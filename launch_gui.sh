#!/bin/bash



CHOICE=$(zenity --list --title="Dev Envs Launcher" --column="Option" --column="Environment" \

    1 "HTML" \

    2 "CSS" \

    3 "HTML+CSS" \

    4 "JavaScript" \

    5 "HTML+JavaScript" \

    6 "C++")



cd "$HOME/dev-envs"



case $CHOICE in

    1) xdg-open html/index.html ;;

    2) xed css/style.css ;;  # Change xed to your preferred editor (e.g., gedit, nano, code)

    3) xdg-open html-css/index.html ;;

    4) gnome-terminal -- bash -c "node javascript/index.js; exec bash" ;;

    5) xdg-open html-js/index.html ;;

    6) gnome-terminal -- bash -c "cd cpp && g++ main.cpp -o app && ./app; exec bash" ;;

    *) zenity --error --text="Invalid choice or canceled." ;;

esac


