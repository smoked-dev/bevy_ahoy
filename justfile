win_target := "x86_64-pc-windows-gnu"
stage_dir := "/mnt/e/bevy-ahoy-dev"

# Build an example for native Windows from WSL2 and launch it from E:\bevy-ahoy-dev.
win-dev example="surf":
    #!/usr/bin/env bash
    set -euo pipefail

    WIN_TARGET="{{win_target}}"
    STAGE_DIR="{{stage_dir}}"
    EXAMPLE="{{example}}"
    EXE="./target/${WIN_TARGET}/win-dev/examples/${EXAMPLE}.exe"

    command -v cmd.exe >/dev/null 2>&1 || { echo "cmd.exe not found; run this from WSL2."; exit 1; }

    cmd.exe /C "taskkill /IM ${EXAMPLE}.exe /F >NUL 2>&1" || true

    echo "Building ${EXAMPLE} for Windows..."
    cargo build --example "${EXAMPLE}" --target "${WIN_TARGET}" --profile win-dev

    echo "Staging to E:\\bevy-ahoy-dev..."
    mkdir -p "${STAGE_DIR}"
    cp "${EXE}" "${STAGE_DIR}/${EXAMPLE}.exe"

    rsync -a --delete assets/ "${STAGE_DIR}/assets/"

    echo "Launching ${EXAMPLE}..."
    cd "${STAGE_DIR}" && "./${EXAMPLE}.exe"
