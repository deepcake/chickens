package;
import echo.Echo;
import components.*;
import spritesheet.SpriteSheet;
#if luxe
import luxe.Ev;
import luxe.Sprite;
import luxe.Vector;
import phoenix.Texture.FilterType;
import lx.components.Animation;
#end
import nape.callbacks.CbType;
import nape.dynamics.InteractionFilter;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.phys.Material;
import nape.shape.Circle;
import nape.shape.Polygon;
import nape.shape.Shape;
using Log;

/**
 * ...
 * @author https://github.com/wimcake
 */
class Builder {


	static public var Chicken = new CbType();
	static public var Monster = new CbType();


	static public var echo:Echo;

	static public var nape:NapeBuilder;
	static public var visual:VisualBuilder;


	static public function init() {
		nape = new NapeBuilder();
		visual = new VisualBuilder();

		echo = new Echo();
	}

	static public function chicken(?x:Float, ?y:Float, ?vx:Float, ?vy:Float) {
		var s = visual.anim('chicken_fly', Std.int(25), .4);
		var v = new Vel(vx, vy);
		var b = nape.body(x, y, nape.cir(10));
		b.cbTypes.add(Chicken);
		var status = new Status();
		echo.setComponent(echo.id(), s, v, b, status);
	}

	static public function monster(?x:Float, ?y:Float, ?vx:Float, ?vy:Float) {
		var s = visual.anim('monster_fly', Std.int(25), 1.0);
		var v = new Vel(vx, vy);
		var b = nape.body(x, y, nape.cir(20));
		b.cbTypes.add(Monster);
		var status = new Status();
		echo.setComponent(echo.id(), s, v, b, status);
	}

}

typedef VisualBuilder = #if luxe LuxeBuilder; #end

#if luxe
class LuxeBuilder {

	static public var atlas:SpriteSheet;

	public function new() {
		atlas = new SpriteSheet();
		SpriteSheet.parseSparrowXmlString(Luxe.resources.text('assets/sprites.atlas').asset.text, atlas);
	}

	public function anim(name:String, speed:Int = 25, scale:Float = 1.0) {
		var seq = atlas.series.get(name);
		var size = new Vector(seq[0].sw * scale, seq[0].sh * scale);
		var s = new Sprite( {
			texture: Luxe.resources.texture('assets/sprites.png'),
			size: size,
			origin: new Vector(size.x * .5, size.y)
		} );
		s.add(new lx.components.Animation(seq, speed));
		return s;
	}

	public function sprite(name:String, scale:Float = 1.0) {
		var f = atlas.frames.get(name);
		var size = new Vector(f.sw * scale, f.sh * scale);
		var s = new Sprite( {
			texture: Luxe.resources.texture('assets/sprites.png'),
			size: size,
			origin: new Vector(size.x * .5, size.y)
		} );
		s.add(new lx.components.Frame(f));
		return s;
	}
}
#end

class NapeBuilder {
	public var space:nape.space.Space;

	public function new() {
		space = new nape.space.Space();
	}

	public function box(w:Float, h:Float, sensor:Bool = false, ?mat:Material):Shape {
		var sh = new Polygon(Polygon.box(w, h, true), mat != null ? mat : Material.wood());
		sh.sensorEnabled = sensor;
		return sh;
	}

	public function cir(r:Float, sensor:Bool = false, ?mat:Material):Shape {
		var sh = new Circle(r, null, mat != null ? mat : Material.wood());
		sh.sensorEnabled = sensor;
		return sh;
	}

	public function body(x:Float, y:Float, ?shape:Shape, ?shapes:Array<Shape>, dyn:Bool = true, bul:Bool = false, ?filter:InteractionFilter):Body {
		var b = new Body(dyn ? BodyType.DYNAMIC : BodyType.STATIC, Vec2.weak(x, y));
		b.isBullet = bul;

		if (shape != null) b.shapes.add(shape);
		if (shapes != null) for (sh in shapes) b.shapes.add(sh);
		if (filter != null) b.setShapeFilters(filter);

		return b;
	}
}
