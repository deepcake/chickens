package;
import luxe.components.sprite.SpriteAnimation;
import luxe.Sprite;
import luxe.Vector;
import phoenix.Texture.FilterType;
import luxe.components.Animation;
import spritesheet.SpriteSheet;
import echo.Echo;
import echo.components.*;
import nape.callbacks.CbType;
import nape.dynamics.InteractionFilter;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.phys.Material;
import nape.shape.Circle;
import nape.shape.Polygon;
import nape.shape.Shape;
import luxe.Color;
using Log;

/**
 * ...
 * @author https://github.com/wimcake
 */
class Builder {


	static public var atlas:SpriteSheet;

	static public var echo:Echo;


	static public var Chicken = new CbType();
	static public var Monster = new CbType();


	static public var nape = new NapeBuilder();


	static public function initialize() {
		atlas = new SpriteSheet();
		SpriteSheet.parseSparrowXmlString(Luxe.resources.text('assets/sprites.xml').asset.text, atlas);

		echo = new Echo();
	}


	static public function animation(name:String, speed:Int = 25, scale:Float = 1.0):Sprite {
		var seq = atlas.series.get(name);
		var size = new Vector(seq[0].sw * scale, seq[0].sh * scale);
		var s = new Sprite( {
			texture: Luxe.resources.texture('assets/sprites.png'),
			size: size,
			origin: new Vector(size.x * .5, size.y)
		} );
		s.add(new luxe.components.Animation(seq, speed));
		return s;
	}

	static public function frame(name:String, scale:Float = 1.0):Sprite {
		var f = atlas.frames.get(name);
		var size = new Vector(f.sw * scale, f.sh * scale);
		var s = new Sprite( {
			texture: Luxe.resources.texture('assets/sprites.png'),
			size: size,
			origin: new Vector(size.x * .5, size.y)
		} );
		s.add(new luxe.components.Frame(f));
		return s;
	}


	static public function chicken(?x:Float, ?y:Float, ?vx:Float, ?vy:Float) {
		var s = animation('chicken_fly', Std.int(25), .4);
		var v = new Vel(vx, vy);
		var b = nape.body(x.alt(Math.random() * Luxe.screen.w), 
						  y.alt(Math.random() * Luxe.screen.h),
						  nape.cir(10));
		b.cbTypes.add(Chicken);
		var c = new Color().rgb(0xf0f0f0);
		echo.setComponent(echo.id(), s, v, b, c);
	}

	static public function monster(?x:Float, ?y:Float, ?vx:Float, ?vy:Float) {
		var s = animation('monster_fly', Std.int(25), 1.0);
		var v = new Vel(vx, vy);
		var b = nape.body(x.alt(Math.random() * Luxe.screen.w), 
						  y.alt(Math.random() * Luxe.screen.h),
						  nape.cir(20));
		b.cbTypes.add(Monster);
		var c = new Color().rgb(0xf0f0f0);
		echo.setComponent(echo.id(), s, v, b, c);
	}

}

class NapeBuilder {
	public function new() { }

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
