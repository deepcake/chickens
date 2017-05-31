package;

import luxe.Color;
import luxe.Input.Key;
import luxe.Input.KeyEvent;
import luxe.Input.MouseButton;
import luxe.Input.MouseEvent;
import luxe.Input.TouchEvent;
import luxe.Sprite;
import luxe.States.State;
import luxe.Vector;
import luxe.tween.Actuate;
import luxe.Ev;
import echo.systems.*;
import luxe.systems.*;

using Log;
using Lambda;

/**
 * ...
 * @author https://github.com/wimcake
 */
class Game extends State {


	var CHICKENS_COUNT = 100;
	var MONSTERS_COUNT = 20;


	public function new() super( { name: 'game' } );


	inline function range(start:Float, end:Float) return start + (end - start) * Math.random();
	inline function grange(start:Float, end:Float, count:Int = 3) return [ for (i in 0...count) range(start, end) ].fold(function(sum, el) return sum + el, .0) / count;

	function build() {
		for (i in 0...MONSTERS_COUNT) Builder.monster(range(Luxe.screen.width, Luxe.screen.width * .75), grange(Luxe.screen.height * .2, Luxe.screen.height * .8), -range(40, 60), 0);
		for (i in 0...CHICKENS_COUNT) Builder.chicken(range(0, Luxe.screen.width * .25), grange(Luxe.screen.height * .2, Luxe.screen.height * .8), range(50, 70), 0);
	}


	override public function init() {
		Builder.initialize();
	}

	override public function onenter(_) {
		Builder.echo.addSystem(new Nape(Luxe.physics.nape.space));
		Builder.echo.addSystem(new Gameplay(Luxe.physics.nape.space));
		Builder.echo.addSystem(new Render());
		//Builder.echo.addSystem(new NapeImmediateDrawer());
		Builder.echo.addSystem(new Destroyer());

		Luxe.on(Ev.update, Builder.echo.update);
		build();
	}

	override public function onleave(_) {
		Luxe.off(Ev.update, Builder.echo.update);
		Builder.echo.systems.iter(function(s) Builder.echo.removeSystem(s));
		Builder.echo.views.iter(function(v) Builder.echo.removeView(v));
		Builder.echo.entities.iter(function(i) Builder.echo.remove(i));
	}

	override public function ontouchdown(e:TouchEvent) {
		Log.log('touch x: ' + e.x + ', y: ' + e.y);
	}

	override public function onmousedown(e:MouseEvent) {
		Log.log('click x: ' + e.x + ', y: ' + e.y);
	}

	override public function onmouseup(e:MouseEvent) {
		switch(e.button) {
			case MouseButton.left:
			case MouseButton.right:
			default:
		}
	}


	override function onkeyup(e:KeyEvent) {
		switch(e.keycode) {
			case Key.key_r: 
				Builder.echo.entities.iter(function(i) Builder.echo.remove(i));
				build();

			case Key.key_q:
				for (i in 0...10) Builder.chicken(range(0, Luxe.screen.width * .25), grange(Luxe.screen.height * .2, Luxe.screen.height * .8), range(50, 70), 0);

			case Key.key_a:
				for (i in 0...10) if (Builder.echo.entities.last() != null) Builder.echo.remove(Builder.echo.entities.first());

			case Key.key_d:
				if (Builder.echo.hasSystem(NapeImmediateDrawer)) Builder.echo.removeSystem(Builder.echo.getSystem(NapeImmediateDrawer));
				else Builder.echo.addSystem(new NapeImmediateDrawer());

			case Key.escape: 
				Luxe.shutdown();

			default:
		}
	}

	override function update(dt:Float) {
		Log.track('echo', '${Builder.echo}');
	}

}
