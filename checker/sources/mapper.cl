-- This module, given a string will return an object of the type specified
-- in the string. Example: given string "Rank" as input return will be Rank obj
class Mapper {
    map_type(input : String) : Object {
        -- Default types
        if input = "Int"        then (new Int)  else
        if input = "String"     then (new String)  else
        if input = "Bool"       then (new Bool)  else
        if input = "IO"         then (new IO)  else
        -- User added types
        if input = "Product"    then (new Product)  else
        if input = "Edible"     then (new Edible)   else
        if input = "Soda"       then (new Soda)     else
        if input = "Coffee"     then (new Coffee)   else
        if input = "Laptop"     then (new Laptop)   else
        if input = "Router"     then (new Router)   else
        if input = "Rank"       then (new Rank)     else
        if input = "Private"    then (new Private)  else
        if input = "Corporal"   then (new Corporal) else
        if input = "Sergent"    then (new Sergent)  else
        if input = "Officer"    then (new Officer)  else
        { abort(); ""; } 
        fi fi fi fi fi fi fi fi fi fi fi fi fi fi fi
    };
};
