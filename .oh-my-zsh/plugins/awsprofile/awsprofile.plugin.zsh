
function awsprofile_prompt_info() {
    if [ -z $ZSH_THEME_AWSPROFILE_PROMPT_PREFIX ]; then
      local ZSH_THEME_AWSPROFILE_PROMPT_PREFIX="%{$fg_bold[blue]%}aws:(%{$reset_color%}"
    fi
    if [ -z $ZSH_THEME_AWSPROFILE_PROMPT_SUFFIX ]; then
      local ZSH_THEME_AWSPROFILE_PROMPT_SUFFIX="%{$fg_bold[blue]%})%{$reset_color%} "
    fi

    # dont show "default" workspace in home dir
    [[ "$PWD" == ~ ]] && return
    # check if in terraform dir
    if [ -d .terraform ]; then
      if [ -z $AWS_PROFILE ]; then
        echo "${ZSH_THEME_AWSPROFILE_PROMPT_PREFIX}%{$fg[red]%}none${ZSH_THEME_AWSPROFILE_PROMPT_SUFFIX}"
      else
        echo "${ZSH_THEME_AWSPROFILE_PROMPT_PREFIX}%{$fg[green]%}${AWS_PROFILE}${ZSH_THEME_AWSPROFILE_PROMPT_SUFFIX}"
      fi
    fi
}

