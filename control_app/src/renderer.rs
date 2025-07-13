use embedded_graphics::text::renderer::CharacterStyle;

use super::*;

pub struct LcdView<'a> {
    style_text_white_bg: MonoTextStyle<'a, Rgb565>,
    style_text_green_bg: MonoTextStyle<'a, Rgb565>,
    style_text_red_bg: MonoTextStyle<'a, Rgb565>,
    a_req: u16,
    a_cnf: u16,
    power_state: bool,
    lna144_state: bool,
    lna430_state: bool,
    voltage: u32,
    current: u32,
    az: u16,
    el: u16,
}

impl<'a> LcdView<'a> {
    pub fn new() -> Self {
        let mut st = MonoTextStyle::new(&FONT_10X20, Rgb565::WHITE);
        st.set_background_color(Some(Rgb565::BLACK));
        let mut st1 = MonoTextStyle::new(&FONT_10X20, Rgb565::GREEN);
        st1.set_background_color(Some(Rgb565::BLACK));
        let mut st2 = MonoTextStyle::new(&FONT_10X20, Rgb565::RED);
        st2.set_background_color(Some(Rgb565::BLACK));
        LcdView {
            style_text_white_bg: st,
            style_text_green_bg: st1,
            style_text_red_bg: st2,
            a_req: 42,
            a_cnf: 42,
            power_state: false,
            lna144_state: true,
            lna430_state: true,
            voltage: 42,
            current: 42,
            az: 42,
            el: 42,
        }
    }

    pub fn loading<O1: OutputPin, O2: OutputPin>(
        &mut self,
        lcd: &mut Display<SpiInterface<'_, SpidevDevice, O1>, ST7789, O2>, //lcd: &mut st7789<SPIInterface<SpidevDevice, O1>, O2>,
    ) {
        lcd.clear(Rgb565::BLACK).unwrap();

        Text::with_alignment(
            "R2AJP AntSwitcher",
            Point::new(120, 30),
            MonoTextStyle::new(&FONT_10X20, Rgb565::BLUE),
            Alignment::Center,
        )
        .draw(lcd)
        .unwrap();

        Text::new("Sat AZ:", Point::new(20, 70), self.style_text_white_bg)
            .draw(lcd)
            .unwrap();
        Text::new("Sat EL:", Point::new(20, 90), self.style_text_white_bg)
            .draw(lcd)
            .unwrap();
        Text::new(
            "ANT Requested:",
            Point::new(20, 110),
            self.style_text_white_bg,
        )
        .draw(lcd)
        .unwrap();
        Text::new(
            "ANT Confirmed:",
            Point::new(20, 130),
            self.style_text_white_bg,
        )
        .draw(lcd)
        .unwrap();
        Text::new("Voltage:", Point::new(20, 150), self.style_text_white_bg)
            .draw(lcd)
            .unwrap();
        Text::new("Current:", Point::new(20, 170), self.style_text_white_bg)
            .draw(lcd)
            .unwrap();
        Text::new("Power:", Point::new(20, 190), self.style_text_white_bg)
            .draw(lcd)
            .unwrap();
        Text::new("LNA 144:", Point::new(20, 210), self.style_text_white_bg)
            .draw(lcd)
            .unwrap();
        Text::new("LNA 430:", Point::new(20, 230), self.style_text_white_bg)
            .draw(lcd)
            .unwrap();
        Text::new(
            "ANT Aperture:",
            Point::new(20, 250),
            self.style_text_white_bg,
        )
        .draw(lcd)
        .unwrap();
    }

    pub fn render<O1: OutputPin, O2: OutputPin>(
        &mut self,
        lcd: &mut Display<SpiInterface<'_, SpidevDevice, O1>, ST7789, O2>,
    ) {
        let a_req = ANT_REQUESTED.load(SeqCst);
        let a_cnf = ANT_CONFIRMED.load(SeqCst);
        let power_state = POWER_RELAY_STATE.load(SeqCst);
        let lna144_state = LNA144_RELAY_STATE.load(SeqCst);
        let lna430_state = LNA430_RELAY_STATE.load(SeqCst);
        let voltage = INA226_MV.load(SeqCst);
        let current = INA226_MA.load(SeqCst);
        let az = ANT_AZ_REQUESTED.load(SeqCst);
        let el = ANT_EL_REQUESTED.load(SeqCst);

        if self.az != az {
            let az_str = format!("{:03}", az);
            self.az = az;
            Text::new(&az_str, Point::new(100, 70), self.style_text_green_bg)
                .draw(lcd)
                .unwrap();
        }
        if self.el != el {
            let el_str = format!("{:03}", el);
            self.el = el;
            Text::new(&el_str, Point::new(100, 90), self.style_text_green_bg)
                .draw(lcd)
                .unwrap();
        }
        if self.a_req != a_req {
            let a_req_str = format!("{:01}", a_req);
            self.a_req = a_req;
            Text::new(&a_req_str, Point::new(170, 110), self.style_text_green_bg)
                .draw(lcd)
                .unwrap();
        }
        if self.a_cnf != a_cnf {
            let a_cnf_str = format!("{:01} ", a_cnf);
            self.a_cnf = a_cnf;
            if a_req + 8 == a_cnf {
                Text::new(&a_cnf_str, Point::new(170, 130), self.style_text_green_bg)
                    .draw(lcd)
                    .unwrap();
            } else {
                Text::new(&a_cnf_str, Point::new(170, 130), self.style_text_red_bg)
                    .draw(lcd)
                    .unwrap();
            }
            let aperture_str = match (a_cnf - 8) {
                // здесь написать актуальные углы и номера антенн после измерения на местности
                1 => {
                    format!("<  224 .. 295   >")
                }
                2 => {
                    format!("<0..7,  296..360>")
                }
                3 => {
                    format!("<   8  ..  79   >")
                }
                4 => {
                    format!("<  80  .. 151   >")
                }
                5 => {
                    format!("<  152 .. 223   >")
                }
                6 => {
                    format!("<  360 HIGH EL  >")
                }
                _ => {
                    format!("---- UNKNOWN ----")
                }
            };
            Text::with_alignment(
                &aperture_str,
                Point::new(120, 270),
                self.style_text_green_bg,
                Alignment::Center,
            )
            .draw(lcd)
            .unwrap();
        }
        if self.voltage != voltage {
            let voltage_str = format!("{:05} mV", voltage);
            self.voltage = voltage;
            Text::new(&voltage_str, Point::new(110, 150), self.style_text_green_bg)
                .draw(lcd)
                .unwrap();
        }
        if self.current != current {
            let current_str = format!("{:05} mA", current);
            self.current = current;
            Text::new(&current_str, Point::new(110, 170), self.style_text_green_bg)
                .draw(lcd)
                .unwrap();
        }
        if self.power_state != power_state {
            let power_state_str = if power_state {
                format!("ON ")
            } else {
                format!("OFF")
            };
            self.power_state = power_state;
            if power_state {
                Text::new(
                    &power_state_str,
                    Point::new(90, 190),
                    self.style_text_green_bg,
                )
                .draw(lcd)
                .unwrap();
            } else {
                Text::new(
                    &power_state_str,
                    Point::new(90, 190),
                    self.style_text_red_bg,
                )
                .draw(lcd)
                .unwrap();
            }
        }
        if self.lna144_state != lna144_state {
            let lna144_state_str = if lna144_state {
                format!("ON ")
            } else {
                format!("OFF")
            };
            self.lna144_state = lna144_state;
            Text::new(
                &lna144_state_str,
                Point::new(110, 210),
                self.style_text_green_bg,
            )
            .draw(lcd)
            .unwrap();
        }
        if self.lna430_state != lna430_state {
            let lna430_state_str = if lna430_state {
                format!("ON ")
            } else {
                format!("OFF")
            };
            self.lna430_state = lna430_state;
            Text::new(
                &lna430_state_str,
                Point::new(110, 230),
                self.style_text_green_bg,
            )
            .draw(lcd)
            .unwrap();
        }
    }
}
