(*
    Laborator COOL.
*)

(*
    Exercițiul 1.

    Implementați funcția fibonacci, utilizând atât varianta recursivă,
    cât și cea iterativă.
*)
class Fibo {
    fibo_rec(n : Int) : Int {
        if n <= 1 then
            n
        else
            fibo_rec(n - 1) + fibo_rec(n-2)
        fi
    };

    total : Int <- 0;
    fibo_iter(n : Int) : Int {
        {
        let first : Int <- 0,
            second : Int <- 1 in
            while (second <= (n - 1)) loop {
                total <- second + first;
                second <- second + 1;
                first <- first + 1;
            }
            pool;
        total;
        }
    };
};
    
(*
    Exercițiul 2.

    Pornind de la ierarhia de clase implementată la curs, aferentă listelor
    (găsiți clasele List și Cons mai jos), implementați următoarele funcții
    și testați-le. Este necesară definirea lor în clasa List și supradefinirea
    în clasa Cons.

    * append: întoarce o nouă listă rezultată prin concatenarea listei curente
        (self) cu lista dată ca parametru;
    * reverse: întoarce o nouă listă cu elementele în ordine inversă.
*)

(*
    Listă omogenă cu elemente de tip Int. Clasa List constituie rădăcina
    ierarhiei de clase reprezentând liste, codificând în același timp
    o listă vidă.

    Adaptare după arhiva oficială de exemple a limbajului COOL.
*)
class List inherits IO {
    isEmpty() : Bool { true };

    -- 0, deși cod mort, este necesar pentru verificarea tipurilor
    hd() : Int { { abort(); 0; } };

    -- Similar pentru self
    tl() : List { { abort(); self; } };

    append() : List {{abort(); self;}};


    cons(h : Int) : Cons {
        new Cons.init(h, self)
    };

    print() : IO { out_string("\n") };
};

(*
    În privința vizibilității, atributele sunt implicit protejate, iar metodele,
    publice.

    Atributele și metodele utilizează spații de nume diferite, motiv pentru care
    hd și tl reprezintă nume atât de atribute, cât și de metode.
*)
class Cons inherits List {
    hd : Int;
    tl : List;

    init(h : Int, t : List) : Cons {
        {
            hd <- h;
            tl <- t;
            self;
        }
    };

    -- Supradefinirea funcțiilor din clasa List
    isEmpty() : Bool { false };
    append(new_list : List) : List {
        while 
    };
    -- Getters
    hd() : Int { hd };

    tl() : List { tl };

    print() : IO {
        {
            out_int(hd);
            out_string(" ");
            -- Mecanismul de dynamic dispatch asigură alegerea implementării
            -- corecte a metodei print.
            tl.print();
        }
    };
};

(*
    Exercițiul 3.

    Scopul este implementarea unor mecanisme similare funcționalelor
    map și filter din limbajele funcționale. map aplică o funcție pe fiecare
    element, iar filter reține doar elementele care satisfac o anumită condiție.
    Ambele întorc o nouă listă.

    Definiți clasele schelet Map, respectiv Filter, care vor include unica
    metodă apply, având tipul potrivit în fiecare clasă, și implementare
    de formă.

    Pentru a defini o funcție utilă, care adună 1 la fiecare element al listei,
    definiți o subclasă a lui Map, cu implementarea corectă a metodei apply.

    În final, definiți în cadrul ierarhiei List-Cons o metodă map, care primește
    un parametru de tipul Map.

    Definiți o subclasă a subclasei de mai sus, care, pe lângă funcționalitatea
    existentă, de incrementare cu 1 a fiecărui element, contorizează intern
    și numărul de elemente prelucrate. Utilizați static dispatch pentru apelarea
    metodei de incrementare, deja definită.

    Repetați pentru clasa Filter, cu o implementare la alegere a metodei apply.
*)

-- Testați în main.
class Main inherits IO {
    main() : Object {
        let list : List <- new List.cons(1).cons(2).cons(3),
            temp : List <- list
        in
            {
                -- Afișare utilizând o buclă while. Mecanismul de dynamic
                -- dispatch asigură alegerea implementării corecte a metodei
                -- isEmpty, din clasele List, respectiv Cons.
                while (not temp.isEmpty()) loop
                    {
                        out_int(temp.hd());
                        out_string(" ");
                        temp <- temp.tl()
                    }
                pool;

                out_string("\n");

                -- Afișare utilizând metoda din clasele pe liste.
                list.print();
            }
    };
};
