// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// The imported things:
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {IERC2981} from "@openzeppelin/contracts/interfaces/IERC2981.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

contract Monumero is ERC721Enumerable {
    address private immutable _berzan;
    mapping(address minter => uint256 id) private _mintedBy;

    constructor(address berzan) ERC721("Monumero", "MONUMERO") {
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
        require(tokenId < 1_000_000);
        _mint(msg.sender, tokenId);
        _mintedBy[msg.sender] = tokenId;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(tokenId < totalSupply());

        string memory number = Strings.toString(tokenId);

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "Monumero',
                        " #",
                        number,
                        '","description": "Fully on-chain number minted on Farcaster.", ',
                        '"attributes": [{"trait_type": "Number", "value": "',
                        number,
                        '"}], "image": "data:image/svg+xml;base64,',
                        Base64.encode(
                            abi.encodePacked(
                                "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 2048 2048' width='2048' height='2048'><path fill='#51fd00' d='M0 0h2048.03v2048.03H0V0Z' transform-origin='1024.03px 1024.03px'/><text x='12.147' y='-19.376' fill='#0b3800' font-family='system-ui' font-size='384' font-weight='700' style='white-space:pre' text-anchor='middle'><tspan x='1024.05' y='1169.63' text-decoration='overline solid color(srgb 1 1 1/.8)' word-spacing='0'>#",
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
