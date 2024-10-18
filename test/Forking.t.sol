// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test, console} from "forge-std/Test.sol";

interface IERC20 {
    function balanceOf(address) external view returns (uint256);
    function transfer(address, uint256) external returns (bool);
    function decimals() external view returns (uint8);
}

contract PEPETransferTest is Test {

    IERC20 pepe;
    // PEPE 大户地址，持有大量 PEPE 代币。我们将在测试中模拟从该账户进行代币转账操作。
    address myAddress = 0xF977814e90dA44bFA03b6295A0616a897441aceC;
    // 初始化为 Vitalik Buterin 的以太坊地址。这个地址将用作代币接收者
    address recipient = 0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045;
    // PEPE代币在以太坊主网上的合约地址
    address pepeAddress = 0x6982508145454Ce325dDbE47a25d4ec3d2311933;
		
	function setUp() public {
        pepe = IERC20(pepeAddress);
        vm.startPrank(myAddress);
	}

	function testPEPETransfer() public {
        uint256 recipientBalanceBefore = pepe.balanceOf(recipient);
        console.log("PEPE balance of recipient before: ", recipientBalanceBefore);

         bool success = pepe.transfer(recipient, 10000000);
        require(success, "Transfer failed");


        uint256 recipientBalanceAfter = pepe.balanceOf(recipient);
        console.log("PEPE balance of recipient after: ", recipientBalanceAfter);
        assertEq(recipientBalanceAfter, recipientBalanceBefore + 10000000, "failed");

	}		
}