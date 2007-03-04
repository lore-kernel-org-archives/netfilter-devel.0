From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 06/10]: nfnetlink_log: fix NULL pointer dereference
Date: Sun,  4 Mar 2007 21:20:06 +0100 (MET)
Message-ID: <20070304201914.28582.4628.sendpatchset@localhost.localdomain>
References: <20070304201906.28582.51903.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070304201906.28582.51903.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: nfnetlink_log: fix NULL pointer dereference

Fix the nasty NULL dereference on multiple packets per netlink message.

BUG: unable to handle kernel NULL pointer dereference at virtual address 00000004
 printing eip:
f8a4b3bf
*pde = 00000000
Oops: 0002 [#1]
SMP 
Modules linked in: nfnetlink_log ipt_ttl ipt_REDIRECT xt_tcpudp iptable_nat nf_nat nf_conntrack_ipv4 xt_state ipt_ipp2p xt_NFLOG xt_hashlimit ip6_tables iptable_filter xt_multiport xt_mark ipt_set iptable_raw xt_MARK iptable_mangle ip_tables cls_fw cls_u32 sch_esfq sch_htb ip_set_ipmap ip_set ipt_ULOG x_tables dm_snapshot dm_mirror loop e1000 parport_pc parport e100 floppy ide_cd cdrom
CPU:    0
EIP:    0060:[<f8a4b3bf>]    Not tainted VLI
EFLAGS: 00010206   (2.6.20 #5)
EIP is at __nfulnl_send+0x24/0x51 [nfnetlink_log]
eax: 00000000   ebx: f2b5cbc0   ecx: c03f5f54   edx: c03f4000
esi: f2b5cbc8   edi: c03f5f54   ebp: f8a4b3ec   esp: c03f5f30
ds: 007b   es: 007b   ss: 0068
Process swapper (pid: 0, ti=c03f4000 task=c03bece0 task.ti=c03f4000)
Stack: f2b5cbc0 f8a4b401 00000100 c0444080 c012af49 00000000 f6f19100 f6f19000 
       c1707800 c03f5f54 c03f5f54 00000123 00000021 c03e8d08 c0426380 00000009 
       c0126932 00000000 00000046 c03e9980 c03e6000 0047b007 c01269bd 00000000 
Call Trace:
 [<f8a4b401>] nfulnl_timer+0x15/0x25 [nfnetlink_log]
 [<c012af49>] run_timer_softirq+0x10a/0x164
 [<c0126932>] __do_softirq+0x60/0xba
 [<c01269bd>] do_softirq+0x31/0x35
 [<c0104f6e>] do_IRQ+0x62/0x74
 [<c01036cb>] common_interrupt+0x23/0x28
 [<c0101018>] default_idle+0x0/0x3f
 [<c0101045>] default_idle+0x2d/0x3f
 [<c01010fa>] cpu_idle+0xa0/0xb9
 [<c03fb7f5>] start_kernel+0x1a8/0x1ac
 [<c03fb293>] unknown_bootoption+0x0/0x181
 =======================
Code: 5e 5f 5b 5e 5f 5d c3 53 89 c3 8d 40 1c 83 7b 1c 00 74 05 e8 2c ee 6d c7 83 7b 14 00 75 04 31 c0 eb 34 83 7b 10 01 76 09 8b 43 18 <66> c7 40 04 03 00 8b 53 34 8b 43 14 b9 40 00 00 00 e8 08 9a 84 
EIP: [<f8a4b3bf>] __nfulnl_send+0x24/0x51 [nfnetlink_log] SS:ESP 0068:c03f5f30
 <0>Kernel panic - not syncing: Fatal exception in interrupt
 <0>Rebooting in 5 seconds..

Panic no more!

Signed-off-by: Micha Mirosaw <mirq-linux@rere.qmqm.pl>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit eff0bb8715bfc8b8c2cbd58504433d3fd48b36c8
tree 9290bdb2b0c490336cd3665de3f7962b7403b95a
parent aa1cfb5305723e815830307a398c17134a19d4d2
author Michal Miroslaw <mirq-linux@rere.qmqm.pl> Thu, 01 Mar 2007 16:21:54 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 01 Mar 2007 16:21:54 +0100

 net/netfilter/nfnetlink_log.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 27b844a..1b94051 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -560,6 +560,7 @@ #endif
 	}
 
 	nlh->nlmsg_len = inst->skb->tail - old_tail;
+	inst->lastnlh = nlh;
 	return 0;
 
 nlmsg_failure:
