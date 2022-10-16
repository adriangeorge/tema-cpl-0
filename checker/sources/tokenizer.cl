-- Module that given a string will return a list of words (separated by space)

class Tokenizer inherits IO {
    tokenize(input : String) : List {
        let output_list : List <- new List.init(),
            start : Int <- 0,
            end : Int <- 0 in
        {
            -- DEBUG CODE TO BE DELETED
            -- out_string("Tokenizing [");
            -- out_string(input);
            -- out_string("]\n");

            -- iterate through string incrementing end
            while (end < input.length()) loop {
                
                end <- end + 1;
                if (input.substr(end - 1, 1) = " ") then
                    -- found space, insert substr in list
                    {
                        output_list.add(input.substr(start, end - start - 1));
                        start <- end;
                    }
                else 
                    out_string("")
                fi;
            } pool;
            -- add last element to list
            if (not (end - start - 1 < 0)) then 
                output_list.add(input.substr(start, end - start))
            else 
                out_string("")
            fi;
            output_list;
        }
    };
};
