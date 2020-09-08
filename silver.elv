last-cmd-start-time = 0
last-cmd-duration = 0
fn add-before-readline [@hooks]{
  each [hook]{
    if (not (has-value $edit:before-readline $hook)) {
      edit:before-readline=[ $@edit:before-readline $hook ]
    }
  } $hooks
}

fn add-after-readline [@hooks]{
  each [hook]{
    if (not (has-value $edit:after-readline $hook)) {
      edit:after-readline=[ $@edit:after-readline $hook ]
    }
  } $hooks
}

fn now {
  put (date +%s%3N)
}

fn after-readline-hook [cmd]{
  last-cmd = $cmd
  last-cmd-start-time = (now)
}

fn before-readline-hook {
  -end-time = (now)
  last-cmd-duration = (- $-end-time $last-cmd-start-time)
}

fn init {
  edit:prompt = { E:jobs=""$num-bg-jobs E:cmdtime=""$last-cmd-duration silver lprint }
  edit:rprompt = { E:jobs=""$num-bg-jobs E:cmdtime=""$last-cmd-duration silver rprint }
  E:VIRTUAL_ENV_DISABLE_PROMPT = 1 # Doesn't make any sense yet
  add-before-readline $before-readline-hook~
  add-after-readline $after-readline-hook~
  last-cmd-start-time = (now)
}

if (has-external silver) {
  init
} else {
  put 'silver is not installed; please follow the instructions on https://github.com/reujab/silver#installation'
}
