const { promisify } = require('util');
const { exec } = require('child_process');
const fs = require('fs');

const promisifiedExec = promisify(exec);

async function runCommand(user, position) {
    const { username, password, validate, limite } = user;

    const command = `./create_user.sh ${username} ${password} ${validate} ${limite}`;

    try {
        const { stdout, stderr } = await promisifiedExec(command);
        console.log({
            position,
            username,
            stdout,
            stderr
        })
    } catch (error) {
        console.error(error);
    }
}

(async () => {
    try {
        const data = fs.readFileSync('/root/users.json', { encoding: "utf-8" });
        const users = JSON.parse(data);
        let i = 0;
        for (const user of users) {
            i++
            await runCommand(user, i);
        }
    } catch (err) {
        console.log(`Falha ao restaurar backup: ` + err);
    }
})();
