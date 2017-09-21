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
    personal protected attribute charMap;
    protected attribute for write width;
    public attribute for read width;
    protected attribute for write height;
    public attribute for read height;

    personal restricted method Initialise
    {
        charMap = CSV fromFile: "charConversion.csv" splitOn: 0x09;
    }

    personal public method csv:
    {|(filename)|
        |map| = Object new;
        map influence: Influence new(self);
        map csv: filename;
        return map;
    }

    protected method csv:
    {|(filename)|
        data = CSV fromFile: filename splitOn: ',';
        data do: 
        {|(line)|
            |c| = line[3] asInteger;
            (c asInteger == 0) 
                ifTrue: {c = ' ' asInteger}
                ifFalse: {c = receiver parseHex(AnsiMap::charMap[c+1][2])};
            line[3] = c asCharacter;
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

    private method parseHex
    {|(hexString)|
        |val| = 0;
        (hexString subString: 3 to: hexString size) asCharacters do:
        {|(c)|
            |hexValue| = c hexValue;
            (hexValue < 0 || hexValue > 15) ifTrue: {return val};
            val *= 16;
            val += c hexValue;
        };
        val;
    }
}
