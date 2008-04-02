From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 15/24] [NETFILTER]: Use bool in nf_conntrack_l3proto
Date: Wed,  2 Apr 2008 13:11:57 +0200
Message-ID: <0aa5855ef4dfa2b39c747828bdb2b5278be2c247.1207134547.git.jengelh@computergmbh.de>
References: <1207134726-28689-1-git-send-email-jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:43150 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756011AbYDBLMK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Apr 2008 07:12:10 -0400
In-Reply-To: <1207134726-28689-1-git-send-email-jengelh@computergmbh.de>
In-Reply-To: <455b3b0ee249d17dff621933f163b8d5e377eb8f.1207134547.git.jengelh@computergmbh.de>
References: <455b3b0ee249d17dff621933f163b8d5e377eb8f.1207134547.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
 include/net/netfilter/nf_conntrack_l3proto.h   |   10 +++++-----
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |   14 +++++++-------
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |   14 +++++++-------
 net/netfilter/nf_conntrack_l3proto_generic.c   |   12 ++++++------
 4 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l3proto.h b/include/net/netfilter/nf_conntrack_l3proto.h
index b886e3a..d018c69 100644
--- a/include/net/netfilter/nf_conntrack_l3proto.h
+++ b/include/net/netfilter/nf_conntrack_l3proto.h
@@ -28,15 +28,15 @@ struct nf_conntrack_l3proto
 	 * Try to fill in the third arg: nhoff is offset of l3 proto
          * hdr.  Return true if possible.
 	 */
-	int (*pkt_to_tuple)(const struct sk_buff *skb, unsigned int nhoff,
-			    struct nf_conntrack_tuple *tuple);
+	bool (*pkt_to_tuple)(const struct sk_buff *skb, unsigned int nhoff,
+	                     struct nf_conntrack_tuple *tuple);
 
 	/*
 	 * Invert the per-proto part of the tuple: ie. turn xmit into reply.
 	 * Some packets can't be inverted: return 0 in that case.
 	 */
-	int (*invert_tuple)(struct nf_conntrack_tuple *inverse,
-			    const struct nf_conntrack_tuple *orig);
+	bool (*invert_tuple)(struct nf_conntrack_tuple *inverse,
+	                     const struct nf_conntrack_tuple *orig);
 
 	/* Print out the per-protocol part of the tuple. */
 	int (*print_tuple)(struct seq_file *s,
@@ -51,7 +51,7 @@ struct nf_conntrack_l3proto
 	 * Called when a new connection for this protocol found;
 	 * returns TRUE if it's OK.  If so, packet() called next.
 	 */
-	int (*new)(struct nf_conn *ct, const struct sk_buff *skb);
+	bool (*new)(struct nf_conn *ct, const struct sk_buff *skb);
 
 	/*
 	 * Called before tracking. 
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index a65b845..fe73a43 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -24,29 +24,29 @@
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/ipv4/nf_conntrack_ipv4.h>
 
-static int ipv4_pkt_to_tuple(const struct sk_buff *skb, unsigned int nhoff,
-			     struct nf_conntrack_tuple *tuple)
+static bool ipv4_pkt_to_tuple(const struct sk_buff *skb, unsigned int nhoff,
+                              struct nf_conntrack_tuple *tuple)
 {
 	const __be32 *ap;
 	__be32 _addrs[2];
 	ap = skb_header_pointer(skb, nhoff + offsetof(struct iphdr, saddr),
 				sizeof(u_int32_t) * 2, _addrs);
 	if (ap == NULL)
-		return 0;
+		return false;
 
 	tuple->src.u3.ip = ap[0];
 	tuple->dst.u3.ip = ap[1];
 
-	return 1;
+	return true;
 }
 
-static int ipv4_invert_tuple(struct nf_conntrack_tuple *tuple,
-			   const struct nf_conntrack_tuple *orig)
+static bool ipv4_invert_tuple(struct nf_conntrack_tuple *tuple,
+                              const struct nf_conntrack_tuple *orig)
 {
 	tuple->src.u3.ip = orig->dst.u3.ip;
 	tuple->dst.u3.ip = orig->src.u3.ip;
 
-	return 1;
+	return true;
 }
 
 static int ipv4_print_tuple(struct seq_file *s,
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index 3717bdf..5937fe6 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -27,8 +27,8 @@
 #include <net/netfilter/nf_conntrack_l3proto.h>
 #include <net/netfilter/nf_conntrack_core.h>
 
-static int ipv6_pkt_to_tuple(const struct sk_buff *skb, unsigned int nhoff,
-			     struct nf_conntrack_tuple *tuple)
+static bool ipv6_pkt_to_tuple(const struct sk_buff *skb, unsigned int nhoff,
+                              struct nf_conntrack_tuple *tuple)
 {
 	const u_int32_t *ap;
 	u_int32_t _addrs[8];
@@ -36,21 +36,21 @@ static int ipv6_pkt_to_tuple(const struct sk_buff *skb, unsigned int nhoff,
 	ap = skb_header_pointer(skb, nhoff + offsetof(struct ipv6hdr, saddr),
 				sizeof(_addrs), _addrs);
 	if (ap == NULL)
-		return 0;
+		return false;
 
 	memcpy(tuple->src.u3.ip6, ap, sizeof(tuple->src.u3.ip6));
 	memcpy(tuple->dst.u3.ip6, ap + 4, sizeof(tuple->dst.u3.ip6));
 
-	return 1;
+	return true;
 }
 
-static int ipv6_invert_tuple(struct nf_conntrack_tuple *tuple,
-			     const struct nf_conntrack_tuple *orig)
+static bool ipv6_invert_tuple(struct nf_conntrack_tuple *tuple,
+                              const struct nf_conntrack_tuple *orig)
 {
 	memcpy(tuple->src.u3.ip6, orig->dst.u3.ip6, sizeof(tuple->src.u3.ip6));
 	memcpy(tuple->dst.u3.ip6, orig->src.u3.ip6, sizeof(tuple->dst.u3.ip6));
 
-	return 1;
+	return true;
 }
 
 static int ipv6_print_tuple(struct seq_file *s,
diff --git a/net/netfilter/nf_conntrack_l3proto_generic.c b/net/netfilter/nf_conntrack_l3proto_generic.c
index 8e914e5..1eac65f 100644
--- a/net/netfilter/nf_conntrack_l3proto_generic.c
+++ b/net/netfilter/nf_conntrack_l3proto_generic.c
@@ -31,22 +31,22 @@
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/ipv4/nf_conntrack_ipv4.h>
 
-static int generic_pkt_to_tuple(const struct sk_buff *skb, unsigned int nhoff,
-				struct nf_conntrack_tuple *tuple)
+static bool generic_pkt_to_tuple(const struct sk_buff *skb, unsigned int nhoff,
+                                 struct nf_conntrack_tuple *tuple)
 {
 	memset(&tuple->src.u3, 0, sizeof(tuple->src.u3));
 	memset(&tuple->dst.u3, 0, sizeof(tuple->dst.u3));
 
-	return 1;
+	return true;
 }
 
-static int generic_invert_tuple(struct nf_conntrack_tuple *tuple,
-			   const struct nf_conntrack_tuple *orig)
+static bool generic_invert_tuple(struct nf_conntrack_tuple *tuple,
+                                 const struct nf_conntrack_tuple *orig)
 {
 	memset(&tuple->src.u3, 0, sizeof(tuple->src.u3));
 	memset(&tuple->dst.u3, 0, sizeof(tuple->dst.u3));
 
-	return 1;
+	return true;
 }
 
 static int generic_print_tuple(struct seq_file *s,
-- 
1.5.4.4

