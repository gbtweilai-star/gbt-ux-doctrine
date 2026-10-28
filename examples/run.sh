#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
PYTHONPATH=src python -m gbt_ux_doctrine info
PYTHONPATH=src python -m gbt_ux_doctrine check --payload '{}'
PYTHONPATH=src python -m gbt_ux_doctrine run   --payload '{}'
