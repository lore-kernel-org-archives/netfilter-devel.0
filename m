From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net] netfilter: xt_hashlimit: do not allow empty names
Date: Sun, 28 Jan 2018 07:41:39 -0800
Message-ID: <1517154099.3715.77.camel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Syzbot reported a WARN() in proc_create_data() [1]

Issue here is that xt_hashlimit does not check that user space provided
an empty table name.

[1]
name len 0
WARNING: CPU: 0 PID: 3680 at fs/proc/generic.c:354 __proc_create+0x696/0x880 fs/proc/generic.c:354
Kernel panic - not syncing: panic_on_warn set ...

CPU: 0 PID: 3680 Comm: syzkaller464755 Not tainted 4.15.0-rc9+ #283
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
RIP: 0010:__proc_create+0x696/0x880 fs/proc/generic.c:354
RSP: 0018:ffff8801d9607410 EFLAGS: 00010286
RAX: dffffc0000000008 RBX: 1ffff1003b2c0e87 RCX: ffffffff8159ebae
RDX: 0000000000000000 RSI: 1ffff1003b284970 RDI: 0000000000000293
RBP: ffff8801d9607580 R08: 1ffff1003b2c0e15 R09: 0000000000000000
R10: ffff8801d96072c8 R11: 0000000000000000 R12: ffff8801d981ef28
R13: ffff8801d9607558 R14: 0000000000000000 R15: ffff8801d9607518
 proc_create_data+0x76/0x180 fs/proc/generic.c:488
 htable_create net/netfilter/xt_hashlimit.c:333 [inline]
 hashlimit_mt_check_common.isra.9+0xaee/0x1420 net/netfilter/xt_hashlimit.c:900
 hashlimit_mt_check_v1+0x48d/0x640 net/netfilter/xt_hashlimit.c:926
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
 tcp_setsockopt+0x82/0xd0 net/ipv4/tcp.c:2875
 sock_common_setsockopt+0x95/0xd0 net/core/sock.c:2968
 SYSC_setsockopt net/socket.c:1831 [inline]
 SyS_setsockopt+0x189/0x360 net/socket.c:1810
 entry_SYSCALL_64_fastpath+0x29/0xa0

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/netfilter/xt_hashlimit.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 5da8746f7b88ff4c9446f256e542e823a6a561b0..eae732e013df92a364b500645360d4606c283a75 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -894,6 +894,8 @@ static int hashlimit_mt_check_common(const struct xt_mtchk_param *par,
 			return -ERANGE;
 	}
 
+	if (!name[0])
+		return -EINVAL;
 	mutex_lock(&hashlimit_mutex);
 	*hinfo = htable_find_get(net, name, par->family);
 	if (*hinfo == NULL) {
