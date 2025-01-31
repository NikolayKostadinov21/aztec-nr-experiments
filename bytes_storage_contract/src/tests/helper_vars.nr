use crate::tests::utils;
use utils::{calculate_feed_index, calculate_round_index};

global TWELVE: Field = 12;
global TWO_POW_128: Field = 340282366920938463463374607431768211456; // 2^128
global TWO_POW_115: Field = 41538374868278621028243970633760768; // 2^115
global TWO_POW_13: Field = 8192; // 2^13
global ZERO: Field = 0;
global ONE: Field = 1;
global TWO: Field = 2;

global zero_feed_ix: Field = ZERO;
global one_feed_ix: Field = ONE;

global stride_0: Field = ZERO;
global stride_12: Field = TWELVE;

global first_feed_ix: Field = calculate_feed_index(zero_feed_ix, zero_round_ix, stride_0);
global second_feed_ix: Field = calculate_feed_index(one_feed_ix, one_round_ix, stride_12);
global zero_round_ix: Field = calculate_round_index(stride_0, zero_feed_ix);
global one_round_ix: Field = calculate_round_index(stride_12, one_feed_ix);

global helper_31_data_feeds_with_len_2: BoundedVec<Field, 189> = BoundedVec::from_array([
    //////////// Feeds
    //////////// feed 1
    // feed_id
    1,
    // feed_len
    TWO,
    // feed_data
    245, 128,
    //////////// feed 2
    //feed_id
    2,
    // feed_len
    TWO,
    // feed_data
    236, 128,
        //////////// feed 3
    //feed_id
    3,
    // feed_len
    TWO,
    // feed_data
    153, 128,
        //////////// feed 4
    //feed_id
    4,
    // feed_len
    TWO,
    // feed_data
    154, 128,
    //////////// feed 5
    //feed_id
    5,
    // feed_len
    TWO,
    // feed_data
    155, 128,
    //////////// feed 6
    //feed_id
    6,
    // feed_len
    TWO,
    // feed_data
    156, 128,
    //////////// feed 7
    //feed_id
    7,
    // feed_len
    TWO,
    // feed_data
    157, 128,
    //////////// feed 8
    //feed_id
    8,
    // feed_len
    TWO,
    // feed_data
    158, 128,
    //////////// feed 9
    //feed_id
    9,
    // feed_len
    TWO,
    // feed_data
    159, 128,
    //////////// feed 10
    //feed_id
    10,
    // feed_len
    TWO,
    // feed_data
    236, 128,
    //////////// Feeds
    //////////// feed 1
    // feed_id
    10,
    // feed_len
    TWO,
    // feed_data
    245, 128,
    //////////// feed 2
    //feed_id
    20,
    // feed_len
    TWO,
    // feed_data
    236, 128,
        //////////// feed 3
    //feed_id
    30,
    // feed_len
    TWO,
    // feed_data
    153, 128,
        //////////// feed 4
    //feed_id
    40,
    // feed_len
    TWO,
    // feed_data
    154, 128,
    //////////// feed 5
    //feed_id
    50,
    // feed_len
    TWO,
    // feed_data
    155, 128,
    //////////// feed 6
    //feed_id
    60,
    // feed_len
    TWO,
    // feed_data
    156, 128,
    //////////// feed 7
    //feed_id
    70,
    // feed_len
    TWO,
    // feed_data
    157, 128,
    //////////// feed 8
    //feed_id
    80,
    // feed_len
    TWO,
    // feed_data
    158, 128,
    //////////// feed 9
    //feed_id
    90,
    // feed_len
    TWO,
    // feed_data
    159, 128,
    //////////// feed 10
    //feed_id
    100,
    // feed_len
    TWO,
    // feed_data
    236, 128,
    //////////////////////////////////// Feeds
    //////////// feed 1
    // feed_id
    100,
    // feed_len
    TWO,
    // feed_data
    245, 128,
    //////////// feed 2
    //feed_id
    200,
    // feed_len
    TWO,
    // feed_data
    236, 128,
        //////////// feed 3
    //feed_id
    300,
    // feed_len
    TWO,
    // feed_data
    153, 128,
        //////////// feed 4
    //feed_id
    400,
    // feed_len
    TWO,
    // feed_data
    154, 128,
    //////////// feed 5
    //feed_id
    500,
    // feed_len
    TWO,
    // feed_data
    155, 128,
    //////////// feed 6
    //feed_id
    600,
    // feed_len
    TWO,
    // feed_data
    156, 128,
    //////////// feed 7
    //feed_id
    700,
    // feed_len
    TWO,
    // feed_data
    157, 128,
    //////////// feed 8
    //feed_id
    800,
    // feed_len
    TWO,
    // feed_data
    158, 128,
    //////////// feed 9
    //feed_id
    900,
    // feed_len
    TWO,
    // feed_data
    159, 128,
    //////////// feed 10
    //feed_id
    1000,
    // feed_len
    TWO,
    // feed_data
    236, 128,
    //////////////////////////////////////////////// feed 60 V
    //feed_id
    1001,
    // feed_len
    ONE,
    // feed_data
    248,
    //////////////////////////////////////////////// feed 63 V
    //feed_id
    1002,
    // feed_len
    ONE,
    // feed_data
    248,
]);

global helper_data_feed_with_len_63: BoundedVec<Field, 189> = BoundedVec::from_array([
    //////////// Feeds
    //////////// feed 0
    // feed_id
    1,
    // feed_len
    63,
    // feed_data
    23,	178, 179, 251, 187,
    126, 243, 154, 29, 39,
    214, 197, 121, 191, 208,
    201, 230, 236, 114, 202,
    19, 119, 79, 15, 237,
    31, 167, 242, 73, 211,
    128, 8, 79, 92, 219,
    181, 159, 22, 208, 172,
    148, 198, 97, 99, 40,
    42, 104, 24, 254, 232,
    57, 188, 133, 175, 95,
    15, 178, 121, 78, 126,
    180, 128, 85,	
]);