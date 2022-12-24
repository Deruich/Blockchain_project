from brownie import accounts, config, Matic
from scripts.helpful_scripts import get_account


initial_supply = 1000000000000000000000  # 1000
token_name = "Matic"
token_symbol = "MATIC"


def main():
    account = get_account()
    erc20 = Matic.deploy(
        initial_supply, token_name, token_symbol, {"from": account}
    )