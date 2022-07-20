# ruby-rocketifier.nvim
Hash rockets ↔ Hash colons

## Why?
In Ruby, sometimes you want to transform hashes from using hash rockets:
```ruby
{
  'foo': 0, 
  'bar': 1, 
  'baz': 2,
}
```
To the newer symbol syntax:
```ruby
{
  foo: 0,
  bar: 1,
  baz: 2,
}
```

After doing this by hand enough times, I decided to create a simple Neovim plugin to do it for me!

## How?
Use your favorite package control system! Using [Plug](https://github.com/junegunn/vim-plug) as an example:
```viml
call plug#begin('~/.local/share/nvim/plugged')
 Plug 'lucaseras/ruby-rocketifier.nvim'
call plug#end()
```

Then, all you need to do is initialize the plugin using `require('ruby-rocketifier').setup({})`

You can define your own keymaps like so:
```lua
require('ruby-rocketifier').setup({
  keymaps = {
    to_rocket = false
    to_colon = false,
    toggle = "<leader>l",
  }
})
```

Keymaps set to `false` don't get set.
