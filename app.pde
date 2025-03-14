int playerX, playerY;
int playerSpeed = 5;
ArrayList<Bullet> bullets;
ArrayList<Asteroid> asteroids;
int enemySpawnRate = 60;
int score = 0;
String screen = "intro";  // Change initial screen to "intro"
int level = 1;
float playerHealth = 100;
boolean canShoot = true; // Flag to track shooting

void setup() {
  size(600, 800);
  playerX = width / 2;
  playerY = height - 50;
  bullets = new ArrayList<Bullet>();
  asteroids = new ArrayList<Asteroid>();
}

void draw() {
  if (screen.equals("intro")) {
    showAsteroidIntro();
  } else if (screen.equals("menu")) {
    showMenu();
  } else if (screen.equals("play")) {
    playGame();
  } else if (screen.equals("gameover")) {
    showGameOver();
  }
}

void showAsteroidIntro() {
  background(0);
  fill(255);
  textSize(24);
  textAlign(CENTER, TOP);
  text("Asteroid Types", width / 2, 50);
  
  textSize(18);
  textAlign(LEFT, TOP);
  text("1. Green Asteroid: Health: 1, Points: 10, Damage: 5", 50, 150);
  text("2. Yellow Asteroid: Health: 2, Points: 20, Damage: 15", 50, 180);
  text("3. Red Asteroid: Health: 4, Points: 50, Damage: 25", 50, 210);
  
  textSize(16);
  textAlign(LEFT, TOP);
  text("Controls:", 50, 250);
  text("A - Move Left", 50, 280);
  text("D - Move Right", 50, 310);
  text("Space - Shoot", 50, 340);
  
  drawButton("Continue", width / 2 - 50, height - 100, 100, 40, color(0, 255, 255));
}


void showMenu() {
  background(0);
  fill(255);
  textSize(30);
  textAlign(CENTER);
  text("Select Level", width / 2, height / 3);
  drawButton("Easy", width / 2 - 50, height / 2, 100, 40, color(0, 255, 0));
  drawButton("Medium", width / 2 - 50, height / 2 + 60, 100, 40, color(255, 255, 0));
  drawButton("Hard", width / 2 - 50, height / 2 + 120, 100, 40, color(255, 0, 0));
}

void playGame() {
  background(0);
  drawPlayer();
  movePlayer();
  handleBullets();
  handleAsteroids();
  checkCollisions();
  showScore();
  showHealth();
  if (playerHealth <= 0) {
    screen = "gameover";
  }
}

void showGameOver() {
  background(0);
  fill(255, 0, 0);
  textSize(30);
  textAlign(CENTER);
  text("Game Over!", width / 2, height / 2);
  text("Score: " + score, width / 2, height / 2 + 50);
  drawButton("Restart", width / 2 - 50, height / 2 + 100, 100, 40, color(0, 255, 255));
  drawButton("Menu", width / 2 - 50, height / 2 + 160, 100, 40, color(255, 255, 255));
}

void drawButton(String label, int x, int y, int w, int h, int col) {
  fill(col);
  rect(x, y, w, h, 10);
  fill(0);
  textSize(20);
  textAlign(CENTER, CENTER);
  text(label, x + w / 2, y + h / 2);
}

void drawPlayer() {
  fill(0, 0, 255);
  triangle(playerX, playerY, playerX - 20, playerY + 30, playerX + 20, playerY + 30);
}

void movePlayer() {
  if (keyPressed) {
    if (key == 'a' && playerX > 20) {
      playerX -= playerSpeed;
    } else if (key == 'd' && playerX < width - 20) {
      playerX += playerSpeed;
    }
    if (key == ' ' && canShoot) {  // Only shoot if canShoot is true
      shoot();
      canShoot = false;  // Prevent continuous shooting while holding spacebar
    }
  }
}

void keyReleased() {
  if (key == ' ') {
    canShoot = true;  // Allow shooting again after spacebar is released
  }
}

void shoot() {
  bullets.add(new Bullet(playerX, playerY - 20));  // Shoot bullet from the player's position
}

void handleBullets() {
  for (int i = bullets.size() - 1; i >= 0; i--) {
    Bullet b = bullets.get(i);
    b.move();
    b.display();
    if (b.y < 0) {
      bullets.remove(i);
    }
  }
}

void handleAsteroids() {
  if (frameCount % enemySpawnRate == 0) {
    asteroids.add(new Asteroid(int(random(20, width - 20)), 0, int(random(3)))); 
  }
  for (int i = asteroids.size() - 1; i >= 0; i--) {
    Asteroid a = asteroids.get(i);
    a.move();
    a.display();
    if (a.y > height) {
      asteroids.remove(i);
    }
  }
}

void checkCollisions() {
  for (int i = bullets.size() - 1; i >= 0; i--) {
    Bullet b = bullets.get(i);
    for (int j = asteroids.size() - 1; j >= 0; j--) {
      Asteroid a = asteroids.get(j);
      if (dist(b.x, b.y, a.x, a.y) < 25) {
        a.health -= 1;
        if (a.health <= 0) {
          score += a.points;
          asteroids.remove(j);
        }
        bullets.remove(i);
        break;
      }
    }
  }
  for (int i = asteroids.size() - 1; i >= 0; i--) {
    Asteroid a = asteroids.get(i);
    if (dist(playerX, playerY, a.x, a.y) < 30) {
      playerHealth -= a.damage;
      asteroids.remove(i);
    }
  }
}

void showScore() {
  fill(255);
  textSize(20);
  textAlign(RIGHT, TOP);  
  text("Score: " + score, width - 10, 10);  
}

void showHealth() {
  fill(255);
  textSize(20);
  textAlign(LEFT, TOP);  
  text("Health Points", 10, 10);  
  
  fill(255, 0, 0);
  rect(10, 35, playerHealth * 2, 10); 
}

void mousePressed() {
  if (screen.equals("intro")) {  // If on the asteroid intro screen
    screen = "menu";  // Go to the level selection menu
  } else if (screen.equals("menu")) {
    if (mouseY > height / 2 && mouseY < height / 2 + 40) {
      level = 1;
      enemySpawnRate = 80;
      screen = "play";
    } else if (mouseY > height / 2 + 60 && mouseY < height / 2 + 100) {
      level = 2;
      enemySpawnRate = 50;
      screen = "play";
    } else if (mouseY > height / 2 + 120 && mouseY < height / 2 + 160) {
      level = 3;
      enemySpawnRate = 30;
      screen = "play";
    }
  } else if (screen.equals("gameover")) {
    if (mouseY > height / 2 + 100 && mouseY < height / 2 + 140) {
      screen = "play";
      score = 0;
      playerHealth = 100;
      asteroids.clear();
      bullets.clear();
    } else if (mouseY > height / 2 + 160 && mouseY < height / 2 + 200) {
      screen = "menu";
    }
  }
}

class Bullet {
  int x, y;
  int speed = 10;
  Bullet(int x, int y) {
    this.x = x;
    this.y = y;
  }
  void move() { y -= speed; }
  void display() { fill(255, 0, 0); ellipse(x, y, 5, 10); }
}

class Asteroid {
  int x, y, type;
  int health, points, damage;
  Asteroid(int x, int y, int type) {
    this.x = x;
    this.y = y;
    this.type = type;
    if (type == 0) { health = 1; points = 10; damage = 5; }
    else if (type == 1) { health = 2; points = 20; damage = 15; }
    else { health = 4; points = 50; damage = 25; }
  }
  void move() { y += 3 + type; }
  void display() { fill(type == 0 ? color(0, 255, 0) : type == 1 ? color(255, 255, 0) : color(255, 0, 0)); ellipse(x, y, 30, 30); }
}
