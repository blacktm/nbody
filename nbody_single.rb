require 'ruby2d'

BODY_COUNT = 5000
UNIVERSE_WIDTH = 800;
UNIVERSE_HEIGHT = 600;
GRAVITY_CONTANT = 1;
Body = Struct.new(
  :mass,
  :vx,
  :vy,
  :dx,
  :dy,
  :square
)

def distance(b1, b2)
  Math.sqrt((b1.square.x - b2.square.x)**2 + (b1.square.y - b2.square.y)**2);
end

def interact(b1, b2)
  force_coefficient = b1.mass * b2.mass * GRAVITY_CONTANT / distance(b1, b2)**2;
  force_x = (b1.square.x - b2.square.x) * force_coefficient;
  force_y = (b1.square.y - b2.square.y) * force_coefficient;
  b1.dx -= force_x;
  b1.dy -= force_y;
  b2.dx += force_x;
  b2.dy += force_y;
end

def update_body(b, t_delta)
  b.vx += b.dx * t_delta;
  b.vy += b.dy * t_delta;
  b.square.x  += b.vx * t_delta;
  b.square.y  += b.vy * t_delta;
  b.dx = 0;
  b.dy = 0;
  b.square.color = [b.vx / 175, b.vx / -110, 1, 1]
end


set title: "nbody", width: UNIVERSE_WIDTH, height: UNIVERSE_HEIGHT, resizable: true

bodies = []

x = 0
y = 0
g = 10

BODY_COUNT.times do

  body = Body.new(
    10, 0, 0, 0, 0,
    Square.new(x: x * g, y: y * g, size: 4)
  )

  if x < UNIVERSE_WIDTH / g
    x += 1
  else
    x = 0
    y += 1
  end

  bodies.push body
end

cursor = Body.new(1000, 0, 0, 0, 0, Square.new(size: 0))


on :key do |e|
  close if e.key == 'escape'
end

# Set t to current time
t = Time.now

update do
  bodies.each do |body|
    interact(cursor, body)
  end

  # Get the elapsed time
  t_delta = Time.now - t;

  # Update each body
  bodies.each do |b|
    update_body(b, t_delta);
  end

  cursor.square.x = get :mouse_x
  cursor.square.y = get :mouse_y

  # Set the start_time to be current time
  t = Time.now
end


show
