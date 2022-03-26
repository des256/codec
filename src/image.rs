use {
    crate::*,
    std::{
        rc::Rc,
    },
};

struct Image<T> {
    width: usize,height: usize,
    pixels: Vec<T>,
}
