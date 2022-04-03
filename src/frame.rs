use {
    crate::*,
};

struct Frame {
    width: usize,
    height: usize,
    y: Vec<u8>,
    cb: Vec<u8>,
    cr: Vec<u8>,
}

impl Frame {
    pub fn from_image(image: Image) -> Frame {
        // TODO: convert image to YUV420
        Frame {
            width: 1,
            height: 1,
            y: Vec::new(),
            cb: Vec::new(),
            cr: Vec::new(),
        }
    }

    fn render(&self) -> Image {
        // TODO: render YUV420 to output image
        Image::new(self.width,self.height)
    }
}
