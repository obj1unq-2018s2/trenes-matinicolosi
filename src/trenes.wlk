class Ciudad {
	var property esGrande 
}
class Locomotora {
	var property peso
	var property puedeArrastrar
	var property velocidadMaxima
	method arrastreUtil () {
		return puedeArrastrar - peso
	}
}

class Deposito {
	var property formacionesArmadas
	var property locomotoras
	method vagonesPesados () {
		var conjuntoVagonesPesados = #{}
		conjuntoVagonesPesados.add(formacionesArmadas.vagones().max({vagon => vagon.pesoMaximo()}))
		return conjuntoVagonesPesados
	}
	method necesitaConductorExperimentado () {
		return formacionesArmadas.any{formacion => formacion.esCompleja()}
	}
}

class Formacion {
	var property locomotoras
	var property vagones
	method cantidadBaniosVagones () {
		return return vagones.sum{vagon => vagon.banios()}
	}
	method cantVagonesLivianos () {
		return vagones.count{vagon => vagon.pesoMaximo() < 2500}
	}
	method velocidadMaxima () {
		return locomotoras.min{locomotora => locomotora.velocidadMaxima()}.velocidadMaxima()
	}
	method esEficiente () {
		return locomotoras.all{locomotora => locomotora.peso() * 5 <= locomotora.puedeArrastrar()}
	}
	method totalPasajeros () {
		return vagones.sum{vagon => vagon.cantidadPasajeros()}
	}
	method puedeMoverse () {
		return locomotoras.sum{locomotora => locomotora.arrastreUtil()} >= vagones.sum{vagon => vagon.pesoMaximo()}
	}
	method cantidadKilosEmpujeQueFaltan () {
		return if (self.puedeMoverse()) 0
		else vagones.sum{vagon => vagon.pesoMaximo()} - locomotoras.sum{locomotora => locomotora.arrastreUtil ()}
	}
	method esCompleja () {
		return vagones.size() + locomotoras.size() > 20 or vagones.sum{vagon => vagon.pesoMaximo()} + locomotoras.sum{locomotora => locomotora.peso()} > 10000
	}
}

class FormacionCortaDistancia inherits Formacion {
	var property limiteDeVelocidad = 60
	method estaBienArmada () {
		return (self.puedeMoverse() and not self.esCompleja())
	}	
	method velocidadMaximaNueva () {
		return [limiteDeVelocidad, self.velocidadMaxima()].min()
	}
}

class FormacionLargaDistancia inherits Formacion {
	var property ciudadesQueUne
	method limiteDeVelocidad () {
		return if (ciudadesQueUne.count{ciudad => ciudad.esGrande()} == 2) 200
		else 150
	}
	method estaBienArmada () {
		return (self.puedeMoverse() and self.totalPasajeros() / self.cantidadBaniosVagones () <= 50)
	}
	method velocidadMaximaNueva () {
		return [self.limiteDeVelocidad(), self.velocidadMaxima()].min()
	}
}

class FormacionDeAltaVelocidad inherits Formacion {
	var property limiteDeVelocidad = 400	
	method velocidadMaximaNueva () {
		return [limiteDeVelocidad, self.velocidadMaxima()].min()
	}
	method estaBienArmada () {
		return (self.velocidadMaximaNueva () >= 250) and self.vagones().all({vagon => vagon.esLiviano()})
	}
}

class VagonPasajeros {
	var property largo
	var property ancho
	var property banios
	method cantidadPasajeros () {
		return if (ancho >= 2.5) largo * 8
		else largo * 10
	}
	method pesoMaximo () {
		return self.cantidadPasajeros() * 80
	}
	method esLiviano () {return self.pesoMaximo() < 2500}
}

class VagonCarga {
	var property cargaMaxima
	var property banios = 0
	method pesoMaximo () {
		return cargaMaxima + 160
	}
	method cantidadPasajeros () {
		return 2
	}
	method esLiviano () {
		return self.pesoMaximo() < 2500
	}
}