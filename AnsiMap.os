directory
{
    local role family ObjectRogue
    {
        AnsiMap method group AnsiMap
    }
}

module AnsiMap

method group (AnsiMap){
    protected attribute data;
    protected attribute for write width;
    public attribute for read width;
    protected attribute for write height;
    public attribute for read height;

    personal public method csv:
    {|(filename)|
        |map| = Object new;
        map influence: Influence new(self);
        map csv: filename;
        return map;
    }

    protected method csv:
    {|(filename)|
        data = (CSV fromFile: filename);
        data do: 
        {|(line)|
            |c| = line[3] asInteger asCharacter;
            (c asInteger == 0) ifTrue: {c = ' '};
            line[3] = c 
        };
        receiver::width = data[data size][1] asInteger + 1;
        receiver::height = data[data size][2] asInteger + 1;
    }
    
    public method character
    {|(x, y)|
        |i| = idx(x, y);
        (data[i] size == 1) ifTrue: {Host out printLine("HERE: " + data[i+1][1] + " " + i)};
        data[i][3];
    }

    public method backgroundColour
    {|(x, y)|
        |i| = idx(x, y);
        data[i][4];
        40;
    }

    public method foregroundColour
    {|(x, y)|
        |i| = idx(x, y);
        data[i][5];
        37;
    }

    private method idx
    {|(x, y)|
        (y * receiver::width) + x + 2; // Plus 2 for first line having headers
    }
}
