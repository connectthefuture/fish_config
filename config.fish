set -g -x PATH /usr/local/bin $PATH

function be
  bundle exec $argv;
end

function d
  sudo docker $argv;
end

function gst
  git st
end

function zc
  zeus c
end

function zs
  zeus s
end

function tmux
  env TERM=xterm-256color /usr/bin/tmux
end

function rvm --description='Ruby enVironment Manager'
  # run RVM and capture the resulting environment
  set --local env_file (mktemp -t rvm.fish.XXXXXXXXXX)
  bash -c 'source ~/.rvm/scripts/rvm; rvm "$@"; status=$?; env > "$0"; exit $status' $env_file $argv

  # apply rvm_* and *PATH variables from the captured environment
  and eval (grep '^rvm\|^[^=]*PATH\|^GEM_HOME' $env_file | grep -v '_clr=' | sed '/^[^=]*PATH/y/:/ /; s/^/set -xg /; s/=/ /; s/$/ ;/; s/(//; s/)//')
  # clean up
  rm -f $env_file
end

function __handle_rvmrc_stuff --on-variable PWD
  # Source a .rvmrc file in a directory after changing to it, if it exists.
  # To disable this fature, set rvm_project_rvmrc=0 in $HOME/.rvmrc
  if test "$rvm_project_rvmrc" != 0
    set -l cwd $PWD
    while true
      if contains $cwd "" $HOME "/"
        if test "$rvm_project_rvmrc_default" = 1
          rvm default 1>/dev/null 2>&1
        end
        break
      else
        if begin; test -s ".rvmrc"; or test -s ".ruby-version"; or test -s ".ruby-gemset"; end
          eval "rvm reload" > /dev/null
          break
        else
          set cwd (dirname "$cwd")
        end
      end
    end

    set -e cwd
  end
end
