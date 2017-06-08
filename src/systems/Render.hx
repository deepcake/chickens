package systems;

import echo.View;
import echo.System;
import luxe.Sprite;
import nape.phys.Body;

/**
 * ...
 * @author https://github.com/wimcake
 */
class Render extends System {


	var view:View<{ b:Body, s:Sprite }>;


	@r function remove_sprite(id:Int) {
		echo.getComponent(id, Sprite).destroy();
	}

	override public function update(dt:Float) {
		for (v in view) {

			if (v.s.flipx && v.b.velocity.x > 0) v.s.flipx = false;
			else if (!v.s.flipx && v.b.velocity.x < 0) v.s.flipx = true;

			v.s.pos.x = v.b.position.x;
			v.s.pos.y = v.b.position.y;

			if (Std.int(v.b.position.y) != Std.int(v.s.depth)) v.s.depth = v.b.position.y;

		}
	}

}
