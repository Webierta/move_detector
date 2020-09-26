# move_detector

## Motion alarm

La mayoría de los dispositivos Android tienen un acelerómetro integrado, y la aplicación utiliza el sensor del acelerómetro para detectar el movimiento o desplazamiento del dispositivo (la fuerza de aceleración en los tres ejes de coordenadas sin considerar la gravedad).

![Sistema de coordenadas que usa el sensor](https://github.com/Webierta/move_detector/blob/master/axis_device.png)

La aplicación detecta la aceleración lineal que experimenta el dispositivo y activa la alarma cuando inicia el movimiento o cuando se detiene, en función de los ajustes realizados por el usuario.

Esto puede ser útil, por ejemplo, cuando no quieres olvidar el dispositivo dentro de un vehículo y avisa que se ha detenido, o si quieres que suene la alarma cuando alguién lo coge sin tu permiso.

