# Minimal contract

### 0.74.0 -> 0.76.4

`pub` keyword has to be added so that the `double` function can return successfully.

error: functions that are annotated with #[public] but marked as `unconstrained`, has to have the `unconstrained` keyword removed.

Error:

```
error: Function double is annotated with #[public] but marked as unconstrained, remove unconstrained keyword
┌─ std/panic.nr:2:12
│
2 │ assert(false, message);
│ ----- Assertion failed
│

```
