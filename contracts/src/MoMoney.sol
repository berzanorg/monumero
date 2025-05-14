// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {IERC2981} from "@openzeppelin/contracts/interfaces/IERC2981.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

contract MoMoney is ERC721Enumerable {
    address private immutable _berzan;
    mapping(address minter => uint256 id) private _mintedBy;

    constructor(address berzan) ERC721("MoMoney", "MOMONEY") {
        _berzan = berzan;
        _mint(berzan, 0);
        _mintedBy[berzan] = 0;
    }

    function mintedBy(address minter) external view returns (uint256) {
        if (minter == _berzan) return 0;
        uint256 tokenId = _mintedBy[minter];
        require(tokenId != 0);
        return tokenId;
    }

    function mint() external payable {
        uint256 tokenId = totalSupply();
        require(msg.sender != _berzan);
        require(msg.value == 1 ether);
        require(_mintedBy[msg.sender] == 0);
        require(tokenId < 10_000);
        _mint(msg.sender, tokenId);
        _mintedBy[msg.sender] = tokenId;
        (bool sent,) = payable(_berzan).call{value: 1 ether}("");
        require(sent);
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(tokenId < totalSupply());

        string memory number = Strings.toString(tokenId);

        string memory bg = tokenId < 10 ? "#00f0fe" : tokenId < 100 ? "#ffd404" : tokenId < 1000 ? "#d4d4d4" : "#51fd00";
        string memory fg = tokenId < 10 ? "#00314e" : tokenId < 100 ? "#393100" : tokenId < 1000 ? "#2d2d2d" : "#0b3800";
        string memory material = tokenId < 10 ? "Diamond" : tokenId < 100 ? "Gold" : tokenId < 1000 ? "Silver" : "Cash";

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "MoMoney',
                        " #",
                        number,
                        '","description": "MoMoney more problems!", ',
                        '"attributes": [{"trait_type": "Material", "value": "',
                        material,
                        '"}], "image": "data:image/svg+xml;base64,',
                        Base64.encode(
                            abi.encodePacked(
                                "<svg xmlns='http://www.w3.org/2000/svg' width='2048' height='2048'><path fill='",
                                bg,
                                "' d='M0 0h2048v2048H0V0Z' transform-origin='1024px 1024px'/><text fill='",
                                fg,
                                "' stroke-width='0' font-family='system-ui' font-size='512' font-weight='700' style='white-space:pre' text-anchor='middle'><tspan x='1024.06' y='1218.06' text-decoration='overline solid color(srgb 1 1 1/.8)'>#",
                                number,
                                "</tspan></text></svg>"
                            )
                        ),
                        '"}'
                    )
                )
            )
        );

        return string(abi.encodePacked(_baseURI(), json));
    }

    function royaltyInfo(uint256, /*tokenId*/ uint256 salePrice)
        public
        view
        virtual
        returns (address receiver, uint256 amount)
    {
        return (_berzan, (salePrice * 10) / 100);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
    }
}
