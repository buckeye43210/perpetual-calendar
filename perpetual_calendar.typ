// Perpetual Calendar, 1900-based 28-year cycle

/// Perpetual Calendar Cover Page (Typst)

#set page(width: 5.5in, height: 8.5in, margin: (x: 0.5in, y: 0.7in), numbering: none)

#show heading: none

#align(center + horizon)[
  #box(
    width: 88%,
    inset: 0.5in,
    radius: 10pt,
    stroke: 2pt + luma(60),
    fill: luma(250)
  )[
    #text(
      38pt,
      weight: "bold",
      fill: navy
    )[Perpetual Calendar]

    #v(18pt)

    #text(
      19pt,
      weight: "medium",
      fill: navy.darken(15%)
    )[Covering Gregorian Years \
    1900-2300]

    #v(1.8em)

    #text(
      13pt,
      weight: "light",
      fill: luma(90)
    )[
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
    
    #v(1em)

    #line(length: 45%, stroke: 0.7pt + luma(120))

    #v(0.3em)
    #align(left)[
    #text(10.5pt, fill: luma(80), weight: "light")[
      This work is dedicated to the public domain under the
      <br>
      #link("https://creativecommons.org/publicdomain/zero/1.0/")[
        Creative Commons Zero (CC0 1.0) license
      ].
      <br>
      You may freely share, remix, adapt, and use it for any purpose, even commercially, with no restrictions.
      ]]
  ]
]

#set page(width: 5.5in, height: 8.5in, margin: (top: 0.48in, bottom: 0.38in, left: 0.85in, right: 0.48in), numbering: none)
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
#let base_year = 1900
#let cycle_letter(y) = calendar_28.at(calc.rem(y - base_year, 28))

#let leap_color = red
#let common_color = black

// ───────────── INDEX PAGE 1900–2200 ─────────────
#align(center + horizon)[
  #text(22pt, weight: "bold")[Perpetual Calendar Index]
  #v(6pt)
  #text(15pt)[1900 – 2200]
  #v(1fr)
]
#set text(size: 10.2pt)
#grid(
  columns: 7,
  column-gutter: 16pt,
  row-gutter: 22pt,
  ..range(1900, 2201).map(y => {
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
    #v(-6pt)
    #line(length: 100%, stroke: 1.8pt + gray.darken(40%))
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
        #grid(
          columns: 7,
          gutter: 3pt,
          ..weekdays.map(w => text(size: 8pt, weight: "medium", fill: gray.darken(30%), w))
        )
        #align(left)[
          #grid(columns: 7, gutter: 3pt, row-gutter: 5pt, ..cells)
        ]
      ]
    )
  }
  grid(columns: 3, rows: 4, column-gutter: 3pt, row-gutter: 5pt, ..months)
  if idx < 13 { pagebreak() }
}

#pagebreak()

// ───────────── FINAL PAGE: 28-year quick table ─────────────
#align(center + horizon)[
  #text(14pt, weight: "bold")[How to use this perpetual calendar]
  #v(0.5em)
  #set text(10.8pt)
  #box(width: 94%, inset: 10pt, radius: 8pt, stroke: 1.2pt + luma(130))[
    #set par(justify: true, leading: 0.7em)
    #align(left)[
      The Gregorian system only has *14 possible calendars* (A–N).

      To find the correct calendar for any year:
      1. Determine *Jan 1* weekday for that year \
         (Sun=0, Mon=1, Tue=2, Wed=3 … Sat=6)
      2. If it's a leap year → add 7
      3. Resulting number maps to letter (0=A … 13=N)

      #v(.5em)
      *28-year cycle* (repeats forever, except century-skip years)\
      *Base year: 1900. Letter Index = (Year - 1900) mod 28*\
      *For century-skip years: Use weekday method.*
    ]
    #table(
      columns: 8,
      inset: 3pt,
      stroke: none,
      column-gutter: 6pt,
      row-gutter: 1pt,
      table.header(
        [*Mod28*],[*Ltr*],[*Mod28*],[*Ltr*],
        [*Mod28*],[*Ltr*],[*Mod28*],[*Ltr*],
      ),
      "0",  "B",  "7",  "C",  "14", "E",  "21", "G",
      "1",  "C",  "8",  "K",  "15", "F",  "22", "A",
      "2",  "D",  "9",  "F",  "16", "N",  "23", "B",
      "3",  "E", "10",  "G",  "17", "B",  "24", "J",
      "4",  "M", "11",  "A",  "18", "C",  "25", "E",
      "5",  "A", "12",  "I",  "19", "D",  "26", "F",
      "6",  "B", "13",  "D",  "20", "L",  "27", "G",
    )
    #v(0.5em)
    *Examples*
    #align(left)[
      - 2026 → index: 2026-1900=126, mod 28 = 14 → letter E
      - 2000 → index: 2000-1900=100, mod 28 = 16 → letter N
      - 2025 → index: 2025-1900=125, mod 28 = 13 → letter D
    ]
  ]
]