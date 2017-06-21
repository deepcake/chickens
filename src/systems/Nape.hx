package systems;

import echo.View;
import echo.System;
import nape.phys.Body;
import nape.space.Space;

import Log;

/**
 * ...
 * @author https://github.com/wimcake
 */
class Nape extends System {


	var space:Space;
	var view:View<{ b:Body }>;


	public function new(space:Space) {
		this.space = space;
		space.gravity.setxy(.0, .0);
		space.worldLinearDrag = 8;
		space.worldAngularDrag = 32;
	}

	override function ondeactivate() {
		space.clear();
	}

	@a inline function ad(id:Int, b:Body) {
		b.userData.id = id;
		space.bodies.add(b);
	}

	@r inline function rm(id:Int, b:Body) {
		b.userData.id = null;
		space.bodies.remove(b);
	}

	@u public function step(dt:Float) {
		space.step(dt);
		Log.track('bodies', space.bodies.length);
	}

}
