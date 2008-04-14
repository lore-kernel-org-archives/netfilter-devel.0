From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 34/41]: nf_conntrack: use bool type in struct nf_conntrack_l3proto
Date: Mon, 14 Apr 2008 12:17:05 +0200 (MEST)
Message-ID: <20080414101701.32717.73127.sendpatchset@localhost.localdomain>
References: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36354 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755723AbYDNKRG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2008 06:17:06 -0400
In-Reply-To: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack: use bool type in struct nf_conntrack_l3proto

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit d54127ebe65604cea93be5c3bfc536ebfbd78695
tree 68f6f215ee242a4bbfde86569f0622429b79c8de
parent cc83490eebaf7334c3403a7af322aa471f0b644c
author Jan Engelhardt <jengelh@computergmbh.de> Mon, 14 Apr 2008 12:10:56 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 14 Apr 2008 12:10:56 +0200

 include/net/netfilter/nf_conntrack_l3proto.h   |    8 ++++----
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |   14 +++++++-------
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |   14 +++++++-------
 net/netfilter/nf_conntrack_l3proto_generic.c   |   12 ++++++------
 4 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l3proto.h b/include/net/netfilter/nf_conntrack_l3proto.h
index db08258..0378676 100644
--- a/include/net/netfilter/nf_conntrack_l3proto.h
+++ b/include/net/netfilter/nf_conntrack_l3proto.h
@@ -28,15 +28,15 @@ struct nf_conntrack_l3proto
 	 * Try to fill in the third arg: nhoff is offset of l3 proto
          * hdr.  Return true if possible.
 	 */
-	int (*pkt_to_tuple)(const struct sk_buff *skb, unsigned int nhoff,
-			    struct nf_conntrack_tuple *tuple);
+	bool (*pkt_to_tuple)(const struct sk_buff *skb, unsigned int nhoff,
+			     struct nf_conntrack_tuple *tuple);
 
 	/*
 	 * Invert the per-proto part of the tuple: ie. turn xmit into reply.
 	 * Some packets can't be inverted: return 0 in that case.
 	 */
-	int (*invert_tuple)(struct nf_conntrack_tuple *inverse,
-			    const struct nf_conntrack_tuple *orig);
+	bool (*invert_tuple)(struct nf_conntrack_tuple *inverse,
+			     const struct nf_conntrack_tuple *orig);
 
 	/* Print out the per-protocol part of the tuple. */
 	int (*print_tuple)(struct seq_file *s,
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 41e7961..cacb9cb 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -30,29 +30,29 @@ int (*nf_nat_seq_adjust_hook)(struct sk_buff *skb,
 			      enum ip_conntrack_info ctinfo);
 EXPORT_SYMBOL_GPL(nf_nat_seq_adjust_hook);
 
-static int ipv4_pkt_to_tuple(const struct sk_buff *skb, unsigned int nhoff,
-			     struct nf_conntrack_tuple *tuple)
+static bool ipv4_pkt_to_tuple(const struct sk_buff *skb, unsigned int nhoff,
+			      struct nf_conntrack_tuple *tuple)
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
+			      const struct nf_conntrack_tuple *orig)
 {
 	tuple->src.u3.ip = orig->dst.u3.ip;
 	tuple->dst.u3.ip = orig->src.u3.ip;
 
-	return 1;
+	return true;
 }
 
 static int ipv4_print_tuple(struct seq_file *s,
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index 3717bdf..85050c0 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -27,8 +27,8 @@
 #include <net/netfilter/nf_conntrack_l3proto.h>
 #include <net/netfilter/nf_conntrack_core.h>
 
-static int ipv6_pkt_to_tuple(const struct sk_buff *skb, unsigned int nhoff,
-			     struct nf_conntrack_tuple *tuple)
+static bool ipv6_pkt_to_tuple(const struct sk_buff *skb, unsigned int nhoff,
+			      struct nf_conntrack_tuple *tuple)
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
+			      const struct nf_conntrack_tuple *orig)
 {
 	memcpy(tuple->src.u3.ip6, orig->dst.u3.ip6, sizeof(tuple->src.u3.ip6));
 	memcpy(tuple->dst.u3.ip6, orig->src.u3.ip6, sizeof(tuple->dst.u3.ip6));
 
-	return 1;
+	return true;
 }
 
 static int ipv6_print_tuple(struct seq_file *s,
diff --git a/net/netfilter/nf_conntrack_l3proto_generic.c b/net/netfilter/nf_conntrack_l3proto_generic.c
index 8e914e5..e7eb807 100644
--- a/net/netfilter/nf_conntrack_l3proto_generic.c
+++ b/net/netfilter/nf_conntrack_l3proto_generic.c
@@ -31,22 +31,22 @@
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/ipv4/nf_conntrack_ipv4.h>
 
-static int generic_pkt_to_tuple(const struct sk_buff *skb, unsigned int nhoff,
-				struct nf_conntrack_tuple *tuple)
+static bool generic_pkt_to_tuple(const struct sk_buff *skb, unsigned int nhoff,
+				 struct nf_conntrack_tuple *tuple)
 {
 	memset(&tuple->src.u3, 0, sizeof(tuple->src.u3));
 	memset(&tuple->dst.u3, 0, sizeof(tuple->dst.u3));
 
-	return 1;
+	return true;
 }
 
-static int generic_invert_tuple(struct nf_conntrack_tuple *tuple,
-			   const struct nf_conntrack_tuple *orig)
+static bool generic_invert_tuple(struct nf_conntrack_tuple *tuple,
+				 const struct nf_conntrack_tuple *orig)
 {
 	memset(&tuple->src.u3, 0, sizeof(tuple->src.u3));
 	memset(&tuple->dst.u3, 0, sizeof(tuple->dst.u3));
 
-	return 1;
+	return true;
 }
 
 static int generic_print_tuple(struct seq_file *s,
