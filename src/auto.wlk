import wollok.game.*

const velocidad = 250


object juego{ 	
	const property obstaculos = []
	
	method configurar(){
		game.title("Road Fighter")
		game.onTick(3000,"nuevoObstaculo",{self.generarObstaculo()})
		game.onTick(500,"nuevaDecoracion",{self.generarDecoracion()})
		game.onTick(2100,"nuevoObstaculoIzq",{self.generarObstaculoIzq()})
		game.onTick(8900,"nuevoObstaculoDer",{self.generarObstaculoDer()})
		game.width(13)
		game.height(12)
		game.addVisual(suelo)
		game.addVisual(auto)
		game.addVisual(vidas)
		game.addVisual(miniMapa)
		game.addVisual(miniAuto)
		game.onTick(6000,"moverMiniAuto",{miniAuto.mover()})
		keyboard.left().onPressDo ({auto.moveteIzquierda()})	
		keyboard.right().onPressDo ({auto.moveteDerecha()})
		game.whenCollideDo(auto,{elemento => elemento.chocar()})
	}
	
	method terminar(){
		game.addVisual(gameOver)
		obstaculos.forEach({o => o.detener()})
		game.removeTickEvent("moverMiniAuto")
		game.removeTickEvent("nuevoObstaculo")
		game.removeTickEvent("nuevaDecoracion")
		game.removeTickEvent("nuevoObstaculoIzq")
		game.removeTickEvent("nuevoObstaculoDer")
		auto.chocar()
	}
	
	method generarObstaculo(){
		const obsta = new Obstaculo()
		obsta.iniciar()
		obstaculos.add(obsta)
	}
	
	method generarDecoracion(){
		const deco = new Decoracion()
		deco.iniciar()
		obstaculos.add(deco)
	}
	
	method generarObstaculoIzq(){
		const obstaIzq = new ObstaculoIzquierda()
		obstaIzq.iniciar()
		obstaculos.add(obstaIzq)
	}
	
	method generarObstaculoDer(){
		const obstaDer = new ObstaculoDerecha()
		obstaDer.iniciar()
		obstaculos.add(obstaDer)
	}
}


object gameOver {
	method position() = game.center()
	method text() = "GAME OVER"
}


class Decoracion {
	var position = self.posicionInicial()
	
	method image() = "arbolDecoracion.png"
	method position() = position
	method posicionInicial() = game.at(0,11)
	method iniciar(){
		position = self.posicionInicial()
		game.addVisual(self)
		game.onTick(velocidad,"moverDecoracion",{self.mover()})
	}
	method mover(){
		position = position.down(1)
		if (position.y() == -1)
			game.removeVisual(self)
	}
	method detener(){
		game.removeTickEvent("moverDecoracion")
	}
}





class Obstaculo {
	var position = self.posicionInicial()

	method image() = "autoObstaculo.png"
	method position() = position
	method posicionInicial() = game.at((2..9).anyOne(),11)
	method iniciar(){
		position = self.posicionInicial()
		game.addVisual(self)
		game.onTick(velocidad,"nuevoObstaculo",{self.mover()})
	}
	method mover(){
		position = position.down(1)
		if (position.y() == -1)
			self.sacar()
	}
	method chocar(){
		auto.chocar()
		vidas.actualizar()
		if(not auto.estaVivo()){
		self.sacar()
		juego.terminar()
		}
	}
    method sacar(){
		game.removeVisual(self)
	}
	method detener(){
		game.removeTickEvent("nuevoObstaculo")
	}}
	
	
	

class ObstaculoIzquierda inherits Obstaculo {
	override method image() = "autoObstaculo.png"
	override method posicionInicial() = game.at((3..9).anyOne(),11)
	override method mover(){
		position = position.down(1)
		if (position.y() == 7)
			position = position.left(1)
	}
	}

class ObstaculoDerecha inherits Obstaculo {
	override method image() = "camion.png"
	override method posicionInicial() = game.at((2..8).anyOne(),11)
	override method mover(){
		position = position.down(1)
		if (position.y() == 7)
			position = position.right(1)
	}
	}
	
	
	
	
	
object suelo{
	method position() = game.origin()
	method image() = "suelo.png"
}



object miniMapa{
	method position() = game.at(12,0)
	method image() = "miniMapa.png"
}



object auto {
	var property vivo = true
	var property vidaRestantes = 50
	var property position = game.at(6,0)
	
	method estaVivo(){
		if(vidaRestantes <= 0){vivo = false}
		else{vivo = true}
		return vivo
	}
	
	method image(){
	if(vivo){return "auto.png"}
	else{return "explocion.png"}
	}
	
	method moveteDerecha(){
		if(position == game.at(9,0)){self.position(self.position().left(1))}
		else{self.position(self.position().right(1))}
	}
	
	method moveteIzquierda(){
		if(position == game.at(2,0)){self.position(self.position().right(1))}
		else{self.position(self.position().left(1))}
	}
	
	method chocar(){
		vidaRestantes = vidaRestantes - 1
	}
}



object miniAuto {
	var property position = self.positionInicial()
	
	method image(){return "miniCar.png"}
	method mover(){position = position.up(1)}
	method positionInicial(){return game.at(12,0)}
}



object vidas {
	var vidas = auto.vidaRestantes()
	
	method text() = "Vida restante:" + vidas.toString()
	method position() = game.at(1, game.height()-1)
	method actualizar(){vidas = auto.vidaRestantes()}
}

