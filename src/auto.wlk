import wollok.game.*

const velocidad = 250


object juego{ 
	
		
	const property obstaculos = []
	var property backgroundMusic = game.sound("soundtrack.mp3")
	
	method configurar(){
		game.title("Road Fighter")
		game.onTick(8000,"nuevoObstaculo",{self.generarObstaculo()})
		game.onTick(850,"nuevaDecoracion",{self.generarDecoracion()})
		game.onTick(3100,"nuevoObstaculoIzq",{self.generarObstaculoIzq()})
		game.onTick(3500,"nuevoObstaculoDer",{self.generarObstaculoDer()})
		game.onTick(10000,"nuevoCochePremio",{self.generarCochePremio()})
		game.width(13)
		game.height(12)
		game.addVisual(suelo)
		game.addVisual(auto)
		game.addVisual(vidas)
		game.addVisual(combustible)
		game.onTick(velocidad,"combustible",{combustible.gastarCombustible()})
		game.addVisual(miniMapa)
		game.addVisual(miniAuto)
		game.onTick(3000,"moverMiniAuto",{miniAuto.mover()})
		keyboard.left().onPressDo ({auto.moveteIzquierda()})	
		keyboard.right().onPressDo ({auto.moveteDerecha()})
		game.whenCollideDo(auto,{elemento => elemento.chocar()})
		backgroundMusic.shouldLoop(true)
	    game.schedule(500,{ backgroundMusic.play()} )
	}
	method terminar(){
		const sound = new Sound(file = "gameOverMusic.mp3")
	    backgroundMusic.pause()
	    sound.volume(0.5)
	    sound.play()
		game.addVisual(gameOver)
		obstaculos.forEach({o => o.detener()})
		game.removeTickEvent("combustible")
		game.removeTickEvent("moverMiniAuto")
		game.removeTickEvent("nuevoObstaculo")
		game.removeTickEvent("nuevaDecoracion")
		game.removeTickEvent("nuevoObstaculoIzq")
		game.removeTickEvent("nuevoObstaculoDer")
		game.removeTickEvent("nuevoCochePremio")
	}
	method ganar(){
		const sound = new Sound(file = "winMusic.mp3")
		backgroundMusic.pause()
		sound.volume(0.5)
		sound.play()
		game.addVisual(felicitaciones)
		obstaculos.forEach({o => o.detener()})
		game.removeTickEvent("combustible")
		game.removeTickEvent("moverMiniAuto")
		game.removeTickEvent("nuevoObstaculo")
		game.removeTickEvent("nuevaDecoracion")
		game.removeTickEvent("nuevoObstaculoIzq")
		game.removeTickEvent("nuevoObstaculoDer")
		game.removeTickEvent("nuevoCochePremio")
	}
	method generarObstaculo(){
		const obsta = new Obstaculo()
		obsta.iniciar()
		obstaculos.add(obsta)
	}
	method generarCochePremio(){
		const premio = new CochePremio()
		premio.iniciar()
		obstaculos.add(premio)
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
	
	method position() = game.at(2,4)
	method image() = "gameover.png"
}

object felicitaciones {
	method position() = game.at(3,5)
	method image() = "ganaste.png"
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

	method image() = "camion.png"
	method position() = position
	method posicionInicial() = game.at((2..9).anyOne(),11)
	method iniciar(){
		position = self.posicionInicial()
		game.addVisual(self)
		game.onTick(velocidad,"nuevoObstaculo",{self.mover()})
	}
	method mover(){
		position = position.down(1)
	
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
	}
}
		
class CochePremio inherits 	Obstaculo{
	

	override method image()="bonu.png"
	override method chocar(){
		
		auto.chocarPremio()
		vidas.actualizar()
		game.removeVisual(self)
		
			
	}}


class ObstaculoIzquierda inherits Obstaculo {
	override method image() = "autoObstaculo.png"
	override method posicionInicial() = game.at((3..9).anyOne(),11)
	override method mover(){
		position = position.down(1)
		if (position.y() == 7)
			position = position.left(1)
		if (position.y() == -1)
			self.sacar()
	}
}

class ObstaculoDerecha inherits Obstaculo {
	override method image() = "autoObstaculo.png"
	override method posicionInicial() = game.at((2..8).anyOne(),11)
	override method mover(){
		position = position.down(1)
		if (position.y() == 4)
			position = position.right(1)
		else if (position.y()==6)
			position = position.right(1)
		
		if (position.y() == -1)
			self.sacar()
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
	var property position = game.at(6,1)
	
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
		if(position == game.at(9,1)){}
		else{self.position(self.position().right(1))}
	}
	method moveteIzquierda(){
		if(position == game.at(2,1)){}
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
		
	}
}

object miniAuto {
	var property position = self.positionInicial()
	
	method image(){return "miniCar.png"}
	method mover(){
		position = position.up(1)
		if (position.y() == 10){meta.iniciar()}
	}
	method positionInicial(){return game.at(12,0)}
}

object vidas {
	var vidas = auto.vidaRestantes()
	
	method text() = "VIDA: " + vidas.toString()
	method position() = game.at(1, game.height()-1)
	method actualizar(){vidas = auto.vidaRestantes()}
}

object combustible {
	var combustible = 100
	
	method llenarCombustible(){combustible = 100}
	method text() = "COMBUSTIBLE: " + combustible.toString()
	method position() = game.at(1, game.height()-2)
	method gastarCombustible() {
		if(combustible <= 0){juego.terminar()}
		else{combustible = combustible - 1}
	}
}

object meta{
	var property position = self.positionInicial()
	
	method positionInicial(){return game.at(3,12)}
	method image(){return "meta.png"}
	method mover(){
		position = position.down(1)
		if (position.y() == 1){
			juego.ganar()
			game.removeTickEvent("moverMeta")
		}
	}
	method iniciar(){
		position = self.positionInicial()
		game.addVisual(self)
		game.onTick(velocidad,"moverMeta",{self.mover()})
	}
	method chocar(){}
}
