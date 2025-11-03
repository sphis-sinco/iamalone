package sphis.iamlo;

import flixel.FlxG;
import flixel.FlxState;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;
import flixel.util.FlxColor;
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

		object_press_key_to_continue_text = new FlxText();
		object_press_key_to_skip_text = new FlxText();

		object_press_key_to_continue_text.size = 16;
		object_press_key_to_skip_text.size = object_press_key_to_continue_text.size;

		object_press_key_to_continue_text.alignment = FlxTextAlign.RIGHT;
		object_press_key_to_skip_text.alignment = object_press_key_to_continue_text.alignment;

		object_press_key_to_continue_text.color = FlxColor.WHITE;
		object_press_key_to_skip_text.color = object_press_key_to_continue_text.color;

		object_press_key_to_continue_text.text = "Press " + continue_key.toString() + " to continue";
		object_press_key_to_skip_text.text = "Press " + skip_key.toString() + " to skip";
	}

	override function create()
	{
		super.create();

		add(object_press_key_to_continue_text);
		add(object_press_key_to_skip_text);

		trace(events.length + " events");

		if (events.length > 0)
		{
			startEvent(0);
		}
		else
		{
			endSlide();
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		FlxG.watch.addQuick("Timer Finished: ", object_timer.finished);
		FlxG.watch.addQuick("Press Key To Continue: ", press_key_to_continue);
		FlxG.watch.addQuick("Can Skip Before End: ", can_skip_before_end);
		FlxG.watch.addQuick("Current Event: ", current_event + 1);
		FlxG.watch.addQuick("Events Count: ", events.length);
		FlxG.watch.addQuick("At End: ", (current_event + 1) == events.length);

		object_press_key_to_continue_text.setPosition(FlxG.width - object_press_key_to_continue_text.width
			- 2,
			FlxG.height
			- object_press_key_to_continue_text.height
			- 2);
		object_press_key_to_skip_text.setPosition(FlxG.width - object_press_key_to_skip_text.width - 2, FlxG.height - object_press_key_to_skip_text.height - 2);

		if (events[current_event] == null)
		{
			object_press_key_to_continue_text.visible = false;
			object_press_key_to_skip_text.visible = false;

			return;
		}

		events[current_event].update();

		if (can_skip_before_end && proceeding_slide != null)
		{
			object_press_key_to_skip_text.visible = true;

			if (FlxG.keys.anyJustReleased([skip_key]))
			{
				endSlide();
			}
		}

		if (object_timer.finished)
		{
			if (press_key_to_continue)
			{
				object_press_key_to_continue_text.visible = true;
				if (FlxG.keys.anyJustReleased([continue_key]))
				{
					if (events.length > (current_event + 1))
					{
						startEvent(current_event + 1);
					}
					else if (events.length == (current_event + 1))
					{
						if (proceeding_slide != null)
						{
							endSlide();
						}
						else
						{
							object_press_key_to_continue_text.visible = false;
						}
					}
				}
			}

			if (current_event == (events.length - 1) && proceeding_slide != null)
			{
				object_press_key_to_skip_text.visible = true;
			}
		}
		if (object_press_key_to_continue_text.visible && object_press_key_to_skip_text.visible)
		{
			object_press_key_to_skip_text.y -= object_press_key_to_continue_text.height;
		}
	}

	public function startEvent(event:Int)
	{
		if (events[event] == null)
		{
			return;
		}

		trace("starting event " + (event + 1));

		object_press_key_to_continue_text.visible = false;
		object_press_key_to_skip_text.visible = false;

		events[event].init();

		for (object in members)
		{
			if (object == object_press_key_to_continue_text)
				continue;
			if (object == object_press_key_to_skip_text)
				continue;

			members.remove(object);
			object.destroy();
		}
		events[event].create();

		object_timer = new FlxTimer();
		object_timer.start(events[event].slide_length, function(object_timer:FlxTimer)
		{
			if (!press_key_to_continue)
			{
				if (events.length > (event + 1))
				{
					startEvent(event + 1);
				}
				else if (events.length == (event + 1))
				{
					endSlide();
				}
			}
		});

		current_event = event;
	}

	public function endSlide()
	{
		if (proceeding_slide != null)
		{
			FlxG.switchState(() -> proceeding_slide);
		}
	}
}
