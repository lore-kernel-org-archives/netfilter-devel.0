From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf] netfilter: nf_tables: disable preemption when restoring chain counters
Date: Mon, 26 Jan 2015 11:51:10 +0100
Message-ID: <1422269470-3499-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, aschultz@tpip.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56237 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbbAZKsP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:48:15 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

With CONFIG_DEBUG_PREEMPT=y

[22144.496057] BUG: using smp_processor_id() in preemptible [00000000] code: iptables-compat/10406
[22144.496061] caller is debug_smp_processor_id+0x17/0x1b
[22144.496065] CPU: 2 PID: 10406 Comm: iptables-compat Not tainted 3.19.0-rc4+ #
[...]
[22144.496092] Call Trace:
[22144.496098]  [<ffffffff8145b9fa>] dump_stack+0x4f/0x7b
[22144.496104]  [<ffffffff81244f52>] check_preemption_disabled+0xd6/0xe8
[22144.496110]  [<ffffffff81244f90>] debug_smp_processor_id+0x17/0x1b
[22144.496120]  [<ffffffffa07c557e>] nft_stats_alloc+0x94/0xc7 [nf_tables]
[22144.496130]  [<ffffffffa07c73d2>] nf_tables_newchain+0x471/0x6d8 [nf_tables]
[22144.496140]  [<ffffffffa07c5ef6>] ? nft_trans_alloc+0x18/0x34 [nf_tables]
[22144.496154]  [<ffffffffa063c8da>] nfnetlink_rcv_batch+0x2b4/0x457 [nfnetlink]

Reported-by: Andreas Schultz <aschultz@tpip.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 7e68694..b543606 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1134,9 +1134,11 @@ static struct nft_stats __percpu *nft_stats_alloc(const struct nlattr *attr)
 	/* Restore old counters on this cpu, no problem. Per-cpu statistics
 	 * are not exposed to userspace.
 	 */
+	preempt_disable();
 	stats = this_cpu_ptr(newstats);
 	stats->bytes = be64_to_cpu(nla_get_be64(tb[NFTA_COUNTER_BYTES]));
 	stats->pkts = be64_to_cpu(nla_get_be64(tb[NFTA_COUNTER_PACKETS]));
+	preempt_enable();
 
 	return newstats;
 }
-- 
1.7.10.4

