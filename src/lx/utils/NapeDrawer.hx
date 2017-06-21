package lx.utils;
import luxe.Color;
import luxe.Vector;
import luxe.tween.Actuate;
import nape.geom.Vec2;
import nape.geom.Vec2List;
import nape.shape.Circle;
import nape.shape.Polygon;
import nape.shape.Shape;
import phoenix.Batcher;
import phoenix.geometry.Geometry;

/**
 * ...
 * @author https://github.com/wimcake
 */
class NapeDrawer {


	static public function cir(c:Circle, color:Color, solid:Bool = false, ?batch:Batcher, imm:Bool = false, local:Bool = true):Geometry {
		var com = local ? c.localCOM : c.worldCOM;

		return Luxe.draw.ngon( {
			x: com.x,
			y: com.y,
			r: c.radius,
			sides: 15,
			solid: solid,
			batcher: batch,
			color: color,
			immediate: imm
		} );
	}

	static public function pol(p:Polygon, color:Color, solid:Bool = false, ?batch:Batcher, imm:Bool = false, local:Bool = true):Geometry {
		var verts:Vec2List = local ? p.localVerts : p.worldVerts;
		var com = local ? p.localCOM : p.worldCOM;

		var points = [ for (i in 0...verts.length) new Vector(verts.at(i).x, verts.at(i).y) ];
		points.push(new Vector(verts.at(0).x, verts.at(0).y));
		points.push(new Vector(com.x, com.y));

		return Luxe.draw.poly( {
			points: points,
			solid: solid,
			batcher: batch,
			color: color,
			immediate: imm
		} );
	}


	static public function shape(sh:Shape, color:Color, solid:Bool = false, ?batch:Batcher, imm:Bool = false, local:Bool = true):Geometry {
		return if (sh.isCircle()) cir(sh.castCircle, color, solid, batch, imm, local) else pol(sh.castPolygon, color, solid, batch, imm, local);
	}


	static public function line(p0:Vec2, p1:Vec2, color:Color, ?batch:Batcher, imm:Bool = false):Geometry {
		return Luxe.draw.line( {
			p0: new Vector(p0.x, p0.y),
			p1: new Vector(p1.x, p1.y),
			batcher: batch,
			color: color,
			immediate: imm
		} );
	}


}
