From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 35/64]: ctnetlink: add support for master tuple event notification and dumping
Date: Tue, 18 Dec 2007 00:47:01 +0100 (MET)
Message-ID: <20071217234700.23601.57180.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38991 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932875AbXLQXrC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:47:02 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: ctnetlink: add support for master tuple event notification and dumping

This patch adds support for master tuple event notification and dumping.
Conntrackd needs this information to recover related connections appropriately.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 511b7ee38fc06fe1a18ae3f4872f318ecb9301c6
tree fb1d55c475e0598964d73047decc5a52893f666b
parent f76c1f6a5f4bdbcb8ac6bf4d5e3c0c3df06c935d
author Pablo Neira Ayuso <pablo@netfilter.org> Mon, 17 Dec 2007 14:58:20 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 18 Dec 2007 00:24:56 +0100

 net/netfilter/nf_conntrack_netlink.c |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index d7da167..94027c8 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -254,6 +254,29 @@ nla_put_failure:
 #define ctnetlink_dump_mark(a, b) (0)
 #endif
 
+#define master_tuple(ct) &(ct->master->tuplehash[IP_CT_DIR_ORIGINAL].tuple)
+
+static inline int
+ctnetlink_dump_master(struct sk_buff *skb, const struct nf_conn *ct)
+{
+	struct nlattr *nest_parms;
+
+	if (!(ct->status & IPS_EXPECTED))
+		return 0;
+
+	nest_parms = nla_nest_start(skb, CTA_TUPLE_MASTER | NLA_F_NESTED);
+	if (!nest_parms)
+		goto nla_put_failure;
+	if (ctnetlink_dump_tuples(skb, master_tuple(ct)) < 0)
+		goto nla_put_failure;
+	nla_nest_end(skb, nest_parms);
+
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+
 #ifdef CONFIG_NF_NAT_NEEDED
 static inline int
 dump_nat_seq_adj(struct sk_buff *skb, const struct nf_nat_seq *natseq, int type)
@@ -371,6 +394,7 @@ ctnetlink_fill_info(struct sk_buff *skb, u32 pid, u32 seq,
 	    ctnetlink_dump_mark(skb, ct) < 0 ||
 	    ctnetlink_dump_id(skb, ct) < 0 ||
 	    ctnetlink_dump_use(skb, ct) < 0 ||
+	    ctnetlink_dump_master(skb, ct) < 0 ||
 	    ctnetlink_dump_nat_seq_adj(skb, ct) < 0)
 		goto nla_put_failure;
 
@@ -475,6 +499,10 @@ static int ctnetlink_conntrack_event(struct notifier_block *this,
 		     ctnetlink_dump_counters(skb, ct, IP_CT_DIR_REPLY) < 0))
 			goto nla_put_failure;
 
+		if (events & IPCT_RELATED &&
+		    ctnetlink_dump_master(skb, ct) < 0)
+			goto nla_put_failure;
+
 		if (events & IPCT_NATSEQADJ &&
 		    ctnetlink_dump_nat_seq_adj(skb, ct) < 0)
 			goto nla_put_failure;
