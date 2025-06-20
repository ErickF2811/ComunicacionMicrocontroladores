
_delay_ms_var:

;MyProject.c,35 :: 		void delay_ms_var(int ms) {
;MyProject.c,36 :: 		while (ms-- > 0) {
L_delay_ms_var0:
	MOVF       FARG_delay_ms_var_ms+0, 0
	MOVWF      R1+0
	MOVF       FARG_delay_ms_var_ms+1, 0
	MOVWF      R1+1
	MOVLW      1
	SUBWF      FARG_delay_ms_var_ms+0, 1
	BTFSS      STATUS+0, 0
	DECF       FARG_delay_ms_var_ms+1, 1
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      R1+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__delay_ms_var42
	MOVF       R1+0, 0
	SUBLW      0
L__delay_ms_var42:
	BTFSC      STATUS+0, 0
	GOTO       L_delay_ms_var1
;MyProject.c,37 :: 		Delay_ms(1);
	MOVLW      3
	MOVWF      R12+0
	MOVLW      151
	MOVWF      R13+0
L_delay_ms_var2:
	DECFSZ     R13+0, 1
	GOTO       L_delay_ms_var2
	DECFSZ     R12+0, 1
	GOTO       L_delay_ms_var2
	NOP
	NOP
;MyProject.c,38 :: 		}
	GOTO       L_delay_ms_var0
L_delay_ms_var1:
;MyProject.c,39 :: 		}
L_end_delay_ms_var:
	RETURN
; end of _delay_ms_var

_playNote:

;MyProject.c,42 :: 		void playNote(char note, int duration_ms) {
;MyProject.c,43 :: 		int freq = 0;
	CLRF       playNote_freq_L0+0
	CLRF       playNote_freq_L0+1
;MyProject.c,45 :: 		for (i = 0; i < 40; i++) {
	CLRF       playNote_i_L0+0
	CLRF       playNote_i_L0+1
L_playNote3:
	MOVLW      128
	XORWF      playNote_i_L0+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__playNote44
	MOVLW      40
	SUBWF      playNote_i_L0+0, 0
L__playNote44:
	BTFSC      STATUS+0, 0
	GOTO       L_playNote4
;MyProject.c,46 :: 		if (names[i] == note) {
	MOVF       playNote_i_L0+0, 0
	ADDLW      _names+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORWF      FARG_playNote_note+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_playNote6
;MyProject.c,47 :: 		freq = tones[i];
	MOVF       playNote_i_L0+0, 0
	MOVWF      R0+0
	MOVF       playNote_i_L0+1, 0
	MOVWF      R0+1
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	ADDLW      _tones+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      playNote_freq_L0+0
	INCF       FSR, 1
	MOVF       INDF+0, 0
	MOVWF      playNote_freq_L0+1
;MyProject.c,48 :: 		break;
	GOTO       L_playNote4
;MyProject.c,49 :: 		}
L_playNote6:
;MyProject.c,45 :: 		for (i = 0; i < 40; i++) {
	INCF       playNote_i_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       playNote_i_L0+1, 1
;MyProject.c,50 :: 		}
	GOTO       L_playNote3
L_playNote4:
;MyProject.c,52 :: 		if (freq > 0) {
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      playNote_freq_L0+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__playNote45
	MOVF       playNote_freq_L0+0, 0
	SUBLW      0
L__playNote45:
	BTFSC      STATUS+0, 0
	GOTO       L_playNote7
;MyProject.c,53 :: 		Sound_Play(freq, duration_ms);
	MOVF       playNote_freq_L0+0, 0
	MOVWF      FARG_Sound_Play_freq_in_hz+0
	MOVF       playNote_freq_L0+1, 0
	MOVWF      FARG_Sound_Play_freq_in_hz+1
	MOVF       FARG_playNote_duration_ms+0, 0
	MOVWF      FARG_Sound_Play_duration_ms+0
	MOVF       FARG_playNote_duration_ms+1, 0
	MOVWF      FARG_Sound_Play_duration_ms+1
	CALL       _Sound_Play+0
;MyProject.c,54 :: 		delay_ms_var(duration_ms);
	MOVF       FARG_playNote_duration_ms+0, 0
	MOVWF      FARG_delay_ms_var_ms+0
	MOVF       FARG_playNote_duration_ms+1, 0
	MOVWF      FARG_delay_ms_var_ms+1
	CALL       _delay_ms_var+0
;MyProject.c,55 :: 		Sound_Play(0, 0);  // Apagar sonido
	CLRF       FARG_Sound_Play_freq_in_hz+0
	CLRF       FARG_Sound_Play_freq_in_hz+1
	CLRF       FARG_Sound_Play_duration_ms+0
	CLRF       FARG_Sound_Play_duration_ms+1
	CALL       _Sound_Play+0
;MyProject.c,56 :: 		} else {
	GOTO       L_playNote8
L_playNote7:
;MyProject.c,57 :: 		delay_ms_var(duration_ms);
	MOVF       FARG_playNote_duration_ms+0, 0
	MOVWF      FARG_delay_ms_var_ms+0
	MOVF       FARG_playNote_duration_ms+1, 0
	MOVWF      FARG_delay_ms_var_ms+1
	CALL       _delay_ms_var+0
;MyProject.c,58 :: 		}
L_playNote8:
;MyProject.c,59 :: 		}
L_end_playNote:
	RETURN
; end of _playNote

_PlaySong:

;MyProject.c,62 :: 		void PlaySong() {
;MyProject.c,65 :: 		for ( i = 0; i < length; i++) {
	CLRF       PlaySong_i_L0+0
	CLRF       PlaySong_i_L0+1
L_PlaySong9:
	MOVLW      128
	XORWF      PlaySong_i_L0+1, 0
	MOVWF      R0+0
	MOVLW      128
	XORLW      0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__PlaySong47
	MOVLW      185
	SUBWF      PlaySong_i_L0+0, 0
L__PlaySong47:
	BTFSC      STATUS+0, 0
	GOTO       L_PlaySong10
;MyProject.c,66 :: 		dur = (25000 / tempo) * beats[i];
	MOVF       PlaySong_i_L0+0, 0
	MOVWF      R0+0
	MOVF       PlaySong_i_L0+1, 0
	MOVWF      R0+1
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
	MOVLW      _beats+0
	ADDWF      R0+0, 1
	MOVLW      hi_addr(_beats+0)
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      R0+1, 1
	MOVF       R0+0, 0
	MOVWF      ___DoICPAddr+0
	MOVF       R0+1, 0
	MOVWF      ___DoICPAddr+1
	CALL       _____DoICP+0
	MOVWF      R0+0
	INCF       ___DoICPAddr+0, 1
	BTFSC      STATUS+0, 2
	INCF       ___DoICPAddr+1, 1
	CALL       _____DoICP+0
	MOVWF      R0+1
	MOVLW      147
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	MOVF       R0+0, 0
	MOVWF      PlaySong_dur_L0+0
	MOVF       R0+1, 0
	MOVWF      PlaySong_dur_L0+1
;MyProject.c,67 :: 		if (dur <= 0) dur = 1;
	MOVLW      128
	MOVWF      R2+0
	MOVLW      128
	XORWF      R0+1, 0
	SUBWF      R2+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__PlaySong48
	MOVF       R0+0, 0
	SUBLW      0
L__PlaySong48:
	BTFSS      STATUS+0, 0
	GOTO       L_PlaySong12
	MOVLW      1
	MOVWF      PlaySong_dur_L0+0
	MOVLW      0
	MOVWF      PlaySong_dur_L0+1
L_PlaySong12:
;MyProject.c,69 :: 		if (notes[i] != ' ') playNote(notes[i], dur);
	MOVF       PlaySong_i_L0+0, 0
	ADDLW      _notes+0
	MOVWF      R0+0
	MOVLW      hi_addr(_notes+0)
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      PlaySong_i_L0+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      ___DoICPAddr+0
	MOVF       R0+1, 0
	MOVWF      ___DoICPAddr+1
	CALL       _____DoICP+0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      32
	BTFSC      STATUS+0, 2
	GOTO       L_PlaySong13
	MOVF       PlaySong_i_L0+0, 0
	ADDLW      _notes+0
	MOVWF      R0+0
	MOVLW      hi_addr(_notes+0)
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      PlaySong_i_L0+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      ___DoICPAddr+0
	MOVF       R0+1, 0
	MOVWF      ___DoICPAddr+1
	CALL       _____DoICP+0
	MOVWF      FARG_playNote_note+0
	MOVF       PlaySong_dur_L0+0, 0
	MOVWF      FARG_playNote_duration_ms+0
	MOVF       PlaySong_dur_L0+1, 0
	MOVWF      FARG_playNote_duration_ms+1
	CALL       _playNote+0
	GOTO       L_PlaySong14
L_PlaySong13:
;MyProject.c,70 :: 		else delay_ms_var(dur);
	MOVF       PlaySong_dur_L0+0, 0
	MOVWF      FARG_delay_ms_var_ms+0
	MOVF       PlaySong_dur_L0+1, 0
	MOVWF      FARG_delay_ms_var_ms+1
	CALL       _delay_ms_var+0
L_PlaySong14:
;MyProject.c,72 :: 		delay_ms_var(dur / 10);
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       PlaySong_dur_L0+0, 0
	MOVWF      R0+0
	MOVF       PlaySong_dur_L0+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	MOVF       R0+0, 0
	MOVWF      FARG_delay_ms_var_ms+0
	MOVF       R0+1, 0
	MOVWF      FARG_delay_ms_var_ms+1
	CALL       _delay_ms_var+0
;MyProject.c,65 :: 		for ( i = 0; i < length; i++) {
	INCF       PlaySong_i_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       PlaySong_i_L0+1, 1
;MyProject.c,73 :: 		}
	GOTO       L_PlaySong9
L_PlaySong10:
;MyProject.c,74 :: 		}
L_end_PlaySong:
	RETURN
; end of _PlaySong

_PlayLobby:

;MyProject.c,77 :: 		void PlayLobby() {
;MyProject.c,80 :: 		for ( i = 0; i < 20; i++) {
	CLRF       PlayLobby_i_L0+0
	CLRF       PlayLobby_i_L0+1
L_PlayLobby15:
	MOVLW      128
	XORWF      PlayLobby_i_L0+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__PlayLobby50
	MOVLW      20
	SUBWF      PlayLobby_i_L0+0, 0
L__PlayLobby50:
	BTFSC      STATUS+0, 0
	GOTO       L_PlayLobby16
;MyProject.c,81 :: 		dur = (25000 / tempo) * beats[i];
	MOVF       PlayLobby_i_L0+0, 0
	MOVWF      R0+0
	MOVF       PlayLobby_i_L0+1, 0
	MOVWF      R0+1
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
	MOVLW      _beats+0
	ADDWF      R0+0, 1
	MOVLW      hi_addr(_beats+0)
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      R0+1, 1
	MOVF       R0+0, 0
	MOVWF      ___DoICPAddr+0
	MOVF       R0+1, 0
	MOVWF      ___DoICPAddr+1
	CALL       _____DoICP+0
	MOVWF      R0+0
	INCF       ___DoICPAddr+0, 1
	BTFSC      STATUS+0, 2
	INCF       ___DoICPAddr+1, 1
	CALL       _____DoICP+0
	MOVWF      R0+1
	MOVLW      147
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	MOVF       R0+0, 0
	MOVWF      PlayLobby_dur_L0+0
	MOVF       R0+1, 0
	MOVWF      PlayLobby_dur_L0+1
;MyProject.c,82 :: 		if (notes[i] != ' ') playNote(notes[i], dur);
	MOVF       PlayLobby_i_L0+0, 0
	ADDLW      _notes+0
	MOVWF      R0+0
	MOVLW      hi_addr(_notes+0)
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      PlayLobby_i_L0+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      ___DoICPAddr+0
	MOVF       R0+1, 0
	MOVWF      ___DoICPAddr+1
	CALL       _____DoICP+0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      32
	BTFSC      STATUS+0, 2
	GOTO       L_PlayLobby18
	MOVF       PlayLobby_i_L0+0, 0
	ADDLW      _notes+0
	MOVWF      R0+0
	MOVLW      hi_addr(_notes+0)
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      PlayLobby_i_L0+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      ___DoICPAddr+0
	MOVF       R0+1, 0
	MOVWF      ___DoICPAddr+1
	CALL       _____DoICP+0
	MOVWF      FARG_playNote_note+0
	MOVF       PlayLobby_dur_L0+0, 0
	MOVWF      FARG_playNote_duration_ms+0
	MOVF       PlayLobby_dur_L0+1, 0
	MOVWF      FARG_playNote_duration_ms+1
	CALL       _playNote+0
	GOTO       L_PlayLobby19
L_PlayLobby18:
;MyProject.c,83 :: 		else delay_ms_var(dur);
	MOVF       PlayLobby_dur_L0+0, 0
	MOVWF      FARG_delay_ms_var_ms+0
	MOVF       PlayLobby_dur_L0+1, 0
	MOVWF      FARG_delay_ms_var_ms+1
	CALL       _delay_ms_var+0
L_PlayLobby19:
;MyProject.c,84 :: 		delay_ms_var(dur / 10);
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       PlayLobby_dur_L0+0, 0
	MOVWF      R0+0
	MOVF       PlayLobby_dur_L0+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	MOVF       R0+0, 0
	MOVWF      FARG_delay_ms_var_ms+0
	MOVF       R0+1, 0
	MOVWF      FARG_delay_ms_var_ms+1
	CALL       _delay_ms_var+0
;MyProject.c,80 :: 		for ( i = 0; i < 20; i++) {
	INCF       PlayLobby_i_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       PlayLobby_i_L0+1, 1
;MyProject.c,85 :: 		}
	GOTO       L_PlayLobby15
L_PlayLobby16:
;MyProject.c,86 :: 		}
L_end_PlayLobby:
	RETURN
; end of _PlayLobby

_PlayGameOver:

;MyProject.c,89 :: 		void PlayGameOver() {
;MyProject.c,92 :: 		for (i = 20; i < 40; i++) {
	MOVLW      20
	MOVWF      PlayGameOver_i_L0+0
	MOVLW      0
	MOVWF      PlayGameOver_i_L0+1
L_PlayGameOver20:
	MOVLW      128
	XORWF      PlayGameOver_i_L0+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__PlayGameOver52
	MOVLW      40
	SUBWF      PlayGameOver_i_L0+0, 0
L__PlayGameOver52:
	BTFSC      STATUS+0, 0
	GOTO       L_PlayGameOver21
;MyProject.c,93 :: 		dur = (25000 / tempo) * beats[i];
	MOVF       PlayGameOver_i_L0+0, 0
	MOVWF      R0+0
	MOVF       PlayGameOver_i_L0+1, 0
	MOVWF      R0+1
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
	MOVLW      _beats+0
	ADDWF      R0+0, 1
	MOVLW      hi_addr(_beats+0)
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      R0+1, 1
	MOVF       R0+0, 0
	MOVWF      ___DoICPAddr+0
	MOVF       R0+1, 0
	MOVWF      ___DoICPAddr+1
	CALL       _____DoICP+0
	MOVWF      R0+0
	INCF       ___DoICPAddr+0, 1
	BTFSC      STATUS+0, 2
	INCF       ___DoICPAddr+1, 1
	CALL       _____DoICP+0
	MOVWF      R0+1
	MOVLW      147
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	MOVF       R0+0, 0
	MOVWF      PlayGameOver_dur_L0+0
	MOVF       R0+1, 0
	MOVWF      PlayGameOver_dur_L0+1
;MyProject.c,94 :: 		if (notes[i] != ' ') playNote(notes[i], dur);
	MOVF       PlayGameOver_i_L0+0, 0
	ADDLW      _notes+0
	MOVWF      R0+0
	MOVLW      hi_addr(_notes+0)
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      PlayGameOver_i_L0+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      ___DoICPAddr+0
	MOVF       R0+1, 0
	MOVWF      ___DoICPAddr+1
	CALL       _____DoICP+0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      32
	BTFSC      STATUS+0, 2
	GOTO       L_PlayGameOver23
	MOVF       PlayGameOver_i_L0+0, 0
	ADDLW      _notes+0
	MOVWF      R0+0
	MOVLW      hi_addr(_notes+0)
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      PlayGameOver_i_L0+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      ___DoICPAddr+0
	MOVF       R0+1, 0
	MOVWF      ___DoICPAddr+1
	CALL       _____DoICP+0
	MOVWF      FARG_playNote_note+0
	MOVF       PlayGameOver_dur_L0+0, 0
	MOVWF      FARG_playNote_duration_ms+0
	MOVF       PlayGameOver_dur_L0+1, 0
	MOVWF      FARG_playNote_duration_ms+1
	CALL       _playNote+0
	GOTO       L_PlayGameOver24
L_PlayGameOver23:
;MyProject.c,95 :: 		else delay_ms_var(dur);
	MOVF       PlayGameOver_dur_L0+0, 0
	MOVWF      FARG_delay_ms_var_ms+0
	MOVF       PlayGameOver_dur_L0+1, 0
	MOVWF      FARG_delay_ms_var_ms+1
	CALL       _delay_ms_var+0
L_PlayGameOver24:
;MyProject.c,96 :: 		delay_ms_var(dur / 10);
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       PlayGameOver_dur_L0+0, 0
	MOVWF      R0+0
	MOVF       PlayGameOver_dur_L0+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	MOVF       R0+0, 0
	MOVWF      FARG_delay_ms_var_ms+0
	MOVF       R0+1, 0
	MOVWF      FARG_delay_ms_var_ms+1
	CALL       _delay_ms_var+0
;MyProject.c,92 :: 		for (i = 20; i < 40; i++) {
	INCF       PlayGameOver_i_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       PlayGameOver_i_L0+1, 1
;MyProject.c,97 :: 		}
	GOTO       L_PlayGameOver20
L_PlayGameOver21:
;MyProject.c,98 :: 		}
L_end_PlayGameOver:
	RETURN
; end of _PlayGameOver

_PlayReset:

;MyProject.c,101 :: 		void PlayReset() {
;MyProject.c,104 :: 		for (i = 40; i < 60; i++) {
	MOVLW      40
	MOVWF      PlayReset_i_L0+0
	MOVLW      0
	MOVWF      PlayReset_i_L0+1
L_PlayReset25:
	MOVLW      128
	XORWF      PlayReset_i_L0+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__PlayReset54
	MOVLW      60
	SUBWF      PlayReset_i_L0+0, 0
L__PlayReset54:
	BTFSC      STATUS+0, 0
	GOTO       L_PlayReset26
;MyProject.c,105 :: 		dur = (25000 / tempo) * beats[i];
	MOVF       PlayReset_i_L0+0, 0
	MOVWF      R0+0
	MOVF       PlayReset_i_L0+1, 0
	MOVWF      R0+1
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
	MOVLW      _beats+0
	ADDWF      R0+0, 1
	MOVLW      hi_addr(_beats+0)
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      R0+1, 1
	MOVF       R0+0, 0
	MOVWF      ___DoICPAddr+0
	MOVF       R0+1, 0
	MOVWF      ___DoICPAddr+1
	CALL       _____DoICP+0
	MOVWF      R0+0
	INCF       ___DoICPAddr+0, 1
	BTFSC      STATUS+0, 2
	INCF       ___DoICPAddr+1, 1
	CALL       _____DoICP+0
	MOVWF      R0+1
	MOVLW      147
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	MOVF       R0+0, 0
	MOVWF      PlayReset_dur_L0+0
	MOVF       R0+1, 0
	MOVWF      PlayReset_dur_L0+1
;MyProject.c,106 :: 		if (notes[i] != ' ') playNote(notes[i], dur);
	MOVF       PlayReset_i_L0+0, 0
	ADDLW      _notes+0
	MOVWF      R0+0
	MOVLW      hi_addr(_notes+0)
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      PlayReset_i_L0+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      ___DoICPAddr+0
	MOVF       R0+1, 0
	MOVWF      ___DoICPAddr+1
	CALL       _____DoICP+0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      32
	BTFSC      STATUS+0, 2
	GOTO       L_PlayReset28
	MOVF       PlayReset_i_L0+0, 0
	ADDLW      _notes+0
	MOVWF      R0+0
	MOVLW      hi_addr(_notes+0)
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      PlayReset_i_L0+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      ___DoICPAddr+0
	MOVF       R0+1, 0
	MOVWF      ___DoICPAddr+1
	CALL       _____DoICP+0
	MOVWF      FARG_playNote_note+0
	MOVF       PlayReset_dur_L0+0, 0
	MOVWF      FARG_playNote_duration_ms+0
	MOVF       PlayReset_dur_L0+1, 0
	MOVWF      FARG_playNote_duration_ms+1
	CALL       _playNote+0
	GOTO       L_PlayReset29
L_PlayReset28:
;MyProject.c,107 :: 		else delay_ms_var(dur);
	MOVF       PlayReset_dur_L0+0, 0
	MOVWF      FARG_delay_ms_var_ms+0
	MOVF       PlayReset_dur_L0+1, 0
	MOVWF      FARG_delay_ms_var_ms+1
	CALL       _delay_ms_var+0
L_PlayReset29:
;MyProject.c,108 :: 		delay_ms_var(dur / 10);
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       PlayReset_dur_L0+0, 0
	MOVWF      R0+0
	MOVF       PlayReset_dur_L0+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	MOVF       R0+0, 0
	MOVWF      FARG_delay_ms_var_ms+0
	MOVF       R0+1, 0
	MOVWF      FARG_delay_ms_var_ms+1
	CALL       _delay_ms_var+0
;MyProject.c,104 :: 		for (i = 40; i < 60; i++) {
	INCF       PlayReset_i_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       PlayReset_i_L0+1, 1
;MyProject.c,109 :: 		}
	GOTO       L_PlayReset25
L_PlayReset26:
;MyProject.c,110 :: 		}
L_end_PlayReset:
	RETURN
; end of _PlayReset

_main:

;MyProject.c,113 :: 		void main() {
;MyProject.c,114 :: 		ANSEL = 0;         // Desactivar entradas analógicas
	CLRF       ANSEL+0
;MyProject.c,115 :: 		ANSELH = 0;
	CLRF       ANSELH+0
;MyProject.c,116 :: 		C1ON_bit = 0;      // Apagar comparadores
	BCF        C1ON_bit+0, BitPos(C1ON_bit+0)
;MyProject.c,117 :: 		C2ON_bit = 0;
	BCF        C2ON_bit+0, BitPos(C2ON_bit+0)
;MyProject.c,119 :: 		TRISB = 0xFF;       // PORTB como entrada (RB0, RB1, RB2)
	MOVLW      255
	MOVWF      TRISB+0
;MyProject.c,120 :: 		TRISC = 0x00;       // PORTC como salida (para buzzer en RC3)
	CLRF       TRISC+0
;MyProject.c,122 :: 		Sound_Init(&PORTC, 3);  // Buzzer en RC3
	MOVLW      PORTC+0
	MOVWF      FARG_Sound_Init_snd_port+0
	MOVLW      3
	MOVWF      FARG_Sound_Init_snd_pin+0
	CALL       _Sound_Init+0
;MyProject.c,124 :: 		while(1) {
L_main30:
;MyProject.c,125 :: 		if (RB0_bit == 1) {      // Señal desde Arduino PC0 - Game Over
	BTFSS      RB0_bit+0, BitPos(RB0_bit+0)
	GOTO       L_main32
;MyProject.c,126 :: 		PlayGameOver();
	CALL       _PlayGameOver+0
;MyProject.c,127 :: 		while (RB0_bit);     // Espera hasta que se libere
L_main33:
	BTFSS      RB0_bit+0, BitPos(RB0_bit+0)
	GOTO       L_main34
	GOTO       L_main33
L_main34:
;MyProject.c,128 :: 		}
L_main32:
;MyProject.c,130 :: 		if (RB1_bit == 1) {      // Señal desde Arduino PC1 - Reset
	BTFSS      RB1_bit+0, BitPos(RB1_bit+0)
	GOTO       L_main35
;MyProject.c,131 :: 		PlayReset();
	CALL       _PlayReset+0
;MyProject.c,132 :: 		while (RB1_bit);
L_main36:
	BTFSS      RB1_bit+0, BitPos(RB1_bit+0)
	GOTO       L_main37
	GOTO       L_main36
L_main37:
;MyProject.c,133 :: 		}
L_main35:
;MyProject.c,135 :: 		if (RB2_bit == 1) {      // Señal desde Arduino PC2 - Lobby / Nivel
	BTFSS      RB2_bit+0, BitPos(RB2_bit+0)
	GOTO       L_main38
;MyProject.c,136 :: 		PlayLobby();
	CALL       _PlayLobby+0
;MyProject.c,137 :: 		while (RB2_bit);
L_main39:
	BTFSS      RB2_bit+0, BitPos(RB2_bit+0)
	GOTO       L_main40
	GOTO       L_main39
L_main40:
;MyProject.c,138 :: 		}
L_main38:
;MyProject.c,139 :: 		}
	GOTO       L_main30
;MyProject.c,140 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
