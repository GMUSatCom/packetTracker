import top_block
import time

print("Creating top_block class...")
tb=top_block.top_block()

print("Starting top_block...")
tb.start()
print("Started...")

#######################################
# Testing the trigger

print("saving...")
tb.set_trigger(1)
time.sleep(2)
tb.set_trigger(-1)
print("stopping...")

time.sleep(2)

print("saving...")
tb.set_trigger(1)
time.sleep(0.5)
tb.set_trigger(-1)
print("stopping...")
