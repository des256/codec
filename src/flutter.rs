use {
    crate::*,
    std::{
        ffi::*,
        boxed::*,
    },
};

#[no_mangle]
pub extern fn image_new(width: usize,height: usize) -> *mut Image {
    let boxed_image = Box::new(Image::new(width,height));
    Box::into_raw(boxed_image)
}

#[no_mangle]
pub extern fn image_drop(image_ptr: *mut Image) {
    unsafe { Box::from_raw(image_ptr); }
}

#[no_mangle]
pub extern fn encoder_new(width: usize,height: usize) -> *mut Encoder {
    let boxed_encoder = Box::new(Encoder::new(width,height));
    Box::into_raw(boxed_encoder)
}

#[no_mangle]
pub extern fn encoder_drop(encoder: *mut Encoder) {
    unsafe { Box::from_raw(encoder); }
}

#[no_mangle]
pub extern fn encoder_encode(encoder: *mut Encoder,image: *mut Image) -> *const c_void {
    let mut encoder = unsafe { Box::from_raw(encoder) };
    let image = unsafe { Box::from_raw(image) };
    let result = &encoder.encode(&image) as *const Vec<u8>;
    Box::leak(encoder);
    Box::leak(image);
    result as *const c_void
}
