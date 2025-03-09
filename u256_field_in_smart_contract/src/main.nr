contract Main {
    use dep::bignum::u256_for_smart_contracts::BigNum;

    fn double(x: Field) -> pub Field {
        x * 2
    }
    // fn triple(x: Field) -> pub Field {
    //     x * 3
    // }
    // fn quadruple(x: Field) -> pub Field {
    //     double(double(x))
    // }
}
