## AWS oh-my-zsh plugin

Plugin to display the current aws profile in Terraform directories.

### Usage

To use it, add `awsprofile` to the plugins array of your `~/.zshrc` file:

```shell
plugins=(... awsprofile)
```

### Expanding ZSH prompt with current AWS profile name

If you want to get current AWS profile name in your ZSH prompt open your .zsh-theme file and in a chosen place insert:

```shell
$(awsprofile_prompt_info)
```

