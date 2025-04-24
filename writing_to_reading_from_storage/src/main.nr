use dep::aztec::macros::aztec;
// mod test;

#[aztec]
pub contract Main {
    use dep::aztec::macros::{functions::{initializer, public, view}, storage::storage};
    // use dep::aztec::oracle::debug_log::debug_log;
    use dep::aztec::prelude::{PublicContext, AztecAddress, Map, PublicImmutable, PublicMutable};
    use aztec::protocol_types::debug_log::debug_log;

    #[storage]
    struct Storage<Context> {
        field_in_map: Map<Field, PublicMutable<Field, Context>, Context>,
        just_field: PublicMutable<Field, Context>,
    }

    #[public]
    #[initializer]
    fn constructor() { // TODO: check if constructor writing has any effect on the gas cost
        storage.field_in_map.at(1).write(1);
        storage.just_field.write(700);
    }


    // TODO: check if useless content affects Gas costs
    #[public]
    fn set_just_field(value: Field) {
        storage.just_field.write(value);
    }

    // unconstrained fn read_just_field_value() -> pub Field {
    //     storage.just_field
    // }

    #[public]
    #[view]
    fn get_just_field() -> Field {
        let y = 20;
        quadruple(storage, y)
    }

    #[public]
    fn set_field_in_map(key: Field, value: Field) {
        storage.field_in_map.at(key).write(value);
    }

    #[public]
    #[view]
    fn read_field_in_map(key: Field) -> Field {
        storage.field_in_map.at(key).read()
    }

    #[contract_library_method]
    fn quadruple(storage: Storage<&mut PublicContext>, x: Field) -> Field {
        let just_one_field = storage.just_field.read();
        (5 * 20) * just_one_field
    }
}
