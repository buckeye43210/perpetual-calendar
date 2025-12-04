#set page(width: 5.5in, height: 8.5in, margin: (x: 0.38in, y: 0.48in), numbering: none)
#set text(font: ("Liberation Serif", "DejaVu Serif"), size: 10pt)

#let month-names = ("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
#let weekdays = ("Su","Mo","Tu","We","Th","Fr","Sa")

#let days-in-month(m, leap) = {
  if m == 2 { if leap {29} else {28} }
  else if m == 4 or m == 6 or m == 9 or m == 11 {30}
  else {31}
}

#let first-wd-of-month(jan1wd, m, leap) = {
  if m == 1 { jan1wd }
  else {
    let prev-days = range(1, m).map(mm => days-in-month(mm, leap and mm >= 2)).sum()
    calc.rem(prev-days + jan1wd, 7)
  }
}

#let is-leap(y) = calc.rem(y, 4) == 0 and (calc.rem(y, 100) != 0 or calc.rem(y, 400) == 0)

#let year-letter(y) = {
  let jan1-wd = datetime(year: y, month: 1, day: 1).weekday() - 1
  let offset = jan1-wd + (if is-leap(y) { 7 } else { 0 })
  str.from-unicode(65 + calc.rem(offset, 14))
}

// ──────────────────────────────
// INDEX 1900–2200 – letter directly UNDER each year
// ──────────────────────────────
#align(center + horizon)[
  #text(22pt, weight: "bold")[Perpetual Calendar Index]
  #v(6pt)
  #text(15pt)[1900 – 2200]
  #v(1fr)
]

#let is-leap(y) = calc.rem(y, 4) == 0 and (calc.rem(y, 100) != 0 or calc.rem(y, 400) == 0)

#let letter(y) = {
  let wd = calc.rem(datetime(year: y, month: 1, day: 1).weekday(), 7)  // 0=Sun…6=Sat
  let offset = wd + if is-leap(y) { 7 } else { 0 }
  str.from-unicode(65 + calc.rem(offset, 14))
}

#set text(size: 10.2pt)
#grid(
  columns: 7,
  column-gutter: 16pt,
  row-gutter: 22pt,
  ..range(1900, 2201).map(y => {
    align(center)[
      #box(width: 100%)[
        #text(weight: if is-leap(y) { "bold" } else { "medium" },
              fill: if is-leap(y) { red } else { black })[#y]
        #v(-10pt)
        #text(16pt, weight: "black")[#letter(y)]
      ]
    ]
  })
)

#pagebreak()

// ──────────────────────────────
// 2. THE 14 CALENDAR LAYOUTS (A through N)
// ──────────────────────────────
#let layouts = (
  (0,false),(1,false),(2,false),(3,false),(4,false),(5,false),(6,false),
  (0,true), (1,true), (2,true), (3,true), (4,true), (5,true), (6,true)
)

#for (idx, (jan1wd, leap)) in layouts.enumerate() {
  let letter = str.from-unicode(65 + idx)
  align(center)[
    #text(24pt, weight: "bold")[#letter]
    #v(-10pt)
    #text(13pt)[#if leap [*Leap year*] else [*Common year*]]
    #v(-6pt)
    #line(length: 100%, stroke: 1.8pt + gray.darken(40%))
  ]

  let months = ()
  for m in range(1,13) {
    let days = days-in-month(m, leap)
    let start = first-wd-of-month(jan1wd, m, leap)
    let cells = ()
    for i in range(42) {
      let day = i - start + 1
      if day > 0 and day <= days {
        let sunday = calc.rem(i, 7) == 0
        cells.push(
          text(weight: if sunday {"bold"} else {"regular"},
               fill: if sunday {red.darken(20%)} else {black},
               size: 9.5pt,
               str(day))
        )
      } else { cells.push(none) }
    }
    months.push(
      block(width: 100%, inset: (bottom: 8pt))[
        == #month-names.at(m - 1) #h(1fr)
        #grid(columns: 7, gutter: 3pt,
          ..weekdays.map(w => text(size: 8pt, weight: "medium", fill: gray.darken(30%), w))
        )
        #align(right)[ #grid(columns: 7, gutter: 3pt, row-gutter: 5pt, ..cells) ]
      ]
    )
  }
  grid(columns: 4, rows: 3, column-gutter: 12pt, row-gutter: 10pt, ..months)
  if idx < 13 { pagebreak() }
}

#pagebreak()
// ──────────────────────────────
// FINAL PAGE – beautiful 8-column 28-year quick table
// ──────────────────────────────
#align(center + horizon)[
  #text(14pt, weight: "bold")[How to use this perpetual calendar]
  #v(0.5em)

  #set text(10.8pt)
  #box(width: 94%, inset: 10pt, radius: 8pt, stroke: 1.2pt + luma(130))[
    #set par(justify: true, leading: 0.7em)
    #align(left)[
    There are only *14 possible calendars* (A–N) in the Gregorian system.

    To find the correct page for any year:
    1. Determine weekday of *Jan 1* that year (Sun=0, Mon=1 … Sat=6)  
    2. If the year is a leap year → add 7  
    3. Take the result mod 14 → number = letter (0=A, 1=B … 13=N)

    #v(1em)
    *28-year cycle table* (repeats forever, except century-skip years)
    ]
    
    #table(
      columns: 8,
      inset: 9pt,
      stroke: none,
      column-gutter: 10pt,
      row-gutter: 6pt,
      table.header(
        [*mod28*],[*Ltr*],[*mod28*],[*Ltr*],
        [*mod28*],[*Ltr*],[*mod28*],[*Ltr*],
      ),
      "0",  "D",  "7",  "L",  "14", "G",  "21", "G",
      "1",  "E",  "8",  "G",  "15", "H",  "22", "H",
      "2",  "F",  "9",  "A",  "16", "C",  "23", "J",
      "3",  "N", "10",  "B",  "17", "D",  "24", "K",
      "4",  "B", "11",  "J",  "18", "E",  "25", "L",
      "5",  "C", "12",  "E",  "19", "K",  "26", "M",
      "6",  "D", "13",  "F",  "20", "F",  "27", "N",
    )

    #v(0.5em)
    *Examples*
    #align(left)[
    - 2025 → mod 28 = 0 → letter *D*  
    - 2036 → mod 28 = 11 → letter *J*  
    - 2100 → not leap → Jan 1 = Tuesday (2) → letter *C*  
    - 2000 → leap → Jan 1 = Saturday (6) → 6+7 = 13 → letter *N*
    ]
  ]
]