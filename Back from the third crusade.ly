\version "2.16.2"
\language "nederlands"


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
     \override StringNumber #'stencil = ##f
     \override Arpeggio #'stencil = ##f
     \override Glissando #'minimum-length = #3.5 % more readable for guitar
     \override Glissando #'springs-and-rods = #ly:spanner::set-spacing-rods

   }
   \context { \TabStaff
      \override TimeSignature #'style = #'numbered
      \override Stem #'transparent = ##t
      \override Flag #'transparent = ##t
      \override Beam #'transparent = ##t
      \revert Arpeggio #'stencil 
   }
   \context { \TabVoice
      \override Tie #'stencil = ##f
   }
   \context { \StaffGroup
      \consists "Instrument_name_engraver"
   }
}

\header {
  title = "Back from the third crusade"
  composer = "Giovanni Unterberger"
  meter = "Open G Tuning - DGDGBD"
  %instrument = "Chitarra Acustica"
}

global = {
  \time #'(1 1) 2/4
  \key g \major
  \set Staff.midiInstrument = #"acoustic guitar (steel)"
  \mergeDifferentlyHeadedOn
  \mergeDifferentlyDottedOn
  \override Fingering #'add-stem-support = ##t
  \override StringNumber #'add-stem-support = ##t
  \override StrokeFinger #'add-stem-support = ##t
  \set fingeringOrientations = #'(up)
  \set strokeFingerOrientations = #'(down)
}

melodia =  {
  \global
  \voiceOne
   r4 <g\4-2-\rh #2 b\3-1-\rh #3 >4 |
   g,8 <g\4-\rh #2 >8 <c'\3-3>8 ( <b\3-1> ) | 
   
   g,8 <g\3>8 <e\4-2-\rh #2 >8 ( <d\4>8 ) |
   r4 <d\4>8 ( <e\4-2>8 ) |
   r4 <g\4-2 b\3-1 >4 |
   g,8 <g\4>8 <c'\3-3>8 ( <b\3-1>8 ) |
   r4 <b\4-3>8 <d'\3-1>8 |
   g,8 <b\4>8 <e'\3-4>8 ( <d'\3-1>8 ) |
   \set fingeringOrientations = #'(up left)
   \set strokeFingerOrientations = #'(up left)
   r4 <fis'\2-1-\rh #3 e'\3-3-\rh #2 >4 |
   \set fingeringOrientations = #'(up)
   \set strokeFingerOrientations = #'(down)
   d8 <e'\3>8 <fis'\2>8 <d'\1>8 |
   d8 <b\2>8 <d'\3-1>8 \glissando ( <c'\3-1>8 ) |
   <a\4>8 <b\2>8 <g\3>8 <g\4-1-\rh #2 >8 |
   r4
   \once \override Arpeggio #'positions = #'(-1 . 1.8)
   \arpeggioArrowUp
   <g\4-1 g\3 b\2>4 \arpeggio |
   g,8 <g\4-\rh #2 > <g\3-\rh #3 > <b\2-\rh #4 > |
   g,8 <a-3\4-\rh #2 > <c'-1\3-\rh #3 > <b\2-\rh #4 > |
   
   g,8 <b\3-1-\rh #3 >8 <g-2\4-\rh #2 >8 <g\3-\rh #3 >8 |
   \repeat volta 1 {
   r4
     \set fingeringOrientations = #'(left)
     <a'\1-4-\rh #3 >4 |
   g,8 <b\2>8 <g'\1-1-\rh #3 >8 ( <d'\1>8 ) |
   
   g, <b\2-\rh #2 > s4  |
   r8 <g\3>8 s4 |
   r4 <g'\2>4 |
   
   g,8 <g\3>8 <fis'\2-3>8 <d'\1>8 |
   r4 \once \set strokeFingerOrientations = #'(left)
   <e'\2-\rh #"3t" g\4>8 <b\3-1>8 |
   \set fingeringOrientations = #'(up)
   g,8 <b\3-1>8 
   \hideNotes \grace <b\3> \glissando \unHideNotes
   <c'\3-1>4 |
    r4 <fis'\2-1 e'\3-3>4 |
    d8 <e'\3>8 <fis'\2>8 <d'\1>8 |
   d8 <b\2>8 <d'\3-1>8 \glissando ( <c'\3-1>8 ) |
   <a\4>8 <b\2>8 <g\3>8 <g\4-1-\rh #2 >8 |
   
    r4
   \once \override Arpeggio #'positions = #'(-1 . 1.8)
   \arpeggioArrowUp
   <g\4-1 g\3 b\2>4 \arpeggio |
   g,8 <g\4-\rh #2 > <g\3-\rh #3 > <b\2-\rh #4 > |
   g,8 <a-3\4-\rh #2 > <c'-1\3-\rh #3 > <b\2-\rh #4 > |
   
   g,8 <b\3-1-\rh #3 >8 <g-2\4-\rh #2 >8 <g\3-\rh #3 >8 |
   } 
   s4 <d g>
   g,8 <d\4-\rh #2 > <g\3-\rh #3 > <b\2-\rh #4 > |
   g,8 <a-3\4-\rh #2 > <c'-1\3-\rh #3 > <b\2-\rh #4 > |
   
   g,8 <b\3-1-\rh #3 >8 <g-2\4-\rh #2 >8 <g\3-\rh #3 >8 |
   <>^\markup { \musicglyph #"scripts.segno" }
  s2 | r2 |
  
  \bar "||"
  
  \once \override Score.RehearsalMark #'break-visibility = #begin-of-line-invisible
  \cadenzaOn
  \stopStaff
    
  \once \override TextScript #'word-space = #1.5
    \once \override TextScript #'extra-offset = #'(0 . 2)
  <>_\markup {
      \center-column {
        \line { " da Capo al " \musicglyph #"scripts.segno"  }
        \line { " poi CODA" }
      }
  }
 
   % Increasing the unfold counter will expand the staff-free space
  s2  \bar ""
  \startStaff
  \cadenzaOff
  
    
 
  
  \repeat volta 1 {
   \break
   \mark "CODA"
   \bar "|:"
   s4 <d g>
   g,8 <d\4-\rh #2 > <g\3-\rh #3 > <b\2-\rh #4 > |
   g,8 <a-3\4-\rh #2 > <d'-1\3-\rh #3 > <b\2-\rh #4 > |
   
   g,8 <b\3-1-\rh #3 >8 <g-2\4-\rh #2 >8 <g\3-\rh #3 >8 |
   
    
  
 
  s4 <d g>
   g,8 <d\4-\rh #2 > <g\3-\rh #3 > <b\2-\rh #4 > |
   g,8 <a-3\4-\rh #2 > <c'-1\3-\rh #3 > <b\2-\rh #4 > |
   <>^\markup { \small \italic "ad libitum" }
   g,8 <b\3-1-\rh #3 >8 <g-2\4-\rh #2 >8 <g\3-\rh #3 >8 |
  
   
  }
  
}
  

bassi = {
  \global
  \voiceTwo
   g,2 | g,2 |g,2 |g,2 |g,2 |g,2 |g,2 |g,2 |
   d2 | d2 | d2 | 
   <a\4-3>2  
   g,2 | g,2 |g,2 | g,2 |
   % start volta
   g,4 
   \set fingeringOrientations = #'(left) 
   <a\4-3-\rh #1 > |
   <g,\5>4 <a\4-3-\rh #1 >  |
   \set fingeringOrientations = #'(up) 
   <g,\5>4
   \once \set strokeFingerOrientations = #'(left)
   <c'\3-1-\rh #1 >8 \glissando ( <b\3-1>  ) |
   <g,\5>4 <g\4-2>8 \glissando ( <a\4-2>  )
   <g,\5>4 
   \hideNotes \grace <a\4> \glissando \unHideNotes
   <b\4>4  |
   \set fingeringOrientations = #'(left) 
   <g,\5>4 <a\4-2> |
   
   <g,\5>4
   \once \set strokeFingerOrientations = #'(left)
   <g\4-\rh #"2t" >4  |

   g,4 g\4 |
   d2 | d2 | d2 | d2 
   g,2 |g,2 |g,2 |g,2 |
   % end volta
   \set fingeringOrientations = #'(up) 
   <c\5-3>8 \glissando ( <d\5-3> ) r4 |
   g,2 |g,2 |g,2 |
  
   
   <c\5-3>8 \glissando ( <d\5-3>~ ) d4~ |
   d2 | % segno
   
   s2 |  % D.C. al ..
   
    <c\5-3>8 \glissando ( <d\5-3> ) r4 |
   g,2 |g,2 |
      g,2 |
  
    <c\5-3>8 \glissando ( <d\5-3> ) r4 |
   g,2 |g,2 |g,2 |
   
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

Tablatura = \new TabStaff \with { stringTunings = #guitar-open-g-tuning } <<
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
    \Parte
    \Tablatura   
  >>
  \layout { }
  %\midi { }
}
