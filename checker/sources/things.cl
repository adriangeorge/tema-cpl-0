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
};