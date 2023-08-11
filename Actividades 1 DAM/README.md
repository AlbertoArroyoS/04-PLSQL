**Enunciado**

Dado el siguiente modelo relacional se pide, entregar la actividad por grupos con las siguientes especificaciones:

![](img/Aspose.Words.795539ad-83bc-4a72-adde-a872d5db2af7.001.png)

1. Crea un procedimiento que reciba un número de empleado y una cadena correspondiente a su nuevo oficio (job\_id) como parámetros. El procedimiento deberá localizar el empleado, modificar su oficio por el nuevo y visualizar los cambios realizados.
1. El procedimiento ha de llamar a una función que deberá comprobar si el id del oficio existe. Esta tarea la realizará una función aparte a la que se le pasará el oficio por parámetro y retornará un booleano. Si el oficio no existe, el procedimiento informará con un mensaje por consola.
1. Crea también un bloque anónimo donde ejecutar el procedimiento con los valores de los argumentos recogidos en variables de sustitución.
1. Crea un trigger que inserte un registro en una tabla nueva llamada EMP\_AUDIT cada vez que modificamos el salario de un empleado. Sólo se realizará la operación si el salario que se va a modificar difiere del nuevo. La tabla EMP\_AUDIT tendrá los siguientes campos:
   1. Identificador del empleado que se está actualizando.
   1. El momento en que se hace la actualización.
   1. Un mensaje que contenga el salario anterior y el nuevo.


