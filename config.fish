alias jl="jupyter-lab"
alias jn="jupyter notebook"

set fish_git_dirty_color red
set fish_git_not_dirty_color green

function parse_git_branch
  set -l branch (git branch 2> /dev/null | grep -e '\* ' | sed 's/^..\(.*\)/\1/')
  set -l git_status (git status -s)

  if test -n "$git_status"
    echo (set_color $fish_git_dirty_color)$branch(set_color normal)
  else
    echo (set_color $fish_git_not_dirty_color)$branch(set_color normal)
  end
end

function fish_prompt
  set -l git_dir (git rev-parse --git-dir 2> /dev/null)
  if test -n "$git_dir"
    printf 'λ %s%s%s:%s> ' (set_color $fish_color_cwd) (prompt_pwd) (set_color normal) (parse_git_branch)
  else
    printf 'λ %s%s%s> ' (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
  end
end

# content has to be in .config/fish/config.fish
# if it does not exist, create the file
setenv SSH_ENV $HOME/.ssh/environment

function start_agent                                                                                                                                                                    
    echo "Initializing new SSH agent ..."
    ssh-agent -c | sed 's/^echo/#echo/' > $SSH_ENV
    echo "succeeded"
    chmod 600 $SSH_ENV 
    . $SSH_ENV > /dev/null
    ssh-add
end

# Other git aliases are in git config
alias g="git"

function test_identities                                                                                                                                                                
    ssh-add -l | grep "The agent has no identities" > /dev/null
    if [ $status -eq 0 ]
        ssh-add
        if [ $status -eq 2 ]
            start_agent
        end
    end
end

if [ -n "$SSH_AGENT_PID" ] 
    ps -ef | grep $SSH_AGENT_PID | grep ssh-agent > /dev/null
    if [ $status -eq 0 ]
        test_identities
    end  
else
    if [ -f $SSH_ENV ]
        . $SSH_ENV > /dev/null
    end  
    ps -ef | grep $SSH_AGENT_PID | grep -v grep | grep ssh-agent > /dev/null
    if [ $status -eq 0 ]
        test_identities
    else 
        start_agent
    end  
end
set -g fish_user_paths "/usr/local/opt/python@3.8/bin" $fish_user_paths
export PATH="/opt/miniconda3/bin:$PATH"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
eval /opt/miniconda3/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<

