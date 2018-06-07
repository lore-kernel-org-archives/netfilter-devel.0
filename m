From: syzbot <syzbot+da4494182233c23a5fcf@syzkaller.appspotmail.com>
Subject: Re: KMSAN: uninit-value in ebt_stp_mt_check (2)
Date: Thu, 07 Jun 2018 14:40:01 -0700
Message-ID: <0000000000002e2239056e142001@google.com>
References: <0000000000009a3b5b056e109e42@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
To: bridge@lists.linux-foundation.org, coreteam@netfilter.org,
        davem@davemloft.net, dvyukov@google.com, fw@strlen.de,
        kadlec@blackhole.kfki.hu, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, stephen@networkplumber.org,
        syzkaller-bugs@googlegroups.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0000000000009a3b5b056e109e42@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    c6a6aed994b6 kmsan: remove dead code to trigger syzbot build
git tree:       https://github.com/google/kmsan.git/master
console output: https://syzkaller.appspot.com/x/log.txt?x=122606bf800000
kernel config:  https://syzkaller.appspot.com/x/.config?x=848e40757852af3e
dashboard link: https://syzkaller.appspot.com/bug?extid=da4494182233c23a5fcf
compiler:       clang version 7.0.0 (trunk 334104)
syzkaller repro:https://syzkaller.appspot.com/x/repro.syz?x=121f481f800000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=121fbbd7800000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+da4494182233c23a5fcf@syzkaller.appspotmail.com

random: sshd: uninitialized urandom read (32 bytes read)
random: sshd: uninitialized urandom read (32 bytes read)
random: sshd: uninitialized urandom read (32 bytes read)
random: sshd: uninitialized urandom read (32 bytes read)
==================================================================
BUG: KMSAN: uninit-value in ebt_stp_mt_check+0x24b/0x450  
net/bridge/netfilter/ebt_stp.c:162
CPU: 1 PID: 4523 Comm: syz-executor710 Not tainted 4.17.0+ #3
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x185/0x1d0 lib/dump_stack.c:113
  kmsan_report+0x149/0x260 mm/kmsan/kmsan.c:1084
  __msan_warning_32+0x6e/0xc0 mm/kmsan/kmsan_instr.c:620
  ebt_stp_mt_check+0x24b/0x450 net/bridge/netfilter/ebt_stp.c:162
  xt_check_match+0x1438/0x1650 net/netfilter/x_tables.c:506
  ebt_check_match net/bridge/netfilter/ebtables.c:372 [inline]
  ebt_check_entry net/bridge/netfilter/ebtables.c:702 [inline]
  translate_table+0x4e88/0x6120 net/bridge/netfilter/ebtables.c:943
  do_replace_finish+0x1258/0x2ea0 net/bridge/netfilter/ebtables.c:999
  do_replace+0x719/0x780 net/bridge/netfilter/ebtables.c:1138
  do_ebt_set_ctl+0x2ab/0x3c0 net/bridge/netfilter/ebtables.c:1517
  nf_sockopt net/netfilter/nf_sockopt.c:106 [inline]
  nf_setsockopt+0x47c/0x4e0 net/netfilter/nf_sockopt.c:115
  ip_setsockopt+0x24b/0x2b0 net/ipv4/ip_sockglue.c:1251
  udp_setsockopt+0x108/0x1b0 net/ipv4/udp.c:2416
  sock_common_setsockopt+0x13b/0x170 net/core/sock.c:3039
  __sys_setsockopt+0x496/0x540 net/socket.c:1903
  __do_sys_setsockopt net/socket.c:1914 [inline]
  __se_sys_setsockopt net/socket.c:1911 [inline]
  __x64_sys_setsockopt+0x15c/0x1c0 net/socket.c:1911
  do_syscall_64+0x15b/0x230 arch/x86/entry/common.c:287
  entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x43fd89
RSP: 002b:00007ffc9d7edb28 EFLAGS: 00000213 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 000000000043fd89
RDX: 0000000000000080 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 00000000006ca018 R08: 0000000000000300 R09: 00000000004002c8
R10: 0000000020000480 R11: 0000000000000213 R12: 00000000004016b0
R13: 0000000000401740 R14: 0000000000000000 R15: 0000000000000000

Local variable description: ----mtpar.i@translate_table
Variable was created at:
  translate_table+0xbb/0x6120 net/bridge/netfilter/ebtables.c:831
  do_replace_finish+0x1258/0x2ea0 net/bridge/netfilter/ebtables.c:999
==================================================================
