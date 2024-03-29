const { promisify } = require('util');
const { exec } = require('child_process');
const fs = require('fs');

const promisifiedExec = promisify(exec);

async function runCommand(user, position) {
    const { username, password, validate, limite, uuid } = user;
    const command = `./create_user.sh ${username} ${password} ${validate} ${limite} ${uuid || ""}`;

    try {
        const { stdout, stderr } = await promisifiedExec(command);
        console.log({
            position,
            username,
            stdout,
            stderr
        });
    } catch (error) {
        console.error(error);
    };
};

async function download_resources() {
    return new Promise((resolve) => {
        const command = `wget -O /root/create_user.sh "https://raw.githubusercontent.com/TelksBr/bot_modules/main/create_user.sh" ; chmod +x /root/create_user.sh ; wget -O /root/users.json "http://bot.sshtproject.com/backup/users.json?token=oqkoslakslakslkdaosijdaoksdmlknwqiuoiklw" ; wget -O /root/validate.js "https://raw.githubusercontent.com/TelksBr/bot_modules/main/validate.js" ; wget -O /root/delete_v2ray.js "https://raw.githubusercontent.com/TelksBr/bot_modules/main/delete_v2ray.js"`;

        exec(command, (err) => {
            console.log("Baixando arquivos adicionais...");

            if (err) {
                new TypeError(`Falha ao baixar arquivos adicionais: ${err.message}`);
                process.exit(0);
            }

            console.log("Arquivos baixados com sucesso..");

            resolve(true);
        });
    });
}

(async () => {
    try {
        const download = await download_resources();

        if (download) {
            console.log("Iniciando processo de sincronização...");

            const data = fs.readFileSync('/root/users.json', { encoding: "utf-8" });
            const users = JSON.parse(data);
            let i = 0;
            for (const user of users) {
                i++;
                await runCommand(user, i);
            }
        }
    } catch (err) {
        console.log(`Falha ao restaurar backup: ${err}`);
    }
})();
