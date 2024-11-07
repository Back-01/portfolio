#include <iostream>        //hacemos una lista con nodos creados por struct
#include <string>
using namespace std;

template <typename T>
struct Nodo {
    T dato;
    Nodo* siguiente;

    Nodo(T valor){
        dato = valor;
        siguiente = nullptr;
    }
};

template <typename T>
class ListaEnlazada {
    Nodo<T>* cabeza;

public:
    ListaEnlazada(){
        cabeza = nullptr;
    }

    void agregar(T valor) {
        Nodo<T>* nuevoNodo = new Nodo<T>(valor);
        if (cabeza == nullptr) {
            cabeza = nuevoNodo;
        } else {
            Nodo<T>* actual = cabeza;
            while (actual->siguiente != nullptr){
                actual = actual->siguiente;
            }
            actual->siguiente = nuevoNodo;
        }
        cout << "Elemento " << valor << " agregado a la lista. \n";
    }

    void mostrar(){
        if (cabeza == nullptr) {
            cout << "La lista está vacía. \n";
            return;
        }
        Nodo<T>* actual = cabeza;
        cout << "Elementos de la lista: ";
        while (actual != nullptr) {
            cout << actual->dato << " ";
            actual = actual->siguiente;
        }
        cout << endl;
    }
};

int main(){
    // Lista de enteros
    ListaEnlazada<int> listaEnteros;
    listaEnteros.agregar(5);
    listaEnteros.agregar(10);
    listaEnteros.agregar(15);
    listaEnteros.mostrar();

    // Lista de caracteres
    ListaEnlazada<char> listaCaracteres;
    listaCaracteres.agregar('A');
    listaCaracteres.agregar('B');
    listaCaracteres.agregar('C');
    listaCaracteres.mostrar();

    return 0;
}
