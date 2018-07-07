From: syzbot <syzbot+7b269953d076326d7de0@syzkaller.appspotmail.com>
Subject: KASAN: stack-out-of-bounds Read in vmalloc_fault
Date: Fri, 06 Jul 2018 18:19:02 -0700
Message-ID: <000000000000d8e31b05705e901b@google.com>
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

HEAD commit:    6fcf9b1d4d6c r8169: fix runtime suspend
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=174529b2400000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d264f2b04177ca7c
dashboard link: https://syzkaller.appspot.com/bug?extid=7b269953d076326d7de0
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
syzkaller repro:https://syzkaller.appspot.com/x/repro.syz?x=1397e2c2400000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=120e462c400000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+7b269953d076326d7de0@syzkaller.appspotmail.com

IPv6: ADDRCONF(NETDEV_CHANGE): veth0: link becomes ready
IPv6: ADDRCONF(NETDEV_CHANGE): bond0: link becomes ready
IPv6: ADDRCONF(NETDEV_UP): team0: link is not ready
8021q: adding VLAN 0 to HW filter on device team0
==================================================================
BUG: KASAN: stack-out-of-bounds in pgd_val  
arch/x86/include/asm/paravirt.h:412 [inline]
BUG: KASAN: stack-out-of-bounds in p4d_pfn  
arch/x86/include/asm/pgtable.h:205 [inline]
BUG: KASAN: stack-out-of-bounds in vmalloc_fault+0x743/0x760  
arch/x86/mm/fault.c:462
Read of size 8 at addr ffff8801a936f160 by task ksoftirqd/0/9

CPU: 0 PID: 9 Comm: ksoftirqd/0 Not tainted 4.18.0-rc3+ #47
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1c9/0x2b4 lib/dump_stack.c:113
  print_address_description+0x6c/0x20b mm/kasan/report.c:256
  kasan_report_error mm/kasan/report.c:354 [inline]
  kasan_report.cold.7+0x242/0x2fe mm/kasan/report.c:412
  __asan_report_load8_noabort+0x14/0x20 mm/kasan/report.c:433
  pgd_val arch/x86/include/asm/paravirt.h:412 [inline]
  p4d_pfn arch/x86/include/asm/pgtable.h:205 [inline]
  vmalloc_fault+0x743/0x760 arch/x86/mm/fault.c:462
  __do_page_fault+0x829/0xe50 arch/x86/mm/fault.c:1245
  do_page_fault+0xf6/0x8c0 arch/x86/mm/fault.c:1471
  page_fault+0x1e/0x30 arch/x86/entry/entry_64.S:1160
RIP: 0010:ebt_do_table+0x1a7/0x2170 net/bridge/netfilter/ebtables.c:208
Code: 24 04 4d 8d ac 24 80 00 00 00 48 89 fa 48 c1 ea 03 0f b6 14 02 48 89  
f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 8f 1e 00 00 <41> 8b 44 24 04  
49 8d 7c 24 38 65 8b 15 28 7f 39 79 48 c1 e0 04 48
RSP: 0018:ffff8801d9ab6ab8 EFLAGS: 00010246
RAX: 0000000000000007 RBX: 0000000000000005 RCX: ffffffff81601dff
RDX: 0000000000000000 RSI: 0000000000000004 RDI: ffffc90001e2c004
RBP: ffff8801d9ab6c88 R08: ffffed003a6f4e49 R09: ffffed003a6f4e48
R10: ffffed003a6f4e48 R11: ffff8801d37a7243 R12: ffffc90001e2c000
R13: ffffc90001e2c080 R14: ffff8801d9ab6cc0 R15: ffff8801d9394380
  ebt_broute+0x200/0x340 net/bridge/netfilter/ebtable_broute.c:60
  br_handle_frame+0x6d1/0x1a20 net/bridge/br_input.c:292
  __netif_receive_skb_core.constprop.140+0x142d/0x3620 net/core/dev.c:4697
  __netif_receive_skb_one_core+0xd0/0x200 net/core/dev.c:4766
  __netif_receive_skb+0x2c/0x1e0 net/core/dev.c:4873
  process_backlog+0x219/0x760 net/core/dev.c:5676
  napi_poll net/core/dev.c:6088 [inline]
  net_rx_action+0x7a5/0x1950 net/core/dev.c:6154
  __do_softirq+0x2e8/0xb17 kernel/softirq.c:288
  run_ksoftirqd+0x86/0x100 kernel/softirq.c:649
  smpboot_thread_fn+0x417/0x870 kernel/smpboot.c:164
  kthread+0x345/0x410 kernel/kthread.c:240
  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:412

The buggy address belongs to the page:
page:ffffea0006a4dbc0 count:1 mapcount:0 mapping:0000000000000000 index:0x0
flags: 0x2fffc0000000000()
raw: 02fffc0000000000 dead000000000100 dead000000000200 0000000000000000
raw: 0000000000000000 0000000000000000 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff8801a936f000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  ffff8801a936f080: 00 00 00 f1 f1 f1 f1 00 f2 f2 f2 f2 f2 f2 f2 00
> ffff8801a936f100: f2 f2 f2 f2 f2 f2 f2 00 f2 f2 f2 f2 f2 f2 f2 f8
                                                        ^
  ffff8801a936f180: f2 f2 f2 f2 f2 f2 f2 00 f2 f2 f2 00 00 00 00 00
  ffff8801a936f200: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
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
