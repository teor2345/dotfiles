#!/bin/bash

MIN_WORD_LEN=4
MAX_WORD_LEN=6

WORDS="/usr/share/dict/words"
N_WORDS=`wc -l "$WORDS" | cut -d/ -f1 | tr -d " " `
N_WORDS_LEN=`echo -n "$N_WORDS" | wc -c | tr -d " "`

WORD_LEN=0
while [ "$WORD_LEN" -eq 0 -o "$WORD_LEN" -lt "$MIN_WORD_LEN" -o \
    "$WORD_LEN" -gt "$MAX_WORD_LEN" ] ; do

    # head is 1-based
    RANDOM_LINE="0"
    # rejection sampling
    while [ "$RANDOM_LINE" -eq 0 -o "$RANDOM_LINE" -gt "$N_WORDS" ] ; do
        RANDOM_LINE=`cat /dev/random | LANG=C tr -dc '0-9' | head -c "$N_WORDS_LEN"`
    done

    WORD=`head -"$RANDOM_LINE" "$WORDS" | tail -1`
    WORD_LEN=`echo -n "$WORD" | wc -c | tr -d " "`

done

echo "$WORD"