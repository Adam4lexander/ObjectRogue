module DrawFont

personal public method main
{
    Console graphics(97, 40);

    0 to: 255 do:
    {|(i)|
        (i % 16 == 0) ifTrue: {Host out printLine};
        Host out print((AnsiMap toUnicode: i) asCharacter);
        Host out flush;
    };
    Host out printLine;
    Host out printLine;
}
