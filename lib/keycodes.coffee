# should probably be .cson
module.exports = [
  [8,   0xff08, 0xff08], # bs
  [9,   0xff09, 0xff09], # tab
  [13,  0xff0d, 0xff0d], # ent
  [16,  0xffe1, 0xffe1], # shift (left)
  [16,  0xffe2, 0xffe2], # shift (right) warning: jquery returns 16 for both!
  [17,  0xffe3, 0xffe3], # ctrl (left)
  [17,  0xffe4, 0xffe4], # ctrl (right) warning: jquery returns 17 for both!
  [18,  0xffe9, 0xffe9], # alt (left)
  [18,  0xffea, 0xffea], # alt (right) warning: jquery returns 18 for both!
  [27,  0xff1b, 0xff1b], # esc
  [32,  32,     32    ], # spc
  [33,  0xff55, 0xff55], # pgup
  [34,  0xff56, 0xff56], # pgdn
  [35,  0xff57, 0xff57], # end
  [36,  0xff50, 0xff50], # home
  [37,  0xff51, 0xff51], # left
  [38,  0xff52, 0xff52], # up
  [39,  0xff53, 0xff53], # right
  [40,  0xff54, 0xff54], # down
  [45,  0xff63, 0xff63], # ins
  [46,  0xffff, 0xffff], # del
  [48,  48,     41    ], # 0
  [49,  49,     33    ], # 1
  [50,  50,     64    ], # 2
  [51,  51,     35    ], # 3
  [52,  52,     36    ], # 4
  [53,  53,     37    ], # 5
  [54,  54,     94    ], # 6
  [55,  55,     38    ], # 7
  [56,  56,     42    ], # 8
  [57,  57,     40    ], # 9
  [65,  97,     65    ], # A
  [66,  98,     66    ], # B
  [67,  99,     67    ], # C
  [68,  100,    68    ], # D
  [69,  101,    69    ], # E
  [70,  102,    70    ], # F
  [71,  103,    71    ], # G
  [72,  104,    72    ], # H
  [73,  105,    73    ], # I
  [74,  106,    74    ], # J
  [75,  107,    75    ], # K
  [76,  108,    76    ], # L
  [77,  109,    77    ], # M
  [78,  110,    78    ], # N
  [79,  111,    79    ], # O
  [80,  112,    80    ], # P
  [81,  113,    81    ], # Q
  [82,  114,    82    ], # R
  [83,  115,    83    ], # S
  [84,  116,    84    ], # T
  [85,  117,    85    ], # U
  [86,  118,    86    ], # V
  [87,  119,    87    ], # W
  [88,  120,    88    ], # X
  [89,  121,    89    ], # Y
  [90,  122,    90    ], # Z
  [97,  49,     49    ], # 1 (keypad)
  [98,  50,     50    ], # 2 (keypad)
  [99,  51,     51    ], # 3 (keypad)
  [100, 52,     52    ], # 4 (keypad)
  [101, 53,     53    ], # 5 (keypad)
  [102, 54,     54    ], # 6 (keypad)
  [103, 55,     55    ], # 7 (keypad)
  [104, 56,     56    ], # 8 (keypad)
  [105, 57,     57    ], # 9 (keypad)
  [106, 42,     42    ], # * (keypad)
  [107, 61,     61    ], # + (keypad)
  [109, 45,     45    ], # - (keypad)
  [110, 46,     46    ], # . (keypad)
  [111, 47,     47    ], # / (keypad)
  [112, 0xffbe, 0xffbe], # f1
  [113, 0xffbf, 0xffbf], # f2
  [114, 0xffc0, 0xffc0], # f3
  [115, 0xffc1, 0xffc1], # f4
  [116, 0xffc2, 0xffc2], # f5
  [117, 0xffc3, 0xffc3], # f6
  [118, 0xffc4, 0xffc4], # f7
  [119, 0xffc5, 0xffc5], # f8
  [120, 0xffc6, 0xffc6], # f9
  [121, 0xffc7, 0xffc7], # f10
  [122, 0xffc8, 0xffc8], # f11
  [123, 0xffc9, 0xffc9], # f12
  [186, 59,     58    ], # ;
  [187, 61,     43    ], # =
  [188, 44,     60    ], # ,
  [189, 45,     95    ], # -
  [190, 46,     62    ], # .
  [191, 47,     63    ], # /
  [192, 96,     126   ], # `
  [220, 92,     124   ], # \
  [221, 93,     125   ], # ]
  [222, 39,     34    ], # '
  [219, 91,     123   ]  # [

          # non-handleable keys:
          # 19  - ?????? - break       (no corresponding rfb code)
          # 44  - ?????? - printscreen (no corresponding rfb code)
          # 99  - ?????? - unknown     (fn-break on my keyboard)
          # 144 - ?????? - numlock     (no corresponding rfb code)
          # 145 - ?????? - scrolllock  (no corresponding rfb code)
          # ??? - 0xffe7 - meta-left   (jquery does not capture)
          # ??? - 0xffe8 - meta-right  (jquery does not capture)
]
