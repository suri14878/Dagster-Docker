from dagster import Definitions, load_assets_from_modules
from .assets import events 

event_assets = load_assets_from_modules([events])

defs = Definitions(
    assets=event_assets,
)
