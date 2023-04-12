// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

struct Campaign {
    address author;
    string title;
    string description;
    string videoUrl;
    string imageUrl;
    uint256 balance;
    bool active;
}

contract DonateCrypto {
  uint256 public nextId = 0;
  mapping(uint256 => Campaign) public campaigns;

  function addCampaign(
    string calldata title,
    string calldata description,
    string calldata videoUrl,
    string calldata imageUrl
  ) public {
    Campaign memory newCampaign;
    newCampaign.title = title;
    newCampaign.description = description;
    newCampaign.videoUrl = videoUrl;
    newCampaign.imageUrl = imageUrl;
    newCampaign.active = true;
    newCampaign.author = msg.sender;

    nextId++;
    campaigns[nextId] = newCampaign;
  }

  function donate(uint256 id) public payable {
    require(msg.value > 0, "You must send a donation value > 0");
    require(campaigns[id].active == true, "Cannot donate to this campaign");
    campaigns[id].balance += msg.value;
  }

  function withdraw(uint256 id) public {
    Campaign memory campaign = campaigns[id];
    require(campaign.author == msg.sender, "You do not have permission");
    require(campaign.active == true, "This campaign is closed");
    require(
        campaign.balance > 100,
        "This campaign does not have enough balance"
    );
    uint256 fee = campaign.balance / 10;
    address payable recipient = payable(campaign.author);
    recipient.call{value: campaign.balance - fee}("");

    campaigns[id].active = false;
  }
}
