mod easycom;
mod renderer;

mod ina226;
mod tsa8418;

use clap::{arg, value_parser, ArgAction, Command};
use std::sync::atomic::{AtomicU16, AtomicU32, AtomicU64, Ordering::SeqCst};
use std::sync::{Condvar, WaitTimeoutResult};
use std::time::Duration;
use std::{
    any::TypeId,
    process,
    sync::{
        atomic::{AtomicBool, Ordering},
        Arc, Mutex,
    },
    thread, time,
};

use embedded_hal::delay::DelayNs;
use embedded_hal::digital::{ErrorType, OutputPin, PinState, StatefulOutputPin};
use embedded_hal::i2c::I2c;
//use linux_embedded_hal::{ Delay };
use display_interface_spi::SPIInterface;
use embedded_graphics::{
    image::Image,
    mono_font::{ascii::FONT_10X20, ascii::FONT_6X10, MonoTextStyle},
    pixelcolor::Rgb565,
    prelude::*,
    primitives::{PrimitiveStyle, PrimitiveStyleBuilder, Rectangle},
    text::{Alignment, Text},
};
use embedded_hal_bus::i2c::AtomicDevice;
use embedded_hal_bus::spi::{ExclusiveDevice, NoDelay};
use embedded_hal_bus::util::AtomicCell;
//use st7789::{Orientation, ST7789};
use linux_embedded_hal::spidev::{SpiModeFlags, Spidev, SpidevOptions, SpidevTransfer};
use linux_embedded_hal::{I2cdev, SpidevDevice};
use mipidsi::interface::SpiInterface;
use mipidsi::{models::ST7789, options::ColorInversion, Builder, Display};

use serialport::{available_ports, SerialPortType};
use std::io::{self, BufRead, BufReader, Write};

use crate::easycom::*;
use crate::ina226::*;
use crate::renderer::*;
use crate::tsa8418::*;

// переменные состояния для обмена между потоками данными

static POWER_RELAY_STATE: AtomicBool = AtomicBool::new(true);
static LNA144_RELAY_STATE: AtomicBool = AtomicBool::new(false);
static LNA430_RELAY_STATE: AtomicBool = AtomicBool::new(false);
static INA226_MV: AtomicU32 = AtomicU32::new(0);
static INA226_MA: AtomicU32 = AtomicU32::new(0);
static ANT_REQUESTED: AtomicU16 = AtomicU16::new(1);
static ANT_CONFIRMED: AtomicU16 = AtomicU16::new(0);
static ANT_AZ_REQUESTED: AtomicU16 = AtomicU16::new(0);
static ANT_EL_REQUESTED: AtomicU16 = AtomicU16::new(0);

fn main() {
    let args = Command::new("libremon")
        .version(clap::crate_version!())
        .about("Antenna switcher. (C) R2AJP")
        .disable_help_flag(true)
        .disable_version_flag(true)
        .args(&[
            arg!(-t --iotest "IO test").action(ArgAction::SetTrue),
            arg!(-'v' --version "Print version information").action(ArgAction::Version),
            arg!(-'?' --help "Print help information")
                .global(true)
                .action(ArgAction::Help),
        ])
        .get_matches();

    // true - do some tests?
    let some_test: bool = *args.get_one("iotest").unwrap();
    //print!("iotest: {some_test}");

    // ---- Handle ^C since we want a graceful shutdown -----
    let quit = Arc::new(AtomicBool::new(false));
    let q = quit.clone();

    ctrlc::set_handler(move || {
        q.store(true, Ordering::SeqCst);
    })
    .expect("Error setting Ctrl-C handler");

    // Объекты синхронизации для печати
    let signal2redraw = Arc::new((Mutex::new(false), Condvar::new()));
    let signal2redraw_renderer = signal2redraw.clone();
    let signal2redraw_dtmf = signal2redraw.clone();
    let signal2redraw_kbd = signal2redraw.clone();
    let signal2redraw_usb = signal2redraw.clone();

    // создаем поток печати на экран
    thread::spawn(move || {
        // настройки дисплея
        let mut buffer = [0u8; 512];
        let mut lcd = {
            // настройки пинов для дисплея
            let mut delay = linux_embedded_hal::Delay;
            //delay.delay_ms(100u32);

            let mut spi = SpidevDevice::open("/dev/spidev0.0").unwrap_or_else(|_err| {
                println!("Couldn't open spi /dev/spidev0.0");
                process::exit(1);
            });

            let options = SpidevOptions::new()
                .bits_per_word(8)
                .max_speed_hz(2_000_000)
                .mode(SpiModeFlags::SPI_MODE_3)
                .build();

            spi.configure(&options).unwrap_or_else(|_err| {
                println!("Couldn't configure spi.");
                process::exit(1);
            });

            /*
            // cs - fake 15 led - по факту пином CS управляет линукс
            let mut led15 = gpiocdev_embedded_hal::OutputPin
                ::new("/dev/gpiochip0", 15, PinState::Low)
                .unwrap_or_else(|_err| {
                    println!("Couldn't open pin15.");
                    process::exit(1);
                });
            */

            // dc
            let pin_dc = gpiocdev_embedded_hal::OutputPin::new("/dev/gpiochip0", 55, PinState::Low)
                .unwrap_or_else(|_err| {
                    println!("Couldn't open pin55.");
                    process::exit(1);
                });
            // reset
            let pin_reset =
                gpiocdev_embedded_hal::OutputPin::new("/dev/gpiochip0", 54, PinState::Low)
                    .unwrap_or_else(|_err| {
                        println!("Couldn't open pin54.");
                        process::exit(1);
                    });
            //let spi_iface = SPIInterface::new(spi, pin_dc);
            let di = SpiInterface::new(spi, pin_dc, &mut buffer);

            Builder::new(ST7789, di)
                .display_size(240, 320)
                //.display_offset(0, 0)
                //.invert_colors(ColorInversion::Inverted)
                .reset_pin(pin_reset)
                .init(&mut delay)
                .unwrap()
        };

        let mut my_view = LcdView::new();
        my_view.loading(&mut lcd);

        let (lock, cvar) = &*signal2redraw_renderer;
        loop {
            // ждем, что кто-то выставит redraw true
            {
                let mut redraw = lock.lock().unwrap();
                while !*redraw {
                    let result = cvar.wait_timeout(redraw, Duration::from_secs(3)).unwrap();
                    redraw = result.0;
                    if result.1.timed_out() {
                        println!("Timeout redraw");
                        break;
                    }
                }
                *redraw = false;
            }
            // делаем что-то с уже освобожденным локом
            my_view.render(&mut lcd);
        }
    });

    // Объекты синхронизации для пищалки и для клавиатуры
    let signal2beep = Arc::new((Mutex::new(false), Condvar::new()));
    let signal2beep_kbd = signal2beep.clone();
    // создаем поток бипера
    thread::spawn(move || {
        let mut pin_beep =
            gpiocdev_embedded_hal::OutputPin::new("/dev/gpiochip0", 56, PinState::Low)
                .unwrap_or_else(|_err| {
                    println!("Couldn't open pin56.");
                    process::exit(1);
                });
        let (lock, cvar) = &*signal2beep;
        loop {
            // ждем, что кто-то выставит beep true
            {
                let mut beep = lock.lock().unwrap();
                while !*beep {
                    let result = cvar.wait(beep).unwrap();
                    beep = result;
                }
                *beep = false;
            }
            // делаем что-то с уже освобожденным локом
            pin_beep.toggle().ok();
            thread::sleep(time::Duration::from_millis(10));
            pin_beep.toggle().ok();
        }
    });

    // Объекты синхронизации для управления реле
    let signal2relay = Arc::new((Mutex::new(false), Condvar::new()));
    let signal2relay_kbd = signal2relay.clone();
    let signal2relay_init = signal2relay.clone();
    // создаем поток управления реле
    thread::spawn(move || {
        let mut pin_power =
            gpiocdev_embedded_hal::OutputPin::new("/dev/gpiochip0", 58, PinState::Low)
                .unwrap_or_else(|_err| {
                    println!("Couldn't open pin58.");
                    process::exit(1);
                });
        let mut pin_lna430 =
            gpiocdev_embedded_hal::OutputPin::new("/dev/gpiochip0", 59, PinState::Low)
                .unwrap_or_else(|_err| {
                    println!("Couldn't open pin59.");
                    process::exit(1);
                });
        let mut pin_lna144 =
            gpiocdev_embedded_hal::OutputPin::new("/dev/gpiochip0", 60, PinState::Low)
                .unwrap_or_else(|_err| {
                    println!("Couldn't open pin60.");
                    process::exit(1);
                });
        let (lock, cvar) = &*signal2relay;
        loop {
            // ждем, что клавиатура выставит сигнал в true
            {
                let mut relay_signal = lock.lock().unwrap();
                while !*relay_signal {
                    let result = cvar.wait(relay_signal).unwrap();
                    relay_signal = result;
                }
                *relay_signal = false;
            }
            // делаем что-то с уже освобожденным локом
            let relay_lna144_state = LNA144_RELAY_STATE.load(SeqCst);
            if relay_lna144_state {
                pin_lna144.set_high().ok();
            } else {
                pin_lna144.set_low().ok();
            }

            let relay_lna430_state = LNA430_RELAY_STATE.load(SeqCst);
            if relay_lna430_state {
                pin_lna430.set_high().ok();
            } else {
                pin_lna430.set_low().ok();
            }

            let relay_power_state = POWER_RELAY_STATE.load(SeqCst);
            if relay_power_state {
                pin_power.set_high().ok();
            } else {
                pin_power.set_low().ok();
            }
        }
    });

    // взываем к включению реле
    {
        let (lock_relay, cvar_relay) = &*signal2relay_init;
        let mut r = lock_relay.lock().unwrap();
        *r = true;
        cvar_relay.notify_one();
    } // освобождаем лок

    // Объекты синхронизации для управления RF реле
    let signal2dtmf = Arc::new((Mutex::new(false), Condvar::new()));
    let signal2dtmf_kbd = signal2dtmf.clone();
    let signal2dtmf_usb = signal2dtmf.clone();
    let signal2dtmf_init = signal2dtmf.clone();
    // создаем поток управления RF реле
    thread::spawn(move || {
        const ADDR_PCF1: u8 = 0x20; // addr output DTMF
        const ADDR_PCF2: u8 = 0x21; // addr input DTMF
        const STD_PIN: u8 = 0b0010000; // STD
        let mut read_dtmf_buffer: [u8; 1] = [0];

        // шина для DTMF
        let i2cdev2 = I2cdev::new("/dev/i2c-1").unwrap_or_else(|_err| {
            println!("Couldn't open i2c-1");
            process::exit(1);
        });
        let i2c_cell2 = AtomicCell::new(i2cdev2);
        let mut i2c_snd = AtomicDevice::new(&i2c_cell2);
        let mut i2c_rcv = AtomicDevice::new(&i2c_cell2);

        i2c_rcv
            .write(ADDR_PCF2, &[0b00001111])
            .unwrap_or_else(|_err| {
                println!("Couldn't write initial read state to rcv pcf.");
                process::exit(1);
            });

        let mut pin_amp_disable =
            gpiocdev_embedded_hal::OutputPin::new("/dev/gpiochip0", 57, PinState::High)
                .unwrap_or_else(|_err| {
                    println!("Couldn't open pin57.");
                    process::exit(1);
                });

        let (lock, cvar) = &*signal2dtmf;
        loop {
            // ждем, что кто-то выставит сигнал в true
            {
                let mut relay_signal = lock.lock().unwrap();
                while !*relay_signal {
                    let result = cvar.wait(relay_signal).unwrap();
                    relay_signal = result;
                }
                *relay_signal = false;
            }
            // делаем что-то с уже освобожденным локом
            let ant: u8 = ANT_REQUESTED.load(SeqCst).try_into().unwrap();
            // антенны у нас с номерами от 1 до 6
            if ant < 1 || ant > 6 {
                continue;
            }
            // ЦИКЛ ПЕРЕДАЧИ
            // включаем усилитель
            pin_amp_disable.set_low().ok();
            thread::sleep(time::Duration::from_millis(400));

            let cmd = ant + STD_PIN;
            // передаем номер антенны и строб
            i2c_snd.write(ADDR_PCF1, &[cmd]).unwrap_or_else(|_err| {
                println!("Couldn't write send dtmf cmd to pcf.");
                process::exit(1);
            });
            // время активности строба должно быть больше 300 мс
            thread::sleep(time::Duration::from_millis(350));
            // снимаем строб
            let cmd = ant;
            i2c_snd.write(ADDR_PCF1, &[cmd]).unwrap_or_else(|_err| {
                println!("Couldn't write send dtmf no STD cmd to pcf.");
                process::exit(1);
            });
            // время неактивности строба должно быть больше 200 мс
            thread::sleep(time::Duration::from_millis(250));
            // выключаем усилитель
            pin_amp_disable.set_high().ok();
            //thread::sleep(time::Duration::from_millis(100));

            println!("DTMF request for ant {} sent.", ant);

            // ЦИКЛ ПРИЁМА
            // ожидаем приёма кода
            thread::sleep(time::Duration::from_millis(900));
            i2c_rcv
                .read(ADDR_PCF2, &mut read_dtmf_buffer)
                .unwrap_or_else(|_err| {
                    println!("Couldn't read rcvd DTMF from pcf.");
                    process::exit(1);
                });
            let cfm_code = read_dtmf_buffer[0];
            println!("DTMF cfm rcvd: {}", cfm_code);
            // тут нужен маппинг принятых кодов и запись
            ANT_CONFIRMED.store(cfm_code.into(), SeqCst);
            // взываем к перерисовке экрана
            {
                let (lock, cvar) = &*signal2redraw_dtmf;
                let mut r = lock.lock().unwrap();
                *r = true;
                cvar.notify_one();
            } // освобождаем лок
        }
    });

    // взываем к DTMF включению RF реле 1
    {
        let (lock_relay, cvar_relay) = &*signal2dtmf_init;
        let mut r = lock_relay.lock().unwrap();
        *r = true;
        cvar_relay.notify_one();
    } // освобождаем лок

    // создаем поток чтения клавиатуры
    thread::spawn(move || {
        // шина для измерителя тока и клавы
        let i2cdev = I2cdev::new("/dev/i2c-0").unwrap_or_else(|_err| {
            println!("Couldn't open i2c");
            process::exit(1);
        });
        let i2c_cell = AtomicCell::new(i2cdev);

        let mut kbd = TSA8418::new(AtomicDevice::new(&i2c_cell), TSA8418_ADDR);
        kbd.init().unwrap_or_else(|_err| {
            println!("Couldn't configure KBD");
            process::exit(1);
        });

        // измеритель тока и напряжения
        let mut ina226 = INA226::new(AtomicDevice::new(&i2c_cell), 0b1000000);
        // калибровка - шунт 50 мОм, максимальный ток ждём максимум 3 А
        ina226.callibrate(0.05, 2.0).unwrap_or_else(|_err| {
            println!("Couldn't calibrate IN226");
            process::exit(1);
        });

        let voltage = ina226.bus_voltage_millivolts().unwrap_or_else(|_err| {
            println!("Couldn't read V IN226");
            process::exit(1);
        });
        println!("Bus voltage from INA226: {} mV", voltage);

        let current_value = if let Ok(x) = ina226.current_amps() {
            if let Some(cur) = x {
                cur
            } else {
                9.0
            }
        } else {
            println!("Couldn't read IN226 A");
            process::exit(1);
        };
        println!("Bus current from INA226: {} A", current_value);

        let (lock_beep, cvar_beep) = &*signal2beep_kbd;
        loop {
            // опрос в бесконечном цикле
            thread::sleep(time::Duration::from_millis(10));

            // всегда обновляем значения тока и напряжения
            let voltage = ina226.bus_voltage_millivolts().unwrap_or_else(|_err| {
                println!("Couldn't read V IN226");
                process::exit(1);
            });
            let current = if let Ok(x) = ina226.current_amps() {
                if let Some(cur) = x {
                    cur
                } else {
                    9.0
                }
            } else {
                println!("Couldn't read IN226 A");
                process::exit(1);
            };
            let current_ma = current * 1000.0;
            let mut int_voltage = voltage.round().abs() as i64;
            let mut int_current_ma = current_ma.round().abs() as i64;
            if int_voltage > 15000 {
                int_voltage = 15000;
            }
            if int_current_ma > 10000 {
                int_current_ma = 10000;
            }
            let int32_mv = u32::try_from(int_voltage).unwrap();
            let int32_ma = u32::try_from(int_current_ma).unwrap();
            // сохраняем значения для других потоков
            INA226_MV.store(int32_mv, SeqCst);
            INA226_MA.store(int32_ma, SeqCst);

            // получаем число событий в очереди клавиатуры
            let ecount = kbd.available().unwrap_or_else(|_err| {
                println!("Couldn't read kbd available");
                process::exit(1);
            });
            //println!("events = {}", ecount);
            if ecount > 0 {
                let event = kbd.get_event().unwrap_or_else(|_err| {
                    println!("Couldn't read kbd event");
                    process::exit(1);
                });
                if (event & 0x80) > 0 {
                    // событие нажатия на клавишу не отрабатываем
                    //print!("Press: ");
                } else {
                    // взываем к биперу
                    {
                        let mut beep = lock_beep.lock().unwrap();
                        *beep = true;
                        cvar_beep.notify_one();
                    } // освобождаем лок
                      //print!("Release: ");
                      // реагируем на отпускание кнопки и сохраняем её код
                    let key = (event & 0x7F) - 1;
                    println!("key: {}", key);

                    // обрабатываем клавиши реле
                    if key > 19 && key < 23 {
                        match key {
                            // button 7
                            20 => {
                                let relay_power_state = POWER_RELAY_STATE.load(SeqCst);
                                if relay_power_state {
                                    POWER_RELAY_STATE.store(false, SeqCst);
                                } else {
                                    POWER_RELAY_STATE.store(true, SeqCst);
                                }
                            }
                            // button 8
                            21 => {
                                let relay_lna144_state = LNA144_RELAY_STATE.load(SeqCst);
                                if relay_lna144_state {
                                    LNA144_RELAY_STATE.store(false, SeqCst);
                                } else {
                                    LNA144_RELAY_STATE.store(true, SeqCst);
                                }
                            }
                            // button 9
                            22 => {
                                let relay_lna430_state = LNA430_RELAY_STATE.load(SeqCst);
                                if relay_lna430_state {
                                    LNA430_RELAY_STATE.store(false, SeqCst);
                                } else {
                                    LNA430_RELAY_STATE.store(true, SeqCst);
                                }
                            }
                            _ => {}
                        }
                        // взываем к включению реле
                        {
                            let (lock_relay, cvar_relay) = &*signal2relay_kbd;
                            let mut r = lock_relay.lock().unwrap();
                            *r = true;
                            cvar_relay.notify_one();
                        } // освобождаем лок
                    }

                    // обрабатываем клавиши антенн
                    if key < 13 {
                        match key {
                            // antenna 1, button 1
                            0 => {
                                ANT_REQUESTED.store(1, SeqCst);
                            }
                            // antenna 2, button 2
                            1 => {
                                ANT_REQUESTED.store(2, SeqCst);
                            }
                            // antenna 3, button 3
                            2 => {
                                ANT_REQUESTED.store(3, SeqCst);
                            }
                            // antenna 4, button 4
                            10 => {
                                ANT_REQUESTED.store(4, SeqCst);
                            }
                            // antenna 5, button 5
                            11 => {
                                ANT_REQUESTED.store(5, SeqCst);
                            }
                            // antenna 6, button 6
                            12 => {
                                ANT_REQUESTED.store(6, SeqCst);
                            }
                            _ => {}
                        }
                        // взываем к DTMF включению RF реле
                        {
                            let (lock_relay, cvar_relay) = &*signal2dtmf_kbd;
                            let mut r = lock_relay.lock().unwrap();
                            *r = true;
                            cvar_relay.notify_one();
                        } // освобождаем лок
                    }
                    //println!("R: {} C: {}", key / 10, key % 10);
                    // взываем к перерисовке экрана
                    {
                        let (lock, cvar) = &*signal2redraw_kbd;
                        let mut r = lock.lock().unwrap();
                        *r = true;
                        cvar.notify_one();
                    } // освобождаем лок
                }
            }
        }
    });

    // создаем поток чтения из UART протокола EASYCOM
    thread::spawn(move || {
        let (lock, cvar) = &*signal2redraw_usb;
        // Настройка UART
        let mut uart_port = serialport::new("/dev/ttyUL0", 9600)
            .timeout(Duration::from_millis(20))
            .open()
            .unwrap_or_else(|_err| {
                println!("Failed to open UART.");
                process::exit(1);
            });

        const RCV_BUF_LEN: usize = 128;
        let mut rcv_buf: Vec<u8> = [0; RCV_BUF_LEN].to_vec();
        let mut rcv_count_raw: usize = 0;

        const ERR_ANS: &[u8] = b"?\n";
        loop {
            rcv_buf.clear();
            rcv_count_raw = 0;
            loop {
                let mut read_buf: [u8; 1] = [0; 1]; // Читаем по одному символу
                let res = uart_port.read(&mut read_buf);
                match res {
                    Err(ref e) if e.kind() == io::ErrorKind::TimedOut => {
                        // закончили приём команды по таймауту
                        break;
                    }
                    Err(e) => {
                        println!("Error reading UART {:?}", e)
                    }
                    Ok(x) => {
                        // начали принимать символы команды, окончание приёма по таймауту 20 мс после последнего символа
                        //rx_timeout = RX_TO;
                        // защита от переполнения буфера
                        if x > 0 && rcv_buf.len() < RCV_BUF_LEN {
                            rcv_buf.push(read_buf[0]);
                        } else {
                            // закончили приём команды по переполнению буфера
                            break;
                        }
                    }
                }
            }
            rcv_count_raw = rcv_buf.len();

            // Convert command to upper case
            if rcv_count_raw != 0 {
                for c in rcv_buf[0..rcv_count_raw].iter_mut() {
                    if 0x61 <= *c && *c <= 0x7a {
                        *c &= !0x20;
                    }
                }
            }
            // strange short input?
            if rcv_count_raw == 1 {
                uart_port.write_all(ERR_ANS).ok();
            }
            // at least 1 command supposed to be in buffer
            if rcv_count_raw > 1 {
                let fullslice = &rcv_buf[0..rcv_count_raw]; // make slice from actual number of chars in buffer - expect one or more commands there
                                                            // make iterator of commands - may produce empty subslices
                                                            // chars splitters are ASCII CR, LF, SPACE
                let slice_iter = fullslice.split(|num| num == &10 || num == &13 || num == &32);
                for supposed_command in slice_iter {
                    // command string must be at least 2 chars
                    if supposed_command.len() < 2 {
                        continue;
                    }
                    let rcv_count = supposed_command.len();

                    // protocol has 2 letter commands
                    let possible_command = EasycomCommands::try_from(&supposed_command[0..2]);
                    match possible_command {
                        Ok(cmd) => {
                            match cmd {
                                EasycomCommands::VE => {
                                    uart_port.write_all(EASYCOM_PROTOCOL_VERSION).ok();
                                    println!("VE");
                                }
                                EasycomCommands::AZ => {
                                    match rcv_count {
                                        // simple query of angle
                                        2 => {
                                            let azf: f32 =
                                                ANT_AZ_REQUESTED.load(Ordering::SeqCst).into();
                                            let mut line: Vec<u8> = Vec::new();
                                            core::write!(line, "+{0:.1}\n", azf).unwrap();
                                            //write!(line, "+181.1 56.7\n").unwrap();
                                            uart_port.write_all(line.as_slice()).ok();
                                            println!("AZ?");
                                        } // angle format is X.X, XX.X, XXX.X
                                        5..=7 => {
                                            let azp: AzAngle = Default::default();
                                            match azp.from_degrees(&supposed_command[2..rcv_count])
                                            {
                                                Ok(ang) => {
                                                    let a_f32: f32 = (&ang).into();
                                                    let a_i64 = a_f32.round().abs() as i64;
                                                    let a2store: u16 =
                                                        u16::try_from(a_i64).unwrap();
                                                    ANT_AZ_REQUESTED
                                                        .store(a2store, Ordering::SeqCst);
                                                    println!("AZ set");
                                                }
                                                Err(_) => {
                                                    uart_port.write_all(ERR_ANS).ok();
                                                    println!("AZ error");
                                                }
                                            }
                                        }
                                        _ => {
                                            // requested angle not identified
                                            uart_port.write_all(ERR_ANS).ok();
                                        }
                                    }
                                }
                                EasycomCommands::EL => {
                                    match rcv_count {
                                        // simple query of angle
                                        2 => {
                                            //let elf: f32 = el.into();
                                            let elf: f32 =
                                                ANT_EL_REQUESTED.load(Ordering::SeqCst).into();
                                            let mut line: Vec<u8> = Vec::new();
                                            core::write!(line, "+{0:.1}\n", elf).unwrap();
                                            uart_port.write_all(line.as_slice()).ok();
                                            println!("EL?");
                                        } // angle format is X.X, XX.X, XXX.X
                                        5..=7 => {
                                            let elp: ElAngle = Default::default();
                                            match elp.from_degrees(&supposed_command[2..rcv_count])
                                            {
                                                Ok(ang) => {
                                                    let a_f32: f32 = (&ang).into();
                                                    let a_i64 = a_f32.round().abs() as i64;
                                                    let a2store: u16 =
                                                        u16::try_from(a_i64).unwrap();
                                                    ANT_EL_REQUESTED
                                                        .store(a2store, Ordering::SeqCst);
                                                    println!("EL set");
                                                }
                                                Err(_) => {
                                                    uart_port.write_all(ERR_ANS).ok();
                                                    println!("EL error");
                                                }
                                            }
                                        }
                                        _ => {
                                            // requested angle not identified
                                            uart_port.write_all(ERR_ANS).ok();
                                        }
                                    }
                                }
                            }
                        }
                        // 2 letter command not identified or supported
                        Err(_) => {
                            uart_port.write_all(ERR_ANS).ok();
                            println!("CMD error");
                        }
                    }

                    // устанавливаем новый номер антенны по результатам обработки команды
                    let azi = ANT_AZ_REQUESTED.load(Ordering::SeqCst);
                    let eli = ANT_EL_REQUESTED.load(Ordering::SeqCst);
                    let ant_old = ANT_REQUESTED.load(Ordering::SeqCst);

                    let mut ant = 1u16;
                    match eli {
                        // high elevation - switch all az to 6
                        50..=91 => {
                            ant = 6;
                        }
                        // low elevation 
                        // ALL settings here MUST be corrected for actual andennas & relay combinations
                        // there must be inclusive range to form 0..360 aperture
                        _ => match azi {
                            // antenna 1
                            224..296 => {
                                ant = 1;
                            }
                            // antenna 2
                            296..=360 => {
                                ant = 2;
                            }
                            // antenna 2
                            0..8 => {
                                ant = 2;
                            }
                            // antenna 3
                            8..80 => {
                                ant = 3;
                            }
                            // antenna 4 
                            80..152 => {
                                ant = 4;
                            }
                            // antenna 5 
                            152..224 => {
                                ant = 5;
                            }
                            // - old
                            /*
                            // antenna 1
                            0..=80 => {
                                ant = 2;
                            }
                            321..=360 => {
                                ant = 2;
                            }
                            // antenna 2
                            81..=200 => {
                                ant = 3;
                            }
                            // antenna 3
                            201..=320 => {
                                ant = 1;
                            }*/
                            _ => {
                                ant = 6;
                            }
                        },
                    }

                    // если нужно переключиться на другую антенну
                    if ant_old != ant {
                        ANT_REQUESTED.store(ant, SeqCst);
                        // взываем к DTMF включению RF реле
                        {
                            let (lock_relay, cvar_relay) = &*signal2dtmf_usb;
                            let mut r = lock_relay.lock().unwrap();
                            *r = true;
                            cvar_relay.notify_one();
                        } // освобождаем лок
                    }

                    // взываем к перерисовке экрана
                    {
                        let (lock, cvar) = &*signal2redraw_usb;
                        let mut r = lock.lock().unwrap();
                        *r = true;
                        cvar.notify_one();
                    } // освобождаем лок
                }
            }
        }
    });

    // red_led
    let mut red_led = gpiocdev_embedded_hal::OutputPin::new("/dev/gpiochip0", 37, PinState::Low)
        .unwrap_or_else(|_err| {
            println!("Couldn't open pin37.");
            process::exit(1);
        });

    while !quit.load(Ordering::SeqCst) {
        red_led.toggle().ok();
        thread::sleep(time::Duration::from_millis(200));
    }

    println!("All was OK! Bye");
}
