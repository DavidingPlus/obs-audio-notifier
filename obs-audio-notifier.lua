local obs = obslua
local ffi = require("ffi")
local winmm = ffi.load("Winmm")
local SND_ASYNC = 0x00000001
local SND_NODEFAULT = 0x00000002
local SND_LOOP = 0x00000008
local SND_FILENAME = 0x00020000
local fdwSound_flags = SND_ASYNC + SND_NODEFAULT + SND_FILENAME
local fdwSound_flags_looped = SND_ASYNC + SND_NODEFAULT + SND_LOOP + SND_FILENAME

-- Sound file path
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
  -- 回放保存的时候播放音效提醒用户。
  if event == obs.OBS_FRONTEND_EVENT_REPLAY_BUFFER_SAVED then
    playsound(SOUND_REPLAY_BUFFER_SAVED_PATH)

  -- 当 OBS 退出的时候关闭回放缓存功能。（没有 OBS 打开的 API，也很容易理解）
  elseif event == obs.OBS_FRONTEND_EVENT_EXIT then
    if obs.obs_frontend_replay_buffer_active() then
      obs.obs_frontend_replay_buffer_stop()
    end
  end
end

function script_description()
  return "An audio notifier script for OBS Studio that plays sounds when the replay buffer is saved."
end

function script_load(settings)
  obs.obs_frontend_add_event_callback(on_event)
end
