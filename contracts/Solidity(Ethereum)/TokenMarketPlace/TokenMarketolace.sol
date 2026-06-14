// SPDX-License-Identifier: GPL-3.0


pragma solidity >=0.7.0 <0.9.0;
import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";
//int - both positive and negative values
//uint - only for positive
contract TokenMarketplace{
     uint public constant TOKEN_PRICE = 1 ether;
     uint private reseverdOderedTokens; // when i dont intialize this variable it will be 0 by default because solidity does not have any concept of null or None.
     IERC20 public slvToken;
     error TokenMarketPlace_ZeroNumberOfTokens(uint256 numberOfTokens);
     error TokenMarketPlace_InsufficentEthPayment(uint256 expectedPayment, uint256 actualPayment);

     constructor(address _slvToken){
      slvToken = IERC20(_slvToken); //type converted adress type into IERC20 type 
     }

     function _getSlvTokenBalanceOfMarketplace() internal view returns(uint256){
          return slvToken.balanceOf(address(this));
     }

     function _isNumberOfTokensZero(uint256 numberOfTokens)internal pure{
             if(numberOfTokens==0){
               revert TokenMarketPlace_ZeroNumberOfTokens(numberOfTokens);
          }

     }

     function _checkEthPayment(uint256 numberOfTokens) internal view{
            if(numberOfTokens*TOKEN_PRICE != msg.value){
               revert TokenMarketPlace_InsufficentEthPayment(numberOfTokens*TOKEN_PRICE,msg.value);
          }
     }

     function buyTokensFromMarketPlace(uint256 numberOfTokens) external payable {
          _isNumberOfTokensZero(numberOfTokens);
          _checkEthPayment(numberOfTokens);
     

     }

}