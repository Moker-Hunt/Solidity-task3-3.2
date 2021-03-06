
/**
 * This file was generated by TONDev.
 * TONDev is a part of TON OS (see http://ton.dev).
 */
pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

// This is class that describes you smart contract.
contract ListOfTask {
    // Contract can have an instance variables.
    // In this example instance variable `timestamp` is used to store the time of `constructor` or `touch`
    // function call

    struct listOfTask{
        string name;
        uint32 time;
        bool status;
    }
    int8 next = 0;

    // Contract can have a `constructor` – function that will be called when contract will be deployed to the blockchain.
    // In this example constructor adds current time to the instance variable.
    // All contracts need call tvm.accept(); for succeeded deploy
    constructor() public {
        // Check that contract's public key is set
        require(tvm.pubkey() != 0, 101);
        // Check that message has signature (msg.pubkey() is not zero) and
        // message is signed with the owner's private key
        require(msg.pubkey() == tvm.pubkey(), 102);
        // The current smart contract agrees to buy some gas to finish the
        // current transaction. This actions required to process external
        // messages, which bring no value (henceno gas) with themselves.
        tvm.accept();
    }

    modifier checkOwnerAndAccept() {
        require(tvm.pubkey() == msg.pubkey(), 101);
        tvm.accept();
        _;
    }

    mapping (int8=>listOfTask) public Tasks;

    /*
        - добавить задачу (должен в сопоставление заполняться последовательный целочисленный ключ)
        - получить количество открытых задач (возвращает число)
        - получить список задач
        - получить описание задачи по ключу
        - удалить задачу по ключу
        - отметить задачу как выполненную по ключу

    */

    function addTask(string name) public checkOwnerAndAccept{
        Tasks[next] = listOfTask(name, now, false);
        next++;
    }

    function viewAllTasks() public returns (mapping (int8=>listOfTask) tasks){
        require(!Tasks.empty(), 102);
        return Tasks;
    }

    function viewOpenTasks() public returns (mapping (int8=>listOfTask) tasks){
        require(!Tasks.empty(), 102);
        for(int8 i = 0; i < next; ++i){
            if(!Tasks[i].status){
                tasks[i] = Tasks[i];
            }
        }
        return tasks;
    }

    function viewTaskInfo(int8 value) public checkOwnerAndAccept returns (listOfTask task){
        require(!Tasks[value].name.empty());
        return Tasks[value];
    }

    function deleteTask(int8 value) public checkOwnerAndAccept{
        require(!Tasks[value].name.empty());
        delete Tasks[value];
    }

    function closeTask(int8 value) public checkOwnerAndAccept{
        require(!Tasks[value].name.empty());
        Tasks[value].status = true;
    }
}
