From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 07/11: nf_conntrack: add nf_ct_kill()
Date: Fri,  6 Jun 2008 17:17:56 +0200 (MEST)
Message-ID: <20080606151755.25286.94031.sendpatchset@localhost.localdomain>
References: <20080606151737.25286.54547.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48151 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758109AbYFFPR6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Jun 2008 11:17:58 -0400
In-Reply-To: <20080606151737.25286.54547.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

netfilter: nf_conntrack: add nf_ct_kill()

Encapsulate the common

	if (del_timer(&ct->timeout))
		ct->timeout.function((unsigned long)ct)

sequence in a new function.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 0c160731721ea46fa0496d32b9e3816a149d7420
tree 57775bffc393305f930acf792493e21ec8914091
parent c6bf7199df1514a3f82c2c6a3d925c5966798141
author Patrick McHardy <kaber@trash.net> Fri, 06 Jun 2008 17:11:05 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 06 Jun 2008 17:11:05 +0200

 include/net/netfilter/nf_conntrack.h           |    2 ++
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |    5 ++---
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |    5 ++---
 net/netfilter/nf_conntrack_core.c              |    7 +++++++
 net/netfilter/nf_conntrack_netlink.c           |    3 +--
 net/netfilter/nf_conntrack_proto_dccp.c        |    3 +--
 net/netfilter/nf_conntrack_proto_tcp.c         |    9 +++------
 7 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 2dbd6c0..fc19ab2 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -223,6 +223,8 @@ static inline void nf_ct_refresh(struct nf_conn *ct,
 	__nf_ct_refresh_acct(ct, 0, skb, extra_jiffies, 0);
 }
 
+extern void nf_ct_kill(struct nf_conn *ct);
+
 /* These are for NAT.  Icky. */
 /* Update TCP window tracking data when NAT mangles the packet */
 extern void nf_conntrack_tcp_update(const struct sk_buff *skb,
diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
index 78ab19a..0e21a46 100644
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -87,9 +87,8 @@ static int icmp_packet(struct nf_conn *ct,
 	   means this will only run once even if count hits zero twice
 	   (theoretically possible with SMP) */
 	if (CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY) {
-		if (atomic_dec_and_test(&ct->proto.icmp.count)
-		    && del_timer(&ct->timeout))
-			ct->timeout.function((unsigned long)ct);
+		if (atomic_dec_and_test(&ct->proto.icmp.count))
+			nf_ct_kill(ct);
 	} else {
 		atomic_inc(&ct->proto.icmp.count);
 		nf_conntrack_event_cache(IPCT_PROTOINFO_VOLATILE, skb);
diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index ee713b0..fe081b9 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -89,9 +89,8 @@ static int icmpv6_packet(struct nf_conn *ct,
 	   means this will only run once even if count hits zero twice
 	   (theoretically possible with SMP) */
 	if (CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY) {
-		if (atomic_dec_and_test(&ct->proto.icmp.count)
-		    && del_timer(&ct->timeout))
-			ct->timeout.function((unsigned long)ct);
+		if (atomic_dec_and_test(&ct->proto.icmp.count))
+			nf_ct_kill(ct);
 	} else {
 		atomic_inc(&ct->proto.icmp.count);
 		nf_conntrack_event_cache(IPCT_PROTOINFO_VOLATILE, skb);
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index c4b1799..79b07c3 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -848,6 +848,13 @@ acct:
 }
 EXPORT_SYMBOL_GPL(__nf_ct_refresh_acct);
 
+void nf_ct_kill(struct nf_conn *ct)
+{
+	if (del_timer(&ct->timeout))
+		ct->timeout.function((unsigned long)ct);
+}
+EXPORT_SYMBOL_GPL(nf_ct_kill);
+
 #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
 
 #include <linux/netfilter/nfnetlink.h>
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 13918c1..ab655f6 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -812,9 +812,8 @@ ctnetlink_del_conntrack(struct sock *ctnl, struct sk_buff *skb,
 			return -ENOENT;
 		}
 	}
-	if (del_timer(&ct->timeout))
-		ct->timeout.function((unsigned long)ct);
 
+	nf_ct_kill(ct);
 	nf_ct_put(ct);
 
 	return 0;
diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
index afb4a18..223742f 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -475,8 +475,7 @@ static int dccp_packet(struct nf_conn *ct, const struct sk_buff *skb,
 	if (type == DCCP_PKT_RESET &&
 	    !test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
 		/* Tear down connection immediately if only reply is a RESET */
-		if (del_timer(&ct->timeout))
-			ct->timeout.function((unsigned long)ct);
+		nf_ct_kill(ct);
 		return NF_ACCEPT;
 	}
 
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index ba94004..c4aa11e 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -843,8 +843,7 @@ static int tcp_packet(struct nf_conn *ct,
 			/* Attempt to reopen a closed/aborted connection.
 			 * Delete this connection and look up again. */
 			write_unlock_bh(&tcp_lock);
-			if (del_timer(&ct->timeout))
-				ct->timeout.function((unsigned long)ct);
+			nf_ct_kill(ct);
 			return -NF_REPEAT;
 		}
 		/* Fall through */
@@ -877,8 +876,7 @@ static int tcp_packet(struct nf_conn *ct,
 			if (LOG_INVALID(IPPROTO_TCP))
 				nf_log_packet(pf, 0, skb, NULL, NULL, NULL,
 					  "nf_ct_tcp: killing out of sync session ");
-			if (del_timer(&ct->timeout))
-				ct->timeout.function((unsigned long)ct);
+			nf_ct_kill(ct);
 			return -NF_DROP;
 		}
 		ct->proto.tcp.last_index = index;
@@ -961,8 +959,7 @@ static int tcp_packet(struct nf_conn *ct,
 		   problem case, so we can delete the conntrack
 		   immediately.  --RR */
 		if (th->rst) {
-			if (del_timer(&ct->timeout))
-				ct->timeout.function((unsigned long)ct);
+			nf_ct_kill(ct);
 			return NF_ACCEPT;
 		}
 	} else if (!test_bit(IPS_ASSURED_BIT, &ct->status)
