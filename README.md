# MyGrep - A Simple Text Search Utility

This repository contains implementations of a simple grep-like utility in both Bash (mygrep.sh) and PowerShell (mygrep.ps1). These scripts provide basic text search functionality similar to the Unix `grep` command but with a simplified interface.

## Features

Both implementations support the following features:

- Case-insensitive text search
- Line number display option (-n)
- Inverted matching option (-v) to show non-matching lines
- Help documentation (--help or -help)

## Usage

### Bash Version (mygrep.sh)

```bash
./mygrep.sh [OPTIONS] PATTERN FILE
```

### PowerShell Version (mygrep.ps1)

```powershell
.\mygrep.ps1 [OPTIONS] PATTERN FILE
```

### Options

- `-n`: Show line numbers for each match
- `-v`: Invert the match (print lines that do not match)
- `--help` (Bash) or `-help` (PowerShell): Display help information

### Examples

```bash
# Search for 'hello' in testfile.txt
./mygrep.sh hello testfile.txt

# Show line numbers with matches
./mygrep.sh -n hello testfile.txt

# Show lines that don't match 'hello'
./mygrep.sh -v hello testfile.txt

# Combine options
./mygrep.sh -vn hello testfile.txt
```

## Implementation Details

### Argument Handling

#### Bash Implementation

The Bash version uses a while loop with case statements to process command-line arguments:

1. It first initializes variables for options and arguments
2. Processes each argument using pattern matching
3. Handles combined options (like `-vn`)
4. Validates required arguments (pattern and file)

#### PowerShell Implementation

The PowerShell version uses PowerShell's built-in parameter handling:

1. Defines parameters with position attributes
2. Uses switch parameters for options
3. Validates required arguments
4. Processes the file using PowerShell's pipeline capabilities

### Extending the Structure

To support additional features like regex matching or more options, the following changes would be needed:

#### For Bash Script

1. Add new flag variables for each option
2. Extend the case statement to handle new options
3. Modify the file processing logic to incorporate new features
4. Update the help documentation

#### For PowerShell Script

1. Add new switch parameters or string parameters as needed
2. Modify the file processing logic
3. Update the help documentation

For regex support specifically:
- The Bash version would need to modify the grep command used internally
- The PowerShell version would need to change from `-match` to `-match` with a regex pattern or use `Select-String` with appropriate options

## Implementation Challenges

The most challenging aspects of implementing these scripts were:

1. **Argument Parsing**: Especially in the Bash version, handling combined options (like `-vn`) required careful string manipulation and pattern matching.

2. **Cross-Platform Consistency**: Ensuring that both implementations behave similarly despite the differences between Bash and PowerShell required careful attention to detail.

3. **Error Handling**: Providing meaningful error messages and proper exit codes for various error conditions while maintaining a consistent user experience.

4. **Performance Considerations**: For large files, reading and processing line by line needed to be done efficiently, especially in the Bash implementation.

The PowerShell implementation benefits from PowerShell's built-in parameter handling, making the code more concise, while the Bash version demonstrates more traditional Unix-style command-line argument processing.