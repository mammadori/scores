\version "2.22.2"
\language "italiano"

#(define (tie::tab-clear-tied-fret-numbers grob)
   (let* ((tied-fret-nr (ly:spanner-bound grob RIGHT)))
      (ly:grob-set-property! tied-fret-nr 'transparent #t)))

#(define rh rightHandFinger)
arm = \markup { \italic { \fontsize #-2 { "ar.12 " }}}
arsett = \markup { \italic { \fontsize #-2 { "ar.7 " }}}


%% Hide fret number: useful to draw slide into/from a casual point of
%% the fretboard.
hideFretNumber = {
  \once \hide TabNoteHead
  \once \hide NoteHead
  \once \hide Stem
  \once \override NoteHead.no-ledgers = ##t
  \once \override Glissando.bound-details.left.padding = #0.3
}

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
   %#(set-paper-size "a4" 'landscape)
   top-margin = 8
   ragged-right = ##f
   ragged-bottom = ##t
}

\header {
  title = "Vilvorde"
  composer = "Giovanni Unterberger"
  opus = "Electric & Acoustic Guitar"
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
   
global = {
  \key mi \major
  \numericTimeSignature
  \time 3/4
  \tempo 4=90
  \override Fingering #'add-stem-support = ##t
  \override StringNumber #'add-stem-support = ##t
  \override StrokeFinger #'add-stem-support = ##t
  \mergeDifferentlyHeadedOn
  \mergeDifferentlyDottedOn
 
  \set fingeringOrientations = #'(left)
  \overrideTimeSignatureSettings
     3/4        % timeSignatureFraction
     1/4        % baseMomentFraction
     #'(1 1 1)    % beatStructure
     #'()  
}

upper = {
  \global
  r2 <si'-1\1 red'\3-2>4 |
  \repeat volta 2 {
    <sold'-4\2 mi'-3\3>4. <fad'-1\2 red'-2\3>8  <mi'-1\2 la-3\4>4 |
    <la'-1\1 dod'-2\3>2 <sold'-4\2 mi'-3\3>4 |
    <fad'-1\2>16 ( <sold'-4\2>16 <fad'\2>8 ) <red'-2\3>4 <la-1\4>8 <mi'\1>8 |
    
    <mi'-1\2>2 <red'-4\2>4 |
    <sold-1\3 si\2 mi'\1>2 <fad'-2\2 red'-3\3 >4 |
    << { <sold'-4\2>4 <la'-1\1>4 }  \\
       { <mi'-3\3>4 \glissando <dod'-2\3>4 } >> <fad'-4\2>8 \glissando <sold'\2>8 |
    <fad'-1\2 si-3\4>4 <red'-2\3>4 <la\4>8 <mi'\1>8 |
  } \alternative {
    {
    <mi'-1\2 sold-2\4>2 <si'-1\1>8 <red'\3-2>8  |
    } { % 2[ 
     
      <mi'-1\2 sold-2\4>2 <si\2>4 |
  } }
    
    \bar "||"
    \time 4/4
     \tempo 4=120
    \set Timing.beamExceptions = #'()
    \set Timing.baseMoment = #(ly:make-moment 1/4)
    \set Timing.beatStructure = 1,1,1,1
    
     <mi'-2\2>8 <si-1\3>8 <sold'-3\1>8 <fad'-1\1>8 <mi'\1>8 <red'-4\2>8 <dod'-1\2>8 si8 |
     <lad-4\3>8 <fad,>8  <dod'-3\2>8 <lad\3>8 <mi'\1>8 <dod'\2>8 
     
     \bbarre #"3/6 BV" {
        <la'-1\1>8 
        \grace { \hideFretNumber mid'8 \glissando s } 
        <fad'-3\2>8 |
     }
     \bbarre #"3/6 BIV" {
       <sold'-1\1 si\3>8 <mi'-3\2>8
     }
     \bbarre #"3/6 BII" {
     
       <la-1\3 dod'\2>8  <fad'\1>8 
     }
     
         \times 2/3 { <mi'\1>16 ( <fad'>16 <mi'>16 ) } <si\2>8 <la-1\3>8  <red'-4\2>8 |
     mi'8 si8 mi'4 <si,\5>8 si8 <dod'-2>8 ( \glissando <red'-2>8 ) | 
     
     
    <mi'\1>8 <si\2>8 <la-2\3>8 <si\2>8 
    \times 2/3 { <sold-1\3>16 ( <la-2\3>16 <sold-1\3>16 ) } <mi\4>8 ( <fad-4\4>8 ) <sold-1\3>8  |
    <la-2\3>8 si8 <dod'-2>8 ( \glissando <red'-2>8 ) mi'8 si8 <sold'-2\1>8 ( mi'8 )  |
    
     \bbarre #"3/6 BII" {
       <la-1\3 dod'\2>8  <fad'\1>8 
     }
     \bbarre #"3/6 BV" {
        <la'-1\1>8 <fad'-4\2>8 
     }
     \bbarre #"3/6 BIV" {
       <sold'-1\1 si\3>8 <mi'-4\2>8
     }
     \bbarre #"3/6 BV" {
        <fad'-4\2>8 <la'\1>8 |
     }
     
     <sold'\1 si\3>8 <mi'\2>8 <fad'\2>8 <la'\1>8 <sold'-1\1 si\3>8 <mi'-4\2>8
     \bbarre #"4/6 BIV" {
        <si\3>8 <red'\2>8 |
     }
     
      <mi'-1\2>2 \bbarre #"4/6 BII" { <red'-4\2>8 ( <dod'>8 ) la8 <fad>8 } |
      <mi\4>8 <sold-2\3>8 si8 mi'8 
      \bbarre #"5/6 BII" { <sold'-1\1>8   <fad'>8   <dod'>8 <red'\2>8  } |
      <mi'-4\2>8 <si-1\3>8 <sold'-2\1>8 <mi'\2>8 <si'-1\1>8 <sold'-2\2>8
      <mi' \harmonic >8^\arm <si \harmonic >8 |
      
      
      \repeat volta 2 { }
       \alternative { { 
      <si'\1  \harmonic >2. \fermata  %^\arsett <si'-1\1>4 | 
      <si'-1\1>4
      %\bar ":|"
        \mark "Da Capo"
                      } {
      
      % 2. [
      <si'\1  \harmonic >1 |
       % \arpeggio
       <la,\6 red'-4\3 la-3\4>2 r2 |
       <la-3\4>4 ( \glissando <sold\4>4 \glissando fad4 \glissando <la\4>4 |
        \grace { \hideFretNumber <la\4>8 \glissando s2 }  <sold\4>1 ) \fermata  |
    
                      }
       }
}

lower =  {
  \global
  r2. |
  \repeat volta 2 {
    r2. | r2. |
    <si-3\4>2 <la\4>4 |
    <sold-2\4>2 <si,-1\5>4 |
    mi,2 <si,-1\6>4 |
    mi,2. |
    <si,\6>2_\markup {\teeny "T"} <la-1\4>4 |
  } \alternative { {
     mi,2 r4 | }
  {
    mi,2 <la\4>8 \glissando ( <sold-3\4>8 )  |
  }}
    
    % 4/4
    <sold-3\4>4 <mi,>4 <sold,-3\6>2 |
    r8 <fad,-1>2 r8
    %\bbarre #"3 B III" { 
      <do'-1\3 >4  
    %} |
    
    <si-1\3>4 <la-1\3>4  <si\3>4 <la\3>4 |
    <sold-1>4 <mi-2>4 \grace { <lad,-1\5>8 ( \glissando s } <si,-1\5>4 ) la,4 |
    <sold,-1\6>4 <fad,-1>4 mi,2 |
    r8 <si,-1>8 la,4 <sold,-1\6>4 mi,4 |
     <la-1\3>4 <do'-1\3 >4 <si-1\3>4 <do'-1\3 >4  |
    <si-1\3>4 <do'-1\3 >4 <si-1\3>4 <fad-1\4>4  |
     <sold-2\4>2 la,4.  <fad-3>8|
     <mi-3\4>2 si,2 |
     mi,1 |
   \repeat volta 2 { }
    \alternative { { 
       r2. <red'\3-2>4 | % da capo 
                    }
     {
       r1 |
       <la,-1\6>2 ( <si,-2\6>2 ) |
       \arpeggio <mi, mi'>1 ( |  <mi, mi'>1 ) \fermata  
       
    } }
     
    
    
}

\score {
  \new StaffGroup \with {
    %\consists "Instrument_name_engraver"
    %instrumentName = "Chitarra"
  } <<
    \new Staff \with {
      midiInstrument = "acoustic guitar (nylon)"
    } { \clef "treble_8" << \upper \\ \lower >> }
    \new TabStaff \with {
      stringTunings = #guitar-tuning
    } <<
      \new TabVoice { \voiceOne \upper }
      \new TabVoice { \voiceTwo \lower }
    >>
  >>
  \layout { }
  \midi {
 %   \tempo 4=100
  }
}
