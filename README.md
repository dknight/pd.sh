# 🟨 pd.sh

A simple shell script to make development for [Playdate](https://play.date)
a bit easier from the command line on the Unix-like systems.

This tool is designed for [Playdate](https://play.date/).

[![Playdate](https://raw.githubusercontent.com/dknight/pd.sh/refs/heads/main/Playdate-platform-icon-inverted.svg)](https://play.date/)

## Features

- **Create a new project with interactive prompt**
- **Build a project**
- **Run/Stop Playdate simulator**
- **Wish your function in the [issues](https://github.com/dknight/pd.sh/issues)**
  or [pull request](https://github.com/dknight/pd.sh/pulls).

## Install

Be sure that `PLAYDATE_SDK_PATH` is already set on your system.

Something like this:

```shell
echo $PLAYDATE_SDK_PATH
```
If nothing is printed then set it in yout shell config, e.g. `.bashrc` or
`.zsh` depends on what terminal you use.

Consider

```shell
echo "/path/to/your/PlaydateSDK-2.7.2" > "$HOME/.bashrc"
```

Clone this repo:

```shell
git clone https://github.com/dknight/pd.sh
```

Change directory:

```shell
cd pd.sh
```

Run Makefile:

* Root privileges might be needed with the `sudo` command.

```shell
make install
# or
sudo make install
```

The default installation path is `/usr/local/bin`. Additionally, 
`PREFIX` can be set to change the destination, for example:

```
PREFIX=/var/opt make install
```

Another option, without `make` utility, to copy manually the `pd.sh` file to 
any desired directory in `$PATH` environment variable.

## Usage

General command: `ps.sh [-hd <directory>] command` where, `-d` directory of the
project (current directory) by default; `-h` prints help in the terminal.

### Commands

- **new**: Create a new project with an interactive prompt;
- **run**: build and run a project;
- **build**: build a project;
- **stop**: stop Playdate simulator, if running.
 
#### Creating new project

Create a new project:

```shell
pd.sh new <project_dir>
```

or

```shell
pd.sh -d <project_dir> new
```

Build a project in the current directory:

```shell
pd.sh new .
```

## .luarc.json

The **new** command will also create `.luarc.json` file, which helps use
autocomplete.

```json
{
    "telemetry.enable": false,
    "runtime.version": "Lua 5.4",
    "runtime.special": {
            "import": "require"
    },
    "runtime.nonstandardSymbol": ["+=", "-=", "*=", "/="],
    "diagnostics.globals": [
            "playdate",
            "json"
    ],
    "diagnostics.disable": ["redefined-local"],
    "diagnostics.neededFileStatus": {},
    "diagnostics.libraryFiles": "Disable",
    "completion.callSnippet": "Replace",
    "workspace.library": ["$PLAYDATE_SDK_PATH/CoreLibs"],
    "workspace.ignoreDir": ["Source/external"]
}
```

#### LuaCATS for Panic PlaydateSDK

LuaCATS provides better completeion documentation. If you install
[notpeter/playdate-luacats](https://github.com/notpeter/playdate-luacats) and
set the environment variable `PLAYDATE_LUACATS_PATH`, it will be automatically
added to the workspace.library.

### Builing the project

Just build the project without running:

```shell
pd.sh build
```

### Builing the project and running the simulator

Build and run the project in Playdate Simulator:

```shell
pd.sh run
```

or run project detached:

```shell
pd.sh run &
```

### Stopping the simulator

Stop Playdate Simulator, if running and detached:

```shell
pd.sh stop
```

### Restarting the simulator

If the simulator was started in detached mode (background), this command will
try to restart it also in the background mode.

```shell
pd.sh restart
```

## Contribution

Any help is appreciated. Found a bug, typo, inaccuracy, etc.? Please do not
hesitate to create a [pull request](https://github.com/dknight/pd.sh/pulls) or
submit an [issue](https://github.com/dknight/pd.sh/issues).

## License

MIT 2024-2025 Dmitri Smirnov
