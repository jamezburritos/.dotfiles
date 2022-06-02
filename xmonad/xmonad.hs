-- 
-- xmonad config - https://xmonad.org
-- depends on:
--   - xmobar
--

import XMonad

import XMonad.StackSet hiding (workspaces)

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Hooks.UrgencyHook

import XMonad.Layout.Spacing
import XMonad.Layout.Renamed
import XMonad.Layout.Grid
import XMonad.Layout.NoBorders (smartBorders)

import XMonad.Util.EZConfig
import XMonad.Util.Cursor

import Data.Ratio

-- main 

main :: IO ()
main = do
    xmonad
      $ docks
      $ ewmh
      $ ewmhFullscreen
      $ withEasySB (statusBarProp "xmobar" (pure myXmobar)) defToggleStrutsKey
        myConfig

-- colours

black   = "#282828"
red     = "#cc241d"
green   = "#98971a"
yellow  = "#d79921"
blue    = "#458588"
magenta = "#b16286"
cyan    = "#689d6a"
white   = "#a89984"

brightBlack   = "#928374"
brightRed     = "#fb4934"
brightGreen   = "#b8bb26"
brightYellow  = "#fabd2f"
brightBlue    = "#83a598"
brightMagenta = "#d3869b"
brightCyan    = "#8ec07c"
brightWhite   = "#ebdbb2"

background = "#282828"
foreground = "#ebdbb2"
pureWhite  = "#ffffff"

underLine col = xmobarBorder "Bottom" col 3

-- layouts

mySpacing = 2
myBorderWidth = 2

myLayoutHook = avoidStruts $ smartBorders $ layout_main 
             ||| layout_flip 
             ||| layout_grid
             ||| layout_full
  where
    layout_main = renamed [Replace "main"]
                $ spacing mySpacing
                $ Tall 1 (3/100) (1/2)

    layout_full = renamed [Replace "full"]
                  Full

    layout_flip = renamed [Replace "flip"]
                $ Mirror layout_main

    layout_grid = renamed [Replace "grid"]
                $ spacing mySpacing
                  Grid

-- workspaces 

myWorkspaces :: [String]
myWorkspaces = clickableWorkspaces 
    [ "home",
      "web",
      "media",
      "chat",
      "play",
      "work",
      "alpha",
      "beta",
      "gamma" ]

clickableWorkspaces :: [String] -> [String]
clickableWorkspaces = zipWith switchWorkspace [0..]
  where
    switchWorkspace i = xmobarAction ("wmctrl -s " ++ show i) "1"

-- key bindings

myKeys = 
    [ -- open rofi
      ("M-p",                    spawn "rofi -show run"),
      ("M-S-p",                  spawn "rofi -show window"),
      -- screenshot
      ("M-S-s",                  spawn "scrot -s -F \"$HOME/screenshots/scrot_%Y-%m-%d.png\""), 
      -- lock screen
      ("M-l",                    spawn "dm-tool lock"),
      -- audio control
      ("<XF86AudioRaiseVolume>", spawn "pamixer -i 2"),
      ("<XF86AudioLowerVolume>", spawn "pamixer -d 2"),
      ("<XF86AudioMute>",        spawn "pamixer -t"),
      ("<XF86AudioPrev>",        spawn "playerctl previous"),
      ("<XF86AudioNext>",        spawn "playerctl next"),
      ("<XF86AudioPlay>",        spawn "playerctl play-pause") ]

-- managehook

myManageHook = composeAll
    [ className =? "feh"              --> doFloat,
      role      =? "pop-up"           --> doFloat,
      role      =? "PictureInPicture" --> doRectFloat (RationalRect (1 % 4) (1 % 4) (1 % 2) (1 % 2)),
      appName   =? "xmessage"         --> doRectFloat (RationalRect (1 % 4) (1 % 4) (1 % 2) (1 % 2)) ]
  where
    role = stringProperty "WM_WINDOW_ROLE"

-- xmobar

myXmobar:: PP
myXmobar = def {
    ppCurrent          = xmobarBorder "Bottom" brightWhite 3 . pad,
    ppUrgent           = xmobarBorder "Bottom" yellow  3 . pad,
    ppHidden           = pad,
    ppHiddenNoWindows  = xmobarColor brightBlack background . pad,
    ppLayout           = xmobarBorder "Bottom" cyan 3 . xmobarColor cyan background . xmobarAction "xdotool key super+space" "1" . pad,
    ppTitle            = xmobarStrip . pad,
    ppWsSep            = "",
    ppSep              = ""
}

-- startup 

myStartupHook = do
    spawn "$HOME/.config/xmonad/launch.sh"
    setDefaultCursor xC_left_ptr


-- config 

myConfig = def {  
    modMask             = mod4Mask,
    workspaces          = myWorkspaces,
    terminal            = "alacritty",
    layoutHook          = myLayoutHook,
    startupHook         = myStartupHook,
    manageHook          = myManageHook,
    focusFollowsMouse   = False,
    clickJustFocuses    = False,
    borderWidth         = myBorderWidth,
    normalBorderColor   = foreground,
    focusedBorderColor  = cyan
}   `additionalKeysP`     myKeys
