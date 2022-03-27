use {
    crate::*,
    std::{
        rc::Rc,
    },
};

pub struct Encoder {
    pub image: Image,
}

impl Encoder {
    pub fn new() -> Encoder {
        Encoder {
            image: Image::new(320,240),
        }
    }
}