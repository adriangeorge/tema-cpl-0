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
};