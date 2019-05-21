//
//  BXHMacros.h
//  BXHReact
//
//  Created by 步晓虎 on 2019/5/18.
//  Copyright © 2019 步晓虎. All rights reserved.
//

#ifndef BXHMacros_h
#define BXHMacros_h

#define BXHBlockFor(COUNT,MARCO)     BXHBlockValue##COUNT(MARCO)

#define BXHBlockValue1(MARCO)   MARCO(0)
#define BXHBlockValue2(MARCO)   BXHBlockValue1(MARCO), MARCO(1)
#define BXHBlockValue3(MARCO)   BXHBlockValue2(MARCO), MARCO(2)
#define BXHBlockValue4(MARCO)   BXHBlockValue3(MARCO), MARCO(3)
#define BXHBlockValue5(MARCO)   BXHBlockValue4(MARCO), MARCO(4)
#define BXHBlockValue6(MARCO)   BXHBlockValue5(MARCO), MARCO(5)
#define BXHBlockValue7(MARCO)   BXHBlockValue6(MARCO), MARCO(6)
#define BXHBlockValue8(MARCO)   BXHBlockValue7(MARCO), MARCO(7)
#define BXHBlockValue9(MARCO)   BXHBlockValue8(MARCO), MARCO(8)
#define BXHBlockValue10(MARCO)  BXHBlockValue9(MARCO), MARCO(9)
#define BXHBlockValue11(MARCO)  BXHBlockValue10(MARCO), MARCO(10)
#define BXHBlockValue12(MARCO)  BXHBlockValue11(MARCO), MARCO(11)
#define BXHBlockValue13(MARCO)  BXHBlockValue12(MARCO), MARCO(12)
#define BXHBlockValue14(MARCO)  BXHBlockValue13(MARCO), MARCO(13)
#define BXHBlockValue15(MARCO)  BXHBlockValue14(MARCO), MARCO(14)
#define BXHBlockValue16(MARCO)  BXHBlockValue15(MARCO), MARCO(15)
#define BXHBlockValue17(MARCO)  BXHBlockValue16(MARCO), MARCO(16)
#define BXHBlockValue18(MARCO)  BXHBlockValue17(MARCO), MARCO(17)
#define BXHBlockValue19(MARCO)  BXHBlockValue18(MARCO), MARCO(18)
#define BXHBlockValue20(MARCO)  BXHBlockValue19(MARCO), MARCO(19)

#define BXHSWITCH(COUNT,MARCO)\
switch (COUNT) {\
case 1: {MARCO(1)}break;\
case 2: {MARCO(2)}break;\
case 3: {MARCO(3)}break;\
case 4: {MARCO(4)}break;\
case 5: {MARCO(5)}break;\
case 6: {MARCO(6)}break;\
case 7: {MARCO(7)}break;\
case 8: {MARCO(8)}break;\
case 9: {MARCO(9)}break;\
case 10: {MARCO(10)}break;\
case 11: {MARCO(11)}break;\
case 12: {MARCO(12)}break;\
case 13: {MARCO(13)}break;\
case 14: {MARCO(14)}break;\
case 15: {MARCO(15)}break;\
case 16: {MARCO(16)}break;\
case 17: {MARCO(17)}break;\
case 18: {MARCO(18)}break;\
case 19: {MARCO(19)}break;\
case 20: {MARCO(20)}break;\
default:break;\
}

#define BXH_KeyPath(OBJ, PATH)                          (((void)(NO && ((void)OBJ.PATH, NO)), @# PATH))

#define BXHNode(TARGET,KEYPATH)                    ([TARGET bxh_node:BXH_KeyPath(TARGET,KEYPATH)])

#define BXHObserver(TARGET,KEYPATH)                ([TARGET bxh_observer:BXH_KeyPath(TARGET,KEYPATH)])

#define BXHObserverOptions(TARGET,KEYPATH,OPTIONS) ([TARGET bxh_observer:BXH_KeyPath(TARGET,KEYPATH) options:OPTIONS])

#endif /* BXHMacros_h */
