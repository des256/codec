use {
    crate::*,
    std::{
        ffi::*,
        boxed::*,
    },
};

#[no_mangle]
pub extern fn create_encoder() -> *mut c_void {
    let boxed_encoder = Box::new(Encoder::new());
    Box::into_raw(boxed_encoder) as *mut Encoder as *mut c_void
}

#[no_mangle]
pub extern fn destroy_encoder(encoder: *mut c_void) {
    unsafe { Box::from_raw(encoder as *mut Encoder); }
}

#[no_mangle]
pub extern fn encoder_get_image_width(encoder: *mut c_void) -> u32 {
    let encoder = unsafe { Box::from_raw(encoder as *mut Encoder) };
    let width = encoder.image.width;
    Box::leak(encoder);
    width as u32
}

#[no_mangle]
pub extern fn encoder_get_image_height(encoder: *mut c_void) -> u32 {
    let encoder = unsafe { Box::from_raw(encoder as *mut Encoder) };
    let height = encoder.image.height;
    Box::leak(encoder);
    height as u32
}

#[no_mangle]
pub extern fn encoder_get_image_pixels_mut_ref(encoder: *mut c_void) -> *mut u8 {
    let mut encoder = unsafe { Box::from_raw(encoder as *mut Encoder) };
    let pixels_ptr = encoder.image.pixels.as_mut_ptr();
    Box::leak(encoder);
    pixels_ptr as *mut u8
}
