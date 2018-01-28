From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net] netfilter: xt_recent: do not accept / in table name
Date: Sun, 28 Jan 2018 10:02:22 -0800
Message-ID: <1517162542.3715.83.camel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35697 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752064AbeA1SCY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 28 Jan 2018 13:02:24 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Eric Dumazet <edumazet@google.com>

proc_create_data() will issue a WARN() otherwise, lets avoid that.

name 'syz/\xF5'
WARNING: CPU: 1 PID: 3688 at fs/proc/generic.c:163 __xlate_proc_name+0xe6/0x110 fs/proc/generic.c:163
Kernel panic - not syncing: panic_on_warn set ...

CPU: 1 PID: 3688 Comm: syzkaller153061 Not tainted 4.15.0-rc9+ #283
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:17 [inline]
 dump_stack+0x194/0x257 lib/dump_stack.c:53
 panic+0x1e4/0x41c kernel/panic.c:183
 __warn+0x1dc/0x200 kernel/panic.c:547
 report_bug+0x211/0x2d0 lib/bug.c:184
 fixup_bug.part.11+0x37/0x80 arch/x86/kernel/traps.c:178
 fixup_bug arch/x86/kernel/traps.c:247 [inline]
 do_error_trap+0x2d7/0x3e0 arch/x86/kernel/traps.c:296
 do_invalid_op+0x1b/0x20 arch/x86/kernel/traps.c:315
 invalid_op+0x22/0x40 arch/x86/entry/entry_64.S:1096
RIP: 0010:__xlate_proc_name+0xe6/0x110 fs/proc/generic.c:163
RSP: 0018:ffff8801d913ec18 EFLAGS: 00010282
RAX: dffffc0000000008 RBX: 0000000000000003 RCX: ffffffff8159ebae
RDX: 0000000000000000 RSI: 1ffff1003b227d3e RDI: ffff8801d913e920
RBP: ffff8801d913ec48 R08: 1ffff1003b227d00 R09: 0000000000000000
R10: ffff8801d913eb10 R11: 0000000000000000 R12: ffff8801d92b4550
R13: 0000000000000000 R14: ffff8801d913ede0 R15: ffff8801d92b4550
 xlate_proc_name fs/proc/generic.c:179 [inline]
 __proc_create+0xcc/0x880 fs/proc/generic.c:349
 proc_create_data+0x76/0x180 fs/proc/generic.c:488
 recent_mt_check.isra.8+0xb1b/0xe70 net/netfilter/xt_recent.c:412
 recent_mt_check_v0+0xd7/0x150 net/netfilter/xt_recent.c:440
 xt_check_match+0x231/0x7d0 net/netfilter/x_tables.c:465
 check_match net/ipv4/netfilter/ip_tables.c:479 [inline]
 find_check_match net/ipv4/netfilter/ip_tables.c:495 [inline]
 find_check_entry.isra.8+0x3fc/0xcb0 net/ipv4/netfilter/ip_tables.c:544
 translate_table+0xed1/0x1610 net/ipv4/netfilter/ip_tables.c:730
 do_replace net/ipv4/netfilter/ip_tables.c:1148 [inline]
 do_ipt_set_ctl+0x370/0x5f0 net/ipv4/netfilter/ip_tables.c:1682
 nf_sockopt net/netfilter/nf_sockopt.c:106 [inline]
 nf_setsockopt+0x67/0xc0 net/netfilter/nf_sockopt.c:115
 ip_setsockopt+0xa1/0xb0 net/ipv4/ip_sockglue.c:1256
 sctp_setsockopt+0x2a0/0x5de0 net/sctp/socket.c:4074
 sock_common_setsockopt+0x95/0xd0 net/core/sock.c:2968
 SYSC_setsockopt net/socket.c:1831 [inline]
 SyS_setsockopt+0x189/0x360 net/socket.c:1810
 entry_SYSCALL_64_fastpath+0x29/0xa0

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/netfilter/xt_recent.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index 245fa350a7a85390e6767c4a0c5862f4213000fe..724f7cf072c1c81a912d007f6f89ea542a42eb0e 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -362,7 +362,8 @@ static int recent_mt_check(const struct xt_mtchk_param *par,
 		return -EINVAL;
 	}
 	if (info->name[0] == '\0' ||
-	    strnlen(info->name, XT_RECENT_NAME_LEN) == XT_RECENT_NAME_LEN)
+	    strnlen(info->name, XT_RECENT_NAME_LEN) == XT_RECENT_NAME_LEN ||
+	    strchr(info->name, '/'))
 		return -EINVAL;
 
 	if (ip_pkt_list_tot && info->hit_count < ip_pkt_list_tot)

