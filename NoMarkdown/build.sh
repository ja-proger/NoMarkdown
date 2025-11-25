#!/usr/bin/sh

#  build.sh
#  NoMarkdown
#  © JA Proger, All Rights Reserved, 2025
#  https://github.com/ja-proger/
#  https://dev.to/japroger

echo "\033[1;35mNoMarkdown Tool\033[0m\nJA Proger, © All Rights Reserved, 2025\nhttps://github.com/ja-proger/\n"
swiftc main.swift -o nomd &
pid=$!
spinner='①②③④'
i=0

while kill -0 $pid 2>/dev/null; do
    i=$(( (i+1) % 4 ))
    printf "\rCompiling source code %s" "${spinner:$i:1}"
    sleep 0.2
done

wait $pid
status=$?

if [ $status -eq 0 ]; then
    printf "\nMoving executable to the '\033[3;36m/usr/local/bin\033[0m'\n"
    mv nomd /usr/local/bin
    printf "\033[1;32mSuccessful!\033[0m\n"
else
    printf "\n\033[1;33mSomething went wrong!\033[0m\n"
fi
