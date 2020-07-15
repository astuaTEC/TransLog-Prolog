

/*
Pruebas para ir viendo el comportamiento de
algunas funciones de Prolog y de  las
grmáticas libres de contexto
*/


%:- include(sustantivosSingulares).
%:- include(adjetivos).

texto :-
  write('Ingrese el idioma a traducir '),
  nl,
  read(X), translate(X), !.


%modulo de seleccion del idioma Ingles: traduce a español
translate(Y) :- Y = "In", 
  write('Please type your text: '),
  nl,
  read(X),
  split_string(X, " ", "¿?¡!,", L),
  display(L), nl,
  oracion(K, L),
  atomic_list_concat(K, ' ', A),
  display(A).

translate(Y) :- Y = "Es",
  write('Ingresa el texto: '),
  nl,
  read(X),
  split_string(X, " ", "¿?¡!,", L),
  %display(L), nl,
  oracion(L, K),
  %display(K), nl,
  atomic_list_concat(K, ' ', A),
  display(A).


%Funcion que concatena las distintas partes de la oración que se encontraron 

concatenar([],X,X) :- !.
concatenar([A|B],C,[A|D]) :- concatenar(B,C,D).
concatenar(A,B,C,Z)       :- concatenar(A,B,X), concatenar(X,C,Z).
concatenar(A,B,C,D,Z)     :- concatenar(A,B,X), concatenar(X,C,Y), concatenar(Y,D,Z).


oracion(A, B) :- oracion_simple(A, B).
oracion(A, B) :- oracion_simple(X, XX), conjuncion(Y, YY), concatenar(X,Y, Z), concatenar(XX,YY, ZZ), 
                 concatenar(Z, V, A), concatenar(ZZ, VV, B), oracion(V,VV),
                 concatenar(Z, V, A), concatenar(ZZ, VV, B).   

oracion(A, B) :- oracion_simple(X, XX), preposicion(Y, YY), concatenar(X,Y, Z), concatenar(XX,YY, ZZ), 
                 concatenar(Z, V, A), concatenar(ZZ, VV, B), oracion(V,VV),
                 concatenar(Z, V, A), concatenar(ZZ, VV, B).                

oracion_simple(A, B) :- palabra(A, B).
oracion_simple(A, B) :- sintagma_nominal(A, B, Persona).
oracion_simple(A, B) :- sintagma_nominal(X, XX, Persona), sintagma_verbal(Y, YY, Persona), concatenar(X, Y, A), 
                        concatenar(XX, YY, B).
oracion_simple(A, B) :- interrogativo(X, XX), sintagma_verbal(Y, YY, Persona), concatenar(X, Y, A), 
                        concatenar(XX, YY, B).



sintagma_verbal(L1, L2, Persona) :- verbo(Numero, Tiempo, Persona, L1, L2).
sintagma_verbal(L1, L2, Persona) :- verbo(Numero, Tiempo, Persona, X, XX), sintagma_nominal(Y, YY, Persona), 
                                    concatenar(X, Y, L1), concatenar(XX, YY, L2).


sintagma_nominal(L1, L2, Persona) :- sustantivo(Numero, Genero, L1, L2).
sintagma_nominal(L1, L2, Persona) :- pronombre(Numero, Persona, L1, L2).
sintagma_nominal(L1, L2, Persona) :- adjetivo(Numero, Genero, L1, L2).

/*sintagma_nominal(L1, L2, Persona) :- determinante(Numero, Genero, Persona, X, XX), 
                                       adjetivo(Numero, Genero, Y, YY), sintagma_nominal(Z, ZZ, Persona),
                                       concatenar(X,Y,Z, L1), concatenar(XX,YY,ZZ,L2).

sintagma_nominal(L1, L2, Persona) :- sustantivo(Numero,Genero,X,XX), adjetivo(Numero, Genero, Y, YY), 
                                     sintagma_nominal(Z, ZZ, Persona), concatenar(X,Y,Z, L1), concatenar(XX,YY,ZZ,L2).

sintagma_nominal(L1, L2, Persona) :- sintagma_nominal(X, XX, Persona), preposicion(Y, YY), 
                                     sintagma_nominal(Z, ZZ, Persona), concatenar(X,Y,Z, L1), concatenar(XX,YY,ZZ,L2).
sustantivo(Numero, Genero, Y, YY)
*/

sintagma_nominal(L1, L2, Persona) :- determinante(Numero, Genero, Persona, X, XX),
                                     sustantivo(Numero, Genero, Y, YY),
                                     concatenar(X, Y, L1), concatenar(XX, YY, L2).

sintagma_nominal(L1, L2, Persona) :- sustantivo(Numero, Genero, X, XX), adjetivo(Numero, Genero, Y, YY),
                                     concatenar(X, Y, L1), concatenar(XX, YY, L2).

sintagma_nominal(L1, L2, Persona) :- determinante(Numero, Genero, Persona, X, XX),
                                     adjetivo(Numero, Genero, Y, YY), sustantivo(Numero, Genero, Z, ZZ), 
                                     concatenar(X, Y, Z, L1), concatenar(XX, YY, ZZ, L2).

sintagma_nominal(L1, L2, Persona) :- adjetivo(Numero, Genero, X, XX), adverbio(Y, YY), 
                                     concatenar(X, Y, L1), concatenar(XX, YY, L2).

/*sintagma_nominal() :- adjetivo(), adverbio().
sintagma_nominal(L1, L2) :- adverbio(), adjetivo().*/


sustantivo(plural, masculino, ["lenguajes"], ["lenguages"]).
sustantivo(singular, _, ["programacion"], ["programming"]).
sustantivo(singular, masculino, ["Prolog"], ["Prolog"]).
sustantivo(singular, masculino, ["uno"], ["one"]).
sustantivo(singular, _, ["eso"], ["It"]).

palabra(["Hola"], ["Hello"]).

verbo(singular, presente, tercera, ["es"],["is"]).
verbo(singular, presente, segunda, ["esta"], ["are"]).
verbo(singular, presente, segunda, ["es"], ["are"]).
verbo(singular, presente, segunda, ["estas"], ["are"]).
verbo(plural, presente, tercera, ["son"],["are"]).
verbo(plural, presente, primera, ["somos"],["are"]).

verbo(singular, presente, tercera, ["come"], ["eats"]).
verbo(singular, presente, primera, ["como"], ["eat"]).
verbo(_, presente, _, ["siguesiendo"], ["remains"]).



adverbio(["comunmente"], ["commonly"]).
adverbio(["hoy"], ["today"]).



preposicion(["de"], ["of"]).
preposicion(["con"], ["with"]).
preposicion(["del"], ["of the"]).

interrogativo(["Quienes"], ["Who"]).
interrogativo(["Quien"], ["Who"]).
interrogativo(["Que"], ["What"]).
interrogativo(["Cual"], ["What"]).
interrogativo(["Which"], ["Cual"]).
interrogativo(["Cuando"], ["When"]).
interrogativo(["Por que"], ["Why"]).
interrogativo(["Donde"], ["Where"]).
interrogativo(["Como"], ["How"]).
interrogativo(["Cuantos"], ["How much"]).
interrogativo(["Cuantos"], ["How many"]).
interrogativo(["Con qué frecuencia"], ["How often"]).
interrogativo(["De quién"], ["Whose"]).

pronombre(singular,primera,["me"], ["I"]).
pronombre(singular,primera,["yo"], ["I"]).
pronombre(singular,segunda,["usted"], ["you"]).
pronombre(singular,segunda,["tu"], ["you"]).
pronombre(singular,tercera,["el"], ["he"]).
pronombre(singular,tercera,["ella"], ["she"]).
pronombre(singular,tercera,["ello"], ["it"]).
pronombre(plural,primera,["nosotros"], ["we"]).
pronombre(plural,segunda,["vosotros"], ["you"]).
pronombre(plural,tercera,["ellos"], ["they"]).
pronombre(plural,tercera,["ellas"], ["they"]).

determinante(singular, masculino, tercera, ["el"], ["the"]).
determinante(singular, femenino, tercera, ["la"], ["the"]).
determinante(plural, masculino, tercera, ["los"], ["the"]).


conjuncion(["y"], ["and"]).
conjuncion(["o"], ["or"]).

adjetivo(singular,masculino,["rojo"],["red"]).
adjetivo(singular,femenino,["roja"],["red"]).
adjetivo(singular,_,["grande"],["big"]).
adjetivo(plural, masculino, ["primeros"], ["first"]).
adjetivo(singular, femenino, ["logica"], ["logic"]).
adjetivo(singular, _, ["popular"], ["popular"]).

