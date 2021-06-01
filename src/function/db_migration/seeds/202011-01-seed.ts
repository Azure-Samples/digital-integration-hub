import db from '../../services/db';

const item_names = ["item 1", "item 2"];

module.exports = {

    up: async () => {
        await item_names.forEach(element => {
            db.models.item.create({ name: element })
        });
    },

    down: async () => {
        await item_names.forEach(element => {
            db.models.item.destroy({
                where: { name: element }
            })
        });
    }
};