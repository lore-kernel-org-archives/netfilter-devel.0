From: syzbot <syzbot+60f2e2b690c5cf94e35d@syzkaller.appspotmail.com>
Subject: KMSAN: uninit-value in iptable_mangle_hook (3)
Date: Fri, 27 Jul 2018 06:12:02 -0700
Message-ID: <00000000000086085a0571fadb3a@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
To: coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@blackhole.kfki.hu, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    d1c2a46a46f6 kmsan: update LLVM/Clang patches to r337583.
git tree:       https://github.com/google/kmsan.git/master
console output: https://syzkaller.appspot.com/x/log.txt?x=16a2732c400000
kernel config:  https://syzkaller.appspot.com/x/.config?x=31cf75cbffdedb44
dashboard link: https://syzkaller.appspot.com/bug?extid=60f2e2b690c5cf94e35d
compiler:       clang version 7.0.0 (trunk 334104)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+60f2e2b690c5cf94e35d@syzkaller.appspotmail.com

==================================================================
BUG: KMSAN: uninit-value in ipt_mangle_out  
net/ipv4/netfilter/iptable_mangle.c:64 [inline]
BUG: KMSAN: uninit-value in iptable_mangle_hook+0x622/0x720  
net/ipv4/netfilter/iptable_mangle.c:84
CPU: 0 PID: 15708 Comm: syz-executor0 Not tainted 4.18.0-rc5+ #29
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x185/0x1e0 lib/dump_stack.c:113
  kmsan_report+0x195/0x2c0 mm/kmsan/kmsan.c:982
  __msan_warning+0x7d/0xe0 mm/kmsan/kmsan_instr.c:645
  ipt_mangle_out net/ipv4/netfilter/iptable_mangle.c:64 [inline]
  iptable_mangle_hook+0x622/0x720 net/ipv4/netfilter/iptable_mangle.c:84
  nf_hook_entry_hookfn include/linux/netfilter.h:119 [inline]
  nf_hook_slow+0x15d/0x3e0 net/netfilter/core.c:511
  nf_hook include/linux/netfilter.h:242 [inline]
  __ip_local_out+0x705/0x830 net/ipv4/ip_output.c:113
  ip_local_out+0xa4/0x1d0 net/ipv4/ip_output.c:122
  iptunnel_xmit+0x854/0xdb0 net/ipv4/ip_tunnel_core.c:91
  ip_tunnel_xmit+0x373a/0x3b10 net/ipv4/ip_tunnel.c:778
  __gre_xmit net/ipv4/ip_gre.c:449 [inline]
  ipgre_xmit+0xe16/0xef0 net/ipv4/ip_gre.c:701
  __netdev_start_xmit include/linux/netdevice.h:4148 [inline]
  netdev_start_xmit include/linux/netdevice.h:4157 [inline]
  xmit_one net/core/dev.c:3034 [inline]
  dev_hard_start_xmit+0x60f/0xcc0 net/core/dev.c:3050
  __dev_queue_xmit+0x3060/0x3c70 net/core/dev.c:3569
  dev_queue_xmit+0x4b/0x60 net/core/dev.c:3602
  packet_snd net/packet/af_packet.c:2919 [inline]
  packet_sendmsg+0x8469/0x9010 net/packet/af_packet.c:2944
  sock_sendmsg_nosec net/socket.c:641 [inline]
  sock_sendmsg net/socket.c:651 [inline]
  ___sys_sendmsg+0xed9/0x1350 net/socket.c:2125
  __sys_sendmsg net/socket.c:2163 [inline]
  __do_sys_sendmsg net/socket.c:2172 [inline]
  __se_sys_sendmsg net/socket.c:2170 [inline]
  __x64_sys_sendmsg+0x3b0/0x520 net/socket.c:2170
  do_syscall_64+0x15b/0x230 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x63/0xe7
RIP: 0033:0x455ab9
Code: 1d ba fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 eb b9 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fd96a1bfc68 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fd96a1c06d4 RCX: 0000000000455ab9
RDX: 0000000000000000 RSI: 0000000020000000 RDI: 0000000000000014
RBP: 000000000072bea0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 00000000004c1066 R14: 00000000004d16c8 R15: 0000000000000000

Uninit was stored to memory at:
  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:256 [inline]
  kmsan_save_stack mm/kmsan/kmsan.c:271 [inline]
  kmsan_internal_chain_origin+0x13c/0x240 mm/kmsan/kmsan.c:573
  __msan_chain_origin+0x76/0xd0 mm/kmsan/kmsan_instr.c:483
  iptunnel_xmit+0xa48/0xdb0 net/ipv4/ip_tunnel_core.c:85
  ip_tunnel_xmit+0x373a/0x3b10 net/ipv4/ip_tunnel.c:778
  __gre_xmit net/ipv4/ip_gre.c:449 [inline]
  ipgre_xmit+0xe16/0xef0 net/ipv4/ip_gre.c:701
  __netdev_start_xmit include/linux/netdevice.h:4148 [inline]
  netdev_start_xmit include/linux/netdevice.h:4157 [inline]
  xmit_one net/core/dev.c:3034 [inline]
  dev_hard_start_xmit+0x60f/0xcc0 net/core/dev.c:3050
  __dev_queue_xmit+0x3060/0x3c70 net/core/dev.c:3569
  dev_queue_xmit+0x4b/0x60 net/core/dev.c:3602
  packet_snd net/packet/af_packet.c:2919 [inline]
  packet_sendmsg+0x8469/0x9010 net/packet/af_packet.c:2944
  sock_sendmsg_nosec net/socket.c:641 [inline]
  sock_sendmsg net/socket.c:651 [inline]
  ___sys_sendmsg+0xed9/0x1350 net/socket.c:2125
  __sys_sendmsg net/socket.c:2163 [inline]
  __do_sys_sendmsg net/socket.c:2172 [inline]
  __se_sys_sendmsg net/socket.c:2170 [inline]
  __x64_sys_sendmsg+0x3b0/0x520 net/socket.c:2170
  do_syscall_64+0x15b/0x230 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x63/0xe7

Uninit was created at:
  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:256 [inline]
  kmsan_internal_poison_shadow+0xc8/0x1d0 mm/kmsan/kmsan.c:181
  kmsan_kmalloc+0xa1/0x120 mm/kmsan/kmsan_hooks.c:91
  kmsan_slab_alloc+0x10/0x20 mm/kmsan/kmsan_hooks.c:100
  slab_post_alloc_hook mm/slab.h:446 [inline]
  slab_alloc_node mm/slub.c:2720 [inline]
  __kmalloc_node_track_caller+0xb48/0x11d0 mm/slub.c:4353
  __kmalloc_reserve net/core/skbuff.c:138 [inline]
  __alloc_skb+0x2cb/0x9e0 net/core/skbuff.c:206
  alloc_skb include/linux/skbuff.h:988 [inline]
  alloc_skb_with_frags+0x1e6/0xb80 net/core/skbuff.c:5271
  sock_alloc_send_pskb+0xb59/0x11e0 net/core/sock.c:2095
  packet_alloc_skb net/packet/af_packet.c:2776 [inline]
  packet_snd net/packet/af_packet.c:2867 [inline]
  packet_sendmsg+0x68cb/0x9010 net/packet/af_packet.c:2944
  sock_sendmsg_nosec net/socket.c:641 [inline]
  sock_sendmsg net/socket.c:651 [inline]
  ___sys_sendmsg+0xed9/0x1350 net/socket.c:2125
  __sys_sendmsg net/socket.c:2163 [inline]
  __do_sys_sendmsg net/socket.c:2172 [inline]
  __se_sys_sendmsg net/socket.c:2170 [inline]
  __x64_sys_sendmsg+0x3b0/0x520 net/socket.c:2170
  do_syscall_64+0x15b/0x230 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x63/0xe7
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with  
syzbot.
