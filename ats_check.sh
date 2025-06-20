#!/bin/bash
# ats_check.sh - Check PDF resume for ATS compatibility
# Usage: ./ats_check.sh NAUDE_CV.pdf

set -e

PDF_FILE="$1"

if [ -z "$PDF_FILE" ]; then
  echo "Usage: $0 <pdf-file>"
  exit 1
fi

if ! command -v pdftotext &> /dev/null; then
  echo "Error: pdftotext is not installed. Install poppler-utils."
  exit 2
fi

TXT_FILE="${PDF_FILE%.pdf}.txt"

# Convert PDF to text
pdftotext "$PDF_FILE" "$TXT_FILE"

# Check if the text file is readable
if [ ! -s "$TXT_FILE" ]; then
  echo "[FAIL] PDF could not be converted to readable text. Not ATS compatible."
  exit 3
fi

# Basic checks
LINES=$(wc -l < "$TXT_FILE")
WORDS=$(wc -w < "$TXT_FILE")

if [ "$LINES" -lt 10 ] || [ "$WORDS" -lt 30 ]; then
  echo "[WARN] Resume text seems too short. Check PDF content."
fi

echo "[PASS] PDF text extracted. File is likely ATS compatible."

echo "--- Preview of extracted text ---"
head -200 "$TXT_FILE"
echo "--- End of preview ---"

echo "[INFO] For best results: Avoid images, columns, tables, and fancy formatting. Use clear headings and standard fonts."
