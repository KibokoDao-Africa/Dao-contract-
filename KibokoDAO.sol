// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract KibokoDAO is Ownable, ReentrancyGuard {
    using SafeMath for uint256;

    uint256 public constant MINIMUM_VOTES = 1;
    uint256 public constant PROPOSAL_DURATION = 7 days;
    uint256 public constant VOTING_DURATION = 2 days;
    uint256 public constant MAX_PROPOSALS = 100;
    uint256 public constant MIN_QUORUM_PERCENTAGE = 10;
    uint256 public constant MAX_QUORUM_PERCENTAGE = 80;

    uint256 public totalMembers;
    uint256 public proposalCount;
    Proposal[] public proposals;
    mapping(address => bool) public members;

    struct VoterRecord {
        bool hasVoted;
        bool support;
    }

    struct Proposal {
        uint256 id;
        string title;
        string description;
        uint256 votes;
        uint256 deadline;
        address proposer;
        VoterRecord[] voters;
        bool executed;
    }

    event NewMember(address indexed member);
    event MemberLeft(address indexed member);
    event NewProposal(uint256 indexed proposalId, string title);
    event Voted(uint256 indexed proposalId, address indexed voter, bool support);
    // event ProposalExecuted(uint256 indexed proposalId, address indexed executor);

    modifier onlyMember() {
        require(members[msg.sender], "Not a member");
        _;
    }

    function addMember(address _member) public onlyOwner {
        require(_member != address(0), "Invalid member address");
        require(!members[_member], "Already a member");
        members[_member] = true;
        totalMembers++;
        emit NewMember(_member);
    }

    function removeMember(address _member) public onlyOwner {
        require(_member != address(0), "Invalid member address");
        require(members[_member], "Not a member");
        require(totalMembers > 1, "Cannot remove the last member");
        members[_member] = false;
        totalMembers--;
        emit MemberLeft(_member);
    }
    
     function createProposal(string memory _title, string memory _description) public onlyMember {
        require(bytes(_title).length > 0, "Empty title");
        require(bytes(_description).length > 0, "Empty description");
        require(proposalCount < MAX_PROPOSALS, "Too many proposals");
        Proposal memory newProposal = Proposal({
            id: proposalCount,
            title: _title,
            description: _description,
            votes: 0,
            deadline: block.timestamp + PROPOSAL_DURATION,
            proposer: msg.sender,
            voters: new VoterRecord[](0),
            executed: false
        });
        proposals.push(newProposal);
        proposalCount++;
        emit NewProposal(newProposal.id, newProposal.title);
    }

    function vote(uint256 _proposalId, bool _support) public onlyMember nonReentrant {
        Proposal storage proposal = proposals[_proposalId];
        require(block.timestamp < proposal.deadline, "Proposal deadline passed");
        require(!proposal.executed, "Proposal has already been executed");
        require(!proposal.voters[msg.sender].hasVoted, "You have already voted on this proposal");

        proposal.voters.push(VoterRecord);
           







}