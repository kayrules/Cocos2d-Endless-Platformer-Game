# Endless Platformer

Project Name: Cocos2d Endless Platformer Game
Author: KayRules, Fleezo.com
Email: kayrules@gmail.com
Descriptions:
* This project is an experimental endless platformer game build using cocos2d. 

Features:
* Random height positioning of platforms
* Automatic difficulty increment in speed & platform gaps
* just need to supply 3 platform images with size of 300x160 in pixel

Notes:
* To fix flickering problem between joined images, need some modification on cocos2d/config.h by changing this value to 1 (default is 0).

`#define CC_FIX_ARTIFACTS_BY_STRECHING_TEXEL 1`


## License

The code is released under the [MIT License][1].

Game assets are copyrighted by [KayRules][2]. Please use them only for learning purposes only.

[1]: http://opensource.org/licenses/mit-license.php
[2]: http://fleezo.com/
