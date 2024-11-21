class Persona{
    var property monedas = 20
    var property anios = 18

    method ganarMonedas(cantidad){
        monedas = monedas + cantidad
    }

    method gastarMonedas(cantidad){
        if(cantidad<= self.monedas()){monedas = monedas - cantidad}
    // (Si quiere gastar mas que lo que tiene, no gasta nada)
    }

    method cumplirAnios() {
        anios = anios + 1
        }

    method recursos() = monedas

    method esDestacado() = (anios >= 18 && anios <= 65) || self.recursos() > 30

    method trabajar(planet,tiempo){} //Trabajar no afecta ni a ellos ni al planeta
}
class Construccion{
    method calcularValor(){}
}
class Muralla inherits Construccion{
    const longitud 

    override method calcularValor() = longitud * 10
}
class Museo inherits Construccion{
    const property superficie 
    const property indiceDeImportancia 

    override method calcularValor() = superficie * indiceDeImportancia
}

class Productor inherits Persona{
    const property planeta // El planeta es un objeto instanciado de la clase Planeta
    const property tecnicas = ["cultivo"]
    
    override method recursos() = monedas * tecnicas.size()
    
    method pertenece(tecnica) = tecnicas.contains(tecnica) // A la tecnica se la tengo que pasar como string

    override method esDestacado() = super() || tecnicas.size() > 5

    method realizarTecnica(tecnica, tiempo){ // (tecnica como string)
        if (self.pertenece(tecnica)){self.ganarMonedas(tiempo*3)}
        else {self.perderUnidadDeRecursos()}
    }

    method aprenderTecnica(tecnica) = self.tecnicas().add(tecnica) 

    override method trabajar(planet, tiempo){
        if(planet == self.planeta()){self.realizarTecnica(tecnicas.last(), tiempo)}
    }

    method perderUnidadDeRecursos() {
        monedas = monedas - 1 / tecnicas.size()
    }
}

class Constructor inherits Persona{
    const property inteligencia 
    const property region //La region es un objeto instanciado de la clase de alguna Region (Montaña,Costa,Llanura,Valle)
    const property construccionesHechas = []

    override method recursos() = self.monedas() + construccionesHechas.size()*10

    override method esDestacado() = construccionesHechas.size() > 5

    override method trabajar(planet,tiempo){
        self.gastarMonedas(5)
        planet.construcciones().add(self.region().construir(self, tiempo))
        self.construccionesHechas().add(self.region().construir(self, tiempo))
    }

    method calcularNivelProporcional() {
        const nivel = (self.recursos()/100).min(5).max(1)
        return nivel
        
    }
}

class Region{
    method construir(construc,tiempo){}
}

class Montania inherits Region{
    override method construir(construc, tiempo){
        return new Muralla(longitud = tiempo/2)
    }
}

class Costa inherits Region{
    override method construir(construc, tiempo){
        return new Museo(superficie=tiempo, indiceDeImportancia=1)
    }
}

class Llanura inherits Region{
    override method construir(construc, tiempo){
        return if (construc.esDestacado()){new Museo(superficie = tiempo, indiceDeImportancia=construc.calcularNivelProporcional())}
        else {new Muralla(longitud=tiempo/2)}
    }
}
//Valle es inventada por mi, depende de la inteligencia del constructor
class Valle inherits Region{ //Si es muy inteligente hace el mejor museo (IQ mayor a 200)
    override method construir(construc, tiempo){
        return if (construc.inteligencia() >= 200){
            new Museo(superficie = tiempo, indiceDeImportancia=5)
        }else{
            new Muralla (longitud=tiempo)
        }
    }
}

class Planeta{
    const property habitantes = []
    const property construcciones = []
    var property delegacionDiplomatica = []

    method formarDelegacion() {
        delegacionDiplomatica = habitantes.filter({x => x.esDestacado()})
        return if (delegacionDiplomatica.contains(self.masRecursos())){delegacionDiplomatica}else{
            delegacionDiplomatica.add(self.masRecursos())
        }    
    }

    method masRecursos(){
        return habitantes.max({x=> x.recursos()})
    }

    method esValioso(){
        return construcciones.map({x=> x.calcularValor()}).sum() > 100
    }
}