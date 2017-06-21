package luxe.components;

import spritesheet.SpriteSheetFrameData;
import luxe.Component;
import luxe.Rectangle;
import luxe.Sprite;

/**
 * ...
 * @author https://github.com/wimcake
 */
class Frame extends Component {


	public var frame:SpriteSheetFrameData;

	var sprite:Sprite;
	var uvcache:Rectangle = new Rectangle();


	public function new(frame:SpriteSheetFrameData) {
		this.frame = frame;

		super();
		//this.name = 'frame';
	}


	override public function onadded() {
		sprite = cast entity;
		//refreshSprite();
	}

	override public function init() {
		refreshSprite();
	}

	inline function refreshSprite() {
		//cache the uv so we don't allocate for no good reason
		uvcache.set( frame.x, frame.y, frame.w, frame.h );

		//ratio of scale between sprite size and frame size
		var _ratio_x = frame.sw / sprite.size.x;
		var _ratio_y = frame.sh / sprite.size.y;

		//resize the sprite non destructively, to fit the new frame size
		sprite.geometry.transform.scale.x = (frame.w / frame.sw) * sprite.scale.x;
		sprite.geometry.transform.scale.y = (frame.h / frame.sh) * sprite.scale.y;

		//var _pos_x = sprite.flipx ? frame.sw - frame.sx - frame.w : frame.sx;
		//var _pos_y = sprite.flipy ? frame.sh - frame.sy - frame.h : frame.sy;
		//var _pos_x = sprite.flipx ? sprite.origin.x + (sprite.origin.x - frame.sx - frame.w) : frame.sx;
		//var _pos_y = sprite.flipy ? sprite.origin.y + (sprite.origin.y - frame.sy - frame.h) : frame.sy;

		var _pos_x = sprite.flipx ? sprite.origin.x * _ratio_x + (sprite.origin.x * _ratio_x - frame.sx - frame.w) : frame.sx; // oh you
		var _pos_y = sprite.flipy ? sprite.origin.y * _ratio_y + (sprite.origin.y * _ratio_y - frame.sy - frame.h) : frame.sy;

		//realign the sprite to match the new frame size, but also adjust for the new scale! otherwise it won't match
		sprite.geometry.transform.origin.x = -((_pos_x / _ratio_x) * sprite.scale.x) / sprite.geometry.transform.scale.x;
		sprite.geometry.transform.origin.y = -((_pos_y / _ratio_y) * sprite.scale.y) / sprite.geometry.transform.scale.y;

		//and finally assign it to the sprite
		sprite.uv = uvcache;
	}

}
