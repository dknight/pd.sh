# pd.sh

A simple shell script to make development for [Playdate](https://play.date)
a bit easier from the command line on the Unix-like systems, using shell.

## Install

Be sure that `PLAYDATE_SDK_PATH` is already set on your system.

Something like this:

```sh
echo "PLAYDATE_SDK_PATH=\"$HOME/PlaydateSDK-2.6.0\""
```

Clone this repo:

```sh
git clone https://github.com/dknight/pd.sh
```

Change directory:

```sh
cd pd.sh
```

Run Makefile:

* Root privileges might be needed with the `sudo` command.

```sh
make install
# or
sudo make install
```

The default installation path is `/usr/local/bin`. Additionally, `PREFIX` can be
set, for example:

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
 
### Examples

Create a new project:

 ```sh
 pd.sh new
 ```
 
 Build a project in the current directory:

 ```sh
 pd.sh -d . new
 ```


Build and run the project in Playdate Simulator:

```sh
pd.sh run
```

or run project detached:

```sh
pd.sh run &
```

Stop Playdate Simulator, if running and detached:

```sh
pd.sh stop
```
