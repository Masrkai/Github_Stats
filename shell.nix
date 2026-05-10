{ pkgs ? import <nixpkgs> {
    config = {
      allowUnfree = true;
      cudaSupport = true;
    };
  }
}:

pkgs.mkShell {
  name = "Status";

  buildInputs = with pkgs; [
    # Python + uv
    python312
    uv

    # Common native deps useful for ML/CUDA projects
    stdenv.cc.cc.lib   # libstdc++
    zlib
    libGL
  ];

  shellHook = ''
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  uv   version: $(uv --version)"
    echo "  Python:       $(python --version)"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    # Create venv with uv if it doesn't exist yet
    if [ ! -d ".venv" ]; then
      echo "→ Creating venv with uv..."
      uv venv .venv --python python3.12
    fi

    # Activate it
    source .venv/bin/activate

    echo "→ Venv active: $VIRTUAL_ENV"
  '';
}
