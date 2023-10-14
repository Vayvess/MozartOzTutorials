functor

import
    OS
    System
    QTk at 'x-oz://system/wp/QTk.ozf'
export
    'spawnGraphics': SpawnGraphics
define
    CD = {OS.getCWD}
    BRINDIROY_SPRITE = {QTk.newImage photo(file: CD # '/ress/brindiroy.png')}
    BACKGROUND_IMAGE = {QTk.newImage photo(file: CD # '/ress/background.png')}

    fun {NewActiveObject Class Init}
        Stream
        Port = {NewPort Stream}
        Instance = {New Class Init}
    in
        thread
            for Msg in Stream do {Instance Msg} end
        end
        
        proc {$ Msg} {Send Port Msg} end
    end

    class GameObject
        attr 'id' 'sprite' 'alive' 'x' 'y'

        meth init(Id Sprite X Y)
            'id' := Id
            'sprite' := Sprite
            'x' := X
            'y' := Y
            'alive' := true
        end

        meth isAlive($) @alive end
        meth setDead() 'alive' := false end

        % meth update() skip end

        meth render(Buffer)
            {Buffer copy(@sprite 'to': o(@x @y))}
        end
    end

    class Bot from GameObject
        meth init(Id X Y)
            GameObject, init(Id BRINDIROY_SPRITE X Y)
        end

        meth setPosition(X Y $)
            if  240 < @x andthen @x < 1040 then
                'x' := X
                if 60 < @y andthen @y < 560 then
                    'y' := Y
                    true
                else
                    {self setDead()}
                    false
                end
            else
                {self setDead()}
                false
            end
        end
    end

    class Graphics
        attr
            'canvas' 'buffer' 'window'
            'gameObjects' 'ids'
        
        meth init(Width Height)
            'window' := {QTk.build td(
                canvas(
                    'handle': @canvas
                    'width': Width
                    'height': Height
                    'background': 'black'
                )
            )}

            'buffer' := {QTk.newImage photo('width': Width 'height': Height)}
            {@canvas create('image' Width div 2 Height div 2 'image': @buffer)}
            'gameObjects' := {Dictionary.new}
            'ids' := 0

            {@window 'show'}
        end

        meth genNextId($)
            'ids' := @ids + 1
            @ids
        end

        meth setPosition(Id X Y $)
            Bot = {Dictionary.get @gameObjects Id}
        in
            {Bot setPosition(X Y $)}
        end

        meth spawnBot(X Y $)
            Id = {self genNextId($)}
            NewBot = {New Bot init(Id X Y)}
        in
            {Dictionary.put @gameObjects Id NewBot}
            Id
        end

        meth update()
            GameObjects = {Dictionary.entries @gameObjects}
        in
            % {@buffer copy(@mapBuffer 'to': o(0 0))}
            % {@buffer blank()}
            {@buffer copy(BACKGROUND_IMAGE 'to': o(0 0))}
            for Key # GameObject in GameObjects do
                % {GameObject update()}
                if {GameObject isAlive($)} then
                    {GameObject render(@buffer)}
                else
                    {Dictionary.remove @gameObjects Key}
                end
            end
        end
    end

    fun {SpawnGraphics}
        {NewActiveObject Graphics init(1280 720)}
    end
in
    {System.show 'Welcome to oz !'}
end