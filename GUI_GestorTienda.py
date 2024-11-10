import tkinter as tk
from tkinter import messagebox

class TiendaApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Tienda")
        self.inventario = []

        # Título principal
        tk.Label(root, text="Menú Principal", font=("Arial", 18)).pack(pady=10)
        
        # Botón para agregar producto
        btn_agregar = tk.Button(root, text="Agregar Producto", command=self.agregar_producto, width=30, height=2)
        btn_agregar.pack(pady=10)
        
        # Botón para ver inventario
        btn_ver_inventario = tk.Button(root, text="Ver Inventario", command=self.ver_inventario, width=30, height=2)
        btn_ver_inventario.pack(pady=10)
        
        # Botón para iniciar venta
        btn_iniciar_venta = tk.Button(root, text="Iniciar Venta", command=self.iniciar_venta, width=30, height=2)
        btn_iniciar_venta.pack(pady=10)
        
        # Botón para información de proveedores
        btn_proveedores = tk.Button(root, text="Información de Proveedores", command=self.informacion_proveedores, width=30, height=2)
        btn_proveedores.pack(pady=10)
        
        # Botón para salir
        btn_salir = tk.Button(root, text="Salir", command=root.quit, width=30, height=2)
        btn_salir.pack(pady=10)

    def agregar_producto(self):
        ventana_agregar = tk.Toplevel(self.root)
        ventana_agregar.title("Agregar Producto")

        tk.Label(ventana_agregar, text="Nombre del Producto").pack(pady=5)
        nombre_entry = tk.Entry(ventana_agregar)
        nombre_entry.pack(pady=5)

        tk.Label(ventana_agregar, text="Cantidad").pack(pady=5)
        cantidad_entry = tk.Entry(ventana_agregar)
        cantidad_entry.pack(pady=5)

        tk.Label(ventana_agregar, text="Precio").pack(pady=5)
        precio_entry = tk.Entry(ventana_agregar)
        precio_entry.pack(pady=5)

        def guardar_producto():
            nombre = nombre_entry.get()
            cantidad = cantidad_entry.get()
            precio = precio_entry.get()

            if nombre and cantidad and precio:
                self.inventario.append({"nombre": nombre, "cantidad": cantidad, "precio": precio})
                messagebox.showinfo("Éxito", "Producto agregado correctamente")
                ventana_agregar.destroy()
            else:
                messagebox.showwarning("Error", "Todos los campos son obligatorios")

        tk.Button(ventana_agregar, text="Guardar", command=guardar_producto).pack(pady=20)

    def ver_inventario(self):
        ventana_inventario = tk.Toplevel(self.root)
        ventana_inventario.title("Inventario")

        for producto in self.inventario:
            tk.Label(ventana_inventario, text=f"Nombre: {producto['nombre']}, Cantidad: {producto['cantidad']}, Precio: {producto['precio']}").pack()

    def iniciar_venta(self):
        ventana_venta = tk.Toplevel(self.root)
        ventana_venta.title("Iniciar Venta")

        tk.Label(ventana_venta, text="Función de iniciar venta en construcción...").pack(pady=20)

    def informacion_proveedores(self):
        ventana_proveedores = tk.Toplevel(self.root)
        ventana_proveedores.title("Información de Proveedores")

        tk.Label(ventana_proveedores, text="Función de información de proveedores en construcción...").pack(pady=20)


# Configuración de la ventana principal
root = tk.Tk()
app = TiendaApp(root)
root.mainloop()
