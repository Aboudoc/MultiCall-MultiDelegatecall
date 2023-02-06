// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/** @title
 * @notice enable multicall sequentially in a single transactions
 * @dev delegatecall allows to preserve the context
 */
contract MultiDelegatecall {
    /**
     * @dev returns the output  of each function call as bytes
     * we delegatecall to the same contract: address(this)
     */
    function multiDelegatecall(bytes[] calldata _data) external payable returns (bytes[] memory results) {
        results = new bytes[](_data.length);
        for (uint256 i; i < _data.length; i++) {
            (bool ok, bytes memory res) = address(this).delegatecall(_data[i]);
            require(ok);
            results[i] = res;
        }
    }
}

/**
 * @notice inherits from MultiDelegatecall
 * @dev If we were using call instead of delegatecall
 * msg.sender would be MultiCall contract
 * and not the EOA
 */
contract TestMultiDeleelegatecall {
    event Log(address _caller, string _function, uint256 i);

    function func1(uint256 _x, uint256 _y) external {
        emit Log(msg.sender, "func1", _x + _y);
    }

    function func2() external returns (uint256) {
        emit Log(msg.sender, "func2", 2);
        return 111;
    }
}

/**
 * @notice helper to abi.encode the data
 * @dev it could be done using abi.encodeWithSignature
 */
contract Helper {
    function getData1(uint256 _x, uint256 _y) external pure returns (bytes memory) {
        return abi.encodeWithSelector(TestMultiDeleelegatecall.func1.selector, _x, _y);
    }

    function getData2() public pure returns (bytes memory) {
        return abi.encodeWithSelector(TestMultiDeleelegatecall.func2.selector);
    }
}
