package systems;

import echo.View;
import echo.System;
import nape.callbacks.CbEvent;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.space.Space;
import components.*;

/**
 * ...
 * @author https://github.com/wimcake
 */
class Gameplay extends System {


	var space:Space;
	var w:Float;
	var h:Float;
	var cx:Float;
	var cy:Float;


	public function new(space:Space, w:Float, h:Float) {
		this.w = w;
		this.h = h;
		this.space = space;
		cx = w * .5;
		cy = h * .5;
	}

	override public function onactivate() {
		space.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, Builder.Chicken, Builder.Monster, startInteract));
		space.listeners.add(new InteractionListener(CbEvent.END, InteractionType.COLLISION, Builder.Chicken, Builder.Monster, stopInteract));
	}

	function startInteract(cb:InteractionCallback) {
		var i1:Int = cb.int1.userData.id;
		var i2:Int = cb.int2.userData.id;
	}

	function stopInteract(cb:InteractionCallback) {
		var i1:Int = cb.int1.userData.id;
		var i2:Int = cb.int2.userData.id;
	}

	@u inline function play(dt:Float, b:Body, vel:Vel, s:Status) {
		vel.angle = Vec2.weak(cx - b.position.x, cy - b.position.y).angle + (Math.PI * .5);

		b.velocity.x = vel.x;
		b.velocity.y = vel.y;

		if (b.position.x > w) b.position.x -= w; else if (b.position.x < 0) b.position.x += w;
		if (b.position.y > h) b.position.y -= h; else if (b.position.y < 0) b.position.y += h;
	}

}
