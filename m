From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 03/19]: nfnetlink: rename functions containing 'nfattr'
Date: Fri, 28 Sep 2007 18:30:41 +0200 (MEST)
Message-ID: <20070928163041.8394.3027.sendpatchset@localhost.localdomain>
References: <20070928163036.8394.36374.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55926 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758868AbXI1Qan (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Sep 2007 12:30:43 -0400
In-Reply-To: <20070928163036.8394.36374.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: nfnetlink: rename functions containing 'nfattr'

There is no struct nfattr anymore, rename functions to 'nlattr'.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 46958d51af5d65a36b04e8c8aabba6d86b19b4c7
tree f4114b05757acaaeb3a1a63d30a3910e60886717
parent 7264cb1fe6541b376129c512f2a28a198e52a117
author Patrick McHardy <kaber@trash.net> Fri, 28 Sep 2007 18:09:13 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 28 Sep 2007 18:09:13 +0200

 include/linux/netfilter/nfnetlink.h            |    2 -
 include/net/netfilter/nf_conntrack_helper.h    |    2 -
 include/net/netfilter/nf_conntrack_l3proto.h   |    4 +-
 include/net/netfilter/nf_conntrack_l4proto.h   |   12 +++---
 include/net/netfilter/nf_nat_protocol.h        |    8 ++--
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |   10 ++---
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |   10 ++---
 net/ipv4/netfilter/nf_nat_core.c               |    8 ++--
 net/ipv4/netfilter/nf_nat_proto_gre.c          |    4 +-
 net/ipv4/netfilter/nf_nat_proto_icmp.c         |    4 +-
 net/ipv4/netfilter/nf_nat_proto_tcp.c          |    4 +-
 net/ipv4/netfilter/nf_nat_proto_udp.c          |    4 +-
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |   10 ++---
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |   10 ++---
 net/netfilter/nf_conntrack_core.c              |   10 ++---
 net/netfilter/nf_conntrack_netlink.c           |   52 ++++++++++++------------
 net/netfilter/nf_conntrack_proto_gre.c         |    4 +-
 net/netfilter/nf_conntrack_proto_tcp.c         |   22 +++++-----
 net/netfilter/nf_conntrack_proto_udp.c         |    8 ++--
 net/netfilter/nf_conntrack_proto_udplite.c     |    8 ++--
 net/netfilter/nfnetlink_log.c                  |    2 -
 net/netfilter/nfnetlink_queue.c                |    4 +-
 22 files changed, 101 insertions(+), 101 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/netfilter/nfnetlink.h
index 4185070..0bd6086 100644
--- a/include/linux/netfilter/nfnetlink.h
+++ b/include/linux/netfilter/nfnetlink.h
@@ -72,7 +72,7 @@ struct nfnetlink_subsystem
 extern int nfnetlink_subsys_register(const struct nfnetlink_subsystem *n);
 extern int nfnetlink_subsys_unregister(const struct nfnetlink_subsystem *n);
 
-#define nfattr_bad_size(tb, max, cta_min)				\
+#define nlattr_bad_size(tb, max, cta_min)				\
 ({	int __i, __res = 0;						\
  	for (__i=1; __i <= max; __i++) {					\
  		if (!cta_min[__i])					\
diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index d04f999..0dcc4c8 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -36,7 +36,7 @@ struct nf_conntrack_helper
 
 	void (*destroy)(struct nf_conn *ct);
 
-	int (*to_nfattr)(struct sk_buff *skb, const struct nf_conn *ct);
+	int (*to_nlattr)(struct sk_buff *skb, const struct nf_conn *ct);
 };
 
 extern struct nf_conntrack_helper *
diff --git a/include/net/netfilter/nf_conntrack_l3proto.h b/include/net/netfilter/nf_conntrack_l3proto.h
index c02402d..f6c372d 100644
--- a/include/net/netfilter/nf_conntrack_l3proto.h
+++ b/include/net/netfilter/nf_conntrack_l3proto.h
@@ -63,10 +63,10 @@ struct nf_conntrack_l3proto
 	int (*get_l4proto)(const struct sk_buff *skb, unsigned int nhoff,
 			   unsigned int *dataoff, u_int8_t *protonum);
 
-	int (*tuple_to_nfattr)(struct sk_buff *skb,
+	int (*tuple_to_nlattr)(struct sk_buff *skb,
 			       const struct nf_conntrack_tuple *t);
 
-	int (*nfattr_to_tuple)(struct nlattr *tb[],
+	int (*nlattr_to_tuple)(struct nlattr *tb[],
 			       struct nf_conntrack_tuple *t);
 
 #ifdef CONFIG_SYSCTL
diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index a43c4e4..658dacc 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -65,15 +65,15 @@ struct nf_conntrack_l4proto
 		     int pf, unsigned int hooknum);
 
 	/* convert protoinfo to nfnetink attributes */
-	int (*to_nfattr)(struct sk_buff *skb, struct nlattr *nla,
+	int (*to_nlattr)(struct sk_buff *skb, struct nlattr *nla,
 			 const struct nf_conn *ct);
 
 	/* convert nfnetlink attributes to protoinfo */
-	int (*from_nfattr)(struct nlattr *tb[], struct nf_conn *ct);
+	int (*from_nlattr)(struct nlattr *tb[], struct nf_conn *ct);
 
-	int (*tuple_to_nfattr)(struct sk_buff *skb,
+	int (*tuple_to_nlattr)(struct sk_buff *skb,
 			       const struct nf_conntrack_tuple *t);
-	int (*nfattr_to_tuple)(struct nlattr *tb[],
+	int (*nlattr_to_tuple)(struct nlattr *tb[],
 			       struct nf_conntrack_tuple *t);
 
 #ifdef CONFIG_SYSCTL
@@ -111,9 +111,9 @@ extern int nf_conntrack_l4proto_register(struct nf_conntrack_l4proto *proto);
 extern void nf_conntrack_l4proto_unregister(struct nf_conntrack_l4proto *proto);
 
 /* Generic netlink helpers */
-extern int nf_ct_port_tuple_to_nfattr(struct sk_buff *skb,
+extern int nf_ct_port_tuple_to_nlattr(struct sk_buff *skb,
 				      const struct nf_conntrack_tuple *tuple);
-extern int nf_ct_port_nfattr_to_tuple(struct nlattr *tb[],
+extern int nf_ct_port_nlattr_to_tuple(struct nlattr *tb[],
 				      struct nf_conntrack_tuple *t);
 
 /* Log invalid packets */
diff --git a/include/net/netfilter/nf_nat_protocol.h b/include/net/netfilter/nf_nat_protocol.h
index 90a82de..14c7b2d 100644
--- a/include/net/netfilter/nf_nat_protocol.h
+++ b/include/net/netfilter/nf_nat_protocol.h
@@ -38,10 +38,10 @@ struct nf_nat_protocol
 			    enum nf_nat_manip_type maniptype,
 			    const struct nf_conn *ct);
 
-	int (*range_to_nfattr)(struct sk_buff *skb,
+	int (*range_to_nlattr)(struct sk_buff *skb,
 			       const struct nf_nat_range *range);
 
-	int (*nfattr_to_range)(struct nlattr *tb[],
+	int (*nlattr_to_range)(struct nlattr *tb[],
 			       struct nf_nat_range *range);
 };
 
@@ -62,9 +62,9 @@ extern int init_protocols(void) __init;
 extern void cleanup_protocols(void);
 extern struct nf_nat_protocol *find_nat_proto(u_int16_t protonum);
 
-extern int nf_nat_port_range_to_nfattr(struct sk_buff *skb,
+extern int nf_nat_port_range_to_nlattr(struct sk_buff *skb,
 				       const struct nf_nat_range *range);
-extern int nf_nat_port_nfattr_to_range(struct nlattr *tb[],
+extern int nf_nat_port_nlattr_to_range(struct nlattr *tb[],
 				       struct nf_nat_range *range);
 
 #endif /*_NF_NAT_PROTO_H*/
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index f8771e0..77ca556 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -360,7 +360,7 @@ getorigdst(struct sock *sk, int optval, void __user *user, int *len)
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nfnetlink_conntrack.h>
 
-static int ipv4_tuple_to_nfattr(struct sk_buff *skb,
+static int ipv4_tuple_to_nlattr(struct sk_buff *skb,
 				const struct nf_conntrack_tuple *tuple)
 {
 	NLA_PUT(skb, CTA_IP_V4_SRC, sizeof(u_int32_t),
@@ -378,13 +378,13 @@ static const size_t cta_min_ip[CTA_IP_MAX+1] = {
 	[CTA_IP_V4_DST]	= sizeof(u_int32_t),
 };
 
-static int ipv4_nfattr_to_tuple(struct nlattr *tb[],
+static int ipv4_nlattr_to_tuple(struct nlattr *tb[],
 				struct nf_conntrack_tuple *t)
 {
 	if (!tb[CTA_IP_V4_SRC] || !tb[CTA_IP_V4_DST])
 		return -EINVAL;
 
-	if (nfattr_bad_size(tb, CTA_IP_MAX, cta_min_ip))
+	if (nlattr_bad_size(tb, CTA_IP_MAX, cta_min_ip))
 		return -EINVAL;
 
 	t->src.u3.ip = *(__be32 *)nla_data(tb[CTA_IP_V4_SRC]);
@@ -411,8 +411,8 @@ struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv4 __read_mostly = {
 	.print_conntrack = ipv4_print_conntrack,
 	.get_l4proto	 = ipv4_get_l4proto,
 #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
-	.tuple_to_nfattr = ipv4_tuple_to_nfattr,
-	.nfattr_to_tuple = ipv4_nfattr_to_tuple,
+	.tuple_to_nlattr = ipv4_tuple_to_nlattr,
+	.nlattr_to_tuple = ipv4_nlattr_to_tuple,
 #endif
 #if defined(CONFIG_SYSCTL) && defined(CONFIG_NF_CONNTRACK_PROC_COMPAT)
 	.ctl_table_path  = nf_net_ipv4_netfilter_sysctl_path,
diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
index 714332b..ca7252c 100644
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -232,7 +232,7 @@ icmp_error(struct sk_buff *skb, unsigned int dataoff,
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nfnetlink_conntrack.h>
 
-static int icmp_tuple_to_nfattr(struct sk_buff *skb,
+static int icmp_tuple_to_nlattr(struct sk_buff *skb,
 				const struct nf_conntrack_tuple *t)
 {
 	NLA_PUT(skb, CTA_PROTO_ICMP_ID, sizeof(u_int16_t),
@@ -254,7 +254,7 @@ static const size_t cta_min_proto[CTA_PROTO_MAX+1] = {
 	[CTA_PROTO_ICMP_ID]	= sizeof(u_int16_t)
 };
 
-static int icmp_nfattr_to_tuple(struct nlattr *tb[],
+static int icmp_nlattr_to_tuple(struct nlattr *tb[],
 				struct nf_conntrack_tuple *tuple)
 {
 	if (!tb[CTA_PROTO_ICMP_TYPE]
@@ -262,7 +262,7 @@ static int icmp_nfattr_to_tuple(struct nlattr *tb[],
 	    || !tb[CTA_PROTO_ICMP_ID])
 		return -EINVAL;
 
-	if (nfattr_bad_size(tb, CTA_PROTO_MAX, cta_min_proto))
+	if (nlattr_bad_size(tb, CTA_PROTO_MAX, cta_min_proto))
 		return -EINVAL;
 
 	tuple->dst.u.icmp.type =
@@ -327,8 +327,8 @@ struct nf_conntrack_l4proto nf_conntrack_l4proto_icmp __read_mostly =
 	.destroy		= NULL,
 	.me			= NULL,
 #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
-	.tuple_to_nfattr	= icmp_tuple_to_nfattr,
-	.nfattr_to_tuple	= icmp_nfattr_to_tuple,
+	.tuple_to_nlattr	= icmp_tuple_to_nlattr,
+	.nlattr_to_tuple	= icmp_nlattr_to_tuple,
 #endif
 #ifdef CONFIG_SYSCTL
 	.ctl_table_header	= &icmp_sysctl_header,
diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
index 4bdbb12..7221aa2 100644
--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -544,7 +544,7 @@ EXPORT_SYMBOL(nf_nat_protocol_unregister);
 
 #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
 int
-nf_nat_port_range_to_nfattr(struct sk_buff *skb,
+nf_nat_port_range_to_nlattr(struct sk_buff *skb,
 			    const struct nf_nat_range *range)
 {
 	NLA_PUT(skb, CTA_PROTONAT_PORT_MIN, sizeof(__be16),
@@ -557,10 +557,10 @@ nf_nat_port_range_to_nfattr(struct sk_buff *skb,
 nla_put_failure:
 	return -1;
 }
-EXPORT_SYMBOL_GPL(nf_nat_port_nfattr_to_range);
+EXPORT_SYMBOL_GPL(nf_nat_port_nlattr_to_range);
 
 int
-nf_nat_port_nfattr_to_range(struct nlattr *tb[], struct nf_nat_range *range)
+nf_nat_port_nlattr_to_range(struct nlattr *tb[], struct nf_nat_range *range)
 {
 	int ret = 0;
 
@@ -583,7 +583,7 @@ nf_nat_port_nfattr_to_range(struct nlattr *tb[], struct nf_nat_range *range)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(nf_nat_port_range_to_nfattr);
+EXPORT_SYMBOL_GPL(nf_nat_port_range_to_nlattr);
 #endif
 
 /* Noone using conntrack by the time this called. */
diff --git a/net/ipv4/netfilter/nf_nat_proto_gre.c b/net/ipv4/netfilter/nf_nat_proto_gre.c
index 2e40cc8..d562290 100644
--- a/net/ipv4/netfilter/nf_nat_proto_gre.c
+++ b/net/ipv4/netfilter/nf_nat_proto_gre.c
@@ -142,8 +142,8 @@ static struct nf_nat_protocol gre __read_mostly = {
 	.in_range		= gre_in_range,
 	.unique_tuple		= gre_unique_tuple,
 #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
-	.range_to_nfattr	= nf_nat_port_range_to_nfattr,
-	.nfattr_to_range	= nf_nat_port_nfattr_to_range,
+	.range_to_nlattr	= nf_nat_port_range_to_nlattr,
+	.nlattr_to_range	= nf_nat_port_nlattr_to_range,
 #endif
 };
 
diff --git a/net/ipv4/netfilter/nf_nat_proto_icmp.c b/net/ipv4/netfilter/nf_nat_proto_icmp.c
index f71ef9b..898d737 100644
--- a/net/ipv4/netfilter/nf_nat_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_nat_proto_icmp.c
@@ -79,7 +79,7 @@ struct nf_nat_protocol nf_nat_protocol_icmp = {
 	.in_range		= icmp_in_range,
 	.unique_tuple		= icmp_unique_tuple,
 #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
-	.range_to_nfattr	= nf_nat_port_range_to_nfattr,
-	.nfattr_to_range	= nf_nat_port_nfattr_to_range,
+	.range_to_nlattr	= nf_nat_port_range_to_nlattr,
+	.nlattr_to_range	= nf_nat_port_nlattr_to_range,
 #endif
 };
diff --git a/net/ipv4/netfilter/nf_nat_proto_tcp.c b/net/ipv4/netfilter/nf_nat_proto_tcp.c
index 123c959..5bbbb2a 100644
--- a/net/ipv4/netfilter/nf_nat_proto_tcp.c
+++ b/net/ipv4/netfilter/nf_nat_proto_tcp.c
@@ -145,7 +145,7 @@ struct nf_nat_protocol nf_nat_protocol_tcp = {
 	.in_range		= tcp_in_range,
 	.unique_tuple		= tcp_unique_tuple,
 #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
-	.range_to_nfattr	= nf_nat_port_range_to_nfattr,
-	.nfattr_to_range	= nf_nat_port_nfattr_to_range,
+	.range_to_nlattr	= nf_nat_port_range_to_nlattr,
+	.nlattr_to_range	= nf_nat_port_nlattr_to_range,
 #endif
 };
diff --git a/net/ipv4/netfilter/nf_nat_proto_udp.c b/net/ipv4/netfilter/nf_nat_proto_udp.c
index 1c4c70e..a0af4fd 100644
--- a/net/ipv4/netfilter/nf_nat_proto_udp.c
+++ b/net/ipv4/netfilter/nf_nat_proto_udp.c
@@ -135,7 +135,7 @@ struct nf_nat_protocol nf_nat_protocol_udp = {
 	.in_range		= udp_in_range,
 	.unique_tuple		= udp_unique_tuple,
 #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
-	.range_to_nfattr	= nf_nat_port_range_to_nfattr,
-	.nfattr_to_range	= nf_nat_port_nfattr_to_range,
+	.range_to_nlattr	= nf_nat_port_range_to_nlattr,
+	.nlattr_to_range	= nf_nat_port_nlattr_to_range,
 #endif
 };
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index f0ea3fb..567fbe2 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -337,7 +337,7 @@ static ctl_table nf_ct_ipv6_sysctl_table[] = {
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nfnetlink_conntrack.h>
 
-static int ipv6_tuple_to_nfattr(struct sk_buff *skb,
+static int ipv6_tuple_to_nlattr(struct sk_buff *skb,
 				const struct nf_conntrack_tuple *tuple)
 {
 	NLA_PUT(skb, CTA_IP_V6_SRC, sizeof(u_int32_t) * 4,
@@ -355,13 +355,13 @@ static const size_t cta_min_ip[CTA_IP_MAX+1] = {
 	[CTA_IP_V6_DST]	= sizeof(u_int32_t)*4,
 };
 
-static int ipv6_nfattr_to_tuple(struct nlattr *tb[],
+static int ipv6_nlattr_to_tuple(struct nlattr *tb[],
 				struct nf_conntrack_tuple *t)
 {
 	if (!tb[CTA_IP_V6_SRC] || !tb[CTA_IP_V6_DST])
 		return -EINVAL;
 
-	if (nfattr_bad_size(tb, CTA_IP_MAX, cta_min_ip))
+	if (nlattr_bad_size(tb, CTA_IP_MAX, cta_min_ip))
 		return -EINVAL;
 
 	memcpy(&t->src.u3.ip6, nla_data(tb[CTA_IP_V6_SRC]),
@@ -382,8 +382,8 @@ struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv6 __read_mostly = {
 	.print_conntrack	= ipv6_print_conntrack,
 	.get_l4proto		= ipv6_get_l4proto,
 #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
-	.tuple_to_nfattr	= ipv6_tuple_to_nfattr,
-	.nfattr_to_tuple	= ipv6_nfattr_to_tuple,
+	.tuple_to_nlattr	= ipv6_tuple_to_nlattr,
+	.nlattr_to_tuple	= ipv6_nlattr_to_tuple,
 #endif
 #ifdef CONFIG_SYSCTL
 	.ctl_table_path		= nf_net_netfilter_sysctl_path,
diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index c181838..238ea6b 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -210,7 +210,7 @@ icmpv6_error(struct sk_buff *skb, unsigned int dataoff,
 
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nfnetlink_conntrack.h>
-static int icmpv6_tuple_to_nfattr(struct sk_buff *skb,
+static int icmpv6_tuple_to_nlattr(struct sk_buff *skb,
 				  const struct nf_conntrack_tuple *t)
 {
 	NLA_PUT(skb, CTA_PROTO_ICMPV6_ID, sizeof(u_int16_t),
@@ -232,7 +232,7 @@ static const size_t cta_min_proto[CTA_PROTO_MAX+1] = {
 	[CTA_PROTO_ICMPV6_ID]	= sizeof(u_int16_t)
 };
 
-static int icmpv6_nfattr_to_tuple(struct nlattr *tb[],
+static int icmpv6_nlattr_to_tuple(struct nlattr *tb[],
 				struct nf_conntrack_tuple *tuple)
 {
 	if (!tb[CTA_PROTO_ICMPV6_TYPE]
@@ -240,7 +240,7 @@ static int icmpv6_nfattr_to_tuple(struct nlattr *tb[],
 	    || !tb[CTA_PROTO_ICMPV6_ID])
 		return -EINVAL;
 
-	if (nfattr_bad_size(tb, CTA_PROTO_MAX, cta_min_proto))
+	if (nlattr_bad_size(tb, CTA_PROTO_MAX, cta_min_proto))
 		return -EINVAL;
 
 	tuple->dst.u.icmp.type =
@@ -289,8 +289,8 @@ struct nf_conntrack_l4proto nf_conntrack_l4proto_icmpv6 __read_mostly =
 	.new			= icmpv6_new,
 	.error			= icmpv6_error,
 #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
-	.tuple_to_nfattr	= icmpv6_tuple_to_nfattr,
-	.nfattr_to_tuple	= icmpv6_nfattr_to_tuple,
+	.tuple_to_nlattr	= icmpv6_tuple_to_nlattr,
+	.nlattr_to_tuple	= icmpv6_nlattr_to_tuple,
 #endif
 #ifdef CONFIG_SYSCTL
 	.ctl_table_header	= &icmpv6_sysctl_header,
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index b64656a..9edaaf2 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -830,7 +830,7 @@ EXPORT_SYMBOL_GPL(__nf_ct_refresh_acct);
 /* Generic function for tcp/udp/sctp/dccp and alike. This needs to be
  * in ip_conntrack_core, since we don't want the protocols to autoload
  * or depend on ctnetlink */
-int nf_ct_port_tuple_to_nfattr(struct sk_buff *skb,
+int nf_ct_port_tuple_to_nlattr(struct sk_buff *skb,
 			       const struct nf_conntrack_tuple *tuple)
 {
 	NLA_PUT(skb, CTA_PROTO_SRC_PORT, sizeof(u_int16_t),
@@ -842,20 +842,20 @@ int nf_ct_port_tuple_to_nfattr(struct sk_buff *skb,
 nla_put_failure:
 	return -1;
 }
-EXPORT_SYMBOL_GPL(nf_ct_port_tuple_to_nfattr);
+EXPORT_SYMBOL_GPL(nf_ct_port_tuple_to_nlattr);
 
 static const size_t cta_min_proto[CTA_PROTO_MAX+1] = {
 	[CTA_PROTO_SRC_PORT]  = sizeof(u_int16_t),
 	[CTA_PROTO_DST_PORT]  = sizeof(u_int16_t)
 };
 
-int nf_ct_port_nfattr_to_tuple(struct nlattr *tb[],
+int nf_ct_port_nlattr_to_tuple(struct nlattr *tb[],
 			       struct nf_conntrack_tuple *t)
 {
 	if (!tb[CTA_PROTO_SRC_PORT] || !tb[CTA_PROTO_DST_PORT])
 		return -EINVAL;
 
-	if (nfattr_bad_size(tb, CTA_PROTO_MAX, cta_min_proto))
+	if (nlattr_bad_size(tb, CTA_PROTO_MAX, cta_min_proto))
 		return -EINVAL;
 
 	t->src.u.tcp.port = *(__be16 *)nla_data(tb[CTA_PROTO_SRC_PORT]);
@@ -863,7 +863,7 @@ int nf_ct_port_nfattr_to_tuple(struct nlattr *tb[],
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(nf_ct_port_nfattr_to_tuple);
+EXPORT_SYMBOL_GPL(nf_ct_port_nlattr_to_tuple);
 #endif
 
 /* Used by ipt_REJECT and ip6t_REJECT. */
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 221c38f..9f9bef2 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -61,8 +61,8 @@ ctnetlink_dump_tuples_proto(struct sk_buff *skb,
 		goto nla_put_failure;
 	NLA_PUT(skb, CTA_PROTO_NUM, sizeof(u_int8_t), &tuple->dst.protonum);
 
-	if (likely(l4proto->tuple_to_nfattr))
-		ret = l4proto->tuple_to_nfattr(skb, tuple);
+	if (likely(l4proto->tuple_to_nlattr))
+		ret = l4proto->tuple_to_nlattr(skb, tuple);
 
 	nla_nest_end(skb, nest_parms);
 
@@ -84,8 +84,8 @@ ctnetlink_dump_tuples_ip(struct sk_buff *skb,
 	if (!nest_parms)
 		goto nla_put_failure;
 
-	if (likely(l3proto->tuple_to_nfattr))
-		ret = l3proto->tuple_to_nfattr(skb, tuple);
+	if (likely(l3proto->tuple_to_nlattr))
+		ret = l3proto->tuple_to_nlattr(skb, tuple);
 
 	nla_nest_end(skb, nest_parms);
 
@@ -153,7 +153,7 @@ ctnetlink_dump_protoinfo(struct sk_buff *skb, const struct nf_conn *ct)
 	struct nlattr *nest_proto;
 	int ret;
 
-	if (!l4proto->to_nfattr) {
+	if (!l4proto->to_nlattr) {
 		nf_ct_l4proto_put(l4proto);
 		return 0;
 	}
@@ -162,7 +162,7 @@ ctnetlink_dump_protoinfo(struct sk_buff *skb, const struct nf_conn *ct)
 	if (!nest_proto)
 		goto nla_put_failure;
 
-	ret = l4proto->to_nfattr(skb, nest_proto, ct);
+	ret = l4proto->to_nlattr(skb, nest_proto, ct);
 
 	nf_ct_l4proto_put(l4proto);
 
@@ -195,8 +195,8 @@ ctnetlink_dump_helpinfo(struct sk_buff *skb, const struct nf_conn *ct)
 		goto nla_put_failure;
 	NLA_PUT(skb, CTA_HELP_NAME, strlen(helper->name), helper->name);
 
-	if (helper->to_nfattr)
-		helper->to_nfattr(skb, ct);
+	if (helper->to_nlattr)
+		helper->to_nlattr(skb, ct);
 
 	nla_nest_end(skb, nest_helper);
 out:
@@ -512,8 +512,8 @@ ctnetlink_parse_tuple_ip(struct nlattr *attr, struct nf_conntrack_tuple *tuple)
 
 	l3proto = nf_ct_l3proto_find_get(tuple->src.l3num);
 
-	if (likely(l3proto->nfattr_to_tuple))
-		ret = l3proto->nfattr_to_tuple(tb, tuple);
+	if (likely(l3proto->nlattr_to_tuple))
+		ret = l3proto->nlattr_to_tuple(tb, tuple);
 
 	nf_ct_l3proto_put(l3proto);
 
@@ -534,7 +534,7 @@ ctnetlink_parse_tuple_proto(struct nlattr *attr,
 
 	nla_parse_nested(tb, CTA_PROTO_MAX, attr, NULL);
 
-	if (nfattr_bad_size(tb, CTA_PROTO_MAX, cta_min_proto))
+	if (nlattr_bad_size(tb, CTA_PROTO_MAX, cta_min_proto))
 		return -EINVAL;
 
 	if (!tb[CTA_PROTO_NUM])
@@ -543,8 +543,8 @@ ctnetlink_parse_tuple_proto(struct nlattr *attr,
 
 	l4proto = nf_ct_l4proto_find_get(tuple->src.l3num, tuple->dst.protonum);
 
-	if (likely(l4proto->nfattr_to_tuple))
-		ret = l4proto->nfattr_to_tuple(tb, tuple);
+	if (likely(l4proto->nlattr_to_tuple))
+		ret = l4proto->nlattr_to_tuple(tb, tuple);
 
 	nf_ct_l4proto_put(l4proto);
 
@@ -602,18 +602,18 @@ static int nfnetlink_parse_nat_proto(struct nlattr *attr,
 
 	nla_parse_nested(tb, CTA_PROTONAT_MAX, attr, NULL);
 
-	if (nfattr_bad_size(tb, CTA_PROTONAT_MAX, cta_min_protonat))
+	if (nlattr_bad_size(tb, CTA_PROTONAT_MAX, cta_min_protonat))
 		return -EINVAL;
 
 	npt = nf_nat_proto_find_get(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum);
 
-	if (!npt->nfattr_to_range) {
+	if (!npt->nlattr_to_range) {
 		nf_nat_proto_put(npt);
 		return 0;
 	}
 
-	/* nfattr_to_range returns 1 if it parsed, 0 if not, neg. on error */
-	if (npt->nfattr_to_range(tb, range) > 0)
+	/* nlattr_to_range returns 1 if it parsed, 0 if not, neg. on error */
+	if (npt->nlattr_to_range(tb, range) > 0)
 		range->flags |= IP_NAT_RANGE_PROTO_SPECIFIED;
 
 	nf_nat_proto_put(npt);
@@ -637,7 +637,7 @@ nfnetlink_parse_nat(struct nlattr *nat,
 
 	nla_parse_nested(tb, CTA_NAT_MAX, nat, NULL);
 
-	if (nfattr_bad_size(tb, CTA_NAT_MAX, cta_min_nat))
+	if (nlattr_bad_size(tb, CTA_NAT_MAX, cta_min_nat))
 		return -EINVAL;
 
 	if (tb[CTA_NAT_MINIP])
@@ -696,7 +696,7 @@ ctnetlink_del_conntrack(struct sock *ctnl, struct sk_buff *skb,
 	u_int8_t u3 = nfmsg->nfgen_family;
 	int err = 0;
 
-	if (nfattr_bad_size(cda, CTA_MAX, cta_min))
+	if (nlattr_bad_size(cda, CTA_MAX, cta_min))
 		return -EINVAL;
 
 	if (cda[CTA_TUPLE_ORIG])
@@ -754,7 +754,7 @@ ctnetlink_get_conntrack(struct sock *ctnl, struct sk_buff *skb,
 					  ctnetlink_done);
 	}
 
-	if (nfattr_bad_size(cda, CTA_MAX, cta_min))
+	if (nlattr_bad_size(cda, CTA_MAX, cta_min))
 		return -EINVAL;
 
 	if (cda[CTA_TUPLE_ORIG])
@@ -928,8 +928,8 @@ ctnetlink_change_protoinfo(struct nf_conn *ct, struct nlattr *cda[])
 
 	l4proto = nf_ct_l4proto_find_get(l3num, npt);
 
-	if (l4proto->from_nfattr)
-		err = l4proto->from_nfattr(tb, ct);
+	if (l4proto->from_nlattr)
+		err = l4proto->from_nlattr(tb, ct);
 	nf_ct_l4proto_put(l4proto);
 
 	return err;
@@ -1045,7 +1045,7 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
 	u_int8_t u3 = nfmsg->nfgen_family;
 	int err = 0;
 
-	if (nfattr_bad_size(cda, CTA_MAX, cta_min))
+	if (nlattr_bad_size(cda, CTA_MAX, cta_min))
 		return -EINVAL;
 
 	if (cda[CTA_TUPLE_ORIG]) {
@@ -1329,7 +1329,7 @@ ctnetlink_get_expect(struct sock *ctnl, struct sk_buff *skb,
 	u_int8_t u3 = nfmsg->nfgen_family;
 	int err = 0;
 
-	if (nfattr_bad_size(cda, CTA_EXPECT_MAX, cta_min_exp))
+	if (nlattr_bad_size(cda, CTA_EXPECT_MAX, cta_min_exp))
 		return -EINVAL;
 
 	if (nlh->nlmsg_flags & NLM_F_DUMP) {
@@ -1393,7 +1393,7 @@ ctnetlink_del_expect(struct sock *ctnl, struct sk_buff *skb,
 	unsigned int i;
 	int err;
 
-	if (nfattr_bad_size(cda, CTA_EXPECT_MAX, cta_min_exp))
+	if (nlattr_bad_size(cda, CTA_EXPECT_MAX, cta_min_exp))
 		return -EINVAL;
 
 	if (cda[CTA_EXPECT_TUPLE]) {
@@ -1534,7 +1534,7 @@ ctnetlink_new_expect(struct sock *ctnl, struct sk_buff *skb,
 	u_int8_t u3 = nfmsg->nfgen_family;
 	int err = 0;
 
-	if (nfattr_bad_size(cda, CTA_EXPECT_MAX, cta_min_exp))
+	if (nlattr_bad_size(cda, CTA_EXPECT_MAX, cta_min_exp))
 		return -EINVAL;
 
 	if (!cda[CTA_EXPECT_TUPLE]
diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
index bdbead8..ff8d03b 100644
--- a/net/netfilter/nf_conntrack_proto_gre.c
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -274,8 +274,8 @@ static struct nf_conntrack_l4proto nf_conntrack_l4proto_gre4 __read_mostly = {
 	.destroy	 = gre_destroy,
 	.me 		 = THIS_MODULE,
 #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
-	.tuple_to_nfattr = nf_ct_port_tuple_to_nfattr,
-	.nfattr_to_tuple = nf_ct_port_nfattr_to_tuple,
+	.tuple_to_nlattr = nf_ct_port_tuple_to_nlattr,
+	.nlattr_to_tuple = nf_ct_port_nlattr_to_tuple,
 #endif
 };
 
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 1d167e6..84f47bc 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1067,7 +1067,7 @@ static int tcp_new(struct nf_conn *conntrack,
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nfnetlink_conntrack.h>
 
-static int tcp_to_nfattr(struct sk_buff *skb, struct nlattr *nla,
+static int tcp_to_nlattr(struct sk_buff *skb, struct nlattr *nla,
 			 const struct nf_conn *ct)
 {
 	struct nlattr *nest_parms;
@@ -1113,7 +1113,7 @@ static const size_t cta_min_tcp[CTA_PROTOINFO_TCP_MAX+1] = {
 	[CTA_PROTOINFO_TCP_FLAGS_REPLY]	    = sizeof(struct nf_ct_tcp_flags)
 };
 
-static int nfattr_to_tcp(struct nlattr *cda[], struct nf_conn *ct)
+static int nlattr_to_tcp(struct nlattr *cda[], struct nf_conn *ct)
 {
 	struct nlattr *attr = cda[CTA_PROTOINFO_TCP];
 	struct nlattr *tb[CTA_PROTOINFO_TCP_MAX+1];
@@ -1125,7 +1125,7 @@ static int nfattr_to_tcp(struct nlattr *cda[], struct nf_conn *ct)
 
 	nla_parse_nested(tb, CTA_PROTOINFO_TCP_MAX, attr, NULL);
 
-	if (nfattr_bad_size(tb, CTA_PROTOINFO_TCP_MAX, cta_min_tcp))
+	if (nlattr_bad_size(tb, CTA_PROTOINFO_TCP_MAX, cta_min_tcp))
 		return -EINVAL;
 
 	if (!tb[CTA_PROTOINFO_TCP_STATE])
@@ -1387,10 +1387,10 @@ struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp4 __read_mostly =
 	.new 			= tcp_new,
 	.error			= tcp_error,
 #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
-	.to_nfattr		= tcp_to_nfattr,
-	.from_nfattr		= nfattr_to_tcp,
-	.tuple_to_nfattr	= nf_ct_port_tuple_to_nfattr,
-	.nfattr_to_tuple	= nf_ct_port_nfattr_to_tuple,
+	.to_nlattr		= tcp_to_nlattr,
+	.from_nlattr		= nlattr_to_tcp,
+	.tuple_to_nlattr	= nf_ct_port_tuple_to_nlattr,
+	.nlattr_to_tuple	= nf_ct_port_nlattr_to_tuple,
 #endif
 #ifdef CONFIG_SYSCTL
 	.ctl_table_users	= &tcp_sysctl_table_users,
@@ -1416,10 +1416,10 @@ struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp6 __read_mostly =
 	.new 			= tcp_new,
 	.error			= tcp_error,
 #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
-	.to_nfattr		= tcp_to_nfattr,
-	.from_nfattr		= nfattr_to_tcp,
-	.tuple_to_nfattr	= nf_ct_port_tuple_to_nfattr,
-	.nfattr_to_tuple	= nf_ct_port_nfattr_to_tuple,
+	.to_nlattr		= tcp_to_nlattr,
+	.from_nlattr		= nlattr_to_tcp,
+	.tuple_to_nlattr	= nf_ct_port_tuple_to_nlattr,
+	.nlattr_to_tuple	= nf_ct_port_nlattr_to_tuple,
 #endif
 #ifdef CONFIG_SYSCTL
 	.ctl_table_users	= &tcp_sysctl_table_users,
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index 2a2fd1a..751ff7e 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -203,8 +203,8 @@ struct nf_conntrack_l4proto nf_conntrack_l4proto_udp4 __read_mostly =
 	.new			= udp_new,
 	.error			= udp_error,
 #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
-	.tuple_to_nfattr	= nf_ct_port_tuple_to_nfattr,
-	.nfattr_to_tuple	= nf_ct_port_nfattr_to_tuple,
+	.tuple_to_nlattr	= nf_ct_port_tuple_to_nlattr,
+	.nlattr_to_tuple	= nf_ct_port_nlattr_to_tuple,
 #endif
 #ifdef CONFIG_SYSCTL
 	.ctl_table_users	= &udp_sysctl_table_users,
@@ -230,8 +230,8 @@ struct nf_conntrack_l4proto nf_conntrack_l4proto_udp6 __read_mostly =
 	.new			= udp_new,
 	.error			= udp_error,
 #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
-	.tuple_to_nfattr	= nf_ct_port_tuple_to_nfattr,
-	.nfattr_to_tuple	= nf_ct_port_nfattr_to_tuple,
+	.tuple_to_nlattr	= nf_ct_port_tuple_to_nlattr,
+	.nlattr_to_tuple	= nf_ct_port_nlattr_to_tuple,
 #endif
 #ifdef CONFIG_SYSCTL
 	.ctl_table_users	= &udp_sysctl_table_users,
diff --git a/net/netfilter/nf_conntrack_proto_udplite.c b/net/netfilter/nf_conntrack_proto_udplite.c
index b906b41..4209ddb 100644
--- a/net/netfilter/nf_conntrack_proto_udplite.c
+++ b/net/netfilter/nf_conntrack_proto_udplite.c
@@ -203,8 +203,8 @@ static struct nf_conntrack_l4proto nf_conntrack_l4proto_udplite4 __read_mostly =
 	.new			= udplite_new,
 	.error			= udplite_error,
 #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
-	.tuple_to_nfattr	= nf_ct_port_tuple_to_nfattr,
-	.nfattr_to_tuple	= nf_ct_port_nfattr_to_tuple,
+	.tuple_to_nlattr	= nf_ct_port_tuple_to_nlattr,
+	.nlattr_to_tuple	= nf_ct_port_nlattr_to_tuple,
 #endif
 #ifdef CONFIG_SYSCTL
 	.ctl_table_users	= &udplite_sysctl_table_users,
@@ -226,8 +226,8 @@ static struct nf_conntrack_l4proto nf_conntrack_l4proto_udplite6 __read_mostly =
 	.new			= udplite_new,
 	.error			= udplite_error,
 #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
-	.tuple_to_nfattr	= nf_ct_port_tuple_to_nfattr,
-	.nfattr_to_tuple	= nf_ct_port_nfattr_to_tuple,
+	.tuple_to_nlattr	= nf_ct_port_tuple_to_nlattr,
+	.nlattr_to_tuple	= nf_ct_port_nlattr_to_tuple,
 #endif
 #ifdef CONFIG_SYSCTL
 	.ctl_table_users	= &udplite_sysctl_table_users,
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index c7fd82f..b656648 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -769,7 +769,7 @@ nfulnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 
 	UDEBUG("entering for msg %u\n", NFNL_MSG_TYPE(nlh->nlmsg_type));
 
-	if (nfattr_bad_size(nfula, NFULA_CFG_MAX, nfula_cfg_min)) {
+	if (nlattr_bad_size(nfula, NFULA_CFG_MAX, nfula_cfg_min)) {
 		UDEBUG("bad attribute size\n");
 		return -EINVAL;
 	}
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 068e88b..1c34668 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -796,7 +796,7 @@ nfqnl_recv_verdict(struct sock *ctnl, struct sk_buff *skb,
 	struct nfqnl_queue_entry *entry;
 	int err;
 
-	if (nfattr_bad_size(nfqa, NFQA_MAX, nfqa_verdict_min)) {
+	if (nlattr_bad_size(nfqa, NFQA_MAX, nfqa_verdict_min)) {
 		QDEBUG("bad attribute size\n");
 		return -EINVAL;
 	}
@@ -876,7 +876,7 @@ nfqnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 
 	QDEBUG("entering for msg %u\n", NFNL_MSG_TYPE(nlh->nlmsg_type));
 
-	if (nfattr_bad_size(nfqa, NFQA_CFG_MAX, nfqa_cfg_min)) {
+	if (nlattr_bad_size(nfqa, NFQA_CFG_MAX, nfqa_cfg_min)) {
 		QDEBUG("bad attribute size\n");
 		return -EINVAL;
 	}
