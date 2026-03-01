script_name("BindMenu PRO")
script_author("CodeKernel")

require 'lib.moonloader'
local imgui = require 'imgui'
local inicfg = require 'inicfg'
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8

local main_window_state = imgui.ImBool(false)
local novoComando = imgui.ImBuffer(256)

local config_dir = "BindMenu"
local config_name = "BindMenu"

local binds = {}

local default_config = {
    binds = {}
}

local cfg = inicfg.load(default_config, config_dir)

-- Carregar binds salvos
if cfg.binds then
    for k, v in pairs(cfg.binds) do
        table.insert(binds, v)
    end
end

function saveBinds()
    cfg.binds = {}
    for i, v in ipairs(binds) do
        cfg.binds[i] = v
    end
    inicfg.save(cfg, config_dir)
end

function main()
    while not isSampAvailable() do wait(100) end

    sampRegisterChatCommand("bindar", function()
        main_window_state.v = not main_window_state.v
    end)

    sampAddChatMessage("[BindMenu PRO] Use /bindar para abrir.", -1)

    while true do
        wait(0)
        imgui.Process = main_window_state.v
    end
end

function imgui.OnDrawFrame()
    if not main_window_state.v then return end

    imgui.Begin(u8"BindMenu PRO", main_window_state)

    imgui.Text(u8"Adicionar novo comando:")
    imgui.InputText("##novo", novoComando)

    if imgui.Button(u8"Adicionar Bind") then
        local texto = tostring(novoComando.v)
        if texto ~= "" then
            table.insert(binds, texto)
            novoComando.v = ""
            saveBinds()
        end
    end

    imgui.Separator()
    imgui.Text(u8"Binds Salvos:")

    for i, cmd in ipairs(binds) do
        if imgui.Button(u8(cmd) .. "##"..i) then
            sampSendChat(cmd)
        end

        imgui.SameLine()

        if imgui.SmallButton(u8"Remover##"..i) then
            table.remove(binds, i)
            saveBinds()
            break
        end
    end

    imgui.Separator()
    imgui.TextColored(imgui.ImVec4(0,1,0,1), u8"Créditos:")
    imgui.Text(u8"Autor E Metade Do Código: CodeKernel")
    imgui.Text(u8"suporte: ChatGPT")
    imgui.Text(u8"Versão: 2.0")

    imgui.End()
end