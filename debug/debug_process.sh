#!/bin/bash

# Top-level work directory
TOP_DIR="work"

# Check input
if [ -z "$1" ]; then
  echo "Usage: $0 <partial-path> (e.g., 0d/95f97)"
  exit 1
fi

# Build glob pattern
partial_path="$1"
glob="$TOP_DIR/$partial_path"*

# Match directories
matches=( $glob )
dir_matches=()

# Filter only directories
for f in "${matches[@]}"; do
  [ -d "$f" ] && dir_matches+=( "$f" )
done

count="${#dir_matches[@]}"
if [ "$count" -eq 0 ]; then
  echo "❌ No directories matched pattern: $glob"
  exit 1
elif [ "$count" -gt 1 ]; then
  echo "⚠️ Multiple matches found:"
  for d in "${dir_matches[@]}"; do
    echo " - $d"
  done
  exit 1
else
  target="${dir_matches[0]}"
  echo "✅ Entering directory: $target"
  cd "$target" || { echo "❌ Failed to cd into $target"; exit 1; }
fi

# Check for .command.run
if [ ! -f ".command.run" ]; then
  echo "⚠️ .command.run not found in $target"
  echo "💻 Launching normal shell..."
  exec "$SHELL"
fi

# Look for activation line in .command.run
activation_line=$(grep -E "source .*activate" .command.run | head -n 1)

if [ -n "$activation_line" ]; then
  echo "🔍 Found Conda activation line:"
  echo "    $activation_line"

  # Create a temporary shell initialization file
  temp_rc="$(mktemp)"

  # Initialize Conda in the shell (if available)
  if command -v conda >/dev/null 2>&1; then
    __conda_setup="$(conda shell.bash hook 2> /dev/null)"
    if [ $? -eq 0 ]; then
      echo "# >>> conda initialize >>>" >> "$temp_rc"
      echo "$__conda_setup" >> "$temp_rc"
      echo "# <<< conda initialize <<<" >> "$temp_rc"
    else
      echo '⚠️ Warning: could not initialize Conda. You may need to run conda init.'
    fi
  else
    echo "⚠️ Conda is not installed or not found in PATH."
  fi

  # Add the activation line
  echo "$activation_line" >> "$temp_rc"
  echo 'echo "✅ Conda environment activated."' >> "$temp_rc"
  echo "rm -f \"$temp_rc\"" >> "$temp_rc"

  echo "💻 Launching interactive shell with activated Conda environment..."
  echo "Run .command.sh to test the process from nextflow"
  exec "$SHELL" --rcfile "$temp_rc"
else
  echo "ℹ️ No Conda activation line found in .command.run"
  echo "💻 Launching normal shell..."
  exec "$SHELL"
fi