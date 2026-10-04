# Програмування під UNIX

[← vim-c-env](../../README.uk.md) · [Уся документація](README.md) · [English](../unix.md) · **Українська**

Середовище покриває системне програмування під Linux, BSD і macOS: man-сторінки
у Vim, clangd, що розуміє POSIX, сніпети для типових системних викликів і
приклад, налаштований під санітайзери, Valgrind і strace.

## Man-сторінки: `\k`

`\k` відкриває man-сторінку для слова під курсором у спліті. Спершу шукає в
розділах C, у такому порядку: **3** (бібліотека C), **2** (системні виклики),
**3p** (POSIX), **7** (огляди). Це важливо, бо багато імен із C — ще й команди:

| Слово | `:Man слово` відкриває | `\k` відкриває |
|-------|------------------------|----------------|
| `printf` | printf(1), команду shell | printf(3) |
| `waitpid` | waitpid(1), команду | wait(2), де він описаний |

Шукати лише в розділі 3 теж недостатньо: `man 3 fork` знаходить fork(3am),
модуль GNU Awk. Тому `\k` приймає сторінку, тільки якщо її розділ збігається
точно, і `fork` відкриває fork(2).

У man-сторінці `CTRL-]` переходить за посиланням на кшталт `pipe(2)`, а `:q`
закриває її. `K` лишається підказкою clangd: вона показує оголошення з тих
заголовків, які clangd справді використав.

## POSIX-макроси

Зі строгим стандартом на кшталт `-std=c11` glibc ховає все, чого немає в ISO C:
`getline`, `strdup`, `fileno` і подібні. Тоді clangd пише про «implicit
declaration», хоча код правильний. Виміряно через `clangd --check` на
невеликому файлі з цими функціями:

| Прапорці | Результат clangd |
|----------|------------------|
| `-std=c11` | 4 помилки |
| `-std=c11 -D_POSIX_C_SOURCE=200809L` | 0 помилок |
| `-std=gnu11` | 0 помилок |

Оберіть одне: `_POSIX_C_SOURCE` (переносний POSIX.1-2008), `_GNU_SOURCE` (усе,
що є в glibc) або стандарт `gnu`. Задайте це в `CFLAGS`, щоб компілятор і clangd
бачили однаково, або вгорі файлу сніпетом `posix`.

## Сніпети

Наберіть тригер і натисніть `Ctrl-l`; `Ctrl-j` / `Ctrl-k` переходять між полями.

| Тригер | Що розгортається |
|--------|------------------|
| `posix` | `#define _POSIX_C_SOURCE 200809L` |
| `die` | допоміжна `die()`: `perror` і `exit(EXIT_FAILURE)` |
| `fork` | `fork()` з гілками помилки, дочірнього й батьківського процесу |
| `waitpid` | `waitpid()` разом із `WIFEXITED` / `WEXITSTATUS` |
| `pipe` | `pipe()` з перевіркою помилки |
| `sigaction` | обробник сигналу через `sigaction` |
| `getopt` | цикл розбору опцій `getopt()` |
| `getline` | читання потоку по рядку зі звільненням буфера |
| `tcpserver` | `socket`, `SO_REUSEADDR`, `bind` і `listen` |

Повний список — у [`UltiSnips/c.snippets`](../../UltiSnips/c.snippets).

## Приклад

[`example-unix/pipeline.c`](../../example-unix/pipeline.c) сам виконує
`cmd1 | cmd2`: `pipe`, `fork`, `dup2`, `execlp`, `waitpid` і `getopt` для `-v`.

```bash
cd example-unix
make run         # ./pipeline -v ls wc: те саме, що ls | wc, плюс коди виходу
make asan        # перезбірка з AddressSanitizer і UBSan, потім запуск
make valgrind    # перевірка витоків і доступу до памʼяті
make strace      # виклики pipe/clone/dup2/execve/wait4 по процесах
```

На цій машині `make valgrind` показує 0 помилок і 0 байтів, зайнятих на виході.
`compile_flags.txt` у тій самій теці показує, як передати clangd прапорці без
жодної системи збірки.

## Дебаг процесів

`\dd ./pipeline` запускає gdb (див. [Гарячі клавіші](keybindings.md)). За
замовчуванням після `fork` gdb лишається з батьківським процесом. Щоб іти за
дочірнім, перед запуском введіть у вікні gdb:

```
set follow-fork-mode child
set detach-on-fork off
```

## Що встановити

Усе необовʼязкове; `make doctor` показує, що знайдено.

| Система | Команда |
|---------|---------|
| Debian / Ubuntu | `sudo apt install manpages-dev manpages-posix-dev valgrind strace` |
| Fedora | `sudo dnf install man-pages valgrind strace` |
| Arch / Manjaro | `sudo pacman -S man-pages valgrind strace` |
| openSUSE | `sudo zypper install man-pages valgrind strace` |
| Gentoo | `sudo emerge sys-apps/man-pages sys-apps/man-pages-posix dev-debug/valgrind dev-debug/strace` |
| macOS | man-сторінки вже є в системі. Замість Valgrind (його немає на Apple Silicon) — `make asan`, замість strace — `dtruss` |
