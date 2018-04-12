#############################################################
#PROCESA ARCHIVOS DUMP                                      #
#############################################################
#!/bin/bash

# VARIABLES:
FECHA=`date +"%b%_d %H:%M:%S"`
FECHALOG=`date +"%Y%m%d%H%M"`
FECHAARCH=`date +"%Y%m%d"`
PATH="/home/canabalon/Descargas/CLARO/PROYECTO_IMEI"
ARCHIVOS=`/bin/ls -lrt *.csv`

DUM1="aaa.csv"
DUM2="bbb.csv"
DUM3="ccc.csv"

DUMSORT1="$DUM1.sort"
DUMSORT2="$DUM2.sort"
DUMSORT3="$DUM3.sort"

## INICIO
#LIMPIO DIRECTORIO
/bin/rm -f *.txt *.log
echo "$FECHA [CUADRATURA]:INICIANDO CUADRATURA" >  log$FECHALOG.log
echo "$FECHA [CUADRATURA]:VALIDANDO ARCHIVOS DUMP" >> log$FECHALOG.log

### VALIDO ARCHIVOS EXISTENTES EN SERVIDOR :

VAR1=`/bin/ls -lrth $DUM1 | /bin/awk '{print $5}'`
VAR2=`/bin/ls -lrth $DUM2 | /bin/awk '{print $5}'`
VAR3=`/bin/ls -lrth $DUM3  | /bin/awk '{print $5}'`
 

if [ "$VAR1" -gt 0  ] && [ "$VAR2" -gt 0  ]  && [ "$VAR3" -gt 0  ] ; then
   echo "$FECHA [CUADRATURA]:DUMP EXISTEN" >> log$FECHALOG.log 
   echo "${ARCHIVOS}" >> log$FECHALOG.log
 else 
  echo "$FECHA [CUADRATURA]:DUMP NO EXISTEN,PROCESO FALLIDO" 
  echo "$FECHA [CUADRATURA]:DUMP NO EXISTEN,PROCESO FALLIDO" > $PATH/log/logERROR$FECHALOG.log 
  exit 0    
 fi


## sort 
/bin/cat $DUM1 | /bin/sort | /bin/uniq   >  $DUMSORT1
/bin/cat $DUM2 | /bin/sort | /bin/uniq   >  $DUMSORT2
/bin/cat $DUM3 | /bin/sort | /bin/uniq   >  $DUMSORT3


##  a-b 
echo "$FECHA [CUADRATURA]:GENERANDO REPORTES $DUM1-$DUM2" >> log$FECHALOG.log
echo "$FECHA [CUADRATURA]:GENERANDO REPORTE DE IMEI QUE ESTA EN $DUMSORT1 PERO NO ESTAN EN $DUMSORT2" > resultado_${FECHAARCH}_imei_A-B.txt
echo "$FECHA [CUADRATURA]:GENERANDO REPORTE DE IMEI QUE ESTA EN $DUMSORT2 PERO NO ESTAN EN $DUMSORT1" > resultado_${FECHAARCH}_imei_B-A.txt

/bin/diff $DUMSORT1 $DUMSORT2  |  /bin/awk -v cc='>>' '{if($1==">"){cmd="echo "$2" "cc" resultado_${FECHAARCH}_imei_B-A.txt"; system(cmd)} else if ($1=="<"){cmd="echo "$2" "cc" resultado_${FECHAARCH}_imei_A-B.txt"; system(cmd)}}'

echo "$FECHA [CUADRATURA]:REPORTES GENERADOS OK" >> log$FECHALOG.log


##  a-c
echo "$FECHA [CUADRATURA]:GENERANDO REPORTES $DUM1-$DUM3" >> log$FECHALOG.log
echo "$FECHA [CUADRATURA]:REPORTE DE IMEI QUE ESTA EN $DUMSORT1 PERO NO ESTAN EN $DUMSORT3" > resultado_${FECHAARCH}_imei_A-C.txt 
echo "$FECHA [CUADRATURA]:REPORTE DE IMEI QUE ESTA EN $DUMSORT3 PERO NO ESTAN EN $DUMSORT1" > resultado_${FECHAARCH}_imei_C-A.txt

/bin/diff $DUMSORT1 $DUMSORT3  |  /bin/awk -v cc='>>' '{if($1==">"){cmd="echo "$2" "cc" resultado_${FECHAARCH}_imei_C-A.txt"; system(cmd)} else if ($1=="<"){cmd="echo "$2" "cc" resultado_${FECHAARCH}_imei_A-C.txt"; system(cmd)}}'

echo "$FECHA [CUADRATURA]:REPORTES GENERADOS OK" >> log$FECHALOG.log

##  b-c
echo "$FECHA [CUADRATURA]:GENERANDO REPORTES $DUM2-$DUM3" >> log$FECHALOG.log
echo "$FECHA [CUADRATURA]:REPORTE DE IMEI QUE ESTA EN $DUM2 PERO NO ESTAN EN $DUM3" > resultado_${FECHAARCH}_imei_B-C.txt 
echo "$FECHA [CUADRATURA]:REPORTE DE IMEI QUE ESTA EN $DUM3 PERO NO ESTAN EN $DUM2" > resultado_${FECHAARCH}_imei_C-B.txt

/bin/diff $DUMSORT1 $DUMSORT3  |  /bin/awk -v cc='>>' '{if($1==">"){cmd="echo "$2" "cc" resultado_${FECHAARCH}_imei_C-B.txt"; system(cmd)} else if ($1=="<"){cmd="echo "$2" "cc" resultado_${FECHAARCH}_imei_B-C.txt"; system(cmd)}}'

echo "$FECHA [CUADRATURA]:REPORTES GENERADOS OK" >> log$FECHALOG.log

ARCHIVOS2=`/bin/ls -lrt resultado_${FECHAARCH}* | /bin/awk '{print$5,$6,$7,$8,$9}'`

echo "$FECHA [CUADRATURA]:REPORTES GENERADOS OK" >> log$FECHALOG.log
echo "${ARCHIVOS2}" >> log$FECHALOG.log
##  copio log a directorio log 


/bin/mv log$FECHALOG.log $PATH/log/
/bin/mv  resultado_${FECHAARCH}* $PATH/resultados
exit



