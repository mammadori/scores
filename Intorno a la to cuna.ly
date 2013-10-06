\header {
	title = "Intorno a la to cuna"
	composer = "Bepi de Marzi"
	enteredby="Marco Amadori"
	maintainer="marco.amadori@gmail.com"
	meter = \markup {Dolcemente, \italic { con semplicità}}
	texidoc = "Una delicata ninna nanna dal sapore nostalgicamente montano."
}

\version "2.10.33"



\paper {
	#(set-paper-size "a4")
	line-width = #(* mm 160)
	indent = 8\mm
	interscoreline = 2.\mm
	between-system-space = 15\mm
%	ragged-bottom = ##f
%	ragged-last-bottom = ##f
}

global = {
	\key bes \major
	\time 4/4
	\partial 4
}

%modernAccidentals = {
%  \set Staff.extraNatural =  ##f
%  \set Staff.autoAccidentals =  #'(Staff (same-octave . 1) (any-octave . 0))
%  \set Staff.autoCautionaries =  #'()
%}

primi = \relative c {
	\override Score.BarNumber #'padding = #2
	\override Score.PaperColumn #'keep-inside-line = ##t
	\override Score.VoltaBracket #'minimum-space = #6
	\set Staff.voltaSpannerDuration = #(ly:make-moment 4 4)

	\dynamicUp
	f \p
\override BreathingSign #'extra-offset = #'(0.0 . 1.0)
%\override BreathingSign #'text = #(text ",")
	\repeat volta 2 {
		d'4. d8 d4 bes |
		f'2 f4 f |
		g4.  f8 ees4 f |
		d2. \breathe f,4 |

		d'4. d8 d4 bes |
		f'2 f4 f |
		g4. f8 ees4 f |
		d2.\breathe bes4 \bar "||"
		g'4. g8 g4 bes |

		f2 f4 bes, |
		g'4. g8 g4 bes |
		a( g) f\<  f\!  |
		d4.\p d8 d4 bes |
		f'2 f4 f4 |

		g4. f8 ees4 f |
	} %repeat
	\alternative {
		{ \override DynamicLineSpanner #'padding = #1.9
		d2. \breathe f,4\pp }
		{ \override DynamicLineSpanner #'padding = #0.5
		d'2\pp
		\once \override TextScript #'padding = #0.7
		d2~ ^\markup {\italic {rall.}} }} |
		d1~ |

	<< \new Voice = "primissimi" { \voiceOne
		\tiny
		%r2  | r1 |
		r2 g4 g | a a g g | a1 }
	{ \voiceOne
		\override DynamicLineSpanner #'staff-padding = #3.6
		\override Script #'padding = #1.8
		|\tieDown d,1~   | d | d  \fermata \ppp } >>

	\bar "|."
}

secondi = \relative c  {
	f4 |
	bes4. bes8 bes4 bes |
	c2 d4 d |
	ees4. d8 c4 c |
	bes2. f4 |

	bes4. bes8 bes4 bes |
	c2 d4 d4 |
	ees4. d8 c4 c |
	bes2. bes4 |
	ees4. ees8 ees4 d |

	c2 d4 bes |
	ees4. f8 ees4 e |
	f( e) ees c |
	bes4. bes8 bes4 bes |
	a2 a4 bes |

	bes4. bes8 bes4 a |
	bes2. f4 |
	bes2 bes~ |
	bes1~ |
	bes ~ |
	bes | \override Script #'padding = #1 % fermata
	bes \fermata |
}

baritoni = \relative c {
	f4 |
	f4. f8 f4 g |
	a2 bes4 a |
	bes4. a8 bes4 a |
	f2. f4 |

	f4. f8 f4 g |
	a2 bes4 a |
	bes4. a8 bes4 a |
	f2. bes4 |
	bes4. bes8 bes4 g |

	a2  bes4 aes |
	bes4. b8 c4 c |
	c( bes) bes a|
	f4. f8 g4 g |
	f2 f4 f |

	ees4. f8 g4 f |
	f2. f4 | \override Script #'padding = #3 % fermata
	f2 g2( | f g | f g | f g | f1) \fermata
}

bassi = \relative c  {
	f4 |
	bes,4. bes8 bes4 g' |
	f2 f4 f |
	ees4. f8 g4 f |
	bes,2. f'4 |

	bes,4. bes8 bes4 g' |
	f2 f4 f |
	ees4. f8 g4 f |
	bes,2. bes'4 |
	ees,4. ees8 ees4 g |

	a2  bes4 f |
	ees4. d8 c4 c |
	f( c) f f|
	bes,4. bes8 bes4 d |
	c2 d4 d |

	c4. c8 c4 c |
	bes2. f'4 |\override Script #'padding = #3.5 % fermata
	bes,2 d( | bes d | bes d | bes d | bes1) \fermata
}

dropLyrics =
{
    \override LyricText #'extra-offset = #'(0 . -2)
    \override LyricHyphen #'extra-offset = #'(0 . -2)
    \override LyricExtender #'extra-offset = #'(0 . -2)
}

primastrofa = \lyricmode {
	\set stanza = "1."
	In-  tor-  no~al-  la  to cu- na l'a- mor se gà~in can- tà
	El co- re de to pa- re la bar- ba gà tre- mà
	To ma- ma zé con- ten- ta con- ten- ti zé~i al- pi -- ni e
	tu- ti gà bam- bi- ni che pian- ze da cu- nar
	Can- \dropLyrics tà Oh __
}

secondastrofa = \lyricmode {
	\set stanza = "2."
	\skip 1 te- mo- ghe 'na sto- ria che fas- sa indor- mes- sar
	Can te- mo pian pia- nè- lo la fa- cia imbam- bo- là
	Te ghè ma- ni- ne bian- che e~i o- ci  co- me~'l cie -- lo
	In tor- no~al fa go- te lo zé fes- ta de bon-
}

finale = \lyricmode {
	\tiny
	Nin- na nan- na nan- na oh __
}

\score {

	\new ChoirStaff <<
		\new Lyrics = finale { s1 }
		\new Staff = Tenori <<
			\clef "G_8"
			\new Voice = "primi" { \voiceOne << \global \primi >> }
			\new Voice = "secondi" { \voiceTwo << \global \secondi >> }
		>>
		\new Lyrics = primastrofa { s1 }
		\new Lyrics = secondastrofa { s2 }

		\new Staff = BB <<
			\clef bass
			\new Voice = "baritoni" { \voiceOne << \global \baritoni >> }
			\new Voice = "bassi" { \voiceTwo << \global \bassi >> }
		>>

		\context Lyrics = finale \lyricsto "primissimi" \finale
		\context Lyrics = primastrofa \lyricsto "secondi" \primastrofa
		\context Lyrics = secondastrofa \lyricsto "secondi" \secondastrofa

	>>

	\layout {
		\context {
			% a little smaller so lyrics
			% can be closer to the staff
		%	\Staff
		%	\override VerticalAxisGroup #'minimum-Y-extent = #'(-3 . 3)
		}
	}
}

