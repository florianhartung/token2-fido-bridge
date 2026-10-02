{ runCommand, hello }:
runCommand "say-hello" { nativeBuildInputs = [ hello ]; } ''
  hello > "$out"
''
