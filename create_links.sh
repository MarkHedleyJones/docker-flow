#!/usr/bin/env bash

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

scripts=(
  enter
  run
)

paths_to_try=(
  /home/${USER}/.local/bin
  /home/${USER}/bin
)

for path in ${paths_to_try[@]}; do
  echo "Checking for local binary path at ${path} ... "
  if [[ -d ${path} ]]; then
    for script in ${scripts[@]}; do
      if [[ -f ${path}/${script} ]]; then
        echo "Warning - Script '${script}' already exists at this location!"
      else
        ln -s ${script_dir}/bin/${script} ${path}/${script}
        echo "Created link to ${script}"
      fi
    done
    test=$(export | grep $PATH | grep ${path} > /dev/null)
    if [[ ${test} -ne 0 ]]; then
      echo "The installed path (${path}) does not appear in you \$PATH environment variable"
      echo "Please include the followng line in your shell's startup script (e.g. .bashrc, .zshrc)"
      echo "export PATH=\"\${PATH}:${path}\""
    fi
    exit 0
  fi
done
