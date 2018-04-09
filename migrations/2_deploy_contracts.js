
var TstToken = artifacts.require("TstToken.sol");
var TstICO = artifacts.require("TstICO.sol");

module.exports = function(deployer, network) {

    var founder, ICOfounder;
    if (network == "live") {
        founder = "0x627306090abab3a6e1400e9345bc60c78a8bef57";
        ICOfounder = founder;
    } else if (network == "ropsten") {
        founder = "0x58B219a8Fd3897303D3C106031736df26Ad3A406";
        ICOfounder = "0x8ad3D6998c0A293Ce7f0f179217Dc8cB882437f6";
    } else {
        founder = "0x627306090abab3a6e1400e9345bc60c78a8bef57";
        ICOfounder = founder;
    }    

	deployer.deploy(TstToken, founder).then(function() {
        return deployer.deploy(TstICO, TstToken.address, ICOfounder);
    }).then(function(tx) {
        return TstToken.deployed();
    }).then(function(tokenContract) {
        return tokenContract.changeMinter(TstICO.address, { from: founder });
    });
};
