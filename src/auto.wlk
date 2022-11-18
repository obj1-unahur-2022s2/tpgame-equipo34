import wollok.game.*
import juego.*
import nivel2.*
const velocidad = 250


object juego{ 
	//MUSICA DE FONDO
	var property backgroundMusic = game.sound("soundtrack.mp3")
	
	//TAMAÑO DEL GAME 
	method configurar0(){
		game.width(13)
		game.height(12)
		//IMAGEN MENU
		game.addVisual(menu)
		//TECLADO
		keyboard.enter().onPressDo{self.configurar1()}
		}
	method configurar1(){
		const rangoDerPista = 9
		const rangoIzqPista = 2
		const imagenDecoracion = "arboldecoracion.png"
		const unbicacionDecoracion = 0
		//EVENTOS AUTOMATICOS
		game.title("Road Fighter")
		game.onTick(8000,"nuevoObstaculo",{self.generarObstaculo(rangoDerPista, rangoIzqPista)})
		game.onTick(850,"nuevaDecoracion",{self.generarDecoracion(unbicacionDecoracion, imagenDecoracion)})
		game.onTick(3100,"nuevoObstaculoIzq",{self.generarObstaculoIzq(rangoDerPista, rangoIzqPista)})
		game.onTick(3500,"nuevoObstaculoDer",{self.generarObstaculoDer(rangoDerPista, rangoIzqPista)})
		game.onTick(10000,"nuevoCochePremio",{self.generarCochePremio(rangoDerPista, rangoIzqPista)})
		game.onTick(3000,"moverMiniAuto",{miniAuto.mover()})
		//VISUALES
		game.addVisual(suelo)
		const auto = new Auto(derecha = rangoDerPista, izquierda = rangoIzqPista)
		auto.iniciar()
		vidas.iniciar()
		combustible.iniciar()
		game.onTick(velocidad,"combustible",{combustible.gastarCombustible()})
		game.addVisual(miniMapa)
		miniAuto.iniciar()
		//TECLADO
		keyboard.left().onPressDo ({auto.moveteIzquierda()})	
		keyboard.right().onPressDo ({auto.moveteDerecha()})
		//COLISION
		game.whenCollideDo(auto,{elemento => elemento.chocar(auto)})
		//ACTIVAR MUSICA
		backgroundMusic.shouldLoop(true)
	    game.schedule(500,{ backgroundMusic.play()} )
	}
	
	method configurar2(){
		const rangoDerPista = 7
		const rangoIzqPista = 5
		const imagenDecoracion = "decoracionNivel2Palmera.png"
		const unbicacionDecoracion = 9
		// EVENTOS AUTOMATICOS
		game.title("Road Fighter")
		game.onTick(8000,"nuevoObstaculo",{self.generarObstaculo(rangoDerPista, rangoIzqPista)})
		game.onTick(850,"nuevaDecoracion",{self.generarDecoracion(unbicacionDecoracion,imagenDecoracion)})
		game.onTick(3100,"nuevoObstaculoIzq",{self.generarObstaculoIzq(rangoDerPista, rangoIzqPista)})
		game.onTick(3500,"nuevoObstaculoDer",{self.generarObstaculoDer(rangoDerPista, rangoIzqPista)})
		game.onTick(10000,"nuevoCochePremio",{self.generarCochePremio(rangoDerPista, rangoIzqPista)})
		game.onTick(velocidad,"combustible",{combustible.gastarCombustible()})
		game.onTick(3000,"miniAutoNivelFinal",{miniAuto.mover()})
		//VISUALES
		game.addVisual(sueloNivel2)
		const auto = new Auto(derecha = rangoDerPista, izquierda = rangoIzqPista)
		auto.iniciar()
		game.addVisual(vidas)
		game.addVisual(combustible)
		game.addVisual(miniMapa)
		miniAutoNivelFinal.iniciar()
		//TECLADO
		keyboard.left().onPressDo ({auto.moveteIzquierda()})	
		keyboard.right().onPressDo ({auto.moveteDerecha()})
		//COLISION
		game.whenCollideDo(auto,{elemento => elemento.chocar(auto)})
		//ACTIVAR MUSICA
		backgroundMusic.shouldLoop(true)
	    game.schedule(500,{ backgroundMusic.play()} )
	}
	method terminar(){
		//LIMPIAR 
		game.clear()
		//DETENER MUSICA FONDO E INICIAR MUSICA "GAMEOVER"
		const sound = new Sound(file = "gameOverMusic.mp3")
	    backgroundMusic.stop()
	    //backgroundMusic2.stop()
	    sound.volume(0.5)
	    sound.play()
	    game.addVisual(gameOver)
	    //SALIR
	    keyboard.s().onPressDo{
	    	sound.stop()
	    	backgroundMusic = game.sound("soundtrack.mp3")
	    	self.configurar0()
	    }
	}
	method pasarNivel(){
		//LIMPIAR Y DETENER MUSICA
		game.clear()
		//IMAGEN NIVEL 2 Y MUSICA PLAY
		const sound = new Sound(file = "winMusic.mp3")
		backgroundMusic.stop()
		sound.volume(0.5)
		sound.play()
		game.addVisual(siguienteNivel)
		//PRESIONAR I PARA INICIAR NIVEL 2
		keyboard.i().onPressDo {
			sound.stop()
			backgroundMusic = game.sound("soundtrack.mp3")
			self.configurar2()
		}
	}
	method ganar(){
		//LIMPIAR, DETENER MUSICA FONDO E INICIAR MUSICA "WIN"
		game.clear()
		const sound = new Sound(file = "winMusic.mp3")
		backgroundMusic.stop()
		sound.volume(0.5)
		sound.play()
		game.addVisual(felicitaciones)
		 keyboard.s().onPressDo{
	    	sound.stop()
	    	backgroundMusic = game.sound("soundtrack.mp3")
	    	self.configurar0()
	    }
	}
	//CREAR OBSTACULOS NIVEL 1
	method generarObstaculo(rangoDerPista, rangoIzqPista){
		const obsta = new Obstaculo(derecha = rangoDerPista, izquierda = rangoIzqPista)
		obsta.iniciar()
	}
	method generarCochePremio(rangoDerPista, rangoIzqPista){
		const premio = new CochePremio(derecha = rangoDerPista, izquierda = rangoIzqPista)
		premio.iniciar()
	}
	method generarDecoracion(ubicacion, imagenDecoracion){
		const deco = new Decoracion(ubicacionDecoracion = ubicacion, imagen = imagenDecoracion)
		deco.iniciar()
	}
	method generarObstaculoIzq(rangoDerPista, rangoIzqPista){
		const obstaIzq = new ObstaculoIzquierda(derecha = rangoDerPista, izquierda = rangoIzqPista)
		obstaIzq.iniciar()
	}
	method generarObstaculoDer(rangoDerPista, rangoIzqPista){
		const obstaDer = new ObstaculoDerecha(derecha = rangoDerPista, izquierda = rangoIzqPista)
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
	method position()=game.at(0,-3)
	method image() = "nivel2.png"
}

class Decoracion {
	var property ubicacionDecoracion
	var property imagen
	var position = self.posicionInicial()
	
	method image() = imagen
	method position() = position
	method posicionInicial() = game.at(ubicacionDecoracion,11)
	method iniciar(){
		position = self.posicionInicial()
		game.addVisual(self)
		game.onTick(velocidad/2,"moverDecoracion",{self.mover()})
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
	var derecha
	var izquierda
	var position = self.posicionInicial()

	method image() = "camion.png"
	method position() = position
	method posicionInicial() = game.at((izquierda..derecha).anyOne(),11)
	method iniciar(){
		position = self.posicionInicial()
		game.addVisual(self)
		game.onTick(velocidad,"nuevoObstaculo",{self.mover()})
	}
	method mover(){position = position.down(1)}
	method chocar(auto){
		auto.chocar(auto)
		vidas.actualizar(auto)
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
	override method chocar(auto){
		auto.chocarPremio()
		vidas.actualizar(auto)
		game.removeVisual(self)		
	}
}

class ObstaculoIzquierda inherits Obstaculo {
	override method image() = "autoObstaculo.png"
	override method mover(){
		position = position.down(1)
		if (position.y() == 5 and position.x() != izquierda)
			position = position.left(1)
		if (position.y() == -1)
			self.sacar()
	}
}

class ObstaculoDerecha inherits Obstaculo {
	override method image() = "autoObstaculo.png"
	override method mover(){
		position = position.down(1)
		if (position.y() == 4 and position.x() != derecha )
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
object miniMapa{
	method position() = game.at(12,0)
	method image() = "miniMapa.png"
}
class Auto {
	var derecha
	var izquierda
	var property vivo = true
	var property vidaRestantes = 50
	var property position = game.at(6,1)
	
	method iniciar(){
		game.addVisual(self)
		vivo = true
		vidaRestantes = 50
		position = game.at(6,1)
	}
	method estaVivo(){
		if(vidaRestantes <= 0){vivo = false}
		else{vivo = true}
		return vivo
	}
	method image(){return "auto.png"}
	method moveteDerecha(){
		if(position == game.at(derecha,1)){}
		else{self.position(self.position().right(1))}
	}
	method moveteIzquierda(){
		if(position == game.at(izquierda,1)){}
		else{self.position(self.position().left(1))}
	}
	method chocar(auto){
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
	var property position= self.positionInicial() 
	
	method iniciar(){
		position = self.positionInicial() 
		game.addVisual(self)
	}
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

object miniAutoNivelFinal {
	var property position = self.positionInicial()
	
	method iniciar(){
		position = self.positionInicial()
		game.addVisual(self)
	}
	method image(){return "miniCar.png"}
	method mover(){
		position = position.up(1)
		if (position.y() == 10){metaNivelFinal.iniciar()}
		if (position.y() == 11){self.sacar()}
	}
	method positionInicial(){return game.at(12,0)}
	method sacar(){
		game.removeVisual(self)
	}
}

object vidas {
	var vidas 
	
	method iniciar(){
		vidas = 50
		game.addVisual(self)
	}
	method text() = "VIDA: " + vidas.toString()
	method position() = game.at(1, game.height()-1)
	method actualizar(auto){vidas = auto.vidaRestantes()}
}

object combustible {
	var combustible = 100
	
	method iniciar(){
		combustible = 100
		game.addVisual(self)
	}
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
}

object metaNivelFinal{
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

