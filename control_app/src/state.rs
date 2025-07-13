use super::*;
use easycom::*;

pub struct RotorState {
    az_angle: AzAngle,
    el_angle: ElAngle,
    pub ant_required: u8,
    pub ant_confirmed: u8,

}

impl RotorState {
    pub fn new() -> Self {
        RotorState {
            az_angle: Default::default(),
            el_angle: Default::default(),       
            ant_required: 1,
            ant_confirmed: 0,
         
        }
    }

    pub fn get_angles(&self) -> (&AzAngle, &ElAngle) {
        (&self.az_angle, &self.el_angle)
    }

    pub fn set_az(&mut self, ang: AzAngle) {
        self.az_angle = ang;
    }

    pub fn set_el(&mut self, ang: ElAngle) {
        self.el_angle = ang;
    }

}


