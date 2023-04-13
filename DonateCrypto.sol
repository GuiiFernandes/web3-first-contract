// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

struct Campaign {
    address author;
    string title;
    string description;
    string[] videoUrl;
    string[] imageUrl;
    uint256 balance;
    uint256 goal;
    bool active;
}

contract DonateCrypto {
  uint256 public nextId = 0;
  mapping(uint256 => Campaign) public campaigns;
  uint256 public fee = 1;

  function addCampaign(
    string calldata title,
    string calldata description,
    string[] calldata videoUrl,
    string[] calldata imageUrl,
    uint256 goal
  ) public {
    Campaign memory newCampaign;
    newCampaign.title = title;
    newCampaign.description = description;
    newCampaign.videoUrl = videoUrl;
    newCampaign.imageUrl = imageUrl;
    newCampaign.goal = goal;
    newCampaign.active = true;
    newCampaign.author = msg.sender;

    nextId++;
    campaigns[nextId] = newCampaign;
  }

  function donate(uint256 id) public payable {
    require(msg.value > 0, "You must send a donation value > 0");
    require(campaigns[id].active == true, "Cannot donate to this campaign");
    campaigns[id].balance += msg.value;

    if (campaigns[id].balance >= campaigns[id].goal) {
      uint256 valueFee = campaigns[id].balance * fee / 100;
      address payable recipient = payable(campaigns[id].author);
      recipient.call{value: campaigns[id].balance - valueFee}("");
      campaigns[id].active = false;
      campaigns[id].balance = 0;
    }
  }

  function withdraw(uint256 id) public {
    Campaign memory campaign = campaigns[id];
    require(campaign.author == msg.sender, "You do not have permission");
    require(campaign.active == true, "This campaign is closed");
    require(
        campaign.balance >= 100,
        "This campaign does not have enough balance"
    );
    uint256 valueFee = campaign.balance * fee / 100;
    address payable recipient = payable(campaign.author);
    recipient.call{value: campaign.balance - valueFee}("");

    campaigns[id].active = false;
    campaigns[id].balance = 0;
  }

  function feeModify(uint256 newFee) public {
    require(newFee > 0, "The new fee is less than 0");
    require(newFee <= 100, "The new fee is greater than 100");
    fee = newFee;
  }
}
