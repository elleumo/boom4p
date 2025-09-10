# patch-4p.ps1
param(
  [string]$RepoRoot = (Get-Location).Path
)

$ErrorActionPreference = "Stop"

function Edit-File {
  param(
    [Parameter(Mandatory=$true)][string]$Path,
    [Parameter(Mandatory=$true)][ScriptBlock]$Edit
  )
  if (-not (Test-Path $Path)) { throw "File non trovato: $Path" }
  $text = Get-Content -Raw -Path $Path
  $new  = & $Edit $text
  if ($null -eq $new) { throw "Nessuna modifica calcolata per $Path" }
  if ($new -ne $text) {
    Set-Content -Path $Path -Value $new -NoNewline
    Write-Host "✔ Modificato $Path"
  } else {
    Write-Host "ℹ Nessuna modifica necessaria in $Path"
  }
}

$controlsCpp = Join-Path $RepoRoot "src\lifish\controls.cpp"

Edit-File -Path $controlsCpp -Edit {
  param($t)

  # 1) Portare players[] a 4 righe con mappature predefinite
  $patternPlayers = '(?s)std::array<\s*sf::Keyboard::Key\s*,\s*lif::controls::CONTROLS_NUM\s*>\s+lif::controls::players\[\]\s*=\s*\{.*?\};'
  $replacementPlayers = @'
std::array<sf::Keyboard::Key, lif::controls::CONTROLS_NUM> lif::controls::players[] =
{
    // P1: W A S D + Space (bomb)
    { sf::Keyboard::W, sf::Keyboard::S, sf::Keyboard::D, sf::Keyboard::A, sf::Keyboard::Space },
    // P2: Arrow keys + Right Control (bomb)
    { sf::Keyboard::Up, sf::Keyboard::Down, sf::Keyboard::Right, sf::Keyboard::Left, sf::Keyboard::RControl },
    // P3: T F G H + Right Shift (bomb)
    { sf::Keyboard::T, sf::Keyboard::G, sf::Keyboard::H, sf::Keyboard::F, sf::Keyboard::RShift },
    // P4: I J K L + Enter (bomb)
    { sf::Keyboard::I, sf::Keyboard::K, sf::Keyboard::L, sf::Keyboard::J, sf::Keyboard::Enter }
};
'@

  if ($t -match $patternPlayers) {
    $t = [regex]::Replace($t, $patternPlayers, [System.Text.RegularExpressions.MatchEvaluator]{ param($m) $replacementPlayers })
  } else {
    $incPattern = '(^\s*#\s*include\s*"controls.hpp".*?$)'
    if ($t -match $incPattern) {
      $t = [regex]::Replace($t,
        '(?s)std::array<\s*sf::Keyboard::Key\s*,\s*lif::controls::CONTROLS_NUM\s*>\s+lif::controls::players\[\]\s*=\s*\{.*?\};\s*',
        '')
      $t = [regex]::Replace($t, $incPattern, { param($m) $m.Groups[1].Value + "`r`n`r`n" + $replacementPlayers }, 1)
    } else {
      throw "Impossibile patchare players[]: non trovo l'include 'controls.hpp' né la definizione originale."
    }
  }

  # 2) joystickBombKey -> 4 elementi {0,0,0,0}
  $patternJoyBomb = 'std::array<\s*unsigned\s*,\s*lif::MAX_PLAYERS\s*>\s+lif::controls::joystickBombKey\s*=\s*\{\s*\{\s*([^\}]*)\s*\}\s*\}\s*;'
  if ($t -match $patternJoyBomb) {
    $t = [regex]::Replace($t, $patternJoyBomb, 'std::array<unsigned, lif::MAX_PLAYERS> lif::controls::joystickBombKey = {{ 0, 0, 0, 0 }};')
  } else {
    $declJoyBomb = 'std::array<\s*unsigned\s*,\s*lif::MAX_PLAYERS\s*>\s+lif::controls::joystickBombKey\s*;'
    if ($t -match $declJoyBomb) {
      $t = $t -replace $declJoyBomb, 'std::array<unsigned, lif::MAX_PLAYERS> lif::controls::joystickBombKey = {{ 0, 0, 0, 0 }};'
    }
  }

  # 3) useJoystick -> {-1,-1,-1,-1}
  $patternUseJoyInit = 'std::array<\s*short\s*,\s*lif::MAX_PLAYERS\s*>\s+lif::controls::useJoystick\s*=\s*\{\s*\{\s*([^\}]*)\s*\}\s*\}\s*;'
  $declUseJoyOnly   = 'std::array<\s*short\s*,\s*lif::MAX_PLAYERS\s*>\s+lif::controls::useJoystick\s*;'
  if ($t -match $patternUseJoyInit) {
    $t = [regex]::Replace($t, $patternUseJoyInit, 'std::array<short, lif::MAX_PLAYERS> lif::controls::useJoystick = {{ -1, -1, -1, -1 }};')
  } elseif ($t -match $declUseJoyOnly) {
    $t = $t -replace $declUseJoyOnly, 'std::array<short, lif::MAX_PLAYERS> lif::controls::useJoystick = {{ -1, -1, -1, -1 }};'
  }

  return $t
}

Write-Host ""
Write-Host ">>> Patch completata."
Write-Host "Ora ricompila."
Write-Host ""
