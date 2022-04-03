use {
    crate::*,
};

pub struct Decoder {
    pub images: Vec<Image>,
}

impl Decoder {
    pub fn new() -> Decoder {
        Decoder {
            images: Vec::new(),
        }
    }

    pub fn decode(&mut self,data: &Vec<u8>) -> Image {
        // TODO: decode frame
        Image::new(320,240)
    }
}
