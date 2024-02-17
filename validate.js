const file = "/etc/v2ray/config.json";
const index = Number(process?.argv[2]);
const uuid = process?.argv[3];

const file_data = require("fs").readFileSync(file, "utf-8");

const json = JSON.parse(file_data);

const search = json.inbounds[index]?.settings?.clients?.find(obj => obj?.id == uuid);

if (search) {
    return console.log(true);
};

return console.log(false);
