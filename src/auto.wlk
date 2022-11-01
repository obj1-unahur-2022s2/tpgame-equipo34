import wollok.game.*

const velocidad = 250


object juego{ 	
	const property obstaculos = []
	
	method configurar(){
		game.title("Road Fighter")
		game.onTick(3000,"nuevoObstaculo",{self.generarObstaculo()})
		game.onTick(500,"nuevaDecoracion",{self.generarDecoracion()})
		game.onTick(3000,"nuevoObstaculoIzq",{self.generarObstaculoIzq()})
		game.onTick(3000,"nuevoObstaculoDer",{self.generarObstaculoDer()})
		game.width(13)
		game.height(12)
		game.addVisual(suelo)
		game.addVisual(auto)
		keyboard.left().onPressDo ({auto.moveteIzquierda()})	
		keyboard.right().onPressDo ({auto.moveteDerecha()})
		game.whenCollideDo(auto,{ elemento => elemento.chocar()})
	}
	method terminar(){
		game.addVisual(gameOver)
		obstaculos.forEach({o => o.detener()})
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
		self.sacar()
		juego.terminar()
	}
    method sacar(){
		game.removeVisual(self)
	}
	method detener(){
		game.removeTickEvent("nuevoObstaculo")
	}
}

class ObstaculoIzquierda {
	var position = self.posicionInicial()

	method image() = "autoObstaculo.png"
	method position() = position
	method posicionInicial() = game.at((3..9).anyOne(),11)
	method iniciar(){
		position = self.posicionInicial()
		game.addVisual(self)
		game.onTick(velocidad,"moverObstaculo",{self.mover()})
	}
	method mover(){
		position = position.down(1)
		if (position.y() == 7)
			position = position.left(1)
	}
	method chocar(){
		self.sacar()
		juego.terminar()
	}
    method sacar(){
		game.removeVisual(self)
	}
    method detener(){
		game.removeTickEvent("moverObstaculo")
	}
}

class ObstaculoDerecha {
	var position = self.posicionInicial()

	method image() = "autoObstaculo.png"
	method position() = position
	method posicionInicial() = game.at((2..8).anyOne(),11)
	method iniciar(){
		position = self.posicionInicial()
		game.addVisual(self)
		game.onTick(velocidad,"moverObstaculo",{self.mover()})
	}
	method mover(){
		position = position.down(1)
		if (position.y() == 7)
			position = position.right(1)
	}
	method chocar(){
		self.sacar()
		juego.terminar()
	}
    method sacar(){
		game.removeVisual(self)
	}
    method detener(){
		game.removeTickEvent("moverObstaculo")
	}
}

object suelo{
	method position() = game.origin()
	method image() = "suelo.png"
}

object auto {
	var vivo = 3
	var property position = game.at(6,0)
	
	method estaVivo(){return vivo > 0}
	method image(){
	if(vivo > 0){return "auto.png"}
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
		game.say(self,"¡Boom!")
		vivo -= 1
	}
}