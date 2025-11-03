package sphis.iamlo;

import flixel.FlxBasic;

class SlideEvent
{
	public var slide_length:Float = 1.0;

	public var objects:Map<String, FlxBasic> = [];
	public var variables:Map<String, Dynamic> = [];

	public function new(slide_length:Float)
	{
		this.slide_length = slide_length;
	}

	public function setVariable(variable:String, value:Dynamic)
	{
		this.variables.set(variable, value);
	}

	public function getVariable(variable:String):Dynamic
	{
		return this.variables.get(variable);
	}

	public function addObject(id:String, object:FlxBasic)
	{
		if (this.objects.exists(id))
		{
			trace("Didn't add " + id + " because it already exists");
			return;
		}

		this.objects.set(id, object);
	}

	public function getObject(id:String):FlxBasic
	{
		if (!this.objects.exists(id))
		{
			return null;
		}
		else
		{
			return this.objects.get(id);
		}
	}

	public function removeObject(id:String)
	{
		if (!this.objects.exists(id))
		{
			return;
		}

		this.objects.remove(id);
	}

	public dynamic function init() {};

	public dynamic function create() {};

	public dynamic function update() {};
}
