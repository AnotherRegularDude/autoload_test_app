# README

## Problem

With Zeitwerk mode and with very special linking between constants, server gets into deadlock.
You might want to look at this `special linking`, then you need to look at three modules
(`FirstModule`, `SecondModule`, `ThirdModule`) and at the `FirstModule::Mixin`,
without which this repository would not exist.

Maybe problem with Ruby's methods `Module::autoload` and `Kernel::autoload`,
which Zeitwerk actively uses `¯\_(ツ)_/¯`.

Also, if we try to access this constants in different Threads,
then script will stuck or will fail with segmentation fault.

## How to Reproduce

I wrote two rake tasks, that crash the world.

```bash
rails test:finish_him # Reproduce problem with deadlock, while autoloading constants
rails test:try_segmentation_fault # Oh my, segmentation fault may appear here or maybe not
```

First rake task executes `rails s` via `Open3.popen2`, and asynchronously requests two actions.
Then, simulates changing in filesystem via touching autoloaded file and makes requests again.
After several such attempts, the server gets into the deadlock.

Second rake task just attempts to access different constants in different threads,
and script freezes, when tries to access the constant, we tried to resolve in thread.
If you change `FirstModule::Mixin` (force filesystem change event on this file)
before hitting/sending ctrl+c (SIGINT) and then terminate stuck script,
it will fail with awesome segmentation fault.
I put stack trace of this sadness to segmentation_fault.log.
