# ibtoolTranslation

This is the script that can be used to internationalize the storyboard.

You edit the Translation.strings that is generated when hit the following command.
The typing the same command again to be translated.

## Usage

1) Generate "Translation.strings" file.

``` sh
ruby Translation.rb path/to/your_storyboard_directory/ <translate from lang> <translate to lang>
```

2) Edit "Translation.strings" file.

``` 
"pre-text" = "post-text";
"Date" = "日時";
"Delete" = "削除";
```

3) Again run (1) command.

``` sh
ruby Translation.rb path/to/your_storyboard_directory/ <translate from lang> <translate to lang>
```

### Example

e.g.) Translate storyboard files from English to Japanese.

``` sh
ruby Translation.rb ExampleProject/storyboard/ en ja
```

