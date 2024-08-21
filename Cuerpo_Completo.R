
# SE ACTUALIZA LAS FECHAS QUE SE DESEAN EVALUAR 

x <- as.Date("2023-01-01","%Y-%m-%d")
h <- as.Date("2024-06-01","%Y-%m-%d")

# SE CREA LOS NOMBRES DE LAS TABLAS PARA CONSTRUIR

FECHA <- mutate(FECHA, NUEVA_FECHA=paste("MES_",NAME[]))

FECHA <- mutate(FECHA, NUEVA_FECHA=gsub("-","_", NUEVA_FECHA))

FECHA <- mutate(FECHA, NUEVA_FECHA=gsub(" ","", NUEVA_FECHA))

FECHA <- mutate(FECHA, CLIENTES=paste("CLIENTES_", FECHA))

FECHA <- mutate(FECHA, CLIENTES=gsub(" ","", CLIENTES))

FECHA <- mutate(FECHA, FECHA_=gsub("-","_", NAME))

# LA RUTA DONDE SE ENCUENTRAN TODOS LOS INSUMOS 
# EN ESTE CASO LOS MESES Y SUS FACTURACION POR CLIENTES

varaux <- 'RUTA DE LOS INSUMOS'

options(scipen=999) 

# ESTE BUCLE LO QUE HACE ES BUSCAR EN CADA MES LOS CLIENTES QUE SE DESEAN ESTUDIAR
# ELIMINA EL NOMBRE Y SOLO QUEDA EL ID Y LA FACTURACION
# HACE LA UNION POR CADA MES CON EL CLIENTE Y LE COLOCA LA FECHA
# AL FINAL GENERA CADA MES QUE SE ESTA ESTUDIANDO

for (i in 1:nrow(FECHA)) {
  
  if (FECHA$FECHA[i] >= x & FECHA$FECHA[i] <= h)  {
    
    varaux1 <- paste(varaux,FECHA[i,3],".xlsx")
 
    varaux1 <- gsub("/ ","/",varaux1)

    varaux1 <- gsub(" .xlsx",".xlsx",varaux1)

    varaux1 <- read_excel(varaux1)

    varaux2 <- select(varaux1, -CLIENTE)

    varaux2 <- left_join(ID, varaux2, by="ID")

    varaux2 <- mutate(varaux2,  FECHA[i,2])

    assign(paste(FECHA[i,4]),varaux2)
    
  }    
} 

# SE HACE LA UNION DE CADAMES EN UNA SOLA TABLA

f0<-data.frame()

for (i in 1:nrow(FECHA)) {
  if (FECHA$FECHA[i] >= x & FECHA$FECHA[i] <= h) {
    
    tab <- get(paste0("CLIENTES_",FECHA$FECHA[i]))
    
    f0 <- rbind(f0, tab)
    
  }
}

# SE GENERA UNA TABLA DINAMICA

CLIENTES_ESTUDIO <- dcast(f0, ID+CLIENTES~NAME, value.var="FACTURACION")    

# SE EXPORTA LOS CLIENTES ESTUDIADOS

write.xlsx(CLIENTES_ESTUDIO, 'CLIENTES_ESTUDIO.xlsx')
