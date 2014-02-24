# IbtoolTranslation

This is the script that can be used to internationalize the storyboard.

You edit the Translation.strings that is generated when hit the following command. The typing the same command again to be translated.

## Installation

Add this line to your application's Gemfile:

    gem 'ibtoolTranslation'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ibtoolTranslation

## Usage

1) Generate "Translation.strings" file.

``` sh
ibtoolTranslation create -d path/to/your_storyboard_directory/ -f <translate from lang> -t <translate to langs>
```

2) Edit "Translation.strings" file.

``` 
"pre-text" = "post-text";
"Date" = "日時";
"Delete" = "削除";
```

3) Again run (1) command.

``` sh
ibtoolTranslation update -d path/to/your_storyboard_directory/ -f <translate from lang> -t <translate to langs>
```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/ibtool_translation/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
