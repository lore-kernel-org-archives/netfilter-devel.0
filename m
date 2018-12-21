From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 21/37] netfilter: nat: remove l4proto->manip_pkt
Date: Fri, 21 Dec 2018 01:28:25 +0100
Message-ID: <20181221002841.28587-22-pablo@netfilter.org>
References: <20181221002841.28587-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181221002841.28587-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

This removes the last l4proto indirection, the two callers, the l3proto
packet mangling helpers for ipv4 and ipv6, now call the
nf_nat_l4proto_manip_pkt() helper.

nf_nat_proto_{dccp,tcp,sctp,gre,icmp,icmpv6} are left behind, even though
they contain no functionality anymore to not clutter this patch.

Next patch will remove the empty files and the nf_nat_l4proto
struct.

nf_nat_proto_udp.c is renamed to nf_nat_proto.c, as it now contains the
other nat manip functionality as well, not just udp and udplite.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_nat_l4proto.h   |  15 +-
 net/ipv4/netfilter/Kconfig               |   5 -
 net/ipv4/netfilter/nf_nat_l3proto_ipv4.c |   4 +-
 net/ipv4/netfilter/nf_nat_pptp.c         |   2 -
 net/ipv4/netfilter/nf_nat_proto_gre.c    |  41 ----
 net/ipv4/netfilter/nf_nat_proto_icmp.c   |  21 --
 net/ipv6/netfilter/nf_nat_l3proto_ipv6.c |   4 +-
 net/ipv6/netfilter/nf_nat_proto_icmpv6.c |  26 ---
 net/netfilter/Kconfig                    |  15 --
 net/netfilter/Makefile                   |   2 +-
 net/netfilter/nf_nat_proto.c             | 353 +++++++++++++++++++++++++++++++
 net/netfilter/nf_nat_proto_dccp.c        |  42 ----
 net/netfilter/nf_nat_proto_sctp.c        |  43 ----
 net/netfilter/nf_nat_proto_tcp.c         |  44 ----
 net/netfilter/nf_nat_proto_udp.c         |  94 --------
 net/netfilter/nf_nat_proto_unknown.c     |  11 -
 16 files changed, 365 insertions(+), 357 deletions(-)
 create mode 100644 net/netfilter/nf_nat_proto.c
 delete mode 100644 net/netfilter/nf_nat_proto_udp.c

diff --git a/include/net/netfilter/nf_nat_l4proto.h b/include/net/netfilter/nf_nat_l4proto.h
index 406f7effeb8e..7b57bd302107 100644
--- a/include/net/netfilter/nf_nat_l4proto.h
+++ b/include/net/netfilter/nf_nat_l4proto.h
@@ -12,14 +12,6 @@ struct nf_nat_l4proto {
 	/* Protocol number. */
 	u8 l4proto;
 
-	/* Translate a packet to the target according to manip type.
-	 * Return true if succeeded.
-	 */
-	bool (*manip_pkt)(struct sk_buff *skb,
-			  const struct nf_nat_l3proto *l3proto,
-			  unsigned int iphdroff, unsigned int hdroff,
-			  const struct nf_conntrack_tuple *tuple,
-			  enum nf_nat_manip_type maniptype);
 };
 
 /* Protocol registration. */
@@ -29,6 +21,13 @@ void nf_nat_l4proto_unregister(u8 l3proto,
 
 const struct nf_nat_l4proto *__nf_nat_l4proto_find(u8 l3proto, u8 l4proto);
 
+/* Translate a packet to the target according to manip type.  Return on success. */
+bool nf_nat_l4proto_manip_pkt(struct sk_buff *skb,
+			      const struct nf_nat_l3proto *l3proto,
+			      unsigned int iphdroff, unsigned int hdroff,
+			      const struct nf_conntrack_tuple *tuple,
+			      enum nf_nat_manip_type maniptype);
+
 /* Built-in protocols. */
 extern const struct nf_nat_l4proto nf_nat_l4proto_tcp;
 extern const struct nf_nat_l4proto nf_nat_l4proto_udp;
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 184bf2e0a1ed..80f72cc5ca8d 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -156,15 +156,10 @@ config NF_NAT_SNMP_BASIC
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
-config NF_NAT_PROTO_GRE
-	tristate
-	depends on NF_CT_PROTO_GRE
-
 config NF_NAT_PPTP
 	tristate
 	depends on NF_CONNTRACK
 	default NF_CONNTRACK_PPTP
-	select NF_NAT_PROTO_GRE
 
 config NF_NAT_H323
 	tristate
diff --git a/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c b/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
index 00904e605e85..65fdb7a74621 100644
--- a/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
@@ -77,8 +77,8 @@ static bool nf_nat_ipv4_manip_pkt(struct sk_buff *skb,
 	iph = (void *)skb->data + iphdroff;
 	hdroff = iphdroff + iph->ihl * 4;
 
-	if (!l4proto->manip_pkt(skb, &nf_nat_l3proto_ipv4, iphdroff, hdroff,
-				target, maniptype))
+	if (!nf_nat_l4proto_manip_pkt(skb, &nf_nat_l3proto_ipv4, iphdroff,
+				      hdroff, target, maniptype))
 		return false;
 	iph = (void *)skb->data + iphdroff;
 
diff --git a/net/ipv4/netfilter/nf_nat_pptp.c b/net/ipv4/netfilter/nf_nat_pptp.c
index 5d259a12e25f..68b4d450391b 100644
--- a/net/ipv4/netfilter/nf_nat_pptp.c
+++ b/net/ipv4/netfilter/nf_nat_pptp.c
@@ -299,8 +299,6 @@ pptp_inbound_pkt(struct sk_buff *skb,
 
 static int __init nf_nat_helper_pptp_init(void)
 {
-	nf_nat_need_gre();
-
 	BUG_ON(nf_nat_pptp_hook_outbound != NULL);
 	RCU_INIT_POINTER(nf_nat_pptp_hook_outbound, pptp_outbound_pkt);
 
diff --git a/net/ipv4/netfilter/nf_nat_proto_gre.c b/net/ipv4/netfilter/nf_nat_proto_gre.c
index 86af36651edd..25849295d537 100644
--- a/net/ipv4/netfilter/nf_nat_proto_gre.c
+++ b/net/ipv4/netfilter/nf_nat_proto_gre.c
@@ -37,49 +37,8 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Harald Welte <laforge@gnumonks.org>");
 MODULE_DESCRIPTION("Netfilter NAT protocol helper module for GRE");
 
-/* manipulate a GRE packet according to maniptype */
-static bool
-gre_manip_pkt(struct sk_buff *skb,
-	      const struct nf_nat_l3proto *l3proto,
-	      unsigned int iphdroff, unsigned int hdroff,
-	      const struct nf_conntrack_tuple *tuple,
-	      enum nf_nat_manip_type maniptype)
-{
-	const struct gre_base_hdr *greh;
-	struct pptp_gre_header *pgreh;
-
-	/* pgreh includes two optional 32bit fields which are not required
-	 * to be there.  That's where the magic '8' comes from */
-	if (!skb_make_writable(skb, hdroff + sizeof(*pgreh) - 8))
-		return false;
-
-	greh = (void *)skb->data + hdroff;
-	pgreh = (struct pptp_gre_header *)greh;
-
-	/* we only have destination manip of a packet, since 'source key'
-	 * is not present in the packet itself */
-	if (maniptype != NF_NAT_MANIP_DST)
-		return true;
-
-	switch (greh->flags & GRE_VERSION) {
-	case GRE_VERSION_0:
-		/* We do not currently NAT any GREv0 packets.
-		 * Try to behave like "nf_nat_proto_unknown" */
-		break;
-	case GRE_VERSION_1:
-		pr_debug("call_id -> 0x%04x\n", ntohs(tuple->dst.u.gre.key));
-		pgreh->call_id = tuple->dst.u.gre.key;
-		break;
-	default:
-		pr_debug("can't nat unknown GRE version\n");
-		return false;
-	}
-	return true;
-}
-
 static const struct nf_nat_l4proto gre = {
 	.l4proto		= IPPROTO_GRE,
-	.manip_pkt		= gre_manip_pkt,
 };
 
 static int __init nf_nat_proto_gre_init(void)
diff --git a/net/ipv4/netfilter/nf_nat_proto_icmp.c b/net/ipv4/netfilter/nf_nat_proto_icmp.c
index 4fecb3f2c55a..c2b7fd1a997b 100644
--- a/net/ipv4/netfilter/nf_nat_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_nat_proto_icmp.c
@@ -10,33 +10,12 @@
 #include <linux/init.h>
 #include <linux/export.h>
 #include <linux/ip.h>
-#include <linux/icmp.h>
 
 #include <linux/netfilter.h>
 #include <net/netfilter/nf_nat.h>
 #include <net/netfilter/nf_nat_core.h>
 #include <net/netfilter/nf_nat_l4proto.h>
 
-static bool
-icmp_manip_pkt(struct sk_buff *skb,
-	       const struct nf_nat_l3proto *l3proto,
-	       unsigned int iphdroff, unsigned int hdroff,
-	       const struct nf_conntrack_tuple *tuple,
-	       enum nf_nat_manip_type maniptype)
-{
-	struct icmphdr *hdr;
-
-	if (!skb_make_writable(skb, hdroff + sizeof(*hdr)))
-		return false;
-
-	hdr = (struct icmphdr *)(skb->data + hdroff);
-	inet_proto_csum_replace2(&hdr->checksum, skb,
-				 hdr->un.echo.id, tuple->src.u.icmp.id, false);
-	hdr->un.echo.id = tuple->src.u.icmp.id;
-	return true;
-}
-
 const struct nf_nat_l4proto nf_nat_l4proto_icmp = {
 	.l4proto		= IPPROTO_ICMP,
-	.manip_pkt		= icmp_manip_pkt,
 };
diff --git a/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c b/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
index 016ab74ac1c6..6ff1375799c7 100644
--- a/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
@@ -83,8 +83,8 @@ static bool nf_nat_ipv6_manip_pkt(struct sk_buff *skb,
 		goto manip_addr;
 
 	if ((frag_off & htons(~0x7)) == 0 &&
-	    !l4proto->manip_pkt(skb, &nf_nat_l3proto_ipv6, iphdroff, hdroff,
-				target, maniptype))
+	    !nf_nat_l4proto_manip_pkt(skb, &nf_nat_l3proto_ipv6, iphdroff, hdroff,
+				      target, maniptype))
 		return false;
 
 	/* must reload, offset might have changed */
diff --git a/net/ipv6/netfilter/nf_nat_proto_icmpv6.c b/net/ipv6/netfilter/nf_nat_proto_icmpv6.c
index 14717c226cec..fcbe7e750420 100644
--- a/net/ipv6/netfilter/nf_nat_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_nat_proto_icmpv6.c
@@ -19,32 +19,6 @@
 #include <net/netfilter/nf_nat_l3proto.h>
 #include <net/netfilter/nf_nat_l4proto.h>
 
-static bool
-icmpv6_manip_pkt(struct sk_buff *skb,
-		 const struct nf_nat_l3proto *l3proto,
-		 unsigned int iphdroff, unsigned int hdroff,
-		 const struct nf_conntrack_tuple *tuple,
-		 enum nf_nat_manip_type maniptype)
-{
-	struct icmp6hdr *hdr;
-
-	if (!skb_make_writable(skb, hdroff + sizeof(*hdr)))
-		return false;
-
-	hdr = (struct icmp6hdr *)(skb->data + hdroff);
-	l3proto->csum_update(skb, iphdroff, &hdr->icmp6_cksum,
-			     tuple, maniptype);
-	if (hdr->icmp6_type == ICMPV6_ECHO_REQUEST ||
-	    hdr->icmp6_type == ICMPV6_ECHO_REPLY) {
-		inet_proto_csum_replace2(&hdr->icmp6_cksum, skb,
-					 hdr->icmp6_identifier,
-					 tuple->src.u.icmp.id, false);
-		hdr->icmp6_identifier = tuple->src.u.icmp.id;
-	}
-	return true;
-}
-
 const struct nf_nat_l4proto nf_nat_l4proto_icmpv6 = {
 	.l4proto		= IPPROTO_ICMPV6,
-	.manip_pkt		= icmpv6_manip_pkt,
 };
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 2ab870ef233a..beb3a69ce1d4 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -403,21 +403,6 @@ config NF_NAT_NEEDED
 	depends on NF_NAT
 	default y
 
-config NF_NAT_PROTO_DCCP
-	bool
-	depends on NF_NAT && NF_CT_PROTO_DCCP
-	default NF_NAT && NF_CT_PROTO_DCCP
-
-config NF_NAT_PROTO_UDPLITE
-	bool
-	depends on NF_NAT && NF_CT_PROTO_UDPLITE
-	default NF_NAT && NF_CT_PROTO_UDPLITE
-
-config NF_NAT_PROTO_SCTP
-	bool
-	default NF_NAT && NF_CT_PROTO_SCTP
-	depends on NF_NAT && NF_CT_PROTO_SCTP
-
 config NF_NAT_AMANDA
 	tristate
 	depends on NF_CONNTRACK && NF_NAT
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 852e47cd769b..ed4a912c5484 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -48,7 +48,7 @@ obj-$(CONFIG_NF_CONNTRACK_SIP) += nf_conntrack_sip.o
 obj-$(CONFIG_NF_CONNTRACK_TFTP) += nf_conntrack_tftp.o
 
 nf_nat-y	:= nf_nat_core.o nf_nat_proto_unknown.o \
-		   nf_nat_proto_udp.o nf_nat_proto_tcp.o nf_nat_helper.o
+		   nf_nat_proto.o nf_nat_proto_tcp.o nf_nat_helper.o
 
 # NAT protocols (nf_nat)
 nf_nat-$(CONFIG_NF_NAT_PROTO_DCCP) += nf_nat_proto_dccp.o
diff --git a/net/netfilter/nf_nat_proto.c b/net/netfilter/nf_nat_proto.c
new file mode 100644
index 000000000000..1042706827cb
--- /dev/null
+++ b/net/netfilter/nf_nat_proto.c
@@ -0,0 +1,353 @@
+/* (C) 1999-2001 Paul `Rusty' Russell
+ * (C) 2002-2006 Netfilter Core Team <coreteam@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/types.h>
+#include <linux/export.h>
+#include <linux/init.h>
+#include <linux/udp.h>
+#include <linux/tcp.h>
+#include <linux/icmp.h>
+#include <linux/icmpv6.h>
+
+#include <linux/dccp.h>
+#include <linux/sctp.h>
+#include <net/sctp/checksum.h>
+
+#include <linux/netfilter.h>
+#include <net/netfilter/nf_nat.h>
+#include <net/netfilter/nf_nat_core.h>
+#include <net/netfilter/nf_nat_l3proto.h>
+#include <net/netfilter/nf_nat_l4proto.h>
+
+static void
+__udp_manip_pkt(struct sk_buff *skb,
+	        const struct nf_nat_l3proto *l3proto,
+	        unsigned int iphdroff, struct udphdr *hdr,
+	        const struct nf_conntrack_tuple *tuple,
+	        enum nf_nat_manip_type maniptype, bool do_csum)
+{
+	__be16 *portptr, newport;
+
+	if (maniptype == NF_NAT_MANIP_SRC) {
+		/* Get rid of src port */
+		newport = tuple->src.u.udp.port;
+		portptr = &hdr->source;
+	} else {
+		/* Get rid of dst port */
+		newport = tuple->dst.u.udp.port;
+		portptr = &hdr->dest;
+	}
+	if (do_csum) {
+		l3proto->csum_update(skb, iphdroff, &hdr->check,
+				     tuple, maniptype);
+		inet_proto_csum_replace2(&hdr->check, skb, *portptr, newport,
+					 false);
+		if (!hdr->check)
+			hdr->check = CSUM_MANGLED_0;
+	}
+	*portptr = newport;
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
+static bool udplite_manip_pkt(struct sk_buff *skb,
+			      const struct nf_nat_l3proto *l3proto,
+			      unsigned int iphdroff, unsigned int hdroff,
+			      const struct nf_conntrack_tuple *tuple,
+			      enum nf_nat_manip_type maniptype)
+{
+#ifdef CONFIG_NF_CT_PROTO_UDPLITE
+	struct udphdr *hdr;
+
+	if (!skb_make_writable(skb, hdroff + sizeof(*hdr)))
+		return false;
+
+	hdr = (struct udphdr *)(skb->data + hdroff);
+	__udp_manip_pkt(skb, l3proto, iphdroff, hdr, tuple, maniptype, true);
+#endif
+	return true;
+}
+
+static bool
+sctp_manip_pkt(struct sk_buff *skb,
+	       const struct nf_nat_l3proto *l3proto,
+	       unsigned int iphdroff, unsigned int hdroff,
+	       const struct nf_conntrack_tuple *tuple,
+	       enum nf_nat_manip_type maniptype)
+{
+#ifdef CONFIG_NF_CT_PROTO_SCTP
+	struct sctphdr *hdr;
+	int hdrsize = 8;
+
+	/* This could be an inner header returned in imcp packet; in such
+	 * cases we cannot update the checksum field since it is outside
+	 * of the 8 bytes of transport layer headers we are guaranteed.
+	 */
+	if (skb->len >= hdroff + sizeof(*hdr))
+		hdrsize = sizeof(*hdr);
+
+	if (!skb_make_writable(skb, hdroff + hdrsize))
+		return false;
+
+	hdr = (struct sctphdr *)(skb->data + hdroff);
+
+	if (maniptype == NF_NAT_MANIP_SRC) {
+		/* Get rid of src port */
+		hdr->source = tuple->src.u.sctp.port;
+	} else {
+		/* Get rid of dst port */
+		hdr->dest = tuple->dst.u.sctp.port;
+	}
+
+	if (hdrsize < sizeof(*hdr))
+		return true;
+
+	if (skb->ip_summed != CHECKSUM_PARTIAL) {
+		hdr->checksum = sctp_compute_cksum(skb, hdroff);
+		skb->ip_summed = CHECKSUM_NONE;
+	}
+
+#endif
+	return true;
+}
+
+static bool
+tcp_manip_pkt(struct sk_buff *skb,
+	      const struct nf_nat_l3proto *l3proto,
+	      unsigned int iphdroff, unsigned int hdroff,
+	      const struct nf_conntrack_tuple *tuple,
+	      enum nf_nat_manip_type maniptype)
+{
+	struct tcphdr *hdr;
+	__be16 *portptr, newport, oldport;
+	int hdrsize = 8; /* TCP connection tracking guarantees this much */
+
+	/* this could be a inner header returned in icmp packet; in such
+	   cases we cannot update the checksum field since it is outside of
+	   the 8 bytes of transport layer headers we are guaranteed */
+	if (skb->len >= hdroff + sizeof(struct tcphdr))
+		hdrsize = sizeof(struct tcphdr);
+
+	if (!skb_make_writable(skb, hdroff + hdrsize))
+		return false;
+
+	hdr = (struct tcphdr *)(skb->data + hdroff);
+
+	if (maniptype == NF_NAT_MANIP_SRC) {
+		/* Get rid of src port */
+		newport = tuple->src.u.tcp.port;
+		portptr = &hdr->source;
+	} else {
+		/* Get rid of dst port */
+		newport = tuple->dst.u.tcp.port;
+		portptr = &hdr->dest;
+	}
+
+	oldport = *portptr;
+	*portptr = newport;
+
+	if (hdrsize < sizeof(*hdr))
+		return true;
+
+	l3proto->csum_update(skb, iphdroff, &hdr->check, tuple, maniptype);
+	inet_proto_csum_replace2(&hdr->check, skb, oldport, newport, false);
+	return true;
+}
+
+static bool
+dccp_manip_pkt(struct sk_buff *skb,
+	       const struct nf_nat_l3proto *l3proto,
+	       unsigned int iphdroff, unsigned int hdroff,
+	       const struct nf_conntrack_tuple *tuple,
+	       enum nf_nat_manip_type maniptype)
+{
+#ifdef CONFIG_NF_CT_PROTO_DCCP
+	struct dccp_hdr *hdr;
+	__be16 *portptr, oldport, newport;
+	int hdrsize = 8; /* DCCP connection tracking guarantees this much */
+
+	if (skb->len >= hdroff + sizeof(struct dccp_hdr))
+		hdrsize = sizeof(struct dccp_hdr);
+
+	if (!skb_make_writable(skb, hdroff + hdrsize))
+		return false;
+
+	hdr = (struct dccp_hdr *)(skb->data + hdroff);
+
+	if (maniptype == NF_NAT_MANIP_SRC) {
+		newport = tuple->src.u.dccp.port;
+		portptr = &hdr->dccph_sport;
+	} else {
+		newport = tuple->dst.u.dccp.port;
+		portptr = &hdr->dccph_dport;
+	}
+
+	oldport = *portptr;
+	*portptr = newport;
+
+	if (hdrsize < sizeof(*hdr))
+		return true;
+
+	l3proto->csum_update(skb, iphdroff, &hdr->dccph_checksum,
+			     tuple, maniptype);
+	inet_proto_csum_replace2(&hdr->dccph_checksum, skb, oldport, newport,
+				 false);
+#endif
+	return true;
+}
+
+static bool
+icmp_manip_pkt(struct sk_buff *skb,
+	       const struct nf_nat_l3proto *l3proto,
+	       unsigned int iphdroff, unsigned int hdroff,
+	       const struct nf_conntrack_tuple *tuple,
+	       enum nf_nat_manip_type maniptype)
+{
+	struct icmphdr *hdr;
+
+	if (!skb_make_writable(skb, hdroff + sizeof(*hdr)))
+		return false;
+
+	hdr = (struct icmphdr *)(skb->data + hdroff);
+	inet_proto_csum_replace2(&hdr->checksum, skb,
+				 hdr->un.echo.id, tuple->src.u.icmp.id, false);
+	hdr->un.echo.id = tuple->src.u.icmp.id;
+	return true;
+}
+
+static bool
+icmpv6_manip_pkt(struct sk_buff *skb,
+		 const struct nf_nat_l3proto *l3proto,
+		 unsigned int iphdroff, unsigned int hdroff,
+		 const struct nf_conntrack_tuple *tuple,
+		 enum nf_nat_manip_type maniptype)
+{
+	struct icmp6hdr *hdr;
+
+	if (!skb_make_writable(skb, hdroff + sizeof(*hdr)))
+		return false;
+
+	hdr = (struct icmp6hdr *)(skb->data + hdroff);
+	l3proto->csum_update(skb, iphdroff, &hdr->icmp6_cksum,
+			     tuple, maniptype);
+	if (hdr->icmp6_type == ICMPV6_ECHO_REQUEST ||
+	    hdr->icmp6_type == ICMPV6_ECHO_REPLY) {
+		inet_proto_csum_replace2(&hdr->icmp6_cksum, skb,
+					 hdr->icmp6_identifier,
+					 tuple->src.u.icmp.id, false);
+		hdr->icmp6_identifier = tuple->src.u.icmp.id;
+	}
+	return true;
+}
+
+/* manipulate a GRE packet according to maniptype */
+static bool
+gre_manip_pkt(struct sk_buff *skb,
+	      const struct nf_nat_l3proto *l3proto,
+	      unsigned int iphdroff, unsigned int hdroff,
+	      const struct nf_conntrack_tuple *tuple,
+	      enum nf_nat_manip_type maniptype)
+{
+#if IS_ENABLED(CONFIG_NF_CT_PROTO_GRE)
+	const struct gre_base_hdr *greh;
+	struct pptp_gre_header *pgreh;
+
+	/* pgreh includes two optional 32bit fields which are not required
+	 * to be there.  That's where the magic '8' comes from */
+	if (!skb_make_writable(skb, hdroff + sizeof(*pgreh) - 8))
+		return false;
+
+	greh = (void *)skb->data + hdroff;
+	pgreh = (struct pptp_gre_header *)greh;
+
+	/* we only have destination manip of a packet, since 'source key'
+	 * is not present in the packet itself */
+	if (maniptype != NF_NAT_MANIP_DST)
+		return true;
+
+	switch (greh->flags & GRE_VERSION) {
+	case GRE_VERSION_0:
+		/* We do not currently NAT any GREv0 packets.
+		 * Try to behave like "nf_nat_proto_unknown" */
+		break;
+	case GRE_VERSION_1:
+		pr_debug("call_id -> 0x%04x\n", ntohs(tuple->dst.u.gre.key));
+		pgreh->call_id = tuple->dst.u.gre.key;
+		break;
+	default:
+		pr_debug("can't nat unknown GRE version\n");
+		return false;
+	}
+#endif
+	return true;
+}
+
+bool nf_nat_l4proto_manip_pkt(struct sk_buff *skb,
+			      const struct nf_nat_l3proto *l3proto,
+			      unsigned int iphdroff, unsigned int hdroff,
+			      const struct nf_conntrack_tuple *tuple,
+			      enum nf_nat_manip_type maniptype)
+{
+	switch (tuple->dst.protonum) {
+	case IPPROTO_TCP:
+		return tcp_manip_pkt(skb, l3proto, iphdroff, hdroff,
+				     tuple, maniptype);
+	case IPPROTO_UDP:
+		return udp_manip_pkt(skb, l3proto, iphdroff, hdroff,
+				     tuple, maniptype);
+	case IPPROTO_UDPLITE:
+		return udplite_manip_pkt(skb, l3proto, iphdroff, hdroff,
+					 tuple, maniptype);
+	case IPPROTO_SCTP:
+		return sctp_manip_pkt(skb, l3proto, iphdroff, hdroff,
+				      tuple, maniptype);
+	case IPPROTO_ICMP:
+		return icmp_manip_pkt(skb, l3proto, iphdroff, hdroff,
+				      tuple, maniptype);
+	case IPPROTO_ICMPV6:
+		return icmpv6_manip_pkt(skb, l3proto, iphdroff, hdroff,
+					tuple, maniptype);
+	case IPPROTO_DCCP:
+		return dccp_manip_pkt(skb, l3proto, iphdroff, hdroff,
+				      tuple, maniptype);
+	case IPPROTO_GRE:
+		return gre_manip_pkt(skb, l3proto, iphdroff, hdroff,
+				     tuple, maniptype);
+	}
+
+	/* If we don't know protocol -- no error, pass it unmodified. */
+	return true;
+}
+EXPORT_SYMBOL_GPL(nf_nat_l4proto_manip_pkt);
+
+#ifdef CONFIG_NF_NAT_PROTO_UDPLITE
+const struct nf_nat_l4proto nf_nat_l4proto_udplite = {
+	.l4proto		= IPPROTO_UDPLITE,
+};
+#endif /* CONFIG_NF_NAT_PROTO_UDPLITE */
+
+const struct nf_nat_l4proto nf_nat_l4proto_udp = {
+	.l4proto		= IPPROTO_UDP,
+};
diff --git a/net/netfilter/nf_nat_proto_dccp.c b/net/netfilter/nf_nat_proto_dccp.c
index ab0b1384717d..dace808d4a23 100644
--- a/net/netfilter/nf_nat_proto_dccp.c
+++ b/net/netfilter/nf_nat_proto_dccp.c
@@ -11,54 +11,12 @@
 
 #include <linux/kernel.h>
 #include <linux/skbuff.h>
-#include <linux/dccp.h>
 
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_nat.h>
 #include <net/netfilter/nf_nat_l3proto.h>
 #include <net/netfilter/nf_nat_l4proto.h>
 
-static bool
-dccp_manip_pkt(struct sk_buff *skb,
-	       const struct nf_nat_l3proto *l3proto,
-	       unsigned int iphdroff, unsigned int hdroff,
-	       const struct nf_conntrack_tuple *tuple,
-	       enum nf_nat_manip_type maniptype)
-{
-	struct dccp_hdr *hdr;
-	__be16 *portptr, oldport, newport;
-	int hdrsize = 8; /* DCCP connection tracking guarantees this much */
-
-	if (skb->len >= hdroff + sizeof(struct dccp_hdr))
-		hdrsize = sizeof(struct dccp_hdr);
-
-	if (!skb_make_writable(skb, hdroff + hdrsize))
-		return false;
-
-	hdr = (struct dccp_hdr *)(skb->data + hdroff);
-
-	if (maniptype == NF_NAT_MANIP_SRC) {
-		newport = tuple->src.u.dccp.port;
-		portptr = &hdr->dccph_sport;
-	} else {
-		newport = tuple->dst.u.dccp.port;
-		portptr = &hdr->dccph_dport;
-	}
-
-	oldport = *portptr;
-	*portptr = newport;
-
-	if (hdrsize < sizeof(*hdr))
-		return true;
-
-	l3proto->csum_update(skb, iphdroff, &hdr->dccph_checksum,
-			     tuple, maniptype);
-	inet_proto_csum_replace2(&hdr->dccph_checksum, skb, oldport, newport,
-				 false);
-	return true;
-}
-
 const struct nf_nat_l4proto nf_nat_l4proto_dccp = {
 	.l4proto		= IPPROTO_DCCP,
-	.manip_pkt		= dccp_manip_pkt,
 };
diff --git a/net/netfilter/nf_nat_proto_sctp.c b/net/netfilter/nf_nat_proto_sctp.c
index 37a9d347a029..e555cb7a248c 100644
--- a/net/netfilter/nf_nat_proto_sctp.c
+++ b/net/netfilter/nf_nat_proto_sctp.c
@@ -7,53 +7,10 @@
  */
 
 #include <linux/types.h>
-#include <linux/sctp.h>
-#include <net/sctp/checksum.h>
 
 #include <net/netfilter/nf_nat_l4proto.h>
 
-static bool
-sctp_manip_pkt(struct sk_buff *skb,
-	       const struct nf_nat_l3proto *l3proto,
-	       unsigned int iphdroff, unsigned int hdroff,
-	       const struct nf_conntrack_tuple *tuple,
-	       enum nf_nat_manip_type maniptype)
-{
-	struct sctphdr *hdr;
-	int hdrsize = 8;
-
-	/* This could be an inner header returned in imcp packet; in such
-	 * cases we cannot update the checksum field since it is outside
-	 * of the 8 bytes of transport layer headers we are guaranteed.
-	 */
-	if (skb->len >= hdroff + sizeof(*hdr))
-		hdrsize = sizeof(*hdr);
-
-	if (!skb_make_writable(skb, hdroff + hdrsize))
-		return false;
-
-	hdr = (struct sctphdr *)(skb->data + hdroff);
-
-	if (maniptype == NF_NAT_MANIP_SRC) {
-		/* Get rid of src port */
-		hdr->source = tuple->src.u.sctp.port;
-	} else {
-		/* Get rid of dst port */
-		hdr->dest = tuple->dst.u.sctp.port;
-	}
-
-	if (hdrsize < sizeof(*hdr))
-		return true;
-
-	if (skb->ip_summed != CHECKSUM_PARTIAL) {
-		hdr->checksum = sctp_compute_cksum(skb, hdroff);
-		skb->ip_summed = CHECKSUM_NONE;
-	}
-
-	return true;
-}
 
 const struct nf_nat_l4proto nf_nat_l4proto_sctp = {
 	.l4proto		= IPPROTO_SCTP,
-	.manip_pkt		= sctp_manip_pkt,
 };
diff --git a/net/netfilter/nf_nat_proto_tcp.c b/net/netfilter/nf_nat_proto_tcp.c
index d378b6c31d34..04d2dc100048 100644
--- a/net/netfilter/nf_nat_proto_tcp.c
+++ b/net/netfilter/nf_nat_proto_tcp.c
@@ -18,50 +18,6 @@
 #include <net/netfilter/nf_nat_l4proto.h>
 #include <net/netfilter/nf_nat_core.h>
 
-static bool
-tcp_manip_pkt(struct sk_buff *skb,
-	      const struct nf_nat_l3proto *l3proto,
-	      unsigned int iphdroff, unsigned int hdroff,
-	      const struct nf_conntrack_tuple *tuple,
-	      enum nf_nat_manip_type maniptype)
-{
-	struct tcphdr *hdr;
-	__be16 *portptr, newport, oldport;
-	int hdrsize = 8; /* TCP connection tracking guarantees this much */
-
-	/* this could be a inner header returned in icmp packet; in such
-	   cases we cannot update the checksum field since it is outside of
-	   the 8 bytes of transport layer headers we are guaranteed */
-	if (skb->len >= hdroff + sizeof(struct tcphdr))
-		hdrsize = sizeof(struct tcphdr);
-
-	if (!skb_make_writable(skb, hdroff + hdrsize))
-		return false;
-
-	hdr = (struct tcphdr *)(skb->data + hdroff);
-
-	if (maniptype == NF_NAT_MANIP_SRC) {
-		/* Get rid of src port */
-		newport = tuple->src.u.tcp.port;
-		portptr = &hdr->source;
-	} else {
-		/* Get rid of dst port */
-		newport = tuple->dst.u.tcp.port;
-		portptr = &hdr->dest;
-	}
-
-	oldport = *portptr;
-	*portptr = newport;
-
-	if (hdrsize < sizeof(*hdr))
-		return true;
-
-	l3proto->csum_update(skb, iphdroff, &hdr->check, tuple, maniptype);
-	inet_proto_csum_replace2(&hdr->check, skb, oldport, newport, false);
-	return true;
-}
-
 const struct nf_nat_l4proto nf_nat_l4proto_tcp = {
 	.l4proto		= IPPROTO_TCP,
-	.manip_pkt		= tcp_manip_pkt,
 };
diff --git a/net/netfilter/nf_nat_proto_udp.c b/net/netfilter/nf_nat_proto_udp.c
deleted file mode 100644
index 25fc6138fbf7..000000000000
--- a/net/netfilter/nf_nat_proto_udp.c
+++ /dev/null
@@ -1,94 +0,0 @@
-/* (C) 1999-2001 Paul `Rusty' Russell
- * (C) 2002-2006 Netfilter Core Team <coreteam@netfilter.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/types.h>
-#include <linux/export.h>
-#include <linux/init.h>
-#include <linux/udp.h>
-
-#include <linux/netfilter.h>
-#include <net/netfilter/nf_nat.h>
-#include <net/netfilter/nf_nat_core.h>
-#include <net/netfilter/nf_nat_l3proto.h>
-#include <net/netfilter/nf_nat_l4proto.h>
-
-static void
-__udp_manip_pkt(struct sk_buff *skb,
-	        const struct nf_nat_l3proto *l3proto,
-	        unsigned int iphdroff, struct udphdr *hdr,
-	        const struct nf_conntrack_tuple *tuple,
-	        enum nf_nat_manip_type maniptype, bool do_csum)
-{
-	__be16 *portptr, newport;
-
-	if (maniptype == NF_NAT_MANIP_SRC) {
-		/* Get rid of src port */
-		newport = tuple->src.u.udp.port;
-		portptr = &hdr->source;
-	} else {
-		/* Get rid of dst port */
-		newport = tuple->dst.u.udp.port;
-		portptr = &hdr->dest;
-	}
-	if (do_csum) {
-		l3proto->csum_update(skb, iphdroff, &hdr->check,
-				     tuple, maniptype);
-		inet_proto_csum_replace2(&hdr->check, skb, *portptr, newport,
-					 false);
-		if (!hdr->check)
-			hdr->check = CSUM_MANGLED_0;
-	}
-	*portptr = newport;
-}
-
-static bool udp_manip_pkt(struct sk_buff *skb,
-			  const struct nf_nat_l3proto *l3proto,
-			  unsigned int iphdroff, unsigned int hdroff,
-			  const struct nf_conntrack_tuple *tuple,
-			  enum nf_nat_manip_type maniptype)
-{
-	struct udphdr *hdr;
-	bool do_csum;
-
-	if (!skb_make_writable(skb, hdroff + sizeof(*hdr)))
-		return false;
-
-	hdr = (struct udphdr *)(skb->data + hdroff);
-	do_csum = hdr->check || skb->ip_summed == CHECKSUM_PARTIAL;
-
-	__udp_manip_pkt(skb, l3proto, iphdroff, hdr, tuple, maniptype, do_csum);
-	return true;
-}
-
-#ifdef CONFIG_NF_NAT_PROTO_UDPLITE
-static bool udplite_manip_pkt(struct sk_buff *skb,
-			      const struct nf_nat_l3proto *l3proto,
-			      unsigned int iphdroff, unsigned int hdroff,
-			      const struct nf_conntrack_tuple *tuple,
-			      enum nf_nat_manip_type maniptype)
-{
-	struct udphdr *hdr;
-
-	if (!skb_make_writable(skb, hdroff + sizeof(*hdr)))
-		return false;
-
-	hdr = (struct udphdr *)(skb->data + hdroff);
-	__udp_manip_pkt(skb, l3proto, iphdroff, hdr, tuple, maniptype, true);
-	return true;
-}
-
-const struct nf_nat_l4proto nf_nat_l4proto_udplite = {
-	.l4proto		= IPPROTO_UDPLITE,
-	.manip_pkt		= udplite_manip_pkt,
-};
-#endif /* CONFIG_NF_NAT_PROTO_UDPLITE */
-
-const struct nf_nat_l4proto nf_nat_l4proto_udp = {
-	.l4proto		= IPPROTO_UDP,
-	.manip_pkt		= udp_manip_pkt,
-};
diff --git a/net/netfilter/nf_nat_proto_unknown.c b/net/netfilter/nf_nat_proto_unknown.c
index ba178b02fc1a..7f6201208a32 100644
--- a/net/netfilter/nf_nat_proto_unknown.c
+++ b/net/netfilter/nf_nat_proto_unknown.c
@@ -17,16 +17,5 @@
 #include <net/netfilter/nf_nat.h>
 #include <net/netfilter/nf_nat_l4proto.h>
 
-static bool
-unknown_manip_pkt(struct sk_buff *skb,
-		  const struct nf_nat_l3proto *l3proto,
-		  unsigned int iphdroff, unsigned int hdroff,
-		  const struct nf_conntrack_tuple *tuple,
-		  enum nf_nat_manip_type maniptype)
-{
-	return true;
-}
-
 const struct nf_nat_l4proto nf_nat_l4proto_unknown = {
-	.manip_pkt		= unknown_manip_pkt,
 };
-- 
2.11.0
