From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 1/2] netfilter: conntrack: merge udp and udplite helpers
Date: Fri,  2 Dec 2016 19:50:36 +0100
Message-ID: <1480704637-14994-2-git-send-email-fw@strlen.de>
References: <1480704637-14994-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:58640 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753360AbcLBSuX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Dec 2016 13:50:23 -0500
In-Reply-To: <1480704637-14994-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

udplite was copied from udp, they are virtually 100% identical, which isn't
suprising given udplite is just udp with partial checksum coverage.

This adds udplite tracker to udp instead, removes udplite module,
and then makes the udplite tracker builtin.

udplite will then simply re-use udp timeout settings.
It makes little sense to add separate sysctls, nowadays we have
fine-grained timeout policy support via the CT target.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/ipv4/nf_conntrack_ipv4.h |   1 +
 include/net/netfilter/ipv6/nf_conntrack_ipv6.h |   1 +
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |   1 +
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |   1 +
 net/netfilter/Kconfig                          |  10 -
 net/netfilter/Makefile                         |   1 -
 net/netfilter/nf_conntrack_proto_udp.c         | 119 ++++++++
 net/netfilter/nf_conntrack_proto_udplite.c     | 385 -------------------------
 8 files changed, 123 insertions(+), 396 deletions(-)
 delete mode 100644 net/netfilter/nf_conntrack_proto_udplite.c

diff --git a/include/net/netfilter/ipv4/nf_conntrack_ipv4.h b/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
index 981c327374da..b38a1b6bea9e 100644
--- a/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
+++ b/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
@@ -14,6 +14,7 @@ extern struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv4;
 
 extern struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp4;
 extern struct nf_conntrack_l4proto nf_conntrack_l4proto_udp4;
+extern struct nf_conntrack_l4proto nf_conntrack_l4proto_udplite4;
 extern struct nf_conntrack_l4proto nf_conntrack_l4proto_icmp;
 
 int nf_conntrack_ipv4_compat_init(void);
diff --git a/include/net/netfilter/ipv6/nf_conntrack_ipv6.h b/include/net/netfilter/ipv6/nf_conntrack_ipv6.h
index a4c993685795..65d5d255bc4f 100644
--- a/include/net/netfilter/ipv6/nf_conntrack_ipv6.h
+++ b/include/net/netfilter/ipv6/nf_conntrack_ipv6.h
@@ -5,6 +5,7 @@ extern struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv6;
 
 extern struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp6;
 extern struct nf_conntrack_l4proto nf_conntrack_l4proto_udp6;
+extern struct nf_conntrack_l4proto nf_conntrack_l4proto_udplite6;
 extern struct nf_conntrack_l4proto nf_conntrack_l4proto_icmpv6;
 
 #include <linux/sysctl.h>
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 7130ed5dc1fa..3539aba83926 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -339,6 +339,7 @@ MODULE_LICENSE("GPL");
 static struct nf_conntrack_l4proto *builtin_l4proto4[] = {
 	&nf_conntrack_l4proto_tcp4,
 	&nf_conntrack_l4proto_udp4,
+	&nf_conntrack_l4proto_udplite4,
 	&nf_conntrack_l4proto_icmp,
 };
 
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index 500be28ff563..6c5a2b09bad6 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -339,6 +339,7 @@ static struct nf_sockopt_ops so_getorigdst6 = {
 static struct nf_conntrack_l4proto *builtin_l4proto6[] = {
 	&nf_conntrack_l4proto_tcp6,
 	&nf_conntrack_l4proto_udp6,
+	&nf_conntrack_l4proto_udplite6,
 	&nf_conntrack_l4proto_icmpv6,
 };
 
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 44410d30d461..9c34c2cabd76 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -169,16 +169,6 @@ config NF_CT_PROTO_SCTP
 	  If you want to compile it as a module, say M here and read
 	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.
 
-config NF_CT_PROTO_UDPLITE
-	tristate 'UDP-Lite protocol connection tracking support'
-	depends on NETFILTER_ADVANCED
-	help
-	  With this option enabled, the layer 3 independent connection
-	  tracking code will be able to do state tracking on UDP-Lite
-	  connections.
-
-	  To compile it as a module, choose M here.  If unsure, say N.
-
 config NF_CONNTRACK_AMANDA
 	tristate "Amanda backup protocol support"
 	depends on NETFILTER_ADVANCED
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 5bbf767672ec..66c7faf52f20 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -20,7 +20,6 @@ obj-$(CONFIG_NF_CONNTRACK) += nf_conntrack.o
 obj-$(CONFIG_NF_CT_PROTO_DCCP) += nf_conntrack_proto_dccp.o
 obj-$(CONFIG_NF_CT_PROTO_GRE) += nf_conntrack_proto_gre.o
 obj-$(CONFIG_NF_CT_PROTO_SCTP) += nf_conntrack_proto_sctp.o
-obj-$(CONFIG_NF_CT_PROTO_UDPLITE) += nf_conntrack_proto_udplite.o
 
 # netlink interface for nf_conntrack
 obj-$(CONFIG_NF_CT_NETLINK) += nf_conntrack_netlink.o
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index 20f35ed68030..3bbaa8f290ae 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -108,6 +108,57 @@ static bool udp_new(struct nf_conn *ct, const struct sk_buff *skb,
 	return true;
 }
 
+static int udplite_error(struct net *net, struct nf_conn *tmpl,
+			 struct sk_buff *skb,
+			 unsigned int dataoff,
+			 enum ip_conntrack_info *ctinfo,
+			 u8 pf, unsigned int hooknum)
+{
+	unsigned int udplen = skb->len - dataoff;
+	const struct udphdr *hdr;
+	struct udphdr _hdr;
+	unsigned int cscov;
+
+	/* Header is too small? */
+	hdr = skb_header_pointer(skb, dataoff, sizeof(_hdr), &_hdr);
+	if (!hdr) {
+		if (LOG_INVALID(net, IPPROTO_UDPLITE))
+			nf_log_packet(net, pf, 0, skb, NULL, NULL, NULL,
+				      "nf_ct_udplite: short packet ");
+		return -NF_ACCEPT;
+	}
+
+	cscov = ntohs(hdr->len);
+	if (cscov == 0) {
+		cscov = udplen;
+	} else if (cscov < sizeof(*hdr) || cscov > udplen) {
+		if (LOG_INVALID(net, IPPROTO_UDPLITE))
+			nf_log_packet(net, pf, 0, skb, NULL, NULL, NULL,
+				      "nf_ct_udplite: invalid checksum coverage ");
+		return -NF_ACCEPT;
+	}
+
+	/* UDPLITE mandates checksums */
+	if (!hdr->check) {
+		if (LOG_INVALID(net, IPPROTO_UDPLITE))
+			nf_log_packet(net, pf, 0, skb, NULL, NULL, NULL,
+				      "nf_ct_udplite: checksum missing ");
+		return -NF_ACCEPT;
+	}
+
+	/* Checksum invalid? Ignore. */
+	if (net->ct.sysctl_checksum && hooknum == NF_INET_PRE_ROUTING &&
+	    nf_checksum_partial(skb, hooknum, dataoff, cscov, IPPROTO_UDP,
+				pf)) {
+		if (LOG_INVALID(net, IPPROTO_UDPLITE))
+			nf_log_packet(net, pf, 0, skb, NULL, NULL, NULL,
+				      "nf_ct_udplite: bad UDPLite checksum ");
+		return -NF_ACCEPT;
+	}
+
+	return NF_ACCEPT;
+}
+
 static int udp_error(struct net *net, struct nf_conn *tmpl, struct sk_buff *skb,
 		     unsigned int dataoff, enum ip_conntrack_info *ctinfo,
 		     u_int8_t pf,
@@ -254,6 +305,8 @@ static int udp_init_net(struct net *net, u_int16_t proto)
 
 static struct nf_proto_net *udp_get_net_proto(struct net *net)
 {
+	BUILD_BUG_ON(CTA_TIMEOUT_UDP_MAX != CTA_TIMEOUT_UDPLITE_MAX);
+
 	return &net->ct.nf_ct_proto.udp.pn;
 }
 
@@ -290,6 +343,39 @@ struct nf_conntrack_l4proto nf_conntrack_l4proto_udp4 __read_mostly =
 };
 EXPORT_SYMBOL_GPL(nf_conntrack_l4proto_udp4);
 
+struct nf_conntrack_l4proto nf_conntrack_l4proto_udplite4 __read_mostly =
+{
+	.l3proto		= PF_INET,
+	.l4proto		= IPPROTO_UDPLITE,
+	.name			= "udplite",
+	.allow_clash		= true,
+	.pkt_to_tuple		= udp_pkt_to_tuple,
+	.invert_tuple		= udp_invert_tuple,
+	.print_tuple		= udp_print_tuple,
+	.packet			= udp_packet,
+	.get_timeouts		= udp_get_timeouts,
+	.new			= udp_new,
+	.error			= udplite_error,
+#if IS_ENABLED(CONFIG_NF_CT_NETLINK)
+	.tuple_to_nlattr	= nf_ct_port_tuple_to_nlattr,
+	.nlattr_to_tuple	= nf_ct_port_nlattr_to_tuple,
+	.nlattr_tuple_size	= nf_ct_port_nlattr_tuple_size,
+	.nla_policy		= nf_ct_port_nla_policy,
+#endif
+#if IS_ENABLED(CONFIG_NF_CT_NETLINK_TIMEOUT)
+	.ctnl_timeout		= {
+		.nlattr_to_obj	= udp_timeout_nlattr_to_obj,
+		.obj_to_nlattr	= udp_timeout_obj_to_nlattr,
+		.nlattr_max	= CTA_TIMEOUT_UDP_MAX,
+		.obj_size	= sizeof(unsigned int) * CTA_TIMEOUT_UDP_MAX,
+		.nla_policy	= udp_timeout_nla_policy,
+	},
+#endif /* CONFIG_NF_CT_NETLINK_TIMEOUT */
+	.init_net		= udp_init_net,
+	.get_net_proto		= udp_get_net_proto,
+};
+EXPORT_SYMBOL_GPL(nf_conntrack_l4proto_udplite4);
+
 struct nf_conntrack_l4proto nf_conntrack_l4proto_udp6 __read_mostly =
 {
 	.l3proto		= PF_INET6,
@@ -322,3 +408,36 @@ struct nf_conntrack_l4proto nf_conntrack_l4proto_udp6 __read_mostly =
 	.get_net_proto		= udp_get_net_proto,
 };
 EXPORT_SYMBOL_GPL(nf_conntrack_l4proto_udp6);
+
+struct nf_conntrack_l4proto nf_conntrack_l4proto_udplite6 __read_mostly =
+{
+	.l3proto		= PF_INET6,
+	.l4proto		= IPPROTO_UDPLITE,
+	.name			= "udplite",
+	.allow_clash		= true,
+	.pkt_to_tuple		= udp_pkt_to_tuple,
+	.invert_tuple		= udp_invert_tuple,
+	.print_tuple		= udp_print_tuple,
+	.packet			= udp_packet,
+	.get_timeouts		= udp_get_timeouts,
+	.new			= udp_new,
+	.error			= udplite_error,
+#if IS_ENABLED(CONFIG_NF_CT_NETLINK)
+	.tuple_to_nlattr	= nf_ct_port_tuple_to_nlattr,
+	.nlattr_to_tuple	= nf_ct_port_nlattr_to_tuple,
+	.nlattr_tuple_size	= nf_ct_port_nlattr_tuple_size,
+	.nla_policy		= nf_ct_port_nla_policy,
+#endif
+#if IS_ENABLED(CONFIG_NF_CT_NETLINK_TIMEOUT)
+	.ctnl_timeout		= {
+		.nlattr_to_obj	= udp_timeout_nlattr_to_obj,
+		.obj_to_nlattr	= udp_timeout_obj_to_nlattr,
+		.nlattr_max	= CTA_TIMEOUT_UDP_MAX,
+		.obj_size	= sizeof(unsigned int) * CTA_TIMEOUT_UDP_MAX,
+		.nla_policy	= udp_timeout_nla_policy,
+	},
+#endif /* CONFIG_NF_CT_NETLINK_TIMEOUT */
+	.init_net		= udp_init_net,
+	.get_net_proto		= udp_get_net_proto,
+};
+EXPORT_SYMBOL_GPL(nf_conntrack_l4proto_udplite6);
diff --git a/net/netfilter/nf_conntrack_proto_udplite.c b/net/netfilter/nf_conntrack_proto_udplite.c
deleted file mode 100644
index 8cdb4b1bf933..000000000000
--- a/net/netfilter/nf_conntrack_proto_udplite.c
+++ /dev/null
@@ -1,385 +0,0 @@
-/* (C) 1999-2001 Paul `Rusty' Russell
- * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
- * (C) 2007 Patrick McHardy <kaber@trash.net>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/types.h>
-#include <linux/timer.h>
-#include <linux/module.h>
-#include <linux/udp.h>
-#include <linux/seq_file.h>
-#include <linux/skbuff.h>
-#include <linux/ipv6.h>
-#include <net/ip6_checksum.h>
-#include <net/checksum.h>
-
-#include <linux/netfilter.h>
-#include <linux/netfilter_ipv4.h>
-#include <linux/netfilter_ipv6.h>
-#include <net/netfilter/nf_conntrack_l4proto.h>
-#include <net/netfilter/nf_conntrack_ecache.h>
-#include <net/netfilter/nf_log.h>
-
-enum udplite_conntrack {
-	UDPLITE_CT_UNREPLIED,
-	UDPLITE_CT_REPLIED,
-	UDPLITE_CT_MAX
-};
-
-static unsigned int udplite_timeouts[UDPLITE_CT_MAX] = {
-	[UDPLITE_CT_UNREPLIED]	= 30*HZ,
-	[UDPLITE_CT_REPLIED]	= 180*HZ,
-};
-
-static int udplite_net_id __read_mostly;
-struct udplite_net {
-	struct nf_proto_net pn;
-	unsigned int timeouts[UDPLITE_CT_MAX];
-};
-
-static inline struct udplite_net *udplite_pernet(struct net *net)
-{
-	return net_generic(net, udplite_net_id);
-}
-
-static bool udplite_pkt_to_tuple(const struct sk_buff *skb,
-				 unsigned int dataoff,
-				 struct net *net,
-				 struct nf_conntrack_tuple *tuple)
-{
-	const struct udphdr *hp;
-	struct udphdr _hdr;
-
-	/* Actually only need first 4 bytes to get ports. */
-	hp = skb_header_pointer(skb, dataoff, 4, &_hdr);
-	if (hp == NULL)
-		return false;
-
-	tuple->src.u.udp.port = hp->source;
-	tuple->dst.u.udp.port = hp->dest;
-	return true;
-}
-
-static bool udplite_invert_tuple(struct nf_conntrack_tuple *tuple,
-				 const struct nf_conntrack_tuple *orig)
-{
-	tuple->src.u.udp.port = orig->dst.u.udp.port;
-	tuple->dst.u.udp.port = orig->src.u.udp.port;
-	return true;
-}
-
-/* Print out the per-protocol part of the tuple. */
-static void udplite_print_tuple(struct seq_file *s,
-				const struct nf_conntrack_tuple *tuple)
-{
-	seq_printf(s, "sport=%hu dport=%hu ",
-		   ntohs(tuple->src.u.udp.port),
-		   ntohs(tuple->dst.u.udp.port));
-}
-
-static unsigned int *udplite_get_timeouts(struct net *net)
-{
-	return udplite_pernet(net)->timeouts;
-}
-
-/* Returns verdict for packet, and may modify conntracktype */
-static int udplite_packet(struct nf_conn *ct,
-			  const struct sk_buff *skb,
-			  unsigned int dataoff,
-			  enum ip_conntrack_info ctinfo,
-			  u_int8_t pf,
-			  unsigned int hooknum,
-			  unsigned int *timeouts)
-{
-	/* If we've seen traffic both ways, this is some kind of UDP
-	   stream.  Extend timeout. */
-	if (test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
-		nf_ct_refresh_acct(ct, ctinfo, skb,
-				   timeouts[UDPLITE_CT_REPLIED]);
-		/* Also, more likely to be important, and not a probe */
-		if (!test_and_set_bit(IPS_ASSURED_BIT, &ct->status))
-			nf_conntrack_event_cache(IPCT_ASSURED, ct);
-	} else {
-		nf_ct_refresh_acct(ct, ctinfo, skb,
-				   timeouts[UDPLITE_CT_UNREPLIED]);
-	}
-	return NF_ACCEPT;
-}
-
-/* Called when a new connection for this protocol found. */
-static bool udplite_new(struct nf_conn *ct, const struct sk_buff *skb,
-			unsigned int dataoff, unsigned int *timeouts)
-{
-	return true;
-}
-
-static int udplite_error(struct net *net, struct nf_conn *tmpl,
-			 struct sk_buff *skb,
-			 unsigned int dataoff,
-			 enum ip_conntrack_info *ctinfo,
-			 u_int8_t pf,
-			 unsigned int hooknum)
-{
-	unsigned int udplen = skb->len - dataoff;
-	const struct udphdr *hdr;
-	struct udphdr _hdr;
-	unsigned int cscov;
-
-	/* Header is too small? */
-	hdr = skb_header_pointer(skb, dataoff, sizeof(_hdr), &_hdr);
-	if (hdr == NULL) {
-		if (LOG_INVALID(net, IPPROTO_UDPLITE))
-			nf_log_packet(net, pf, 0, skb, NULL, NULL, NULL,
-				      "nf_ct_udplite: short packet ");
-		return -NF_ACCEPT;
-	}
-
-	cscov = ntohs(hdr->len);
-	if (cscov == 0)
-		cscov = udplen;
-	else if (cscov < sizeof(*hdr) || cscov > udplen) {
-		if (LOG_INVALID(net, IPPROTO_UDPLITE))
-			nf_log_packet(net, pf, 0, skb, NULL, NULL, NULL,
-				"nf_ct_udplite: invalid checksum coverage ");
-		return -NF_ACCEPT;
-	}
-
-	/* UDPLITE mandates checksums */
-	if (!hdr->check) {
-		if (LOG_INVALID(net, IPPROTO_UDPLITE))
-			nf_log_packet(net, pf, 0, skb, NULL, NULL, NULL,
-				      "nf_ct_udplite: checksum missing ");
-		return -NF_ACCEPT;
-	}
-
-	/* Checksum invalid? Ignore. */
-	if (net->ct.sysctl_checksum && hooknum == NF_INET_PRE_ROUTING &&
-	    nf_checksum_partial(skb, hooknum, dataoff, cscov, IPPROTO_UDP,
-	    			pf)) {
-		if (LOG_INVALID(net, IPPROTO_UDPLITE))
-			nf_log_packet(net, pf, 0, skb, NULL, NULL, NULL,
-				      "nf_ct_udplite: bad UDPLite checksum ");
-		return -NF_ACCEPT;
-	}
-
-	return NF_ACCEPT;
-}
-
-#if IS_ENABLED(CONFIG_NF_CT_NETLINK_TIMEOUT)
-
-#include <linux/netfilter/nfnetlink.h>
-#include <linux/netfilter/nfnetlink_cttimeout.h>
-
-static int udplite_timeout_nlattr_to_obj(struct nlattr *tb[],
-					 struct net *net, void *data)
-{
-	unsigned int *timeouts = data;
-	struct udplite_net *un = udplite_pernet(net);
-
-	/* set default timeouts for UDPlite. */
-	timeouts[UDPLITE_CT_UNREPLIED] = un->timeouts[UDPLITE_CT_UNREPLIED];
-	timeouts[UDPLITE_CT_REPLIED] = un->timeouts[UDPLITE_CT_REPLIED];
-
-	if (tb[CTA_TIMEOUT_UDPLITE_UNREPLIED]) {
-		timeouts[UDPLITE_CT_UNREPLIED] =
-		  ntohl(nla_get_be32(tb[CTA_TIMEOUT_UDPLITE_UNREPLIED])) * HZ;
-	}
-	if (tb[CTA_TIMEOUT_UDPLITE_REPLIED]) {
-		timeouts[UDPLITE_CT_REPLIED] =
-		  ntohl(nla_get_be32(tb[CTA_TIMEOUT_UDPLITE_REPLIED])) * HZ;
-	}
-	return 0;
-}
-
-static int
-udplite_timeout_obj_to_nlattr(struct sk_buff *skb, const void *data)
-{
-	const unsigned int *timeouts = data;
-
-	if (nla_put_be32(skb, CTA_TIMEOUT_UDPLITE_UNREPLIED,
-			 htonl(timeouts[UDPLITE_CT_UNREPLIED] / HZ)) ||
-	    nla_put_be32(skb, CTA_TIMEOUT_UDPLITE_REPLIED,
-			 htonl(timeouts[UDPLITE_CT_REPLIED] / HZ)))
-		goto nla_put_failure;
-	return 0;
-
-nla_put_failure:
-	return -ENOSPC;
-}
-
-static const struct nla_policy
-udplite_timeout_nla_policy[CTA_TIMEOUT_UDPLITE_MAX+1] = {
-	[CTA_TIMEOUT_UDPLITE_UNREPLIED]	= { .type = NLA_U32 },
-	[CTA_TIMEOUT_UDPLITE_REPLIED]	= { .type = NLA_U32 },
-};
-#endif /* CONFIG_NF_CT_NETLINK_TIMEOUT */
-
-#ifdef CONFIG_SYSCTL
-static struct ctl_table udplite_sysctl_table[] = {
-	{
-		.procname	= "nf_conntrack_udplite_timeout",
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_jiffies,
-	},
-	{
-		.procname	= "nf_conntrack_udplite_timeout_stream",
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_jiffies,
-	},
-	{ }
-};
-#endif /* CONFIG_SYSCTL */
-
-static int udplite_kmemdup_sysctl_table(struct nf_proto_net *pn,
-					struct udplite_net *un)
-{
-#ifdef CONFIG_SYSCTL
-	if (pn->ctl_table)
-		return 0;
-
-	pn->ctl_table = kmemdup(udplite_sysctl_table,
-				sizeof(udplite_sysctl_table),
-				GFP_KERNEL);
-	if (!pn->ctl_table)
-		return -ENOMEM;
-
-	pn->ctl_table[0].data = &un->timeouts[UDPLITE_CT_UNREPLIED];
-	pn->ctl_table[1].data = &un->timeouts[UDPLITE_CT_REPLIED];
-#endif
-	return 0;
-}
-
-static int udplite_init_net(struct net *net, u_int16_t proto)
-{
-	struct udplite_net *un = udplite_pernet(net);
-	struct nf_proto_net *pn = &un->pn;
-
-	if (!pn->users) {
-		int i;
-
-		for (i = 0 ; i < UDPLITE_CT_MAX; i++)
-			un->timeouts[i] = udplite_timeouts[i];
-	}
-
-	return udplite_kmemdup_sysctl_table(pn, un);
-}
-
-static struct nf_conntrack_l4proto nf_conntrack_l4proto_udplite4 __read_mostly =
-{
-	.l3proto		= PF_INET,
-	.l4proto		= IPPROTO_UDPLITE,
-	.name			= "udplite",
-	.allow_clash		= true,
-	.pkt_to_tuple		= udplite_pkt_to_tuple,
-	.invert_tuple		= udplite_invert_tuple,
-	.print_tuple		= udplite_print_tuple,
-	.packet			= udplite_packet,
-	.get_timeouts		= udplite_get_timeouts,
-	.new			= udplite_new,
-	.error			= udplite_error,
-#if IS_ENABLED(CONFIG_NF_CT_NETLINK)
-	.tuple_to_nlattr	= nf_ct_port_tuple_to_nlattr,
-	.nlattr_tuple_size	= nf_ct_port_nlattr_tuple_size,
-	.nlattr_to_tuple	= nf_ct_port_nlattr_to_tuple,
-	.nla_policy		= nf_ct_port_nla_policy,
-#endif
-#if IS_ENABLED(CONFIG_NF_CT_NETLINK_TIMEOUT)
-	.ctnl_timeout		= {
-		.nlattr_to_obj	= udplite_timeout_nlattr_to_obj,
-		.obj_to_nlattr	= udplite_timeout_obj_to_nlattr,
-		.nlattr_max	= CTA_TIMEOUT_UDPLITE_MAX,
-		.obj_size	= sizeof(unsigned int) *
-					CTA_TIMEOUT_UDPLITE_MAX,
-		.nla_policy	= udplite_timeout_nla_policy,
-	},
-#endif /* CONFIG_NF_CT_NETLINK_TIMEOUT */
-	.net_id			= &udplite_net_id,
-	.init_net		= udplite_init_net,
-};
-
-static struct nf_conntrack_l4proto nf_conntrack_l4proto_udplite6 __read_mostly =
-{
-	.l3proto		= PF_INET6,
-	.l4proto		= IPPROTO_UDPLITE,
-	.name			= "udplite",
-	.allow_clash		= true,
-	.pkt_to_tuple		= udplite_pkt_to_tuple,
-	.invert_tuple		= udplite_invert_tuple,
-	.print_tuple		= udplite_print_tuple,
-	.packet			= udplite_packet,
-	.get_timeouts		= udplite_get_timeouts,
-	.new			= udplite_new,
-	.error			= udplite_error,
-#if IS_ENABLED(CONFIG_NF_CT_NETLINK)
-	.tuple_to_nlattr	= nf_ct_port_tuple_to_nlattr,
-	.nlattr_tuple_size	= nf_ct_port_nlattr_tuple_size,
-	.nlattr_to_tuple	= nf_ct_port_nlattr_to_tuple,
-	.nla_policy		= nf_ct_port_nla_policy,
-#endif
-#if IS_ENABLED(CONFIG_NF_CT_NETLINK_TIMEOUT)
-	.ctnl_timeout		= {
-		.nlattr_to_obj	= udplite_timeout_nlattr_to_obj,
-		.obj_to_nlattr	= udplite_timeout_obj_to_nlattr,
-		.nlattr_max	= CTA_TIMEOUT_UDPLITE_MAX,
-		.obj_size	= sizeof(unsigned int) *
-					CTA_TIMEOUT_UDPLITE_MAX,
-		.nla_policy	= udplite_timeout_nla_policy,
-	},
-#endif /* CONFIG_NF_CT_NETLINK_TIMEOUT */
-	.net_id			= &udplite_net_id,
-	.init_net		= udplite_init_net,
-};
-
-static struct nf_conntrack_l4proto *udplite_proto[] = {
-	&nf_conntrack_l4proto_udplite4,
-	&nf_conntrack_l4proto_udplite6,
-};
-
-static int udplite_net_init(struct net *net)
-{
-	return nf_ct_l4proto_pernet_register(net, udplite_proto,
-					     ARRAY_SIZE(udplite_proto));
-}
-
-static void udplite_net_exit(struct net *net)
-{
-	nf_ct_l4proto_pernet_unregister(net, udplite_proto,
-					ARRAY_SIZE(udplite_proto));
-}
-
-static struct pernet_operations udplite_net_ops = {
-	.init = udplite_net_init,
-	.exit = udplite_net_exit,
-	.id   = &udplite_net_id,
-	.size = sizeof(struct udplite_net),
-};
-
-static int __init nf_conntrack_proto_udplite_init(void)
-{
-	int ret;
-
-	ret = register_pernet_subsys(&udplite_net_ops);
-	if (ret < 0)
-		return ret;
-	ret = nf_ct_l4proto_register(udplite_proto, ARRAY_SIZE(udplite_proto));
-	if (ret < 0)
-		unregister_pernet_subsys(&udplite_net_ops);
-	return ret;
-}
-
-static void __exit nf_conntrack_proto_udplite_exit(void)
-{
-	nf_ct_l4proto_unregister(udplite_proto, ARRAY_SIZE(udplite_proto));
-	unregister_pernet_subsys(&udplite_net_ops);
-}
-
-module_init(nf_conntrack_proto_udplite_init);
-module_exit(nf_conntrack_proto_udplite_exit);
-
-MODULE_LICENSE("GPL");
-- 
2.7.3

