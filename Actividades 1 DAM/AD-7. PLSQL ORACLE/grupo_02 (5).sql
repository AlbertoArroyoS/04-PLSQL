-- Ejercicio realizado en ORACLE LIVE y en SQL DEVELOPER
-- GRUPO 2

/*  1. Antes de crear el procedimiento tenemos que hacer una funcion que nos diga si el oficio existe o no.
	a)Para ello pasamos por parámetro, P_JOBID, un oficio.
	b)Creamos la variable V_CUANTOS para saber si existe.
	c)Seleccionamos de la tabla JOBS todas las filas que contengan el oficio seleccionado.
	d)Si hay alguna fila con ese oficio V_CUANTOS tomará valor de 1 y la función retornará TRUE (existe oficio),
	por lo contrario FALSE.
*/	

create or replace function EXISTE_OFICIO (P_JOBID IN JOBS.JOB_ID%TYPE )  
return BOOLEAN AS   
    
V_CUANTOS integer := 0;

BEGIN
    
    SELECT COUNT(*)
    INTO V_CUANTOS
    FROM JOBS
    WHERE JOB_ID = P_JOBID;

        IF V_CUANTOS = 1 THEN
            RETURN TRUE;
		ELSE			
			RETURN FALSE;
		END IF;
		
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		RETURN false;

END EXISTE_OFICIO;   

/*  2. Realizamos el procedimiento ,que recibirá un empleado y un oficio por parámetros.
	a) Como el ejercicio pide mostrar los cambios realizados crearemos una variable V_JOBID_INICIAL de tipo employees.job_id
	   para conocer el oficio que tenia el empleado antes de los cambios y comprobar que efectivamente se le ha cambiado de oficio.
*/
create or replace procedure NUEVO_OFICIO (P_EMPL employees.employee_id%TYPE , P_JOBID jobs.job_id%TYPE)
    
AS

V_JOBID_INICIAL EMPLOYEES.JOB_ID%TYPE;

BEGIN

/*  b) LLamamos a la función creada anteriormente para localizar el oficio (EXISTE_OFICIO). 
	   Si existe el oficio (P_JOBID) nuevo que queremos asignar entonces seleccionamos el JOB_ID que tiene actualmente el empleado,
	   lo guardamos en la variable P_JOBID_INICIAL y a continuación modificamos a dicho el empleado el oficio por el nuevo P_JOBID.	  
*/    
IF EXISTE_OFICIO (P_JOBID) THEN
    
    SELECT  JOB_ID
    INTO V_JOBID_INICIAL
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID = P_EMPL;

    UPDATE EMPLOYEES
    SET JOB_ID = P_JOBID
    WHERE EMPLOYEE_ID = P_EMPL;

	DBMS_OUTPUT.PUT_LINE('Oficio anterior del empleado : '  || V_JOBID_INICIAL);
	DBMS_OUTPUT.PUT_LINE('Oficio nuevo del empleado : '  || P_JOBID);

    ELSE 
        DBMS_OUTPUT.PUT_LINE('EL TRABAJO NO EXISTE');

END IF;

-- La excepcion saltará en caso de que no exista el empleado recibido por parámetro;

EXCEPTION
 
	WHEN OTHERS THEN

    RAISE_APPLICATION_ERROR(-20200, 'EL TRABAJADOR NO EXISTE');

end NUEVO_OFICIO;
/

/* 3. Realizamos un bloque anónimo para probar el procedimiento. En ORACLE LIVE no reconocía el símbolo &, ni tampoco 
reconocía los "ids" de JOB Y EMPLOYEE, por lo que en OACLE LIVE hemos tenido que asignar a las variables valores numéricos. 
Al hacerlo en el DEVELOPER, funcionaba correctamente y hemos optado por dejarlo así.
*/

DECLARE 
 V_EMPL employees.employee_id%TYPE; 
 V_JOBID jobs.job_id%TYPE; 
BEGIN 
     
V_EMPL := &empleado_buscado; 
V_JOBID := '&nuevo_empleo'; 
 
NUEVO_OFICIO(V_EMPL, V_JOBID); 
 
NULL; 
EXCEPTION 
	WHEN OTHERS THEN 
	DBMS_OUTPUT.PUT_LINE('ERROR DE PROCEDIMIENTO :' ||SQLERRM); 
 
END; 
-- ROLLBACK
/* 4. Para el TRIGGER,crearemos la tabla EMPL_AUDIT, pues una vez modificado el salario,siempre que éste sea distinto al que 
      tenía el empleado, el TRIGGER se activa y recogerá los datos (empleado, fecha , salario anterior y salario nuevo) 
	  en la tabla.
	  El TRIGGER se creará:
	  a) AFTER, para que se active una vez hecha la modificacion del salario.
	  b) UPDATE, puesto que es un cambio de valor en un atributo de l atable, tendremos que recoger el salario anterior 
		 :old.salary y el nuevo :new.salary.
	  c) Será de tipo FOR EACH ROW, es decir, el TRIGGER se activará por cada fila, cada vez que realicemos un cambio de salario.	  	
*/

-- 2ª Forma:

create table EMPL_AUDIT (EMPLOYEE_ID INTEGER  not null constraint empl_audit_pk primary key,
                         FECHA timestamp NOT NULL,
                         SALARIO_ANTERIOR INTEGER NOT NULL,
                         SALARIO_NUEVO INTEGER  NOT NULL
    );


create or replace NONEDITIONABLE trigger AIU_EMPL_AUDIT
after update OF SALARY on EMPLOYEES
for each row

begin
IF (:new.salary <> :old.salary) THEN
	INSERT INTO EMPL_AUDIT(employee_id,fecha ,SALARIO_ANTERIOR,SALARIO_NUEVO)
	VALUES (:new.employee_id ,SYSDATE , :old.salary, :new.salary);
END IF;
end;


UPDATE employees set salary = 240000 where employee_id = 100;
