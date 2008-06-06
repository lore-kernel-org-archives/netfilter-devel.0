From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 08/11: nf_conntrack: properly account terminating packets
Date: Fri,  6 Jun 2008 17:17:58 +0200 (MEST)
Message-ID: <20080606151756.25286.12052.sendpatchset@localhost.localdomain>
References: <20080606151737.25286.54547.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48156 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758174AbYFFPR7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Jun 2008 11:17:59 -0400
In-Reply-To: <20080606151737.25286.54547.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

netfilter: nf_conntrack: properly account terminating packets

Currently the last packet of a connection isn't accounted when its causing
abnormal termination.

Introduces nf_ct_kill_acct() which increments the accounting counters on
conntrack kill. The new function was necessary, because there are calls
to nf_ct_kill() which don't need accounting:

nf_conntrack_proto_tcp.c line ~847:
Kills ct and returns NF_REPEAT. We don't want to count twice.

nf_conntrack_proto_tcp.c line ~880:
Kills ct and returns NF_DROP. I think we don't want to count dropped
packets.

nf_conntrack_netlink.c line ~824:
As far as I can see ctnetlink_del_conntrack() is used to destroy a
conntrack on behalf of the user. There is an sk_buff, but I don't think
this is an actual packet. Incrementing counters here is therefore not
desired.

Signed-off-by: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 1b6e77c24870f9932eacedb0e59a3182711b1980
tree 1984675860a2c0a6be95cc2a30b07d84c1f4571c
parent 0c160731721ea46fa0496d32b9e3816a149d7420
author Fabian Hugelshofer <hugelshofer2006@gmx.ch> Fri, 06 Jun 2008 17:11:05 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 06 Jun 2008 17:11:05 +0200

 include/net/netfilter/nf_conntrack.h           |   19 ++++++++++++++++++-
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |    2 +-
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |    2 +-
 net/netfilter/nf_conntrack_core.c              |   16 ++++++++++++++--
 net/netfilter/nf_conntrack_proto_dccp.c        |    2 +-
 net/netfilter/nf_conntrack_proto_tcp.c         |    2 +-
 6 files changed, 36 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index fc19ab2..d77dec7 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -223,7 +223,24 @@ static inline void nf_ct_refresh(struct nf_conn *ct,
 	__nf_ct_refresh_acct(ct, 0, skb, extra_jiffies, 0);
 }
 
-extern void nf_ct_kill(struct nf_conn *ct);
+extern void __nf_ct_kill_acct(struct nf_conn *ct,
+				enum ip_conntrack_info ctinfo,
+				const struct sk_buff *skb,
+				int do_acct);
+
+/* kill conntrack and do accounting */
+static inline void nf_ct_kill_acct(struct nf_conn *ct,
+				enum ip_conntrack_info ctinfo,
+				const struct sk_buff *skb)
+{
+	__nf_ct_kill_acct(ct, ctinfo, skb, 1);
+}
+
+/* kill conntrack without accounting */
+static inline void nf_ct_kill(struct nf_conn *ct)
+{
+	__nf_ct_kill_acct(ct, 0, NULL, 0);
+}
 
 /* These are for NAT.  Icky. */
 /* Update TCP window tracking data when NAT mangles the packet */
diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
index 0e21a46..9779104 100644
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -88,7 +88,7 @@ static int icmp_packet(struct nf_conn *ct,
 	   (theoretically possible with SMP) */
 	if (CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY) {
 		if (atomic_dec_and_test(&ct->proto.icmp.count))
-			nf_ct_kill(ct);
+			nf_ct_kill_acct(ct, ctinfo, skb);
 	} else {
 		atomic_inc(&ct->proto.icmp.count);
 		nf_conntrack_event_cache(IPCT_PROTOINFO_VOLATILE, skb);
diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index fe081b9..14d47d8 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -90,7 +90,7 @@ static int icmpv6_packet(struct nf_conn *ct,
 	   (theoretically possible with SMP) */
 	if (CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY) {
 		if (atomic_dec_and_test(&ct->proto.icmp.count))
-			nf_ct_kill(ct);
+			nf_ct_kill_acct(ct, ctinfo, skb);
 	} else {
 		atomic_inc(&ct->proto.icmp.count);
 		nf_conntrack_event_cache(IPCT_PROTOINFO_VOLATILE, skb);
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 79b07c3..e6d6452 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -848,12 +848,24 @@ acct:
 }
 EXPORT_SYMBOL_GPL(__nf_ct_refresh_acct);
 
-void nf_ct_kill(struct nf_conn *ct)
+void __nf_ct_kill_acct(struct nf_conn *ct,
+		enum ip_conntrack_info ctinfo,
+		const struct sk_buff *skb,
+		int do_acct)
 {
+#ifdef CONFIG_NF_CT_ACCT
+	if (do_acct) {
+		spin_lock_bh(&nf_conntrack_lock);
+		ct->counters[CTINFO2DIR(ctinfo)].packets++;
+		ct->counters[CTINFO2DIR(ctinfo)].bytes +=
+			skb->len - skb_network_offset(skb);
+		spin_unlock_bh(&nf_conntrack_lock);
+	}
+#endif
 	if (del_timer(&ct->timeout))
 		ct->timeout.function((unsigned long)ct);
 }
-EXPORT_SYMBOL_GPL(nf_ct_kill);
+EXPORT_SYMBOL_GPL(__nf_ct_kill_acct);
 
 #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
 
diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
index 223742f..e7866dd 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -475,7 +475,7 @@ static int dccp_packet(struct nf_conn *ct, const struct sk_buff *skb,
 	if (type == DCCP_PKT_RESET &&
 	    !test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
 		/* Tear down connection immediately if only reply is a RESET */
-		nf_ct_kill(ct);
+		nf_ct_kill_acct(ct, ctinfo, skb);
 		return NF_ACCEPT;
 	}
 
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index c4aa11e..8db13fb 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -959,7 +959,7 @@ static int tcp_packet(struct nf_conn *ct,
 		   problem case, so we can delete the conntrack
 		   immediately.  --RR */
 		if (th->rst) {
-			nf_ct_kill(ct);
+			nf_ct_kill_acct(ct, ctinfo, skb);
 			return NF_ACCEPT;
 		}
 	} else if (!test_bit(IPS_ASSURED_BIT, &ct->status)
