package systems;

import echo.View;
import echo.System;
import nape.phys.Body;

/**
 * ...
 * @author https://github.com/wimcake
 */
class Render extends System {


	#if luxe
	@r inline function remove_sprite(s:luxe.Sprite) {
		s.destroy();
	}

	@u function render(b:Body, s:luxe.Sprite) {
		if (s.flipx && b.velocity.x > 0) s.flipx = false;
		if (!s.flipx && b.velocity.x < 0) s.flipx = true;

		s.pos.x = b.position.x;
		s.pos.y = b.position.y;

		if (Std.int(b.position.y) != Std.int(s.depth)) s.depth = b.position.y;
	}
	#end

	


}
