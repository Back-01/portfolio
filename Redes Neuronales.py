import tkinter as tk
from tkinter import messagebox
from PIL import ImageGrab, Image, ImageDraw
import numpy as np
import os
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Conv2D, MaxPooling2D, Flatten, Dense, Input
from tensorflow.keras.utils import to_categorical

IMAGE_DIR = "imagenes"
NUM_CLASSES = 4
EPOCHS = 10
IMAGE_SIZE = (64, 64)
CANVAS_WIDTH, CANVAS_HEIGHT = 500, 500


class DrawingApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Dibuja una imagen")
        self.canvas = tk.Canvas(root, width=CANVAS_WIDTH, height=CANVAS_HEIGHT, bg="black")
        self.canvas.pack()
        self.canvas.bind("<B1-Motion>", self.paint)
        self.canvas.bind("<Button-1>", self.active_draw)
        self.canvas.bind("<ButtonRelease-1>", self.reset)

        limpiar = tk.Button(root, text="Limpiar", command=self.clear_canvas)
        limpiar.pack()

        save_button = tk.Button(root, text="Guardar", command=self.save_canvas)
        save_button.pack()

        train_button = tk.Button(root, text="Entrenar", command=self.train_model)
        train_button.pack()

        predict_button = tk.Button(root, text="Predecir", command=self.predict_image)
        predict_button.pack()

        # Inicializar variables de clase e imagen
        self.current_class = 0
        self.image_count = 0
        self.model = None  # Asegúrate de inicializar el modelo a None
        if not os.path.exists(IMAGE_DIR):
            os.makedirs(IMAGE_DIR)

    def active_draw(self, event):
        """Iniciar el trazo"""
        self.last_x, self.last_y = event.x, event.y

    def reset(self, event):
        """Resetea la posición al soltar el mouse"""
        self.last_x, self.last_y = None, None

    def paint(self, event):
        x, y = event.x, event.y
        self.canvas.create_oval(x-5, y-5, x+5, y+5, fill="white")

    def clear_canvas(self):
        self.canvas.delete("all")
        
    def save_canvas(self):
        x = self.root.winfo_rootx() + self.canvas.winfo_x()
        y = self.root.winfo_rooty() + self.canvas.winfo_y()
        x1 = x + self.canvas.winfo_width()
        y1 = y + self.canvas.winfo_height()
        self.img = ImageGrab.grab().crop((x, y, x1, y1))
        self.img = self.img.resize((28, 28))
        self.img = self.img.convert('L')
        img_arreglo = np.array(self.img)
        print(img_arreglo)
        img_arregloN = img_arreglo / 255.0
        print(img_arregloN)
        self.save_image()

    def save_image(self):
        if self.current_class >= NUM_CLASSES:
            messagebox.showinfo("Info", "Has guardado todas las imágenes")
            return
    
        image_path = os.path.join(IMAGE_DIR, f"class_{self.current_class}_img_{self.image_count}.png")
        self.img.save(image_path)
        messagebox.showinfo("Guardado", f"Imagen guardada {image_path}")

        self.image_count += 1
        self.clear_canvas()
        if self.image_count >= 4:
            self.image_count = 0
            self.current_class += 1
            if self.current_class >= NUM_CLASSES:
                messagebox.showinfo("Info", "Carga completa de clases")

    def load_images(self):
        images = []
        labels = []
        for class_id in range(NUM_CLASSES):
            for img_id in range(4):
                image_path = os.path.join(IMAGE_DIR, f"class_{class_id}_img_{img_id}.png")
                if os.path.exists(image_path):
                    img = Image.open(image_path).resize(IMAGE_SIZE).convert('RGB')
                    img_array = np.array(img) / 255.0
                    images.append(img_array)
                    labels.append(class_id)
                else:
                    messagebox.showwarning("Cuidado", f"Imagen {image_path} no encontrada")
                    return None, None
        images = np.array(images)
        labels = to_categorical(labels, NUM_CLASSES)
        return images, labels

    def build_model(self):
        model = Sequential([
            Input(shape=(64, 64, 3)),
            Conv2D(32, kernel_size=(3, 3), activation="relu"),
            MaxPooling2D(pool_size=(2, 2)),
            Conv2D(64, kernel_size=(3, 3), activation="relu"),
            MaxPooling2D(pool_size=(2, 2)),
            Flatten(),
            Dense(128, activation="relu"),
            Dense(NUM_CLASSES, activation="softmax")
        ])
        model.compile(optimizer="adam", loss="categorical_crossentropy", metrics=["accuracy"])
        return model

    def train_model(self):
        images, labels = self.load_images()
        if images is None:
            return
        self.model = self.build_model()
        self.model.fit(images, labels, epochs=EPOCHS)
        messagebox.showinfo("Entrenamiento completo")

    def predict_image(self):
        if self.model is None:
            messagebox.showerror("Error", "Debes entrenar el modelo primero")
            return

        # Ventana para dibujar la imagen a predecir
        predict_window = tk.Toplevel(self.root)
        predict_window.title("Dibujar para predecir")

        predict_canvas = tk.Canvas(predict_window, width=CANVAS_WIDTH, height=CANVAS_HEIGHT, bg='white')
        predict_canvas.pack()

        draw = False
        last_x, last_y = None, None

        predict_image = Image.new('RGB', (CANVAS_WIDTH, CANVAS_HEIGHT), 'white')
        draw_pil = ImageDraw.Draw(predict_image)

        def on_press(event):
            nonlocal draw, last_x, last_y
            draw = True
            last_x, last_y = event.x, event.y

        def on_move(event):
            nonlocal draw, last_x, last_y
            if draw:
                x, y = event.x, event.y
                predict_canvas.create_line((last_x, last_y, x, y), fill='black', width=5)
                draw_pil.line((last_x, last_y, x, y), fill='black', width=5)
                last_x, last_y = x, y

        def on_release(event):
            nonlocal draw, last_x, last_y
            draw = False
            last_x, last_y = None, None

        predict_canvas.bind("<ButtonPress-1>", on_press)
        predict_canvas.bind("<B1-Motion>", on_move)
        predict_canvas.bind("<ButtonRelease-1>", on_release)

        def save_and_predict():
            temp_path = os.path.join(IMAGE_DIR, "temp_predict.png")
            predict_image.save(temp_path)

            img = Image.open(temp_path).resize(IMAGE_SIZE).convert('RGB')
            img_array = np.array(img) / 255.0
            img_array = np.expand_dims(img_array, axis=0)

            prediction = self.model.predict(img_array)
            predicted_label = np.argmax(prediction)
            confidence = np.max(prediction) * 100

            messagebox.showinfo("Predicción", f"Clase predicha: {predicted_label}\nConfianza: {confidence:.2f}%")
            predict_window.destroy()

        predict_button = tk.Button(predict_window, text="Predecir", command=save_and_predict)
        predict_button.pack(pady=10)

        cancel_button = tk.Button(predict_window, text="Cancelar", command=predict_window.destroy)
        cancel_button.pack(pady=5)

root = tk.Tk()
app = DrawingApp(root)
root.mainloop()
