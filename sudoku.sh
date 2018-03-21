#!/usr/bin/env bash

# DEBUG=true
DEBUG=false
OVERALL_GRID=
SIZE=9
SUBGRID_SIZE=3
SUBGRID_STEPS=(0 9 18)

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
            printf "%-2d" "${OVERALL_GRID[i]}"
        else
            printf "%-2d\\n" "${OVERALL_GRID[i]}"
        fi
    done
}

print_heading() {
    local _heading="$*"
    local _pos=$(((17 - ${#_heading}) / 2))
    printf "%*s%s\\n" "$_pos" "" "$_heading"
}

get_row_indices() {
    local _index=$1
    for (( i=(_index / SIZE) * SIZE; i < ((_index / SIZE) * SIZE) + SIZE; i++ )) {
        echo -en "$i "
    }
}

get_column_indices() {
    local _index=$1
    for (( i=(_index % SIZE); i <= _index % SIZE + (SIZE - 1) * SIZE; i+=SIZE )) {
        echo -en "$i ";
    }
}

get_subgrid_indices() {
    local _index=$1
    local _current_row=$((_index / SIZE))
    local _index_on_firstrow_subgrid=$((_index - ((_current_row % SUBGRID_SIZE) * SIZE)))
    local _index_startpos_subgrid=$(((_index_on_firstrow_subgrid / SUBGRID_SIZE) * SUBGRID_SIZE))
    for i in "${SUBGRID_STEPS[@]}"; do
        for ((j=_index_startpos_subgrid; j < _index_startpos_subgrid + SUBGRID_SIZE; j++)) {
            echo -en "$(( j + i )) "
        }
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
        *subgrid*)
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
    if ! run_check get_subgrid_indices "$_index"; then
        return 1
    fi
	return 0
}

get_next_empty() {
    local _i=
    for _i in "${!OVERALL_GRID[@]}"; do
        if (( OVERALL_GRID[_i] == 0 )); then
            echo $_i
            return
        fi
    done
    echo -1
}

solve_puzzle() {
    local _i=0
    local _n=0
	local _next=
	_next=$(get_next_empty)
	(( _next == -1 )) && return 0
	for _n in {1..9}; do
		OVERALL_GRID[$_next]="$_n"
		if is_unique "$_next"; then
			if solve_puzzle; then
				return 0
			fi
		fi
        OVERALL_GRID[$_next]=0
	done
    return 1
}

verify_puzzle() {
    local _i=0
    for _i in "${!OVERALL_GRID[@]}"; do
		if ! is_unique "$_i"; then
            print "grid is not unique at OVERALL_GRID[$_i]=${OVERALL_GRID[$_i]}"
            return 1
        fi
    done
    return 0
}

# --main --
read_grid_from_file "$1"
print_heading "INPUT GRID"
print_grid
solve_puzzle
print_heading "SOLVED GRID"
print_grid
if ! verify_puzzle; then
    echo "something must be wrong"
fi
