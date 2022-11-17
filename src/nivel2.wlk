import auto.*
import wollok.game.*





//ESCENARIO 
object sueloNivel2{
	method position() = game.origin()
	method image() = "sueloNivel2.png"
}

object miniAutoNivel2 {
	var property position = self.positionInicial()
	
	method iniciar(){
		position = self.positionInicial()
		game.addVisual(self)
	}
	
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
//AUTO PROTAGONISTA
object autoNivel2 {
	var property vivo = true
	var property vidaRestantes = 50
	var property position = game.at(6,1)
	
	method iniciar(){
		game.addVisual(self)
		vivo= true
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

//LINEA DE META
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

	