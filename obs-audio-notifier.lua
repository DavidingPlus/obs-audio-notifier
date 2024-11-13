local obs = obslua
local ffi = require("ffi")
local winmm = ffi.load("Winmm")
local SND_ASYNC = 0x00000001
local SND_NODEFAULT = 0x00000002
local SND_LOOP = 0x00000008
local SND_FILENAME = 0x00020000
local fdwSound_flags = SND_ASYNC + SND_NODEFAULT + SND_FILENAME
local fdwSound_flags_looped = SND_ASYNC + SND_NODEFAULT + SND_LOOP + SND_FILENAME

-- Put a sounds of your choice in directory res and don't forget to match its names either in code below or rename your existing files.
SOUND_REPLAY_BUFFER_SAVED_PATH = script_path() .. "./res/replay-buffer-saved.wav"

ffi.cdef[[
    bool PlaySound(const char *pszSound, void *hmod, uint32_t fdwSound);
]]

function playsound(filepath)
    winmm.PlaySound(filepath, nil, fdwSound_flags)
end

function playsound_looped(filepath)
    winmm.PlaySound(filepath, nil, fdwSound_flags_looped)
end

function on_event(event)
  -- see more event: https://docs.obsproject.com/reference-frontend-api
  if event == obs.OBS_FRONTEND_EVENT_REPLAY_BUFFER_SAVED then
    playsound(SOUND_REPLAY_BUFFER_SAVED_PATH)
  end
end

function script_description()
    return "An audio notifier script for OBS Studio."
end

function script_load(settings)
  obs.obs_frontend_add_event_callback(on_event)
end
