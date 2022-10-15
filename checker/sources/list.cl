class END_LIST {};

class List inherits IO {

    (* TODO: store data *)
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

    -- Tell if this list is empty or not
    isEndList() : Int {
        case head of
            empty_list : END_LIST => 1;
            default : Object => 0;
        esac
    };

    add(o : Object):SELF_TYPE {
        let temp : List <- self,
            loop_flag : Bool <- true
        in
            {
                if (temp.isEndList() = 1) then
                    out_string("reached end of list\n")
                else
                    out_string("still more of this list\n")
                fi;

                -- Navigate to end of list
                while (loop_flag) loop
                {
                    case temp.getHead() of 
                    i : Int => {tail <- tail.getTail();};
                    o : Object => {loop_flag <- false;};
                    esac;
                }
                pool;
                

                -- Replace END_LIST last element with actual element
                temp.setHead(o);
                temp.setTail(new List.init()); 
                out_string("ADDED ");
                case temp.getHead() of 
                i : Int => out_int(i);
                o : Object => out_string("teapa");
                esac;
                out_string("\n");
                self;
            }
    };

    toString():String {
        let temp : List <- self,
            output : String <- ""
        in
            {
                -- if (temp.isEndList() = 1) then
                -- out_string("reached end of list\n")
                -- else
                -- out_string("still more of this list\n")
                -- fi;

                out_string("[");

                while (temp.isEndList() = 0) loop
                {
                    case temp.getHead() of 
                    i : Int => out_int(i);
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
        self (* TODO *)
    };

    filterBy():SELF_TYPE {
        self (* TODO *)
    };

    sortBy():SELF_TYPE {
        self (* TODO *)
    };
};

class Main inherits IO{
    lists : List <- new List.init();
    looping : Bool <- true;
    somestr : String;

    main():Object {
        {
            out_string("add 1\n");
            lists.add(1);
            out_string("add 2\n");
            lists.add(2);
            out_string("add 3\n");
            lists.add(3);
            out_string(lists.toString());
            out_string("add 4\n");
            lists.add(4);
            out_string(lists.toString());
            out_string("added all");
            -- lists.add(5);
            while looping loop {
                out_string(lists.toString());
                -- input 
                somestr <- in_string();
                -- out_string("Hi ".concat(somestr).concat("\n"));
            } pool;
        }
    };
};