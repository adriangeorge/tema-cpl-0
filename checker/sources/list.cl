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
        let temp            : List      <- self,
            output          : String    <- "",
            index           : Int       <- 0,
            isListOfLists   : Bool      <- false
        in
            {
                case temp.getHead() of
                    l : List => isListOfLists <- true;
                    o : Object => {isListOfLists <- false; output <- output.concat("[");};
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

                if isListOfLists then output else output<- output.concat("]") fi;
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
                o:Object => 999;
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
    };

    ----------------- END GETTERS FOR VARIOUS TYPES -----------------
    
    remove(index : Int) : List {
        let temp : List     <- self,
            counter : Int   <- 0
        in
        {
            -- Iterate to specified index
            if not (index < 0) then 
            {
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
                (new List).init();
            }
            fi;
            
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

    filterBy(): List {
        let
            newList : List  <- (new List).init(),
            counter : Int   <- 0
        in
            {
                out_string("filter\n");
            }
        
    };

    sortBy(): List {
        self (* TODO *)
    };
};