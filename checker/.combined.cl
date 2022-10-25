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
    length : Int <- 0;

    getTail() : List {tail};
    getHead() : Object {head};
    getLen() : Int {length};

    setHead(h : Object) : Object {head <- h};
    setTail(t : List) : List {tail <- t};
    setLen(l : Int) : Int {length <- l};

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
                    length <- 1;
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
                    length <- length + 1;
                };
                esac;
                self;
            }
    };

    -- Output a string showing the list's contents
    toString():String {
        let temp            : List      <- self,
            output          : String    <- "",
            index           : Int       <- 0,
            isListOfLists   : Bool      <- false
        in
            {
                case temp.getHead() of
                    l : List => isListOfLists <- true;
                    o : Object => {isListOfLists <- false; output <- output.concat("[ ");};
                esac;

                while (temp.isEndList() = 0) loop
                {
                    case temp.getHead() of 
                        -- Custom datatypes use their toString() method
                        p:Product => output <- output.concat(p.toString());
                        r:Rank => output <- output.concat(r.toString());

                        -- Manually define outputs for basic data types
                        s:String    => output <- output.concat("String(".concat(s).concat(")"));
                        i:Int       => output <- output.concat("Int(".concat((new A2I).i2a(i)).concat(")"));
                        io:IO       => output <- output.concat("IO()");
                        l : List    => output <- output.concat((new A2I).i2a(index <- index + 1).concat(": ").concat(l.toString()));
                        b:Bool      => if b then output <- output.concat("Bool(true)") else output<- output.concat("Bool(false)") fi;
                        o:Object    => output<- output.concat("Error:No Type Match");
                    esac;
                    
                    if (temp.getTail().isEndList() = 1) then 
                        output <- output.concat("")
                    else
                        {
                            case temp.getHead() of
                                l : List => output <- output.concat("\n");
                                o : Object => output <- output.concat(", ");
                            esac;
                        }
                    fi;

                    temp <- temp.getTail();
                }
                pool;

                if isListOfLists then output else output<- output.concat(" ]") fi;
                output;
            }
    };

    ------------------- GETTERS FOR VARIOUS TYPES ------------------
    getStr(index : Int) : String {
        let temp    : List  <- self,
            counter : Int   <- 0
        in
        {
            -- Iterate to specified index
            while not (counter = index) loop
            {
                counter <- counter + 1;
                temp <- temp.getTail();
            }
            pool;
            
            case temp.getHead() of
                i:Int => (new A2I).i2a(i);
                s:String => s;
                o:Object => "ERR";
            esac;
        }
    };

    getBool(index : Int) : Bool {
        let temp    : List  <- self,
            counter : Int   <- 0
        in
        {
            -- Iterate to specified index
            while not (counter = index) loop
            {
                counter <- counter + 1;
                temp <- temp.getTail();
            }
            pool;   

            case temp.getHead() of
                b:String => if b = "true" then true else false fi;
                o:Object => {out_string("obj"); false;};
            esac;
        }
    };

    getInt(index : Int) : Int {
        let temp    : List  <- self,
            counter : Int   <- 0
        in
        {
            -- Iterate to specified index
            while not (counter = index) loop
            {
                counter <- counter + 1;
                temp <- temp.getTail();
            }
            pool;
            
            case temp.getHead() of
                i:Int => i;
                s:String => (new A2I).a2i(s);
                o:Object => (0 - 99999);
            esac;
        }
    };

    getObj(index : Int) : Object {
        let temp    : List  <- self,
            counter : Int   <- 0
        in
        {
            -- Iterate to specified index
            while not (counter = index) loop
            {
                counter <- counter + 1;
                temp <- temp.getTail();
            }
            pool;
            
            temp.getHead();
        }
    };

    getList(index : Int) : List {
        let temp : List     <- self,
            counter : Int   <- 0
        in
        {
            if index < length then
            {
                -- Iterate to specified index
                while not (counter = index) loop
                {
                    counter <- counter + 1;
                    temp <- temp.getTail();
                }
                pool;
                
                case temp.getHead() of
                    l:List => l;
                    o:Object => new List;
                esac;
            }
            else
            {
                out_string("ERR: Index out of bounds ");
                out_int(index);
                out_string(" vs ");
                out_int(length);
                out_string("\n");
            }
            fi;
        }
    };

    ----------------- END GETTERS FOR VARIOUS TYPES -----------------
    
    remove(index : Int) : List {
        let temp : List <- self,
            aux : List <- (new List).init(),
            ret_head : List <- temp,
            counter : Int <- 0
        in
        {
            if index = 0 then 
            {
                temp <- temp.getTail();
            }
            else 
            {
                while temp.isEndList() = 0 loop
                {
                    if counter = index then
                        out_string("")
                    else 
                    {
                        aux.add(temp.getHead());
                    } fi;

                    counter <- counter + 1;
                    temp <- temp.getTail();
                }
                pool;

                -- out_string("\nRESULT: ".concat(aux.toString().concat("\n")));
                aux;
            }
            fi;
            
        }
    };

    -- Replace element at "index" with "elem" in list
    replace (index : Int, elem : Object) : List {
        let temp : List <- self,
            counter : Int   <- 0
        in
        {
            -- Iterate to last element before end of list
            while (temp.isEndList() = 0) loop
            {
                if(counter = index) then
                temp.setHead(elem)
                else
                out_string("")
                fi;
                temp <- temp.getTail();
                counter <- counter + 1;
            }
            pool;
            self;
        }
    };

    merge(other : List):SELF_TYPE {
        let temp : List     <- self
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

    filterBy(f : Filter, idx : Int): List {
        let
            temp : List  <- getList(idx),
            aux : List <- (new List).init(),
            counter : Int   <- 0
        in
            {
                while temp.isEndList() = 0 loop
                {
                    if f.filter(temp.getHead()) then
                        aux.add(temp.getHead())
                    else 
                        out_string("")
                    fi;

                    counter <- counter + 1;
                    temp <- temp.getTail();
                }
                pool;
                aux;
            }
        
    };

    -- I am aware that Bubble Sort is not very efficient but
    -- I will assume it is sufficiently efficient for this homework 
    -- since this is not an algorithms class
    sortBy(c : Comparator, idx : Int, ascending : Bool ): List {
        let
            temp : List  <- getList(idx),
            aux : List <- temp,
            sorted : Bool <- false,
            elem1 : Object,
            idx1 : Int   <- 0,
            elem2 : Object,
            idx2 : Int   <- 0
        in
            {
                while
                    not sorted
                loop
                {
                    -- out_string(aux.toString().concat("\n"));
                    idx1 <- 0;
                    idx2 <- 1;
                    sorted <- true;
                    while temp.getTail().isEndList() = 0 loop
                    {
                        elem1 <- temp.getHead();
                        elem2 <- temp.getTail().getHead();
                        -- out_string("\n");

                        if ascending then
                        {
                            if c.compareTo(elem1,elem2) <= 0 then
                                out_string("")
                            else 
                            {
                                aux <- aux.replace(idx1, elem2);
                                aux <- aux.replace(idx2, elem1);
                                sorted <- false;
                            }
                            fi;
                        }
                        else
                        {
                            if not c.compareTo(elem1,elem2) < 0 then
                                out_string("")
                            else 
                            {
                                aux <- aux.replace(idx1, elem2);
                                aux <- aux.replace(idx2, elem1);
                                sorted <- false;
                                -- out_int(c.compareTo(elem1,elem2));
                                -- out_string(aux.toString().concat("\n"));
                            }
                            fi;
                        }
                        fi;
                        temp <- temp.getTail();
                        idx1 <- idx1 + 1;
                        idx2 <- idx2 + 1;
                    }
                    pool;
                    temp <- aux;
                    -- out_string(aux.toString().concat("\n"));
                }
                pool;
                
                aux;
            }
    };
};class Main inherits IO{
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
            output <- output.concat("(").concat(name).concat(";").concat(model).concat(")");
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
    priority() : Int {0};
    init(n : String): SELF_TYPE {
        {
            name <- n;
            self;
        }
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

class Private inherits Rank {
    priority() : Int {0};
};

class Corporal inherits Private {
    priority() : Int {1};
};

class Sergent inherits Corporal {
    priority() : Int {2};
};

class Officer inherits Sergent {
    priority() : Int {3};
};-- Module that given a string will return a list of words (separated by space)

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
class Comparator inherits IO {
    compareTo(o1 : Object, o2 : Object):Int {0};
};

class Filter {
    filter(o : Object):Bool {true};
};

(* TODO: implement specified comparators and filters*)

class ProductFilter inherits Filter{
    filter(o : Object) : Bool {
        case o of
            p: Product => true;
            o: Object => false;
        esac
    };
};

class RankFilter inherits Filter{
    filter(o : Object) : Bool {
        case o of
            r: Rank => true;
            o: Object => false;
        esac
    };
};

class SamePriceFilter inherits Filter{

    filter(o : Object) : Bool {
        case o of
            p: Product => {
                if p.getprice() = p@Product.getprice() then
                    true
                else
                    false
                fi;
            };
            o: Object => false;
        esac
    };
};

class PriceComparator inherits Comparator {
    compareTo(o1 : Object, o2 : Object):Int {
        case o1 of
            p1 :Product => {
                case o2 of
                p2 : Product => {
                    -- out_string(p1.toString().concat(" vs ").concat(p2.toString()).concat("\n"));
                    p1.getprice() - p2.getprice();
                };
                esac;
            };
        esac
    };
};

class RankComparator inherits Comparator {
    compareTo(o1 : Object, o2 : Object):Int {
        case o1 of
            p1 : Rank => {
                case o2 of
                p2 : Rank => {
                    -- out_string(p1.toString().concat(" vs ").concat(p2.toString()).concat("\n"));
                    p1.priority() - p2.priority();
                };
                esac;
            };
        esac
    };
};

class AlphabeticComparator inherits Comparator {
    compareTo(o1 : Object, o2 : Object):Int {
        case o1 of
            p1 : String => {
                case o2 of
                p2 : String => {
                    -- out_string(p1.toString().concat(" vs ").concat(p2.toString()).concat("\n"));
                    if(p1 < p2) then
                        0 - 1
                    else if (p1 = p2) then
                        0
                    else
                        1
                    fi fi;
                };
                esac;
            };
        esac
    };
};