import wollok.game.*

const velocidad = 250


object juego{
	
	method configurar(){
		game.width(12)
		game.height(12)
		game.addVisual(suelo)
		game.addVisual(auto)
		game.addVisual(obstaculo)
		game.addVisual(obstaculo2)
		keyboard.left().onPressDo ({auto.moveteIzquierda()})	
		keyboard.right().onPressDo ({auto.moveteDerecha()})
		game.onCollideDo(auto,{ obstaculo => obstaculo.chocar()})
	}
	method iniciar(){
		obstaculo.iniciar()
		obstaculo2.iniciar()
	}
	method terminar(){
		game.addVisual(gameOver)
		obstaculo.detener()
		obstaculo2.detener()
		auto.chocar()
	}
}

object gameOver {
	method position() = game.center()
	method text() = "GAME OVER"
}

object decoracion {
	var position = self.posicionInicial()
	
	method posicionInicial() = game.at(6,1)
}

object obstaculo {
	var position = self.posicionInicial()

	method image() = "autoObstaculo.png"
	method position() = position
	method posicionInicial() = game.at(6,11)
	method iniciar(){
		position = self.posicionInicial()
		game.onTick(velocidad,"moverObstaculo",{self.mover()})
	}
	method mover(){
		position = position.down(1)
		if (position.y() == -1)
			position = self.posicionInicial()
	}
	method chocar(){
		juego.terminar()
	}
    method detener(){
		game.removeTickEvent("moverObstaculo")
	}
}

object obstaculo2 {
	var position = self.posicionInicial()

	method image() = "autoObstaculo.png"
	method position() = position
	method posicionInicial() = game.at(4,11)
	method iniciar(){
		position = self.posicionInicial()
		game.onTick(velocidad,"moverObstaculo",{self.mover()})
	}
	method mover(){
		position = position.down(1)
		if (position.y() == 6)
			position = position.left(1)
		if (position.y() == -1)
			position = self.posicionInicial()
	}
	method chocar(){
		juego.terminar()
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
	var vivo = true
	var property position = game.at(6,0)
	
	method estaVivo(){return vivo}
	method image() = "auto.png"
	method moveteDerecha(){self.position(self.position().right(1))}
	method moveteIzquierda(){self.position(self.position().left(1))}
	method chocar(){
		game.say(self,"¡Boom!")
		vivo = false
	}
}