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


	var view:View<{ b:Body, vel:Vel, s:Status }>;
	var space:Space;
	var w:Float;
	var h:Float;


	public function new(space:Space, ?w:Float, ?h:Float) {
		this.w = w;
		this.h = h;
		this.space = space;
	}

	override public function onactivate() {
		space.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, Builder.Chicken, Builder.Monster, startInteract));
		space.listeners.add(new InteractionListener(CbEvent.END, InteractionType.COLLISION, Builder.Chicken, Builder.Monster, stopInteract));
	}

	function startInteract(cb:InteractionCallback) {
		var i1:Int = cb.int1.userData.id;
		var i2:Int = cb.int2.userData.id;

		if (echo.hasComponent(i1, Status)) echo.getComponent(i1, Status).interactingBodies.push(i2);
		if (echo.hasComponent(i2, Status)) echo.getComponent(i2, Status).interactingBodies.push(i1);
	}

	function stopInteract(cb:InteractionCallback) {
		var i1:Int = cb.int1.userData.id;
		var i2:Int = cb.int2.userData.id;

		if (echo.hasComponent(i1, Status)) echo.getComponent(i1, Status).interactingBodies.remove(i2);
		if (echo.hasComponent(i2, Status)) echo.getComponent(i2, Status).interactingBodies.remove(i1);
	}

	override public function update(dt:Float) {
		for (v in view) {
			v.b.velocity.x = v.vel.x;
			v.b.velocity.y = v.vel.y;

			

			if (v.b.position.x > w) v.b.position.x -= w; else if (v.b.position.x < 0) v.b.position.x += w;
			if (v.b.position.y > h) v.b.position.y -= h; else if (v.b.position.y < 0) v.b.position.y += h;
		}
	}

}
