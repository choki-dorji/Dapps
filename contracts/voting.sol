// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {

    struct Candidate {
        uint256 id;
        string name;
        uint256 voteCount;
    }

    address public admin;

    mapping(address => bool) public voters;
    mapping(uint => Candidate) public candidates;
    uint public candidatesCount;

    constructor() {
        admin = msg.sender; // Set the creator of the contract as the admin
        addCandidate("Tshering Tobgay");
        addCandidate("Loday Tshering");
        addCandidate("Pema Chewang");
        addCandidate("Dorji Wangdi");

    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    function addCandidate(string memory name) public onlyAdmin {
        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, name, 0);
    }

    function vote(uint candidateId) public {
        require(!voters[msg.sender], "You have already voted");
        require(candidates[candidateId].id != 0, "Candidate does not exist");

        voters[msg.sender] = true;
        candidates[candidateId].voteCount++;
    }

    function viewResults(uint candidateId) public view returns (uint) {
        require(candidates[candidateId].id != 0, "Candidate does not exist");
        return (candidates[candidateId].voteCount);
    }

    function getCandidate(uint candidateId) public view returns (uint, string memory, uint) {
        require(candidates[candidateId].id != 0, "Candidate does not exist");
        Candidate memory candidate = candidates[candidateId];
        return (candidate.id, candidate.name, candidate.voteCount);
    }
    function getTotalCandidates() public view returns (uint) {
        return candidatesCount;
    }
    function getAllCandidates() public view returns (uint[] memory, string[] memory, uint[] memory) {
        uint[] memory ids = new uint[](candidatesCount);
        string[] memory names = new string[](candidatesCount);
        uint[] memory voteCounts = new uint[](candidatesCount);

        for (uint i = 1; i <= candidatesCount; i++) {
            Candidate storage candidate = candidates[i];
            ids[i - 1] = candidate.id;
            names[i - 1] = candidate.name;
            voteCounts[i - 1] = candidate.voteCount;
        }

        return (ids, names, voteCounts);
    }
}
