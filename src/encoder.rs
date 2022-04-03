use {
    crate::*,
};

pub struct Encoder {
    pub width: usize,
    pub height: usize,
    images: Vec<Image>,  // most recent frames
}

impl Encoder {

    pub fn new(width: usize,height: usize) -> Encoder {
        Encoder {
            width: width,
            height: height,
            images: Vec::new(),
        }
    }

    pub fn encode(&mut self,image: &Image) -> Vec<u8> {
        // TODO: encode frame
        Vec::new()
    }
}
