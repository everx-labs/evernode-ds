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
                sortedIndex(['workchain_id', 'shard', 'gen_utime']),
                sortedIndex(['workchain_id', 'seq_no']),
                sortedIndex(['workchain_id', 'key_block', 'seq_no']),
                sortedIndex(['workchain_id', 'gen_utime']),
                sortedIndex(['workchain_id', 'tr_count', 'gen_utime']),
                sortedIndex(['master.min_shard_gen_utime']),
                sortedIndex(['prev_ref.root_hash', '_key']),
                sortedIndex(['prev_alt_ref.root_hash', '_key']),
            ],
        },
        accounts: {
            indexes: [
                sortedIndex(['last_trans_lt']),
                sortedIndex(['balance']),
                sortedIndex(['code_hash']),
                sortedIndex(['code_hash', 'balance']),
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
                sortedIndex(['code_hash', 'created_at']),
                sortedIndex(['code_hash', 'last_paid']),
                sortedIndex(['src', 'dst', 'value', 'created_at']),
                sortedIndex(['status', 'src', 'created_at', 'bounced', 'value']),
                sortedIndex(['dst', 'msg_type', 'created_at', 'created_lt']),
                sortedIndex(['src', 'msg_type', 'created_at', 'created_lt']),
                sortedIndex(['src', 'dst', 'value', 'created_at', 'created_lt']),
                sortedIndex(['src',  'value' , 'msg_type', 'created_at', 'created_lt']),
                sortedIndex(['dst',  'value' , 'msg_type', 'created_at', 'created_lt']),
                sortedIndex(['src', 'dst', 'created_at', 'created_lt']),
                sortedIndex(['src', 'body_hash', 'created_at', 'created_lt']),
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
                sortedIndex(['workchain_id', 'now']),
                sortedIndex(['block_id', 'tr_type', 'outmsg_cnt', 'now', 'lt']),
                sortedIndex(['tr_type', 'now', 'lt']),
                sortedIndex(['account_addr', 'orig_status', 'end_status', 'action.spec_action']),
                sortedIndex(['account_addr', 'balance_delta', 'now', 'lt']),
                sortedIndex(['account_addr', 'lt', 'now']),
                sortedIndex(['block_id', 'lt']),
            ],
        },
        blocks_signatures: {
            indexes: [
                sortedIndex(['signatures[*].node_id', 'gen_utime']),
                sortedIndex(['gen_utime']),
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

function checkDB(db_name, collections_schema) {
    db._useDatabase('_system');
    if (db._databases().find(x => x.toLowerCase() === db_name)) {
        console.log(`Database ${db_name} already exist.`);
    } else {
        console.log(`Database ${db_name} does not exist. Created.`);
        db._createDatabase(db_name, {}, []);
    }
    db._useDatabase(db_name);
    Object.entries(collections_schema).forEach(([name, collection]) => {
        checkCollection(name, collection);
    });
}


if (process.env.DB_TYPE === "Auth") {
    checkDB(process.env.DB_NAME || AUTH_SERVICE.name, AUTH_SERVICE.collections);
} else {
    checkDB(process.env.DB_NAME || BLOCKCHAIN.name, BLOCKCHAIN.collections);
}
