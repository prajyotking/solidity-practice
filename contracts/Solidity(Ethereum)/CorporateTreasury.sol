// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract CorporateTreasury {
    enum Continent {
        None, //0
        NorthAmerica, //1
        Europe, //2
        Asia, //3
        Oceania, //4
        SouthAmerica,
        Africa
    }

    enum AssetClass {
        Equity,
        FixedIncome,
        Crypto,
        RealEstate
    }

    struct Investment {
        uint256 id;
        address investor;
        string assetName;
        uint256 principal;
        uint256 timestamp;
        Continent continent;
        AssetClass assetClass;
    }

    mapping(uint256 => Investment) public ledger;
    mapping(uint256 => bool) public idUsed;
    uint256 public totalInvestmentsCount;
    address public owner;

    error CorporateTreasury_notAuthorized();
    error CorporateTreasury_InvalidAmount();
    error  CorporateTreasury_SelectContinent();

    modifier onlyOwner() {
    if(msg.sender != owner){
        revert CorporateTreasury_notAuthorized();
        _;
    }
    }

    function addInvestment(uint256 _id, string memory _assetName, Continent _continent, AssetClass _assetClass) external payable{
        if(msg.value == 0){
            revert CorporateTreasury_InvalidAmount();
        }
        if(_continent == Continent.None){
         revert  CorporateTreasury_SelectContinent();
        }
    }

}
