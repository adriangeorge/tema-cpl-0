-- This module, given a string will return an object of the type specified
-- in the string. Example: given string "Rank" as args.getStr(0) return will be Rank obj
class Mapper {
    map_type(args: List) : Object {
        -- Default types
        if args.getStr(0) = "Int"        then args.getInt(1)  else
        if args.getStr(0) = "String"     then args.getStr(1)  else
        if args.getStr(0) = "Bool"       then args.getBool(1)  else
        if args.getStr(0) = "IO"         then (new IO)  else
        -- User added types
        if args.getStr(0) = "Product"    then (new Product).init(args.getStr(1),args.getStr(2),args.getInt(3))  else
        if args.getStr(0) = "Edible"     then (new Edible).init(args.getStr(1),args.getStr(2),args.getInt(3))   else
        if args.getStr(0) = "Soda"       then (new Soda).init(args.getStr(1),args.getStr(2),args.getInt(3))     else
        if args.getStr(0) = "Coffee"     then (new Coffee).init(args.getStr(1),args.getStr(2),args.getInt(3))   else
        if args.getStr(0) = "Laptop"     then (new Laptop).init(args.getStr(1),args.getStr(2),args.getInt(3))   else
        if args.getStr(0) = "Router"     then (new Router).init(args.getStr(1),args.getStr(2),args.getInt(3))   else
        if args.getStr(0) = "Rank"       then (new Rank).init(args.getStr(1))                                   else
        if args.getStr(0) = "Private"    then (new Private).init(args.getStr(1))                                else
        if args.getStr(0) = "Corporal"   then (new Corporal).init(args.getStr(1))                               else
        if args.getStr(0) = "Sergent"    then (new Sergent).init(args.getStr(1))                                else
        if args.getStr(0) = "Officer"    then (new Officer).init(args.getStr(1))                                else
        { abort(); ""; } 
        fi fi fi fi fi fi fi fi fi fi fi fi fi fi fi
    };
};
