From: syzbot <syzbot+2b43f681169a2a0d306a@syzkaller.appspotmail.com>
Subject: WARNING in ebt_do_table
Date: Tue, 05 Jun 2018 20:47:02 -0700
Message-ID: <000000000000066ad1056df1058c@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
To: bridge@lists.linux-foundation.org, coreteam@netfilter.org,
        davem@davemloft.net, fw@strlen.de, kadlec@blackhole.kfki.hu,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        stephen@networkplumber.org, syzkaller-bugs@googlegroups.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    5037be168f0e Merge branch 'for-linus' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1393dd4f800000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4f65cd4286737868
dashboard link: https://syzkaller.appspot.com/bug?extid=2b43f681169a2a0d306a
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
syzkaller repro:https://syzkaller.appspot.com/x/repro.syz?x=147ef0af800000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15effdef800000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+2b43f681169a2a0d306a@syzkaller.appspotmail.com

IPv6: ADDRCONF(NETDEV_UP): team0: link is not ready
8021q: adding VLAN 0 to HW filter on device team0
IPv6: ADDRCONF(NETDEV_CHANGE): team0: link becomes ready
------------[ cut here ]------------
jump to non-chain
WARNING: CPU: 1 PID: 4490 at net/bridge/netfilter/ebtables.c:283  
ebt_do_table+0x1c45/0x2140 net/bridge/netfilter/ebtables.c:283
Kernel panic - not syncing: panic_on_warn set ...

CPU: 1 PID: 4490 Comm: syz-executor851 Not tainted 4.17.0+ #85
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1b9/0x294 lib/dump_stack.c:113
  panic+0x22f/0x4de kernel/panic.c:184
  __warn.cold.8+0x163/0x1b3 kernel/panic.c:536
  report_bug+0x252/0x2d0 lib/bug.c:186
  fixup_bug arch/x86/kernel/traps.c:178 [inline]
  do_error_trap+0x1fc/0x4d0 arch/x86/kernel/traps.c:296
  do_invalid_op+0x1b/0x20 arch/x86/kernel/traps.c:316
  invalid_op+0x14/0x20 arch/x86/entry/entry_64.S:992
RIP: 0010:ebt_do_table+0x1c45/0x2140 net/bridge/netfilter/ebtables.c:283
Code: 61 6c 9c fa 0f 0b 48 8b bd 48 fe ff ff 31 db e8 71 16 c7 00 e9 29 fe  
ff ff e8 87 39 d0 fa 48 c7 c7 c0 d5 57 88 e8 3b 6c 9c fa <0f> 0b 48 8b bd  
48 fe ff ff 31 db e8 4b 16 c7 00 e9 03 fe ff ff bb
RSP: 0018:ffff8801d9bbdde8 EFLAGS: 00010282
RAX: 0000000000000011 RBX: 0000000000000200 RCX: ffffffff8160d09d
RDX: 0000000000000000 RSI: ffffffff81611d51 RDI: ffff8801d9bbd948
RBP: ffff8801d9bbdfb8 R08: ffff8801ad170080 R09: 0000000000000002
R10: ffff8801ad170080 R11: 0000000000000000 R12: ffffc90001e3c000
R13: ffffc90001e36130 R14: ffffc90001e36090 R15: dffffc0000000000
  ebt_in_hook+0x65/0x80 net/bridge/netfilter/ebtable_filter.c:63
  ebt_out_hook+0x25/0x30 net/bridge/netfilter/ebtable_filter.c:63
  nf_hook_entry_hookfn include/linux/netfilter.h:120 [inline]
  nf_hook_slow+0xc2/0x1c0 net/netfilter/core.c:483
  nf_hook include/linux/netfilter.h:243 [inline]
  NF_HOOK include/linux/netfilter.h:286 [inline]
  __br_forward+0x520/0xd90 net/bridge/br_forward.c:112
  deliver_clone+0x61/0xc0 net/bridge/br_forward.c:128
  maybe_deliver net/bridge/br_forward.c:169 [inline]
  br_flood+0x781/0x8d0 net/bridge/br_forward.c:211
  br_dev_xmit+0x1121/0x1810 net/bridge/br_device.c:103
  __netdev_start_xmit include/linux/netdevice.h:4087 [inline]
  netdev_start_xmit include/linux/netdevice.h:4096 [inline]
  xmit_one net/core/dev.c:3035 [inline]
  dev_hard_start_xmit+0x264/0xc10 net/core/dev.c:3051
  __dev_queue_xmit+0x2724/0x34c0 net/core/dev.c:3566
  dev_queue_xmit+0x17/0x20 net/core/dev.c:3599
  neigh_resolve_output+0x679/0xad0 net/core/neighbour.c:1358
  neigh_output include/net/neighbour.h:482 [inline]
  ip_finish_output2+0xa5f/0x1840 net/ipv4/ip_output.c:229
  ip_do_fragment+0x218e/0x2ac0 net/ipv4/ip_output.c:675
  ip_fragment.constprop.49+0x179/0x240 net/ipv4/ip_output.c:546
  ip_finish_output+0x6cb/0xf80 net/ipv4/ip_output.c:315
  NF_HOOK_COND include/linux/netfilter.h:277 [inline]
  ip_output+0x21b/0x850 net/ipv4/ip_output.c:405
  dst_output include/net/dst.h:444 [inline]
  ip_local_out+0xc5/0x1b0 net/ipv4/ip_output.c:124
  ip_send_skb+0x40/0xe0 net/ipv4/ip_output.c:1425
  udp_send_skb+0x581/0xcc0 net/ipv4/udp.c:803
  udp_push_pending_frames+0x4e/0xe0 net/ipv4/udp.c:831
  udp_sendmsg+0x161e/0x35e0 net/ipv4/udp.c:1072
  udpv6_sendmsg+0x2627/0x30f0 net/ipv6/udp.c:1180
  inet_sendmsg+0x19f/0x690 net/ipv4/af_inet.c:798
  sock_sendmsg_nosec net/socket.c:633 [inline]
  sock_sendmsg+0xd5/0x120 net/socket.c:643
  __sys_sendto+0x3d7/0x670 net/socket.c:1814
  __do_sys_sendto net/socket.c:1826 [inline]
  __se_sys_sendto net/socket.c:1822 [inline]
  __x64_sys_sendto+0xe1/0x1a0 net/socket.c:1822
  do_syscall_64+0x1b1/0x800 arch/x86/entry/common.c:287
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x441ba9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 6b 08 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffddca95978 EFLAGS: 00000213 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000441ba9
RDX: 0000000000000000 RSI: 0000000020000140 RDI: 0000000000000004
RBP: 00000000006cd018 R08: 0000000020000180 R09: 000000000000001c
R10: 0000000000000000 R11: 0000000000000213 R12: 00000000004028a0
R13: 0000000000402930 R14: 0000000000000000 R15: 0000000000000000
Dumping ftrace buffer:
    (ftrace buffer empty)
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with  
syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
