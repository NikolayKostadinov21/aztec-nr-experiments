# Gas interfaces and classes

Transactions are metered for their gas consumption across two dimensions:

1. **Data Availability (DA) Gas**: This dimension measures data usage by the transaction, e.g. creating/spending notes, emitting logs, etc.
2. **Layer 2 (L2) Gas**: This dimension measures computation usage of the public VM.
   This is similar to the gas model in Ethereum, where transaction consume gas to perform operations, and may also consume blob gas for storing data.

## Interfaces

- **GasPrice**

```
export interface GasPrice {
	maxFeePerGas: bigint; // <== The max amount you are willing to pay for gas
	maxPriorityFeePerGas: bigint; // <== How much you are willing to pay the operator
	maxFeePerBlobGas?: bigint; // <== How much you are willing to pay for Blob data
}
```

the interface is used in L1 utils and helper functions.

- **GasUsed**
  Gas used during the execution of this tx

---

## Classes

- **Gas**
  Gas amounts in each dimension.

```
constructor(public readonly daGas: UInt32, public readonly l2Gas: UInt32) {}
```

- **GasSettings**
  Gas usage and fees limits set by the transaction sender for different dimensions and phases.

```
constructor(
	public readonly gasLimits: Gas,
	public readonly teardownGasLimits: Gas,
	public readonly maxFeesPerGas: GasFees,
	public readonly maxPriorityFeesPerGas: GasFees,
) {}
```

- **GasFees**
  Gas prices for each dimension.

```
public readonly feePerDaGas: Fr;
public readonly feePerL2Gas: Fr;
```

This class aims to define objects containing the global gas prices for each L2 block.

- **GasTxValidator**
  This class is being used for the implementation of each operator(validator) function.

- **GasBridgingTestHarness**
  A Class for testing cross chain interactions, contains common interactions shared between cross chain tests. Since there are no functions closely related to Gas consumption, this function is not of our interest.

---

## Transaction Fee

The transaction fee is calculated as:

```
transactionFee = maxInclusionFee + (DA gas consumed * feePerDaGas) + (L2 gas consumed * feePerL2Gas)
```

Note: every transaction has overhead costs associated with it, e.g. verifying its encompassing rollup proof on L1, which are captured in the `maxInclusionFee`, which is not tied to gas consumption on the transaction, but is specified in FPA.
