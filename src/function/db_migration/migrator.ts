import Umzug from 'umzug';
import * as path from 'path';
import db from '../services/db';

const umzug = new Umzug({
    storage: 'sequelize',
    storageOptions: {
        sequelize: db
    },
    logging: (...args) => console.log.apply(null, args),
    migrations: {
        path: path.join(__dirname, './migrations'),
        pattern: /\.js$/,
        params: [
            db.getQueryInterface()
        ]
    }
});

export async function migrate() {
    console.log("Running migrations.");
    
    try {
        console.log(`Trying to connect to: ${process.env.PGHOST}`);
        await db.authenticate();
        console.log(`Database connection OK!`);

    } catch (error) {
        console.log(`Unable to connect to the database:`);
        console.log(error.message);
    }

    await umzug.up();
}

export async function rollback() {
    console.log("Rollback migrations.");
    await umzug.down();
}