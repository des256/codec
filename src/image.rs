use {
    crate::*,
};

#[derive(Clone)]
pub struct Image {
    pub width: usize,
    pub height: usize,
    pub pixels: Vec<u32>,
}

impl Image {
    pub fn new(width: usize,height: usize) -> Image {
        let mut image = Image {
            width: width,
            height: height,
            pixels: vec![0; (width * height) as usize],
        };
        for y in 0..height {
            for x in 0..width {
                image.pixels[y * width + x] = if ((y >> 4)&1)^((x >> 4)&1) != 0 { 0xFF002266 } else { 0xFF662200 };
            }
        }
        image
    }
}
