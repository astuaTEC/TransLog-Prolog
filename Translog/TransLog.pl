
/*
Código Fuente: TransLog.pl
Desarrolado por: Saymon Astúa, Oscar Araya
Tarea 2 - Lenguajes
IS 2020 - Grupo 01

Descripción: Programa para la traducción de algunos tipos de oraciones
             de español a inglés y viceversa. Se utilizan gramáticas libres de contexto

Instituto Tecnológico de Costa Rica | CE3104 - Lenguajes, Compiladores e Interpretes
*/


% regla que se tiene que llamar desde la consola para 
% realizar la traducción. Es lo que inicia el traductor

texto :-
  write('Ingrese el idioma a traducir '),
  nl,
  read(X), traductor(X), !.


% Seleccion del idioma Ingles: traduce al idioma Español
traductor(E) :- E = "In", 
  write('Please type your text: '),
  nl,
  read(X),
  split_string(X, " ", "¿¡,", L),
  oracion(K, L),
  atomic_list_concat(K, ' ', A),
  write(A).

% Seleccion del idioma Español: traduce al idioma Inglés
traductor(E) :- E = "Es",
  write('Ingresa el texto: '),
  nl,
  read(X),
  split_string(X, " ", "¿¡,", L),
  oracion(L, K),
  atomic_list_concat(K, ' ', A),
  write(A).

% En caso de que la frase u oración no se reconozca
no_reconocido :- write('Disculpa, no te he entendido'), nl,
                 write('Intentalo de nuevo'), nl, 
                 texto.

%Funcion que concatena las distintas partes de la oración que se encontraron
% C: Cabeza
% R: Resto
% L: lista
% A, B, C, X, Z: son listas cualesquiera 
concatenar([], L, L). % caso base
concatenar([C|R1], L1, [C|R2]) :- concatenar(R1, L1, R2).
concatenar(A, B, C, Z)         :- concatenar(A,B,X), concatenar(X,C,Z).


% ------------------------------------GRAMÁTICA LIBRE DE CONTEXTO-----------------------------------------

% Esta regla lo que hace es delimitar la estructura que puede tener una oración
% A: Es una lista con la oración en Español. Ej: ["el", "hombre", "come", "la", "manzana"]
% B: Es una lista con la oración en Inglés. Ej: ["the", "man", "eats", "the", "apple"]
% X, Y, Z, V: Todas estas variables que son una sola letra, significan una lista cualquiera de algún
%             elemento de la oración en el idioma Español.
% XX, YY, ZZ, VV: Todas estas variables que son dos letras, significan una lista cualquiera de algún
%                 elemento de la oración en el idioma Inglés.

oracion(A, B) :- oracion_simple(A, B).
oracion(A, B) :- oracion_simple(X, XX), conjuncion(Y, YY), concatenar(X, Y, Z), concatenar(XX,YY, ZZ), 
                 concatenar(Z, V, A), concatenar(ZZ, VV, B), oracion(V,VV).  

oracion(A, B) :- oracion_simple(X, XX), preposicion(Y, YY), concatenar(X,Y, Z), concatenar(XX,YY, ZZ), 
                 concatenar(Z, V, A), concatenar(ZZ, VV, B), oracion(V,VV).
                

oracion(A, B) :- no_reconocido, !.

% Es una subdivisión de una oración más compleja en una oración más simple. En este caso para
% facilidad a la hora de formar oraciones con más elementos en la gramática
% Persona: significa la persona en la cual está conjugado algún elemento de la oración (primera, segunda, tercera) 

oracion_simple(A, B) :- saludo(X, XX), concatenar(X, ["!"], A), concatenar(XX, ["!"], B).

% Esto es una excepción a la gramática, solo para temas de la especificación de la tarea
oracion_simple(A, B) :- sintagma_nominal(A, B, Persona).

oracion_simple(A, B) :- sintagma_nominal(X, XX, Persona), sintagma_verbal(Y, YY, Persona), concatenar(X, Y, A), 
                        concatenar(XX, YY, B).

% Esto es una excepción a la gramática, solo para temas de la especificación de la tarea. Se utiliza para
% preguntas sencillas
oracion_simple(A, B) :- interrogativo(X, XX), sintagma_verbal(Y, YY, Persona), concatenar(X, Y, C), 
                        concatenar(C, ["?"], A), concatenar(XX, YY, CC), concatenar(CC, ["?"], B).


%-----------------------------------------SINTAGMA VERBAL------------------------------------------

% Se define la estructura para un sintagma verbal
% L1: Es una lista con la oración en Español.
% L2: Es una lista con la oración en Inglés.
% X, Y: Todas estas variables que son una sola letra, significan una lista cualquiera de algún
%       elemento de la oración en el idioma Español.
% XX, YY: Todas estas variables que son dos letras, significan una lista cualquiera de algún
%         elemento de la oración en el idioma Inglés.
% Persona: significa la persona en la cual está conjugado algún elemento de la oración
%          (primera, segunda, tercera) 
% Numero: corresponte a plural o singular
% Tiempo: corresponde a pasado, presente o futuro
sintagma_verbal(L1, L2, Persona) :- verbo(Numero, Tiempo, Persona, L1, L2).
sintagma_verbal(L1, L2, Persona) :- verbo(Numero, Tiempo, Persona, X, XX), sintagma_nominal(Y, YY, Persona), 
                                    concatenar(X, Y, L1), concatenar(XX, YY, L2).


%-------------------------------------------------SINTAGMA NOMINAL-----------------------------------

% Se define la estructura para un sintagma verbal
% L1: Es una lista con la oración en Español.
% L2: Es una lista con la oración en Inglés.
% X, Y, Z: Todas estas variables que son una sola letra, significan una lista cualquiera de algún
%          elemento de la oración en el idioma Español.
% XX, YY, ZZ: Todas estas variables que son dos letras, significan una lista cualquiera de algún
%             elemento de la oración en el idioma Inglés.
% Persona: significa la persona en la cual está conjugado algún elemento de la oración
%          (primera, segunda, tercera) 
% Numero: corresponte a plural o singular
% Tiempo: corresponde a pasado, presente o futuro
% Genero: corresponde a masculino o femenino

% Estos son los elementos más atómicos del sintagma nominal
sintagma_nominal(L1, L2, Persona) :- sustantivo(Numero, Genero, L1, L2).
sintagma_nominal(L1, L2, Persona) :- pronombre(Numero, Persona, L1, L2).
sintagma_nominal(L1, L2, Persona) :- adjetivo(Numero, Genero, L1, L2).


% Estos son los elementos complejos del sintagma nominal
sintagma_nominal(L1, L2, Persona) :- determinante(Numero, Genero, Persona, X, XX),
                                     sustantivo(Numero, Genero, Y, YY),
                                     concatenar(X, Y, L1), concatenar(XX, YY, L2).

sintagma_nominal(L1, L2, Persona) :- sustantivo(Numero, Genero, X, XX), adjetivo(Numero, Genero, Y, YY),
                                     concatenar(X, Y, L1), concatenar(YY, XX, L2).

sintagma_nominal(L1, L2, Persona) :- determinante(Numero, Genero, Persona, X, XX),
                                     adjetivo(Numero, Genero, Y, YY), sustantivo(Numero, Genero, Z, ZZ), 
                                     concatenar(X, Y, Z, L1), concatenar(XX, YY, ZZ, L2).

sintagma_nominal(L1, L2, Persona) :- determinante(Numero, Genero, Persona, X, XX),
                                     sustantivo(Numero, Genero, Y, YY), adjetivo(Numero, Genero, Z, ZZ), 
                                     concatenar(X, Y, Z, L1), concatenar(XX, ZZ, YY, L2).

sintagma_nominal(L1, L2, Persona) :- adjetivo(Numero, Genero, X, XX), adverbio(Y, YY), 
                                     concatenar(X, Y, L1), concatenar(XX, YY, L2).



%----------------------------------------------BASE DE DATOS-----------------------------------------------

% sustantivo(Numero, Genero, L1, L2).
sustantivo(plural, masculino, ["lenguajes"], ["lenguages"]).
sustantivo(singular, _, ["programacioon"], ["programming"]).
sustantivo(singular, masculino, ["Prolog"], ["Prolog"]).
sustantivo(singular, masculino, ["uno"], ["one"]).
sustantivo(singular, _, ["eso"], ["It"]).
sustantivo(singular, femenino, ["manzana"], ["apple"]).
sustantivo(singular, femenino, ["naranja"], ["orange"]).
sustantivo(singular, masculino, ["hombre"], ["man"]).
sustantivo(singular, femenino, ["mujer"], ["woman"]).
sustantivo(singular, masculino, ["carro"], ["car"]).
sustantivo(singular, masculino, ["automoovil"], ["car"]).


saludo(["Hola"], ["Hello"]).


% verbo(Numero, Tiempo, Persona, L1, L2).
verbo(singular, presente, tercera, ["es"],["is"]).
verbo(singular, presente, segunda, ["esta"], ["are"]).
verbo(singular, presente, segunda, ["es"], ["are"]).
verbo(singular, presente, segunda, ["estaas"], ["are"]).
verbo(singular, presente, segunda, ["tiene"], ["are"]). % caso especial
verbo(singular, presente, segunda, ["tienes"], ["are"]). % caso especial
verbo(plural, presente, tercera, ["son"],["are"]).
verbo(plural, presente, primera, ["somos"],["are"]).
verbo(singular, presente, segunda, ["tienes"], ["have"]).
verbo(singular, presente, tercera, ["come"], ["eats"]).
verbo(singular, presente, primera, ["como"], ["eat"]).
verbo(_, presente, _, ["siguesiendo"], ["remains"]). %caso especial
verbo(singular, presente, tercera, ["corre"], ["runs"]).
verbo(singular, presente, tercera, ["piensa"], ["thinks"]).

adverbio(["comunmente"], ["commonly"]).
adverbio(["hoy"], ["today"]).


preposicion(["de"], ["of"]).
preposicion(["con"], ["with"]).
preposicion(["del"], ["of the"]).

% Por especificación de la tarea las letras donde hay tilde se cambian por una doble
% letra sin tilde. Ej: él -> eel, tú -> tuu

interrogativo(["Quieenes"], ["Who"]).
interrogativo(["Quieen"], ["Who"]).
interrogativo(["Quee"], ["What"]).
interrogativo(["Cuaal"], ["What"]).
interrogativo(["Which"], ["Cual"]).
interrogativo(["Cuaando"], ["When"]).
interrogativo(["Por_quee"], ["Why"]).
interrogativo(["Doonde"], ["Where"]).
interrogativo(["Coomo"], ["How"]).
interrogativo(["Cuaantos"], ["How_much"]).
interrogativo(["Cuaantos"], ["How_many"]).
interrogativo(["Cuaantos_anios"], ["How_old"]).
interrogativo(["Con_quee_frecuencia"], ["How often"]).
interrogativo(["De_quieen"], ["Whose"]).

pronombre(singular, primera, ["me"], ["I"]).
pronombre(singular, primera, ["yo"], ["I"]).
pronombre(singular, segunda, ["usted"], ["you"]).
pronombre(singular, segunda, ["tuu"], ["you"]).
pronombre(singular, tercera, ["eel"], ["he"]).
pronombre(singular, tercera, ["ella"], ["she"]).
pronombre(singular, tercera, ["ello"], ["it"]).
pronombre(plural, primera, ["nosotros"], ["we"]).
pronombre(plural, segunda, ["vosotros"], ["you"]).
pronombre(plural, tercera, ["ellos"], ["they"]).
pronombre(plural, tercera, ["ellas"], ["they"]).

determinante(singular, masculino, tercera, ["el"], ["the"]).
determinante(singular, femenino, tercera, ["la"], ["the"]).
determinante(plural, masculino, tercera, ["los"], ["the"]).


conjuncion(["y"], ["and"]).
conjuncion(["o"], ["or"]).

adjetivo(singular,masculino,["rojo"],["red"]).
adjetivo(singular,femenino,["roja"],["red"]).
adjetivo(singular,_,["grande"],["big"]).
adjetivo(plural, masculino, ["primeros"], ["first"]).
adjetivo(singular, femenino, ["loogica"], ["logic"]).
adjetivo(singular, _, ["popular"], ["popular"]).
adjetivo(singular, masculino, ["raapido"], ["fast"]).

