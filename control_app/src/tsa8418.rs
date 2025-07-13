use super::*;

use embedded_hal::i2c::I2c;

pub const TSA8418_ADDR: u8 = 0x34;
pub const REG_KP_GPIO1: u8 = 0x1D;
pub const REG_KP_GPIO2: u8 = 0x1E;
pub const REG_KEY_EVENT_A: u8 = 0x04;
pub const REG_KEY_LCK_EC: u8 = 0x03;

pub struct TSA8418<I2C> {
    i2c: I2C,
    address: u8,
}

impl<I2C: I2c> TSA8418<I2C> {
    pub fn new(i2c: I2C, address: u8) -> Self {
        Self { i2c, address }
    }

    pub fn init(&mut self) -> Result<(), I2C::Error> {
        // размер клавиатуры 3х4 кнопок
        // по умолчанию во всех регистрах после сброса 0
        // устанавливаем биты строк и колонок
        // 4 строки
        self.write_reg(REG_KP_GPIO1, 0b1111)?;
        // 3 колонки
        self.write_reg(REG_KP_GPIO2, 0b111)?;

        if self.available()? > 0 {
            while self.get_event()? != 0 {} 
        }

        Ok(())
    }

    pub fn available(&mut self) -> Result<u8, I2C::Error> {
        let content = self.read_reg(REG_KEY_LCK_EC)?;
        //  lower 4 bits only
        Ok(content & 0x0F)
    }

    /*
     *     key event 0x00        no event
     *               0x01..0x50  key  press
     *               0x81..0xD0  key  release
     *               0x5B..0x72  GPIO press
     *               0xDB..0xF2  GPIO release
     */
    pub fn get_event(&mut self) -> Result<u8, I2C::Error> {
        self.read_reg(REG_KEY_EVENT_A)
    }

    fn read_reg(&mut self, register_idx: u8) -> Result<u8, I2C::Error> {
        let mut register_buf = [0u8; 1];
        self.i2c
            .write_read(self.address, &[register_idx], &mut register_buf)?;
        Ok(register_buf[0])
    }

    fn write_reg(&mut self, reg_addr: u8, value: u8) -> Result<(), I2C::Error> {
        let reg_buf = [reg_addr, value];
        self.i2c.write(self.address, &reg_buf)
    }
}
