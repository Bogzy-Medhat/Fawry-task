#!/bin/bash
# mygrep.sh - A mini version of the grep command
# Supports case-insensitive search, line numbers (-n), and inverted matching (-v)

# Function to display help information
show_help() {
    echo "Usage: $0 [OPTIONS] PATTERN FILE"
    echo "Search for PATTERN in FILE (case-insensitive by default)"
    echo ""
    echo "Options:"
    echo "  -n         Show line numbers for each match"
    echo "  -v         Invert the match (print lines that do not match)"
    echo "  --help     Display this help and exit"
    echo ""
    echo "Examples:"
    echo "  $0 hello testfile.txt       # Search for 'hello' in testfile.txt"
    echo "  $0 -n hello testfile.txt    # Show line numbers with matches"
    echo "  $0 -v hello testfile.txt    # Show lines that don't match 'hello'"
    echo "  $0 -vn hello testfile.txt   # Combine options"
    exit 0
}

# Initialize variables
show_line_numbers=false
invert_match=false
pattern=""
file=""

# Parse command line arguments
while [ $# -gt 0 ]; do
    case "$1" in
        --help)
            show_help
            ;;
        -n)
            show_line_numbers=true
            shift
            ;;
        -v)
            invert_match=true
            shift
            ;;
        -nv|-vn)
            show_line_numbers=true
            invert_match=true
            shift
            ;;
        -*)
            # Handle combined options like -vn or -nv
            if [[ "$1" =~ ^-[nv]+$ ]]; then
                if [[ "$1" == *"n"* ]]; then
                    show_line_numbers=true
                fi
                if [[ "$1" == *"v"* ]]; then
                    invert_match=true
                fi
                shift
            else
                echo "Error: Unknown option: $1" >&2
                echo "Try '$0 --help' for more information." >&2
                exit 1
            fi
            ;;
        *)
            # First non-option argument is the pattern
            if [ -z "$pattern" ]; then
                pattern="$1"
            # Second non-option argument is the file
            elif [ -z "$file" ]; then
                file="$1"
            else
                echo "Error: Too many arguments." >&2
                echo "Try '$0 --help' for more information." >&2
                exit 1
            fi
            shift
            ;;
    esac
done

# Check if pattern is provided
if [ -z "$pattern" ]; then
    echo "Error: Missing search pattern." >&2
    echo "Try '$0 --help' for more information." >&2
    exit 1
fi

# Check if file is provided
if [ -z "$file" ]; then
    echo "Error: Missing filename." >&2
    echo "Try '$0 --help' for more information." >&2
    exit 1
fi

# Check if file exists
if [ ! -f "$file" ]; then
    echo "Error: File '$file' does not exist." >&2
    exit 1
fi

# Process the file
line_number=0
while IFS= read -r line; do
    line_number=$((line_number + 1))
    # Case-insensitive match using grep with -i
    if echo "$line" | grep -qi "$pattern"; then
        match=true
    else
        match=false
    fi
    
    # Determine whether to print based on invert_match flag
    if [ "$invert_match" = true ] && [ "$match" = false ] || \
       [ "$invert_match" = false ] && [ "$match" = true ]; then
        if [ "$show_line_numbers" = true ]; then
            echo "$line_number:$line"
        else
            echo "$line"
        fi
    fi
done < "$file"

exit 0