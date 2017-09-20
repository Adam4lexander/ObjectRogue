module ObjectRogue

personal public method main
{
    Host out printLine("Starting up ObjectRogue");

    Console hideCursor;
    |fb| = FrameBuffer x: Console columns y: Console rows;

    1 to: 5 do: {
    |(i)|
        fb draw(10+i, 10, '@', 32, 43, 1);    
    };

    fb toConsole;

    Console showCursor;
}

