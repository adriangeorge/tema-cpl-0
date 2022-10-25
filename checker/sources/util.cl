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