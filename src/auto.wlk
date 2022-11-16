import wollok.game.*
import juego.*
const velocidad = 250


object juego{ 
	var property backgroundMusic = game.sound("soundtrack.mp3")
	var property backgroundMusic2 = game.sound("musicaNivel2.mp3")
	
	method configurar0(){
		game.width(13)
		game.height(12)
		game.addVisual(menu)
		keyboard.enter().onPressDo{self.configurar1()}
		}
	method configurar1(){
		game.title("Road Fighter")
		game.onTick(8000,"nuevoObstaculo",{self.generarObstaculo()})
		game.onTick(850,"nuevaDecoracion",{self.generarDecoracion()})
		game.onTick(3100,"nuevoObstaculoIzq",{self.generarObstaculoIzq()})
		game.onTick(3500,"nuevoObstaculoDer",{self.generarObstaculoDer()})
		game.onTick(10000,"nuevoCochePremio",{self.generarCochePremio()})
		
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
	
	method configurar2(){
		
		game.title("Road Fighter")
		game.onTick(8000,"nuevoObstaculo",{self.generarObstaculoNivel2()})
		game.onTick(850,"nuevaDecoracion",{self.generarDecoracionNivel2()})
		game.onTick(3100,"nuevoObstaculoIzq",{self.generarObstaculoIzqNivel2()})
		game.onTick(3500,"nuevoObstaculoDer",{self.generarObstaculoDerNivel2()})
		game.onTick(10000,"nuevoCochePremio",{self.generarCochePremioNivel2()})
		
		game.addVisual(sueloNivel2)
		game.addVisual(autoNivel2)
		game.addVisual(vidas)
		game.addVisual(combustible)
		game.onTick(velocidad,"combustible",{combustible.gastarCombustible()})
		game.addVisual(miniMapa)
		game.addVisual(miniAutoNivel2)
		game.onTick(3000,"moverMiniAuto",{miniAutoNivel2.mover()})
		keyboard.left().onPressDo ({autoNivel2.moveteIzquierda()})	
		keyboard.right().onPressDo ({autoNivel2.moveteDerecha()})
		game.whenCollideDo(autoNivel2,{elemento => elemento.chocar()})
		backgroundMusic2.shouldLoop(true)
	    game.schedule(500,{ backgroundMusic2.play()} )
	}
	
	
	method terminar(){
		game.clear()
		const sound = new Sound(file = "gameOverMusic.mp3")
	    backgroundMusic.pause()
	    sound.volume(0.5)
	    sound.play()
	    game.addVisual(gameOver)
	    keyboard.s().onPressDo{
	    	sound.pause()
	    	game.clear()
	    }
	}
	method pasarNivel(){
		game.clear()
		backgroundMusic.pause()
		const sound = new Sound(file = "winMusic.mp3")
		sound.volume(0.5)
		sound.play()
		game.addVisual(siguienteNivel)
		keyboard.i().onPressDo {
			sound.pause()
			self.configurar2()
		}
	}
	method ganar(){
		game.clear()
		backgroundMusic2.pause()
		const sound = new Sound(file = "winMusic.mp3")
		sound.volume(0.5)
		sound.play()
		game.addVisual(felicitaciones)
	}
	method generarObstaculo(){
		const obsta = new Obstaculo()
		obsta.iniciar()
	}
	method generarObstaculoNivel2(){
		const obsta = new ObstaculoNivel2()
		obsta.iniciar()
	}
	method generarCochePremio(){
		const premio = new CochePremio()
		premio.iniciar()
	}
	method generarCochePremioNivel2(){
		const premio = new CochePremioNivel2()
		premio.iniciar()
	}
	method generarDecoracion(){
		const deco = new Decoracion()
		deco.iniciar()
	}
	method generarDecoracionNivel2(){
		const deco = new DecoracionNivel2()
		deco.iniciar()
	}
	method generarObstaculoIzq(){
		const obstaIzq = new ObstaculoIzquierda()
		obstaIzq.iniciar()
	}
	method generarObstaculoIzqNivel2(){
		const obstaIzq = new ObstaculoIzquierdaNivel2()
		obstaIzq.iniciar()
	}
	method generarObstaculoDer(){
		const obstaDer = new ObstaculoDerecha()
		obstaDer.iniciar()
	}
	method generarObstaculoDerNivel2(){
		const obstaDer = new ObstaculoDerechaNivel2()
		obstaDer.iniciar()
	}
}


object gameOver {
	
	method position() = game.at(-4,0)
	method image() = "gameOverScreen.png"
}

object felicitaciones {
	method position()=game.at(-4,0)
	method image() = "winScreen.png"
}

object siguienteNivel {
	method position()=game.at(0,0)
	method image() = "nivel2.png"
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

class DecoracionNivel2 inherits Decoracion {
	
	override method image() = "decoracionNivel2Palmera.png"
	override method posicionInicial() = game.at(9,11)
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
	}
}

class ObstaculoIzquierda inherits Obstaculo {
	override method image() = "autoObstaculo.png"
	override method posicionInicial() = game.at((3..9).anyOne(),11)
	override method mover(){
		position = position.down(1)
		if (position.y() == 5)
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
		if (position.y() == 4 and position.x() <9)
			position = position.right(1)
		else if (position.y()==5)
			position = position.right(1)
		
		if (position.y() == -1)
			self.sacar()
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
		if (position.y() == -1)
			self.sacar()
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
		
		if (position.y() == -1)
			self.sacar()
	}
}

object menu {
	method position()=game.at(-3,0)
	method image()="fondoMenu.jpg"
}
object suelo{
	method position() = game.origin()
	method image() = "suelo.png"
}

object sueloNivel2{
	method position() = game.origin()
	method image() = "sueloNivel2.png"
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
	method image(){return "auto.png"}
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
		const sound = new Sound(file = "cargaCombustible.mp3")
		sound.volume(1)
		sound.play()
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

object miniAuto {
	var property position = self.positionInicial()
	
	method image(){return "miniCar.png"}
	method mover(){
		position = position.up(1)
		if (position.y() == 10){meta.iniciar()}
		if (position.y() == 11){self.sacar()}
	}
	method positionInicial(){return game.at(12,0)}
	method sacar(){
		game.removeVisual(self)
	}
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
			juego.pasarNivel()
		}
	}
	method iniciar(){
		position = self.positionInicial()
		game.addVisual(self)
		game.onTick(velocidad,"moverMeta",{self.mover()})
	}
	method chocar(){}
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
	method chocar(){}
}
