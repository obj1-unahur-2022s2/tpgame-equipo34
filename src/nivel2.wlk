import auto.*
import wollok.game.*

class DecoracionNivel2 inherits Decoracion {
	
	override method image() = "decoracionNivel2Palmera.png"
	override method posicionInicial() = game.at(9,11)
		override method mover(){
		position = position.down(1)
		if (position.y() == -3)
			game.removeVisual(self)
	}
}

class ObstaculoNivel2 inherits Obstaculo {
	override method posicionInicial() = game.at((5..7).anyOne(),11)
}

class CochePremioNivel2 inherits Obstaculo{
	override method posicionInicial() = game.at((5..7).anyOne(),11)
	override method image()="bonu.png"
	override method chocar(){
		auto.chocarPremio()
		vidas.actualizar()
		game.removeVisual(self)		
	}
}

class ObstaculoIzquierdaNivel2 inherits Obstaculo {
	
	override method image() = "autoObstaculo.png"
	override method posicionInicial() = game.at((6..7).anyOne(),11)
	override method mover(){
		position = position.down(1)
		if (position.y() == 5)
			position = position.left(1)
		
	}
}

class ObstaculoDerechaNivel2 inherits Obstaculo {
	override method image() = "autoObstaculo.png"
	override method posicionInicial() = game.at((5..6).anyOne(),11)
	override method mover(){
		position = position.down(1)
		 if (position.y() == 4 and position.x() <7)
			position = position.right(1)
		else if (position.y()==5)
			position = position.right(1)

	}
//CREAR OBSTACULOS NIVEL 2
	method generarObstaculoDerNivel2(){
		const obstaDer = new ObstaculoDerechaNivel2()
		obstaDer.iniciar()
	}
		method generarObstaculoNivel2(){
		const obsta = new ObstaculoNivel2()
		obsta.iniciar()
	}
		method generarObstaculoIzqNivel2(){
		const obstaIzq = new ObstaculoIzquierdaNivel2()
		obstaIzq.iniciar()
	}
		method generarDecoracionNivel2(){
		const deco = new DecoracionNivel2()
		deco.iniciar()
	}
		method generarCochePremioNivel2(){
		const premio = new CochePremioNivel2()
		premio.iniciar()
	}
}

object sueloNivel2{
	method position() = game.origin()
	method image() = "sueloNivel2.png"
}

object miniAutoNivel2 {
	var property position = self.positionInicial()
	
	method image(){return "miniCar.png"}
	method mover(){
		position = position.up(1)
		if (position.y() == 10){metaNivel2.iniciar()}
		if (position.y() == 11){self.sacar()}
	}
	method positionInicial(){return game.at(12,0)}
	method sacar(){
		game.removeVisual(self)
	}
}

object autoNivel2 {
	var property vivo = true
	var property vidaRestantes = 50
	var property position = game.at(6,1)
	
	method estaVivo(){
		if(vidaRestantes <= 0){vivo = false}
		else{vivo = true}
		return vivo
	}
	method image(){return "auto.png"}
	method moveteDerecha(){
		if(position == game.at(7,1)){}
		else{self.position(self.position().right(1))}
	}
	method moveteIzquierda(){
		if(position == game.at(5,1)){}
		else{self.position(self.position().left(1))}
	}
	method chocar(){
		const sound = new Sound(file = "explosion.mp3")
		sound.volume(0.5)
		sound.play()
		vidaRestantes = vidaRestantes - 1
	}
	method chocarPremio(){
		combustible.llenarCombustible()
		const sound = new Sound(file = "cargaCombustible.mp3")
		sound.volume(1)
		sound.play()
	}
}

	
object metaNivel2{
	var property position = self.positionInicial()
	
	method positionInicial(){return game.at(5,12)}
	method image(){return "meta2.png"}
	method mover(){
		position = position.down(1)
		if (position.y() == 1){
			juego.ganar()
		}
	}
	method iniciar(){
		position = self.positionInicial()
		game.addVisual(self)
		game.onTick(velocidad,"moverMeta",{self.mover()})
	}
}

	