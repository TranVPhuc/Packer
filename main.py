import platform
import time

print("👋 Hello from Jenkins Agent!")

print("\n🔍 System Information:")
print(f"Python version : {platform.python_version()}")
print(f"Platform       : {platform.system()} {platform.release()}")

print("\n⏳ Simulating some steps:")
for i in range(3):
    print(f"Step {i+1}/3...")
    time.sleep(1)

print("\n✅ Script completed successfully.")