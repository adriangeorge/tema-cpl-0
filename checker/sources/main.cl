class Main inherits IO{
    lists : List <- new List.init();
    cursor : List;
    cursor_idx : Int <- 0;
    looping : Bool <- true;
    kboard_input : String;
    tokens : List;
    (*
        0 - LOAD mode
        1 - EXPECT COMMAND mode    
    *)
    mode : Int <- 0;
    
    main():Object {
        {
            lists.add(new List.init());
            cursor <- lists.getList(cursor_idx);
            while
                looping
            loop
                {
                    -- Read new input from keyboard
                    kboard_input <- in_string();
                    -- Tokenize input and analyze user's request
                    tokens <- (new Tokenizer).tokenize(kboard_input);
                    -- out_string("input:".concat(tokens.toString()).concat("\n"));
                    
                    -- Check what command has been entered
                    if(tokens.getStr(0) = "help") then
                    {
                        out_string("Help:\n");
                    }
                    else if(tokens.getStr(0) = "load") then
                    {
                        out_string("Load: ");
                        -- out_string("Loading new object\n");
                        cursor_idx <- cursor_idx + 1;
                        lists.add((new List).init());
                        cursor <- lists.getList(cursor_idx);
                        looping <- true;

                        -- Read new input from keyboard
                        kboard_input <- in_string();
                        -- Tokenize input and analyze user's request
                        tokens <- (new Tokenizer).tokenize(kboard_input);
                        out_string(tokens.toString().concat("\n"));
                    }
                    else if(tokens.getStr(0) = "print") then
                    {
                        out_string("Print:\n");
                        out_string(lists.toString());
                        out_string("\n");
                    }
                    else if(tokens.getStr(0) = "merge") then
                    {
                        let
                            idx1: Int <- (new A2I).a2i(tokens.getStr(1)),
                            idx2: Int <- (new A2I).a2i(tokens.getStr(2))
                        in
                            {
                                out_string("Merge:\n");
                                out_string(lists.getList(idx1).merge(lists.getList(idx2)).toString());
                            };
                        
                    }
                    else if(tokens.getStr(0) = "filterBy") then
                    {
                        out_string("Filter:\n");
                    }
                    else if(tokens.getStr(0) = "sortBy") then
                    {
                        out_string("Sort:\n");
                    }
                    else 
                    {
                        out_string("Idk what u want :(\n");
                    }
                    fi fi fi fi fi fi;

                    while not (tokens.getStr(0) = "END") loop
                    {
                        out_string("Load: ");
                        -- Map string from array of strings to object and add to list
                        cursor.add((new Mapper).map_type(tokens));
                        -- Read new input from keyboard
                        kboard_input <- in_string();
                        -- Tokenize input and analyze on next loop
                        tokens <- (new Tokenizer).tokenize(kboard_input);
                        out_string(tokens.toString().concat("\n"));
                    }
                    pool;
                }
            pool;
        }
    };
};
