From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 2/2] netfilter: nat: merge udp and udplite helpers
Date: Fri,  2 Dec 2016 19:50:37 +0100
Message-ID: <1480704637-14994-3-git-send-email-fw@strlen.de>
References: <1480704637-14994-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:58644 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753547AbcLBSu0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Dec 2016 13:50:26 -0500
In-Reply-To: <1480704637-14994-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

udplite nat was copied from udp, they are virtually 100% identical,
which isn't suprising given udplite is just udp with partial
checksum coverage.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_nat_l4proto.h |   1 +
 net/netfilter/Kconfig                  |   5 --
 net/netfilter/Makefile                 |   1 -
 net/netfilter/nf_nat_core.c            |   2 +
 net/netfilter/nf_nat_proto_udp.c       |  76 +++++++++++++++++++----
 net/netfilter/nf_nat_proto_udplite.c   | 106 ---------------------------------
 6 files changed, 68 insertions(+), 123 deletions(-)
 delete mode 100644 net/netfilter/nf_nat_proto_udplite.c

diff --git a/include/net/netfilter/nf_nat_l4proto.h b/include/net/netfilter/nf_nat_l4proto.h
index 12f4cc841b6e..40fa3bf77c6e 100644
--- a/include/net/netfilter/nf_nat_l4proto.h
+++ b/include/net/netfilter/nf_nat_l4proto.h
@@ -51,6 +51,7 @@ const struct nf_nat_l4proto *__nf_nat_l4proto_find(u8 l3proto, u8 l4proto);
 /* Built-in protocols. */
 extern const struct nf_nat_l4proto nf_nat_l4proto_tcp;
 extern const struct nf_nat_l4proto nf_nat_l4proto_udp;
+extern const struct nf_nat_l4proto nf_nat_l4proto_udplite;
 extern const struct nf_nat_l4proto nf_nat_l4proto_icmp;
 extern const struct nf_nat_l4proto nf_nat_l4proto_icmpv6;
 extern const struct nf_nat_l4proto nf_nat_l4proto_unknown;
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 9c34c2cabd76..61b9dd083663 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -378,11 +378,6 @@ config NF_NAT_PROTO_DCCP
 	depends on NF_NAT && NF_CT_PROTO_DCCP
 	default NF_NAT && NF_CT_PROTO_DCCP
 
-config NF_NAT_PROTO_UDPLITE
-	tristate
-	depends on NF_NAT && NF_CT_PROTO_UDPLITE
-	default NF_NAT && NF_CT_PROTO_UDPLITE
-
 config NF_NAT_PROTO_SCTP
 	tristate
 	default NF_NAT && NF_CT_PROTO_SCTP
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 66c7faf52f20..51a5d3ea42fc 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -55,7 +55,6 @@ obj-$(CONFIG_NF_NAT_REDIRECT) += nf_nat_redirect.o
 
 # NAT protocols (nf_nat)
 obj-$(CONFIG_NF_NAT_PROTO_DCCP) += nf_nat_proto_dccp.o
-obj-$(CONFIG_NF_NAT_PROTO_UDPLITE) += nf_nat_proto_udplite.o
 obj-$(CONFIG_NF_NAT_PROTO_SCTP) += nf_nat_proto_sctp.o
 
 # NAT helpers
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index bbb8f3df79f7..2cc2cd0de82b 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -671,6 +671,8 @@ int nf_nat_l3proto_register(const struct nf_nat_l3proto *l3proto)
 			 &nf_nat_l4proto_tcp);
 	RCU_INIT_POINTER(nf_nat_l4protos[l3proto->l3proto][IPPROTO_UDP],
 			 &nf_nat_l4proto_udp);
+	RCU_INIT_POINTER(nf_nat_l4protos[l3proto->l3proto][IPPROTO_UDPLITE],
+			 &nf_nat_l4proto_udplite);
 	mutex_unlock(&nf_nat_proto_mutex);
 
 	RCU_INIT_POINTER(nf_nat_l3protos[l3proto->l3proto], l3proto);
diff --git a/net/netfilter/nf_nat_proto_udp.c b/net/netfilter/nf_nat_proto_udp.c
index b1e627227b6e..bef76c1e0364 100644
--- a/net/netfilter/nf_nat_proto_udp.c
+++ b/net/netfilter/nf_nat_proto_udp.c
@@ -18,6 +18,7 @@
 #include <net/netfilter/nf_nat_l4proto.h>
 
 static u16 udp_port_rover;
+static u16 udplite_port_rover;
 
 static void
 udp_unique_tuple(const struct nf_nat_l3proto *l3proto,
@@ -30,20 +31,26 @@ udp_unique_tuple(const struct nf_nat_l3proto *l3proto,
 				    &udp_port_rover);
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
 static bool
-udp_manip_pkt(struct sk_buff *skb,
-	      const struct nf_nat_l3proto *l3proto,
-	      unsigned int iphdroff, unsigned int hdroff,
-	      const struct nf_conntrack_tuple *tuple,
-	      enum nf_nat_manip_type maniptype)
+__udp_manip_pkt(struct sk_buff *skb,
+		const struct nf_nat_l3proto *l3proto,
+		unsigned int iphdroff, struct udphdr *hdr,
+		const struct nf_conntrack_tuple *tuple,
+		enum nf_nat_manip_type maniptype, bool do_csum)
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
@@ -53,7 +60,7 @@ udp_manip_pkt(struct sk_buff *skb,
 		newport = tuple->dst.u.udp.port;
 		portptr = &hdr->dest;
 	}
-	if (hdr->check || skb->ip_summed == CHECKSUM_PARTIAL) {
+	if (do_csum) {
 		l3proto->csum_update(skb, iphdroff, &hdr->check,
 				     tuple, maniptype);
 		inet_proto_csum_replace2(&hdr->check, skb, *portptr, newport,
@@ -65,6 +72,53 @@ udp_manip_pkt(struct sk_buff *skb,
 	return true;
 }
 
+static bool
+udp_manip_pkt(struct sk_buff *skb,
+	      const struct nf_nat_l3proto *l3proto,
+	      unsigned int iphdroff, unsigned int hdroff,
+	      const struct nf_conntrack_tuple *tuple,
+	      enum nf_nat_manip_type maniptype)
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
+	return __udp_manip_pkt(skb, l3proto, iphdroff, hdr, tuple,
+			       maniptype, do_csum);
+}
+
+static bool
+udplite_manip_pkt(struct sk_buff *skb,
+		  const struct nf_nat_l3proto *l3proto,
+		  unsigned int iphdroff, unsigned int hdroff,
+		  const struct nf_conntrack_tuple *tuple,
+		  enum nf_nat_manip_type maniptype)
+{
+	struct udphdr *hdr;
+
+	if (!skb_make_writable(skb, hdroff + sizeof(*hdr)))
+		return false;
+
+	hdr = (struct udphdr *)(skb->data + hdroff);
+	return __udp_manip_pkt(skb, l3proto, iphdroff, hdr, tuple,
+			       maniptype, true);
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
+
 const struct nf_nat_l4proto nf_nat_l4proto_udp = {
 	.l4proto		= IPPROTO_UDP,
 	.manip_pkt		= udp_manip_pkt,
diff --git a/net/netfilter/nf_nat_proto_udplite.c b/net/netfilter/nf_nat_proto_udplite.c
deleted file mode 100644
index 58340c97bd83..000000000000
--- a/net/netfilter/nf_nat_proto_udplite.c
+++ /dev/null
@@ -1,106 +0,0 @@
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
-#include <linux/init.h>
-#include <linux/udp.h>
-
-#include <linux/netfilter.h>
-#include <linux/module.h>
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
-static const struct nf_nat_l4proto nf_nat_l4proto_udplite = {
-	.l4proto		= IPPROTO_UDPLITE,
-	.manip_pkt		= udplite_manip_pkt,
-	.in_range		= nf_nat_l4proto_in_range,
-	.unique_tuple		= udplite_unique_tuple,
-#if IS_ENABLED(CONFIG_NF_CT_NETLINK)
-	.nlattr_to_range	= nf_nat_l4proto_nlattr_to_range,
-#endif
-};
-
-static int __init nf_nat_proto_udplite_init(void)
-{
-	int err;
-
-	err = nf_nat_l4proto_register(NFPROTO_IPV4, &nf_nat_l4proto_udplite);
-	if (err < 0)
-		goto err1;
-	err = nf_nat_l4proto_register(NFPROTO_IPV6, &nf_nat_l4proto_udplite);
-	if (err < 0)
-		goto err2;
-	return 0;
-
-err2:
-	nf_nat_l4proto_unregister(NFPROTO_IPV4, &nf_nat_l4proto_udplite);
-err1:
-	return err;
-}
-
-static void __exit nf_nat_proto_udplite_fini(void)
-{
-	nf_nat_l4proto_unregister(NFPROTO_IPV6, &nf_nat_l4proto_udplite);
-	nf_nat_l4proto_unregister(NFPROTO_IPV4, &nf_nat_l4proto_udplite);
-}
-
-module_init(nf_nat_proto_udplite_init);
-module_exit(nf_nat_proto_udplite_fini);
-
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("UDP-Lite NAT protocol helper");
-MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
-- 
2.7.3

