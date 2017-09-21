directory
{
    local role family ObjectRogue
    {
        CSV method group csv
    }
}

module csv

method group (csv){
    personal public method fromFile:splitOn:
    {|(filename, splitChar) line|
        |data| = Array new;
        |file| = File openAsTextInput: filename;
        { (line = file readLine) isNotNil } whileTrue: {
            (line length > 0) ifTrue: { 
                data = data append(receiver splitProperly(line, splitChar))
            };
        };
        return data;
    }
    
    personal private method splitProperly
    {|(str, splitOn) temp, tempS|
        tempS = str;
        |arr| = Array new;
        {temp = tempS split: splitOn; temp[2] size > 0} whileTrue: {
            arr = arr append: temp[1];
            tempS = temp[2];
        };
        (temp[1] == "") ifTrue: {Host out printLine("Found empty at: " + str)};
        (arr append: temp[1]) asMutableArray;
    }
}
