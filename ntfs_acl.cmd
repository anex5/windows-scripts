::icacls e: /setowner *S-1-5-32-544 /T /C
::takeown /f g:\* /a /r /d Y
::icacls e: /reset /T /C
::Admins
icacls f: /grant:r *S-1-5-32-544:(OI)(CI)F /grant:r *S-1-5-32-545:(OI)(CI)F /inheritance:e /T /C /Q
::Users
::icacls e: /grant:r *S-1-5-32-545:(OI)(CI)F /inheritance:e /T /C