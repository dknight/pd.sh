#!/bin/sh

# License MIT 2024 Dmitri Smirnov <https://www.whoop.ee>
#
# TODO
# - Test on MacOS
#

# Check PLAYDATE_SDK_PATH existence.
if [[ -z "$PLAYDATE_SDK_PATH" ]]; then
	echo "PLAYDATE_SDK_PATH environment variable is not set."
	exit 1
fi

if [[ "$OSTYPE" = "darwin" ]]; then
	IS_MACOS=1
fi

if [[ $IS_MACOS -eq 1 ]]; then
	SIMULATOR_BIN="$PLAYDATE_SDK_PATH/bin/Playdate Simulator.app"
	SIMULATOR_BIN="/usr/bin/open -a \"$SIMULATOR_BIN\""
fi

# Create builds directory if not exists.
function check_build_dir() {
	if [[ ! -d "$PDX_PATH" ]]; then
		mkdir -pv "$PDX_PATH"
	fi
}

# Increment build number, timestamp also can be used?
function increment_build() {
	VERSION=$(cat "$PDXINFO_PATH" | grep buildNumber | tr -dc '0-9')
	NEW=$(( VERSION + 1 ))

	compat=""
	if [[ $IS_MACOS -eq 1 ]]; then
		compat="\'\'"
	fi
	sed -i $compat "s/buildNumber=[0-9]*/buildNumber=$NEW/g" "$PDXINFO_PATH"

	status=$?
	if [[ $status -eq 0 ]]; then
		echo "Updating pdxinfo buildNumber: $VERSION -> $NEW"
	else
		echo "error updating build number"
		exit $status
	fi
}

# Get process id of PlaydateSimulator process.
function get_pid() {
	PID="$( pidof PlaydateSimulator )"
	if [[ -n "$PID" ]]; then
		echo "Playdate simulator PID $PID"
	fi
}

# Stop Playdate simulator.
function stop() {
	get_pid
	if [[ -n $PID ]]; then
		echo "Stopping Playdate simulator..."
		kill -9 $PID
	fi
}

#Build a project.
function build() {
	cd "$DIR"
	echo "Building..."
	check_build_dir
	$COMPILER_BIN -sdkpath "$PLAYDATE_SDK_PATH" "$SOURCE_PATH" "$PDX_PATH"
	if [[ $? -ne 0 ]]; then
		exit 1
	fi
	increment_build
}

# Build and Playdate simulator.
function run() {
	stop
	build
	$SIMULATOR_BIN "$PDX_PATH"
	get_pid
}

# Create a new project interactively.
function new() {
	while true; do
		if [[ -d "$DIR" && "$DIR" != $( pwd ) ]]; then
			read -p "$DIR already exist. Do you wish to continue? [y/N]" ok
			if [[ "$ok" != "y" && "$ok" != "Y" ]]; then
				echo "$BYE"
				exit 1
			fi
		fi
		echo "Project path: $DIR"

		while true; do
			read -p "Game name: " GANE_NAME
			if [[ -z ${GANE_NAME//[[:blank:]]/} ]]; then
				echo "Game name cannot be empty"
			else
				break
			fi
		done
		read -p "Author: " AUTHOR
		read -p "Description " DESCRIPTION
		while true; do
			read -p "Bundle ID: " BUNDLE_ID
			if [[ -n "$BUNDLE_ID" &&  "$BUNDLE_ID" != *"."* ]]; then
				echo "Bundle can be empty or follow reverse DNS notation."
				echo "Example: com.john.doe"
			else
				break
			fi
		done
		while true; do
			read -p "Version: " VERSION
			if [[ ! "$VERSION" =~ ^[0-9]+\.[0-9]+ ]]; then
				echo "Version should match semver: major.minor[.patch"]
				echo "Examples. 1.0.0, 0.2.4", 0.1, 1.2, etc.
			else
				break
			fi
		done

		pdxcontent="name=$GANE_NAME\n"
		pdxcontent="${pdxcontent}author=$AUTHOR\n"
		pdxcontent="${pdxcontent}description=$DESCRIPTION\n"
		pdxcontent="${pdxcontent}bundleID=$BUNDLE_ID\n"
		pdxcontent="${pdxcontent}version=$VERSION\n"
		pdxcontent="${pdxcontent}buildNumber=0\n"

		clear
		printf "$pdxcontent"

		read -p "Is this ok? [y/N] " ok
		if [[ "$ok" = "y" || "$ok" = "Y" ]]; then
			break
		else
			read -p "Start again? [y/N] " retry
			if [[ "$retry" != "y" && "$retry" != "Y" ]]; then
				echo "$BYE"
				exit 0
			fi
		fi
	done

	mkdir -pv\
		"$DIR"\
		"$DIR/source"\
		"$DIR/source/images"\
		"$DIR/source/sounds"

	cat > "$DIR/source/main.lua" << EOL
import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local gfx <const> = playdate.graphics

function playdate.update()
gfx.clear()
gfx.drawText("Hello World", 20, 20)
end
EOL
	echo "Created: $DIR/source/main.lua"

	printf "$pdxcontent" > "$DIR/source/pdxinfo"
	echo "Created: $DIR/source/pdxinfo"

	echo "/builds" > "$DIR/.gitignore"
	echo "Done"

	exit 0
}

# Prints usage.
function usage() {
	echo "Usage: pd.sh [-d <directory>] command"
	echo "Options"
	echo "  -d <directory>: project directory, current directory by default"
	echo "  -h: print this help information."
	echo "Commands:"
	echo "  new: Create a new project with an interactive prompt;"
	echo "  run: build and run a project;"
	echo "  build:  build a project;"
	echo "  stop: stop Playdate simulator, if running."
}


# main

DIR=$( pwd )
BYE="Bye!"
PID=

# For such small software there is no need to make large option parser.
# Maybe in the future nice to have.
set -- $( getopt d: "$@" )
while [ $# -gt 0 ]
do
    case "$1" in
		-d)
			DIR="$( realpath $2 )"
			shift 
			;;
		-h)
			usage
			shift
			;;
		--)
			shift 
			break;;
		*)
    esac
    shift
done

SOURCE_PATH="$DIR/source"
BUILD_PATH="$DIR/builds"
PDXINFO_PATH="$SOURCE_PATH/pdxinfo"
PDX_PATH="$BUILD_PATH/$(basename $DIR).pdx"
SIMULATOR_BIN="$PLAYDATE_SDK_PATH/bin/PlaydateSimulator"
COMPILER_BIN="$PLAYDATE_SDK_PATH/bin/pdc"

# Verbose, but compatible.
case "$1" in
	new)
		new
		;;
	run)
		run
		;;
	build)
		build
		;;
	stop)
		get_pid
		if [[ -z $PID ]]; then
			echo "No Playdate simulator running"
			echo "$BYE"
			exit 0
		fi
		stop
		;;
	*)
		usage
		;;
esac
