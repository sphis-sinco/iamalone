package sphis.iamlo;

import flixel.FlxG;
import flixel.FlxState;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;
import flixel.util.FlxTimer;

class Slide extends FlxState
{
	// a list of slide events, duh.
	public var events:Array<SlideEvent> = [];

	// current event in the events list... obviously
	public var current_event:Int = 0;

	// if true it lets you skip this slide before it ends
	public var can_skip_before_end:Bool = false;

	// if true then you have to use continue_key to proceed events
	public var press_key_to_continue:Bool = false;

	// the slide once this one is over
	public var proceeding_slide:Slide = null;

	// the key to continue; duh
	public var continue_key:FlxKey = FlxKey.SPACE;

	// the key to skip; duh
	public var skip_key:FlxKey = FlxKey.ENTER;

	private var object_timer:FlxTimer;

	private var object_press_key_to_continue_text:FlxText;
	private var object_press_key_to_skip_text:FlxText;

	override public function new()
	{
		super();

		this.object_press_key_to_continue_text = new FlxText();
		this.object_press_key_to_skip_text = new FlxText();

		this.object_press_key_to_continue_text.size = 16;
		this.object_press_key_to_skip_text.size = this.object_press_key_to_continue_text.size;

		this.object_press_key_to_continue_text.alignment = FlxTextAlign.RIGHT;
		this.object_press_key_to_skip_text.alignment = this.object_press_key_to_continue_text.alignment;

		this.object_press_key_to_continue_text.text = "Press " + this.continue_key.toString() + " to continue";
		this.object_press_key_to_skip_text.text = "Press " + this.skip_key.toString() + " to skip";
	}

	override function create()
	{
		super.create();

		if (this.events.length > 0)
		{
			this.startEvent(0);
		}
		else
		{
			this.endSlide();
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		this.object_press_key_to_continue_text.setPosition(FlxG.width
			- this.object_press_key_to_continue_text.width
			- 2,
			FlxG.height
			- this.object_press_key_to_continue_text.height
			- 2);
		this.object_press_key_to_skip_text.setPosition(FlxG.width - this.object_press_key_to_skip_text.width - 2,
			FlxG.height - this.object_press_key_to_skip_text.height - 2);

		if (this.events[current_event] == null)
		{
			this.object_press_key_to_continue_text.visible = false;
			this.object_press_key_to_skip_text.visible = false;

			return;
		}

		this.events[current_event].update();

		if (this.object_timer.finished)
		{
			if (this.press_key_to_continue)
			{
				this.object_press_key_to_continue_text.visible = true;
			}

			if (this.can_skip_before_end && this.current_event != (this.events.length - 1))
			{
				this.object_press_key_to_skip_text.visible = true;
			}

			if (this.current_event == (this.events.length - 1))
			{
				this.object_press_key_to_skip_text.visible = true;
			}
		}

		if (this.object_press_key_to_continue_text.visible && this.object_press_key_to_skip_text.visible)
		{
			this.object_press_key_to_skip_text.setPosition(FlxG.width
				- this.object_press_key_to_skip_text.width
				- 2,
				FlxG.height
				- this.object_press_key_to_skip_text.height
				- this.object_press_key_to_continue_text.height
				- 4);
		}
	}

	public function startEvent(event:Int)
	{
		if (this.events[event] == null)
		{
			return;
		}
		this.object_press_key_to_continue_text.visible = false;
		this.object_press_key_to_skip_text.visible = false;

		this.events[event].init();

		this.events[event].create();

		this.object_timer = new FlxTimer();
		this.object_timer.start(this.events[event].slide_length, function(object_timer:FlxTimer)
		{
			if (this.events.length > (event + 1))
			{
				if (!this.press_key_to_continue)
				{
					this.startEvent(event + 1);
				}
			}
			else if (this.events.length == (event + 1))
			{
				this.endSlide();
			}
		});

		this.current_event = event;
	}

	public function endSlide()
	{
		if (this.proceeding_slide != null)
		{
			FlxG.switchState(() -> this.proceeding_slide);
		}
	}
}
