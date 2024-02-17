const file = "/etc/v2ray/config.json";
const uuid = process?.argv[2];
const fs = require("fs");

const file_data = fs.readFileSync(file, "utf-8");

let json = JSON.parse(file_data);

let inbounds_array = json?.inbounds;

inbounds_array.map((item, index) => {
    const clients = item.settings.clients;

    const find_id = clients.findIndex(obj => obj?.id == uuid);

    if (find_id >= 0) {
        clients.splice(find_id, 1);
        inbounds_array[index].settings.clients = clients;

        if (index == inbounds_array.length - 1) {
            fs.writeFileSync(file, JSON.stringify(json, null, 2), "utf-8");
        };
    };
});
