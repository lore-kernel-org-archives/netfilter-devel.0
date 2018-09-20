From: syzbot <syzbot+e45eda8eda6e93a03959@syzkaller.appspotmail.com>
Subject: general protection fault in ctnetlink_alloc_filter
Date: Thu, 20 Sep 2018 14:04:04 -0700
Message-ID: <000000000000f4bf02057653dc0a@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
To: coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@blackhole.kfki.hu, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    3eb5358079d3 Add linux-next specific files for 20180918
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=171ce6f1400000
kernel config:  https://syzkaller.appspot.com/x/.config?x=786006c5dafbadf6
dashboard link: https://syzkaller.appspot.com/bug?extid=e45eda8eda6e93a03959
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=114f76fa400000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=102ed6c6400000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+e45eda8eda6e93a03959@syzkaller.appspotmail.com

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 5551 Comm: syz-executor610 Not tainted  
4.19.0-rc4-next-20180918+ #74
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:nla_get_be32 include/net/netlink.h:1082 [inline]
RIP: 0010:ctnetlink_alloc_filter+0xb9/0x200  
net/netfilter/nf_conntrack_netlink.c:843
Code: 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 57 01 00 00 48 b8 00 00 00 00 00  
fc ff df 4d 8b 6c 24 40 49 8d 7d 04 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48  
89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 06
RSP: 0018:ffff8801c48f71a0 EFLAGS: 00010247
RAX: dffffc0000000000 RBX: ffff8801d7acd580 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff864dfefd RDI: 0000000000000004
RBP: ffff8801c48f71b8 R08: ffff8801d957a180 R09: ffffed003b585b57
R10: ffffed003b585b57 R11: ffff8801dac2dabb R12: ffff8801c48f7500
R13: 0000000000000000 R14: ffff8801d90ef2b8 R15: ffff8801d90ef291
FS:  0000000000a90880(0000) GS:ffff8801dac00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000100 CR3: 00000001d9104000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  ctnetlink_start+0x10b/0x1b0 net/netfilter/nf_conntrack_netlink.c:857
  __netlink_dump_start+0x43e/0x6f0 net/netlink/af_netlink.c:2312
  netlink_dump_start include/linux/netlink.h:213 [inline]
  ctnetlink_get_conntrack+0x777/0x9f0  
net/netfilter/nf_conntrack_netlink.c:1320
  nfnetlink_rcv_msg+0xdd3/0x10c0 net/netfilter/nfnetlink.c:228
  netlink_rcv_skb+0x172/0x440 net/netlink/af_netlink.c:2447
  nfnetlink_rcv+0x1c0/0x4d0 net/netfilter/nfnetlink.c:560
  netlink_unicast_kernel net/netlink/af_netlink.c:1310 [inline]
  netlink_unicast+0x5a5/0x760 net/netlink/af_netlink.c:1336
  netlink_sendmsg+0xa18/0xfc0 net/netlink/af_netlink.c:1901
  sock_sendmsg_nosec net/socket.c:622 [inline]
  sock_sendmsg+0xd5/0x120 net/socket.c:632
  ___sys_sendmsg+0x7fd/0x930 net/socket.c:2117
  __sys_sendmsg+0x11d/0x280 net/socket.c:2155
  __do_sys_sendmsg net/socket.c:2164 [inline]
  __se_sys_sendmsg net/socket.c:2162 [inline]
  __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2162
  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4400d9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fff461c2298 EFLAGS: 00000213 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 00000000004400d9
RDX: 0000000000000000 RSI: 0000000020d65000 RDI: 0000000000000003
RBP: 00000000006ca018 R08: 0000000000000000 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000213 R12: 0000000000401960
R13: 00000000004019f0 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace 37c3db5bd5270e98 ]---
RIP: 0010:nla_get_be32 include/net/netlink.h:1082 [inline]
RIP: 0010:ctnetlink_alloc_filter+0xb9/0x200  
net/netfilter/nf_conntrack_netlink.c:843
Code: 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 57 01 00 00 48 b8 00 00 00 00 00  
fc ff df 4d 8b 6c 24 40 49 8d 7d 04 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48  
89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 06
RSP: 0018:ffff8801c48f71a0 EFLAGS: 00010247
RAX: dffffc0000000000 RBX: ffff8801d7acd580 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff864dfefd RDI: 0000000000000004
RBP: ffff8801c48f71b8 R08: ffff8801d957a180 R09: ffffed003b585b57
R10: ffffed003b585b57 R11: ffff8801dac2dabb R12: ffff8801c48f7500
R13: 0000000000000000 R14: ffff8801d90ef2b8 R15: ffff8801d90ef291
FS:  0000000000a90880(0000) GS:ffff8801dac00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000100 CR3: 00000001d9104000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with  
syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
