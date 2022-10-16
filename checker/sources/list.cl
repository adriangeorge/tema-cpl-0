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
};