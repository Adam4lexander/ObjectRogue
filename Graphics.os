directory
{
    local role family ObjectRogue
    {
        FrameBuffer method group FrameBuffer,
        Console method group Console
    }
}

module Graphics

method group (FrameBuffer){
    protected attribute chars;
    protected attribute backColours;
    protected attribute frontColours;
    protected attribute depths;

    protected attribute for write width;
    public attribute for read width;
    protected attribute for write height;
    public attribute for read height;

    personal public method new as x:y:
    {|(x, y)|
        |f| = Object new;
        f influence: Influence new(self);
        f resize(x, y);
        return f;
    }

    public method resize as x:y:
    {|(x, y)|
        width = x;
        height = y;

        chars = Array size: (width * height);
        backColours = Array size: (width * height);
        frontColours = Array size: (width * height);
        depths = Array size: (width * height);
        receiver clear;
    }

    public method clear 
    {
        1 to: (depths size) do: 
        {|(i)|
            chars[i] = ' ';
            backColours[i] = 0;
            frontColours[i] = 7;
            depths[i] = 99999;
        } 
    }

    public method draw
    {|(x, y, char, backCol, frontCol, depth)|
        (x < 0 || x >= width || y < 0 || y >= height) ifTrue: {return};
        |ind| = y * width + x + 1; // OT arrays are 0 exclusive
        (depth >= depths[ind]) ifTrue: {return};

        chars[ind] = char;
        backColours[ind] = backCol;
        frontColours[ind] = frontCol;
        depths[ind] = depth;
    }

    public method draw
    {|(x, y, map : AnsiMap, depth)|
        |area| = map::width * map::height;
        0 to: (area - 1) do:
        {|(i)|
            |mx| = i % (map::width);
            |my| = i / (map::width);
            |fbx| = x + mx;
            |fby| = y + my;
            (fbx < 0 || fbx >= receiver::width || fby < 0 || fby >= receiver::height) ifFalse: {
                receiver draw(fbx, fby, map character(mx, my), map backgroundColour(mx, my), map foregroundColour(mx, my), depth);
            }
        }
    }

    public method toConsole
    {
        Console goto(0, 0);
        1 to: (width*height) do:
        {|(i)|
            |bc| = backColours[i];
            |fc| = frontColours[i];
            (fc < 10) ifTrue: { Console graphics(bc + 40, fc + 30) }
            ifFalse: { Console graphics(fc - 10 + 90, bc + 40) };
            Host out print(chars[i]);
            (i % width == 0) ifTrue: {Host out print("\n")};
        };
        Host out flush;
    }
}

method group (Console){
    shared protected method ESC { 27 asCharacter }
    shared protected method CSI { "\\e[" }

    shared public method clear
    {
        Host out print(receiver ESC + "[2J");
        Host out flush;
    }

    shared public method goto
    {|(x, y)|
        Host out print(Receiver ESC + "[" + x + ";" + y + "H");
        Host out flush;
    }

    shared public method graphics
    {|(code ...)|
        |codes| = {} variableParameters append: code;
        Host out print(Receiver ESC + "[");
        codes doWithIndex: 
        {|(code, i)|
            Host out print(code asString);
            (i < codes size) ifTrue: { Host out print(";") };
        };
        Host out print("m");
        Host out flush;
    }

    shared public method backgroundColour
    {|(r, g, b)|
        Host out print(Receiver ESC + "[38;2;");
        Host out print(r + ";" + g + ";" + b);
        Host out print("m");
        Host out flush;
    }

    shared public method hideCursor
    {
        Host systemCall: "setterm -cursor off";
    }

    shared public method showCursor
    {
        Host systemCall: "setterm -cursor on";
    }

    shared public method mode
    {|(code)|
        Host out print(Receiver ESC + "[=" + code + "h");
        Host out flush;
    }

    shared public method columns { (receiver runCommand: "tput cols") asInteger; }
    shared public method rows { (receiver runCommand: "tput lines") asInteger - 1; }

    shared protected method runCommand as runCommand: 
    {|(cmd : String -> String)|
        Host systemCall: cmd + "> temp";
        |value| = (File openAsTextInput: "temp") readLine;
        File delete: "temp";
        return value;
    }
}
