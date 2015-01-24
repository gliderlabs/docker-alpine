
# Misc utility functions / commands

indent() {
	while read line; do
		if [[ "$line" == --* ]]; then
			echo $'\e[1G'$line
		else
			echo $'\e[1G      ' "$line"
		fi
	done
}

status-header() {
	echo "----->" $@ "..."
}

status() {
	echo $@ | indent
}

status-start() {
	printf "       %s ... " "$@"
}

status-finish() {
	printf "%s\n" "$@"
}

info-header() {
	echo "=====>" $@
}

info() {
	printf "       %-16s: %s\n" "$1" "$2"
}

fn() {
	declare desc="Run arbitrary function directly"
	declare fn="$1"; shift
	$fn "$@"
}

cmd-export fn
