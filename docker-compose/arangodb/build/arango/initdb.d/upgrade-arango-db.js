const AUTH_SERVICE = {
    name: 'auth_service',
    collections: {},
};
const BLOCKCHAIN = {
    name: 'blockchain',
    collections: {
        blocks: {
            indexes: [
                sortedIndex(['seq_no', 'gen_utime']),
                sortedIndex(['gen_utime']),
                sortedIndex(['workchain_id', 'shard', 'seq_no']),
                sortedIndex(['workchain_id', 'seq_no']),
                sortedIndex(['workchain_id', 'gen_utime']),
                sortedIndex(['master.min_shard_gen_utime']),
                sortedIndex(['prev_ref.root_hash', '_key']),
            ],
        },
        accounts: {
            indexes: [
                sortedIndex(['last_trans_lt']),
                sortedIndex(['balance']),
            ],
        },
        messages: {
            indexes: [
                sortedIndex(['block_id']),
                sortedIndex(['value', 'created_at']),
                sortedIndex(['src', 'value', 'created_at']),
                sortedIndex(['dst', 'value', 'created_at']),
                sortedIndex(['src', 'created_at']),
                sortedIndex(['dst', 'created_at']),
                sortedIndex(['created_lt']),
                sortedIndex(['created_at']),
            ],
        },
        transactions: {
            indexes: [
                sortedIndex(['block_id']),
                sortedIndex(['in_msg']),
                sortedIndex(['out_msgs[*]']),
                sortedIndex(['account_addr', 'now']),
                sortedIndex(['now']),
                sortedIndex(['lt']),
                sortedIndex(['account_addr', 'orig_status', 'end_status']),
                sortedIndex(['now', 'account_addr', 'lt']),
            ],
        },
        blocks_signatures: {
            indexes: [
                sortedIndex(['signatures[*].node_id', 'gen_utime']),
            ],
        },
    }
};

function sortedIndex(fields) {
    return {
        type: "persistent",
        fields
    };
}

function checkCollection(name, props) {
    let collection = db._collection(name);
    if (!collection) {
        console.log(`Collection ${name} does not exist. Created.`);
        collection = db._create(name);
    } else {
        console.log(`Collection ${name} already exist.`);
    }
    props.indexes.forEach((index) => {
        console.log(`Ensure index ${index.fields.join(', ')}`);
        collection.ensureIndex(index);
    });

}

function checkDB(schema) {
    db._useDatabase('_system');
    if (db._databases().find(x => x.toLowerCase() === schema.name)) {
        console.log(`Database ${schema.name} already exist.`);
    } else {
        console.log(`Database ${schema.name} does not exist. Created.`);
        db._createDatabase(schema.name, {}, []);
    }
    db._useDatabase(schema.name);
    Object.entries(schema.collections).forEach(([name, collection]) => {
        checkCollection(name, collection);
    });
}

if (process.env.DB_TYPE === "Auth") {
    checkDB(AUTH_SERVICE);
} else {
    checkDB(BLOCKCHAIN);
}
