package sphis.iamlo.slides;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class IntroSlide extends Slide
{
	override public function create()
	{
		var event_1:SlideEvent = new SlideEvent(1.0);
		event_1.init = function()
		{
			var nicom = new FlxSprite();
			nicom.loadGraphic('assets/images/nicom-front-face.png');

			event_1.addObject('nicom', nicom);
		};

		event_1.create = function()
		{
			var nicom:FlxSprite = cast event_1.getObject('nicom');

			nicom.alpha = 0;
			nicom.screenCenter();

			add(nicom);

			FlxTween.tween(nicom, {alpha: 1}, 1, {
				onComplete: function(tween:FlxTween)
				{
					trace("Tweened Nicom into view");
				},
				ease: FlxEase.sineInOut
			});
		}

		var event_2:SlideEvent = new SlideEvent(2.0);
		event_2.init = function()
		{
			var nicom:FlxSprite = cast event_1.getObject('nicom');

			event_2.addObject('nicom', nicom.clone());
		};
		event_2.create = function()
		{
			var nicom:FlxSprite = cast event_2.getObject('nicom');

			nicom.screenCenter();

			add(nicom);

			FlxTween.tween(nicom, {alpha: 0.75}, 1, {
				ease: FlxEase.smootherStepInOut
			});
			event_2.setVariable('squash_and_stretch_frames', [0, 1, 2, 4, 5, 7, 9, 11]);
			event_2.setVariable('squash_and_stretch_differences', [
				['x', 0.1],
				['x', 0.2],
				['x', 0.25],
				['y', 0.1],
				['y', 0.5],
				['y', 0.4],
				['y', 0.2],
				['x', 0],
			]);
			event_2.setVariable('squash_and_stretch_funcs', [
				null,
				null,
				null,
				function() {
					nicom.loadGraphic('assets/images/nicom-front-face-fear.png');
				},
				null,
				null,
				null,
				null
			]);

			new FlxTimer().start(1, function(timer:FlxTimer)
			{
				var squash_and_stretch_frames:Array<Int> = cast event_2.getVariable('squash_and_stretch_frames');
				var i = 0;
				for (frame in squash_and_stretch_frames)
				{
					var difference:Array<Dynamic> = cast event_2.getVariable('squash_and_stretch_differences')[i];
					var difference_axis:String = difference[0];
					var difference_value:Float = difference[1];
					var func:Void->Void = cast event_2.getVariable('squash_and_stretch_funcs')[i];
					var curI = i;

					new FlxTimer().start((1 / FlxG.drawFramerate) * frame, function(timer:FlxTimer)
					{
						trace('squash_and_stretch_frame={i='
							+ curI
							+ ', frame='
							+ frame
							+ ', axis='
							+ difference_axis
							+ ', value='
							+ difference_value
							+ '}');

						if (difference_axis == 'x')
						{
							nicom.scale.set(1 + difference_value, 1 - difference_value);
						}
						else if (difference_axis == 'y')
						{
							nicom.scale.set(1 - difference_value, 1 + difference_value);
						}

						if (func != null)
						{
							func();
						}
					});

					i++;
				}
			});
		};

		events = [event_1, event_2];

		press_key_to_continue = true;
		can_skip_before_end = true;

		super.create();
	}
}
