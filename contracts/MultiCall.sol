// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

// Aggregate two function calls, to func1 and func2, into a single query by writing the MultiCall contract
// We need to prepare the data to pass in the multicall function

contract TestMultiCall {
    function func1() external view returns (uint256, uint256) {
        return (1, block.timestamp);
    }

    function func2() external view returns (uint256, uint256) {
        return (2, block.timestamp);
    }

    function getData1() external pure returns (bytes memory) {
        return abi.encodeWithSelector(this.func1.selector);
        // <=> abi.encodeWithSignature("func1()")
    }

    function getData2() external pure returns (bytes memory) {
        return abi.encodeWithSelector(this.func2.selector);
    }
}

contract MultiCall {
    function multiCall(address[] calldata targets, bytes[] calldata data) external view returns (bytes[] memory) {
        require(targets.length == data.length, "target length is not equal to data length");
        bytes[] memory results = new bytes[](data.length);

        for (uint256 i; i < targets.length; i++) {
            (bool success, bytes memory result) = targets[i].staticcall(data[i]);
            require(success, "call failed");
            results[i] = result;
        }
        return results;
    }
}

/*
<screenshot> first output returns 1, and the next part is the timestamp. 
second output returns 2 then the timestamp
Notice that the two timestamps are the same.
=> Aggregate multi queries into a single function call by using multicall 
*/
