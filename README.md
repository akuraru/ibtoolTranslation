# ibtoolTranslation

This is the script that can be used to internationalize the storyboard.

You edit the Translation.strings that is generated when hit the following command.
The typing the same command again to be translated.

## Usage

``` sh
ruby Translation.rb path/to/your_storyboard_direcotry/ <translate from lang> <translate to lang>
```

### Example

e.g.) Translate storyboard files from English to Japanese.

``` sh
ruby Translation.rb ExampleProject/storyboard/ en ja
```

