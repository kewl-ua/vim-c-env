#!/usr/bin/env python3
# SPDX-License-Identifier: GPL-3.0-or-later
"""Animated README hero: Vim in the centre, vim-c-env components arrive above
and below. Writes assets/hero.gif and assets/social-preview.png (last frame).
Needs rsvg-convert and ffmpeg; brand icons come from cdn.simpleicons.org."""
import math, os, re, subprocess, shutil, tempfile, urllib.request

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
WORK = tempfile.mkdtemp(prefix="vce-hero-")
W, H, FPS, DUR = 1280, 640, 15, 11.5
N = int(FPS * DUR)

BG, CARD, EDGE, FG, MUTED = "#1d2021", "#282828", "#3c3836", "#ebdbb2", "#a89984"
SANS, MONO = "DejaVu Sans", "DejaVu Sans Mono"

ICON = {}
for s in ["vim", "llvm", "nodedotjs", "gnu", "git", "neovim", "linux", "arm"]:
    req = urllib.request.Request(f"https://cdn.simpleicons.org/{s}", headers={"User-Agent": "vim-c-env/make-hero"})
    svg = urllib.request.urlopen(req).read().decode()
    ICON[s] = re.search(r' d="([^"]+)"', svg).group(1)

TOP = [("clangd", "completion · go-to", "llvm", "#83a598"),
       ("coc.nvim", "LSP client", "nodedotjs", "#8ec07c"),
       ("Snippets", "main · for · guard", "{}", "#fabd2f"),
       ("Build", "make → quickfix", "play", "#fe8019"),
       ("Debugger", "gdb · Termdebug", "gnu", "#d3869b")]
BOT = [("Git", "fugitive · gitgutter", "git", "#fb4934"),
       ("Files", "NERDTree · fzf", "folder", "#b8bb26"),
       ("Neovim", "same config", "neovim", "#8ec07c"),
       ("UNIX", "man · POSIX · strace", "linux", "#83a598"),
       ("Embedded", "STM32 · ESP32", "arm", "#d3869b")]

XS = [150, 395, 640, 885, 1130]
CW, CH = 232, 80
TOP_Y, BOT_Y = 34, 526
HX, HY, HW, HH = 440, 182, 400, 276
ATT = [512, 576, 640, 704, 768]

# arrival order alternates top / bottom
ORDER = []
for i in range(5):
    ORDER += [("top", i), ("bot", i)]
T0, STEP = 1.2, 0.42
START = {key: T0 + n * STEP for n, key in enumerate(ORDER)}
T_TITLE = T0 + 9 * STEP + 0.75
T_SLOGAN = T_TITLE + 1.1


def clamp(x): return max(0.0, min(1.0, x))
def ease(x): x = clamp(x); return 1 - (1 - x) ** 3
def prog(t, start, dur): return ease((t - start) / dur)


def bezier_len(p0, p1, p2, p3, n=40):
    pts = [tuple(((1 - u) ** 3) * a + 3 * ((1 - u) ** 2) * u * b + 3 * (1 - u) * u * u * c + u ** 3 * d
                 for a, b, c, d in zip(p0, p1, p2, p3)) for u in (i / n for i in range(n + 1))]
    return sum(math.dist(pts[i], pts[i + 1]) for i in range(n))


def glyph(kind, x, y, s, color):
    """Icon box of size s at (x, y)."""
    if kind in ICON:
        k = s / 24
        return f'<path transform="translate({x} {y}) scale({k})" d="{ICON[kind]}" fill="{color}"/>'
    if kind == "{}":
        return (f'<text x="{x + s / 2}" y="{y + s * 0.78}" font-family="{MONO}" font-weight="bold" '
                f'font-size="{s * 0.82}" text-anchor="middle" fill="{color}">{{}}</text>')
    if kind == "play":
        return f'<polygon points="{x + s * .2},{y + s * .12} {x + s * .9},{y + s / 2} {x + s * .2},{y + s * .88}" fill="{color}"/>'
    if kind == "folder":
        return (f'<path d="M{x} {y + s * .2} h{s * .38} l{s * .1} {s * .12} h{s * .52} v{s * .62} h-{s} z" '
                f'fill="{color}"/>')
    return ""


def card(label, sub, icon, color, cx, y, opacity, dy):
    x = cx - CW / 2
    return (f'<g opacity="{opacity:.3f}" transform="translate(0 {dy:.1f})">'
            f'<rect x="{x}" y="{y}" width="{CW}" height="{CH}" rx="12" fill="{CARD}" '
            f'stroke="{color}" stroke-opacity="0.85" stroke-width="1.6"/>'
            + glyph(icon, x + 16, y + 21, 36, color) +
            f'<text x="{x + 64}" y="{y + 35}" font-family="{SANS}" font-weight="bold" font-size="18" fill="{FG}">{label}</text>'
            f'<text x="{x + 64}" y="{y + 58}" font-family="{SANS}" font-size="13" fill="{MUTED}">{sub}</text>'
            '</g>')


def connector(cx, y0, hx, y1, color, p):
    mid = (y0 + y1) / 2
    pts = ((cx, y0), (cx, mid), (hx, mid), (hx, y1))
    L = bezier_len(*pts)
    d = f"M{cx} {y0} C{cx} {mid} {hx} {mid} {hx} {y1}"
    out = (f'<path d="{d}" fill="none" stroke="{color}" stroke-width="2.4" stroke-linecap="round" '
           f'stroke-dasharray="{L:.1f}" stroke-dashoffset="{L * (1 - p):.1f}"/>')
    if p >= 1:
        out += f'<circle cx="{hx}" cy="{y1}" r="4.5" fill="{color}"/>'
    return out


def frame(t):
    o = [f'<svg xmlns="http://www.w3.org/2000/svg" width="{W}" height="{H}" viewBox="0 0 {W} {H}">',
         '<defs><pattern id="dots" width="32" height="32" patternUnits="userSpaceOnUse">'
         f'<circle cx="2" cy="2" r="1.2" fill="{EDGE}"/></pattern></defs>',
         f'<rect width="{W}" height="{H}" fill="{BG}"/><rect width="{W}" height="{H}" fill="url(#dots)"/>']

    # connectors first, so cards and hub sit on top of them
    for (row, i), st in START.items():
        lab, sub, ic, col = (TOP if row == "top" else BOT)[i]
        p = prog(t, st + 0.25, 0.35)
        if p > 0:
            if row == "top":
                o.append(connector(XS[i], TOP_Y + CH, ATT[i], HY, col, p))
            else:
                o.append(connector(XS[i], BOT_Y, ATT[i], HY + HH, col, p))

    # hub
    hp = prog(t, 0.0, 0.8)
    s = 0.92 + 0.08 * hp
    o.append(f'<g opacity="{hp:.3f}" transform="translate(640 320) scale({s:.3f}) translate(-640 -320)">')
    o.append(f'<rect x="{HX}" y="{HY}" width="{HW}" height="{HH}" rx="20" fill="{CARD}" stroke="{EDGE}" stroke-width="2"/>')
    for (row, i), st in START.items():         # glow in the arriving card's colour
        g = clamp(1 - abs(t - (st + 0.6)) / 0.45)
        if g > 0:
            col = (TOP if row == "top" else BOT)[i][3]
            o.append(f'<rect x="{HX}" y="{HY}" width="{HW}" height="{HH}" rx="20" fill="none" '
                     f'stroke="{col}" stroke-opacity="{g:.3f}" stroke-width="{2 + 3 * g:.2f}"/>')
    fin = prog(t, T_TITLE, 0.6)
    if fin > 0:
        o.append(f'<rect x="{HX}" y="{HY}" width="{HW}" height="{HH}" rx="20" fill="none" '
                 f'stroke="#b8bb26" stroke-opacity="{fin:.3f}" stroke-width="3"/>')
    k = 104 / 24
    o.append(f'<path transform="translate({640 - 52} {206}) scale({k})" d="{ICON["vim"]}" fill="#019733"/>')
    vim_op = 1 - prog(t, T_TITLE - 0.3, 0.35)
    o.append(f'<text x="640" y="366" font-family="{SANS}" font-weight="bold" font-size="30" '
             f'text-anchor="middle" fill="{FG}" opacity="{vim_op:.3f}">Vim</text>')
    if fin > 0:
        o.append(f'<text x="640" y="358" font-family="{MONO}" font-weight="bold" font-size="34" '
                 f'text-anchor="middle" fill="#fe8019" opacity="{fin:.3f}">vim-c-env</text>'
                 f'<text x="640" y="388" font-family="{SANS}" font-size="17" text-anchor="middle" '
                 f'fill="{MUTED}" opacity="{fin:.3f}">Vim as a C/C++ IDE</text>')
    slo = prog(t, T_SLOGAN, 0.7)
    if slo > 0:
        o.append(f'<line x1="520" y1="406" x2="760" y2="406" stroke="{EDGE}" stroke-width="1.5" opacity="{slo:.3f}"/>'
                 f'<text x="640" y="436" font-family="{SANS}" font-weight="bold" font-size="16" '
                 f'text-anchor="middle" opacity="{slo:.3f}">'
                 f'<tspan fill="#b8bb26">Good for system.</tspan> <tspan fill="#fe8019">Fine for embedded.</tspan></text>')
    o.append('</g>')

    # cards
    for (row, i), st in START.items():
        lab, sub, ic, col = (TOP if row == "top" else BOT)[i]
        p = prog(t, st, 0.4)
        if p > 0:
            dy = (-60 if row == "top" else 60) * (1 - p)
            o.append(card(lab, sub, ic, col, XS[i], TOP_Y if row == "top" else BOT_Y, p, dy))

    o.append('</svg>')
    return "".join(o)


if __name__ == "__main__":
    fdir = f"{WORK}/frames"
    os.makedirs(fdir)
    for n in range(N):
        svg = f"{fdir}/f{n:04d}.svg"
        open(svg, "w").write(frame(n / FPS))
        subprocess.run(["rsvg-convert", "-w", str(W), "-h", str(H), svg, "-o", f"{fdir}/f{n:04d}.png"], check=True)
    shutil.copy(f"{fdir}/f{N - 1:04d}.png", f"{REPO}/assets/social-preview.png")
    subprocess.run(["ffmpeg", "-v", "error", "-y", "-framerate", str(FPS), "-i", f"{fdir}/f%04d.png", "-vf",
                    "scale=960:-1:flags=lanczos,split[a][b];[a]palettegen=max_colors=160:stats_mode=diff[p];"
                    "[b][p]paletteuse=dither=bayer:bayer_scale=4:diff_mode=rectangle",
                    "-loop", "0", f"{REPO}/assets/hero.gif"], check=True)
    shutil.rmtree(WORK)
    print("wrote assets/hero.gif and assets/social-preview.png")
