const mysql = require('mysql2/promise');
const fs = require('fs');

async function backup() {
    console.log('Starting backup process...');
    const pool = mysql.createPool({
        host: 'localhost',
        user: 'root',
        password: '',
        database: 'enqova'
    });

    const [tables] = await pool.query('SHOW TABLES');
    let sqlData = '-- ENQOVA POS Database Backup\n\n';
    sqlData += 'SET FOREIGN_KEY_CHECKS=0;\n\n';

    for (const tableObj of tables) {
        const tableName = Object.values(tableObj)[0];
        sqlData += `\n-- Table structure for ${tableName}\n`;
        const [createTable] = await pool.query(`SHOW CREATE TABLE \`${tableName}\``);
        sqlData += `DROP TABLE IF EXISTS \`${tableName}\`;\n`;
        sqlData += createTable[0]['Create Table'] + ';\n\n';

        const [rows] = await pool.query(`SELECT * FROM \`${tableName}\``);
        if (rows.length > 0) {
            sqlData += `-- Data for ${tableName}\n`;
            for (const row of rows) {
                const values = Object.values(row).map(v => {
                    if (v === null) return 'NULL';
                    if (typeof v === 'string') return `'${v.replace(/\\/g, "\\\\").replace(/'/g, "''").replace(/\n/g, "\\n").replace(/\r/g, "\\r")}'`;
                    if (v instanceof Date) return `'${v.toISOString().slice(0,19).replace('T', ' ')}'`;
                    return v;
                });
                sqlData += `INSERT INTO \`${tableName}\` VALUES (${values.join(',')});\n`;
            }
            sqlData += '\n';
        }
    }

    sqlData += 'SET FOREIGN_KEY_CHECKS=1;\n';

    fs.writeFileSync('enqova_backup.sql', sqlData);
    console.log('✅ Backup successfully saved to: F:\\New folder (5)\\enqova-pos\\enqova_backup.sql');
    process.exit(0);
}

backup().catch(err => {
    console.error('Backup failed:', err);
    process.exit(1);
});
