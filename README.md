## Word Count

Counts characters, words, **numbers**, and lines.

### Build

    make

### Usage

Pass text in via stdin:

    cat wc.l | ./wc

    lines     words   numbers     chars
       23        48        11       445

    echo '13 black cats in a size 11.5 hat' | ./wc

    lines     words   numbers     chars
        1         6         2        33

    ./wc        
    17 frogs hopped across
    the 4-lane highway.
    ^D

    lines     words   numbers     chars
        2         6         2        43


### Why?

Regular word count doesn't do numbers, mine does  :)
