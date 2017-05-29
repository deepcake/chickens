package spritesheet;

import haxe.Json;
import haxe.xml.Fast;

/**
 * ...
 * @author https://github.com/wimcake
 */
class SpriteSheet {


	/**
	 *  /(NAME)(SERIAL_NUMBER)/
	 */
	static public var DEFAULT_NAME_EXTRACTOR = ~/([^0-9.]+)(\d*)(?:[\D]*)/i;


	/**
	 *  @param xml
	 *  <TextureAtlas imagePath="spritesheet.png">
	 *    <SubTexture name="cat_fly0001.png" x="129" y="203" width="128" height="75" frameX="0" frameY="0" frameWidth="128" frameHeight="75"/>
	 *    <SubTexture name="cat_fly0002.png" x="258" y="228" width="128" height="75" frameX="0" frameY="0" frameWidth="128" frameHeight="75"/>
	 *    ...
	 *  </TextureAtlas>
	 */
	static public function parseSparrowXmlString(xml:String, ?result:SpriteSheet) {
		return parseSparrowXmlObject(Xml.parse(xml), result);
	}

	static public function parseSparrowXmlObject(xml:Xml, ?result:SpriteSheet) {
		var result = result == null ? new SpriteSheet() : result;
		var fast = new Fast(xml.firstElement());
		for (subtex in fast.nodes.SubTexture) {

			var data = new SpriteSheetFrameData();
			data.x = Std.parseInt(subtex.att.x);
			data.y = Std.parseInt(subtex.att.y);
			data.w = Std.parseInt(subtex.att.width);
			data.h = Std.parseInt(subtex.att.height);
			data.sx = subtex.has.frameX ? -Std.parseInt(subtex.att.frameX) : 0;
			data.sy = subtex.has.frameY ? -Std.parseInt(subtex.att.frameY) : 0;
			data.sw = subtex.has.frameWidth ? Std.parseInt(subtex.att.frameWidth) : data.w;
			data.sh = subtex.has.frameHeight ? Std.parseInt(subtex.att.frameHeight) : data.h;

			if (DEFAULT_NAME_EXTRACTOR.match(subtex.att.name)) {
				addToResult(result, DEFAULT_NAME_EXTRACTOR.matched(1), DEFAULT_NAME_EXTRACTOR.matched(2), data);
			}

		}

		return result;
	}


	static public function parseDefaultJsonString(json:String, ?result:SpriteSheet) {
		return parseDefaultJsonObject(Json.parse(json), result);
	}

	static public function parseDefaultJsonObject(json:Dynamic, ?result:SpriteSheet) {
		var result = result == null ? new SpriteSheet() : result;
		var frames:Array<Dynamic> = cast json.frames;
		for (frame in frames) {

			var data = new SpriteSheetFrameData();
			data.x = frame.frame.x;
			data.y = frame.frame.y;
			data.w = frame.frame.w;
			data.h = frame.frame.h;
			data.sx = frame.spriteSourceSize.x;
			data.sy = frame.spriteSourceSize.y;
			data.sw = frame.spriteSourceSize.w;
			data.sh = frame.spriteSourceSize.h;

			if (DEFAULT_NAME_EXTRACTOR.match(frame.filename)) {
				addToResult(result, DEFAULT_NAME_EXTRACTOR.matched(1), DEFAULT_NAME_EXTRACTOR.matched(2), data);
			}

		}

		return result;
	}


	/**
	 *  Name; Grid total width, height; Cell width, height; Start index; Frames count (0 for all)
	 *  @example parseGrid('some_anim_name', 50, 40, 10, 10, 6, 5)
	 *  50x40 pixels grid, 10x10 pixels cell, starting from index == 6 and get 5 cells
	 *  |0|1|2|3|4|
	 *  |5|x|x|x|x|
	 *  |x|_|_|_|_|
	 *  |_|_|_|_|_|
	 */
	static public function parseGrid(name:String, gw:Int, gh:Int, cw:Int, ch:Int, start:Int = 0, count:Int = 1, ?result:SpriteSheet) {
		var result = result == null ? new SpriteSheet() : result;
		var i = 0;
		var cy = Math.floor(start / Math.floor(gw / cw)) * ch;
		var cx = Math.floor(start % Math.floor(gw / cw)) * cw;
		while (cy + ch <= gh) {

			while (cx + cw <= gw) {

				var data = new SpriteSheetFrameData();
				data.x = cx;
				data.y = cy;
				data.sx = 0;
				data.sy = 0;
				data.sw = data.w = cw;
				data.sh = data.h = ch;

				addToResult(result, '$name', '$i', data);

				i++;

				if (count > 0 && i == count) return result;

				cx += cw;

			}

			cx = 0;
			cy += ch;

		}

		return result;
	}

	static function addToResult(result:SpriteSheet, name:String, num:String, data:SpriteSheetFrameData) {
		// set frames
		result.frames.set(name + num, data);
		// set series
		if (!result.series.exists(name)) result.series.set(name, []);
		result.series.get(name).push(data);
	}


	public var frames = new Map<String, SpriteSheetFrameData>();
	public var series = new Map<String, Array<SpriteSheetFrameData>>();

	public function new() { }

}
