use dep::aztec::macros::aztec;
mod test;

#[aztec]
contract Main {
    use dep::aztec::{macros::{functions::{initializer, public, view, private}}};

    #[public]
    #[initializer]
    fn constructor() {}

    #[public]
    #[view]
    unconstrained fn double(x: Field) -> Field { x * 2 }
    #[public]
    #[view]
    fn doublee(x: Field) -> Field { double(x) }
    unconstrained fn triple(x: Field) -> pub Field { x * 3 }
    fn quadriple(x: Field) -> pub Field { x * 4 }
}