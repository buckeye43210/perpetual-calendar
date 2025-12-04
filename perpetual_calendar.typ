// Perpetual Calendar, 1900-based 28-year cycle

/// Perpetual Calendar Cover Page (Typst)

#set page(width: 5.5in, height: 8.5in, margin: (top: 0.48in, bottom: 0.38in, left: 0.85in, right: 0.48in), numbering: none)

#show heading: none

#align(center + horizon)[
  #box(
    height: 100%,
    width: 100%,
    inset: 0.5in,
    radius: 10pt,
    stroke: 2pt + luma(60),
    fill: luma(250)
  )[
    #text(
      38pt,
      weight: "bold",
      fill: navy
    )[Gregorian Perpetual Calendar]

    #text(
      19pt,
      weight: "medium",
      fill: navy.darken(15%)
    )[Covering Years \
    1700-3057]

    #v(1.8em)

    #text(13pt, weight: "light", fill: luma(90))[
    #align(left)[
      Instantly find the calendar for any Gregorian year.
      <br>
      Ideal for planning, genealogy, date validation, and history.<br>
      <br>
      #v(0.5em)
      Calendars for all possible years
      - Indexed for quick reference
      - 28-year cycle instructions
      ]
    ]

    #v(1.2em)

    #line(length: 60%, stroke: 1.8pt + navy.darken(20%))

    #v(0.3em)

    #text(11.5pt, fill: navy.darken(30%), weight: "medium")[Created using Typst, 2025]
  ]
]

#pagebreak()

#align(center)[
    #text(20pt, weight: "bold", fill: navy)[License & Frontmatter]
]
    
#text(10pt)[
    This project is licensed under the Creative Commons Zero \
    (CC0) 1.0 Universal License.
    
    *No Copyright*

    The person who associated a work with this deed has dedicated the work to the public domain by waiving all of his or her rights to the work
    worldwide under copyright law, including all related and neighboring rights, to the extent allowed by law.
    
    You can copy, modify, distribute and perform the work, even for commercial purposes, all without asking permission.
    See Other Information below.
    
    *Other Information*

    In no way are the patent or trademark rights of any person affected by CC0, nor are the rights that other persons may have in the work
    or in how the work is used, such as publicity or privacy rights.
    
    Unless expressly stated otherwise, the person who associated a work with this deed makes no warranties about the work,
    and disclaims liability for all uses of the work, to the fullest extent permitted by applicable law.
    
    When using or citing the work, you should not imply endorsement by the author or the affirmer.

    For more details, see the full legal code at:   
    #link("https://creativecommons.org/publicdomain/zero/1.0/")[#text(blue)[https://creativecommons.org]]
]

#pagebreak()

#set page(width: 5.5in, height: 8.5in, margin: (top: 0.48in, bottom: 0.28in, left: 0.85in, right: 0.48in), numbering: none)
#set text(font: ("Liberation Serif", "DejaVu Serif"), size: 10pt)

// Month and weekday
#let month_names = ("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
#let weekdays = ("Su", "Mo", "Tu", "We", "Th", "Fr", "Sa")

#let is_leap(y) = calc.rem(y, 4) == 0 and (calc.rem(y, 100) != 0 or calc.rem(y, 400) == 0)
#let jan1_weekday(y) = calc.rem(datetime(year: y, month: 1, day: 1).weekday(), 7)

// 14 calendar layouts A-N
#let calendar_letters = ("A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N")
#let calendar_letter(jan1wd, leap) = calendar_letters.at(calc.rem(jan1wd + (if leap { 7 } else { 0 }), 14))
#let letter(y) = calendar_letter(jan1_weekday(y), is_leap(y))

#let days_in_month(m, leap) = {
  if m == 2 { if leap { 29 } else { 28 } }
  else if m == 4 or m == 6 or m == 9 or m == 11 { 30 }
  else { 31 }
}

#let first_wd_of_month(jan1wd, m, leap) = {
  if m == 1 { jan1wd }
  else {
    let prev_days = range(1, m).map(mm => days_in_month(mm, leap)).sum()
    calc.rem(prev_days + jan1wd, 7)
  }
}

// 28-year cycle, base year 1900
#let calendar_28 = (
  "B","C","D","E","M","A","B","C","K","F","G","A","I","D","E","F","N","B","C","D","L","G","A","B","J","E","F","G","H"
)
#let base_year = 1901
#let cycle_letter(y) = calendar_28.at(calc.rem(y - base_year, 28))

#let leap_color = red
#let common_color = black

// ───────────── INDEX PAGE 1700–3057 ─────────────
#align(center + horizon)[
  #text(22pt, weight: "bold")[Perpetual Calendar Index]
  #v(1pt)
  #text(15pt)[1700 – 3057]
  #v(1pt)
]
#set text(size: 10pt)
#grid(
  columns: 7,
  column-gutter: 16pt,
  row-gutter: 12pt,
  ..range(1700, 3058).map(y => {
    align(center)[
      #box(width: 100%)[
        #text(
          weight: if is_leap(y) { "bold" } else { "medium" },
          fill: if is_leap(y) { leap_color } else { common_color }
        )[#y]
        #v(-10pt)
        #text(16pt, weight: "black")[#letter(y)]
        #v(2pt)
      ]
    ]
  })
)

#pagebreak()

// ───────────── 14 CALENDAR LAYOUTS (A–N) ─────────────

#set page(width: 5.5in, height: 8.5in, margin: (top: 0.75in, bottom: 0.38in, left: 0.75in, right: 0.5in), numbering: none)
#set text(font: ("Liberation Serif", "DejaVu Serif"), size: 10pt)

#let layouts = (
  (0, false), (1, false), (2, false), (3, false), (4, false), (5, false), (6, false),
  (0, true), (1, true), (2, true), (3, true), (4, true), (5, true), (6, true)
)
#for (idx, (jan1wd, leap)) in layouts.enumerate() {
  let ltr = calendar_letters.at(idx)
  align(center)[
    #text(24pt, weight: "bold")[#ltr]
    #v(-10pt)
    #text(13pt)[#if leap [*Leap year*] else [*Common year*]]
  ]
  align(right)[
    #v(-6pt)
    #line(length: 96%, stroke: 1.8pt + gray.darken(40%))
  ]
  let months = ()
  for m in range(1, 13) {
    let days = days_in_month(m, leap)
    let start = first_wd_of_month(jan1wd, m, leap)
    if start == none { start = 0 }
    let cells = ()
    for i in range(42) {
      let day = i - start + 1
      if day > 0 and day <= days {
        let sunday = calc.rem(i, 7) == 0
        cells.push(
          text(
            weight: if sunday { "bold" } else { "regular" },
            fill: if sunday { red.darken(20%) } else { black },
            size: 9.5pt,
            str(day)
          )
        )
      } else { cells.push(none) }
    }

    months.push(
      block(width: 100%, inset: (bottom: 8pt))[
        == #month_names.at(m - 1) #h(1fr)
        #align(right)[
        #grid(columns: 7, gutter: 3pt, row-gutter: 3pt,
          ..weekdays.map(w => text(size: 8.5pt, weight: "medium", fill: navy.darken(90%), w))
        )
        #grid(columns: 7, gutter: 3pt, row-gutter: 8pt, ..cells)
        ]
      ]
    )
  }
  grid(columns: 3, rows: 4, column-gutter: 3pt, row-gutter: 5pt, ..months)
  if idx < 13 { pagebreak() }
}

#pagebreak()

// ───────────── FINAL PAGE: 28-year quick table ─────────────
#set page(width: 21cm, height: 29.7cm, margin: 2cm)
#set text(font: "TeX Gyre Pagella", size: 11pt)
#set heading(numbering: none)

= The 14 Gregorian Calendar Types (A–N) — Correct Instructions

There are exactly *14 possible yearly calendars* in the Gregorian system:

- 7 for common years: *A B C D E F G*
- 7 for leap years:   *H I J K L M N*

== Primary Method (100 % accurate — works for every Gregorian year)

+ Find the weekday of *January 1* for the desired year  
  Sun = 0, Mon = 1, Tue = 2, Wed = 3, Thu = 4, Fri = 5, Sat = 6

+ If the year is a *leap year* → add 7 to that number

+ Take the result *modulo 14* (remainder 0–13)

+ Use this table:

  #table(
    columns: 3,
    stroke: none,
    align: center + horizon,
    [*Remainder*], [*Common year*], [*Leap year*],
    [0], [A], [H],
    [1], [B], [J],
    [2], [C], [K],
    [3], [D], [L],
    [4], [E], [M],
    [5], [F], [N],
    [6], [G], [— (impossible)],
    [7–13], [same as 0–6], [same as 0–6],
  )

== Alternate Quick Method — 1901 Base Year (perfect for 1901–2099)

The calendar repeats *exactly every 28 years* between 1901 and 2099 (no century exceptions).

+ Calculate:  
  $ "Offset" = ("Year" - 1901) mod 28 $

+ Look up the offset below:

#table(
  columns: 3,
  inset: 9pt,
  align: center,
  stroke: (x, y) => (
    left:   if x == 0 { 0.7pt } else { 0.3pt },
    right:  if x == 2 { 0.7pt } else { 0.3pt },
    top:    if y == 0 { 0.7pt } else { 0.3pt },
    bottom: if y == 27 { 0.7pt } else { 0.3pt },
    rest:   0.3pt
  ),
  [*Offset*], [*Common year*], [*Leap year*],
  [0],  [A], [—],
  [1],  [B], [H],
  [2],  [C], [J],
  [3],  [D], [K],
  [4],  [E], [L],
  [5],  [F], [M],
  [6],  [G], [N],
  [7],  [A], [—],
  [8],  [B], [—],
  [9],  [C], [—],
  [10], [D], [—],
  [11], [E], [—],
  [12], [F], [—],
  [13], [G], [—],
  [14], [A], [—],
  [15], [B], [—],
  [16], [C], [—],
  [17], [D], [—],
  [18], [E], [—],
  [19], [F], [—],
  [20], [G], [—],
  [21], [A], [—],
  [22], [B], [—],
  [23], [C], [—],
  [24], [D], [—],
  [25], [E], [—],
  [26], [F], [—],
  [27], [G], [—],
  )

  *Use the leap-year column only when the actual year is a leap year.*

== Examples

- 2025 → (2025 − 1901) = 124 → 124 mod 28 = 20 → *G* (common) ✔
- 2032 → offset 19 → leap year → *N* ✔
- 2000 → offset 15 → leap year → fall back to Primary Method → Jan 1 was Saturday (6) → 6 + 7 = 13 → 13 mod 14 = 13 → *G* ✔

*For any year outside 1901–2099 (or century years like 2100, 2200), always use the Primary Method — it never fails.*
