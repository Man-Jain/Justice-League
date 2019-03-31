pragma solidity >=0.4.22 <0.6.0;

contract Critics {
    struct blockchain_project {
        address owner;
        uint total_votes;
        uint positive_votes;
        uint negative_votes;
        string details;
    }
    uint count_ques;
    mapping(string => blockchain_project) projects;
    mapping(string => bet) bets;
    mapping(address => uint) repo;
    //address public proposer;
    /*struct proposal {
        address proposer;
        string proposal_details;
    }*/
    struct bet{
        uint  count_total;
        uint count_fors;
        uint count_nos;
        uint fors;
        uint nos;
        mapping (address => uint) gambler;
        mapping (address => uint) status; //o=nil 1= up 2= down
        mapping (uint => address) list;
    }
    /*mapping (address => uint) coin;
    function buy_alu() payble public {
        alu[msg.sender]=msg.value;
    }*/
    /*struct peer {
        address adrs;
        mapping(address => address[]) voted_icos;
        mapping(string => address) proof_submitted;
    }*/
    struct proposal{
        address proposer;
        string id ;
        uint total;
        uint upvote;
        uint downvote;
        mapping (address=>uint) status;// check for review 0= nil, 1= true ,2 = flase
    }
    mapping(string => proposal) proposals;
    function submit_project(string memory  id, string memory details) public{
        projects[id].details = details;
        count_ques++;
        projects[id].owner = msg.sender;
        repo[msg.sender] += 25;
    }
    /*function view_proposal(string memory id) public view returns(string memory proposal_details, address proposer){
        proposal_details = proposals[id].proposal_details;
        proposer = proposals[id].proposer;
        return(proposal_details, proposer);
    }*/
    function view_project(string memory id) public view returns(string memory details, address owner){
        details = projects[id].details;
        owner = projects[id].owner;
        return(details, owner);
    }
    function submit_propsal (string memory prop_id, string memory id ) public {
        require (proposals[id].status[msg.sender]==0 && repo[msg.sender]>50);
        proposals[id].proposer = msg.sender;
        proposals[prop_id].id = id;

    }
    /*function submit_proof(string memory id, string memory proof_details) public{
        proposals[id].proposer = msg.sender;
        proposals[id].proposal_details = proof_details;
    }*/
    function vote(string memory id, bool vote_type) payable public {
        require(bets[id].gambler[msg.sender]==0);
        projects[id].total_votes = projects[id].total_votes + 1;
        bets[id].count_total++;
        if (vote_type == true){
            projects[id].positive_votes = projects[id].positive_votes + 1;
            bets[id].fors += msg.value;
            bets[id].count_fors ++;
            bets[id].gambler[msg.sender]= msg.value;
            bets[id].status[msg.sender]= 1;
        }
        else {
            projects[id].negative_votes = projects[id].negative_votes + 1;
            bets[id].nos += msg.value;
            bets[id].count_nos ++;
            bets[id].gambler[msg.sender]= msg.value;
            bets[id].status[msg.sender]= 2;
        }
    }
    function prop_vote(bool yes , string memory id) public{
        require(proposals[id].status[msg.sender]==0);
        proposals[id].total++;
        if (yes==true){
            proposals[id].upvote++;
            proposals[id].status[msg.sender]= 1;
        }
        else{
            proposals[id].status[msg.sender]= 2;
            proposals[id].downvote++;
        }
        if (proposals[id].upvote>proposals[id].downvote) {
            repo[msg.sender]=(proposals[id].upvote/proposals[id].total)*10;
        }
    }
    function get_prop_votes(string memory id) view public returns(uint up, uint down){
        up = proposals[id].upvote;
        down= proposals[id].downvote;
    }
    function send_count()public view returns(uint ct){
        ct=count_ques;
    }
    /*function get_votes(string memory id) public view returns(uint total_votes, uint positive_votes, uint negative_votes) {
        total_votes = projects[id].total_votes;
        positive_votes = projects[id].positive_votes;
        negative_votes = projects[id].negative_votes;
        return(total_votes, positive_votes, negative_votes);
    }*/
    /*function set_bets(string memory id, bool yes) payable public{
        require(bets[id].gambler[msg.sender]==0);
        if (yes == true){
            bets[id].fors += msg.value;
            bets[id].count_fors ++;
            bets[id].gambler[msg.sender]= msg.value;
            bets[id].status[msg.sender]= 1;
        }
        else{
            bets[id].nos += msg.value;
            bets[id].count_nos ++;
            bets[id].gambler[msg.sender]= msg.value;
            bets[id].status[msg.sender]= 2;
        }
    }*/
    function get_bets (string memory id) view public returns(uint up, uint down, uint upamt, uint downamt){
        downamt = bets[id].nos;
        upamt = bets[id].fors;
        up = bets[id].count_fors;
        down = bets[id].count_nos;
    }
    function destribute(string memory id ) public {

        for(uint i=0; i<bets[id].count_total; i++)
        {
           address payable addr= address(uint160(bets[id].list[i]));
           if(bets[id].count_fors>bets[id].count_nos){
               if(bets[id].status[addr]==1){
                    uint  perc = bets[id].count_fors / bets[id].count_nos;
                    uint amt = (bets[id].gambler[addr] * perc)/100;
                    uint our = amt/10;
                    amt = amt - our;
                    addr.transfer(amt);
                }else{
                    uint  perc = bets[id].count_nos / bets[id].count_fors;
                    uint amt = (bets[id].gambler[addr] * perc)/100;
                    uint our = amt/10;
                    amt = amt - our;
                    addr.transfer(amt);
                }
            }else
            {
                 if(bets[id].status[addr]==2){
                    uint  perc = bets[id].count_fors / bets[id].count_nos;
                    uint amt = (bets[id].gambler[addr] * perc)/100;
                    uint our = amt/10;
                    amt = amt - our;
                    addr.transfer(amt);
                }else{
                    uint  perc = bets[id].count_nos / bets[id].count_fors;
                    uint amt = (bets[id].gambler[addr] * perc)/100;
                    uint our = amt/10;
                    amt = amt - our;
                    addr.transfer(amt);
                }
            }

        }

    }
}