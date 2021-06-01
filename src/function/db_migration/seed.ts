import Umzug from 'umzug';
import * as path from 'path';
import db from '../services/db';

const umzug = new Umzug({
    storage: 'sequelize',
    storageOptions: {
        sequelize: db,
        tableName: 'SequelizeMetaSeed'
    },
    logging: (...args) => console.log.apply(null, args),
    migrations: {
        path: path.join(__dirname, './seeds'),
        pattern: /\.js$/,
        params: [
            db.getQueryInterface()
        ]
    }
});

export async function seed() {
    console.log("Seeding the database.");
    await umzug.up();
}
    
export async function rollback() {
    console.log("Rollback seeds.");
    await umzug.down();
}
