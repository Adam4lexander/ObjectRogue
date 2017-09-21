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
    personal protected attribute colourMap;
    protected attribute for write width;
    public attribute for read width;
    protected attribute for write height;
    public attribute for read height;

    personal restricted method Initialise
    {
        charMap = CSV fromFile: "charConversion.csv" splitOn: 0x09;
        colourMap = Dictionary new;
        (CSV fromFile: "colourmap.csv" splitOn: ',') do:
        {|(line)|
            colourMap addKey: line[1] object: line[2] asInteger;
        }
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
        2 to: data size do: 
        {|(i)|
            |line| = data[i];
            |c| = line[3] asInteger;
            (c asInteger == 0) 
                ifTrue: {c = ' ' asInteger}
                ifFalse: {c = receiver parseHex(AnsiMap::charMap[c+1][2])};
            line[3] = c asCharacter;
           
            line[4] = (AnsiMap::colourMap getObjectsForKey: line[4])[1];
            line[5] = (AnsiMap::colourMap getObjectsForKey: line[5])[1];
        };
        receiver::width = data[data size][1] asInteger + 1;
        receiver::height = data[data size][2] asInteger + 1;
    }
    
    public method character
    {|(x, y)|
        |i| = idx(x, y);
        data[i][3];
    }

    public method backgroundColour
    {|(x, y)|
        |i| = idx(x, y);
        data[i][5];
    }

    public method foregroundColour
    {|(x, y)|
        |i| = idx(x, y);
        data[i][4];
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
