#!/bin/bash

# it uses at least this (for italian chord names) : https://github.com/mammadori/chordii.git

PROGRAMNAME=$(basename $0)
SONGBOOK="Canzoniere"

TMPFILE=$(mktemp "/tmp/${PROGRAMNAME}_XXXXXX")

printf "\n{ns}\n" > "${TMPFILE}"

if [ "$1" = "DEBUG" ]; then
    for source in *.chopro ; do
        echo "Doing ${source}"
        iconv -f "UTF-8" -t "ISO-8859-1" "${source}" > ${TMPFILE}.chopro
        chordii -a -g -I  ${TMPFILE}.chopro | ps2pdf - - > ${TMPFILE}.pdf
    done
    rm -f "${TMPFILE}.pdf" "${TMPFILE}.chopro"
else
    echo "Generating songbook"
    find . -name "*.chopro" -print0 | sort -z | xargs -0 -i cat "{}" ${TMPFILE} | iconv -f UTF-8 -t ISO-8859-1 >> "${SONGBOOK}.txt"
    chordii -a -g -I -i "${SONGBOOK}.txt" | ps2pdf - - > "${SONGBOOK}.pdf"
    echo "Generating single songs"
    find . -name "*.chopro" | sort | while read filename ; do
        base=$(basename "${filename}" .chopro)
        iconv -f UTF-8 -t ISO-8859-1 "${filename}" > "/tmp/${base}.chopro"
        chordii -a -g -I "/tmp/${base}.chopro" | ps2pdf - - > "${base}.pdf"
    done
    rm -f "${SONGBOOK}.txt"
fi

rm -f "${TMPFILE}"
