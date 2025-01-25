// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTTree is ERC721, Ownable {
    enum TreeState { Healthy, Neutral, Withered }

    mapping(uint256 => TreeState) private _treeStates;
    mapping(uint256 => uint256) private _lastUpdated; // Время последнего обновления состояния дерева
    uint256 private _tokenIds;

    // Периоды изменения состояния (в секундах)
    uint256 private constant STATE_CHANGE_INTERVAL = 1 days;

    constructor() ERC721("NFTree", "TREE") Ownable(msg.sender) {}

    function mintTree() external returns (uint256) {
        _tokenIds++;
        uint256 newTreeId = _tokenIds;

        _safeMint(msg.sender, newTreeId);
        _treeStates[newTreeId] = TreeState.Neutral;
        _lastUpdated[newTreeId] = block.timestamp; // Устанавливаем текущее время как время последнего обновления

        return newTreeId;
    }

    function getTreeState(uint256 tokenId) public view returns (TreeState) {
        return _calculateCurrentState(tokenId);
    }

    function waterTree(uint256 tokenId) external {
        require(ownerOf(tokenId) == msg.sender, "You don't own this tree");

        // Обновляем состояние дерева перед взаимодействием
        _updateTreeState(tokenId);

        // Улучшаем состояние дерева
        if (_treeStates[tokenId] == TreeState.Withered) {
            _treeStates[tokenId] = TreeState.Neutral;
        } else if (_treeStates[tokenId] == TreeState.Neutral) {
            _treeStates[tokenId] = TreeState.Healthy;
        }

        // Обновляем время последнего взаимодействия
        _lastUpdated[tokenId] = block.timestamp;
    }

    function _updateTreeState(uint256 tokenId) internal {
        uint256 timeElapsed = block.timestamp - _lastUpdated[tokenId];

        if (timeElapsed >= STATE_CHANGE_INTERVAL) {
            uint256 steps = timeElapsed / STATE_CHANGE_INTERVAL;

            for (uint256 i = 0; i < steps; i++) {
                if (_treeStates[tokenId] == TreeState.Healthy) {
                    _treeStates[tokenId] = TreeState.Neutral;
                } else if (_treeStates[tokenId] == TreeState.Neutral) {
                    _treeStates[tokenId] = TreeState.Withered;
                } else if (_treeStates[tokenId] == TreeState.Withered) {
                    break;
                }
            }

            _lastUpdated[tokenId] = block.timestamp;
        }
    }

    function _calculateCurrentState(uint256 tokenId) internal view returns (TreeState) {
        uint256 timeElapsed = block.timestamp - _lastUpdated[tokenId];
        TreeState currentState = _treeStates[tokenId];

        if (timeElapsed >= STATE_CHANGE_INTERVAL) {
            uint256 steps = timeElapsed / STATE_CHANGE_INTERVAL;

            for (uint256 i = 0; i < steps; i++) {
                if (currentState == TreeState.Healthy) {
                    currentState = TreeState.Neutral;
                } else if (currentState == TreeState.Neutral) {
                    currentState = TreeState.Withered;
                } else if (currentState == TreeState.Withered) {
                    break;
                }
            }
        }

        return currentState;
    }
}
