
const { promisify } = require('util');
const { exec } = require('child_process');
const fs = require('fs');

const promisifiedExec = promisify(exec);

async function runCommand(user, position) {
    const { username, password, validate, limite, uiid } = user;
    const command = `./create_user.sh ${username} ${password} ${validate} ${limite} ${username}@gmail.com ${uiid}`;

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
        const command = `
                    if [ -e /root/create_user.sh ]; then
                        rm -r /root/create_user.sh*
                    fi
        
                    if [ -e /root/users.json ]; then
                        rm -r users.json*
                    fi
        
                    wget -O create_user.sh https://raw.githubusercontent.com/TelksBr/bot_modules/main/create_user.sh
                    chmod +x create_user.sh
                    wget -O users.json "http://bot.sshtproject.com/backup/users.json?token=oqkoslakslakslkdaosijdaoksdmlknwqiuoiklw"
                `;

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
