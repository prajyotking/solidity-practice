// SPDX-License-Identifier: GPL-3.0


pragma solidity >=0.7.0 <0.9.0;
import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";
import {OrderInfo} from "./types/Trades.sol";


//int - both positive and negative values
//uint - only for positive
contract TokenMarketplace{
     uint public constant TOKEN_PRICE = 1 ether;
     uint private reseverdOderedTokens; // when i dont intialize this variable it will be 0 by default because solidity does not have any concept of null or None.
     IERC20 public slvToken;
     mapping(uint256 => OrderInfo) private orders;
     uint256 private nextOrder;

     error TokenMarketPlace_ZeroNumberOfTokens(uint256 numberOfTokens);
     error TokenMarketPlace_InsufficentEthPayment(uint256 expectedPayment, uint256 actualPayment);
     error TokenMarketPlace_InsufficentTokenBalance(uint256 expectedToken, uint256 actualToken);
     error TokenMarketPlace_InsufficentSellerTokenBalance(uint256 expectedTokenToSell, uint256 actualTokenToSell);
     error TokenMarketPlace_InsufficentAllowance(uint256 requiredAllowance, uint256 actualAllowance);
     error TokenMarketPlace_sellOrderIsNotActive(uint256 orderId);
     error TokenMarketPlace_NotEnoughTokensInOrder(uint256 actualTokens, uint256 requiredTokens);

     constructor(address _slvToken){
      slvToken = IERC20(_slvToken); 
      /* What it does: You pass in the raw address of the token you want to sell (e.g., 0x123...). 
         The contract wraps that address in the IERC20 interface and stores it in your slvToken state variable.
         Now, your contract is permanently linked to that specific token.*/
     }

     function _getSlvTokenBalanceOfMarketplace() internal view returns(uint256){
          return slvToken.balanceOf(address(this));
     }

      function _getSellerSlvTokenBalance() internal view returns(uint256){//getter function
          return slvToken.balanceOf(address(msg.sender));
     }

     
     function _checkTokenBalance(uint256 numberOfTokens) internal view{
           if(_getSlvTokenBalanceOfMarketplace()<numberOfTokens){
               revert TokenMarketPlace_InsufficentTokenBalance(numberOfTokens, _getSlvTokenBalanceOfMarketplace());
          }
     }

     function _checkSellerSlvTokenBalance(uint256 numberOfTokensToSell)internal view{//checker function
          if(_getSellerSlvTokenBalance()<numberOfTokensToSell){
               revert TokenMarketPlace_InsufficentSellerTokenBalance(numberOfTokensToSell, _getSellerSlvTokenBalance());
          }
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
          _isNumberOfTokensZero(numberOfTokens); //check 1
          _checkEthPayment(numberOfTokens); //check 2
          _checkTokenBalance(numberOfTokens);//check 3

          slvToken.transfer(msg.sender, numberOfTokens);//Okay Proceed to tranfer tokens to buyer

     }

     function createSellOrder(uint256 numberOfTokensToSell)external

         {
           _isNumberOfTokensZero(numberOfTokensToSell);
           _checkSellerSlvTokenBalance(numberOfTokensToSell);
           uint256 allowance = slvToken.allowance(msg.sender, address(this));

           if(allowance<numberOfTokensToSell){
               revert TokenMarketPlace_InsufficentAllowance(numberOfTokensToSell, allowance);
           }

               OrderInfo memory order = OrderInfo({                  
                     orderId: nextOrder,
                     seller: msg.sender,
                     numberOfTokensToSell: numberOfTokensToSell,
                     isActive: true
               });

               orders[nextOrder] = order;//orders[1] = order;
               nextOrder++;
               slvToken.transferFrom(msg.sender, address(this), numberOfTokensToSell);

               reseverdOderedTokens += numberOfTokensToSell;

          }

        
     
     function buyTokensFromSellOrderCreator(uint256 orderId, uint256 numberOfTokensToBuy) external payable {
          _isNumberOfTokensZero(numberOfTokensToBuy);
          _checkEthPayment(numberOfTokensToBuy);
          OrderInfo memory order = orders[orderId];
         

          if(order.isActive == false){
               revert  TokenMarketPlace_sellOrderIsNotActive(orderId);
          }

          if(order.numberOfTokensToSell < numberOfTokensToBuy){
               revert TokenMarketPlace_NotEnoughTokensInOrder(order.numberOfTokensToSell, numberOfTokensToBuy);
          }

          order.numberOfTokensToSell-=numberOfTokensToBuy;

          if(order.numberOfTokensToSell==0){
               order.isActive = false;
          }

          slvToken.transfer(msg.sender, numberOfTokensToBuy);

          (bool sucsess,) = order.seller.call{value: msg.value}("");




          }

}