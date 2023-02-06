// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract MultiDelegatecall {
    function multiDelegatecall(bytes[] calldata _data) public returns (bytes[] memory results) {
        results = new bytes[](_data.length);
        for (uint256 i; i < _data.length; i++) {
            (bool ok, bytes memory res) = address(this).delegatecall(_data[i]);
            require(ok);
            results[i] = res;
        }
    }
}

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
