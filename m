From: syzbot <syzbot+6f18401420df260e37ed@syzkaller.appspotmail.com>
Subject: KMSAN: uninit-value in __nf_conntrack_find_get
Date: Tue, 17 Jul 2018 07:25:02 -0700
Message-ID: <0000000000002a4cb6057132b614@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
To: coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@blackhole.kfki.hu, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    b64f7ec04e12 kmsan: implement kmsan_memmove_shadow() and k..
git tree:       https://github.com/google/kmsan.git/master
console output: https://syzkaller.appspot.com/x/log.txt?x=109869d0400000
kernel config:  https://syzkaller.appspot.com/x/.config?x=93d57043084eee38
dashboard link: https://syzkaller.appspot.com/bug?extid=6f18401420df260e37ed
compiler:       clang version 7.0.0 (trunk 334104)
syzkaller repro:https://syzkaller.appspot.com/x/repro.syz?x=174cce78400000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16b0b562400000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+6f18401420df260e37ed@syzkaller.appspotmail.com

random: sshd: uninitialized urandom read (32 bytes read)
==================================================================
BUG: KMSAN: uninit-value in ____nf_conntrack_find  
net/netfilter/nf_conntrack_core.c:539 [inline]
BUG: KMSAN: uninit-value in __nf_conntrack_find_get+0xc15/0x2190  
net/netfilter/nf_conntrack_core.c:573
CPU: 0 PID: 4610 Comm: syz-executor884 Not tainted 4.18.0-rc4+ #24
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x185/0x1e0 lib/dump_stack.c:113
  kmsan_report+0x195/0x2c0 mm/kmsan/kmsan.c:1092
  __msan_warning_32+0x7d/0xe0 mm/kmsan/kmsan_instr.c:640
  ____nf_conntrack_find net/netfilter/nf_conntrack_core.c:539 [inline]
  __nf_conntrack_find_get+0xc15/0x2190 net/netfilter/nf_conntrack_core.c:573
  resolve_normal_ct net/netfilter/nf_conntrack_core.c:1331 [inline]
  nf_conntrack_in+0x1674/0x2070 net/netfilter/nf_conntrack_core.c:1416
  ipv6_conntrack_local+0xc3/0xf0  
net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c:179
  nf_hook_entry_hookfn include/linux/netfilter.h:119 [inline]
  nf_hook_slow+0x15d/0x3e0 net/netfilter/core.c:511
  nf_hook include/linux/netfilter.h:242 [inline]
  __ip6_local_out+0x64c/0x770 net/ipv6/output_core.c:164
  ip6_local_out+0xa4/0x1d0 net/ipv6/output_core.c:174
  ip6_send_skb net/ipv6/ip6_output.c:1696 [inline]
  ip6_push_pending_frames+0x218/0x4d0 net/ipv6/ip6_output.c:1716
  rawv6_push_pending_frames net/ipv6/raw.c:616 [inline]
  rawv6_sendmsg+0x45f0/0x5410 net/ipv6/raw.c:935
  inet_sendmsg+0x3fc/0x760 net/ipv4/af_inet.c:798
  sock_sendmsg_nosec net/socket.c:641 [inline]
  sock_sendmsg net/socket.c:651 [inline]
  __sys_sendto+0x798/0x8e0 net/socket.c:1797
  __do_sys_sendto net/socket.c:1809 [inline]
  __se_sys_sendto net/socket.c:1805 [inline]
  __x64_sys_sendto+0x1a1/0x210 net/socket.c:1805
  do_syscall_64+0x15b/0x230 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x63/0xe7
RIP: 0033:0x4459c9
Code: e8 bc e7 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 2b 0e fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fa03df22d98 EFLAGS: 00000212 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00000000006dac24 RCX: 00000000004459c9
RDX: 000000000000fedf RSI: 0000000020000000 RDI: 0000000000000004
RBP: 0000000000000000 R08: 0000000020000180 R09: 000000000000001a
R10: 0000000000000000 R11: 0000000000000212 R12: 00000000006dac20
R13: 616e732f7665642f R14: 00007fa03df239c0 R15: 0000000000000001

Uninit was stored to memory at:
  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:256 [inline]
  kmsan_save_stack mm/kmsan/kmsan.c:271 [inline]
  kmsan_internal_chain_origin+0x13c/0x240 mm/kmsan/kmsan.c:683
  __msan_chain_origin+0x76/0xd0 mm/kmsan/kmsan_instr.c:483
  __nf_conntrack_confirm+0x2700/0x3f70 net/netfilter/nf_conntrack_core.c:793
  nf_conntrack_confirm include/net/netfilter/nf_conntrack_core.h:71 [inline]
  ipv6_confirm+0x573/0x740 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c:165
  nf_hook_entry_hookfn include/linux/netfilter.h:119 [inline]
  nf_hook_slow+0x15d/0x3e0 net/netfilter/core.c:511
  nf_hook include/linux/netfilter.h:242 [inline]
  NF_HOOK_COND include/linux/netfilter.h:275 [inline]
  ip6_output+0x37d/0x710 net/ipv6/ip6_output.c:171
  dst_output include/net/dst.h:444 [inline]
  ip6_local_out+0x164/0x1d0 net/ipv6/output_core.c:176
  ip6_send_skb net/ipv6/ip6_output.c:1696 [inline]
  ip6_push_pending_frames+0x218/0x4d0 net/ipv6/ip6_output.c:1716
  rawv6_push_pending_frames net/ipv6/raw.c:616 [inline]
  rawv6_sendmsg+0x45f0/0x5410 net/ipv6/raw.c:935
  inet_sendmsg+0x3fc/0x760 net/ipv4/af_inet.c:798
  sock_sendmsg_nosec net/socket.c:641 [inline]
  sock_sendmsg net/socket.c:651 [inline]
  __sys_sendto+0x798/0x8e0 net/socket.c:1797
  __do_sys_sendto net/socket.c:1809 [inline]
  __se_sys_sendto net/socket.c:1805 [inline]
  __x64_sys_sendto+0x1a1/0x210 net/socket.c:1805
  do_syscall_64+0x15b/0x230 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x63/0xe7

Uninit was created at:
  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:256 [inline]
  kmsan_internal_poison_shadow+0xc8/0x1d0 mm/kmsan/kmsan.c:181
  kmsan_kmalloc+0xa1/0x120 mm/kmsan/kmsan_hooks.c:91
  kmem_cache_alloc+0xad2/0xbb0 mm/slub.c:2739
  __nf_conntrack_alloc+0x166/0x670 net/netfilter/nf_conntrack_core.c:1137
  init_conntrack+0x635/0x2840 net/netfilter/nf_conntrack_core.c:1219
  resolve_normal_ct net/netfilter/nf_conntrack_core.c:1333 [inline]
  nf_conntrack_in+0x1812/0x2070 net/netfilter/nf_conntrack_core.c:1416
  ipv6_conntrack_local+0xc3/0xf0  
net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c:179
  nf_hook_entry_hookfn include/linux/netfilter.h:119 [inline]
  nf_hook_slow+0x15d/0x3e0 net/netfilter/core.c:511
  nf_hook include/linux/netfilter.h:242 [inline]
  __ip6_local_out+0x64c/0x770 net/ipv6/output_core.c:164
  ip6_local_out+0xa4/0x1d0 net/ipv6/output_core.c:174
  ip6_send_skb net/ipv6/ip6_output.c:1696 [inline]
  ip6_push_pending_frames+0x218/0x4d0 net/ipv6/ip6_output.c:1716
  rawv6_push_pending_frames net/ipv6/raw.c:616 [inline]
  rawv6_sendmsg+0x45f0/0x5410 net/ipv6/raw.c:935
  inet_sendmsg+0x3fc/0x760 net/ipv4/af_inet.c:798
  sock_sendmsg_nosec net/socket.c:641 [inline]
  sock_sendmsg net/socket.c:651 [inline]
  __sys_sendto+0x798/0x8e0 net/socket.c:1797
  __do_sys_sendto net/socket.c:1809 [inline]
  __se_sys_sendto net/socket.c:1805 [inline]
  __x64_sys_sendto+0x1a1/0x210 net/socket.c:1805
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
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
