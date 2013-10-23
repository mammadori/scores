\language "italiano"
#(define (tie::tab-clear-tied-fret-numbers grob)
   (let* ((tied-fret-nr (ly:spanner-bound grob RIGHT)))
      (ly:grob-set-property! tied-fret-nr 'transparent #t)))

#(define RH rightHandFinger)

\version "2.16.0"
\paper {
   top-margin = 8
   print-all-headers = ##t
   ragged-right = ##f
   ragged-bottom = ##t
}
\layout {
   \context { \Score
      \override MetronomeMark #'padding = #'5
   }
   \context { \Staff
      \override TimeSignature #'style = #'numbered
      \override StringNumber #'transparent = ##t
   }
   \context { \TabStaff
      \override TimeSignature #'style = #'numbered
      \override Stem #'transparent = ##t
      \override Flag #'transparent = ##t
      \override Beam #'transparent = ##t
      \override Tie  #'after-line-breaking = #tie::tab-clear-tied-fret-numbers
      %fixme: \override arpeggioBracket #'transparent = ##t
   }
   \context { \TabVoice
      \override Tie #'stencil = ##f
   }
   \context { \StaffGroup
      \consists "Instrument_name_engraver"
   }
}

deadNote = #(define-music-function (parser location note) (ly:music?)
   (set! (ly:music-property note 'tweaks)
      (acons 'stencil ly:note-head::print
         (acons 'glyph-name "2cross"
            (acons 'style 'special
               (ly:music-property note 'tweaks)))))
   note)

palmMute = #(define-music-function (parser location note) (ly:music?)
   (set! (ly:music-property note 'tweaks)
      (acons 'style 'do (ly:music-property note 'tweaks)))
   note)

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


TrackAVoiceAMusic = #(define-music-function (parser location inTab) (boolean?)
#{
   \tempo 4=120
   \clef #(if inTab "tab" "treble_8")
   \key sol \major
   \time 4/4
   \set Staff.midiInstrument = #"acoustic guitar (steel)"
   \set fingeringOrientations = #'(left)

   \voiceOne % parte melodica, indice, medio, anulare
   r2 <re\4-\RH #2 >8 ( <red-1\4>8 ) ( <mi-3\4>8 ) [<sol\3-\RH #3 >8 ]|
   \repeat volta 2 {

     \mergeDifferentlyHeadedOn
      r8 <sol\3>8 \acciaccatura <fa'-2\1>8 \glissando <fad'\1-\RH #4 si\2-\RH #3 >4~ <fad'\1  si\2 >8 ( <mi'\1>8 ) <re'-3\2-\RH #4 >8 [

     \bbarre "4/6 B II" {
       \arpeggioBracket
       \once \override Fingering #'positions = #'(-1 . 1.8)
       <dod'\2-\RH #4  mi\4
       -\tweak #'self-alignment-Y #-2
       -1-\RH #2 >8 \arpeggio ] |
       \set doubleSlurs = ##t
       r8  <dod'-\RH #4 mi-\RH #2 >8 ( <re'\2-2 fad\4-3 >8 )[ }


      <mi'\1~ la\3( >8 ] <mi'\1 sol\3) >8  fad8 r8 <sol-\RH  #2 > |
      mi,8 <sol\3>8 <fad'\1 si\2 >4~ <si\2 fad'\1 >8 [ \( \acciaccatura {<sol'\1>16 [ <fad'\1>16 ]  } <mi'\1>8 ]  \)  <re'\2-3-\RH #4 >8  [ 

    \bbarre "4/6 B II" {
      <dod'\2-\RH #4  mi\4-\RH #2 >8 ]  |
      r8 <dod'\2 mi\4 >8 ( <re'-2\2 fad\4-3 >8 ) [
    }

      <mi'\1~ la\3 >8 ] ( <mi'\1 sol\3 >8 ) <fad-\RH #1 >8 r8 <sol> |
      r4 <fad'-1\1-\RH #4 >8 <sol\3-\RH #2 >8 <sol,\6>8 [ <re'-3\2-\RH #3 >8 ] <sol\3>8 <sol'-4\1>8  |
   }
   \alternative {
    {\set doubleSlurs = ##f
      do8 [ <sol'\1-4>8 ] ( <fad'\1-1>8 ) <sol\3>8 <mi'\1>8 [ <re'\2-3>8 ] <sol\3-\RH #2 >8 <si\2-\RH #4 >8 |
     \mergeDifferentlyHeadedOn
     \mergeDifferentlyDottedOn
      <si,\5-2>8 [ <la\3-3-\RH #3 >8 ]  <red\4-1-\RH #2 >8  <la,\5>8 r2  |

      <la\3-3-\RH #3 >8 \glissando ([ <lad\3 >8 ]) \glissando (<la\3 >8 ) (<sol\3>8 )  la-1 ( [ sol8 ) ] <mi\4-1>8 [ ( re8 ) ]|
    }
    {

      do8 [ <sol'\1>8 ] ( <fad'\1>8 ) <sol\3>8 <mi'\1>8 [ <re'\2>8 ] <sol\3>8 <mi'\1-\RH #4 >8 |
       \set doubleSlurs = ##t
      mi,8 [  <la\3-2-\RH #4 fad'\1-1-\RH #2  >8 ( ]


      \set doubleSlurs = ##f

      <sol\3   mi'\1  >8 ) 


       <sol-1\4 do'-1\3 mi'-1\2 >8 

      mi,8  [ <fad\4-2 si\3-3  re'\2-1 >8 ] mi,8 <si\3-\RH #4 re\4-\RH #2 >8 |
      mi,8 [ <la\3-1>8 (] <sol\3>8 ) <la\3>8 ( <sol\3>8 ) [ <mi\4>8 (] <re\4>8 ) dod8 |
      r8 <re\4-\RH #2 >8 ( <mi\4-2>8 ) [ <sol\3-\RH #3 >8 ]<si\2-\RH #4 >8 [ <sol\3-\RH #3 >8 ] <mi\4-\RH #2 >8 <sol'\1-4-\RH #4 >8~ |
      sol'2 <re\4-\RH #2 >8 ( <red-1\4>8 ) ( <mi-3\4>8 ) [<sol\3-\RH #3 >8 ]|
    }
   }
   \repeat volta 2 {

     \mergeDifferentlyHeadedOn
      r8^\markup {\musicglyph #"scripts.segno" } <sol\3>8 \acciaccatura <fa'-2\1>8 \glissando <fad'\1-\RH #4 si\2-\RH #3 >4~ <fad'\1  si\2 >8 ( <mi'\1>8 ) <re'-3\2-\RH #4 >8 [


       <dod'\2-\RH #4 mi\4-\RH #2 >8 ]
       \set doubleSlurs = ##t
       r8  \bbarre "4/6 B II" { <dod'-\RH #4 mi-\RH #2 >8 ( <re'\2-2 fad\4-3 >8 )[  }


      <mi'\1~ la\3( >8 ] <mi'\1 sol\3) >8  fad8 r8 <sol-\RH  #2 > |
      mi,8 <sol\3>8 <fad'\1 si\2 >4~ <si\2 fad'\1 >8 [ \(
      \set doubleSlurs = ##f
      \acciaccatura {<sol'\1>16 [ <fad'\1>16 ]  } 
      <mi'\1>8 ]  \)  <re'\2-3-\RH #4 >8  [ 

      \bbarre "4/6 B II" {
      <dod'\2-\RH #4  mi\4-\RH #2 >8 ] |
        \set doubleSlurs = ##t
        r8 <dod'\2 mi\4 >8 ( <re'-2\2 fad\4-3 >8 ) [
      }


      <mi'\1~ la\3 >8 ] ( <mi'\1 sol\3 >8 ) <fad-\RH #1 >8 r8 <sol> |
      r4 <fad'-1\1-\RH #4 >8 <sol\3-\RH #2 >8 <sol,\6>8 [ <re'-3\2-\RH #3 >8 ] <sol\3>8 <sol'-4\1>8  |
   }
   \alternative {
       { \set doubleSlurs = ##f
      do8 [ <sol'\1-4>8 ] ( <fad'\1-1>8 ) <sol\3>8 <mi'\1>8 [ <re'\2-3>8 ] <sol\3-\RH #2 >8 <si\2-\RH #4 >8 |
     \mergeDifferentlyHeadedOn
     \mergeDifferentlyDottedOn
      <si,\5-2>8 [ <la\3-3-\RH #3 >8 ]  <red\4-1-\RH #2 >8  <la,\5>8 r4 r8^\markup { "perc." } <red'-3>8 (  |
      <mi'\2-3 >8-> ) [ <mi'\1 >8 ]

      <mi'-\RH #4 ~ la-1-\RH #2 >16 ( <mi' sol>16 )  mi8 

      \acciaccatura <la-2>8 \glissando <si-2>8 [ <re'-1>8 ]\acciaccatura <si-2>8 \glissando <la-2>8 ( <sol\3>8 ) |
    }
    {
      do8 [ <sol'\1>8 ] ( <fad'\1>8 ) <sol\3>8 <mi'\1>8 [ <re'\2>8 ] <sol\3>8 <mi'\1-\RH #4 >8 |
      \set doubleSlurs = ##t
      mi,8 [  <la\3-2-\RH #4 fad'\1-1-\RH #2  >8 ( ] <sol\3   mi'\1  >8 ) <sol\4-1 do'\3-1 mi'\2-1 >8 mi,8 [ <fad\4-2 si\3-3  re'\2-1 >8 ] mi,8 <si\3 re\4 >8 |
      \set doubleSlurs = ##f
      mi,8 [ <la\3-1>8 (] <sol\3>8 ) <la\3>8 ( <sol\3>8 ) [ <mi\4>8 (] <re\4>8 ) dod8 |
      r8 <re\4-\RH #2 >8 ( <mi\4-2>8 ) [ <sol\3-\RH #3 >8 ]<si\2-\RH #4 >8 [ <sol\3-\RH #3 >8 ] <mi\4-\RH #2 >8 <sol'\1-4-\RH #4 >8~ |
      sol'2 <re\4-\RH #2 >8 ( <red-1\4>8 ) ( <mi-3\4>8 ) [<sol\3-\RH #3 >8 ]|
    }
   }
   \bar "|."
  
#})

TrackAVoiceBMusic = #(define-music-function (parser location inTab) (boolean?)
#{
   \tempo 4=120
   \clef #(if inTab "tab" "treble_8")
   \key sol \major
   \time 4/4

   \set Staff.midiInstrument = #"acoustic guitar (steel)"
   \set fingeringOrientations = #'(left)
   \voiceTwo % basso col pollice
   r2 la,4 ( si,4 ) |
   \repeat volta 2 {
      <mi,\6>2 <mi,\6>2 |
      <la,\5>2 r8 <fad\4>8 ( <mi\4>8 ) [<sol\3>8] |
      <mi,\6>2 <mi,\6>2 |
      <la,\5>2 r8 <fad\4>8 ( <mi\4>8[ ) <sol\3>8] |
      <do-2\5>2 <sol,-2>2 |
   }
   \alternative {
    {
      <do\5-2>2 <sol,-2>2 |
      <si,\5>4. <la,-\RH #1 >8 <fad,-2>4_\markup { "perc."} r8 <si,-2\5>8 |
      <si,\5-2 red-1-\RH #2 >8 \glissando ( <do\5 mi>8 ) \glissando ( <si, red>4) do4-2 <dod-3\5>4   |
    }
    {
      <do\5-2>2 <sol,\6-2>2  |
      <mi,\6>2 <mi,\6>4 <mi,\6>4  |
      <mi,\6>4. <dod\5-3>2 <dod-3-\RH #1 >8 ( \glissando  |
      <do\5-3>1 ) |
      r2 <la,\5 >4 ( <si,-2\5>4 ) 
    }
   }
\repeat volta 2 {
      <mi,\6>2 <mi,\6>2 |
      <la,\5>2 r8 <fad\4>8 ( <mi\4>8 ) [<sol\3>8] |
      <mi,\6>2 <mi,\6>2 |
      <la,\5>2 r8 <fad\4>8 ( <mi\4>8[ ) <sol\3>8] |
      <do-2\5>2 <sol,-2>2 |
   }
   \alternative {
    {
      <do\5-2>2 <sol,-2>2 |
      <si,\5>4. <la,-\RH #1 >8 <fad,-2>4 r4  |
      r4 r8 <mi-1-\RH #1 >8 s2  |
    }
    {
      <do\5-2>2 <sol,\6-2>2  |
      <mi,\6>2 <mi,\6>4 <mi,\6>4  |
      <mi,\6>4. <dod\5-3>2 <dod-3-\RH #1 >8 ( \glissando  |
      <do\5-3>1 ) |
      r2 <la,\5 >4 ( <si,-2\5>4 ) 
    }
   }
   
   \bar "|."
   \pageBreak
#})
TrackAStaff = \new Staff <<
   \context Voice = "TrackAVoiceAMusic" {
      \TrackAVoiceAMusic ##f
   }
   \context Voice = "TrackAVoiceBMusic" {
      \TrackAVoiceBMusic ##f
   }
>>
TrackATabStaff = \new TabStaff = "tab" \with { stringTunings = #`(,(ly:make-pitch 0 2 NATURAL) ,(ly:make-pitch -1 6 NATURAL) ,(ly:make-pitch -1 4 NATURAL) ,(ly:make-pitch -1 1 NATURAL) ,(ly:make-pitch -2 5 NATURAL) ,(ly:make-pitch -2 2 NATURAL) ) } <<
   \context TabVoice = "TrackAVoiceAMusic" {
      \clef  "moderntab"
      \TrackAVoiceAMusic ##t
   }
   \context TabVoice = "TrackAVoiceBMusic" {
      \TrackAVoiceBMusic ##t
   }
>>
TrackAStaffGroup = \new StaffGroup <<
   \set StaffGroup.instrumentName = #"Guitar 1"
   \TrackAStaff
   \TrackATabStaff
>>
TrackBVoiceAMusic = #(define-music-function (parser location inTab) (boolean?)
#{
   \tempo 4=120
   \clef #(if inTab "tab" "treble_8")
   \key sol \major
   \time 4/4
   \set Staff.midiInstrument = #"acoustic guitar (steel)"
   \set fingeringOrientations = #'(left)
   \oneVoice
   r1  |
   \repeat volta 2 {
      r1  |
      r1  |
      r1  |
      r1  |
      r1  |
   }
   \alternative {
   {
      r1  |
      r1  |
      r1  |
   }
   {
      r1  |
      r1  |
      r1  |
      r1  |
      r1  |
   }}
   \voiceOne
   \repeat volta 2 {
      mi,8 [ <sol\3>8 ] <si'\1-1>8-> <sol\3>8 mi,8 [ <si\2>8 ] <si'\1-1>8-> \glissando <la'\1-1>8  |
      la,8 <dod'-2\3>8 <la-3\4>8 [ <si\2>8 ] la,8 [ <dod'\3>8 ] <la\4>8 <si\2>8  |
      mi,8 [ <sol\3>8 ] <fad'-1\2>8-> <sol\3>8 mi,8 [ <sol\3>8 ] <fad'-1\2>8-> \glissando <mi'-1\2>8^"t"  |
      <la,\6>8 [ <dod'-2\3>8 ] <mi-3\5>8 <mi'-1\2>8 <la,\6>8 <dod'~\3>8 <dod'\3>4  |
      <do\6>8 [ <sol\3>8 ] <re''-4\1>8 <sol\3>8 <do\6>8 <sol\3>8 <si'-1\1>8 [ <la'-4\2>8 ] |
   }
   \alternative {
     {
      <do\6>8 [ <sol\3>8 ] <do'\4>8 <sol'-1\2>8 <do\6>8 <la'-4\2>8 <do'\4>8 [ <si'-1\1>8 ] |
      <si'\1>4  \glissando \hideNotes \grace { sol'4 } \unHideNotes  r4 r2 |
      \oneVoice r1 \voiceOne |
     }
     {
      <do\6>8 [ <sol\3>8 ] <do'\4>8 <sol'-1\2>8 <do\6>8 <la'-4\2>8 <do'\4>8 [ mi'8 ] |
      r2.. si8~ |
      \oneVoice
      si2 r8 sib8 ( la8 ) [ sol8~ ] |
      sol2 r8 
      \voiceOne 
      <fad-2>8 ( \glissando fa8 ) \glissando ( mi8~ ) |
      mi2  r2 |
     }
   }


   \bar "|." %\mark \markup { \musicglyph #"scripts.coda" } |

#})

TrackBVoiceBMusic = #(define-music-function (parser location inTab) (boolean?)
#{
   \tempo 4=120
   \clef #(if inTab "tab" "treble_8")
   \key sol \major
   \set Staff.midiInstrument = #"acoustic guitar (steel)"
   \set fingeringOrientations = #'(left)
   \time 4/4
   \oneVoice
   \skip 4*4  |
   \repeat volta 2 {
      \skip 4*4  |
      \skip 4*4  |
      \skip 4*4  |
      \skip 4*4  |
      \skip 4*4  |
   }
   \alternative {
    {
      \skip 4*4  |
      \skip 4*4  |
      \skip 4*4  |
    }
    {
      \skip 4*4  |
      \skip 4*4  |
      \skip 4*4  |
      \skip 4*4  |
      \skip 4*4  |
    }
   }
   \voiceTwo
   \repeat volta 2 {
      <mi,\6>4^\markup {\musicglyph #"scripts.segno" } <si\4-3>4-> <mi,\6>4 <si\4>8-> \glissando <la\4>8  |
      <la,\5>4 <la\4>4 <la,\5>4 <la\4>4  |
      <mi,\6>4 <fad-3\5>4->_"t" <mi,\6>4 <fad\5-3>8-> \glissando <mi-3\5>8_"t"  |
      <la,\6>4_\markup {\teeny "T"} <mi\5>4 <la,\6>4 <mi\5>4  |
      <do\6>4_\markup {\teeny "T"} <si-2\4>4 <do\6>4 <si-2\4>4  |
   }
   \alternative {
    {
      <do\6>4_\markup {\teeny "T"} <do'-3\4>4 <do\6>4 <do'-2\4>4  |
      <si,\6>4_\markup {\teeny "T"} \glissando \hideNotes \grace { sol,4 } \unHideNotes  r4 r2 |
      s1 |
    }
    {
      <do\6>4_\markup {\teeny "T"} <do'-3\4>4 <do\6>4 <do'\4>4  |
      mi,8 ( [ <fad,-2>8 ]) ( <sol,-3>8) la,8 \acciaccatura la,8 <si,-2\5>8 <re\4>8 (  <mi-2\4>8 ) [si8 ]|
      s1 |
      s2 s8 <re-3\5>8 ( \glissando <dod\5>8 ) \glissando ( <do\5>8~ ) |
      <do\5>2 r2|

    }
   }

   \bar "|."

#})


TrackBStaff = \new Staff <<
   \context Voice = "TrackBVoiceAMusic" {
      \clef "G_8"
      \TrackBVoiceAMusic ##f
   }
   \context Voice = "TrackBVoiceBMusic" {
      \TrackBVoiceBMusic ##f
   }
>>
TrackBTabStaff = \new TabStaff \with { stringTunings = #`(,(ly:make-pitch 0 2 NATURAL) ,(ly:make-pitch -1 6 NATURAL) ,(ly:make-pitch -1 4 NATURAL) ,(ly:make-pitch -1 1 NATURAL) ,(ly:make-pitch -2 5 NATURAL) ,(ly:make-pitch -2 2 NATURAL) ) } <<
   \context TabVoice = "TrackBVoiceAMusic" {
      \TrackBVoiceAMusic ##t
   }
   \context TabVoice = "TrackBVoiceBMusic" {
      \TrackBVoiceBMusic ##t
   }
>>
TrackBStaffGroup = \new StaffGroup <<
   \set StaffGroup.instrumentName = #"Guitar 2"
   \TrackBStaff
   \TrackBTabStaff
>>
\score {
   <<
   \TrackAStaffGroup
   \TrackBStaffGroup
   >>
   % \midi  {}
   \layout {}
   \header {
      title = "Ode to Billy's Hoe" 
      composer = "Rick Ruskin" 
      arranger = "Giovanni Unterberger"
   }
}

