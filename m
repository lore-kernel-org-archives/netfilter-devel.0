From: Greg KH <gregkh@suse.de>
Subject: [patch 06/20] nfnetlink_log: fix NULL pointer dereference
Date: Fri, 9 Mar 2007 22:17:18 -0800
Message-ID: <20070310061718.GG31412@kroah.com>
References: <20070310061234.465093436@mini.kroah.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	netfilter-devel@lists.netfilter.org, Justin Forbes <jmforbes@linuxtx.org>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>, davem@davemloft.net,
	Randy Dunlap <rdunlap@xenotime.net>, Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>, Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>, akpm@linux-foundation.org,
	Micha Mirosaw <mirq-linux@rere.qmqm.pl>,
	torvalds@linux-foundation.org, Patrick McHardy <kaber@trash.net>,
	alan@lxorguk.ukuu.org.uk
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline;
	filename="nfnetlink_log-fix-null-pointer-dereference.patch"
In-Reply-To: <20070310061603.GA31412@kroah.com>
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

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Micha Mirosaw <mirq-linux@rere.qmqm.pl>

[NETFILTER]: nfnetlink_log: fix NULL pointer dereference

Fix the nasty NULL dereference on multiple packets per netlink message.

BUG: unable to handle kernel NULL pointer dereference at virtual address 00000004
 printing eip:
f8a4b3bf
*pde = 00000000
Oops: 0002 [#1]
SMP
Modules linked in: nfnetlink_log ipt_ttl ipt_REDIRECT xt_tcpudp iptable_nat nf_nat nf_conntrack
_ipv4 xt_state ipt_ipp2p xt_NFLOG xt_hashlimit ip6_tables iptable_filter xt_multiport xt_mark i
pt_set iptable_raw xt_MARK iptable_mangle ip_tables cls_fw cls_u32 sch_esfq sch_htb ip_set_ipma
p ip_set ipt_ULOG x_tables dm_snapshot dm_mirror loop e1000 parport_pc parport e100 floppy ide_
cd cdrom
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
Code: 5e 5f 5b 5e 5f 5d c3 53 89 c3 8d 40 1c 83 7b 1c 00 74 05 e8 2c ee 6d c7 83 7b 14 00 75 04
 31 c0 eb 34 83 7b 10 01 76 09 8b 43 18 <66> c7 40 04 03 00 8b 53 34 8b 43 14 b9 40 00 00 00 e8
 08 9a 84
EIP: [<f8a4b3bf>] __nfulnl_send+0x24/0x51 [nfnetlink_log] SS:ESP 0068:c03f5f30
 <0>Kernel panic - not syncing: Fatal exception in interrupt
 <0>Rebooting in 5 seconds..

Panic no more!

Signed-off-by: Micha Mirosaw <mirq-linux@rere.qmqm.pl>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 net/netfilter/nfnetlink_log.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -564,6 +564,7 @@ __build_packet_message(struct nfulnl_ins
 	}
 		
 	nlh->nlmsg_len = inst->skb->tail - old_tail;
+	inst->lastnlh = nlh;
 	return 0;
 
 nlmsg_failure:

-- 
