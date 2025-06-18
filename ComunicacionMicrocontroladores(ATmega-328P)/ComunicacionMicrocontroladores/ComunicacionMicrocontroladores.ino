#include <LedControl.h>

// Pin configurations
const int DIN_PIN = 12;
const int CS_PIN = 10;
const int CLK_PIN = 11;

LedControl lc = LedControl(DIN_PIN, CLK_PIN, CS_PIN, 1);

const int MATRIX_WIDTH = 8;
const int MATRIX_HEIGHT = 8;
uint8_t currentPiece[3][3];
int currentX, currentY;
unsigned long lastDropTime;
unsigned long lastRotateTime;
const int rotateDebounceTime = 300;
unsigned long startTime;
bool gameOver = false;
int score = 0;
int level = 1;
int dropInterval = 1000;
bool gameStarted = false;

bool board[MATRIX_HEIGHT][MATRIX_WIDTH] = {false};

const uint8_t shapes[7][3][3] = {
    {{1, 1, 1}, {0, 0, 0}, {0, 0, 0}},
    {{1, 1, 1}, {0, 1, 0}, {0, 0, 0}},
    {{1, 1, 0}, {0, 1, 1}, {0, 0, 0}},
    {{1, 0, 0}, {1, 1, 1}, {0, 0, 0}},
    {{1, 1, 0}, {1, 1, 0}, {0, 0, 0}},
    {{0, 1, 1}, {1, 1, 0}, {0, 0, 0}},
    {{0, 0, 1}, {1, 1, 1}, {0, 0, 0}},
};

#define LEFT_BUTTON_PRESSED   !(PIND & (1 << PD2))
#define RIGHT_BUTTON_PRESSED  !(PIND & (1 << PD3))
#define ROTATE_BUTTON_PRESSED !(PIND & (1 << PD7))

void setup() {
    DDRC |= (1 << PC0) | (1 << PC1) | (1 << PC2);
    DDRD &= ~((1 << PD2) | (1 << PD3) | (1 << PD7));
    PORTD |= (1 << PD2) | (1 << PD3) | (1 << PD7);

    lc.shutdown(0, false);
    lc.setIntensity(0, 15);
    lc.clearDisplay(0);

    lastDropTime = millis();
    lastRotateTime = 0;
    startTime = millis();
}

void loop() {
    if (!gameStarted) {
        static unsigned long lastLeftPress = 0;
        static unsigned long lastRightPress = 0;

        // Cambiar nivel
        if (LEFT_BUTTON_PRESSED && millis() - lastLeftPress > 300) {
            lastLeftPress = millis();
            level++;
            if (level > 3) level = 1;

            lc.clearDisplay(0);
            displayDigit(level, 0);  // Mostrar número del nivel
        }

        // Iniciar juego
        if (RIGHT_BUTTON_PRESSED && millis() - lastRightPress > 300) {
            lastRightPress = millis();
            gameStarted = true;
            dropInterval = 1000 / level;
            spawnPiece();
        }

        return;
    }

    if (gameOver) {
        displayGameOver();
        gameStarted = false;
        return;
    }

    static unsigned long lastLeftPress = 0;
    static unsigned long lastRightPress = 0;

    if (LEFT_BUTTON_PRESSED && millis() - lastLeftPress > 300) {
        movePiece(-1);
        lastLeftPress = millis();
    }

    if (RIGHT_BUTTON_PRESSED && millis() - lastRightPress > 300) {
        movePiece(1);
        lastRightPress = millis();
    }

    if (ROTATE_BUTTON_PRESSED && (millis() - lastRotateTime > rotateDebounceTime)) {
        rotatePiece();
        lastRotateTime = millis();
    }

    if (millis() - lastDropTime >= dropInterval) {
        dropPiece();
        lastDropTime = millis();
    }

    drawBoard();
    delay(100);
}

void spawnPiece() {
    currentX = MATRIX_WIDTH / 2 - 1;
    currentY = 0;
    int randShape = random(0, 7);
    memcpy(currentPiece, shapes[randShape], sizeof(currentPiece));
}

void movePiece(int dx) {
    if (canMove(currentX + dx, currentY)) {
        currentX += dx;
    }
}

void dropPiece() {
    if (canMove(currentX, currentY + 1)) {
        currentY++;
    } else {
        addPieceToBoard();
        checkForFullRows();
        spawnPiece();
        if (!canMove(currentX, currentY)) {
            gameOver = true;
        }
    }
}

void drawBoard() {
    lc.clearDisplay(0);
    for (int y = 0; y < MATRIX_HEIGHT; y++) {
        for (int x = 0; x < MATRIX_WIDTH; x++) {
            if (board[y][x]) {
                lc.setLed(0, y, x, true);
            }
        }
    }
    drawPiece();
}

void drawPiece() {
    for (int y = 0; y < 3; y++) {
        for (int x = 0; x < 3; x++) {
            if (currentPiece[y][x]) {
                lc.setLed(0, currentY + y, currentX + x, true);
            }
        }
    }
}

void addPieceToBoard() {
    for (int y = 0; y < 3; y++) {
        for (int x = 0; x < 3; x++) {
            if (currentPiece[y][x]) {
                board[currentY + y][currentX + x] = true;
            }
        }
    }
}

void resetGame() {
    PORTC |= (1 << PC1);
    delay(100);
    PORTC &= ~(1 << PC1);

    memset(board, false, sizeof(board));
    spawnPiece();
    currentY = 0;
    gameOver = false;
    score = 0;
}

bool canMove(int x, int y) {
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            if (currentPiece[i][j]) {
                int newX = x + j;
                int newY = y + i;
                if (newX < 0 || newX >= MATRIX_WIDTH || newY >= MATRIX_HEIGHT) {
                    return false;
                }
                if (newY >= 0 && board[newY][newX]) {
                    return false;
                }
            }
        }
    }
    return true;
}

void rotatePiece() {
    uint8_t tempPiece[3][3];
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            tempPiece[j][2 - i] = currentPiece[i][j];
        }
    }
    if (canMove(currentX, currentY)) {
        memcpy(currentPiece, tempPiece, sizeof(currentPiece));
    } else if (canMove(currentX - 1, currentY)) {
        currentX -= 1;
        memcpy(currentPiece, tempPiece, sizeof(currentPiece));
    } else if (canMove(currentX + 1, currentY)) {
        currentX += 1;
        memcpy(currentPiece, tempPiece, sizeof(currentPiece));
    }
}

void displayGameOver() {
    PORTC |= (1 << PC0);

    lc.clearDisplay(0);
    String scoreStr = String(score);
    if (scoreStr.length() > 2) {
        scoreStr = scoreStr.substring(0, 2);
    }

    for (int i = 0; i < scoreStr.length(); i++) {
        int digit = scoreStr.charAt(i) - '0';
        if (digit >= 0 && digit <= 9) {
            displayDigit(digit, i);
        }
    }

    delay(2000);
    PORTC &= ~(1 << PC0);
    resetGame();
}

void displayDigit(int digit, int pos) {
    const int digits[10][5][3]  = {
        {{1,1,1},{1,0,1},{1,0,1},{1,0,1},{1,1,1}},
        {{0,1,0},{1,1,0},{0,1,0},{0,1,0},{1,1,1}},
        {{1,1,1},{0,0,1},{1,1,1},{1,0,0},{1,1,1}},
        {{1,1,1},{0,0,1},{1,1,1},{0,0,1},{1,1,1}},
        {{1,0,1},{1,0,1},{1,1,1},{0,0,1},{0,0,1}},
        {{1,1,1},{1,0,0},{1,1,1},{0,0,1},{1,1,1}},
        {{1,1,1},{1,0,0},{1,1,1},{1,0,1},{1,1,1}},
        {{1,1,1},{0,0,1},{0,0,1},{0,0,1},{0,0,1}},
        {{1,1,1},{1,0,1},{1,1,1},{1,0,1},{1,1,1}},
        {{1,1,1},{1,0,1},{1,1,1},{0,0,1},{1,1,1}},
    };

    if (digit > 1) {
        PORTC |= (1 << PC2);
    } else {
        PORTC &= ~(1 << PC2);
    }

    if (digit < 0 || digit > 9) return;
    for (int row = 0; row < 5; row++) {
        for (int col = 0; col < 3; col++) {
            bool ledState = digits[digit][row][col];
            lc.setLed(0, row, pos * 4 + col, ledState);
        }
    }
}

void checkForFullRows() {
    for (int y = MATRIX_HEIGHT - 1; y >= 0; y--) {
        bool fullRow = true;
        for (int x = 0; x < MATRIX_WIDTH; x++) {
            if (!board[y][x]) {
                fullRow = false;
                break;
            }
        }
        if (fullRow) {
            for (int i = y; i > 0; i--) {
                for (int j = 0; j < MATRIX_WIDTH; j++) {
                    board[i][j] = board[i - 1][j];
                }
            }
            for (int j = 0; j < MATRIX_WIDTH; j++) {
                board[0][j] = false;
            }
            score++;
            y++;
        }
    }
}