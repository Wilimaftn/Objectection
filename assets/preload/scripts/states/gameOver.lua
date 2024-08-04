local canReset = false
local canPause = false
function onCreate()
    makeLuaSprite('tt', 'gameOverText', 0, 0)
    loadGraphic('tt', 'gameOverText', 175, 13)
    addAnimation('tt', 'idle', {0}, 12, false)
    scaleObject('tt', 3.1, 3.1)
    screenCenter('tt', 'xy')
    setProperty('tt.y', getProperty('tt.y')+200)
    setProperty('tt.antialiasing', false)
    setObjectCamera('tt', 'other')
    addLuaSprite('tt', true)
    setProperty('tt.alpha', 0)
    openCustomSubstate('GuiltyVerdict', false)
end

function onPause()
    if not canPause then
        return Function_Stop
    end
end

function onCustomSubstateCreate(name)
    if name == 'GuiltyVerdict' then
        setProperty('defaultCamZoom', 0.98)
        setProperty('cameraSpeed', 300)
        setProperty('camZooming', false)
        setPropertyFromClass('flixel.FlxG', 'sound.music.volume', 0)
        setProperty('vocals.volume', 0)
        cameraShake('camGame', 0.010, 0.3)
        startTween('fadeHUD', 'this', {['camHUD.alpha'] = 0}, 0.5, {ease = 'quartInOut', onComplete = 'onTweenCompleted'})
        runTimer('wait2', 1.8)
        playAnim('boyfriend', 'singRIGHTmiss', true)
        playAnim('gf', 'danceRight', true)
        triggerEvent('Alt Idle Animation', 'bf', '-none')
        playSound('sfx-damage2', 1)
        cameraSetTarget('boyfriend')
    end
end

function onCustomSubstateUpdate(name, elapsed)
    if name == 'GuiltyVerdict' then
        setPropertyFromClass('backend.Conductor', 'songPosition', 00000)
        if canReset then
            if keyJustPressed('accept') then
                addAnimation('tt', 'idle', {2,2,1,1,0,0}, 24, false)
                playSound('sfx-pichoop', 1)
                cameraFade('camOther', '000000', 2, true)
                runTimer('asan', 2)
                canReset = false
            elseif keyJustPressed('back') then
                cameraFade('camOther', '000000', 2, true)
                runTimer('asan3', 2)
            end
        end
    end
end

function onCustomSubstateDestroy(name)

end

function onTweenCompleted(tag)
    if tag == 'fadeother' then
        loadSong('turnabout', 0)
    end
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'wait' then
        runTimer('asan2', 1.5)
        cameraShake('camGame', 0.005, 0.2)
        makeAnimatedLuaSprite('guilty', 'ui/guilty', 0, 0)
        scaleObject('guilty', 4, 4)
        screenCenter('guilty', 'xy')
        setProperty('guilty.x', getProperty('guilty.x')-70)
        setProperty('guilty.y', getProperty('guilty.y')-50)
        setObjectCamera('guilty', 'other')
        setProperty('guilty.antialiasing', false)
        addAnimationByPrefix('guilty', 'boom', 'guilty idle', 24, false)
        playAnim('guilty', 'boom', true)
        addLuaSprite('guilty', true)
        playAnim('gf', 'warning', true)
        canReset = true
        playSound('sfx-guilty', 1)
        startTween('color', 'this', {['camGame.color'] = '000000'}, 2, {ease = 'quartInOut', startDelay = 2, onComplete = 'onTweenCompleted'})
    end
    if tag == 'wait2' then
        playSound('sfx-realization', 1)
        triggerEvent('Camera Follow Pos',getMidpointX('gf')+getProperty('gf.cameraPosition[0]'),getMidpointY('gf')+getProperty('gf.cameraPosition[1]'));
        runTimer('wait', 2.1)
    end
    if tag == 'asan' then
        loadSong('turnabout', 0)
    end
    if tag == 'asan2' then
        startTween('fadeInText', 'tt', {alpha = 1}, 0.6, {ease = 'quartIn', startDelay = 3, onComplete = 'onTweenCompleted'})
        cameraFade('camGame', '000000', 3, true)
    end
    if tag == 'asan3' then
        exitSong()
    end
end