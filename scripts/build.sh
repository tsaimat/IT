#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

build_one () {
  local dir="$1"        # e.g. latex/paper
  local entry="$2"      # e.g. main.tex
  local outname="$3"    # e.g. paper.pdf

  echo "==> Building ${outname} from ${dir}/${entry}"

  pushd "${ROOT_DIR}/${dir}" > /dev/null

  # Build into a local build/ directory so the source tree stays clean
  latexmk -pdf -interaction=nonstopmode -halt-on-error \
          -outdir=build \
          "${entry}"

  # Find the produced PDF (assumes entry tex -> entry pdf name)
  local produced="build/${entry%.tex}.pdf"
  if [[ ! -f "${produced}" ]]; then
    echo "Expected PDF not found: ${produced}" >&2
    exit 1
  fi

  cp -f "${produced}" "${ROOT_DIR}/${outname}"

  popd > /dev/null
}

build_one "latex"    "problems.tex"     "problems.pdf"
build_one "latex"   "hints.tex"   "hints.pdf"
build_one "latex" "cheatsheet.tex" "cheatsheet.pdf"

echo "Done. PDFs updated in repo root."

