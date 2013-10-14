\version "2.16.2"
\language "italiano"

#(define (tie::tab-clear-tied-fret-numbers grob)
   (let* ((tied-fret-nr (ly:spanner-bound grob RIGHT)))
      (ly:grob-set-property! tied-fret-nr 'transparent #t)))

#(define rh rightHandFinger)

arm = \markup { \italic { \fontsize #-2 { "ar.12 " }}}

bbarre =
#(define-music-function (barre location str music) (string? ly:music?)
   (let ((elts (extract-named-music music '(NoteEvent EventChord))))
     (if (pair? elts)
         (let ((first-element (first elts))
               (last-element (last elts)))
           (set! (ly:music-property first-element 'articulations)
                 (cons (make-music 'TextSpanEvent 'span-direction -1)
                       (ly:music-property first-element 'articulations)))
           (set! (ly:music-property last-element 'articulations)
                 (cons (make-music 'TextSpanEvent 'span-direction 1)
                       (ly:music-property last-element 'articulations))))))
   #{
       \once \override TextSpanner #'font-size = #-2
       \once \override TextSpanner #'font-shape = #'upright
       \once \override TextSpanner #'staff-padding = #3
       \once \override TextSpanner #'style = #'line
       \once \override TextSpanner #'to-barline = ##f
       \once \override TextSpanner #'bound-details =
            #`(
               (left
                (text . ,#{ \markup { #str } #})
                (Y . 0)
                (padding . 0.25)
                (attach-dir . -2))
               (right
                (text . ,#{ \markup { \draw-line #'( 0 . -.5) } #})
                (Y . 0)
                (padding . 0.25)
                (attach-dir . 2)))
%% uncomment this line for make full barred
       % \once  \override TextSpanner #'bound-details #'left #'text =  \markup { "B" #str }
       $music
   #})

\paper {
	% #(set-paper-size "a4" 'landscape)
   top-margin = 8
   ragged-right = ##f
   ragged-bottom = ##t
}
\layout {
   \context { \Score
      \override MetronomeMark #'padding = #'5
   }
   \context { \Staff
      %\override TimeSignature #'style = #'numbered
      \override StringNumber #'transparent = ##t
   }
   \context { \TabStaff
      \override TimeSignature #'style = #'numbered
      \override Stem #'transparent = ##t
      \override Flag #'transparent = ##t
      \override Beam #'transparent = ##t
      \override Tie  #'after-line-breaking = #tie::tab-clear-tied-fret-numbers
   }
   \context { \TabVoice
      \override Tie #'stencil = ##f
   }
   \context { \StaffGroup
      \consists "Instrument_name_engraver"
   }
}

\header {
  title = "Six Bars Jail"
  arranger = "Giovanni Unterberger"
  meter = "Dropped D Tuning - DADGBE"
  instrument = "Chitarra Acustica"
}

global = {
  \time 4/4
  \tempo 4=90
  \key re \major
  \set Staff.midiInstrument = #"acoustic guitar (steel)"
  \mergeDifferentlyHeadedOn
  \mergeDifferentlyDottedOn
  \override Fingering #'add-stem-support = ##t
  \override StringNumber #'add-stem-support = ##t
  \override StrokeFinger #'add-stem-support = ##t
}

chordNames = \chordmode {
  \global
  do1
  
}

melodia =  {
  \global
  \voiceOne
    \once \override Score.BreakAlignment #'break-align-orders =
    #(make-vector 3 '(instrument-name
                      left-edge
                      ambitus
                      breathing-sign
                      clef
                      key-signature
                      time-signature
                      staff-bar
                      custos))
  \once \override Staff.TimeSignature #'space-alist =
    #'((first-note . (fixed-space . 2.0))
       (right-edge . (extra-space . 0.5))
       ;; free up some space between time signature
       ;; and repeat bar line
       (staff-bar . (extra-space . 1)))
  \repeat volta 1 {
    \bar "|:"
    \set doubleSlurs = ##t
    \mark \markup {\musicglyph #"scripts.segno" }
    \set fingeringOrientations = #'(left)
    r4
    \bbarre #"4/6 B III" {
      <fad-3 la-1 re'-2 >8(~ \arpeggio <dod'-1  la-1 mi-1>8(~ ) <fad-3 la-1 re'-2 >4 ) 
    }
    <mi'\1>8 <sol\3>8 |
    \set fingeringOrientations = #'(left)
    \set doubleSlurs = ##f
    <fad'-2>8 ( <sol'-4>16 ) ( fad' ) ( mi'8 ) <re'-3> \acciaccatura <fad'-2>8 \glissando ( <sol'-2> ) si ( <dod'-1> ) ( \glissando [ <mi'-1\2 > ] ) | 
    <si-\rh #3 >8 ( <dod'-2>16 ) ( si ) <la-2-\rh #2 >8 ( sol ) <fad-3-\rh #2 re'-2-\rh #4 >4  <la-1-\rh #3 >8 ( sol ) | 
    <fad-1-\rh #2 >8 ( <sol-3\4>16 ) ( fad ) ( re8 ) <sol-\rh #3 >8 <mi-1-\rh #2 >4 
 
    
    \set doubleSlurs = ##t
    \bbarre #"4/6 B III" {
       \times 2/3 { <la-1-\rh #3 dod'-1-\rh #4 >16 [ ( <si-\3 re'-2 > ) (  <la-\rh #3 dod'-\rh #4 > ) } <sol\4-4-\rh #2 >8 ]
    }
    \time 2/4
    \set doubleSlurs = ##f
      <fad-3-\rh #2 >8 [ <sol-\rh #3 > ] <mi-1-\rh #2 > ( re ) |
  }
  \time 4/4
  \mark \markup { \musicglyph #"scripts.coda" }
  r2 r8^"Perc." <la,-\rh #2 >8 
  \times 2/3 { <mi-1-\rh #3 >16 ( <fad-3> ) ( <mi-1> ) ( }  re8 ) |
  \repeat volta 2 {
    \acciaccatura <do-2> 
    <re-2\5-\rh #2 >4
    r8^"Perc."
    <re-2-\rh #2 >8 re, <re-2-\rh #2 fad-1-\rh #3 >16 r16 
    \set fingeringOrientations = #'(left)
    \set strokeFingerOrientations = #'(down up)
    r16 <mi-3\5-\rh #2 sol-1\4-\rh #3 >8. \glissando |
    \set fingeringOrientations = #'(right)
    <fad-3\5 la-1\4>4 r8
    \set strokeFingerOrientations = #'(right)
    \set fingeringOrientations = #'(left)
    <fad\5-3-\rh #2 >8
    <la\4-1-\rh #3 > <sol-\rh #4 > <si-\rh #3 > [<sol-\rh #2 > ] |
    la,8 <la\4-2>_"t"  \times 2/3 { <dod'\3-1-\rh #3 >16 ( <re'\3-3> ) ( <dod'\3-1> ) ( }  sol8 ) 
    \acciaccatura <la\4-2> \glissando ( <si-2\4-\rh #2 >8 ) \glissando ( <la\4-2> ) <sol-\rh #3 > [ <mi-1> ] |
    \acciaccatura <do-2-\rh #2 > \glissando ( <dod-2 >8 ) <sol,\6>  <re-\rh #3 > [ <re\5-\rh #2 > ] re, 
    <re\harmonic-\rh #2 >^\arm <sol-\harmonic\rh #3 >^\arm ( [ <fad'\3-2>^\markup {\italic { \fontsize #-2 { "Eco" }}} ) ] |
    \once \override Arpeggio #'positions = #'(0.5 . 3) 
    <mi'\3-2 sol'\2>4\arpeggio <mi'-1\2>8 <dod'-2\3> \glissando <la-2 dod'-3> ( si ) <dod'-3>4 |
    
    \bbarre "3/6 B II" {
	    <fad-3-\rh #2 re'-2-\rh #4 >8 [ re, ] <la-1> <fad'-1> re <re'-2>_"t" <sol'-3> ( [ <fad'-1> ] )
    } 

    \once \override Arpeggio #'positions = #'(0 . 3)
    <dod'-2 mi'>4 \arpeggio r4^"Perc." 
    
    \set doubleSlurs = ##t
    \times 2/3 { <sol-\rh #2 mi'-\rh #4 >8~ <sol mi'> ( <la-1 fad'-1>~ ) }
    \times 2/3 { <la fad'> <si\3-3 sol'-2>~ <si\3 sol'> } |
    \set doubleSlurs = ##f
    \once \override Arpeggio #'positions = #'(0 . 3)
    <la-3-\rh #2 fad'-4-\rh #4 >4 \arpeggio 
    \acciaccatura <dod'-2> \glissando <re'-2>4
    <mi-1 dod'-2>8 ( si ) <dod'-2 sol> \glissando ( [ <re'-2> ] ) |
    } \alternative {
    {
	<re'-2-\rh #4 fad-3-\rh #1 >2 \arpeggio r8^"Perc."
	<la,-\rh #2 >8
	\times 2/3 { <mi-1-\rh #3 >16 ( <fad-3> ) ( <mi-1> ) ( }
	re8 ) |
    }  
    { 
      
    <>^\markup { 
      \center-column {
        \line {"dal  " \musicglyph #"scripts.segno" "al  " \musicglyph #"scripts.coda" }
        \line { "poi CODA" }
      }
    }
   s1 |
   \bar "||"
   \break 
    }
  }
  
  % coda
  \mark "CODA"
  <sol-\rh #3 \harmonic si-\rh #4 \harmonic >4^\arm
  <fad'\3-2-\rh #3 la'\2-1-\rh #4 >8 <re-\rh #2 \harmonic>8^\arm
  <sol-\rh #3 \harmonic>8^\arm [ <re'\4 fad'\3 >8~ ]  
  <re'\4 fad'\3 >4 \glissando \hideNotes \grace {<la\4 dod'\3>} \unHideNotes |
  < dod'-3-\rh #4 mi-2-\rh #2 >8 ( si ) <dod'-3>4^"rall." 
  <re'-1-\rh #4 fad-2-\rh #2 >2 \arpeggio \fermata |
   \bar "|."
}
  

bassi = {
  \global
  \voiceTwo
  \set doubleSlurs = ##f
  \repeat volta 1 {
    <re,>2~ re,8~ re,~ re,4 |
    re2~ re8 la,~ la,4 |
    <sol-\rh #1 >4 r4 r8 re,8~ re,4 |
    <re\5-2>2~ re8 la,8~ la,4 |
    \time 2/4
    
    la,2 | 
  } 
  \time 4/4
  re,2 r8 r8 r4 |
  \repeat volta 2 {
    \hideNotes \acciaccatura s8 \unHideNotes
    re,4 r8 r8 re,2 |
    re,4 re,2. |
    la,2 la,2 |
    r8 <sol,\6-3> r4 re,2 |
    la,2 <la>4 sol |
    r8 re,4. re2 |
    la,4 r8 la,8~ la,2 |
    re2 la,4 <sol-\rh #1 > |
  } \alternative {
    {
    <re,-\rh #1 >2 r2 |
    }
    {
    s1  |
    }
  }
  %coda
  r1 |
  la,2 re,2 |
  \bar "|."
}

Parte = \new Staff <<
   \clef "treble_8"
   \context Voice = "melodia" {
      \melodia 
   }
   \context Voice = "bassi" {
      \bassi
   }
>>

Tablatura = \new TabStaff \with { stringTunings = #guitar-drop-d-tuning } <<
   \clef "moderntab"
   \context TabVoice = "melodia" {
      \melodia
   }
   \context TabVoice = "bassi" {
      \bassi
   }
>>


\score {
  <<
   % \new ChordNames \chordNames
   % \new FretBoards \chordNames
    \Parte
    \Tablatura   
  >>
  \layout { }
  % \midi { }
}
