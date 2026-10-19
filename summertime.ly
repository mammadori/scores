% Impostazioni generali di LilyPond e dimensione del pentagramma.
\version "2.24.3"
\pointAndClickOff
#(set-global-staff-size 17)

% Disegna il mini barrè con una parentesi e un solo numero di dito.
#(define (mini-barre-fingering grob)
 (let* ((bracket (ly:arpeggio::brew-chord-bracket grob))
        (ext (ly:stencil-extent bracket Y))
        (digit (grob-interpret-markup grob (markup #:fontsize -3.5 "1")))
        (digit (ly:stencil-aligned-to digit Y CENTER))
        (digit (ly:stencil-translate-axis digit (/ (+ (car ext) (cdr ext)) 2) Y)))
   (ly:stencil-combine-at-edge bracket X LEFT digit 0.35)))

% T: pollice della mano sinistra; il richiamo compare soltanto nella TAB.
thumb = \tag #'tabOnly \tweak stencil #ly:text-interface::print
        _\markup { \fontsize #-2 "T" }

% Dispone le diteggiature a sinistra anche sulle note singole.
% Mantiene sulle note i numeri delle dita, separando gli altri segni musicali.
#(define (place-left-hand-fingers music)
   (let ((name (ly:music-property music 'name)))
     (cond
      ((eq? name 'EventChord) music)
      ((and (eq? name 'NoteEvent)
            (any (lambda (event)
                   (eq? (ly:music-property event 'name) 'FingeringEvent))
                 (ly:music-property music 'articulations)))
       (let* ((articulations (ly:music-property music 'articulations))
              (note-event?
               (lambda (event)
                 (memq (ly:music-property event 'name)
                       '(FingeringEvent StringNumberEvent StrokeFingerEvent))))
              (fingers (filter note-event? articulations))
              (scripts (remove note-event? articulations)))
         (ly:music-set-property! music 'articulations fingers)
         (make-music 'EventChord
           'origin (ly:music-property music 'origin)
           'elements (cons music scripts))))
      (else
       (let ((element (ly:music-property music 'element))
             (elements (ly:music-property music 'elements)))
         (if (ly:music? element)
             (ly:music-set-property! music 'element
               (place-left-hand-fingers element)))
         (if (pair? elements)
             (ly:music-set-property! music 'elements
               (map place-left-hand-fingers elements))))
       music))))
leftHandLayout = #(define-music-function (music) (ly:music?)
                   (place-left-hand-fingers music))

% Segno a U per il vibrato lento e intenso
vibratoLento = \tag #'staffOnly \tweak stencil #ly:text-interface::print
               \tweak direction #UP
               \tweak padding #1
               \tweak staff-padding #2
               \tweak outside-staff-priority #400
               ^\markup { \path #0.15 #'((moveto 0 0.6)
                                         (curveto 0 -0.2 1.2 -0.2 1.2 0.6)) }

% Abbreviazione per le lettere p, i, m, a della mano destra.
#(define rh rightHandFinger)
% Assegna la corda alla TAB senza stampare il numero cerchiato sul pentagramma.
tabString = #(define-event-function (number) (integer?)
 (make-music 'StringNumberEvent 'string-number number
  'tweaks '((transparent . #t))))
% Indicazione di barrè con linea orizzontale e stanghetta finale verso il basso.
barre = #(define-music-function (label) (string?)
 #{
  \once \override TextSpanner.font-size = #-2
  \once \override TextSpanner.font-shape = #'upright
  \once \override TextSpanner.staff-padding = #4
  \once \override TextSpanner.style = #'line
  \once \override TextSpanner.to-barline = ##f
  \once \override TextSpanner.bound-details.left.text = \markup { #label }
  \once \override TextSpanner.bound-details.right.text = \markup { \draw-line #'(0 . -0.5) }

  % Al cambio di rigo continua solo la linea, senza ripetere il testo.
  \once \override TextSpanner.bound-details.left-broken.text = ##f
  \once \override TextSpanner.bound-details.left-broken.padding = #0
  \once \override TextSpanner.bound-details.right-broken.text = ##f
  \once \override TextSpanner.bound-details.right-broken.padding = #0
 #})
% Nella TAB nasconde il numero di tasto sulla seconda nota di una legatura di valore.
#(define (tie::tab-clear-tied-fret-numbers grob)
 (ly:grob-set-property! (ly:spanner-bound grob RIGHT) 'transparent #t))

% Testi delle due note esecutive richiamate nello spartito.
notaUnoTesto = \markup \wordwrap-string #"La percussione all’inizio della pausa si ottiene appoggiando con forza p, i, m sulle corde n. 6, 5 e 4, in modo che battano contro la tastiera."
notaDueTesto = \markup \wordwrap-string #"La parte che segue è uguale alla prima parte del brano (e per questo priva della diteggiatura), ma con delle variazioni in alcune battute. Tali variazioni si riconoscono dalla presenza della diteggiatura."

% Titolo e crediti.
\header {
 title = "Summertime"
 subtitle = "G. Gershwin"
 enteredby="Marco Amadori"
 maintainer="marco.amadori@gmail.com"
 arranger = "Trascrizione e arrangiamento per chitarra di G.Unterberger"
 tagline = ##f
}
% Formato della pagina, margini e numero massimo di sistemi per pagina.
\paper {
 #(set-paper-size "a4")
 top-margin = 12\mm bottom-margin = 12\mm
 left-margin = 14\mm right-margin = 14\mm
 ragged-last-bottom = ##t
 max-systems-per-page = 5
 print-page-number = ##t
}
% Regole comuni per la disposizione di pentagramma e tablatura.
\layout {
 indent = 0\mm
 \context { \Score \override BarNumber.break-visibility = ##(#f #f #t) }
 % Dita della sinistra a lato delle note; lettere della destra sopra il pentagramma.
 \context { \Staff
  \consists "Span_arpeggio_engraver"
  connectArpeggios = ##f

  \override Arpeggio.script-priority = #150
  \override StringNumber.stencil = ##f

  \override Fingering.add-stem-support = ##f
  \override Fingering.font-size = #-3.5
  \override Fingering.padding = #0.6
  \override StringNumber.add-stem-support = ##t
  \override StrokeFinger.add-stem-support = ##t
  \override StrokeFinger.avoid-slur = #'outside
  \override StrokeFinger.font-size = #-3
  \override StrokeFinger.padding = #0.8
  \override StrokeFinger.staff-padding = #2.5
  \override StrokeFinger.outside-staff-priority = #250
  fingeringOrientations = #'(left)
  stringNumberOrientations = #'(down)
  strokeFingerOrientations = #'(up)
 }
 % TAB essenziale: numeri dei tasti e slide, senza duplicare diteggiature e barrè.
 \context { \TabStaff
  \override Fingering.stencil = ##f
  \override StrokeFinger.stencil = ##f
  \override StringNumber.stencil = ##f
  \override TextSpanner.stencil = ##f
  \override Arpeggio.stencil = ##f
  \override Stem.transparent = ##t
  \override Flag.transparent = ##t
  \override Beam.transparent = ##t
  \override Tie.after-line-breaking = #tie::tab-clear-tied-fret-numbers
 }
 \context { \TabVoice
  \override StrokeFinger.avoid-slur = #'inside
  \override Tie.stencil = ##f \override Slur.stencil = ##f
 }

}

% Prima sezione: voce superiore, con melodia e bicordi.
upperOneTwo = {
\partial 2 r8 r4 r8 |
r4 \barre #"5/6 B II" \once \override TextSpanner.bound-details.right.padding = #2 \tag #'staffOnly { \once \override Arpeggio.stencil = #mini-barre-fingering } <b\5-\rh #"i" e'\4-\rh #"m">8\arpeggio\startTextSpan~ <b\5 e'\4>4. \mark \markup \box "Nota 1" d'4.\4\stopTextSpan r4^\markup { \italic "perc." } r8 |
e'4.-3\4 r4^\markup { \italic "perc." } a'8-3\4-\rh #"m"~ a'4 es'8-1\5-\rh #"i"( \tag #'tabOnly \glissando e'4\5) g'8\3-\rh #"a"~ | \break
g'4 e'8-3\4 r4 r8 d'4.\4 r4^\markup { \italic "perc." } r8 |
e'4.-3\4 r4 a'8-3\4-\rh #"m"~ a'4 a'8-3\4-\rh #"m"( \tag #'tabOnly \glissando b'4\4) g'8\3-\rh #"a"~ | \break
g'4 e'8-3\4-\rh #"m" r4 r8 d'4.\4 r4^\markup { \italic "perc." } r8 |
e'4.-3\4 r4 \set Staff.connectArpeggios = ##t <a'\4-\rh #"m" d''\3-\rh #"a">8\arpeggio->~ \set Staff.connectArpeggios = ##f <a'\4 d''\3>4. c''4-1\3-\rh #"m" b'8\2-\rh #"a"~ | \break
b'4\2 e'8-3\4-\rh #"m" r8 r4 d'4.\4 r4^\markup { \italic "perc." } r8 |
des'4-1-\tabString #5 -\rh #"a" \acciaccatura { g'8-3\4-\rh #"m"( \tag #'tabOnly \glissando } a'8\4)~ a'4 g'8\3-\rh #"a" a'4-3\4-\rh #"m"( \tag #'tabOnly \glissando b'8\4) g'4\3-\rh #"a" e'8-3\4-\rh #"m"~ | \break
e'4 b8-2\5-\rh #"i"~ b8 r4 d'4.\4 r4 r8 |
e'4.-3\4 r4 r8 b'4\2-\rh #"m" bes'8-2\3~ bes'4 a'8-2\3~ | \break
a'4 a'8-2-\tabString #3 c''4-1-\tabString #2 \acciaccatura { d''8-3-\tabString #2( \tag #'tabOnly \glissando } dis''8-\tabString #2)\vibratoLento ~ \tuplet 4/6 { dis''16-\tabString #2[ d''16-3-\tabString #2 c''16-1-\tabString #2 a'16-2\3] } c''4-1-\tabString #2 -\rh #"m" a'8-2-\tabString #3 -\rh #"i"~ |
a'4-\tabString #3 g'8\3 e'4-2-\tabString #4 -\rh #"i" r8 g'4\3-\rh #"m" a'8-3\3-\rh #"m"( g'4\3) f'8-4-\tabString #4 -\rh #"i"( | \break
fis'4-\finger #"4t"-\tabString #4) b'8-\tabString #2 -\rh #"a"~ b'4. fis'4.-\finger #"4t"-\tabString #4 fis'4-4-\tabString #4 fis'8-4-\tabString #4 ~ |
fis'4. r4 e''16-2\3[ g''16-1\2] d'''4.-3\1 c'''4-1\1 a''8-3\2( \tag #'tabOnly \glissando | \break
b''4.-3\2)\vibratoLento r4^\markup { \italic "perc." } r8 d'4.\4 r4^\markup { \italic "perc." } r8 |
des'4-1-\tabString #5 -\rh #"i" \acciaccatura { g'8-3\4-\rh #"m"( \tag #'tabOnly \glissando } a'8\4)~ a'4 g'8\3-\rh #"a" a'4-3\4-\rh #"m"( \tag #'tabOnly \glissando b'8\4) g'4\3-\rh #"a" e'8-3\4-\rh #"m"~ | \break
e'4 b8-2\5-\rh #"i"~ b8 r4 d'4\4-\rh #"m"( e'8-1-\tabString #4 ) g'4\3-\rh #"a" e'8-3\4-\rh #"m"~ |
e'4 b8-1\5-\rh #"i"~ b8 r8 r8 b'4.-\tabString #2 -\rh #"m" g'4-\tabString #3 -\rh #"i" a'8-\finger #"2t"-\tabString #3 ~ | \break
a'4 <d'\4-\rh #"i" a'-2\3-\rh #"m">8~ <dis'-1\4 a'\3>8~[ <d'\4 a'\3>8 c'8-3-\tabString #5 -\rh #"p"] <d'\4-\rh #"i" a'-2\3-\rh #"m">4. <dis'-1\4 a'\3>4 \acciaccatura d'8-1-\tabString #5 <e' a'-2-\tabString #3 >8 |
r4 g'8-\tabString #3 -\rh #"m"~ g'4 e'8-\finger #"2t"-\tabString #4 -\rh #"i" g'4-\tabString #3 e'8-\finger #"2t"-\tabString #4 -\rh #"i" g'4-\tabString #3 <b-1\5 e'-2\4>8~ | \break
<b\5 e'\4>2. d'8\4-\rh #"i" r4 dis'4 e'8~ |
e'2. r4 r8 r4 r8 | \break
r4 <b-1\5-\rh #"i" e'-1\4-\rh #"m">8( <cis'-3\5 fis'-4\4>4) r8 g'4-\tabString #3 -\rh #"a" fis'8-3\4-\rh #"m"~ fis'4. |
e'4.-3-\tabString #4 -\rh #"m" d'4-\tabString #4 -\rh #"m" b8-\finger #"3t"\5-\rh #"i"~ b2. |
}

% Prima sezione: bassi e accompagnamento.
lowerOneTwo = {
\partial 2 e8\6( g8-2\6 gis8-3\6 b8-1\5) |
e2. g4.-2\6 r4 r8 |
<fis-2\6 bes-1\5>4. r4 <b-2\6-\rh #"p" es'-1\5-\rh #"i">8~ <b\6 es'\5>4 r8 r4 r8 |
e4. e4.-> g4.-2\6 r4 r8 |
<fis-2\6 bes-1\5>4. r4 <b-2\6-\rh #"p" es'-1\5-\rh #"i">8~ <b\6 es'\5>4 r8 r4 r8 |
e4. e4. g4.-2\6 r4 r8 |
<fis-2\6 bes-1\5>4. r4 <b-2\6-\rh #"p" es'-1\5-\rh #"i">8\arpeggio~ <b\6 es'\5>4. r4 r8 |
e4. e8-> r4 g4.-2\6 r4 r8 |
a4-2\6 r8 r4 r8 <b-2\6-\rh #"p" es'-1\5-\rh #"i">4. r8 r4 |
e4. e8 r4 g4.-2\6 r4 r8 |
<e\6 b-2\5>4. r4 g8-3\6~ g4\6 r8 gis4-3\6 r8 |
a2. fis2.\6\thumb |
a4.\5~ a4\5 ais8-1\5 ~ ais4.\5~ ais4\5 ais8-1\5( |
b4.-1\5) fis4.-1\6 a4.-0\5 ais4-1\5 b8-1\5 ~ |
b4.\5 r4 r8 r4 r8 r4 r8 |
e4. r4 r8 g4.-2\6 r4 r8 |
a4-2\6 r8 r4 r8 <b-2\6-\rh #"p" es'-1\5-\rh #"i">4 r8 r4 r8 |
e4. e8 r4 g4.-2\6 r4 r8 |
e4. e8 r8 g8-3\6 ~ g4\6 gis8-3\6 ~ gis4\6 r8 |
a4.-\tabString #5 ~ a4 s8 r4 a8-\tabString #5 -\rh #"p"~ a4. |
r4 a8-\tabString #5 -\rh #"p"~ a4. ais4.-1-\tabString #5 c'4-3-\tabString #5 s8 |
r4 e8-\tabString #6 -\rh #"p"~ e4. a8-0\5-\rh #"p" r4 ais4\5 b8\5~ |
b2.\5 r4 e8( g8-2-\tabString #6 gis8-3-\tabString #6 b8-1-\tabString #5 ) |
e4.~ e4 g8-2-\tabString #6 ~ g4 r8 gis4.-2-\tabString #6 |
a4.-\tabString #5 ais4-1-\tabString #5 r8 fis4.-2-\tabString #6 f4.-1-\tabString #6 |
}

% Sezione centrale e avvio della ripresa: voce superiore.
upperThree = {
\break
r4 \barre #"2/6 B V" <d'-1\5 g'-1\4>8\startTextSpan~ <d' g'>4\stopTextSpan r8 <e'-3\5 a'-4\4>4. r4 r8 |
<fis'-3\5 ais'-2\4>4.~ <fis' ais'>4 <fis'-3\5 b'-4\4>8~ <fis' b'>4. dis''4-2\3( \glissando e''8\3) | \break
r4 g''8-1\2 a''8-3\2 r8 e''8-3\2( \tuplet 4/6 { eis''16-3\2\vibratoLento e''16-3\2 d''16-1\2 b'16-2\3) } d''4-1-\tabString #2 e''8-\tabString #1 |
\acciaccatura <a''-3\2 c'''-\finger #"4t"\1>8 <ais''-3\2 d'''-4\1>4\vibratoLento <g''-1\2 d'''-4\1>8( <a''-3\2 d'''-\finger #"4t"\1>4) e''8-2\3 <g''-1\2 d'''-4\1>4 <a''-3\2 d'''-4\1>8 r4 <a'-4\3-\rh #"i" e''\1-\rh #"a">8~ | \break
<a' e''>4( <g'-\tabString #3 e''>8) <a'-1-\tabString #3 e''>4 b'8-\tabString #2 <a'-1-\tabString #3 e''>4( <g'-\tabString #3 e''>8) <e'-1-\tabString #4 b'-\tabString #2 >4( <d'-\tabString #4 b'>8) |
<e'-4-\tabString #4 b'-\tabString #2 >4 <e' b'>8 r4 <e'-3-\tabString #4 b'>8~ <e' b'>4 r8 r4 r8 | \break
\mark \markup \box "Nota 2" r4 <b-1\5 e'-1\4>8~ <b\5 e'\4>4. d'4.\4 r4^\markup { \italic "perc." } r8 |
e'4. r4^\markup { \italic "perc." } <es'\5 a'\4>8~ <es'\5 a'\4>4 es'8\5( e'4\5) g'8~ | \break
g'4 e'8 r4 r8 d'4.\4 r4^\markup { \italic "perc." } r8 |
e'4. r4 <es'\5 a'\4>8~ <es'\5 a'\4>4 a'8\4( \tag #'tabOnly \glissando b'4\4) g'8~ | \break
g'4 e'8 r4 r8 d'4.\4 r4^\markup { \italic "perc." } r8 |
e'4. r4^\markup { \italic "perc." } <es'\5 a'\4 d''\3>8\arpeggio->~ <es'\5 a'\4 d''\3>4. c''4\3 b'8\2~ | \break
b'4\2 e'8 r8 r4 d'4.\4 r4^\markup { \italic "perc." } r8 | \break
}

% Bassi della sezione centrale e dell’avvio della ripresa.
lowerThree = {
e4. bes4-2\6 r8 a4.-1\6 \acciaccatura { bes8-2\6( \tag #'tabOnly \glissando } c'4-2\6) r8 |
b4.-1\6 c'4-1\6 b8-1\6 ~ b4.\6 r4 r8 |
e4-> r8 r4 r8 g4.\6\thumb~ g4\6 r8 |
a2.-\tabString #5 c'4.\6\thumb r4 r8 |
d'2. des'2.-3-\tabString #5 |
c'4-2-\tabString #5 c'8 r4 a8-2-\tabString #6 ~ a4 e8( g8-2-\tabString #6 gis8-3-\tabString #6 b8-1-\tabString #5 ) |
e2. g4.-2\6 r4 r8 |
<fis\6 bes\5>4. r4 b8\6~ b4\6 r8 r4 r8 |
e4. e4. g4.\6 r4 r8 |
<fis\6 bes\5>4. r4 b8\6~ b4\6 r8 r4 r8 |
e4. e4. g4.\6 r4 r8 |
<fis\6 bes\5>4. r4 b8\6~ b4.\6 r4 r8 |
e4. e8-> r4 g4.\6 r4 r8 |
}

% Ripresa con variazioni: voce superiore.
upperFour = {
\break
des'4\5 \acciaccatura { g'8\4( \tag #'tabOnly \glissando } a'8\4)~ a'4\4 g'8\3 a'4\4( \tag #'tabOnly \glissando b'8\4) g'4\3 e'8\4~ |
e'4 b8-2\5 ~ b8 r8 e'8-4-\tabString #4 -\rh #"m"~ \tuplet 4/6 { e'16( f'16-3-\tabString #4 e'16-1-\tabString #4 d'16-\tabString #4 ) } b4-1-\tabString #5 -\rh #"i" d'8-0\4-\rh #"m"( | \break
e'4-2-\tabString #4) g'8-\tabString #3 -\rh #"a"~ g'4. b'4-\tabString #2 -\rh #"m" bes'8-2-\tabString #3 ~ bes'4 a'8-2-\tabString #3 ~ |
a'4 a'8 c''4 \acciaccatura { d''8-3-\tabString #2( \tag #'tabOnly \glissando } dis''8-\tabString #2)\vibratoLento ~ \tuplet 4/6 { dis''16( d''16-3-\tabString #2 c''16-1-\tabString #2 a'16-2-\tabString #3 ) } c''4 a'8~ | \break
a'4( g'8-\rh #"a") e'4 r8 g'4 a'8( g'4) f'8( |
fis'4) b'8~ b'4. fis'4. fis'4 fis'8~ | \break
fis'4. r4 e''16-2\3[ g''16-1\2] d'''4.-3-\tabString #1 c'''4-1-\tabString #1 a''8-3\2( \tag #'tabOnly \glissando |
b''4-3\2)\vibratoLento a''8-3\2( b''4-3\2)\vibratoLento r8 d'4.\4 r4^\markup { \italic "perc." } r8 | \break
des'4\5 \acciaccatura { g'8\4( \tag #'tabOnly \glissando } a'8\4)~ a'4\4 g'8\3 a'4\4( \tag #'tabOnly \glissando b'8\4) g'4\3 e'8\4~ |
e'4\4 b8\5~ b8\5 r4 d'4\4( e'8\4) g'4\3 e'8\4~ | \break
e'4 b8-1\5-\rh #"i"~ b4. <g'-\tabString #3 b'-\tabString #2 >4 r8 \barre #"B II" <ais'-1-\tabString #3 cis''-4-\tabString #2 >4\startTextSpan ais'8-1-\tabString #3 (\stopTextSpan |
\barre #"B III" b'4.-\finger #"2t"-\tabString #2 )\startTextSpan d''4 b'8-\finger #"2t"-\tabString #2 e''4-4\2\stopTextSpan g''8-1-\tabString #1 ~ \barre #"B III" g''4\startTextSpan <e''-4-\tabString #2 g''-1-\tabString #1 >8~ | \break
}

% Ripresa con variazioni: bassi e accompagnamento.
lowerFour = {
a4\6 r8 r4 r8 <b\6 es'\5>4 r8 r4 r8 |
e4. e8-> r8 g8-2-\tabString #6 ~ g2. |
e4. fis4-1\6 g8-3\6 ~ g4.\6 gis4-3\6 r8 |
a2.-0\5 fis2.\6\thumb
 |
a4.\5~ a4\5 ais8\5~ ais4.\5~ ais4\5 ais8\5 |
b4.\5 fis4.\6 a4.\5 ais4\5 b8\5~ |
b4.\5 r4 r8 r4 r8 r4 r8 |
e4.~ e4 r8 g4.\6 r4 r8 |
a4\6 r8 r4 r8 <b\6 es'\5>4 r8 r4 r8 |
e4. e8-> r4 g4. r4 r8 |
e4. e4. e4 fis8-1\6~ fis4\6 g8-1\6~ |
g4.\6 g'4.-\finger #"3t"\4 e4.-0\6 g'4.-3-\tabString #4 |
}

% Sezione finale: voce superiore e ritornello da ripetere a piacere.
upperFive = {
\break
<e'' g''>4 bes'8-1\stopTextSpan-\tabString #3 ~ <g'-3\4 bes'\3>4 r8 \barre #"B II" <a'-4-\tabString #3 dis''-4-\tabString #2 fis''-4-\tabString #1 >4\startTextSpan <dis'' g''-2-\tabString #1 >8( <dis'' fis''-1-\tabString #1 >4)\stopTextSpan e''8-\tabString #1 ~ |
e''4-\rh #"a" b'8-\tabString #2 -\rh #"m" g'4-\tabString #3 -\rh #"i" e''8~ e''4.~ e''4. | \break
\acciaccatura { ais8-2\5( \tag #'tabOnly \glissando } b4-2\5)-\rh #"i" d'8-\tabString #4 -\rh #"m"( dis'4-2-\tabString #4 ) e'8-2-\tabString #4 ~ e'4 r8 r4 r8 |
r4 \acciaccatura <ais dis'>8 <b-1\5 e'-1\4 >8~ <b e'>4. d'4.\4 r4^\markup { \italic "perc." } r8 | \break
\bar ".|:" e'4. r4^\markup { \italic "perc." } <es'\5 a'\4>8~ <es'\5 a'\4>4 es'8\5( e'4\5) g'8~ |
g'4 e'8 r4 r8 d'4.\4 r4^\markup { \italic "perc." } r8 | \break
e'4. r4 <es'\5 a'\4>8~ <es'\5 a'\4>4 a'8\4( \tag #'tabOnly \glissando b'4\4) g'8~ |
g'4 e'8 r4 r8 d'4.\4 r4 r8 \bar ":|." \break
}

% Sezione finale: bassi e accompagnamento del ritornello.
lowerFive = {
c'4.-1-\tabString #5 s4 b8-1\5 ~ b4.\5 fis'4-3\4 r8 |
e4.~ e4 a'8-4-\tabString #3 ~ \tuplet 4/6 { a'16( b'16-3-\tabString #3 a'16-1-\tabString #3 g'16-\tabString #3 ) } e'4-1-\tabString #4 ( d'8-\tabString #4 ) |
\acciaccatura { f8-1\6( \tag #'tabOnly \glissando } fis!4-1\6)-\rh #"p" r8 f4-1\6 e8~ e4 e8( g8-2-\tabString #6 gis8-3-\tabString #6 b8-1-\tabString #5 ) |
e2. g4.\6 r4 r8 |
\bar ".|:" <fis\6 bes\5>4. r4 b8\6~ b4\6 r8 r4 r8 |
e4. e4. g4.\6 r4 r8 |
<fis\6 bes\5>4. r4 b8\6~ b4\6 r8 r4 r8 |
e4. e4. g4.\6 r4 r8 \bar ":|."
}

% Riunisce le sezioni nelle due voci complete.
melody = { \upperOneTwo \upperThree \upperFour \upperFive }
bass = { \lowerOneTwo \lowerThree \lowerFour \lowerFive }
% Abbassa le altezze di un’ottava e sovrappone le due voci.
% Le diverse priorità tengono separate le lettere della mano destra.
notes = \transpose c c, \leftHandLayout <<
 { \voiceOne \override StrokeFinger.outside-staff-priority = #300 \melody }
 \\
 { \voiceTwo \override StrokeFinger.outside-staff-priority = #200 \bass }
>>
% Stessa musica per pentagramma e TAB. I tag selezionano i segni da mostrare.
\score {
 \new StaffGroup <<
  \new Staff { \clef "treble_8" \key g \major \time 12/8 \removeWithTag #'tabOnly \notes }
  \new TabStaff \with { stringTunings = #guitar-tuning } {
   \key g \major \time 12/8 \removeWithTag #'staffOnly \notes
  }
 >>
 \layout { }
}

% Note esecutive stampate in fondo allo spartito.
\markup \column {
 \vspace #1.5
 \bold "Note"
 \vspace #0.5
 \bold "Nota 1"
 \notaUnoTesto
 \vspace #1
 \bold "Nota 2"
 \notaDueTesto
}
