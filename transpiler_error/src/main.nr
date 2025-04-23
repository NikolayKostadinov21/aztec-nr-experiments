use dep::aztec::macros::aztec;

pub contract Main {
    // use dep::aztec::macros::{functions::{initializer, public, view, utility}, storage::storage};
    // // use dep::aztec::oracle::debug_log::debug_log;
    // use dep::aztec::prelude::{AztecAddress, Map, PublicImmutable, PublicMutable};
    use aztec::protocol_types::debug_log::debug_log;

        use std::{meta::derive, ops::{Add, Sub}};

    // use dep::compressed_string::FieldCompressedString;

    use dep::aztec::{
        context::{PrivateCallInterface, PrivateContext},
        event::event_interface::EventInterface,
        macros::{
            events::event,
            functions::{initializer, internal, private, public, utility, view},
            storage::storage,
        },
        prelude::{AztecAddress, Map, PublicContext, PublicImmutable, PublicMutable},
        protocol_types::traits::Serialize,
    };

    // use dep::uint_note::uint_note::{PartialUintNote, UintNote};
    // use aztec::protocol_types::traits::ToField;

    // use dep::authwit::auth::{
    //     assert_current_call_valid_authwit, assert_current_call_valid_authwit_public,
    //     compute_authwit_nullifier,
    // };

    #[storage]
    struct Storage<Context> {
        field_in_map: Map<Field, PublicMutable<Field, Context>, Context>,
        just_field: PublicMutable<Field, Context>,
    }

    fn double(x: Field) -> pub Field { x * 2 }

    #[utility]
    unconstrained fn triple(x: Field) -> Field { 
        let x = x + storage.just_field.read();
        x * 3
    }

    #[contract_library_method]
    fn quadruple(x: Field) -> Field { storage.just_field.read() }
}
