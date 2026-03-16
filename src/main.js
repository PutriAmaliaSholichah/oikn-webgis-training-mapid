import { createMap } from "./map/createMap";
import { addControl } from "./controls/addControl";
import { addHandlers } from "./handlers/addHandlers";
import { addMapEvents } from "./events/addMapEvents";

const map = createMap();
addControl(map);
addHandlers(map);
addMapEvents(map);