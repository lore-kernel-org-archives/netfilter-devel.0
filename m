From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nf-next 2/2] netfilter: nat: merge udp and udplite helpers
Date: Tue, 20 Dec 2016 21:57:03 +0100
Message-ID: <1482267423-1411-3-git-send-email-fw@strlen.de>
References: <1482267423-1411-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:38700 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1759149AbcLTU4y (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Dec 2016 15:56:54 -0500
In-Reply-To: <1482267423-1411-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

udplite nat was copied from udp nat, they are virtually 100% identical.
Not really surprising given udplite is just udp with partial csum coverage.

old:
   text    data     bss     dec     hex filename
  11606    1457     210   13273    33d9 nf_nat.ko
    330       0       2     332     14c nf_nat_proto_udp.o
    276       0       2     278     116 nf_nat_proto_udplite.o
new:
   text    data     bss     dec     hex filename
  11598    1457     210   13265    33d1 nf_nat.ko
    640       0       4     644     284 nf_nat_proto_udp.o

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Change since v1: rebase on current master

 net/netfilter/Makefile               |  1 -
 net/netfilter/nf_nat_proto_udp.c     | 78 ++++++++++++++++++++++++++++++------
 net/netfilter/nf_nat_proto_udplite.c | 73 ---------------------------------
 3 files changed, 66 insertions(+), 86 deletions(-)
 delete mode 100644 net/netfilter/nf_nat_proto_udplite.c

diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index bf5c577113b6..6b3034f12661 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -46,7 +46,6 @@ nf_nat-y	:= nf_nat_core.o nf_nat_proto_unknown.o nf_nat_proto_common.o \
 # NAT protocols (nf_nat)
 nf_nat-$(CONFIG_NF_NAT_PROTO_DCCP) += nf_nat_proto_dccp.o
 nf_nat-$(CONFIG_NF_NAT_PROTO_SCTP) += nf_nat_proto_sctp.o
-nf_nat-$(CONFIG_NF_NAT_PROTO_UDPLITE) += nf_nat_proto_udplite.o
 
 # generic transport layer logging
 obj-$(CONFIG_NF_LOG_COMMON) += nf_log_common.o
diff --git a/net/netfilter/nf_nat_proto_udp.c b/net/netfilter/nf_nat_proto_udp.c
index b1e627227b6e..edd4a77dc09a 100644
--- a/net/netfilter/nf_nat_proto_udp.c
+++ b/net/netfilter/nf_nat_proto_udp.c
@@ -30,20 +30,15 @@ udp_unique_tuple(const struct nf_nat_l3proto *l3proto,
 				    &udp_port_rover);
 }
 
-static bool
-udp_manip_pkt(struct sk_buff *skb,
-	      const struct nf_nat_l3proto *l3proto,
-	      unsigned int iphdroff, unsigned int hdroff,
-	      const struct nf_conntrack_tuple *tuple,
-	      enum nf_nat_manip_type maniptype)
+static void
+__udp_manip_pkt(struct sk_buff *skb,
+	        const struct nf_nat_l3proto *l3proto,
+	        unsigned int iphdroff, struct udphdr *hdr,
+	        const struct nf_conntrack_tuple *tuple,
+	        enum nf_nat_manip_type maniptype, bool do_csum)
 {
-	struct udphdr *hdr;
 	__be16 *portptr, newport;
 
-	if (!skb_make_writable(skb, hdroff + sizeof(*hdr)))
-		return false;
-	hdr = (struct udphdr *)(skb->data + hdroff);
-
 	if (maniptype == NF_NAT_MANIP_SRC) {
 		/* Get rid of src port */
 		newport = tuple->src.u.udp.port;
@@ -53,7 +48,7 @@ udp_manip_pkt(struct sk_buff *skb,
 		newport = tuple->dst.u.udp.port;
 		portptr = &hdr->dest;
 	}
-	if (hdr->check || skb->ip_summed == CHECKSUM_PARTIAL) {
+	if (do_csum) {
 		l3proto->csum_update(skb, iphdroff, &hdr->check,
 				     tuple, maniptype);
 		inet_proto_csum_replace2(&hdr->check, skb, *portptr, newport,
@@ -62,9 +57,68 @@ udp_manip_pkt(struct sk_buff *skb,
 			hdr->check = CSUM_MANGLED_0;
 	}
 	*portptr = newport;
+}
+
+static bool udp_manip_pkt(struct sk_buff *skb,
+			  const struct nf_nat_l3proto *l3proto,
+			  unsigned int iphdroff, unsigned int hdroff,
+			  const struct nf_conntrack_tuple *tuple,
+			  enum nf_nat_manip_type maniptype)
+{
+	struct udphdr *hdr;
+	bool do_csum;
+
+	if (!skb_make_writable(skb, hdroff + sizeof(*hdr)))
+		return false;
+
+	hdr = (struct udphdr *)(skb->data + hdroff);
+	do_csum = hdr->check || skb->ip_summed == CHECKSUM_PARTIAL;
+
+	__udp_manip_pkt(skb, l3proto, iphdroff, hdr, tuple, maniptype, do_csum);
+	return true;
+}
+
+#ifdef CONFIG_NF_NAT_PROTO_UDPLITE
+static u16 udplite_port_rover;
+
+static bool udplite_manip_pkt(struct sk_buff *skb,
+			      const struct nf_nat_l3proto *l3proto,
+			      unsigned int iphdroff, unsigned int hdroff,
+			      const struct nf_conntrack_tuple *tuple,
+			      enum nf_nat_manip_type maniptype)
+{
+	struct udphdr *hdr;
+
+	if (!skb_make_writable(skb, hdroff + sizeof(*hdr)))
+		return false;
+
+	hdr = (struct udphdr *)(skb->data + hdroff);
+	__udp_manip_pkt(skb, l3proto, iphdroff, hdr, tuple, maniptype, true);
 	return true;
 }
 
+static void
+udplite_unique_tuple(const struct nf_nat_l3proto *l3proto,
+		     struct nf_conntrack_tuple *tuple,
+		     const struct nf_nat_range *range,
+		     enum nf_nat_manip_type maniptype,
+		     const struct nf_conn *ct)
+{
+	nf_nat_l4proto_unique_tuple(l3proto, tuple, range, maniptype, ct,
+				    &udplite_port_rover);
+}
+
+const struct nf_nat_l4proto nf_nat_l4proto_udplite = {
+	.l4proto		= IPPROTO_UDPLITE,
+	.manip_pkt		= udplite_manip_pkt,
+	.in_range		= nf_nat_l4proto_in_range,
+	.unique_tuple		= udplite_unique_tuple,
+#if IS_ENABLED(CONFIG_NF_CT_NETLINK)
+	.nlattr_to_range	= nf_nat_l4proto_nlattr_to_range,
+#endif
+};
+#endif /* CONFIG_NF_NAT_PROTO_UDPLITE */
+
 const struct nf_nat_l4proto nf_nat_l4proto_udp = {
 	.l4proto		= IPPROTO_UDP,
 	.manip_pkt		= udp_manip_pkt,
diff --git a/net/netfilter/nf_nat_proto_udplite.c b/net/netfilter/nf_nat_proto_udplite.c
deleted file mode 100644
index 366bfbfd82a1..000000000000
--- a/net/netfilter/nf_nat_proto_udplite.c
+++ /dev/null
@@ -1,73 +0,0 @@
-/* (C) 1999-2001 Paul `Rusty' Russell
- * (C) 2002-2006 Netfilter Core Team <coreteam@netfilter.org>
- * (C) 2008 Patrick McHardy <kaber@trash.net>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/types.h>
-#include <linux/udp.h>
-
-#include <linux/netfilter.h>
-#include <net/netfilter/nf_nat.h>
-#include <net/netfilter/nf_nat_l3proto.h>
-#include <net/netfilter/nf_nat_l4proto.h>
-
-static u16 udplite_port_rover;
-
-static void
-udplite_unique_tuple(const struct nf_nat_l3proto *l3proto,
-		     struct nf_conntrack_tuple *tuple,
-		     const struct nf_nat_range *range,
-		     enum nf_nat_manip_type maniptype,
-		     const struct nf_conn *ct)
-{
-	nf_nat_l4proto_unique_tuple(l3proto, tuple, range, maniptype, ct,
-				    &udplite_port_rover);
-}
-
-static bool
-udplite_manip_pkt(struct sk_buff *skb,
-		  const struct nf_nat_l3proto *l3proto,
-		  unsigned int iphdroff, unsigned int hdroff,
-		  const struct nf_conntrack_tuple *tuple,
-		  enum nf_nat_manip_type maniptype)
-{
-	struct udphdr *hdr;
-	__be16 *portptr, newport;
-
-	if (!skb_make_writable(skb, hdroff + sizeof(*hdr)))
-		return false;
-
-	hdr = (struct udphdr *)(skb->data + hdroff);
-
-	if (maniptype == NF_NAT_MANIP_SRC) {
-		/* Get rid of source port */
-		newport = tuple->src.u.udp.port;
-		portptr = &hdr->source;
-	} else {
-		/* Get rid of dst port */
-		newport = tuple->dst.u.udp.port;
-		portptr = &hdr->dest;
-	}
-
-	l3proto->csum_update(skb, iphdroff, &hdr->check, tuple, maniptype);
-	inet_proto_csum_replace2(&hdr->check, skb, *portptr, newport, false);
-	if (!hdr->check)
-		hdr->check = CSUM_MANGLED_0;
-
-	*portptr = newport;
-	return true;
-}
-
-const struct nf_nat_l4proto nf_nat_l4proto_udplite = {
-	.l4proto		= IPPROTO_UDPLITE,
-	.manip_pkt		= udplite_manip_pkt,
-	.in_range		= nf_nat_l4proto_in_range,
-	.unique_tuple		= udplite_unique_tuple,
-#if IS_ENABLED(CONFIG_NF_CT_NETLINK)
-	.nlattr_to_range	= nf_nat_l4proto_nlattr_to_range,
-#endif
-};
-- 
2.7.3

