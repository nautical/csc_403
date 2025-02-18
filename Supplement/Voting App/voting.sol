// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VotingContract {
    struct Candidate {
        string name;
        uint256 voteCount;
    }

    struct Voter {
        bool isRegistered;
        bool hasVoted;
    }

    address public admin;
    uint256 public startTime;
    uint256 public endTime;
    bool public electionFinalized;

    Candidate[] public candidates;
    mapping(address => Voter) public voters;

    event ElectionStarted(uint256 startTime, uint256 endTime);
    event VoterRegistered(address voter);
    event VoteCast(address voter, uint256 candidateIndex);
    event ElectionFinalized(string[] candidateNames, uint256[] voteCounts);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function.");
        _;
    }

    modifier duringElection() {
        require(block.timestamp >= startTime && block.timestamp <= endTime, "Voting is not open.");
        _;
    }

    modifier afterElection() {
        require(block.timestamp > endTime, "Election has not ended yet.");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    // Admin starts the election
    function startElection(string[] memory candidateNames, uint256 _durationInMinutes) external onlyAdmin {
        require(candidates.length == 0, "Election already started.");
        require(_durationInMinutes > 0, "Duration should be greater than 0.");

        startTime = block.timestamp;
        endTime = block.timestamp + (_durationInMinutes * 1 minutes);
        electionFinalized = false;

        // Adding candidates
        for (uint256 i = 0; i < candidateNames.length; i++) {
            candidates.push(Candidate({
                name: candidateNames[i],
                voteCount: 0
            }));
        }

        emit ElectionStarted(startTime, endTime);
    }

    // Voter registration
    function registerVoter() external {
        require(!voters[msg.sender].isRegistered, "Voter is already registered.");
        voters[msg.sender] = Voter({
            isRegistered: true,
            hasVoted: false
        });

        emit VoterRegistered(msg.sender);
    }

    // Voter casts vote by selecting a candidate index
    function castVote(uint256 candidateIndex) external duringElection {
<<<<<<< HEAD
        require(voters[msg.sender].isRegistered, "Voter is not registered.");
        require(!voters[msg.sender].hasVoted, "Voter has already voted.");
        require(candidateIndex < candidates.length, "Invalid candidate index.");

        voters[msg.sender].hasVoted = true;
        candidates[candidateIndex].voteCount++;

        emit VoteCast(msg.sender, candidateIndex);
=======
        // TODO 
>>>>>>> e51003c3ac55f5149a6cbd86b745d510284ee6e2
    }

    // Admin finalizes the election and reveals the results
    function finalizeElection() external onlyAdmin afterElection {
        require(!electionFinalized, "Election has already been finalized.");
        
        electionFinalized = true;

        // Emit election results
        string[] memory candidateNames = new string[](candidates.length);
        uint256[] memory voteCounts = new uint256[](candidates.length);

        for (uint256 i = 0; i < candidates.length; i++) {
            candidateNames[i] = candidates[i].name;
            voteCounts[i] = candidates[i].voteCount;
        }

        emit ElectionFinalized(candidateNames, voteCounts);
    }

    // Returns the remaining time until voting ends
    function getTimeLeft() external view returns (uint256) {
        if (block.timestamp > endTime) {
            return 0;
        }
        return endTime - block.timestamp;
    }

    // Get candidate count
    function getCandidateCount() external view returns (uint256) {
        return candidates.length;
    }

    // Get candidate details
    function getCandidate(uint256 index) external view returns (string memory, uint256) {
        require(index < candidates.length, "Invalid candidate index.");
        return (candidates[index].name, candidates[index].voteCount);
    }
}