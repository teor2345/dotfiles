cat /dev/random | head -c 40 | xxd | cut -d" " -f2-10 | tr -d " \n" && echo
