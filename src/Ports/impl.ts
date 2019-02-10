import Dexie from 'dexie';

interface File {
    name: string;
    content: string;
}

class FilesDatabase extends Dexie {
    // @ts-ignore 2564
    files: Dexie.Table<File, string>;

    constructor(){
        super('files');
        this.version(1).stores({
            files: 'name, content'
        });
    }
}
const db = new FilesDatabase();

/**
 * ファイルをIndexed DB(IDB)に書き込みます。
 * @param path ファイルのパス(ファイル名)
 * @param content 書き込む内容
 * @param mode 'w'が指定されると上書き、'a'が指定されると末尾に追記。デフォルトは'w'で省略可能。
 */
export async function writeFile(path: string, content: string, mode?: "w"|"a"): Promise<void> {
    mode = mode||"w";
    if(mode==="w") {
        await db.files.put({name: path, content: content});
    } else if(mode==="a") {
        // db.files.get(path)が返す値はundefinedの可能性があるので、
        // undefinedの時は代わりに{content: ''}を使う。
        content = ((await db.files.get(path)) || {content: ''}).content + content;
        await db.files.put({name: path, content: content});
    }
}

/**
 * ファイルをIndexed DB(IDB)から読み出します。
 * @param path ファイルのパス(ファイル名)
 * @returns 読み込んだファイル
 */
export async function readFile(path: string): Promise<{name: string, content: string}> {
    return await db.files.get(path) || {content: '', name: path};
}

/**
 * Indexed DBからファイルを削除します。
 * @param path 削除するファイルのパス(ファイル名)
 */
export async function deleteFile(path:string): Promise<void> {
    await db.files.delete(path);
}

/**
 * Indexed DBに保存されたファイルの一覧を取得します
 * @returns 保存されているファイルの名前の配列
 */
export async function getSavedFiles(): Promise<String[]> {
    return await db.files.toCollection().primaryKeys();
}
