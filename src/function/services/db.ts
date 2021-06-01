import { Sequelize } from 'sequelize';
import item from '../models/item';

const db = new Sequelize(
  process.env.PGDB,
  process.env.PGUSER,
  process.env.PGPASSWORD,
  {
    dialect: 'postgres',
    host: process.env.PGHOST
  });

const modelDefiners = [
  item
];

for (const modelDefiner of modelDefiners) {
  modelDefiner(db);
}

export default db;