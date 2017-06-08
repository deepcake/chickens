package spritesheet;

/**
 * ...
 * @author https://github.com/wimcake
 */
class Animation {


	var index:Int;
	var length:Int;

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
	}


	public function reset() {
		index = 0;
	}

	public function play() {
		playing = true;
	}

	public function pause() {
		playing = false;
	}

	public function stop() {
		index = 0;
		playing = false;
	}


	public inline function setSpeed(value:Int) {
		step = 1 / value;
	}

	public inline function getCurrentIndex():Int {
		return index;
	}

	public inline function getCurrentFrameData():SpriteSheetFrameData {
		return frames[index];
	}


	public function update(dt:Float) {
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

		}
	}

}
