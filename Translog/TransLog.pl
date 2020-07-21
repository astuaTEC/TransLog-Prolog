
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
  read(Espanol), traductor(Espanol), !.


% Seleccion del idioma Ingles: traduce al idioma Español
traductor(E) :- E = "In", 
  write('Please type your text: '),
  nl,
  read(Espanol),
  split_string(Espanol, " ", "¿¡,", L),
  oracion(K, L),
  atomic_list_concat(K, ' ', ListaPalabrasEspanol),
  write(ListaPalabrasEspanol).

% Seleccion del idioma Español: traduce al idioma Inglés
traductor(E) :- E = "Es",
  write('Ingresa el texto: '),
  nl,
  read(Espanol),
  split_string(Espanol, " ", "¿¡,", L),
  oracion(L, K),
  atomic_list_concat(K, ' ', ListaPalabrasEspanol),
  write(ListaPalabrasEspanol).

% En caso de que la frase u oración no se reconozca
no_reconocido :- write('Disculpa, no te he entendido'), nl,
                 write('Intentalo de nuevo'), nl, 
                 texto.

%Funcion que concatena las distintas partes de la oración que se encontraron
% Cabeza: Cabeza de la lista
% R: Resto
% L: lista
% ListaA, ListaB, ListaC, ListaX, ListaZ: son listas cualesquiera 
concatenar([], Lista, Lista). % caso base
concatenar([Cabeza|R1], Lista, [Cabeza|R2]) :- concatenar(R1, Lista, R2).
concatenar(ListaA, ListaB, ListaC, ListaZ)  :- concatenar(ListaA, ListaB, ListaX), 
                                               concatenar(ListaX, ListaC, ListaZ).


% ------------------------------------GRAMÁTICA LIBRE DE CONTEXTO-----------------------------------------

% Esta regla lo que hace es delimitar la estructura que puede tener una oración
% ListaPalabrasEspanol: Es una lista con la oración en Español. Ej: ["el", "hombre", "come", "la", "manzana"]
% ListaPalabrasIngles: Es una lista con la oración en Inglés. Ej: ["the", "man", "eats", "the", "apple"]
% Espanol, Espanol2, Espanol3, RestoEspanol: Todas estas variables significan una lista cualquiera de algún
%                                            elemento de la oración en el idioma Español.
% Ingles, Ingles2, Ingles3, RestoIngles: Todas estas variables significan una lista cualquiera de algún
%                                        elemento de la oración en el idioma Inglés.

oracion(ListaPalabrasEspanol, ListaPalabrasIngles) :- oracion_simple(ListaPalabrasEspanol, ListaPalabrasIngles).
oracion(ListaPalabrasEspanol, ListaPalabrasIngles) :- oracion_simple(Espanol, Ingles), conjuncion(Espanol2, Ingles2), 
                                                      concatenar(Espanol, Espanol2, Espanol3), 
                                                      concatenar(Ingles, Ingles2, Ingles3), 
                                                      concatenar(Espanol3, RestoEspanol, ListaPalabrasEspanol), 
                                                      concatenar(Ingles3, RestoIngles, ListaPalabrasIngles), 
                                                      oracion(RestoEspanol, RestoIngles).  

oracion(ListaPalabrasEspanol, ListaPalabrasIngles) :- oracion_simple(Espanol, Ingles), preposicion(Espanol2, Ingles2),
                                                      concatenar(Espanol,Espanol2, Espanol3), 
                                                      concatenar(Ingles,Ingles2, Ingles3), 
                                                      concatenar(Espanol3, RestoEspanol, ListaPalabrasEspanol), 
                                                      concatenar(Ingles3, RestoIngles, ListaPalabrasIngles), 
                                                      oracion(RestoEspanol,RestoIngles).
                

oracion(ListaPalabrasEspanol, ListaPalabrasIngles) :- no_reconocido, !.

% Es una subdivisión de una oración más compleja en una oración más simple. En este caso para
% facilidad a la hora de formar oraciones con más elementos en la gramática
% Persona: significa la persona en la cual está conjugado algún elemento de la oración (primera, segunda, tercera) 

oracion_simple(ListaPalabrasEspanol, ListaPalabrasIngles) :- saludo(Espanol, Ingles), 
                                                             concatenar(Espanol, ["!"], ListaPalabrasEspanol), 
                                                             concatenar(Ingles, ["!"], ListaPalabrasIngles).

% Esto es una excepción a la gramática, solo para temas de la especificación de la tarea
oracion_simple(ListaPalabrasEspanol, ListaPalabrasIngles) :- sintagma_nominal(ListaPalabrasEspanol, ListaPalabrasIngles, Persona).

oracion_simple(ListaPalabrasEspanol, ListaPalabrasIngles) :- sintagma_nominal(Espanol, Ingles, Persona), 
                                                             sintagma_verbal(Espanol2, Ingles2, Persona), 
                                                             concatenar(Espanol, Espanol2, ListaPalabrasEspanol), 
                                                             concatenar(Ingles, Ingles2, ListaPalabrasIngles).

% Esto es una excepción a la gramática, solo para temas de la especificación de la tarea. Se utiliza para
% preguntas sencillas
oracion_simple(ListaPalabrasEspanol, ListaPalabrasIngles) :- interrogativo(Espanol, Ingles), 
                                                             sintagma_verbal(Espanol2, Ingles2, Persona), 
                                                             concatenar(Espanol, Espanol2, ResultadoEspanol), 
                                                             concatenar(ResultadoEspanol, ["?"], ListaPalabrasEspanol), 
                                                             concatenar(Ingles, Ingles2, ResultadoIngles), 
                                                             concatenar(ResultadoIngles, ["?"], ListaPalabrasIngles).


%-----------------------------------------SINTAGMA VERBAL------------------------------------------

% Se define la estructura para un sintagma verbal
% PalabraEspanol: Es una lista con la oración en Español.
% PalabraIngles: Es una lista con la oración en Inglés.
% Espanol, Espanol2: Todas estas variables significan una lista cualquiera de algún
%                    elemento de la oración en el idioma Español.
% Ingles, Ingles2: Todas estas variables significan una lista cualquiera de algún
%                  elemento de la oración en el idioma Inglés.
% Persona: significa la persona en la cual está conjugado algún elemento de la oración
%          (primera, segunda, tercera) 
% Numero: corresponte a plural o singular
% Tiempo: corresponde a pasado, presente o futuro

sintagma_verbal(PalabraEspanol, PalabraIngles, Persona) :- verbo(Numero, Tiempo, Persona, PalabraEspanol, PalabraIngles).
sintagma_verbal(PalabraEspanol, PalabraIngles, Persona) :- verbo(Numero, Tiempo, Persona, Espanol, Ingles),
                                                           sintagma_nominal(Espanol2, Ingles2, Persona), 
                                                           concatenar(Espanol, Espanol2, PalabraEspanol), 
                                                           concatenar(Ingles, Ingles2, PalabraIngles).


%-------------------------------------------------SINTAGMA NOMINAL-----------------------------------

% Se define la estructura para un sintagma verbal
% PalabraEspanol: Es una lista con la oración en Español.
% PalabraIngles: Es una lista con la oración en Inglés.
% Espanol, Espanol2, Espanol3: Todas estas variables que son una sola letra, significan una lista cualquiera de algún
%          elemento de la oración en el idioma Español.
% Ingles, Ingles2, Ingles3: Todas estas variables que son dos letras, significan una lista cualquiera de algún
%             elemento de la oración en el idioma Inglés.
% Persona: significa la persona en la cual está conjugado algún elemento de la oración
%          (primera, segunda, tercera) 
% Numero: corresponte a plural o singular
% Tiempo: corresponde a pasado, presente o futuro
% Genero: corresponde a masculino o femenino

% Estos son los elementos más atómicos del sintagma nominal
sintagma_nominal(PalabraEspanol, PalabraIngles, Persona) :- sustantivo(Numero, Genero, PalabraEspanol, PalabraIngles).
sintagma_nominal(PalabraEspanol, PalabraIngles, Persona) :- pronombre(Numero, Persona, PalabraEspanol, PalabraIngles).
sintagma_nominal(PalabraEspanol, PalabraIngles, Persona) :- adjetivo(Numero, Genero, PalabraEspanol, PalabraIngles).


% Estos son los elementos complejos del sintagma nominal
sintagma_nominal(PalabraEspanol, PalabraIngles, Persona) :- determinante(Numero, Genero, Persona, Espanol, Ingles),
                                                            sustantivo(Numero, Genero, Espanol2, Ingles2),
                                                            concatenar(Espanol, Espanol2, PalabraEspanol), 
                                                            concatenar(Ingles, Ingles2, PalabraIngles).

sintagma_nominal(PalabraEspanol, PalabraIngles, Persona) :- sustantivo(Numero, Genero, Espanol, Ingles), 
                                                            adjetivo(Numero, Genero, Espanol2, Ingles2),
                                                            concatenar(Espanol, Espanol2, PalabraEspanol), 
                                                            concatenar(Ingles2, Ingles, PalabraIngles).

sintagma_nominal(PalabraEspanol, PalabraIngles, Persona) :- determinante(Numero, Genero, Persona, Espanol, Ingles),
                                                            adjetivo(Numero, Genero, Espanol2, Ingles2), 
                                                            sustantivo(Numero, Genero, Espanol3, Ingles3), 
                                                            concatenar(Espanol, Espanol2, Espanol3, PalabraEspanol), 
                                                            concatenar(Ingles, Ingles2, Ingles3, PalabraIngles).

sintagma_nominal(PalabraEspanol, PalabraIngles, Persona) :- determinante(Numero, Genero, Persona, Espanol, Ingles),
                                                            sustantivo(Numero, Genero, Espanol2, Ingles2), 
                                                            adjetivo(Numero, Genero, Espanol3, Ingles3), 
                                                            concatenar(Espanol, Espanol2, Espanol3, PalabraEspanol), 
                                                            concatenar(Ingles, Ingles3, Ingles2, PalabraIngles).

sintagma_nominal(PalabraEspanol, PalabraIngles, Persona) :- adjetivo(Numero, Genero, Espanol, Ingles), 
                                                            adverbio(Espanol2, Ingles2), 
                                                            concatenar(Espanol, Espanol2, PalabraEspanol), 
                                                            concatenar(Ingles, Ingles2, PalabraIngles).



%----------------------------------------------BASE DE DATOS-----------------------------------------------

% sustantivo(Numero, Genero, PalabraEspanol, PalabraIngles).
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


% verbo(Numero, Tiempo, Persona, PalabraEspanol, PalabraIngles).
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

