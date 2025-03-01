import os
import sys
from dagster import asset

from EventTracker.event_tracker import EventManager

# @asset
# def test_asset() -> None: # turn it into a function
#     os.makedirs("data", exist_ok=True)
#     with open("data/test.txt", "w") as f:
#         f.write("Hello World")


@asset
def event_definitions() -> None:

    file_path = './dagster_IR/EventTracker/Test/data/event_definitions.csv'
    operation = 'event_definition'
    mode = 'safe'
    event_manager = EventManager()
    event_manager.process_file(file_path, operation, mode)

@asset
def semester_codes() -> None:

    file_path = './dagster_IR/EventTracker/Test/data/semester_codes.csv'
    operation = 'semester_codes'
    mode = 'safe'
    event_manager = EventManager()
    event_manager.process_file(file_path, operation, mode)


@asset(deps=[event_definitions,semester_codes])
def event_instances() -> None:

    event_manager = EventManager()
    event_manager.initialize_all_events()
    event_manager.activate_initialized_events()
    event_manager.terminate_active_events()
    event_manager.validate_completed_events()
    