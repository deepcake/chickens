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

	@a function add(id:Int) {
		var b = echo.getComponent(id, Body);
		b.userData.id = id;
		space.bodies.add(b);
	}

	@r function rem(id:Int) {
		var b = echo.getComponent(id, Body);
		b.userData.id = null;
		space.bodies.remove(b);
	}

	override public function update(dt:Float) {

		Log.track('bodies', space.bodies.length);

	}

}
