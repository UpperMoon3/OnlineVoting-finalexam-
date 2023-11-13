// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract OnlineVoting {
    struct Candidate {
        string name;
        uint256 voteCount;
    }

    address public owner;
    bool public votingOpen;
    mapping(address => bool) public hasVoted;
    Candidate[] public candidates;

    event Voted(address indexed voter, uint256 indexed candidateIndex);

    constructor(string[] memory candidateNames) {
        owner = msg.sender;
        votingOpen = true;

        for (uint256 i = 0; i < candidateNames.length; i++) {
            candidates.push(Candidate({
                name: candidateNames[i],
                voteCount: 0
            }));
        }
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    modifier isVotingOpen() {
        require(votingOpen, "Voting is closed");
        _;
    }

    function openVoting() public onlyOwner {
        votingOpen = true;
    }

    function closeVoting() public onlyOwner {
        votingOpen = false;
    }

    function vote(uint256 candidateIndex) public isVotingOpen {
        require(candidateIndex < candidates.length, "Invalid candidate index");
        require(!hasVoted[msg.sender], "You have already voted");

        candidates[candidateIndex].voteCount++;
        hasVoted[msg.sender] = true;

        emit Voted(msg.sender, candidateIndex);
    }

    function getCandidateCount() public view returns (uint256) {
        return candidates.length;
    }

    function getCandidate(uint256 candidateIndex) public view returns (string memory, uint256) {
        require(candidateIndex < candidates.length, "Invalid candidate index");
        return (candidates[candidateIndex].name, candidates[candidateIndex].voteCount);
    }

    function getWinner() public view returns (string memory, uint256) {
        require(!votingOpen, "Voting is still open");
        uint256 winningVoteCount = 0;
        string memory winnerName;

        for (uint256 i = 0; i < candidates.length; i++) {
            if (candidates[i].voteCount > winningVoteCount) {
                winningVoteCount = candidates[i].voteCount;
                winnerName = candidates[i].name;
            }
        }

        return (winnerName, winningVoteCount);
    }
}
