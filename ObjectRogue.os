directory
{
    local role family ObjectRogue
    {
        Simulation method group Simulation
    }
}

#define KEY_ESC 0x1B
#define KEY_UP 0x11
#define KEY_RIGHT 0x14
#define KEY_DOWN 0x12
#define KEY_LEFT 0x13

module ObjectRogue

personal public method main
{
    Host out printLine("Starting up ObjectRogue");

    Console hideCursor;

    |sim| = Simulation new;
    sim render;  
 
    |exiting| = False;
    {exiting} whileFalse: {
        |c| = Host in readChar;
        (c asInteger == KEY_ESC) ifTrue: {exiting = True};
        sim tick(c);
        sim render;
    };

    Console showCursor;
}

method group (Simulation)
{
    protected attribute fb;
    protected attribute map;
    protected attribute x;
    protected attribute y;

    personal public method new
    {
        |sim| = Object new;
        sim influence: Influence new(self);
        sim::fb = FrameBuffer x: Console columns y: Console rows;
        sim::x = 0;
        sim::y = 0;
        sim::map = AnsiMap csv: "Test.csv";
        return sim;
    }

    public method tick
    {|(input)|
        { x += 1 } if: { input asInteger == KEY_RIGHT } else:
        { y += 1 } if: { input asInteger == KEY_DOWN } else:
        { x -= 1 } if: { input asInteger == KEY_LEFT } else:
        { y -= 1 } if: { input asInteger == KEY_UP }
    }

    public method render
    {   
        fb clear;
        1 to: 5 do: {
        |(i)|
            fb draw(10 + i - x, 10 - y, '@', 32, 43, 1);
        };
        fb draw(0 - x, 0 - y, receiver::map, 0);
        fb toConsole;
    }
}
