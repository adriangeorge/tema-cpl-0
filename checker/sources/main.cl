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
            -- First entry is always of type "load"
            tokens <- (new Tokenizer).tokenize("load");
            
            while
                looping
            loop
                {
                    -- Check what command has been entered
                    if(tokens.getStr(0) = "help") then
                    {
                        out_string("Help:\n");
                    }
                    else if(tokens.getStr(0) = "load") then
                    {
                        -- out_string("Load: ");
                        -- out_string("Loading new object\n");
                        lists.add((new List).init());
                        cursor <- lists.getList(cursor_idx);
                        cursor_idx <- cursor_idx + 1;
                        looping <- true;

                        -- Read first object from keyboard
                        kboard_input <- in_string();
                        -- Tokenize input and analyze
                        tokens <- (new Tokenizer).tokenize(kboard_input);
                        -- out_string(tokens.toString().concat("\n"));

                        while not (tokens.getStr(0) = "END") loop
                        {
                            -- out_string("Load:\n");
                            -- Map string from array of strings to object and add to list
                            cursor.add((new Mapper).map_type(tokens));
                            -- out_string(cursor.toString());
                            -- Read new input from keyboard
                            kboard_input <- in_string();
                            -- Tokenize input and analyze on next loop
                            tokens <- (new Tokenizer).tokenize(kboard_input);
                        }
                        pool;
                    }
                    else if(tokens.getStr(0) = "print") then
                    {

                        if (tokens.getLen() <= 1) then 
                        {
                            out_string(lists.toString());
                            out_string("\n");
                        } 
                        else
                        {
                            out_string(lists.getList(tokens.getInt(1) - 1).toString());
                            out_string("\n");
                        }
                        fi;
                    }
                    else if(tokens.getStr(0) = "merge") then
                    {
                        let
                            idx1: Int <- (new A2I).a2i(tokens.getStr(1)) - 1,
                            idx2: Int <- (new A2I).a2i(tokens.getStr(2)) - 1,
                            l1: List <- lists.getList(idx1).copy(),
                            l2: List <- lists.getList(idx2).copy(),
                            merged : List
                        in
                            {
                                -- out_string("\nMerge: ".concat(tokens.getStr(1)).concat(" ").concat(tokens.getStr(2)).concat("\n"));
                                -- out_string("LT: ".concat(lists.toString()));
                                -- out_string("\n");
                                -- out_string("L1: ".concat(l1.toString()));
                                -- out_string("\n");
                                -- out_string("L2: ".concat(l2.toString()));
                                -- out_string("\n");
                                lists <- lists.remove(idx1);
                                lists <- lists.remove(idx2 - 1);

                                merged <- l1.merge(l2);
                                lists.add(merged);

                            };
                    }
                    else if(tokens.getStr(0) = "filterBy") then
                    {
                        -- out_string("Filter:\n");
                        let
                            index : Int <- tokens.getInt(1),
                            filter : Filter,
                            filter_list : List
                        in
                            {
                                if tokens.getStr(2) = "ProductFilter" then
                                {
                                    filter <- new ProductFilter;
                                } 
                                else if tokens.getStr(2) = "RankFilter" then
                                {
                                    filter <- new RankFilter;
                                }
                                else
                                {
                                    filter <- new SamePriceFilter;
                                } fi fi;
                            
                                filter_list <- lists.filterBy(filter, index - 1);
                                lists.replace(index-1, filter_list);
                            };
                        
                    }
                    else if(tokens.getStr(0) = "sortBy") then
                    {
                        let
                            index : Int <- tokens.getInt(1),
                            c : Comparator,
                            sorted : List
                        in
                            {
                                if tokens.getStr(2) = "PriceComparator" then
                                {
                                    c <- new PriceComparator;
                                } 
                                else if tokens.getStr(2) = "RankComparator" then
                                {
                                    c <- new RankComparator;
                                }
                                else
                                {
                                    c <- new AlphabeticComparator;
                                } fi fi;
                                
                                if tokens.getStr(3) = "ascendent" then
                                {
                                    sorted <- lists.sortBy(c, index-1,true);
                                }
                                else
                                {
                                    sorted <- lists.sortBy(c, index-1,false);
                                }
                                fi;

                                lists.replace(index-1, sorted);
                            };
                    }
                    else 
                    {
                        abort();
                    }
                    fi fi fi fi fi fi;

                    
                    -- Read new input from keyboard
                    kboard_input <- in_string();
                    -- Tokenize input and analyze user's request
                    tokens <- (new Tokenizer).tokenize(kboard_input);
                    -- out_string("Getting new command\n");
                }
            pool;
        }
    };
};
