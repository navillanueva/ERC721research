**How does ERC721A save gas?**

ERC721A made three main optimizations, which are most notably felt when compared to ERC721Enumerable, but also better than the standard ERC721 used by OpenZeppelin:

    - optimization 1: removing the use of ERC721Enumerable eliminates some read/writes to storage

    - optimization 2: updating the owner's balance only once, this is possibly by accounting and expecting batch minting to happen

    ```


    ```

**Where does it add cost?**
