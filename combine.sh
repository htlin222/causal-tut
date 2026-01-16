#!/bin/bash
# combine.sh - Modular QMD management for Quarto presentations
# Usage:
#   ./combine.sh split   - Split index.qmd into chapters/
#   ./combine.sh watch   - Watch chapters/ and auto-combine on changes
#   ./combine.sh combine - One-time combine chapters/ into index.qmd

set -euo pipefail

CHAPTERS_DIR="./chapters"
INDEX_FILE="./index.qmd"

# Create chapters directory
mkdir -p "$CHAPTERS_DIR"

# Function to create slug from H1 header text
slugify() {
    echo "$1" | \
        sed 's/{[^}]*}//g' | \
        tr '[:upper:]' '[:lower:]' | \
        sed 's/[^a-z0-9]/-/g' | \
        sed 's/--*/-/g' | \
        sed 's/^-//' | \
        sed 's/-$//'
}

# Split index.qmd by H1 headers into chapters/
split_qmd() {
    echo "Splitting $INDEX_FILE into chapters..."

    if [[ ! -f "$INDEX_FILE" ]]; then
        echo "Error: $INDEX_FILE not found"
        exit 1
    fi

    # Clear existing chapter files
    rip "$CHAPTERS_DIR"/*.qmd 2>/dev/null || true

    local counter=0
    local current_file=""
    local in_content=false
    local in_code_block=false

    while IFS= read -r line || [[ -n "$line" ]]; do
        # Track code block boundaries (``` with optional language)
        if [[ "$line" == '```'* ]]; then
            if $in_code_block; then
                in_code_block=false
            else
                in_code_block=true
            fi
        fi

        # Check if line starts with H1 (# but not ##) and NOT inside code block
        if [[ "$line" == "# "* ]] && [[ "$line" != "## "* ]] && ! $in_code_block; then
            # Extract H1 text (remove leading "# ")
            local h1_text="${line#\# }"
            local slug
            slug=$(slugify "$h1_text")

            counter=$((counter + 1))
            local padded
            padded=$(printf "%02d" $counter)
            current_file="$CHAPTERS_DIR/${padded}_${slug}.qmd"

            echo "  Creating: $current_file"
            echo "$line" > "$current_file"
            in_content=true
        elif [[ -n "$current_file" ]] && $in_content; then
            echo "$line" >> "$current_file"
        fi
    done < "$INDEX_FILE"

    echo "Split complete. Created $counter chapter files."
    ls -la "$CHAPTERS_DIR"/*.qmd 2>/dev/null || echo "No files created"
}

# Combine all chapter files back into index.qmd
combine_qmd() {
    echo "Combining chapters into $INDEX_FILE..."

    local files
    files=$(find "$CHAPTERS_DIR" -name "*.qmd" -type f 2>/dev/null | sort)

    if [[ -z "$files" ]]; then
        echo "No .qmd files found in $CHAPTERS_DIR"
        return 1
    fi

    # Create new index.qmd by concatenating all chapter files
    local first=true
    > "$INDEX_FILE"  # Clear the file

    for file in $files; do
        if $first; then
            first=false
        else
            echo "" >> "$INDEX_FILE"  # Add blank line between chapters
        fi
        cat "$file" >> "$INDEX_FILE"
    done

    echo "Combined $(echo "$files" | wc -l | tr -d ' ') files into $INDEX_FILE"
}

# Watch chapters/ for changes and auto-combine
watch_chapters() {
    echo "Watching $CHAPTERS_DIR for changes..."
    echo "Press Ctrl+C to stop"
    echo ""

    # Check if fswatch is installed
    if ! command -v fswatch &> /dev/null; then
        echo "Error: fswatch not found. Install with: brew install fswatch"
        exit 1
    fi

    # Initial combine
    combine_qmd

    # Watch for changes
    fswatch -o "$CHAPTERS_DIR" | while read -r _; do
        echo ""
        echo "[$(date '+%H:%M:%S')] Change detected, combining..."
        combine_qmd
        echo "Ready for next change..."
    done
}

# Main command handler
case "${1:-help}" in
    split)
        split_qmd
        ;;
    combine)
        combine_qmd
        ;;
    watch)
        watch_chapters
        ;;
    help|--help|-h)
        echo "Usage: $0 {split|combine|watch}"
        echo ""
        echo "Commands:"
        echo "  split   - Split index.qmd by H1 headers into chapters/"
        echo "  combine - Combine chapters/*.qmd into index.qmd"
        echo "  watch   - Watch chapters/ and auto-combine on changes"
        echo ""
        echo "Workflow:"
        echo "  1. ./combine.sh split  # Initial split"
        echo "  2. ./combine.sh watch  # Run in background"
        echo "  3. Edit files in chapters/"
        echo "  4. Quarto auto-renders index.qmd"
        ;;
    *)
        echo "Unknown command: $1"
        echo "Run '$0 help' for usage"
        exit 1
        ;;
esac
