functor

export
    'spawnAgent': SpawnAgent
define
    proc {Handler Msg | Upcoming Agent}
        {Handler Upcoming {Agent.{Label Msg} Msg}}
    end

    fun {SpawnAgent Agent}
        Events
        Port = {NewPort Events}
    in
        thread {Handler Events Agent} end
        Port
    end
end
