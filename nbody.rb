require 'ruby2d'

BODY_COUNT = 200
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

BODY_COUNT.times do
  mass = Math.log(1 - rand) / -0.1
  body = Body.new(
    mass, 0, 0, 0, 0,
    Square.new(x: rand() * UNIVERSE_WIDTH, y: rand() * UNIVERSE_HEIGHT, size: Math.sqrt(mass)*2))
  bodies.push body
end


on :key do |e|
  close if e.key == 'escape'
end

# Set t to current time
t = Time.now

update do
  # Make each body interact with every other
  bodies.combination(2).each do |pair|
    interact(pair[0], pair[1])
  end

  # Get the elapsed time
  t_delta = Time.now - t;

  # Update each body
  bodies.each do |b|
    update_body(b, t_delta);
  end

  # Set the start_time to be current time
  t = Time.now
end


show
