// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

import { Base64 } from "./libraries/Base64.sol";

contract MyEpicNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' />";
    string baseFirstText = "<text x='50%' y='40%' class='base' dominant-baseline='middle' text-anchor='middle'>";
    string baseSecondText = "<text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";
    string baseThirdText = "<text x='50%' y='60%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    string[] firstWords = ["Water Breathing", "Flame Breathing", "Thunder Breathing", "Wind Breathing", "Beast Breathing", "Hinokami Kagura", "Stone Breathing", "Insect Breathing", "Flower Breathing", "Love Breathing", "Serpent Breathing", "Sound Breathing", "Mist Breathing", "Moon Breathing"];
    string[] secondWords = ["First Form", "Second Form", "Third Form", "Fourth Form", "Fifth Form", "Sixth Form", "Seventh Form", "Eighth Form", "Ninth Form", "Tenth Form", "Eleventh Form", "Twelveth Form", "Thirteenth Form", "Fourteenth Form"];
    string[] thirdWords = ["Thunderclap and Flash", "Rising Scorching Sun", "Flowing Dance", "Rising Dust Storm", "Crazy Cutting", "Dragon Sun Halo Head Dance", "Serpentinite Bipolar", "Hundred-Legged Zigzag", "Crimson Hanagoromo", "Coil Choke", "Catlove Shower", "String Performance", "String Performance", "Dark Moon - Evening Palace"];

    event NewEpicNFTMinted(address sender, uint256 tokenId);

    constructor() ERC721 ("SquareNFT", "SQUARE") {
        console.log("This is my NFT contract. Whoa!");
    }

    function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
        rand = rand % firstWords.length;
        return firstWords[rand];
    }

    function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
        rand = rand % secondWords.length;
        return secondWords[rand];
    }

    function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
        rand = rand % thirdWords.length;
        return thirdWords[rand];
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function getTotalNFTsMintedSoFar() public view returns (uint256) {
        uint256 newItemId = _tokenIds.current();
        console.log("%s NFTs have minted!", newItemId);
        return newItemId;
    }

    function makeAnEpicNFT() public {
        uint256 mintLimit = 500;
        uint256 newItemId = _tokenIds.current();
        require(newItemId < mintLimit, "All NFTs have already minted");

        string memory first = pickRandomFirstWord(newItemId);
        string memory second = pickRandomSecondWord(newItemId);
        string memory third = pickRandomThirdWord(newItemId);
        string memory combinedWord = string(abi.encodePacked(first, second, third));

        string memory finalSvg = string(abi.encodePacked(baseSvg, baseFirstText, first, "</text>", baseSecondText, second, "</text>", baseThirdText, third, "</text>", "</svg>"));

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        combinedWord,
                        '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log("\n--------------------");
        console.log(finalTokenUri);
        console.log("--------------------\n");

        _safeMint(msg.sender, newItemId);

        _setTokenURI(newItemId, finalTokenUri);

        _tokenIds.increment();
        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);
        emit NewEpicNFTMinted(msg.sender, newItemId);
    }
}