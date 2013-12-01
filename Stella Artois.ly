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
  title = "Stella Artois"
  arranger = "Reno Brandoni"
  meter = "Dropped D Tuning - DADGBE"
  %instrument = "Chitarra Acustica"
}

global = {
  \time #'(1 1) 2/4
  \tempo 4=90
  \key re \major
  \set Staff.midiInstrument = #"acoustic guitar (steel)"
  \mergeDifferentlyHeadedOn
  \mergeDifferentlyDottedOn
  \override Fingering #'add-stem-support = ##t
  \override StringNumber #'add-stem-support = ##t
  \override StrokeFinger #'add-stem-support = ##t
  \set fingeringOrientations = #'(left)
  
  \overrideTimeSignatureSettings
     3/4        % timeSignatureFraction
     1/4        % baseMomentFraction
     #'(1 1 1)    % beatStructure
     #'()  
  
  
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
  \set fingeringOrientations = #'(left)
  
  \repeat volta 2 {
    \bar "|:"
    <>^\markup { \musicglyph #"scripts.segno" }
    r8 <fad'\2-4>8 <dod'-2\3>4 |
    <la'-1>4 ( mi'8 ) <re'-4\2> |
    r8 re'8 ( dod'-2 ) <si\3-4> |
    <fad'-1>4 ( mi'8 ) re'-1 |
    <sol,>8 re'8 <si\3-2>4 |
    mi'4 <re'-2>8 mi' |
   } \alternative {
    {
      fad'2~ | fad'2 |
    }
    
    {
      \set Score.voltaSpannerDuration = #(ly:make-moment 2 4)
      re'2~ | re'2 |}
  }    
  
  
  \bar "||"
  \mark \markup { \musicglyph #"scripts.coda" }
  
  \once \override Score.RehearsalMark #'break-visibility = #begin-of-line-invisible
  \cadenzaOn
    \stopStaff
    
\once \override TextScript #'word-space = #1.5
  \once \override TextScript #'extra-offset = #'(0 . 2)
  <>_\markup {
      \center-column {
        \line { " dal " \musicglyph #"scripts.segno" "al " \musicglyph #"scripts.coda" }
        \line { " poi segue" }
      }
  }
   % Increasing the unfold counter will expand the staff-free space
  \repeat unfold 3 {
     s1
     \bar ""
  }  
  \startStaff
  \cadenzaOff
  \bar "||"

   
  <fad'-1>8 ( <sol'-2> ) ( fad' )  ( mi' )  |
  si ( <dod'-1> ) ( re'-2 ) ( mi' ) |
  \bar "||"
 

  \time 3/4
  <re'-3>4 <fad-4>8 fad'-2 ( mi' )  re'-3  |
  \bbarre "⅔ B II" { dod'4 mi8 la-1 ( si\3-3 )  dod'-1   } |
  <re'-3>4 r2 |
  \bar "||"
  
  \time #'(1 1) 2/4
 
  \set fingeringOrientations = #'(left)
  
  \times 2/3 {
     <dod'-1>16  (
     
     re' )
     ( dod' ) } 
 
  si8  sol ( la-1 )  |
  \bar "||"
  \time #'(1 1 1) 3/4
  <fad-3>8 r8 la,  fad-3  sol fad |
  mi-1 r8 la,  mi  sol mi |
  fad r8 la,  fad sol fad |
  mi r8 la,  mi  sol <dod\5>  \glissando ( |
   
  <re\5>2. ) \fermata |
  \bar "|."
}
  

bassi = {
  \global
  \voiceTwo

  \set fingeringOrientations = #'(left)
 
    \repeat volta 2 {
    <re\5-1>4. <la-3\4>8 |
    r8 re,8~ re,4 |
    
      <si,-1>4. r8  |
    re2 |
   
    <sol,-3>4. <sol-4\4>8 |
    <mi,-1>2 |
    
   } \alternative {
    { re4 la, | re,4 la, | }
    { re4 la, | re,4 la, | }
   }
  \bar "||"
  \repeat unfold 3 {
     s1
     \bar ""
  }
  
  \bar "||"
  
  r2 | r2 |
  \bar "||"
  % \time 3/4
  <si,-1>4 <fad>4 r4 |
  la, mi2 |
  la,4 <si,-1>8 ( <dod-3> ) re4 |
  \bar "||"
  % \time 2/4
  r2 |
  \bar "||"
  % \time 3/4

  re,8 r8 la,2 |
  la,8 r8 la,2 |
  re,8 r8 la,2 |
  la,8 r8 la,4. <dod\5-3>8 |
  re,2. |  
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
  %\midi { }
}
