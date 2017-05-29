package luxe.components;

import spritesheet.SpriteSheetFrameData;

/**
 * ...
 * @author https://github.com/wimcake
 */
class Animation extends Frame {


	public var index:Int;
	public var length:Int;

	var time:Float;
	var step:Float;

	public var loop:Bool;
	public var playing:Bool;

	var frames:Array<SpriteSheetFrameData>;


	public function new(frames:Array<SpriteSheetFrameData>, speed:Int, loop:Bool = true, play:Bool = true) {
		index = 0;
		length = frames.length;

		time = .0;
		step = 1 / speed;

		this.loop = loop;
		this.playing = play;

		this.frames = frames;

		super(frames[index]);
		//this.name = 'animation';
	}


	public function reset() {
		index = 0;
		playing = true;
	}

	public function play() {
		playing = true;
	}

	public function stop() {
		playing = false;
	}


	public function speed(value:Int) {
		step = 1 / value;
	}


	override public function update(dt:Float) {
		if (playing) {

			time += dt;

			while (time >= step) {

				time -= step;

				if (++index >= length) {

					if (loop) {
						index = 0;
					} else {
						index = length - 1;
						playing = false;
						break;
					}

				}

			}

			if (frame != frames[index]) {

				frame = frames[index];
				refreshSprite();

			}

		}
	}

}
