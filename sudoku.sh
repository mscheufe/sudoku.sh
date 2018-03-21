#!/usr/bin/env bash

# DEBUG=true
DEBUG=false
OVERALL_GRID=
SIZE=9
GRID_SIZE=3
GRID_STEPS=(0 9 18)

print() { [[ $DEBUG = true ]] && echo -e "$*"; }

read_grid_from_file() {
    OVERALL_GRID=()
    while read -r line; do
        for number in $line; do OVERALL_GRID+=("$number"); done
    done < "$1"
}

print_grid() {
    for i in "${!OVERALL_GRID[@]}"; do
        if (( (i+1) % SIZE )); then
            printf "%2d " "${OVERALL_GRID[i]}"
        else
            printf "%2d\\n" "${OVERALL_GRID[i]}"
        fi
    done
}

get_row_indices() {
    local _index=$1
    for (( i=(_index / SIZE) * SIZE; i < ((_index / SIZE) * SIZE) + SIZE; i++ )) { echo -en "$i "; }
}

get_column_indices() {
    local _index=$1
    for (( i=(_index % SIZE); i <= _index % SIZE + (SIZE - 1) * SIZE; i+=SIZE )) { echo -en "$i "; }
}

get_grid_indices() {
    local _index=$1
    local _start_pos=$(( ((_index - SIZE * ((_index / SIZE) % GRID_SIZE)) / GRID_SIZE) * GRID_SIZE ))
    for i in "${GRID_STEPS[@]}"; do
        for ((j=_start_pos; j < _start_pos + GRID_SIZE; j++)) { echo -en "$(( j + i )) "; }
    done
}

type_of_check() {
    case $1 in
        *row*)
            echo row
            ;;
        *col*)
            echo col
            ;;
        *grid*)
            echo grid
            ;;
    esac
}

run_check() {
    local _func=$1; shift
    local _index=$1; shift
    local _i=
    print "check for duplicate of grid[$_index]=${OVERALL_GRID[$_index]} in $(type_of_check "$_func")"
	for _i in $($_func "$_index"); do
		if [[ "${OVERALL_GRID[$_i]}" = "${OVERALL_GRID[$_index]}" \
              && $_i -ne $_index && "${OVERALL_GRID[$_i]}" -ne 0 ]]; then
			print "duplicate of ${OVERALL_GRID[$_index]} found at index $_i"
			return 1
		fi
	done
}

is_unique() {
    local _index=$1; shift
    if ! run_check get_row_indices "$_index"; then
        return 1
    fi
    if ! run_check get_column_indices "$_index"; then
        return 1
    fi
    if ! run_check get_grid_indices "$_index"; then
        return 1
    fi
	return 0
}

get_next() {
    local _i=
    for _i in "${!OVERALL_GRID[@]}"; do
        if (( OVERALL_GRID[_i] == 0 )); then
            echo $_i
            return
        fi
    done
    echo -1
}

solve() {
    local _i=0
    local _n=0
	local _next=
	_next=$(get_next)
	(( _next == -1 )) && return 0
	for _n in {1..9}; do
		OVERALL_GRID[$_next]="$_n"
		if is_unique "$_next"; then
			if solve; then
				return 0
			fi
		fi
        OVERALL_GRID[$_next]=0
	done
    return 1
}

verify() {
    local _i=0
    for _i in "${!OVERALL_GRID[@]}"; do
		if ! is_unique "$_i"; then
            "grid is not unique at OVERALL_GRID[$_i]=${OVERALL_GRID[$_i]}"
            return 1
        fi
    done
    return 0
}

read_grid_from_file "$1"
print_grid
solve
echo -
print_grid
verify
