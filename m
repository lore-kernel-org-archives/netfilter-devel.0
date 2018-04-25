From: syzbot <syzbot+4e42a04e0bc33cb6c087@syzkaller.appspotmail.com>
Subject: KASAN: stack-out-of-bounds Write in compat_copy_entries
Date: Tue, 24 Apr 2018 22:19:02 -0700
Message-ID: <000000000000ba10e2056aa5686c@google.com>
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

syzbot hit the following crash on upstream commit
24cac7009cb1b211f1c793ecb6a462c03dc35818 (Tue Apr 24 21:16:40 2018 +0000)
Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
syzbot dashboard link:  
https://syzkaller.appspot.com/bug?extid=4e42a04e0bc33cb6c087

So far this crash happened 3 times on upstream.
syzkaller reproducer:  
https://syzkaller.appspot.com/x/repro.syz?id=4827027970457600
Raw console output:  
https://syzkaller.appspot.com/x/log.txt?id=6212733133389824
Kernel config:  
https://syzkaller.appspot.com/x/.config?id=7043958930931867332
compiler: gcc (GCC) 8.0.1 20180413 (experimental)
user-space arch: i386

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+4e42a04e0bc33cb6c087@syzkaller.appspotmail.com
It will help syzbot understand when the bug is fixed. See footer for  
details.
If you forward the report, please keep this part and the footer.

random: sshd: uninitialized urandom read (32 bytes read)
random: sshd: uninitialized urandom read (32 bytes read)
random: sshd: uninitialized urandom read (32 bytes read)
IPVS: ftp: loaded support on port[0] = 21
==================================================================
BUG: KASAN: stack-out-of-bounds in strlcpy include/linux/string.h:300  
[inline]
BUG: KASAN: stack-out-of-bounds in compat_mtw_from_user  
net/bridge/netfilter/ebtables.c:1957 [inline]
BUG: KASAN: stack-out-of-bounds in ebt_size_mwt  
net/bridge/netfilter/ebtables.c:2059 [inline]
BUG: KASAN: stack-out-of-bounds in size_entry_mwt  
net/bridge/netfilter/ebtables.c:2155 [inline]
BUG: KASAN: stack-out-of-bounds in compat_copy_entries+0x96c/0x14a0  
net/bridge/netfilter/ebtables.c:2194
Write of size 33 at addr ffff8801b0abf888 by task syz-executor0/4504

CPU: 0 PID: 4504 Comm: syz-executor0 Not tainted 4.17.0-rc2+ #40
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1b9/0x294 lib/dump_stack.c:113
  print_address_description+0x6c/0x20b mm/kasan/report.c:256
  kasan_report_error mm/kasan/report.c:354 [inline]
  kasan_report.cold.7+0x242/0x2fe mm/kasan/report.c:412
  check_memory_region_inline mm/kasan/kasan.c:260 [inline]
  check_memory_region+0x13e/0x1b0 mm/kasan/kasan.c:267
  memcpy+0x37/0x50 mm/kasan/kasan.c:303
  strlcpy include/linux/string.h:300 [inline]
  compat_mtw_from_user net/bridge/netfilter/ebtables.c:1957 [inline]
  ebt_size_mwt net/bridge/netfilter/ebtables.c:2059 [inline]
  size_entry_mwt net/bridge/netfilter/ebtables.c:2155 [inline]
  compat_copy_entries+0x96c/0x14a0 net/bridge/netfilter/ebtables.c:2194
  compat_do_replace+0x483/0x900 net/bridge/netfilter/ebtables.c:2285
  compat_do_ebt_set_ctl+0x2ac/0x324 net/bridge/netfilter/ebtables.c:2367
  compat_nf_sockopt net/netfilter/nf_sockopt.c:144 [inline]
  compat_nf_setsockopt+0x9b/0x140 net/netfilter/nf_sockopt.c:156
  compat_ip_setsockopt+0xff/0x140 net/ipv4/ip_sockglue.c:1279
  inet_csk_compat_setsockopt+0x97/0x120 net/ipv4/inet_connection_sock.c:1041
  compat_tcp_setsockopt+0x49/0x80 net/ipv4/tcp.c:2901
  compat_sock_common_setsockopt+0xb4/0x150 net/core/sock.c:3050
  __compat_sys_setsockopt+0x1ab/0x7c0 net/compat.c:403
  __do_compat_sys_setsockopt net/compat.c:416 [inline]
  __se_compat_sys_setsockopt net/compat.c:413 [inline]
  __ia32_compat_sys_setsockopt+0xbd/0x150 net/compat.c:413
  do_syscall_32_irqs_on arch/x86/entry/common.c:323 [inline]
  do_fast_syscall_32+0x345/0xf9b arch/x86/entry/common.c:394
  entry_SYSENTER_compat+0x70/0x7f arch/x86/entry/entry_64_compat.S:139
RIP: 0023:0xf7fb3cb9
RSP: 002b:00000000fff0c26c EFLAGS: 00000282 ORIG_RAX: 000000000000016e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000000000
RDX: 0000000000000080 RSI: 0000000020000300 RDI: 00000000000005f4
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

The buggy address belongs to the page:
page:ffffea0006c2afc0 count:0 mapcount:0 mapping:0000000000000000 index:0x0
flags: 0x2fffc0000000000()
raw: 02fffc0000000000 0000000000000000 0000000000000000 00000000ffffffff
raw: 0000000000000000 ffffea0006c20101 0000000000000000 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff8801b0abf780: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  ffff8801b0abf800: 00 00 00 00 00 f1 f1 f1 f1 00 00 f2 f2 f2 f2 f2
> ffff8801b0abf880: f2 00 00 00 07 f3 f3 f3 f3 00 00 00 00 00 00 00
                                ^
  ffff8801b0abf900: 00 00 00 00 00 00 00 00 00 00 f1 f1 f1 f1 00 00
  ffff8801b0abf980: 00 f2 f2 f2 f2 f2 00 00 00 00 00 00 00 00 00 00
==================================================================


---
This bug is generated by a dumb bot. It may contain errors.
See https://goo.gl/tpsmEJ for details.
Direct all questions to syzkaller@googlegroups.com.

syzbot will keep track of this bug report.
If you forgot to add the Reported-by tag, once the fix for this bug is  
merged
into any tree, please reply to this email with:
#syz fix: exact-commit-title
If you want to test a patch for this bug, please reply with:
#syz test: git://repo/address.git branch
and provide the patch inline or as an attachment.
To mark this as a duplicate of another syzbot report, please reply with:
#syz dup: exact-subject-of-another-report
If it's a one-off invalid bug report, please reply with:
#syz invalid
Note: if the crash happens again, it will cause creation of a new bug  
report.
Note: all commands must start from beginning of the line in the email body.
