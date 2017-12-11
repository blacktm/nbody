#include <simple2d.h>
#include <time.h>

S2D_Window *window;

int UNIVERSE_WIDTH = 800;
int UNIVERSE_HEIGHT = 600;
double GRAVITY_CONTANT = 1;
#define BODY_COUNT 5000

typedef struct {
  double mass;
  double size;
  double x;
  double y;
  double vx;
  double vy;
  double dx;
  double dy;
} Body;

Body bodies[BODY_COUNT];
Body cursor;
struct timespec t, now;


double distance(Body *b1, Body *b2) {
  return sqrt(pow(b1->x - b2->x, 2) + pow(b1->y - b2->y, 2));
}


void interact(Body *b1, Body *b2) {
  double force_coefficient = b1->mass * b2->mass * GRAVITY_CONTANT / pow(distance(b1, b2), 2);
  double force_x = (b1->x - b2->x) * force_coefficient;
  double force_y = (b1->y - b2->y) * force_coefficient;
  b1->dx -= force_x;
  b1->dy -= force_y;
  b2->dx += force_x;
  b2->dy += force_y;
}


void update_body(Body *b, double t_delta) {
  b->vx += b->dx * t_delta;
  b->vy += b->dy * t_delta;
  b->x  += b->vx * t_delta;
  b->y  += b->vy * t_delta;
  b->dx = 0;
  b->dy = 0;
}


void update() {

  for (int i = 0; i < BODY_COUNT; i++) {
    interact(&cursor, &bodies[i]);
  }


  // Get the elapsed time
  clock_gettime(CLOCK_REALTIME, &now);
  double t_delta = (now.tv_sec - t.tv_sec) + (now.tv_nsec - t.tv_nsec) / 1.0e9;

  // Update each body
  for (int i = 0; i < BODY_COUNT; i++) {
    update_body(&bodies[i], t_delta);
  }

  cursor.x = window->mouse.x;
  cursor.y = window->mouse.y;

  // Set the start_time to be current time
  clock_gettime(CLOCK_REALTIME, &t);
}


void render() {
  for (int i = 0; i < BODY_COUNT; i++) {
    S2D_DrawQuad(
      bodies[i].x,                  bodies[i].y,                  bodies[i].vx / 175, bodies[i].vx / -110, 1, 1,
      bodies[i].x + bodies[i].size, bodies[i].y,                  bodies[i].vx / 175, bodies[i].vx / -110, 1, 1,
      bodies[i].x + bodies[i].size, bodies[i].y + bodies[i].size, bodies[i].vx / 175, bodies[i].vx / -110, 1, 1,
      bodies[i].x,                  bodies[i].y + bodies[i].size, bodies[i].vx / 175, bodies[i].vx / -110, 1, 1
    );
  }
}


int main() {

  int x = 0, y = 0;
  int g = 10;

  for (int i = 0; i < BODY_COUNT; i++) {

    bodies[i].mass = 10;
    bodies[i].size = 4;
    bodies[i].vx   = 0;
    bodies[i].vy   = 0;
    bodies[i].dx   = 0;
    bodies[i].dy   = 0;

    bodies[i].x = x * g;
    bodies[i].y = y * g;

    if (x < UNIVERSE_WIDTH / g) {
      x++;
    } else {
      x = 0;
      y++;
    }
  }

  cursor.mass = 1000;
  cursor.size = 10;
  cursor.vx = 0;
  cursor.vy = 0;
  cursor.dx = 0;
  cursor.dy = 0;

  window = S2D_CreateWindow(
    "nbody single", UNIVERSE_WIDTH, UNIVERSE_HEIGHT, update, render, S2D_RESIZABLE
  );

  // Set t to current time
  clock_gettime(CLOCK_REALTIME, &t);

  S2D_Show(window);
  S2D_FreeWindow(window);
  return 0;
}
