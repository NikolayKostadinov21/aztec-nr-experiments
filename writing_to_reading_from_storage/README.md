# Writing to/Reading from storage contract

### 0.74.0 -> 0.76.4

`pub` keyword has to be added so that the `double` function can return successfully.

error: functions that are annotated with #[public] but marked as `unconstrained`, has to have the `unconstrained` keyword removed.
