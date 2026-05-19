[comment]: <> (SPDX-License-Identifier: AGPL-3.0)

[comment]: <> (-------------------------------------------------------------)
[comment]: <> (Copyright © 2024, 2025  Pellegrino Prevete)
[comment]: <> (All rights reserved)
[comment]: <> (-------------------------------------------------------------)

[comment]: <> (This program is free software: you can redistribute)
[comment]: <> (it and/or modify it under the terms of the GNU Affero)
[comment]: <> (General Public License as published by the Free)
[comment]: <> (Software Foundation, either version 3 of the License.)

[comment]: <> (This program is distributed in the hope that it will be useful,)
[comment]: <> (but WITHOUT ANY WARRANTY; without even the implied warranty of)
[comment]: <> (MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the)
[comment]: <> (GNU Affero General Public License for more details.)

[comment]: <> (You should have received a copy of the GNU Affero General Public)
[comment]: <> (License along with this program.)
[comment]: <> (If not, see <https://www.gnu.org/licenses/>.)

# Crash JavaScript

A collection of JavaScript utility functions.

The Crash Javascript library allows to write Javascript
applications written the same as Bash programs
written using the
[Crash Bash](
  https://github.com/themartiancompany/crash-bash)
library which work both in a Node.js as well as a browser
environment without any code changes.

To implement file system functions
the library depends on the `node:fs`
module
[`tmcfs`](
  https://github.com/themartiancompany/tmcfs)
override.

Some GNU coreutils utilities like the `split` function
are provided by
[`tmcsplit`](
  https://github.com/themartiancompany/tmcsplit).

This library is being used by most of
Human Instrumentality Project (HIP)
JavaScript programs.

## Installation

The library in this source repo
can be installed from source using GNU Make.

```bash
make \
  install
```

or from the
[NPM Registry](
  https://www.npmjs.com/package/crash-js)

```bash
npm \
  install \
    "crash-js"
```

Upon installation a pre-built browser-compatible
single file webpack one can simply open
from a browser can be found in
`dist/crash-js.js` in the
Node.js module directory.

The library is officially published on the
the uncensorable
[Ur](
  https://github.com/themartiancompany/ur)
user repository and application store as
`libcrash-js`.
The source code is published on the
[Ethereum Virtual Machine File System](
  https://github.com/themartiancompany/evmfs)
so it can't possibly be taken down.

To install it from there just type

```bash
ur \
  libcrash-js
```

A censorable HTTP Github mirror of the recipe published there
is hosted on
[libcrash-js-ur](
  https://github.com/themartiancompany/libcrash-js-ur).
Be aware it could go offline any time.

## Documentation

The manual can be accessed with

```bash
man \
  libcrash-js
```

An example program using both this library and the
[Crash Bash](
  https://github.com/themartiancompany/crash-bash)
library,
[ahsi](
  https://github.com/themartiancompany/ahsi),
is been made available as a submodule in the
`examples` directory.

## Contributing

Bugs can be reported on the
[issues tracker](
  https://github.com/themartiancompany/crash-js/issues)
of
[Gur](
  https://github.com/themartiancompany/gur)
source repository
[mirror](
  https://github.com/themartiancompany/crash-js)
for the software now.

The library uses ESLint to build so all
merge requests are of course required
to pass the test.

Contributing to the software may be eligible
to a free purchase of the corresponding
[Ur](
  https://github.com/themartiancompany/ur)
for the package by
[The Martian Company](
  https://github.com/themartiancompany).

## License

Crash JavaScript is released by Pellegrino Prevete
under the terms of the GNU Affero General Public License version 3.
