#line 1 "C:/Users/USUARIO/Desktop/SISTEMAS EMBEBIDOS PREPRACTICAS/Comunicación entre Microcontroladores/PIC16F887/MyProject.c"

const char notes[] = "cgfgegdg ggefgagfed eecdefedc=0 00caggcdefedcdcc=cde !BAGFEDC ccccc-9-c- -------989-9 99998888668468 99-ccccccc-9-c---cddr-";
const int beats[] = {
4,1,1,1,1,1,1,1,1,
2,2,1,1,1,1,2,1,2,2,1,
2,2,1,1,1,1,2,1,2,2,2,1,
1,1,2,2,2,1,3,1,1,2,
2,2,2,3,2,2,1,8,8,2,1,
2,2,2,2,2,2,2,4,1,
1,1,1,1,2,1,2,1,2,3,1,
1,1,1,1,1,1,1,1,2,1,2,3,1,
1,2,2,1,2,1,2,2,1,2,2,1,2,6,1,
1,1,1,4,1,1,1,1,1,2,1,2,
1,2,3,1,2,2,1,3,1,2,2,1,6,1,
1,1,1,2,2,1,2,2,1,4,1,
1,1,6,2,2,1,2,1,1,2,1,3,1,
1,1,1,1,1,1,2,1,1,2,1,1,2,1,
1,1,2,1,3,1,5,1,1,2,1,1,
1,2,3,1,1,1,1,10
};

const int tempo = 170;
const int length = sizeof(beats) / sizeof(beats[0]);


char names[40] = { ' ', '!', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '=', 'c', 'd', 'r', 'e', 'f', 'g', 'S', 'a', 'b','s','C', 'D', 'R', 'E', 'F', 'G', 'O', 'A', 'o', 'B', 'i', 'N', 'R', 'u', '1', 'L', 'k' };

int tones[40] = {
 0, 1046, 138, 146, 155, 164, 174, 184, 195, 207, 220, 233, 246,
 261, 293, 311, 329, 349, 391, 415, 440, 493, 466, 523, 587, 622,
 659, 698, 783, 831, 880, 932, 987, 466, 740, 622, 415, 1046, 622, 227
};


void delay_ms_var(int ms) {
 while (ms-- > 0) {
 Delay_ms(1);
 }
}


void playNote(char note, int duration_ms) {
 int freq = 0;
 int i;
 for (i = 0; i < 40; i++) {
 if (names[i] == note) {
 freq = tones[i];
 break;
 }
 }

 if (freq > 0) {
 Sound_Play(freq, duration_ms);
 delay_ms_var(duration_ms);
 Sound_Play(0, 0);
 } else {
 delay_ms_var(duration_ms);
 }
}


void PlaySong() {
 int dur;
 int i ;
 for ( i = 0; i < length; i++) {
 dur = (25000 / tempo) * beats[i];
 if (dur <= 0) dur = 1;

 if (notes[i] != ' ') playNote(notes[i], dur);
 else delay_ms_var(dur);

 delay_ms_var(dur / 10);
 }
}


void PlayLobby() {
 int dur;
 int i;
 for ( i = 0; i < 20; i++) {
 dur = (25000 / tempo) * beats[i];
 if (notes[i] != ' ') playNote(notes[i], dur);
 else delay_ms_var(dur);
 delay_ms_var(dur / 10);
 }
}


void PlayGameOver() {
 int dur;
 int i;
 for (i = 20; i < 40; i++) {
 dur = (25000 / tempo) * beats[i];
 if (notes[i] != ' ') playNote(notes[i], dur);
 else delay_ms_var(dur);
 delay_ms_var(dur / 10);
 }
}


void PlayReset() {
 int dur;
 int i;
 for (i = 40; i < 60; i++) {
 dur = (25000 / tempo) * beats[i];
 if (notes[i] != ' ') playNote(notes[i], dur);
 else delay_ms_var(dur);
 delay_ms_var(dur / 10);
 }
}


void main() {
 ANSEL = 0;
 ANSELH = 0;
 C1ON_bit = 0;
 C2ON_bit = 0;

 TRISB = 0xFF;
 TRISC = 0x00;

 Sound_Init(&PORTC, 3);

 while(1) {
 if (RB0_bit == 1) {
 PlayGameOver();
 while (RB0_bit);
 }

 if (RB1_bit == 1) {
 PlayReset();
 while (RB1_bit);
 }

 if (RB2_bit == 1) {
 PlayLobby();
 while (RB2_bit);
 }
 }
}
