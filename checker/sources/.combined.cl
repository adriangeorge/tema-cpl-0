(*
   The class A2I provides integer-to-string and string-to-integer
conversion routines.  To use these routines, either inherit them
in the class where needed, have a dummy variable bound to
something of type A2I, or simpl write (new A2I).method(argument).
*)


(*
   c2i   Converts a 1-character string to an integer.  Aborts
         if the string is not "0" through "9"
*)
class A2I {

    c2i(char : String) : Int {
   if char = "0" then 0 else
   if char = "1" then 1 else
   if char = "2" then 2 else
       if char = "3" then 3 else
       if char = "4" then 4 else
       if char = "5" then 5 else
       if char = "6" then 6 else
       if char = "7" then 7 else
       if char = "8" then 8 else
       if char = "9" then 9 else
       { abort(); 0; }  -- the 0 is needed to satisfy the typchecker
       fi fi fi fi fi fi fi fi fi fi
    };

(*
  i2c is the inverse of c2i.
*)
    i2c(i : Int) : String {
   if i = 0 then "0" else
   if i = 1 then "1" else
   if i = 2 then "2" else
   if i = 3 then "3" else
   if i = 4 then "4" else
   if i = 5 then "5" else
   if i = 6 then "6" else
   if i = 7 then "7" else
   if i = 8 then "8" else
   if i = 9 then "9" else
   { abort(); ""; }  -- the "" is needed to satisfy the typchecker
       fi fi fi fi fi fi fi fi fi fi
    };

(*
  a2i converts an ASCII string into an integer.  The empty string
is converted to 0.  Signed and unsigned strings are handled.  The
method aborts if the string does not represent an integer.  Very
long strings of digits produce strange answers because of arithmetic 
overflow.

*)
    a2i(s : String) : Int {
       if s.length() = 0 then 0 else
   if s.substr(0,1) = "-" then ~a2i_aux(s.substr(1,s.length()-1)) else
       if s.substr(0,1) = "+" then a2i_aux(s.substr(1,s.length()-1)) else
          a2i_aux(s)
       fi fi fi
    };

(*
 a2i_aux converts the usigned portion of the string.  As a programming
example, this method is written iteratively.
*)
    a2i_aux(s : String) : Int {
   (let int : Int <- 0 in	
          {	
              (let j : Int <- s.length() in
             (let i : Int <- 0 in
           while i < j loop
           {
               int <- int * 10 + c2i(s.substr(i,1));
               i <- i + 1;
           }
           pool
         )
          );
             int;
       }
       )
    };

(*
   i2a converts an integer to a string.  Positive and negative 
numbers are handled correctly.  
*)
   i2a(i : Int) : String {
   if i = 0 then "0" else 
       if 0 < i then i2a_aux(i) else
         "-".concat(i2a_aux(i * ~1)) 
       fi fi
   };
   
(*
   i2a_aux is an example using recursion.
*)		
   i2a_aux(i : Int) : String {
       if i = 0 then "" else 
       (let next : Int <- i / 10 in
       i2a_aux(next).concat(i2c(i - next * 10))
       )
       fi
   };

};
class END_LIST {};

class List inherits IO {

    head : Object;
    tail : List;

    getTail() : List {tail};
    getHead() : Object {head};

    setHead(h : Object) : Object {head <- h};
    setTail(t : List) : List {tail <- t};

    init() : List {
        {
            head <- new END_LIST;
            tail <- new List;
            tail.setHead(new END_LIST);
            self;
        }
    };

    -- Tells if current list node is the last 
    isEndList() : Int {
        case head of
            empty_list : END_LIST => 1;
            default : Object => 0;
        esac
    };
    
    -- Append a single element to end of list
    add(o : Object):SELF_TYPE {
        let temp : List <- tail,
            curr_head : Object <- head,
            loop_flag : Bool <- true
        in
            {
                case head of 
                -- Particular case where list is empty
                case_empty_list : END_LIST => {
                    head <- o;
                    tail <- new List.init();
                };
                -- Navigate to end of list
                default : Object => {
                    while (loop_flag) loop
                    {
                        case temp.getHead() of 
                        i : Object => temp <- temp.getTail();
                        o : END_LIST => loop_flag <- false;
                        esac;
                    }
                    pool;
                    
                    -- Replace END_LIST last element with actual element
                    temp.setHead(o);
                    temp.setTail(new List.init()); 
                };
                esac;
                
                self;
            }
    };

    -- Output a string showing the list's contents
    toString():String {
        let temp : List <- self,
            output : String <- ""
        in
            {
                output.concat("[");
                while (temp.isEndList() = 0) loop
                {
                    case temp.getHead() of 
                    i : Int => out_int(i);
                    s : String => out_string("'".concat(s).concat("'"));
                    o : Object => out_string("teapa");
                    esac;
                    
                    if(temp.getTail().isEndList() = 1) then 
                        out_string("")
                    else
                        out_string(", ")
                    fi;

                    temp <- temp.getTail();
                }
                pool;
                out_string("]\n");
                output;
            }
    };

    merge(other : List):SELF_TYPE {
        let temp : List <- self
        in
        {
            -- Iterate to last element before end of list
            while (temp.getTail().isEndList() = 0) loop
            {
                temp <- temp.getTail();
            }
            pool;

            temp.setTail(other);
            self;
        }

    };

    filterBy():SELF_TYPE {
        self (* TODO *)
    };

    sortBy():SELF_TYPE {
        self (* TODO *)
    };
};class Main inherits IO{
    lists : List <- new List.init();
    looping : Bool <- true;
    somestr : String;

    main():Object {
        {
            list1.add(1);
            list2.add(3);

            list1.toString();
            list2.toString();
            
            list1.merge(list2);
            list1.toString();
        }
    };
};
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
(*******************************
 *** Classes Product-related ***
 *******************************)
class Product {
    name : String;
    model : String;
    price : Int;

    init(n : String, m: String, p : Int):SELF_TYPE {{
        name <- n;
        model <- m;
        price <- p;
        self;
    }};

    getprice():Int{ price * 119 / 100 };

    toString():String {
        -- Hint: what are the default methods of Object?
        let output: String <- "" in
        {
            output <- output.concat(self.type_name());
            output <- output.concat("(").concat(name).concat(")");
            output;
        }
    };
};

class Edible inherits Product {
    -- VAT tax is lower for foods
    getprice():Int { price * 109 / 100 };
};

class Soda inherits Edible {
    -- sugar tax is 20 bani
    getprice():Int {price * 109 / 100 + 20};
};

class Coffee inherits Edible {
    -- this is technically poison for ants
    getprice():Int {price * 119 / 100};
};

class Laptop inherits Product {
    -- operating system cost included
    getprice():Int {price * 119 / 100 + 499};
};

class Router inherits Product {};

(****************************
 *** Classes Rank-related ***
 ****************************)
class Rank {
    name : String;

    init(n : String):String {
        name <- n
    };

    toString():String {
        -- Hint: what are the default methods of Object?
        let output: String <- "" in
        {
            output <- output.concat(self.type_name());
            output <- output.concat("(").concat(name).concat(")");
            output;
        }
    };
};

class Private inherits Rank {};

class Corporal inherits Private {};

class Sergent inherits Corporal {};

class Officer inherits Sergent {};-- Module that given a string will return a list of words (separated by space)

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
(* Think of these as abstract classes *)
class Comparator {
    compareTo(o1 : Object, o2 : Object):Int {0};
};

class Filter {
    filter(o : Object):Bool {true};
};

(* TODO: implement specified comparators and filters*)