import { DataTypes } from 'sequelize';

export async function up(query) {
    await query.createTable('items', {
            id: {
                type: DataTypes.INTEGER,
                primaryKey: true,
                autoIncrement: true,
                allowNull: false
            },
            createdAt: DataTypes.DATE,
            updatedAt: DataTypes.DATE,
            name: DataTypes.STRING
        });
    }

export async function down(query) {
    await query.dropTable('items');
}
