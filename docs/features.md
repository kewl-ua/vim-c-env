# Features in action

[← vim-c-env](../README.md) · [All docs](README.md) · **English** · [Українська](uk/features.md)

All clips are recorded from the [example project](c-workflow.md#example-project) with this
exact config.

## Completion

Typing `self.` lists the struct members. clangd checks the half-written line
straight away: a warning and an error show up in the sign column and the
status line.

![Completion](../assets/completion.gif)

## Go to definition and references

`gd` jumps from the call to the definition, `Ctrl-o` jumps back, and `gr` finds
every reference to the type.

![Go to definition and references](../assets/navigation.gif)

## Hover documentation

`K` shows the signature under the cursor, including libc functions such as
`strlen` with their documentation.

![Hover documentation](../assets/hover.gif)

## Diagnostics

Errors are reported as you type. `]g` jumps to the next one and the message
appears in a float.

![Diagnostics](../assets/diagnostics.gif)

## Rename

`\rn` renames a symbol in every place clangd knows about. Comments are left
alone.

![Rename](../assets/rename.gif)

## Formatting

`\f` runs clang-format over the file, here after the indentation was scrambled
on purpose.

![Formatting](../assets/format.gif)

## Snippets

A whole program from snippet triggers: `inc`, `main`, `for` and `pr`, each
expanded with `Ctrl-l`. `Ctrl-j` moves to the next placeholder.

![Snippets](../assets/snippets.gif)

## Build and quickfix

`\m` runs `make`. The compiler error lands in the quickfix list, `Enter` jumps
to it, and a clean rebuild closes the list.

![Build and quickfix](../assets/build.gif)

## Debugging

`\dd ./demo` starts gdb inside Vim. A breakpoint (`\db`), run (`\dr`), step
into (`\ds`), step over (`\dn`), evaluate (`\de`) and continue (`\dc`). Recorded
in the Docker image, since Termdebug needs Vim with `+terminal`.

![Debugging](../assets/debug.gif)

## Git

gitgutter marks changed (`~`) and added (`+`) lines, `]c` walks the hunks, `\gp`
previews one, and `\gg` opens fugitive's status.

![Git](../assets/git.gif)

## Cheatsheet inside Vim

`:Cheatsheet` (or `\?`) opens this keybinding reference as a native Vim help
page next to your code. Links in the contents jump with `CTRL-]`, and
`:help vim-c-env` works too.

![Cheatsheet inside Vim](../assets/cheatsheet.gif)
