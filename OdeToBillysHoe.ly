#(define (tie::tab-clear-tied-fret-numbers grob)
   (let* ((tied-fret-nr (ly:spanner-bound grob RIGHT)))
      (ly:grob-set-property! tied-fret-nr 'transparent #t)))

#(define RH rightHandFinger)

\version "2.16.0"
\paper {
   top-margin = 8
   page-count = #3
   print-all-headers = ##t
   ragged-right = ##f
   ragged-bottom = ##f
   
   
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


TrackAVoiceAMusic = #(define-music-function (parser location inTab) (boolean?)
#{
   \tempo 4=120
   \clef #(if inTab "tab" "treble_8")
   \key g \major
   \time 4/4
   \set Staff.midiInstrument = #"acoustic guitar (steel)"
   \set fingeringOrientations = #'(left)
   \voiceOne % parte melodica, indice, medio, anulare
   r2 <d\4-\RH #2 >8 ( <dis-1\4>8 ) ( <e-3\4>8 ) [<g\3-\RH #3 >8 ]|
   \repeat volta 2 {

     \mergeDifferentlyHeadedOn
      r8 <g\3>8 \acciaccatura <f'-2\1>8 \glissando <fis'\1-\RH #4 b\2-\RH #3 >4~ <fis'\1  b\2 >8 ( <e'\1>8 ) <d'-3\2-\RH #4 >8 [
      \textSpannerUp % barré
      \override TextSpanner #'(bound-details left text) = #"4/6 B II "
       <cis'\2-\RH #4 e\4-\RH #2 >8 ] \startTextSpan |
       r8 <cis'-\RH #4 e-\RH #2 >8 ( <d'\2-2 fis\4-3 >8 )[ 
      \stopTextSpan
      
      <e'\1~ a\3( >8 ] <e'\1 g\3) >8  fis8 r8 <g-\RH  #2 > |
      e,8 <g\3>8 <fis'\1 b\2 >4~ <b\2 fis'\1 >8 [ \( \acciaccatura {<g'\1>16 [ <fis'\1>16 ]  } <e'\1>8 ]  \)  <d'\2-3-\RH #4 >8  [ 
      
      \textSpannerUp % barré
      <cis'\2-\RH #4  e\4-\RH #2 >8 ] \startTextSpan |
      r8 <cis'\2 e\4 >8 ( <d'-2\2 fis\4-3 >8 ) [
      \stopTextSpan
      
      <e'\1~ a\3 >8 ] ( <e'\1 g\3 >8 ) <fis-\RH #1 >8 r8 <g> |
      r4 <fis'-1\1-\RH #4 >8 <g\3-\RH #2 >8 <g,\6>8 [ <d'-3\2-\RH #3 >8 ] <g\3>8 <g'-4\1>8  |
   }
   \alternative {
    {
      c8 [ <g'\1-4>8 ] ( <fis'\1-1>8 ) <g\3>8 <e'\1>8 [ <d'\2-3>8 ] <g\3-\RH #2 >8 <b\2-\RH #4 >8 |
     \mergeDifferentlyHeadedOn
     \mergeDifferentlyDottedOn
      <b,\5-2>8 [ <a\3-3-\RH #3 >8 ]  <dis\4-1-\RH #2 >8  <a,\5>8 r2  |
      <a\3-3-\RH #3 >8 \glissando ([ <ais\3 >8 ]) \glissando (<a\3 >8 ) (<g\3>8 )  a-1 ( [ g8 ) ] <e\4-1>8 [ ( d8 ) ]|
    }
    {
      \override TextSpanner #'(bound-details left text) = #"4/6 B V "
      \textSpannerUp % barré 
               
      
      c8 [ <g'\1>8 ] ( <fis'\1>8 ) <g\3>8 <e'\1>8 [ <d'\2>8 ] <g\3>8 <e'\1-\RH #4 >8 |
      e,8 [  <a\3-2-\RH #4 fis'\1-1-\RH #2  >8 ( ] \startTextSpan
      
      
      <g\3   e'\1  >8 )
      \stopTextSpan
      
      <g\4 c'\3 e'\2 >8 e,8 [ <fis\4-2 b\3-3  d'\2-1 >8 ] e,8 <b\3-\RH #4 d\4-\RH #2 >8 |
      e,8 [ <a\3-1>8 (] <g\3>8 ) <a\3>8 ( <g\3>8 ) [ <e\4>8 (] <d\4>8 ) cis8 |
      r8 <d\4-\RH #2 >8 ( <e\4-2>8 ) [ <g\3-\RH #3 >8 ]<b\2-\RH #4 >8 [ <g\3-\RH #3 >8 ] <e\4-\RH #2 >8 <g'\1-4-\RH #4 >8~ |
      g'2 <d\4-\RH #2 >8 ( <dis-1\4>8 ) ( <e-3\4>8 ) [<g\3-\RH #3 >8 ]|
    }
   }
   \repeat volta 2 {

     \mergeDifferentlyHeadedOn
      r8^\markup {\musicglyph #"scripts.segno" } <g\3>8 \acciaccatura <f'-2\1>8 \glissando <fis'\1-\RH #4 b\2-\RH #3 >4~ <fis'\1  b\2 >8 ( <e'\1>8 ) <d'-3\2-\RH #4 >8 [
      \textSpannerUp % barré
      \override TextSpanner #'(bound-details left text) = #"4/6 B II "
       <cis'\2-\RH #4 e\4-\RH #2 >8 ] \startTextSpan |
       r8 <cis'-\RH #4 e-\RH #2 >8 ( <d'\2-2 fis\4-3 >8 )[ 
      \stopTextSpan
      
      <e'\1~ a\3( >8 ] <e'\1 g\3) >8  fis8 r8 <g-\RH  #2 > |
      e,8 <g\3>8 <fis'\1 b\2 >4~ <b\2 fis'\1 >8 [ \( \acciaccatura {<g'\1>16 [ <fis'\1>16 ]  } <e'\1>8 ]  \)  <d'\2-3-\RH #4 >8  [ 
      
      \textSpannerUp % barré
      <cis'\2-\RH #4  e\4-\RH #2 >8 ] \startTextSpan |
      r8 <cis'\2 e\4 >8 ( <d'-2\2 fis\4-3 >8 ) [
      \stopTextSpan
      
      <e'\1~ a\3 >8 ] ( <e'\1 g\3 >8 ) <fis-\RH #1 >8 r8 <g> |
      r4 <fis'-1\1-\RH #4 >8 <g\3-\RH #2 >8 <g,\6>8 [ <d'-3\2-\RH #3 >8 ] <g\3>8 <g'-4\1>8  |
   }
   \alternative {
       {
      c8 [ <g'\1-4>8 ] ( <fis'\1-1>8 ) <g\3>8 <e'\1>8 [ <d'\2-3>8 ] <g\3-\RH #2 >8 <b\2-\RH #4 >8 |
     \mergeDifferentlyHeadedOn
     \mergeDifferentlyDottedOn
      <b,\5-2>8 [ <a\3-3-\RH #3 >8 ]  <dis\4-1-\RH #2 >8  <a,\5>8 r4 r8^\markup { "perc." } <dis'-3>8 (  |
      <e'\2-3 >8-> ) [ <e'\1 >8 ] <e'-\RH #4 ~ a-1-\RH #2 >16 ( <e' g>16 )  e8 
      \acciaccatura <a-2>8 \glissando <b-2>8 [ <d'-1>8 ]\acciaccatura <b-2>8 \glissando <a-2>8 ( <g\3>8 ) |
    }
    {
      c8 [ <g'\1>8 ] ( <fis'\1>8 ) <g\3>8 <e'\1>8 [ <d'\2>8 ] <g\3>8 <e'\1-\RH #4 >8 |
      e,8 [  <a\3-2-\RH #4 fis'\1-1-\RH #2  >8 ( ] <g\3   e'\1  >8 ) <g\4 c'\3 e'\2 >8 e,8 [ <fis\4-2 b\3-3  d'\2-1 >8 ] e,8 <b\3 d\4 >8 |
      e,8 [ <a\3-1>8 (] <g\3>8 ) <a\3>8 ( <g\3>8 ) [ <e\4>8 (] <d\4>8 ) cis8 |
      r8 <d\4-\RH #2 >8 ( <e\4-2>8 ) [ <g\3-\RH #3 >8 ]<b\2-\RH #4 >8 [ <g\3-\RH #3 >8 ] <e\4-\RH #2 >8 <g'\1-4-\RH #4 >8~ |
      g'2 <d\4-\RH #2 >8 ( <dis-1\4>8 ) ( <e-3\4>8 ) [<g\3-\RH #3 >8 ]|
    }
   }
   \bar "|."
  
#})

TrackAVoiceBMusic = #(define-music-function (parser location inTab) (boolean?)
#{
   \tempo 4=120
   \clef #(if inTab "tab" "treble_8")
   \key g \major
   \time 4/4
   \set Staff.midiInstrument = #"acoustic guitar (steel)"
   \set fingeringOrientations = #'(left)
   \voiceTwo % basso col pollice
   r2 a,4 ( b,4 ) |
   \repeat volta 2 {
      <e,\6>2 <e,\6>2 |
      <a,\5>2 r8 <fis\4>8 ( <e\4>8 ) [<g\3>8] |
      <e,\6>2 <e,\6>2 |
      <a,\5>2 r8 <fis\4>8 ( <e\4>8[ ) <g\3>8] |
      <c-2\5>2 <g,-2>2 |
   }
   \alternative {
    {
      <c\5-2>2 <g,-2>2 |
      <b,\5>4. <a,-\RH #1 >8 <fis,-2>4_\markup { "perc."} r8 <b,-2\5>8 |
      <b,\5-2 dis-1-\RH #2 >8 \glissando ( <c\5 e>8 ) \glissando ( <b, dis>4) c4-2 <cis-3\5>4   |
    }
    {
      <c\5-2>2 <g,\6-2>2  |
      <e,\6>2 <e,\6>4 <e,\6>4  |
      <e,\6>4. <cis\5-3>2 <cis-3-\RH #1 >8 ( \glissando  |
      <c\5-3>1 ) |
      r2 <a,\5 >4 ( <b,-2\5>4 ) 
    }
   }
\repeat volta 2 {
      <e,\6>2 <e,\6>2 |
      <a,\5>2 r8 <fis\4>8 ( <e\4>8 ) [<g\3>8] |
      <e,\6>2 <e,\6>2 |
      <a,\5>2 r8 <fis\4>8 ( <e\4>8[ ) <g\3>8] |
      <c-2\5>2 <g,-2>2 |
   }
   \alternative {
    {
      <c\5-2>2 <g,-2>2 |
      <b,\5>4. <a,-\RH #1 >8 <fis,-2>4 r4  |
      r4 r8 <e-1-\RH #1 >8 s2  |
    }
    {
      <c\5-2>2 <g,\6-2>2  |
      <e,\6>2 <e,\6>4 <e,\6>4  |
      <e,\6>4. <cis\5-3>2 <cis-3-\RH #1 >8 ( \glissando  |
      <c\5-3>1 ) |
      r2 <a,\5 >4 ( <b,-2\5>4 ) 
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
   \key g \major
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
      e,8 [ <g\3>8 ] <b'\1-1>8-> <g\3>8 e,8 [ <b\2>8 ] <b'\1-1>8-> \glissando <a'\1-1>8  |
      a,8 <cis'-2\3>8 <a-3\4>8 [ <b\2>8 ] a,8 [ <cis'\3>8 ] <a\4>8 <b\2>8  |
      e,8 [ <g\3>8 ] <fis'-1\2>8-> <g\3>8 e,8 [ <g\2>8 ] <fis'-1\2>8-> \glissando <e'-1\2>8^"t"  |
      <a,\6>8 [ <cis'-2\3>8 ] <e-3\5>8 <e'-1\2>8 <a,\6>8 <cis'~\3>8 <cis'\3>4  |
      <c\6>8 [ <g\3>8 ] <d''-4\1>8 <g\3>8 <c\6>8 <g\3>8 <b'-1\1>8 [ <a'-4\2>8 ] |
   }
   \alternative {
     {
      <c\6>8 [ <g\3>8 ] <c'\4>8 <g'-1\2>8 <c\6>8 <a'-4\2>8 <c'\4>8 [ <b'-1\1>8 ] |
      <b'\1>4  \glissando \hideNotes \grace { g'4 } \unHideNotes  r4 r2 |
      \oneVoice r1 \voiceOne |
     }
     {
      <c\6>8 [ <g\3>8 ] <c'\4>8 <g'-1\2>8 <c\6>8 <a'-4\2>8 <c'\4>8 [ e'8 ] |
      r2.. b8~ |
      \oneVoice
      b2 r8 bes8 ( a8 ) [ g8~ ] |
      g2 r8 
      \voiceOne 
      <fis-2>8 ( \glissando f8 ) \glissando ( e8~ ) |
      e2  r2 |
     }
   }

  
   \bar "|." %\mark \markup { \musicglyph #"scripts.coda" } |
  
#})

TrackBVoiceBMusic = #(define-music-function (parser location inTab) (boolean?)
#{
   \tempo 4=120
   \clef #(if inTab "tab" "treble_8")
   \key g \major
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
      <e,\6>4^\markup {\musicglyph #"scripts.segno" } <b\4-3>4-> <e,\6>4 <b\4>8-> \glissando <a\4>8  |
      <a,\5>4 <a\4>4 <a,\5>4 <a\4>4  |
      <e,\6>4 <fis-3\5>4->_"t" <e,\6>4 <fis\5-3>8-> \glissando <e-3\5>8_"t"  |
      <a,\6>4_\markup {\teeny "T"} <e\5>4 <a,\6>4 <e\5>4  |
      <c\6>4_\markup {\teeny "T"} <b-2\4>4 <c\6>4 <b-2\4>4  |
   }
   \alternative {
    {
      <c\6>4_\markup {\teeny "T"} <c'-3\4>4 <c\6>4 <c'-2\4>4  |
      <b,\6>4_\markup {\teeny "T"} \glissando \hideNotes \grace { g,4 } \unHideNotes  r4 r2 |
      s1 |
    }
    {
      <c\6>4_\markup {\teeny "T"} <c'-3\4>4 <c\6>4 <c'\4>4  |
      e,8 ( [ <fis,-2>8 ]) ( <g,-3>8) a,8 \acciaccatura a,8 <b,-2\5>8 <d\4>8 (  <e-2\4>8 ) [b8 ]|
      s1 |
      s2 s8 <d-3\5>8 ( \glissando <cis\5>8 ) \glissando ( <c\5>8~ ) |
      <c\5>2 r2|
      
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
   \header {
      title = "Ode to Billy's Hoe" 
      composer = "Rick Ruskin" 
   }
}
