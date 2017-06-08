package luxe.components;

import spritesheet.SpriteSheetFrameData;

/**
 * ...
 * @author https://github.com/wimcake
 */
class Animation extends Frame {


	var anim:spritesheet.Animation;
	var index:Int;


	public function new(frames:Array<SpriteSheetFrameData>, speed:Int, loop:Bool = true, play:Bool = true) {
		anim = new spritesheet.Animation(frames, speed, loop, play);
		index = 0;

		super(anim.getCurrentFrameData());
		//this.name = 'animation';
	}

	override public function update(dt:Float) {
		anim.update(dt);
		if (index != anim.getCurrentIndex()) {
			frame = anim.getCurrentFrameData();
			index = anim.getCurrentIndex();
			refreshSprite();
		}
	}

}
