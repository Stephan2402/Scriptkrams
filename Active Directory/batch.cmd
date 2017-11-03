for /f "tokens=1-2 delims=: " %i in ('manage-bde -protectors -get C: -Type recoverypassword ^| findstr /i /c:"ID: "') do @ set _ID=%j
manage-bde.exe -protectors -adbackup c: -ID "%_ID%"