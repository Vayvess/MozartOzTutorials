functor

import
    OS
    Agent
    System
    Graphics
define
    Window = {Graphics.spawnGraphics}

    fun {BotFuncObj State}
        fun {NextMove nextMove(Id X Y)}
            Id = State.id
            X = State.x - 16 + {OS.rand} mod 32
            Y = State.y - 16 + {OS.rand} mod 32
            {BotFuncObj {Adjoin State state(
                'x': X
                'y': Y
            )}}
        end

        fun {GetState getState(R)}
            R = State
            {BotFuncObj State}
        end

        fun {ShowState showState()}
            {System.show State}
            {BotFuncObj State}
        end
    in
        botFuncObj(
            'nextMove': NextMove
            'getState': GetState
            'showState': ShowState
        )
    end

    fun {NewBot Id X Y}
        {Agent.spawnAgent {BotFuncObj state(
            'id': Id
            'x': X
            'y': Y
        )}}
    end

    fun {SpawnBots N}
        if N > 0 then
            X = {OS.rand} mod 800
            Y = {OS.rand} mod 600
            Id = {Window spawnBot(X Y $)}
        in
            {NewBot Id X Y} | {SpawnBots N - 1}
        else 'nil' end
    end

    fun {RespawnBot Bots}
        case Bots of
            Bot | T then
                Id NewX NewY
            in
                {Send Bot nextMove(Id NewX NewY)}
                if {Window setPosition(Id NewX NewY $)} then
                    Bot | {RespawnBot T}
                else
                    {RespawnBot T}
                end
        else 'nil' end
    end

    proc {Ticks Bots}
        AliveBots = {RespawnBot Bots}
    in
        {Window update()}
        {Delay 33}
        {Ticks AliveBots}
    end

    Bots = {SpawnBots 8}
in
    {Ticks Bots}
end
