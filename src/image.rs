use {
    crate::*,
};

pub struct Image {
    pub width: usize,
    pub height: usize,
    pub pixels: Vec<u32>,
}

impl Image {
    pub fn new(width: usize,height: usize) -> Image {
        Image {
            width: width,
            height: height,
            pixels: vec![0xFFFF7F3F; width * height],
        }
    }
}
