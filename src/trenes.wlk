class Locomotora {
	var peso
	var puedeArrastrar
	var velocidadMaxima
	method arrastreUtil () {
		return puedeArrastrar - peso
	}
}

class Deposito {
	var formacionesArmadas
	var locomotoras
}

class Formacion {
	var locomotoras
	var vagones
	method cantVagonesLivianos () {
		return vagones.count{vagon => vagon.pesoMaximo() < 2500}
	}
	method velocidadMaxima () {
		locomotoras.min{locomotora => locomotora.velocidadMaxima()}.velocidadMaxima()
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
}

class VagonPasajeros {
	var largo
	var ancho
	method cantidadPasajeros () {
		return if (ancho >= 2.5) largo * 8
		else largo * 10
	}
	method pesoMaximo () {
		return self.cantidadPasajeros() * 80
	}
}

class VagonCarga {
	var cargaMaxima
	method pesoMaximo () {
		return cargaMaxima + 160
	}
	method cantidadPasajeros () {
		return 2
	}
}