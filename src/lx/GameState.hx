package lx;

import luxe.Color;
import luxe.Input.Key;
import luxe.Input.KeyEvent;
import luxe.Input.MouseButton;
import luxe.Input.MouseEvent;
import luxe.Input.TouchEvent;
import luxe.States.State;
import luxe.Text;
import systems.*;

using Log;
using Lambda;

/**
 * ...
 * @author https://github.com/wimcake
 */
class GameState extends State {


	var CHICKENS_COUNT = 64;
	var MONSTERS_COUNT = 8;

	var info_text:Text;


	public function new() super( { name: 'game' } );

	// uniform
	inline function urange(start:Float, end:Float) return start + (end - start) * Math.random();
	// normal
	inline function nrange(start:Float, end:Float, power:Int = 3) return [ for (i in 0...power) urange(start, end) ].fold(function(sum, el) return sum + el, .0) / power;

	function build() {
		add_monster(MONSTERS_COUNT);
		add_chicken(CHICKENS_COUNT);
	}

	function add_monster(count:Int) {
		for (i in 0...count) Builder.monster(nrange(0, Luxe.screen.width), nrange(0, Luxe.screen.height), urange(40, 60), 0);
	}

	function add_chicken(count:Int) {
		for (i in 0...count) Builder.chicken(nrange(0, Luxe.screen.width), nrange(0, Luxe.screen.height), urange(70, 150), 0);
	}

	function remove_chicken(count:Int) {
		for (i in 0...count) if (Builder.echo.entities.last() != null) Builder.echo.remove(Builder.echo.entities.last());
	}

	override function init() {
		var size = 14 * Luxe.screen.device_pixel_ratio;
		info_text = new lx.utils.LogText(true, false, size, new Color().rgb(Std.random(0xffffff)));
		info_text.text = '[R] to reload scene\n[Q/A][right/left tap] to add/remove chicken\n[D] to enable/disable debug nape draw';
	}

	override public function onenter(_) {
		Builder.echo.addSystem(new Nape(Builder.nape.space));
		Builder.echo.addSystem(new Gameplay(Builder.nape.space, Luxe.screen.width, Luxe.screen.height));
		Builder.echo.addSystem(new Render());
		//Builder.echo.addSystem(new NapeDebugDraw());
		Builder.echo.addSystem(new Destroy());

		build();

		if (info_text.scene == null) Luxe.scene.add(info_text);
	}

	override public function onleave(_) {
		Builder.echo.systems.iter(function(s) Builder.echo.removeSystem(s));
		Builder.echo.views.iter(function(v) Builder.echo.removeView(v));
		Builder.echo.entities.iter(function(i) Builder.echo.remove(i));

		info_text.scene.remove(info_text);
	}

	override public function ontouchdown(e:TouchEvent) {
		Log.log('touch x: ' + e.x + ', y: ' + e.y);
		if (e.x > .5) add_chicken(8); else remove_chicken(8);
	}

	override public function onmousedown(e:MouseEvent) {
		Log.log('click x: ' + e.x + ', y: ' + e.y);
		if (e.x > Luxe.screen.mid.x) add_chicken(8); else remove_chicken(8);
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
				add_chicken(8);

			case Key.key_a:
				remove_chicken(8);

			case Key.key_d:
				if (Builder.echo.hasSystem(NapeDebugDraw)) Builder.echo.removeSystem(Builder.echo.getSystem(NapeDebugDraw));
				else Builder.echo.addSystem(new NapeDebugDraw());

			//case Key.escape: 
			//	Luxe.shutdown();

			default:
		}
	}

	override function update(dt:Float) {
		Builder.echo.update(dt);
		Log.track('echo', '${Builder.echo}');
	}

}
