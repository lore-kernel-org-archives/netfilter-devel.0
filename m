From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 08/19]: ctnetlink: use netlink policy
Date: Fri, 28 Sep 2007 18:30:48 +0200 (MEST)
Message-ID: <20070928163048.8394.18039.sendpatchset@localhost.localdomain>
References: <20070928163036.8394.36374.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55943 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756604AbXI1Qau (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Sep 2007 12:30:50 -0400
In-Reply-To: <20070928163036.8394.36374.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: ctnetlink: use netlink policy

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit e15d4b6820d941fdec349fba9b5800c366f1e4c1
tree b509cb5af053c35a298d581e32734be77dedcfe9
parent 697cfea5ad56bc42a46706acd713cdad23f55f27
author Patrick McHardy <kaber@trash.net> Fri, 28 Sep 2007 18:09:15 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 28 Sep 2007 18:09:15 +0200

 include/net/netfilter/nf_conntrack_l3proto.h   |    2 
 include/net/netfilter/nf_conntrack_l4proto.h   |    3 +
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |   10 +-
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |   12 +--
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |   10 +-
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |   12 +--
 net/netfilter/nf_conntrack_core.c              |   10 +-
 net/netfilter/nf_conntrack_netlink.c           |  111 +++++++++++-------------
 net/netfilter/nf_conntrack_proto_gre.c         |    1 
 net/netfilter/nf_conntrack_proto_tcp.c         |   22 +++--
 net/netfilter/nf_conntrack_proto_udp.c         |    2 
 net/netfilter/nf_conntrack_proto_udplite.c     |    2 
 12 files changed, 97 insertions(+), 100 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l3proto.h b/include/net/netfilter/nf_conntrack_l3proto.h
index f6c372d..15888fc 100644
--- a/include/net/netfilter/nf_conntrack_l3proto.h
+++ b/include/net/netfilter/nf_conntrack_l3proto.h
@@ -12,6 +12,7 @@
 #ifndef _NF_CONNTRACK_L3PROTO_H
 #define _NF_CONNTRACK_L3PROTO_H
 #include <linux/netlink.h>
+#include <net/netlink.h>
 #include <linux/seq_file.h>
 #include <net/netfilter/nf_conntrack.h>
 
@@ -68,6 +69,7 @@ struct nf_conntrack_l3proto
 
 	int (*nlattr_to_tuple)(struct nlattr *tb[],
 			       struct nf_conntrack_tuple *t);
+	const struct nla_policy *nla_policy;
 
 #ifdef CONFIG_SYSCTL
 	struct ctl_table_header	*ctl_table_header;
diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index 658dacc..fb50c21 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -10,6 +10,7 @@
 #ifndef _NF_CONNTRACK_L4PROTO_H
 #define _NF_CONNTRACK_L4PROTO_H
 #include <linux/netlink.h>
+#include <net/netlink.h>
 #include <net/netfilter/nf_conntrack.h>
 
 struct seq_file;
@@ -75,6 +76,7 @@ struct nf_conntrack_l4proto
 			       const struct nf_conntrack_tuple *t);
 	int (*nlattr_to_tuple)(struct nlattr *tb[],
 			       struct nf_conntrack_tuple *t);
+	const struct nla_policy *nla_policy;
 
 #ifdef CONFIG_SYSCTL
 	struct ctl_table_header	**ctl_table_header;
@@ -115,6 +117,7 @@ extern int nf_ct_port_tuple_to_nlattr(struct sk_buff *skb,
 				      const struct nf_conntrack_tuple *tuple);
 extern int nf_ct_port_nlattr_to_tuple(struct nlattr *tb[],
 				      struct nf_conntrack_tuple *t);
+extern const struct nla_policy nf_ct_port_nla_policy[];
 
 /* Log invalid packets */
 extern unsigned int nf_ct_log_invalid;
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 77ca556..2fcb924 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -373,9 +373,9 @@ nla_put_failure:
 	return -1;
 }
 
-static const size_t cta_min_ip[CTA_IP_MAX+1] = {
-	[CTA_IP_V4_SRC]	= sizeof(u_int32_t),
-	[CTA_IP_V4_DST]	= sizeof(u_int32_t),
+static const struct nla_policy ipv4_nla_policy[CTA_IP_MAX+1] = {
+	[CTA_IP_V4_SRC]	= { .type = NLA_U32 },
+	[CTA_IP_V4_DST]	= { .type = NLA_U32 },
 };
 
 static int ipv4_nlattr_to_tuple(struct nlattr *tb[],
@@ -384,9 +384,6 @@ static int ipv4_nlattr_to_tuple(struct nlattr *tb[],
 	if (!tb[CTA_IP_V4_SRC] || !tb[CTA_IP_V4_DST])
 		return -EINVAL;
 
-	if (nlattr_bad_size(tb, CTA_IP_MAX, cta_min_ip))
-		return -EINVAL;
-
 	t->src.u3.ip = *(__be32 *)nla_data(tb[CTA_IP_V4_SRC]);
 	t->dst.u3.ip = *(__be32 *)nla_data(tb[CTA_IP_V4_DST]);
 
@@ -413,6 +410,7 @@ struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv4 __read_mostly = {
 #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
 	.tuple_to_nlattr = ipv4_tuple_to_nlattr,
 	.nlattr_to_tuple = ipv4_nlattr_to_tuple,
+	.nla_policy	 = ipv4_nla_policy,
 #endif
 #if defined(CONFIG_SYSCTL) && defined(CONFIG_NF_CONNTRACK_PROC_COMPAT)
 	.ctl_table_path  = nf_net_ipv4_netfilter_sysctl_path,
diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
index ca7252c..11fedc7 100644
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -248,10 +248,10 @@ nla_put_failure:
 	return -1;
 }
 
-static const size_t cta_min_proto[CTA_PROTO_MAX+1] = {
-	[CTA_PROTO_ICMP_TYPE]	= sizeof(u_int8_t),
-	[CTA_PROTO_ICMP_CODE]	= sizeof(u_int8_t),
-	[CTA_PROTO_ICMP_ID]	= sizeof(u_int16_t)
+static const struct nla_policy icmp_nla_policy[CTA_PROTO_MAX+1] = {
+	[CTA_PROTO_ICMP_TYPE]	= { .type = NLA_U8 },
+	[CTA_PROTO_ICMP_CODE]	= { .type = NLA_U8 },
+	[CTA_PROTO_ICMP_ID]	= { .type = NLA_U16 },
 };
 
 static int icmp_nlattr_to_tuple(struct nlattr *tb[],
@@ -262,9 +262,6 @@ static int icmp_nlattr_to_tuple(struct nlattr *tb[],
 	    || !tb[CTA_PROTO_ICMP_ID])
 		return -EINVAL;
 
-	if (nlattr_bad_size(tb, CTA_PROTO_MAX, cta_min_proto))
-		return -EINVAL;
-
 	tuple->dst.u.icmp.type =
 			*(u_int8_t *)nla_data(tb[CTA_PROTO_ICMP_TYPE]);
 	tuple->dst.u.icmp.code =
@@ -329,6 +326,7 @@ struct nf_conntrack_l4proto nf_conntrack_l4proto_icmp __read_mostly =
 #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
 	.tuple_to_nlattr	= icmp_tuple_to_nlattr,
 	.nlattr_to_tuple	= icmp_nlattr_to_tuple,
+	.nla_policy		= icmp_nla_policy,
 #endif
 #ifdef CONFIG_SYSCTL
 	.ctl_table_header	= &icmp_sysctl_header,
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index 567fbe2..37a3db9 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -350,9 +350,9 @@ nla_put_failure:
 	return -1;
 }
 
-static const size_t cta_min_ip[CTA_IP_MAX+1] = {
-	[CTA_IP_V6_SRC]	= sizeof(u_int32_t)*4,
-	[CTA_IP_V6_DST]	= sizeof(u_int32_t)*4,
+static const struct nla_policy ipv6_nla_policy[CTA_IP_MAX+1] = {
+	[CTA_IP_V6_SRC]	= { .len = sizeof(u_int32_t)*4 },
+	[CTA_IP_V6_DST]	= { .len = sizeof(u_int32_t)*4 },
 };
 
 static int ipv6_nlattr_to_tuple(struct nlattr *tb[],
@@ -361,9 +361,6 @@ static int ipv6_nlattr_to_tuple(struct nlattr *tb[],
 	if (!tb[CTA_IP_V6_SRC] || !tb[CTA_IP_V6_DST])
 		return -EINVAL;
 
-	if (nlattr_bad_size(tb, CTA_IP_MAX, cta_min_ip))
-		return -EINVAL;
-
 	memcpy(&t->src.u3.ip6, nla_data(tb[CTA_IP_V6_SRC]),
 	       sizeof(u_int32_t) * 4);
 	memcpy(&t->dst.u3.ip6, nla_data(tb[CTA_IP_V6_DST]),
@@ -384,6 +381,7 @@ struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv6 __read_mostly = {
 #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
 	.tuple_to_nlattr	= ipv6_tuple_to_nlattr,
 	.nlattr_to_tuple	= ipv6_nlattr_to_tuple,
+	.nla_policy		= ipv6_nla_policy,
 #endif
 #ifdef CONFIG_SYSCTL
 	.ctl_table_path		= nf_net_netfilter_sysctl_path,
diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index 238ea6b..fbdc669 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -226,10 +226,10 @@ nla_put_failure:
 	return -1;
 }
 
-static const size_t cta_min_proto[CTA_PROTO_MAX+1] = {
-	[CTA_PROTO_ICMPV6_TYPE]	= sizeof(u_int8_t),
-	[CTA_PROTO_ICMPV6_CODE]	= sizeof(u_int8_t),
-	[CTA_PROTO_ICMPV6_ID]	= sizeof(u_int16_t)
+static const struct nla_policy icmpv6_nla_policy[CTA_PROTO_MAX+1] = {
+	[CTA_PROTO_ICMPV6_TYPE]	= { .type = NLA_U8 },
+	[CTA_PROTO_ICMPV6_CODE]	= { .type = NLA_U8 },
+	[CTA_PROTO_ICMPV6_ID]	= { .type = NLA_U16 },
 };
 
 static int icmpv6_nlattr_to_tuple(struct nlattr *tb[],
@@ -240,9 +240,6 @@ static int icmpv6_nlattr_to_tuple(struct nlattr *tb[],
 	    || !tb[CTA_PROTO_ICMPV6_ID])
 		return -EINVAL;
 
-	if (nlattr_bad_size(tb, CTA_PROTO_MAX, cta_min_proto))
-		return -EINVAL;
-
 	tuple->dst.u.icmp.type =
 			*(u_int8_t *)nla_data(tb[CTA_PROTO_ICMPV6_TYPE]);
 	tuple->dst.u.icmp.code =
@@ -291,6 +288,7 @@ struct nf_conntrack_l4proto nf_conntrack_l4proto_icmpv6 __read_mostly =
 #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
 	.tuple_to_nlattr	= icmpv6_tuple_to_nlattr,
 	.nlattr_to_tuple	= icmpv6_nlattr_to_tuple,
+	.nla_policy		= icmpv6_nla_policy,
 #endif
 #ifdef CONFIG_SYSCTL
 	.ctl_table_header	= &icmpv6_sysctl_header,
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 9edaaf2..f9d36ca 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -844,10 +844,11 @@ nla_put_failure:
 }
 EXPORT_SYMBOL_GPL(nf_ct_port_tuple_to_nlattr);
 
-static const size_t cta_min_proto[CTA_PROTO_MAX+1] = {
-	[CTA_PROTO_SRC_PORT]  = sizeof(u_int16_t),
-	[CTA_PROTO_DST_PORT]  = sizeof(u_int16_t)
+const struct nla_policy nf_ct_port_nla_policy[CTA_PROTO_MAX+1] = {
+	[CTA_PROTO_SRC_PORT]  = { .type = NLA_U16 },
+	[CTA_PROTO_DST_PORT]  = { .type = NLA_U16 },
 };
+EXPORT_SYMBOL_GPL(nf_ct_port_nla_policy);
 
 int nf_ct_port_nlattr_to_tuple(struct nlattr *tb[],
 			       struct nf_conntrack_tuple *t)
@@ -855,9 +856,6 @@ int nf_ct_port_nlattr_to_tuple(struct nlattr *tb[],
 	if (!tb[CTA_PROTO_SRC_PORT] || !tb[CTA_PROTO_DST_PORT])
 		return -EINVAL;
 
-	if (nlattr_bad_size(tb, CTA_PROTO_MAX, cta_min_proto))
-		return -EINVAL;
-
 	t->src.u.tcp.port = *(__be16 *)nla_data(tb[CTA_PROTO_SRC_PORT]);
 	t->dst.u.tcp.port = *(__be16 *)nla_data(tb[CTA_PROTO_DST_PORT]);
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 9f9bef2..ce35812 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -512,16 +512,20 @@ ctnetlink_parse_tuple_ip(struct nlattr *attr, struct nf_conntrack_tuple *tuple)
 
 	l3proto = nf_ct_l3proto_find_get(tuple->src.l3num);
 
-	if (likely(l3proto->nlattr_to_tuple))
-		ret = l3proto->nlattr_to_tuple(tb, tuple);
+	if (likely(l3proto->nlattr_to_tuple)) {
+		ret = nla_validate_nested(attr, CTA_IP_MAX,
+					  l3proto->nla_policy);
+		if (ret == 0)
+			ret = l3proto->nlattr_to_tuple(tb, tuple);
+	}
 
 	nf_ct_l3proto_put(l3proto);
 
 	return ret;
 }
 
-static const size_t cta_min_proto[CTA_PROTO_MAX+1] = {
-	[CTA_PROTO_NUM]	= sizeof(u_int8_t),
+static const struct nla_policy proto_nla_policy[CTA_PROTO_MAX+1] = {
+	[CTA_PROTO_NUM]	= { .type = NLA_U8 },
 };
 
 static inline int
@@ -532,10 +536,9 @@ ctnetlink_parse_tuple_proto(struct nlattr *attr,
 	struct nf_conntrack_l4proto *l4proto;
 	int ret = 0;
 
-	nla_parse_nested(tb, CTA_PROTO_MAX, attr, NULL);
-
-	if (nlattr_bad_size(tb, CTA_PROTO_MAX, cta_min_proto))
-		return -EINVAL;
+	ret = nla_parse_nested(tb, CTA_PROTO_MAX, attr, proto_nla_policy);
+	if (ret < 0)
+		return ret;
 
 	if (!tb[CTA_PROTO_NUM])
 		return -EINVAL;
@@ -543,8 +546,12 @@ ctnetlink_parse_tuple_proto(struct nlattr *attr,
 
 	l4proto = nf_ct_l4proto_find_get(tuple->src.l3num, tuple->dst.protonum);
 
-	if (likely(l4proto->nlattr_to_tuple))
-		ret = l4proto->nlattr_to_tuple(tb, tuple);
+	if (likely(l4proto->nlattr_to_tuple)) {
+		ret = nla_validate_nested(attr, CTA_PROTO_MAX,
+					  l4proto->nla_policy);
+		if (ret == 0)
+			ret = l4proto->nlattr_to_tuple(tb, tuple);
+	}
 
 	nf_ct_l4proto_put(l4proto);
 
@@ -588,9 +595,9 @@ ctnetlink_parse_tuple(struct nlattr *cda[], struct nf_conntrack_tuple *tuple,
 }
 
 #ifdef CONFIG_NF_NAT_NEEDED
-static const size_t cta_min_protonat[CTA_PROTONAT_MAX+1] = {
-	[CTA_PROTONAT_PORT_MIN]	= sizeof(u_int16_t),
-	[CTA_PROTONAT_PORT_MAX]	= sizeof(u_int16_t),
+static const struct nla_policy protonat_nla_policy[CTA_PROTONAT_MAX+1] = {
+	[CTA_PROTONAT_PORT_MIN]	= { .type = NLA_U16 },
+	[CTA_PROTONAT_PORT_MAX]	= { .type = NLA_U16 },
 };
 
 static int nfnetlink_parse_nat_proto(struct nlattr *attr,
@@ -599,11 +606,11 @@ static int nfnetlink_parse_nat_proto(struct nlattr *attr,
 {
 	struct nlattr *tb[CTA_PROTONAT_MAX+1];
 	struct nf_nat_protocol *npt;
+	int err;
 
-	nla_parse_nested(tb, CTA_PROTONAT_MAX, attr, NULL);
-
-	if (nlattr_bad_size(tb, CTA_PROTONAT_MAX, cta_min_protonat))
-		return -EINVAL;
+	err = nla_parse_nested(tb, CTA_PROTONAT_MAX, attr, protonat_nla_policy);
+	if (err < 0)
+		return err;
 
 	npt = nf_nat_proto_find_get(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum);
 
@@ -621,9 +628,9 @@ static int nfnetlink_parse_nat_proto(struct nlattr *attr,
 	return 0;
 }
 
-static const size_t cta_min_nat[CTA_NAT_MAX+1] = {
-	[CTA_NAT_MINIP]		= sizeof(u_int32_t),
-	[CTA_NAT_MAXIP]		= sizeof(u_int32_t),
+static const struct nla_policy nat_nla_policy[CTA_NAT_MAX+1] = {
+	[CTA_NAT_MINIP]		= { .type = NLA_U32 },
+	[CTA_NAT_MAXIP]		= { .type = NLA_U32 },
 };
 
 static inline int
@@ -635,10 +642,9 @@ nfnetlink_parse_nat(struct nlattr *nat,
 
 	memset(range, 0, sizeof(*range));
 
-	nla_parse_nested(tb, CTA_NAT_MAX, nat, NULL);
-
-	if (nlattr_bad_size(tb, CTA_NAT_MAX, cta_min_nat))
-		return -EINVAL;
+	err = nla_parse_nested(tb, CTA_NAT_MAX, nat, nat_nla_policy);
+	if (err < 0)
+		return err;
 
 	if (tb[CTA_NAT_MINIP])
 		range->min_ip = *(__be32 *)nla_data(tb[CTA_NAT_MINIP]);
@@ -677,12 +683,12 @@ ctnetlink_parse_help(struct nlattr *attr, char **helper_name)
 	return 0;
 }
 
-static const size_t cta_min[CTA_MAX+1] = {
-	[CTA_STATUS] 		= sizeof(u_int32_t),
-	[CTA_TIMEOUT] 		= sizeof(u_int32_t),
-	[CTA_MARK]		= sizeof(u_int32_t),
-	[CTA_USE]		= sizeof(u_int32_t),
-	[CTA_ID]		= sizeof(u_int32_t)
+static const struct nla_policy ct_nla_policy[CTA_MAX+1] = {
+	[CTA_STATUS] 		= { .type = NLA_U32 },
+	[CTA_TIMEOUT] 		= { .type = NLA_U32 },
+	[CTA_MARK]		= { .type = NLA_U32 },
+	[CTA_USE]		= { .type = NLA_U32 },
+	[CTA_ID]		= { .type = NLA_U32 },
 };
 
 static int
@@ -696,9 +702,6 @@ ctnetlink_del_conntrack(struct sock *ctnl, struct sk_buff *skb,
 	u_int8_t u3 = nfmsg->nfgen_family;
 	int err = 0;
 
-	if (nlattr_bad_size(cda, CTA_MAX, cta_min))
-		return -EINVAL;
-
 	if (cda[CTA_TUPLE_ORIG])
 		err = ctnetlink_parse_tuple(cda, &tuple, CTA_TUPLE_ORIG, u3);
 	else if (cda[CTA_TUPLE_REPLY])
@@ -754,9 +757,6 @@ ctnetlink_get_conntrack(struct sock *ctnl, struct sk_buff *skb,
 					  ctnetlink_done);
 	}
 
-	if (nlattr_bad_size(cda, CTA_MAX, cta_min))
-		return -EINVAL;
-
 	if (cda[CTA_TUPLE_ORIG])
 		err = ctnetlink_parse_tuple(cda, &tuple, CTA_TUPLE_ORIG, u3);
 	else if (cda[CTA_TUPLE_REPLY])
@@ -1045,9 +1045,6 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
 	u_int8_t u3 = nfmsg->nfgen_family;
 	int err = 0;
 
-	if (nlattr_bad_size(cda, CTA_MAX, cta_min))
-		return -EINVAL;
-
 	if (cda[CTA_TUPLE_ORIG]) {
 		err = ctnetlink_parse_tuple(cda, &otuple, CTA_TUPLE_ORIG, u3);
 		if (err < 0)
@@ -1313,9 +1310,9 @@ out:
 	return skb->len;
 }
 
-static const size_t cta_min_exp[CTA_EXPECT_MAX+1] = {
-	[CTA_EXPECT_TIMEOUT]	= sizeof(u_int32_t),
-	[CTA_EXPECT_ID]		= sizeof(u_int32_t)
+static const struct nla_policy exp_nla_policy[CTA_EXPECT_MAX+1] = {
+	[CTA_EXPECT_TIMEOUT]	= { .type = NLA_U32 },
+	[CTA_EXPECT_ID]		= { .type = NLA_U32 },
 };
 
 static int
@@ -1329,9 +1326,6 @@ ctnetlink_get_expect(struct sock *ctnl, struct sk_buff *skb,
 	u_int8_t u3 = nfmsg->nfgen_family;
 	int err = 0;
 
-	if (nlattr_bad_size(cda, CTA_EXPECT_MAX, cta_min_exp))
-		return -EINVAL;
-
 	if (nlh->nlmsg_flags & NLM_F_DUMP) {
 		return netlink_dump_start(ctnl, skb, nlh,
 					  ctnetlink_exp_dump_table,
@@ -1393,9 +1387,6 @@ ctnetlink_del_expect(struct sock *ctnl, struct sk_buff *skb,
 	unsigned int i;
 	int err;
 
-	if (nlattr_bad_size(cda, CTA_EXPECT_MAX, cta_min_exp))
-		return -EINVAL;
-
 	if (cda[CTA_EXPECT_TUPLE]) {
 		/* delete a single expect by tuple */
 		err = ctnetlink_parse_tuple(cda, &tuple, CTA_EXPECT_TUPLE, u3);
@@ -1534,9 +1525,6 @@ ctnetlink_new_expect(struct sock *ctnl, struct sk_buff *skb,
 	u_int8_t u3 = nfmsg->nfgen_family;
 	int err = 0;
 
-	if (nlattr_bad_size(cda, CTA_EXPECT_MAX, cta_min_exp))
-		return -EINVAL;
-
 	if (!cda[CTA_EXPECT_TUPLE]
 	    || !cda[CTA_EXPECT_MASK]
 	    || !cda[CTA_EXPECT_MASTER])
@@ -1577,22 +1565,29 @@ static struct notifier_block ctnl_notifier_exp = {
 
 static const struct nfnl_callback ctnl_cb[IPCTNL_MSG_MAX] = {
 	[IPCTNL_MSG_CT_NEW]		= { .call = ctnetlink_new_conntrack,
-					    .attr_count = CTA_MAX, },
+					    .attr_count = CTA_MAX,
+					    .policy = ct_nla_policy },
 	[IPCTNL_MSG_CT_GET] 		= { .call = ctnetlink_get_conntrack,
-					    .attr_count = CTA_MAX, },
+					    .attr_count = CTA_MAX,
+					    .policy = ct_nla_policy },
 	[IPCTNL_MSG_CT_DELETE]  	= { .call = ctnetlink_del_conntrack,
-					    .attr_count = CTA_MAX, },
+					    .attr_count = CTA_MAX,
+					    .policy = ct_nla_policy },
 	[IPCTNL_MSG_CT_GET_CTRZERO] 	= { .call = ctnetlink_get_conntrack,
-					    .attr_count = CTA_MAX, },
+					    .attr_count = CTA_MAX,
+					    .policy = ct_nla_policy },
 };
 
 static const struct nfnl_callback ctnl_exp_cb[IPCTNL_MSG_EXP_MAX] = {
 	[IPCTNL_MSG_EXP_GET]		= { .call = ctnetlink_get_expect,
-					    .attr_count = CTA_EXPECT_MAX, },
+					    .attr_count = CTA_EXPECT_MAX,
+					    .policy = exp_nla_policy },
 	[IPCTNL_MSG_EXP_NEW]		= { .call = ctnetlink_new_expect,
-					    .attr_count = CTA_EXPECT_MAX, },
+					    .attr_count = CTA_EXPECT_MAX,
+					    .policy = exp_nla_policy },
 	[IPCTNL_MSG_EXP_DELETE]		= { .call = ctnetlink_del_expect,
-					    .attr_count = CTA_EXPECT_MAX, },
+					    .attr_count = CTA_EXPECT_MAX,
+					    .policy = exp_nla_policy },
 };
 
 static const struct nfnetlink_subsystem ctnl_subsys = {
diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
index ff8d03b..4a185f6 100644
--- a/net/netfilter/nf_conntrack_proto_gre.c
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -276,6 +276,7 @@ static struct nf_conntrack_l4proto nf_conntrack_l4proto_gre4 __read_mostly = {
 #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
 	.tuple_to_nlattr = nf_ct_port_tuple_to_nlattr,
 	.nlattr_to_tuple = nf_ct_port_nlattr_to_tuple,
+	.nla_policy	 = nf_ct_port_nla_policy,
 #endif
 };
 
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 84f47bc..df718e7 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1105,28 +1105,28 @@ nla_put_failure:
 	return -1;
 }
 
-static const size_t cta_min_tcp[CTA_PROTOINFO_TCP_MAX+1] = {
-	[CTA_PROTOINFO_TCP_STATE]	    = sizeof(u_int8_t),
-	[CTA_PROTOINFO_TCP_WSCALE_ORIGINAL] = sizeof(u_int8_t),
-	[CTA_PROTOINFO_TCP_WSCALE_REPLY]    = sizeof(u_int8_t),
-	[CTA_PROTOINFO_TCP_FLAGS_ORIGINAL]  = sizeof(struct nf_ct_tcp_flags),
-	[CTA_PROTOINFO_TCP_FLAGS_REPLY]	    = sizeof(struct nf_ct_tcp_flags)
+static const struct nla_policy tcp_nla_policy[CTA_PROTOINFO_TCP_MAX+1] = {
+	[CTA_PROTOINFO_TCP_STATE]	    = { .type = NLA_U8 },
+	[CTA_PROTOINFO_TCP_WSCALE_ORIGINAL] = { .type = NLA_U8 },
+	[CTA_PROTOINFO_TCP_WSCALE_REPLY]    = { .type = NLA_U8 },
+	[CTA_PROTOINFO_TCP_FLAGS_ORIGINAL]  = { .len = sizeof(struct nf_ct_tcp_flags) },
+	[CTA_PROTOINFO_TCP_FLAGS_REPLY]	    = { .len =  sizeof(struct nf_ct_tcp_flags) },
 };
 
 static int nlattr_to_tcp(struct nlattr *cda[], struct nf_conn *ct)
 {
 	struct nlattr *attr = cda[CTA_PROTOINFO_TCP];
 	struct nlattr *tb[CTA_PROTOINFO_TCP_MAX+1];
+	int err;
 
 	/* updates could not contain anything about the private
 	 * protocol info, in that case skip the parsing */
 	if (!attr)
 		return 0;
 
-	nla_parse_nested(tb, CTA_PROTOINFO_TCP_MAX, attr, NULL);
-
-	if (nlattr_bad_size(tb, CTA_PROTOINFO_TCP_MAX, cta_min_tcp))
-		return -EINVAL;
+	err = nla_parse_nested(tb, CTA_PROTOINFO_TCP_MAX, attr, tcp_nla_policy);
+	if (err < 0)
+		return err;
 
 	if (!tb[CTA_PROTOINFO_TCP_STATE])
 		return -EINVAL;
@@ -1391,6 +1391,7 @@ struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp4 __read_mostly =
 	.from_nlattr		= nlattr_to_tcp,
 	.tuple_to_nlattr	= nf_ct_port_tuple_to_nlattr,
 	.nlattr_to_tuple	= nf_ct_port_nlattr_to_tuple,
+	.nla_policy		= nf_ct_port_nla_policy,
 #endif
 #ifdef CONFIG_SYSCTL
 	.ctl_table_users	= &tcp_sysctl_table_users,
@@ -1420,6 +1421,7 @@ struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp6 __read_mostly =
 	.from_nlattr		= nlattr_to_tcp,
 	.tuple_to_nlattr	= nf_ct_port_tuple_to_nlattr,
 	.nlattr_to_tuple	= nf_ct_port_nlattr_to_tuple,
+	.nla_policy		= nf_ct_port_nla_policy,
 #endif
 #ifdef CONFIG_SYSCTL
 	.ctl_table_users	= &tcp_sysctl_table_users,
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index 751ff7e..ba80e1a 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -205,6 +205,7 @@ struct nf_conntrack_l4proto nf_conntrack_l4proto_udp4 __read_mostly =
 #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
 	.tuple_to_nlattr	= nf_ct_port_tuple_to_nlattr,
 	.nlattr_to_tuple	= nf_ct_port_nlattr_to_tuple,
+	.nla_policy		= nf_ct_port_nla_policy,
 #endif
 #ifdef CONFIG_SYSCTL
 	.ctl_table_users	= &udp_sysctl_table_users,
@@ -232,6 +233,7 @@ struct nf_conntrack_l4proto nf_conntrack_l4proto_udp6 __read_mostly =
 #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
 	.tuple_to_nlattr	= nf_ct_port_tuple_to_nlattr,
 	.nlattr_to_tuple	= nf_ct_port_nlattr_to_tuple,
+	.nla_policy		= nf_ct_port_nla_policy,
 #endif
 #ifdef CONFIG_SYSCTL
 	.ctl_table_users	= &udp_sysctl_table_users,
diff --git a/net/netfilter/nf_conntrack_proto_udplite.c b/net/netfilter/nf_conntrack_proto_udplite.c
index 4209ddb..b8981dd 100644
--- a/net/netfilter/nf_conntrack_proto_udplite.c
+++ b/net/netfilter/nf_conntrack_proto_udplite.c
@@ -205,6 +205,7 @@ static struct nf_conntrack_l4proto nf_conntrack_l4proto_udplite4 __read_mostly =
 #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
 	.tuple_to_nlattr	= nf_ct_port_tuple_to_nlattr,
 	.nlattr_to_tuple	= nf_ct_port_nlattr_to_tuple,
+	.nla_policy		= nf_ct_port_nla_policy,
 #endif
 #ifdef CONFIG_SYSCTL
 	.ctl_table_users	= &udplite_sysctl_table_users,
@@ -228,6 +229,7 @@ static struct nf_conntrack_l4proto nf_conntrack_l4proto_udplite6 __read_mostly =
 #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
 	.tuple_to_nlattr	= nf_ct_port_tuple_to_nlattr,
 	.nlattr_to_tuple	= nf_ct_port_nlattr_to_tuple,
+	.nla_policy		= nf_ct_port_nla_policy,
 #endif
 #ifdef CONFIG_SYSCTL
 	.ctl_table_users	= &udplite_sysctl_table_users,
