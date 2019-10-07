import top_block
import time

print("Creating top_block class...")
tb=top_block.top_block()

print("Starting top_block...")
tb.start()
print("Started...")

time.sleep(2)

print("saving...")
tb.set_trigger(1)
time.sleep(3)
tb.set_trigger(-1)
print("stopping...")
