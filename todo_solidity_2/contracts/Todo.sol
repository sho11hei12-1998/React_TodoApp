// ⓪ コンパイラバージョンを指定する
pragma solidity ^0.4.25;

// ① Contract名を宣言
contract TodoApp {
    uint256 num = 0;

    // ③ 構造体の性質を持った配列を変数todosとして定義
    struct Todo {
        uint256 taskid;
        string task;
        bool flag;
    }

    Todo[] public todos;

    // ④ mappingを宣言
    mapping(uint256 => address) public todoToOwner;

    // ⑤ mappingを宣言
    mapping(address => uint256) public ownerTodoCount;

    // ⑥ Todoを作成する関数 （Gas発生）
    function TodoCreate(string memory _task) public {
        uint256 id = todos.push(Todo(num, _task, true)) - 1;
        todoToOwner[id] = msg.sender;
        ownerTodoCount[msg.sender]++;
        num++;
    }

    // ⑦ Todoの状態を完了にする関数 （Gas発生）
    function TodoRemove(uint256 id) external {
        require(todoToOwner[id] == msg.sender);
        require(todos[id].flag);
        todos[id].flag = false;
    }

    // ⑧ 自分のイーサリアムアドレスに紐づくTodoのidを取得する関数 （ガス代不要）
    function getTodosByOwner(address owner)
        external
        view
        returns (uint256[] memory)
    {
        uint256[] memory result = new uint256[](ownerTodoCount[owner]);
        uint256 counter = 0;
        for (uint256 i = 0; i < todos.length; i++) {
            if (todoToOwner[i] == owner) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }
}
