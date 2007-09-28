From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/19]: nfnetlink: convert to generic netlink attribute functions
Date: Fri, 28 Sep 2007 18:30:39 +0200 (MEST)
Message-ID: <20070928163039.8394.40440.sendpatchset@localhost.localdomain>
References: <20070928163036.8394.36374.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55923 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755870AbXI1Qam (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Sep 2007 12:30:42 -0400
In-Reply-To: <20070928163036.8394.36374.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: nfnetlink: convert to generic netlink attribute functions

Get rid of the duplicated rtnetlink macros and use the generic netlink
attribute functions. The old duplicated stuff is moved to a new header
file that exists just for userspace.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 7264cb1fe6541b376129c512f2a28a198e52a117
tree 5387bd3f4ea2e24fddf826eaea2f44ab5deb356e
parent 03d16f1357128ee213012f18911a3cdabc353c13
author Patrick McHardy <kaber@trash.net> Fri, 28 Sep 2007 18:09:02 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 28 Sep 2007 18:09:02 +0200

 include/linux/netfilter/Kbuild                 |    1 
 include/linux/netfilter/nfnetlink.h            |   78 -----
 include/linux/netfilter/nfnetlink_compat.h     |   61 ++++
 include/net/netfilter/nf_conntrack_l3proto.h   |    5 
 include/net/netfilter/nf_conntrack_l4proto.h   |   10 -
 include/net/netfilter/nf_nat_protocol.h        |    4 
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |   20 +
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |   30 +-
 net/ipv4/netfilter/nf_nat_core.c               |   16 -
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |   20 +
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |   30 +-
 net/netfilter/nf_conntrack_core.c              |   21 +
 net/netfilter/nf_conntrack_netlink.c           |  393 +++++++++++++-----------
 net/netfilter/nf_conntrack_proto_tcp.c         |   63 ++--
 net/netfilter/nfnetlink.c                      |   39 --
 net/netfilter/nfnetlink_log.c                  |  155 +++++----
 net/netfilter/nfnetlink_queue.c                |  113 +++----
 17 files changed, 527 insertions(+), 532 deletions(-)

diff --git a/include/linux/netfilter/Kbuild b/include/linux/netfilter/Kbuild
index ab57cb7..f2eaea2 100644
--- a/include/linux/netfilter/Kbuild
+++ b/include/linux/netfilter/Kbuild
@@ -40,5 +40,6 @@ unifdef-y += nf_conntrack_common.h
 unifdef-y += nf_conntrack_ftp.h
 unifdef-y += nf_conntrack_tcp.h
 unifdef-y += nfnetlink.h
+unifdef-y += nfnetlink_compat.h
 unifdef-y += x_tables.h
 unifdef-y += xt_physdev.h
diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/netfilter/nfnetlink.h
index e32418b..4185070 100644
--- a/include/linux/netfilter/nfnetlink.h
+++ b/include/linux/netfilter/nfnetlink.h
@@ -1,16 +1,7 @@
 #ifndef _NFNETLINK_H
 #define _NFNETLINK_H
 #include <linux/types.h>
-
-#ifndef __KERNEL__
-/* nfnetlink groups: Up to 32 maximum - backwards compatibility for userspace */
-#define NF_NETLINK_CONNTRACK_NEW 		0x00000001
-#define NF_NETLINK_CONNTRACK_UPDATE		0x00000002
-#define NF_NETLINK_CONNTRACK_DESTROY		0x00000004
-#define NF_NETLINK_CONNTRACK_EXP_NEW		0x00000008
-#define NF_NETLINK_CONNTRACK_EXP_UPDATE		0x00000010
-#define NF_NETLINK_CONNTRACK_EXP_DESTROY	0x00000020
-#endif
+#include <linux/netfilter/nfnetlink_compat.h>
 
 enum nfnetlink_groups {
 	NFNLGRP_NONE,
@@ -31,48 +22,6 @@ enum nfnetlink_groups {
 };
 #define NFNLGRP_MAX	(__NFNLGRP_MAX - 1)
 
-/* Generic structure for encapsulation optional netfilter information.
- * It is reminiscent of sockaddr, but with sa_family replaced
- * with attribute type. 
- * ! This should someday be put somewhere generic as now rtnetlink and
- * ! nfnetlink use the same attributes methods. - J. Schulist.
- */
-
-struct nfattr
-{
-	u_int16_t nfa_len;
-	u_int16_t nfa_type;	/* we use 15 bits for the type, and the highest
-				 * bit to indicate whether the payload is nested */
-};
-
-/* FIXME: Apart from NFNL_NFA_NESTED shamelessly copy and pasted from
- * rtnetlink.h, it's time to put this in a generic file */
-
-#define NFNL_NFA_NEST	0x8000
-#define NFA_TYPE(attr) 	((attr)->nfa_type & 0x7fff)
-
-#define NFA_ALIGNTO     4
-#define NFA_ALIGN(len)	(((len) + NFA_ALIGNTO - 1) & ~(NFA_ALIGNTO - 1))
-#define NFA_OK(nfa,len)	((len) > 0 && (nfa)->nfa_len >= sizeof(struct nfattr) \
-	&& (nfa)->nfa_len <= (len))
-#define NFA_NEXT(nfa,attrlen)	((attrlen) -= NFA_ALIGN((nfa)->nfa_len), \
-	(struct nfattr *)(((char *)(nfa)) + NFA_ALIGN((nfa)->nfa_len)))
-#define NFA_LENGTH(len)	(NFA_ALIGN(sizeof(struct nfattr)) + (len))
-#define NFA_SPACE(len)	NFA_ALIGN(NFA_LENGTH(len))
-#define NFA_DATA(nfa)   ((void *)(((char *)(nfa)) + NFA_LENGTH(0)))
-#define NFA_PAYLOAD(nfa) ((int)((nfa)->nfa_len) - NFA_LENGTH(0))
-#define NFA_NEST(skb, type) \
-({	struct nfattr *__start = (struct nfattr *)skb_tail_pointer(skb); \
-	NFA_PUT(skb, (NFNL_NFA_NEST | type), 0, NULL); \
-	__start;  })
-#define NFA_NEST_END(skb, start) \
-({      (start)->nfa_len = skb_tail_pointer(skb) - (unsigned char *)(start); \
-        (skb)->len; })
-#define NFA_NEST_CANCEL(skb, start) \
-({      if (start) \
-                skb_trim(skb, (unsigned char *) (start) - (skb)->data); \
-        -1; })
-
 /* General form of address family dependent message.
  */
 struct nfgenmsg {
@@ -83,10 +32,6 @@ struct nfgenmsg {
 
 #define NFNETLINK_V0	0
 
-#define NFM_NFA(n)      ((struct nfattr *)(((char *)(n)) \
-        + NLMSG_ALIGN(sizeof(struct nfgenmsg))))
-#define NFM_PAYLOAD(n)  NLMSG_PAYLOAD(n, sizeof(struct nfgenmsg))
-
 /* netfilter netlink message types are split in two pieces:
  * 8 bit subsystem, 8bit operation.
  */
@@ -107,12 +52,13 @@ struct nfgenmsg {
 
 #include <linux/netlink.h>
 #include <linux/capability.h>
+#include <net/netlink.h>
 
 struct nfnl_callback
 {
 	int (*call)(struct sock *nl, struct sk_buff *skb, 
-		struct nlmsghdr *nlh, struct nfattr *cda[]);
-	u_int16_t attr_count;	/* number of nfattr's */
+		struct nlmsghdr *nlh, struct nlattr *cda[]);
+	u_int16_t attr_count;	/* number of nlattr's */
 };
 
 struct nfnetlink_subsystem
@@ -123,27 +69,15 @@ struct nfnetlink_subsystem
 	const struct nfnl_callback *cb;	/* callback for individual types */
 };
 
-extern void __nfa_fill(struct sk_buff *skb, int attrtype,
-        int attrlen, const void *data);
-#define NFA_PUT(skb, attrtype, attrlen, data) \
-({ if (skb_tailroom(skb) < (int)NFA_SPACE(attrlen)) goto nfattr_failure; \
-   __nfa_fill(skb, attrtype, attrlen, data); })
-
 extern int nfnetlink_subsys_register(const struct nfnetlink_subsystem *n);
 extern int nfnetlink_subsys_unregister(const struct nfnetlink_subsystem *n);
 
-extern void nfattr_parse(struct nfattr *tb[], int maxattr, 
-			struct nfattr *nfa, int len);
-
-#define nfattr_parse_nested(tb, max, nfa) \
-	nfattr_parse((tb), (max), NFA_DATA((nfa)), NFA_PAYLOAD((nfa)))
-
 #define nfattr_bad_size(tb, max, cta_min)				\
 ({	int __i, __res = 0;						\
- 	for (__i=0; __i<max; __i++) {					\
+ 	for (__i=1; __i <= max; __i++) {					\
  		if (!cta_min[__i])					\
  			continue;					\
- 		if (tb[__i] && NFA_PAYLOAD(tb[__i]) < cta_min[__i]){	\
+ 		if (tb[__i] && nla_len(tb[__i]) < cta_min[__i]){	\
  			__res = 1;					\
  			break;						\
  		}							\
diff --git a/include/linux/netfilter/nfnetlink_compat.h b/include/linux/netfilter/nfnetlink_compat.h
new file mode 100644
index 0000000..02a42d8
--- /dev/null
+++ b/include/linux/netfilter/nfnetlink_compat.h
@@ -0,0 +1,61 @@
+#ifndef _NFNETLINK_COMPAT_H
+#define _NFNETLINK_COMPAT_H
+#ifndef __KERNEL
+/* Old nfnetlink macros for userspace */
+
+/* nfnetlink groups: Up to 32 maximum */
+#define NF_NETLINK_CONNTRACK_NEW 		0x00000001
+#define NF_NETLINK_CONNTRACK_UPDATE		0x00000002
+#define NF_NETLINK_CONNTRACK_DESTROY		0x00000004
+#define NF_NETLINK_CONNTRACK_EXP_NEW		0x00000008
+#define NF_NETLINK_CONNTRACK_EXP_UPDATE		0x00000010
+#define NF_NETLINK_CONNTRACK_EXP_DESTROY	0x00000020
+
+/* Generic structure for encapsulation optional netfilter information.
+ * It is reminiscent of sockaddr, but with sa_family replaced
+ * with attribute type.
+ * ! This should someday be put somewhere generic as now rtnetlink and
+ * ! nfnetlink use the same attributes methods. - J. Schulist.
+ */
+
+struct nfattr
+{
+	u_int16_t nfa_len;
+	u_int16_t nfa_type;	/* we use 15 bits for the type, and the highest
+				 * bit to indicate whether the payload is nested */
+};
+
+/* FIXME: Apart from NFNL_NFA_NESTED shamelessly copy and pasted from
+ * rtnetlink.h, it's time to put this in a generic file */
+
+#define NFNL_NFA_NEST	0x8000
+#define NFA_TYPE(attr) 	((attr)->nfa_type & 0x7fff)
+
+#define NFA_ALIGNTO     4
+#define NFA_ALIGN(len)	(((len) + NFA_ALIGNTO - 1) & ~(NFA_ALIGNTO - 1))
+#define NFA_OK(nfa,len)	((len) > 0 && (nfa)->nfa_len >= sizeof(struct nfattr) \
+	&& (nfa)->nfa_len <= (len))
+#define NFA_NEXT(nfa,attrlen)	((attrlen) -= NFA_ALIGN((nfa)->nfa_len), \
+	(struct nfattr *)(((char *)(nfa)) + NFA_ALIGN((nfa)->nfa_len)))
+#define NFA_LENGTH(len)	(NFA_ALIGN(sizeof(struct nfattr)) + (len))
+#define NFA_SPACE(len)	NFA_ALIGN(NFA_LENGTH(len))
+#define NFA_DATA(nfa)   ((void *)(((char *)(nfa)) + NFA_LENGTH(0)))
+#define NFA_PAYLOAD(nfa) ((int)((nfa)->nfa_len) - NFA_LENGTH(0))
+#define NFA_NEST(skb, type) \
+({	struct nfattr *__start = (struct nfattr *)skb_tail_pointer(skb); \
+	NFA_PUT(skb, (NFNL_NFA_NEST | type), 0, NULL); \
+	__start;  })
+#define NFA_NEST_END(skb, start) \
+({      (start)->nfa_len = skb_tail_pointer(skb) - (unsigned char *)(start); \
+        (skb)->len; })
+#define NFA_NEST_CANCEL(skb, start) \
+({      if (start) \
+                skb_trim(skb, (unsigned char *) (start) - (skb)->data); \
+        -1; })
+
+#define NFM_NFA(n)      ((struct nfattr *)(((char *)(n)) \
+        + NLMSG_ALIGN(sizeof(struct nfgenmsg))))
+#define NFM_PAYLOAD(n)  NLMSG_PAYLOAD(n, sizeof(struct nfgenmsg))
+
+#endif /* ! __KERNEL__ */
+#endif /* _NFNETLINK_COMPAT_H */
diff --git a/include/net/netfilter/nf_conntrack_l3proto.h b/include/net/netfilter/nf_conntrack_l3proto.h
index 3c58a2c..c02402d 100644
--- a/include/net/netfilter/nf_conntrack_l3proto.h
+++ b/include/net/netfilter/nf_conntrack_l3proto.h
@@ -11,11 +11,10 @@
 
 #ifndef _NF_CONNTRACK_L3PROTO_H
 #define _NF_CONNTRACK_L3PROTO_H
+#include <linux/netlink.h>
 #include <linux/seq_file.h>
 #include <net/netfilter/nf_conntrack.h>
 
-struct nfattr;
-
 struct nf_conntrack_l3proto
 {
 	/* L3 Protocol Family number. ex) PF_INET */
@@ -67,7 +66,7 @@ struct nf_conntrack_l3proto
 	int (*tuple_to_nfattr)(struct sk_buff *skb,
 			       const struct nf_conntrack_tuple *t);
 
-	int (*nfattr_to_tuple)(struct nfattr *tb[],
+	int (*nfattr_to_tuple)(struct nlattr *tb[],
 			       struct nf_conntrack_tuple *t);
 
 #ifdef CONFIG_SYSCTL
diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index f46cb93..a43c4e4 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -9,10 +9,10 @@
 
 #ifndef _NF_CONNTRACK_L4PROTO_H
 #define _NF_CONNTRACK_L4PROTO_H
+#include <linux/netlink.h>
 #include <net/netfilter/nf_conntrack.h>
 
 struct seq_file;
-struct nfattr;
 
 struct nf_conntrack_l4proto
 {
@@ -65,15 +65,15 @@ struct nf_conntrack_l4proto
 		     int pf, unsigned int hooknum);
 
 	/* convert protoinfo to nfnetink attributes */
-	int (*to_nfattr)(struct sk_buff *skb, struct nfattr *nfa,
+	int (*to_nfattr)(struct sk_buff *skb, struct nlattr *nla,
 			 const struct nf_conn *ct);
 
 	/* convert nfnetlink attributes to protoinfo */
-	int (*from_nfattr)(struct nfattr *tb[], struct nf_conn *ct);
+	int (*from_nfattr)(struct nlattr *tb[], struct nf_conn *ct);
 
 	int (*tuple_to_nfattr)(struct sk_buff *skb,
 			       const struct nf_conntrack_tuple *t);
-	int (*nfattr_to_tuple)(struct nfattr *tb[],
+	int (*nfattr_to_tuple)(struct nlattr *tb[],
 			       struct nf_conntrack_tuple *t);
 
 #ifdef CONFIG_SYSCTL
@@ -113,7 +113,7 @@ extern void nf_conntrack_l4proto_unregister(struct nf_conntrack_l4proto *proto);
 /* Generic netlink helpers */
 extern int nf_ct_port_tuple_to_nfattr(struct sk_buff *skb,
 				      const struct nf_conntrack_tuple *tuple);
-extern int nf_ct_port_nfattr_to_tuple(struct nfattr *tb[],
+extern int nf_ct_port_nfattr_to_tuple(struct nlattr *tb[],
 				      struct nf_conntrack_tuple *t);
 
 /* Log invalid packets */
diff --git a/include/net/netfilter/nf_nat_protocol.h b/include/net/netfilter/nf_nat_protocol.h
index a9ec5ef..90a82de 100644
--- a/include/net/netfilter/nf_nat_protocol.h
+++ b/include/net/netfilter/nf_nat_protocol.h
@@ -41,7 +41,7 @@ struct nf_nat_protocol
 	int (*range_to_nfattr)(struct sk_buff *skb,
 			       const struct nf_nat_range *range);
 
-	int (*nfattr_to_range)(struct nfattr *tb[],
+	int (*nfattr_to_range)(struct nlattr *tb[],
 			       struct nf_nat_range *range);
 };
 
@@ -64,7 +64,7 @@ extern struct nf_nat_protocol *find_nat_proto(u_int16_t protonum);
 
 extern int nf_nat_port_range_to_nfattr(struct sk_buff *skb,
 				       const struct nf_nat_range *range);
-extern int nf_nat_port_nfattr_to_range(struct nfattr *tb[],
+extern int nf_nat_port_nfattr_to_range(struct nlattr *tb[],
 				       struct nf_nat_range *range);
 
 #endif /*_NF_NAT_PROTO_H*/
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index f813e02..f8771e0 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -363,32 +363,32 @@ getorigdst(struct sock *sk, int optval, void __user *user, int *len)
 static int ipv4_tuple_to_nfattr(struct sk_buff *skb,
 				const struct nf_conntrack_tuple *tuple)
 {
-	NFA_PUT(skb, CTA_IP_V4_SRC, sizeof(u_int32_t),
+	NLA_PUT(skb, CTA_IP_V4_SRC, sizeof(u_int32_t),
 		&tuple->src.u3.ip);
-	NFA_PUT(skb, CTA_IP_V4_DST, sizeof(u_int32_t),
+	NLA_PUT(skb, CTA_IP_V4_DST, sizeof(u_int32_t),
 		&tuple->dst.u3.ip);
 	return 0;
 
-nfattr_failure:
+nla_put_failure:
 	return -1;
 }
 
-static const size_t cta_min_ip[CTA_IP_MAX] = {
-	[CTA_IP_V4_SRC-1]       = sizeof(u_int32_t),
-	[CTA_IP_V4_DST-1]       = sizeof(u_int32_t),
+static const size_t cta_min_ip[CTA_IP_MAX+1] = {
+	[CTA_IP_V4_SRC]	= sizeof(u_int32_t),
+	[CTA_IP_V4_DST]	= sizeof(u_int32_t),
 };
 
-static int ipv4_nfattr_to_tuple(struct nfattr *tb[],
+static int ipv4_nfattr_to_tuple(struct nlattr *tb[],
 				struct nf_conntrack_tuple *t)
 {
-	if (!tb[CTA_IP_V4_SRC-1] || !tb[CTA_IP_V4_DST-1])
+	if (!tb[CTA_IP_V4_SRC] || !tb[CTA_IP_V4_DST])
 		return -EINVAL;
 
 	if (nfattr_bad_size(tb, CTA_IP_MAX, cta_min_ip))
 		return -EINVAL;
 
-	t->src.u3.ip = *(__be32 *)NFA_DATA(tb[CTA_IP_V4_SRC-1]);
-	t->dst.u3.ip = *(__be32 *)NFA_DATA(tb[CTA_IP_V4_DST-1]);
+	t->src.u3.ip = *(__be32 *)nla_data(tb[CTA_IP_V4_SRC]);
+	t->dst.u3.ip = *(__be32 *)nla_data(tb[CTA_IP_V4_DST]);
 
 	return 0;
 }
diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
index 6593fd2..714332b 100644
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -235,42 +235,42 @@ icmp_error(struct sk_buff *skb, unsigned int dataoff,
 static int icmp_tuple_to_nfattr(struct sk_buff *skb,
 				const struct nf_conntrack_tuple *t)
 {
-	NFA_PUT(skb, CTA_PROTO_ICMP_ID, sizeof(u_int16_t),
+	NLA_PUT(skb, CTA_PROTO_ICMP_ID, sizeof(u_int16_t),
 		&t->src.u.icmp.id);
-	NFA_PUT(skb, CTA_PROTO_ICMP_TYPE, sizeof(u_int8_t),
+	NLA_PUT(skb, CTA_PROTO_ICMP_TYPE, sizeof(u_int8_t),
 		&t->dst.u.icmp.type);
-	NFA_PUT(skb, CTA_PROTO_ICMP_CODE, sizeof(u_int8_t),
+	NLA_PUT(skb, CTA_PROTO_ICMP_CODE, sizeof(u_int8_t),
 		&t->dst.u.icmp.code);
 
 	return 0;
 
-nfattr_failure:
+nla_put_failure:
 	return -1;
 }
 
-static const size_t cta_min_proto[CTA_PROTO_MAX] = {
-	[CTA_PROTO_ICMP_TYPE-1] = sizeof(u_int8_t),
-	[CTA_PROTO_ICMP_CODE-1] = sizeof(u_int8_t),
-	[CTA_PROTO_ICMP_ID-1]   = sizeof(u_int16_t)
+static const size_t cta_min_proto[CTA_PROTO_MAX+1] = {
+	[CTA_PROTO_ICMP_TYPE]	= sizeof(u_int8_t),
+	[CTA_PROTO_ICMP_CODE]	= sizeof(u_int8_t),
+	[CTA_PROTO_ICMP_ID]	= sizeof(u_int16_t)
 };
 
-static int icmp_nfattr_to_tuple(struct nfattr *tb[],
+static int icmp_nfattr_to_tuple(struct nlattr *tb[],
 				struct nf_conntrack_tuple *tuple)
 {
-	if (!tb[CTA_PROTO_ICMP_TYPE-1]
-	    || !tb[CTA_PROTO_ICMP_CODE-1]
-	    || !tb[CTA_PROTO_ICMP_ID-1])
+	if (!tb[CTA_PROTO_ICMP_TYPE]
+	    || !tb[CTA_PROTO_ICMP_CODE]
+	    || !tb[CTA_PROTO_ICMP_ID])
 		return -EINVAL;
 
 	if (nfattr_bad_size(tb, CTA_PROTO_MAX, cta_min_proto))
 		return -EINVAL;
 
 	tuple->dst.u.icmp.type =
-			*(u_int8_t *)NFA_DATA(tb[CTA_PROTO_ICMP_TYPE-1]);
+			*(u_int8_t *)nla_data(tb[CTA_PROTO_ICMP_TYPE]);
 	tuple->dst.u.icmp.code =
-			*(u_int8_t *)NFA_DATA(tb[CTA_PROTO_ICMP_CODE-1]);
+			*(u_int8_t *)nla_data(tb[CTA_PROTO_ICMP_CODE]);
 	tuple->src.u.icmp.id =
-			*(__be16 *)NFA_DATA(tb[CTA_PROTO_ICMP_ID-1]);
+			*(__be16 *)nla_data(tb[CTA_PROTO_ICMP_ID]);
 
 	if (tuple->dst.u.icmp.type >= sizeof(invmap)
 	    || !invmap[tuple->dst.u.icmp.type])
diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
index deab27f..4bdbb12 100644
--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -547,38 +547,38 @@ int
 nf_nat_port_range_to_nfattr(struct sk_buff *skb,
 			    const struct nf_nat_range *range)
 {
-	NFA_PUT(skb, CTA_PROTONAT_PORT_MIN, sizeof(__be16),
+	NLA_PUT(skb, CTA_PROTONAT_PORT_MIN, sizeof(__be16),
 		&range->min.tcp.port);
-	NFA_PUT(skb, CTA_PROTONAT_PORT_MAX, sizeof(__be16),
+	NLA_PUT(skb, CTA_PROTONAT_PORT_MAX, sizeof(__be16),
 		&range->max.tcp.port);
 
 	return 0;
 
-nfattr_failure:
+nla_put_failure:
 	return -1;
 }
 EXPORT_SYMBOL_GPL(nf_nat_port_nfattr_to_range);
 
 int
-nf_nat_port_nfattr_to_range(struct nfattr *tb[], struct nf_nat_range *range)
+nf_nat_port_nfattr_to_range(struct nlattr *tb[], struct nf_nat_range *range)
 {
 	int ret = 0;
 
 	/* we have to return whether we actually parsed something or not */
 
-	if (tb[CTA_PROTONAT_PORT_MIN-1]) {
+	if (tb[CTA_PROTONAT_PORT_MIN]) {
 		ret = 1;
 		range->min.tcp.port =
-			*(__be16 *)NFA_DATA(tb[CTA_PROTONAT_PORT_MIN-1]);
+			*(__be16 *)nla_data(tb[CTA_PROTONAT_PORT_MIN]);
 	}
 
-	if (!tb[CTA_PROTONAT_PORT_MAX-1]) {
+	if (!tb[CTA_PROTONAT_PORT_MAX]) {
 		if (ret)
 			range->max.tcp.port = range->min.tcp.port;
 	} else {
 		ret = 1;
 		range->max.tcp.port =
-			*(__be16 *)NFA_DATA(tb[CTA_PROTONAT_PORT_MAX-1]);
+			*(__be16 *)nla_data(tb[CTA_PROTONAT_PORT_MAX]);
 	}
 
 	return ret;
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index 3153e15..f0ea3fb 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -340,33 +340,33 @@ static ctl_table nf_ct_ipv6_sysctl_table[] = {
 static int ipv6_tuple_to_nfattr(struct sk_buff *skb,
 				const struct nf_conntrack_tuple *tuple)
 {
-	NFA_PUT(skb, CTA_IP_V6_SRC, sizeof(u_int32_t) * 4,
+	NLA_PUT(skb, CTA_IP_V6_SRC, sizeof(u_int32_t) * 4,
 		&tuple->src.u3.ip6);
-	NFA_PUT(skb, CTA_IP_V6_DST, sizeof(u_int32_t) * 4,
+	NLA_PUT(skb, CTA_IP_V6_DST, sizeof(u_int32_t) * 4,
 		&tuple->dst.u3.ip6);
 	return 0;
 
-nfattr_failure:
+nla_put_failure:
 	return -1;
 }
 
-static const size_t cta_min_ip[CTA_IP_MAX] = {
-	[CTA_IP_V6_SRC-1]       = sizeof(u_int32_t)*4,
-	[CTA_IP_V6_DST-1]       = sizeof(u_int32_t)*4,
+static const size_t cta_min_ip[CTA_IP_MAX+1] = {
+	[CTA_IP_V6_SRC]	= sizeof(u_int32_t)*4,
+	[CTA_IP_V6_DST]	= sizeof(u_int32_t)*4,
 };
 
-static int ipv6_nfattr_to_tuple(struct nfattr *tb[],
+static int ipv6_nfattr_to_tuple(struct nlattr *tb[],
 				struct nf_conntrack_tuple *t)
 {
-	if (!tb[CTA_IP_V6_SRC-1] || !tb[CTA_IP_V6_DST-1])
+	if (!tb[CTA_IP_V6_SRC] || !tb[CTA_IP_V6_DST])
 		return -EINVAL;
 
 	if (nfattr_bad_size(tb, CTA_IP_MAX, cta_min_ip))
 		return -EINVAL;
 
-	memcpy(&t->src.u3.ip6, NFA_DATA(tb[CTA_IP_V6_SRC-1]),
+	memcpy(&t->src.u3.ip6, nla_data(tb[CTA_IP_V6_SRC]),
 	       sizeof(u_int32_t) * 4);
-	memcpy(&t->dst.u3.ip6, NFA_DATA(tb[CTA_IP_V6_DST-1]),
+	memcpy(&t->dst.u3.ip6, nla_data(tb[CTA_IP_V6_DST]),
 	       sizeof(u_int32_t) * 4);
 
 	return 0;
diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index ab154fb..c181838 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -213,42 +213,42 @@ icmpv6_error(struct sk_buff *skb, unsigned int dataoff,
 static int icmpv6_tuple_to_nfattr(struct sk_buff *skb,
 				  const struct nf_conntrack_tuple *t)
 {
-	NFA_PUT(skb, CTA_PROTO_ICMPV6_ID, sizeof(u_int16_t),
+	NLA_PUT(skb, CTA_PROTO_ICMPV6_ID, sizeof(u_int16_t),
 		&t->src.u.icmp.id);
-	NFA_PUT(skb, CTA_PROTO_ICMPV6_TYPE, sizeof(u_int8_t),
+	NLA_PUT(skb, CTA_PROTO_ICMPV6_TYPE, sizeof(u_int8_t),
 		&t->dst.u.icmp.type);
-	NFA_PUT(skb, CTA_PROTO_ICMPV6_CODE, sizeof(u_int8_t),
+	NLA_PUT(skb, CTA_PROTO_ICMPV6_CODE, sizeof(u_int8_t),
 		&t->dst.u.icmp.code);
 
 	return 0;
 
-nfattr_failure:
+nla_put_failure:
 	return -1;
 }
 
-static const size_t cta_min_proto[CTA_PROTO_MAX] = {
-	[CTA_PROTO_ICMPV6_TYPE-1] = sizeof(u_int8_t),
-	[CTA_PROTO_ICMPV6_CODE-1] = sizeof(u_int8_t),
-	[CTA_PROTO_ICMPV6_ID-1]   = sizeof(u_int16_t)
+static const size_t cta_min_proto[CTA_PROTO_MAX+1] = {
+	[CTA_PROTO_ICMPV6_TYPE]	= sizeof(u_int8_t),
+	[CTA_PROTO_ICMPV6_CODE]	= sizeof(u_int8_t),
+	[CTA_PROTO_ICMPV6_ID]	= sizeof(u_int16_t)
 };
 
-static int icmpv6_nfattr_to_tuple(struct nfattr *tb[],
+static int icmpv6_nfattr_to_tuple(struct nlattr *tb[],
 				struct nf_conntrack_tuple *tuple)
 {
-	if (!tb[CTA_PROTO_ICMPV6_TYPE-1]
-	    || !tb[CTA_PROTO_ICMPV6_CODE-1]
-	    || !tb[CTA_PROTO_ICMPV6_ID-1])
+	if (!tb[CTA_PROTO_ICMPV6_TYPE]
+	    || !tb[CTA_PROTO_ICMPV6_CODE]
+	    || !tb[CTA_PROTO_ICMPV6_ID])
 		return -EINVAL;
 
 	if (nfattr_bad_size(tb, CTA_PROTO_MAX, cta_min_proto))
 		return -EINVAL;
 
 	tuple->dst.u.icmp.type =
-			*(u_int8_t *)NFA_DATA(tb[CTA_PROTO_ICMPV6_TYPE-1]);
+			*(u_int8_t *)nla_data(tb[CTA_PROTO_ICMPV6_TYPE]);
 	tuple->dst.u.icmp.code =
-			*(u_int8_t *)NFA_DATA(tb[CTA_PROTO_ICMPV6_CODE-1]);
+			*(u_int8_t *)nla_data(tb[CTA_PROTO_ICMPV6_CODE]);
 	tuple->src.u.icmp.id =
-			*(__be16 *)NFA_DATA(tb[CTA_PROTO_ICMPV6_ID-1]);
+			*(__be16 *)nla_data(tb[CTA_PROTO_ICMPV6_ID]);
 
 	if (tuple->dst.u.icmp.type < 128
 	    || tuple->dst.u.icmp.type - 128 >= sizeof(invmap)
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 0fe1188..b64656a 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -827,40 +827,39 @@ EXPORT_SYMBOL_GPL(__nf_ct_refresh_acct);
 #include <linux/netfilter/nfnetlink_conntrack.h>
 #include <linux/mutex.h>
 
-
 /* Generic function for tcp/udp/sctp/dccp and alike. This needs to be
  * in ip_conntrack_core, since we don't want the protocols to autoload
  * or depend on ctnetlink */
 int nf_ct_port_tuple_to_nfattr(struct sk_buff *skb,
 			       const struct nf_conntrack_tuple *tuple)
 {
-	NFA_PUT(skb, CTA_PROTO_SRC_PORT, sizeof(u_int16_t),
+	NLA_PUT(skb, CTA_PROTO_SRC_PORT, sizeof(u_int16_t),
 		&tuple->src.u.tcp.port);
-	NFA_PUT(skb, CTA_PROTO_DST_PORT, sizeof(u_int16_t),
+	NLA_PUT(skb, CTA_PROTO_DST_PORT, sizeof(u_int16_t),
 		&tuple->dst.u.tcp.port);
 	return 0;
 
-nfattr_failure:
+nla_put_failure:
 	return -1;
 }
 EXPORT_SYMBOL_GPL(nf_ct_port_tuple_to_nfattr);
 
-static const size_t cta_min_proto[CTA_PROTO_MAX] = {
-	[CTA_PROTO_SRC_PORT-1]  = sizeof(u_int16_t),
-	[CTA_PROTO_DST_PORT-1]  = sizeof(u_int16_t)
+static const size_t cta_min_proto[CTA_PROTO_MAX+1] = {
+	[CTA_PROTO_SRC_PORT]  = sizeof(u_int16_t),
+	[CTA_PROTO_DST_PORT]  = sizeof(u_int16_t)
 };
 
-int nf_ct_port_nfattr_to_tuple(struct nfattr *tb[],
+int nf_ct_port_nfattr_to_tuple(struct nlattr *tb[],
 			       struct nf_conntrack_tuple *t)
 {
-	if (!tb[CTA_PROTO_SRC_PORT-1] || !tb[CTA_PROTO_DST_PORT-1])
+	if (!tb[CTA_PROTO_SRC_PORT] || !tb[CTA_PROTO_DST_PORT])
 		return -EINVAL;
 
 	if (nfattr_bad_size(tb, CTA_PROTO_MAX, cta_min_proto))
 		return -EINVAL;
 
-	t->src.u.tcp.port = *(__be16 *)NFA_DATA(tb[CTA_PROTO_SRC_PORT-1]);
-	t->dst.u.tcp.port = *(__be16 *)NFA_DATA(tb[CTA_PROTO_DST_PORT-1]);
+	t->src.u.tcp.port = *(__be16 *)nla_data(tb[CTA_PROTO_SRC_PORT]);
+	t->dst.u.tcp.port = *(__be16 *)nla_data(tb[CTA_PROTO_DST_PORT]);
 
 	return 0;
 }
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 5080045..221c38f 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -54,18 +54,21 @@ ctnetlink_dump_tuples_proto(struct sk_buff *skb,
 			    struct nf_conntrack_l4proto *l4proto)
 {
 	int ret = 0;
-	struct nfattr *nest_parms = NFA_NEST(skb, CTA_TUPLE_PROTO);
+	struct nlattr *nest_parms;
 
-	NFA_PUT(skb, CTA_PROTO_NUM, sizeof(u_int8_t), &tuple->dst.protonum);
+	nest_parms = nla_nest_start(skb, CTA_TUPLE_PROTO | NLA_F_NESTED);
+	if (!nest_parms)
+		goto nla_put_failure;
+	NLA_PUT(skb, CTA_PROTO_NUM, sizeof(u_int8_t), &tuple->dst.protonum);
 
 	if (likely(l4proto->tuple_to_nfattr))
 		ret = l4proto->tuple_to_nfattr(skb, tuple);
 
-	NFA_NEST_END(skb, nest_parms);
+	nla_nest_end(skb, nest_parms);
 
 	return ret;
 
-nfattr_failure:
+nla_put_failure:
 	return -1;
 }
 
@@ -75,16 +78,20 @@ ctnetlink_dump_tuples_ip(struct sk_buff *skb,
 			 struct nf_conntrack_l3proto *l3proto)
 {
 	int ret = 0;
-	struct nfattr *nest_parms = NFA_NEST(skb, CTA_TUPLE_IP);
+	struct nlattr *nest_parms;
+
+	nest_parms = nla_nest_start(skb, CTA_TUPLE_IP | NLA_F_NESTED);
+	if (!nest_parms)
+		goto nla_put_failure;
 
 	if (likely(l3proto->tuple_to_nfattr))
 		ret = l3proto->tuple_to_nfattr(skb, tuple);
 
-	NFA_NEST_END(skb, nest_parms);
+	nla_nest_end(skb, nest_parms);
 
 	return ret;
 
-nfattr_failure:
+nla_put_failure:
 	return -1;
 }
 
@@ -114,10 +121,10 @@ static inline int
 ctnetlink_dump_status(struct sk_buff *skb, const struct nf_conn *ct)
 {
 	__be32 status = htonl((u_int32_t) ct->status);
-	NFA_PUT(skb, CTA_STATUS, sizeof(status), &status);
+	NLA_PUT(skb, CTA_STATUS, sizeof(status), &status);
 	return 0;
 
-nfattr_failure:
+nla_put_failure:
 	return -1;
 }
 
@@ -132,10 +139,10 @@ ctnetlink_dump_timeout(struct sk_buff *skb, const struct nf_conn *ct)
 	else
 		timeout = htonl(timeout_l / HZ);
 
-	NFA_PUT(skb, CTA_TIMEOUT, sizeof(timeout), &timeout);
+	NLA_PUT(skb, CTA_TIMEOUT, sizeof(timeout), &timeout);
 	return 0;
 
-nfattr_failure:
+nla_put_failure:
 	return -1;
 }
 
@@ -143,7 +150,7 @@ static inline int
 ctnetlink_dump_protoinfo(struct sk_buff *skb, const struct nf_conn *ct)
 {
 	struct nf_conntrack_l4proto *l4proto = nf_ct_l4proto_find_get(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num, ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum);
-	struct nfattr *nest_proto;
+	struct nlattr *nest_proto;
 	int ret;
 
 	if (!l4proto->to_nfattr) {
@@ -151,17 +158,19 @@ ctnetlink_dump_protoinfo(struct sk_buff *skb, const struct nf_conn *ct)
 		return 0;
 	}
 
-	nest_proto = NFA_NEST(skb, CTA_PROTOINFO);
+	nest_proto = nla_nest_start(skb, CTA_PROTOINFO | NLA_F_NESTED);
+	if (!nest_proto)
+		goto nla_put_failure;
 
 	ret = l4proto->to_nfattr(skb, nest_proto, ct);
 
 	nf_ct_l4proto_put(l4proto);
 
-	NFA_NEST_END(skb, nest_proto);
+	nla_nest_end(skb, nest_proto);
 
 	return ret;
 
-nfattr_failure:
+nla_put_failure:
 	nf_ct_l4proto_put(l4proto);
 	return -1;
 }
@@ -169,7 +178,7 @@ nfattr_failure:
 static inline int
 ctnetlink_dump_helpinfo(struct sk_buff *skb, const struct nf_conn *ct)
 {
-	struct nfattr *nest_helper;
+	struct nlattr *nest_helper;
 	const struct nf_conn_help *help = nfct_help(ct);
 	struct nf_conntrack_helper *helper;
 
@@ -181,18 +190,20 @@ ctnetlink_dump_helpinfo(struct sk_buff *skb, const struct nf_conn *ct)
 	if (!helper)
 		goto out;
 
-	nest_helper = NFA_NEST(skb, CTA_HELP);
-	NFA_PUT(skb, CTA_HELP_NAME, strlen(helper->name), helper->name);
+	nest_helper = nla_nest_start(skb, CTA_HELP | NLA_F_NESTED);
+	if (!nest_helper)
+		goto nla_put_failure;
+	NLA_PUT(skb, CTA_HELP_NAME, strlen(helper->name), helper->name);
 
 	if (helper->to_nfattr)
 		helper->to_nfattr(skb, ct);
 
-	NFA_NEST_END(skb, nest_helper);
+	nla_nest_end(skb, nest_helper);
 out:
 	rcu_read_unlock();
 	return 0;
 
-nfattr_failure:
+nla_put_failure:
 	rcu_read_unlock();
 	return -1;
 }
@@ -203,20 +214,24 @@ ctnetlink_dump_counters(struct sk_buff *skb, const struct nf_conn *ct,
 			enum ip_conntrack_dir dir)
 {
 	enum ctattr_type type = dir ? CTA_COUNTERS_REPLY: CTA_COUNTERS_ORIG;
-	struct nfattr *nest_count = NFA_NEST(skb, type);
+	struct nlattr *nest_count;
 	__be32 tmp;
 
+	nest_count = nla_nest_start(skb, type | NLA_F_NESTED);
+	if (!nest_count)
+		goto nla_put_failure;
+
 	tmp = htonl(ct->counters[dir].packets);
-	NFA_PUT(skb, CTA_COUNTERS32_PACKETS, sizeof(u_int32_t), &tmp);
+	NLA_PUT(skb, CTA_COUNTERS32_PACKETS, sizeof(u_int32_t), &tmp);
 
 	tmp = htonl(ct->counters[dir].bytes);
-	NFA_PUT(skb, CTA_COUNTERS32_BYTES, sizeof(u_int32_t), &tmp);
+	NLA_PUT(skb, CTA_COUNTERS32_BYTES, sizeof(u_int32_t), &tmp);
 
-	NFA_NEST_END(skb, nest_count);
+	nla_nest_end(skb, nest_count);
 
 	return 0;
 
-nfattr_failure:
+nla_put_failure:
 	return -1;
 }
 #else
@@ -229,10 +244,10 @@ ctnetlink_dump_mark(struct sk_buff *skb, const struct nf_conn *ct)
 {
 	__be32 mark = htonl(ct->mark);
 
-	NFA_PUT(skb, CTA_MARK, sizeof(u_int32_t), &mark);
+	NLA_PUT(skb, CTA_MARK, sizeof(u_int32_t), &mark);
 	return 0;
 
-nfattr_failure:
+nla_put_failure:
 	return -1;
 }
 #else
@@ -243,10 +258,10 @@ static inline int
 ctnetlink_dump_id(struct sk_buff *skb, const struct nf_conn *ct)
 {
 	__be32 id = htonl(ct->id);
-	NFA_PUT(skb, CTA_ID, sizeof(u_int32_t), &id);
+	NLA_PUT(skb, CTA_ID, sizeof(u_int32_t), &id);
 	return 0;
 
-nfattr_failure:
+nla_put_failure:
 	return -1;
 }
 
@@ -255,10 +270,10 @@ ctnetlink_dump_use(struct sk_buff *skb, const struct nf_conn *ct)
 {
 	__be32 use = htonl(atomic_read(&ct->ct_general.use));
 
-	NFA_PUT(skb, CTA_USE, sizeof(u_int32_t), &use);
+	NLA_PUT(skb, CTA_USE, sizeof(u_int32_t), &use);
 	return 0;
 
-nfattr_failure:
+nla_put_failure:
 	return -1;
 }
 
@@ -271,7 +286,7 @@ ctnetlink_fill_info(struct sk_buff *skb, u32 pid, u32 seq,
 {
 	struct nlmsghdr *nlh;
 	struct nfgenmsg *nfmsg;
-	struct nfattr *nest_parms;
+	struct nlattr *nest_parms;
 	unsigned char *b = skb_tail_pointer(skb);
 
 	event |= NFNL_SUBSYS_CTNETLINK << 8;
@@ -284,15 +299,19 @@ ctnetlink_fill_info(struct sk_buff *skb, u32 pid, u32 seq,
 	nfmsg->version      = NFNETLINK_V0;
 	nfmsg->res_id	    = 0;
 
-	nest_parms = NFA_NEST(skb, CTA_TUPLE_ORIG);
+	nest_parms = nla_nest_start(skb, CTA_TUPLE_ORIG | NLA_F_NESTED);
+	if (!nest_parms)
+		goto nla_put_failure;
 	if (ctnetlink_dump_tuples(skb, tuple(ct, IP_CT_DIR_ORIGINAL)) < 0)
-		goto nfattr_failure;
-	NFA_NEST_END(skb, nest_parms);
+		goto nla_put_failure;
+	nla_nest_end(skb, nest_parms);
 
-	nest_parms = NFA_NEST(skb, CTA_TUPLE_REPLY);
+	nest_parms = nla_nest_start(skb, CTA_TUPLE_REPLY | NLA_F_NESTED);
+	if (!nest_parms)
+		goto nla_put_failure;
 	if (ctnetlink_dump_tuples(skb, tuple(ct, IP_CT_DIR_REPLY)) < 0)
-		goto nfattr_failure;
-	NFA_NEST_END(skb, nest_parms);
+		goto nla_put_failure;
+	nla_nest_end(skb, nest_parms);
 
 	if (ctnetlink_dump_status(skb, ct) < 0 ||
 	    ctnetlink_dump_timeout(skb, ct) < 0 ||
@@ -303,13 +322,13 @@ ctnetlink_fill_info(struct sk_buff *skb, u32 pid, u32 seq,
 	    ctnetlink_dump_mark(skb, ct) < 0 ||
 	    ctnetlink_dump_id(skb, ct) < 0 ||
 	    ctnetlink_dump_use(skb, ct) < 0)
-		goto nfattr_failure;
+		goto nla_put_failure;
 
 	nlh->nlmsg_len = skb_tail_pointer(skb) - b;
 	return skb->len;
 
 nlmsg_failure:
-nfattr_failure:
+nla_put_failure:
 	nlmsg_trim(skb, b);
 	return -1;
 }
@@ -320,7 +339,7 @@ static int ctnetlink_conntrack_event(struct notifier_block *this,
 {
 	struct nlmsghdr *nlh;
 	struct nfgenmsg *nfmsg;
-	struct nfattr *nest_parms;
+	struct nlattr *nest_parms;
 	struct nf_conn *ct = (struct nf_conn *)ptr;
 	struct sk_buff *skb;
 	unsigned int type;
@@ -362,45 +381,49 @@ static int ctnetlink_conntrack_event(struct notifier_block *this,
 	nfmsg->version	= NFNETLINK_V0;
 	nfmsg->res_id	= 0;
 
-	nest_parms = NFA_NEST(skb, CTA_TUPLE_ORIG);
+	nest_parms = nla_nest_start(skb, CTA_TUPLE_ORIG | NLA_F_NESTED);
+	if (!nest_parms)
+		goto nla_put_failure;
 	if (ctnetlink_dump_tuples(skb, tuple(ct, IP_CT_DIR_ORIGINAL)) < 0)
-		goto nfattr_failure;
-	NFA_NEST_END(skb, nest_parms);
+		goto nla_put_failure;
+	nla_nest_end(skb, nest_parms);
 
-	nest_parms = NFA_NEST(skb, CTA_TUPLE_REPLY);
+	nest_parms = nla_nest_start(skb, CTA_TUPLE_REPLY | NLA_F_NESTED);
+	if (!nest_parms)
+		goto nla_put_failure;
 	if (ctnetlink_dump_tuples(skb, tuple(ct, IP_CT_DIR_REPLY)) < 0)
-		goto nfattr_failure;
-	NFA_NEST_END(skb, nest_parms);
+		goto nla_put_failure;
+	nla_nest_end(skb, nest_parms);
 
 	if (events & IPCT_DESTROY) {
 		if (ctnetlink_dump_counters(skb, ct, IP_CT_DIR_ORIGINAL) < 0 ||
 		    ctnetlink_dump_counters(skb, ct, IP_CT_DIR_REPLY) < 0)
-			goto nfattr_failure;
+			goto nla_put_failure;
 	} else {
 		if (ctnetlink_dump_status(skb, ct) < 0)
-			goto nfattr_failure;
+			goto nla_put_failure;
 
 		if (ctnetlink_dump_timeout(skb, ct) < 0)
-			goto nfattr_failure;
+			goto nla_put_failure;
 
 		if (events & IPCT_PROTOINFO
 		    && ctnetlink_dump_protoinfo(skb, ct) < 0)
-			goto nfattr_failure;
+			goto nla_put_failure;
 
 		if ((events & IPCT_HELPER || nfct_help(ct))
 		    && ctnetlink_dump_helpinfo(skb, ct) < 0)
-			goto nfattr_failure;
+			goto nla_put_failure;
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
 		if ((events & IPCT_MARK || ct->mark)
 		    && ctnetlink_dump_mark(skb, ct) < 0)
-			goto nfattr_failure;
+			goto nla_put_failure;
 #endif
 
 		if (events & IPCT_COUNTER_FILLING &&
 		    (ctnetlink_dump_counters(skb, ct, IP_CT_DIR_ORIGINAL) < 0 ||
 		     ctnetlink_dump_counters(skb, ct, IP_CT_DIR_REPLY) < 0))
-			goto nfattr_failure;
+			goto nla_put_failure;
 	}
 
 	nlh->nlmsg_len = skb->tail - b;
@@ -408,7 +431,7 @@ static int ctnetlink_conntrack_event(struct notifier_block *this,
 	return NOTIFY_DONE;
 
 nlmsg_failure:
-nfattr_failure:
+nla_put_failure:
 	kfree_skb(skb);
 	return NOTIFY_DONE;
 }
@@ -479,13 +502,13 @@ out:
 }
 
 static inline int
-ctnetlink_parse_tuple_ip(struct nfattr *attr, struct nf_conntrack_tuple *tuple)
+ctnetlink_parse_tuple_ip(struct nlattr *attr, struct nf_conntrack_tuple *tuple)
 {
-	struct nfattr *tb[CTA_IP_MAX];
+	struct nlattr *tb[CTA_IP_MAX+1];
 	struct nf_conntrack_l3proto *l3proto;
 	int ret = 0;
 
-	nfattr_parse_nested(tb, CTA_IP_MAX, attr);
+	nla_parse_nested(tb, CTA_IP_MAX, attr, NULL);
 
 	l3proto = nf_ct_l3proto_find_get(tuple->src.l3num);
 
@@ -497,26 +520,26 @@ ctnetlink_parse_tuple_ip(struct nfattr *attr, struct nf_conntrack_tuple *tuple)
 	return ret;
 }
 
-static const size_t cta_min_proto[CTA_PROTO_MAX] = {
-	[CTA_PROTO_NUM-1]	= sizeof(u_int8_t),
+static const size_t cta_min_proto[CTA_PROTO_MAX+1] = {
+	[CTA_PROTO_NUM]	= sizeof(u_int8_t),
 };
 
 static inline int
-ctnetlink_parse_tuple_proto(struct nfattr *attr,
+ctnetlink_parse_tuple_proto(struct nlattr *attr,
 			    struct nf_conntrack_tuple *tuple)
 {
-	struct nfattr *tb[CTA_PROTO_MAX];
+	struct nlattr *tb[CTA_PROTO_MAX+1];
 	struct nf_conntrack_l4proto *l4proto;
 	int ret = 0;
 
-	nfattr_parse_nested(tb, CTA_PROTO_MAX, attr);
+	nla_parse_nested(tb, CTA_PROTO_MAX, attr, NULL);
 
 	if (nfattr_bad_size(tb, CTA_PROTO_MAX, cta_min_proto))
 		return -EINVAL;
 
-	if (!tb[CTA_PROTO_NUM-1])
+	if (!tb[CTA_PROTO_NUM])
 		return -EINVAL;
-	tuple->dst.protonum = *(u_int8_t *)NFA_DATA(tb[CTA_PROTO_NUM-1]);
+	tuple->dst.protonum = *(u_int8_t *)nla_data(tb[CTA_PROTO_NUM]);
 
 	l4proto = nf_ct_l4proto_find_get(tuple->src.l3num, tuple->dst.protonum);
 
@@ -529,29 +552,29 @@ ctnetlink_parse_tuple_proto(struct nfattr *attr,
 }
 
 static inline int
-ctnetlink_parse_tuple(struct nfattr *cda[], struct nf_conntrack_tuple *tuple,
+ctnetlink_parse_tuple(struct nlattr *cda[], struct nf_conntrack_tuple *tuple,
 		      enum ctattr_tuple type, u_int8_t l3num)
 {
-	struct nfattr *tb[CTA_TUPLE_MAX];
+	struct nlattr *tb[CTA_TUPLE_MAX+1];
 	int err;
 
 	memset(tuple, 0, sizeof(*tuple));
 
-	nfattr_parse_nested(tb, CTA_TUPLE_MAX, cda[type-1]);
+	nla_parse_nested(tb, CTA_TUPLE_MAX, cda[type], NULL);
 
-	if (!tb[CTA_TUPLE_IP-1])
+	if (!tb[CTA_TUPLE_IP])
 		return -EINVAL;
 
 	tuple->src.l3num = l3num;
 
-	err = ctnetlink_parse_tuple_ip(tb[CTA_TUPLE_IP-1], tuple);
+	err = ctnetlink_parse_tuple_ip(tb[CTA_TUPLE_IP], tuple);
 	if (err < 0)
 		return err;
 
-	if (!tb[CTA_TUPLE_PROTO-1])
+	if (!tb[CTA_TUPLE_PROTO])
 		return -EINVAL;
 
-	err = ctnetlink_parse_tuple_proto(tb[CTA_TUPLE_PROTO-1], tuple);
+	err = ctnetlink_parse_tuple_proto(tb[CTA_TUPLE_PROTO], tuple);
 	if (err < 0)
 		return err;
 
@@ -565,19 +588,19 @@ ctnetlink_parse_tuple(struct nfattr *cda[], struct nf_conntrack_tuple *tuple,
 }
 
 #ifdef CONFIG_NF_NAT_NEEDED
-static const size_t cta_min_protonat[CTA_PROTONAT_MAX] = {
-	[CTA_PROTONAT_PORT_MIN-1]       = sizeof(u_int16_t),
-	[CTA_PROTONAT_PORT_MAX-1]       = sizeof(u_int16_t),
+static const size_t cta_min_protonat[CTA_PROTONAT_MAX+1] = {
+	[CTA_PROTONAT_PORT_MIN]	= sizeof(u_int16_t),
+	[CTA_PROTONAT_PORT_MAX]	= sizeof(u_int16_t),
 };
 
-static int nfnetlink_parse_nat_proto(struct nfattr *attr,
+static int nfnetlink_parse_nat_proto(struct nlattr *attr,
 				     const struct nf_conn *ct,
 				     struct nf_nat_range *range)
 {
-	struct nfattr *tb[CTA_PROTONAT_MAX];
+	struct nlattr *tb[CTA_PROTONAT_MAX+1];
 	struct nf_nat_protocol *npt;
 
-	nfattr_parse_nested(tb, CTA_PROTONAT_MAX, attr);
+	nla_parse_nested(tb, CTA_PROTONAT_MAX, attr, NULL);
 
 	if (nfattr_bad_size(tb, CTA_PROTONAT_MAX, cta_min_protonat))
 		return -EINVAL;
@@ -598,40 +621,40 @@ static int nfnetlink_parse_nat_proto(struct nfattr *attr,
 	return 0;
 }
 
-static const size_t cta_min_nat[CTA_NAT_MAX] = {
-	[CTA_NAT_MINIP-1]       = sizeof(u_int32_t),
-	[CTA_NAT_MAXIP-1]       = sizeof(u_int32_t),
+static const size_t cta_min_nat[CTA_NAT_MAX+1] = {
+	[CTA_NAT_MINIP]		= sizeof(u_int32_t),
+	[CTA_NAT_MAXIP]		= sizeof(u_int32_t),
 };
 
 static inline int
-nfnetlink_parse_nat(struct nfattr *nat,
+nfnetlink_parse_nat(struct nlattr *nat,
 		    const struct nf_conn *ct, struct nf_nat_range *range)
 {
-	struct nfattr *tb[CTA_NAT_MAX];
+	struct nlattr *tb[CTA_NAT_MAX+1];
 	int err;
 
 	memset(range, 0, sizeof(*range));
 
-	nfattr_parse_nested(tb, CTA_NAT_MAX, nat);
+	nla_parse_nested(tb, CTA_NAT_MAX, nat, NULL);
 
 	if (nfattr_bad_size(tb, CTA_NAT_MAX, cta_min_nat))
 		return -EINVAL;
 
-	if (tb[CTA_NAT_MINIP-1])
-		range->min_ip = *(__be32 *)NFA_DATA(tb[CTA_NAT_MINIP-1]);
+	if (tb[CTA_NAT_MINIP])
+		range->min_ip = *(__be32 *)nla_data(tb[CTA_NAT_MINIP]);
 
-	if (!tb[CTA_NAT_MAXIP-1])
+	if (!tb[CTA_NAT_MAXIP])
 		range->max_ip = range->min_ip;
 	else
-		range->max_ip = *(__be32 *)NFA_DATA(tb[CTA_NAT_MAXIP-1]);
+		range->max_ip = *(__be32 *)nla_data(tb[CTA_NAT_MAXIP]);
 
 	if (range->min_ip)
 		range->flags |= IP_NAT_RANGE_MAP_IPS;
 
-	if (!tb[CTA_NAT_PROTO-1])
+	if (!tb[CTA_NAT_PROTO])
 		return 0;
 
-	err = nfnetlink_parse_nat_proto(tb[CTA_NAT_PROTO-1], ct, range);
+	err = nfnetlink_parse_nat_proto(tb[CTA_NAT_PROTO], ct, range);
 	if (err < 0)
 		return err;
 
@@ -640,31 +663,31 @@ nfnetlink_parse_nat(struct nfattr *nat,
 #endif
 
 static inline int
-ctnetlink_parse_help(struct nfattr *attr, char **helper_name)
+ctnetlink_parse_help(struct nlattr *attr, char **helper_name)
 {
-	struct nfattr *tb[CTA_HELP_MAX];
+	struct nlattr *tb[CTA_HELP_MAX+1];
 
-	nfattr_parse_nested(tb, CTA_HELP_MAX, attr);
+	nla_parse_nested(tb, CTA_HELP_MAX, attr, NULL);
 
-	if (!tb[CTA_HELP_NAME-1])
+	if (!tb[CTA_HELP_NAME])
 		return -EINVAL;
 
-	*helper_name = NFA_DATA(tb[CTA_HELP_NAME-1]);
+	*helper_name = nla_data(tb[CTA_HELP_NAME]);
 
 	return 0;
 }
 
-static const size_t cta_min[CTA_MAX] = {
-	[CTA_STATUS-1] 		= sizeof(u_int32_t),
-	[CTA_TIMEOUT-1] 	= sizeof(u_int32_t),
-	[CTA_MARK-1]		= sizeof(u_int32_t),
-	[CTA_USE-1]		= sizeof(u_int32_t),
-	[CTA_ID-1]		= sizeof(u_int32_t)
+static const size_t cta_min[CTA_MAX+1] = {
+	[CTA_STATUS] 		= sizeof(u_int32_t),
+	[CTA_TIMEOUT] 		= sizeof(u_int32_t),
+	[CTA_MARK]		= sizeof(u_int32_t),
+	[CTA_USE]		= sizeof(u_int32_t),
+	[CTA_ID]		= sizeof(u_int32_t)
 };
 
 static int
 ctnetlink_del_conntrack(struct sock *ctnl, struct sk_buff *skb,
-			struct nlmsghdr *nlh, struct nfattr *cda[])
+			struct nlmsghdr *nlh, struct nlattr *cda[])
 {
 	struct nf_conntrack_tuple_hash *h;
 	struct nf_conntrack_tuple tuple;
@@ -676,9 +699,9 @@ ctnetlink_del_conntrack(struct sock *ctnl, struct sk_buff *skb,
 	if (nfattr_bad_size(cda, CTA_MAX, cta_min))
 		return -EINVAL;
 
-	if (cda[CTA_TUPLE_ORIG-1])
+	if (cda[CTA_TUPLE_ORIG])
 		err = ctnetlink_parse_tuple(cda, &tuple, CTA_TUPLE_ORIG, u3);
-	else if (cda[CTA_TUPLE_REPLY-1])
+	else if (cda[CTA_TUPLE_REPLY])
 		err = ctnetlink_parse_tuple(cda, &tuple, CTA_TUPLE_REPLY, u3);
 	else {
 		/* Flush the whole table */
@@ -695,8 +718,8 @@ ctnetlink_del_conntrack(struct sock *ctnl, struct sk_buff *skb,
 
 	ct = nf_ct_tuplehash_to_ctrack(h);
 
-	if (cda[CTA_ID-1]) {
-		u_int32_t id = ntohl(*(__be32 *)NFA_DATA(cda[CTA_ID-1]));
+	if (cda[CTA_ID]) {
+		u_int32_t id = ntohl(*(__be32 *)nla_data(cda[CTA_ID]));
 		if (ct->id != id) {
 			nf_ct_put(ct);
 			return -ENOENT;
@@ -712,7 +735,7 @@ ctnetlink_del_conntrack(struct sock *ctnl, struct sk_buff *skb,
 
 static int
 ctnetlink_get_conntrack(struct sock *ctnl, struct sk_buff *skb,
-			struct nlmsghdr *nlh, struct nfattr *cda[])
+			struct nlmsghdr *nlh, struct nlattr *cda[])
 {
 	struct nf_conntrack_tuple_hash *h;
 	struct nf_conntrack_tuple tuple;
@@ -734,9 +757,9 @@ ctnetlink_get_conntrack(struct sock *ctnl, struct sk_buff *skb,
 	if (nfattr_bad_size(cda, CTA_MAX, cta_min))
 		return -EINVAL;
 
-	if (cda[CTA_TUPLE_ORIG-1])
+	if (cda[CTA_TUPLE_ORIG])
 		err = ctnetlink_parse_tuple(cda, &tuple, CTA_TUPLE_ORIG, u3);
-	else if (cda[CTA_TUPLE_REPLY-1])
+	else if (cda[CTA_TUPLE_REPLY])
 		err = ctnetlink_parse_tuple(cda, &tuple, CTA_TUPLE_REPLY, u3);
 	else
 		return -EINVAL;
@@ -776,10 +799,10 @@ out:
 }
 
 static inline int
-ctnetlink_change_status(struct nf_conn *ct, struct nfattr *cda[])
+ctnetlink_change_status(struct nf_conn *ct, struct nlattr *cda[])
 {
 	unsigned long d;
-	unsigned int status = ntohl(*(__be32 *)NFA_DATA(cda[CTA_STATUS-1]));
+	unsigned int status = ntohl(*(__be32 *)nla_data(cda[CTA_STATUS]));
 	d = ct->status ^ status;
 
 	if (d & (IPS_EXPECTED|IPS_CONFIRMED|IPS_DYING))
@@ -795,14 +818,14 @@ ctnetlink_change_status(struct nf_conn *ct, struct nfattr *cda[])
 		/* ASSURED bit can only be set */
 		return -EINVAL;
 
-	if (cda[CTA_NAT_SRC-1] || cda[CTA_NAT_DST-1]) {
+	if (cda[CTA_NAT_SRC] || cda[CTA_NAT_DST]) {
 #ifndef CONFIG_NF_NAT_NEEDED
 		return -EINVAL;
 #else
 		struct nf_nat_range range;
 
-		if (cda[CTA_NAT_DST-1]) {
-			if (nfnetlink_parse_nat(cda[CTA_NAT_DST-1], ct,
+		if (cda[CTA_NAT_DST]) {
+			if (nfnetlink_parse_nat(cda[CTA_NAT_DST], ct,
 						&range) < 0)
 				return -EINVAL;
 			if (nf_nat_initialized(ct,
@@ -810,8 +833,8 @@ ctnetlink_change_status(struct nf_conn *ct, struct nfattr *cda[])
 				return -EEXIST;
 			nf_nat_setup_info(ct, &range, NF_IP_PRE_ROUTING);
 		}
-		if (cda[CTA_NAT_SRC-1]) {
-			if (nfnetlink_parse_nat(cda[CTA_NAT_SRC-1], ct,
+		if (cda[CTA_NAT_SRC]) {
+			if (nfnetlink_parse_nat(cda[CTA_NAT_SRC], ct,
 						&range) < 0)
 				return -EINVAL;
 			if (nf_nat_initialized(ct,
@@ -831,7 +854,7 @@ ctnetlink_change_status(struct nf_conn *ct, struct nfattr *cda[])
 
 
 static inline int
-ctnetlink_change_helper(struct nf_conn *ct, struct nfattr *cda[])
+ctnetlink_change_helper(struct nf_conn *ct, struct nlattr *cda[])
 {
 	struct nf_conntrack_helper *helper;
 	struct nf_conn_help *help = nfct_help(ct);
@@ -842,7 +865,7 @@ ctnetlink_change_helper(struct nf_conn *ct, struct nfattr *cda[])
 	if (ct->master)
 		return -EINVAL;
 
-	err = ctnetlink_parse_help(cda[CTA_HELP-1], &helpname);
+	err = ctnetlink_parse_help(cda[CTA_HELP], &helpname);
 	if (err < 0)
 		return err;
 
@@ -879,9 +902,9 @@ ctnetlink_change_helper(struct nf_conn *ct, struct nfattr *cda[])
 }
 
 static inline int
-ctnetlink_change_timeout(struct nf_conn *ct, struct nfattr *cda[])
+ctnetlink_change_timeout(struct nf_conn *ct, struct nlattr *cda[])
 {
-	u_int32_t timeout = ntohl(*(__be32 *)NFA_DATA(cda[CTA_TIMEOUT-1]));
+	u_int32_t timeout = ntohl(*(__be32 *)nla_data(cda[CTA_TIMEOUT]));
 
 	if (!del_timer(&ct->timeout))
 		return -ETIME;
@@ -893,15 +916,15 @@ ctnetlink_change_timeout(struct nf_conn *ct, struct nfattr *cda[])
 }
 
 static inline int
-ctnetlink_change_protoinfo(struct nf_conn *ct, struct nfattr *cda[])
+ctnetlink_change_protoinfo(struct nf_conn *ct, struct nlattr *cda[])
 {
-	struct nfattr *tb[CTA_PROTOINFO_MAX], *attr = cda[CTA_PROTOINFO-1];
+	struct nlattr *tb[CTA_PROTOINFO_MAX+1], *attr = cda[CTA_PROTOINFO];
 	struct nf_conntrack_l4proto *l4proto;
 	u_int16_t npt = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum;
 	u_int16_t l3num = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
 	int err = 0;
 
-	nfattr_parse_nested(tb, CTA_PROTOINFO_MAX, attr);
+	nla_parse_nested(tb, CTA_PROTOINFO_MAX, attr, NULL);
 
 	l4proto = nf_ct_l4proto_find_get(l3num, npt);
 
@@ -913,44 +936,44 @@ ctnetlink_change_protoinfo(struct nf_conn *ct, struct nfattr *cda[])
 }
 
 static int
-ctnetlink_change_conntrack(struct nf_conn *ct, struct nfattr *cda[])
+ctnetlink_change_conntrack(struct nf_conn *ct, struct nlattr *cda[])
 {
 	int err;
 
-	if (cda[CTA_HELP-1]) {
+	if (cda[CTA_HELP]) {
 		err = ctnetlink_change_helper(ct, cda);
 		if (err < 0)
 			return err;
 	}
 
-	if (cda[CTA_TIMEOUT-1]) {
+	if (cda[CTA_TIMEOUT]) {
 		err = ctnetlink_change_timeout(ct, cda);
 		if (err < 0)
 			return err;
 	}
 
-	if (cda[CTA_STATUS-1]) {
+	if (cda[CTA_STATUS]) {
 		err = ctnetlink_change_status(ct, cda);
 		if (err < 0)
 			return err;
 	}
 
-	if (cda[CTA_PROTOINFO-1]) {
+	if (cda[CTA_PROTOINFO]) {
 		err = ctnetlink_change_protoinfo(ct, cda);
 		if (err < 0)
 			return err;
 	}
 
 #if defined(CONFIG_NF_CONNTRACK_MARK)
-	if (cda[CTA_MARK-1])
-		ct->mark = ntohl(*(__be32 *)NFA_DATA(cda[CTA_MARK-1]));
+	if (cda[CTA_MARK])
+		ct->mark = ntohl(*(__be32 *)nla_data(cda[CTA_MARK]));
 #endif
 
 	return 0;
 }
 
 static int
-ctnetlink_create_conntrack(struct nfattr *cda[],
+ctnetlink_create_conntrack(struct nlattr *cda[],
 			   struct nf_conntrack_tuple *otuple,
 			   struct nf_conntrack_tuple *rtuple)
 {
@@ -963,28 +986,28 @@ ctnetlink_create_conntrack(struct nfattr *cda[],
 	if (ct == NULL || IS_ERR(ct))
 		return -ENOMEM;
 
-	if (!cda[CTA_TIMEOUT-1])
+	if (!cda[CTA_TIMEOUT])
 		goto err;
-	ct->timeout.expires = ntohl(*(__be32 *)NFA_DATA(cda[CTA_TIMEOUT-1]));
+	ct->timeout.expires = ntohl(*(__be32 *)nla_data(cda[CTA_TIMEOUT]));
 
 	ct->timeout.expires = jiffies + ct->timeout.expires * HZ;
 	ct->status |= IPS_CONFIRMED;
 
-	if (cda[CTA_STATUS-1]) {
+	if (cda[CTA_STATUS]) {
 		err = ctnetlink_change_status(ct, cda);
 		if (err < 0)
 			goto err;
 	}
 
-	if (cda[CTA_PROTOINFO-1]) {
+	if (cda[CTA_PROTOINFO]) {
 		err = ctnetlink_change_protoinfo(ct, cda);
 		if (err < 0)
 			goto err;
 	}
 
 #if defined(CONFIG_NF_CONNTRACK_MARK)
-	if (cda[CTA_MARK-1])
-		ct->mark = ntohl(*(__be32 *)NFA_DATA(cda[CTA_MARK-1]));
+	if (cda[CTA_MARK])
+		ct->mark = ntohl(*(__be32 *)nla_data(cda[CTA_MARK]));
 #endif
 
 	helper = nf_ct_helper_find_get(rtuple);
@@ -1014,7 +1037,7 @@ err:
 
 static int
 ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
-			struct nlmsghdr *nlh, struct nfattr *cda[])
+			struct nlmsghdr *nlh, struct nlattr *cda[])
 {
 	struct nf_conntrack_tuple otuple, rtuple;
 	struct nf_conntrack_tuple_hash *h = NULL;
@@ -1025,22 +1048,22 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
 	if (nfattr_bad_size(cda, CTA_MAX, cta_min))
 		return -EINVAL;
 
-	if (cda[CTA_TUPLE_ORIG-1]) {
+	if (cda[CTA_TUPLE_ORIG]) {
 		err = ctnetlink_parse_tuple(cda, &otuple, CTA_TUPLE_ORIG, u3);
 		if (err < 0)
 			return err;
 	}
 
-	if (cda[CTA_TUPLE_REPLY-1]) {
+	if (cda[CTA_TUPLE_REPLY]) {
 		err = ctnetlink_parse_tuple(cda, &rtuple, CTA_TUPLE_REPLY, u3);
 		if (err < 0)
 			return err;
 	}
 
 	write_lock_bh(&nf_conntrack_lock);
-	if (cda[CTA_TUPLE_ORIG-1])
+	if (cda[CTA_TUPLE_ORIG])
 		h = __nf_conntrack_find(&otuple, NULL);
-	else if (cda[CTA_TUPLE_REPLY-1])
+	else if (cda[CTA_TUPLE_REPLY])
 		h = __nf_conntrack_find(&rtuple, NULL);
 
 	if (h == NULL) {
@@ -1057,7 +1080,7 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
 	err = -EEXIST;
 	if (!(nlh->nlmsg_flags & NLM_F_EXCL)) {
 		/* we only allow nat config for new conntracks */
-		if (cda[CTA_NAT_SRC-1] || cda[CTA_NAT_DST-1]) {
+		if (cda[CTA_NAT_SRC] || cda[CTA_NAT_DST]) {
 			err = -EINVAL;
 			goto out_unlock;
 		}
@@ -1079,16 +1102,18 @@ ctnetlink_exp_dump_tuple(struct sk_buff *skb,
 			 const struct nf_conntrack_tuple *tuple,
 			 enum ctattr_expect type)
 {
-	struct nfattr *nest_parms = NFA_NEST(skb, type);
+	struct nlattr *nest_parms;
 
+	nest_parms = nla_nest_start(skb, type | NLA_F_NESTED);
+	if (!nest_parms)
+		goto nla_put_failure;
 	if (ctnetlink_dump_tuples(skb, tuple) < 0)
-		goto nfattr_failure;
-
-	NFA_NEST_END(skb, nest_parms);
+		goto nla_put_failure;
+	nla_nest_end(skb, nest_parms);
 
 	return 0;
 
-nfattr_failure:
+nla_put_failure:
 	return -1;
 }
 
@@ -1101,32 +1126,34 @@ ctnetlink_exp_dump_mask(struct sk_buff *skb,
 	struct nf_conntrack_l3proto *l3proto;
 	struct nf_conntrack_l4proto *l4proto;
 	struct nf_conntrack_tuple m;
-	struct nfattr *nest_parms;
+	struct nlattr *nest_parms;
 
 	memset(&m, 0xFF, sizeof(m));
 	m.src.u.all = mask->src.u.all;
 	memcpy(&m.src.u3, &mask->src.u3, sizeof(m.src.u3));
 
-	nest_parms = NFA_NEST(skb, CTA_EXPECT_MASK);
+	nest_parms = nla_nest_start(skb, CTA_EXPECT_MASK | NLA_F_NESTED);
+	if (!nest_parms)
+		goto nla_put_failure;
 
 	l3proto = nf_ct_l3proto_find_get(tuple->src.l3num);
 	ret = ctnetlink_dump_tuples_ip(skb, &m, l3proto);
 	nf_ct_l3proto_put(l3proto);
 
 	if (unlikely(ret < 0))
-		goto nfattr_failure;
+		goto nla_put_failure;
 
 	l4proto = nf_ct_l4proto_find_get(tuple->src.l3num, tuple->dst.protonum);
 	ret = ctnetlink_dump_tuples_proto(skb, &m, l4proto);
 	nf_ct_l4proto_put(l4proto);
 	if (unlikely(ret < 0))
-		goto nfattr_failure;
+		goto nla_put_failure;
 
-	NFA_NEST_END(skb, nest_parms);
+	nla_nest_end(skb, nest_parms);
 
 	return 0;
 
-nfattr_failure:
+nla_put_failure:
 	return -1;
 }
 
@@ -1139,20 +1166,20 @@ ctnetlink_exp_dump_expect(struct sk_buff *skb,
 	__be32 id = htonl(exp->id);
 
 	if (ctnetlink_exp_dump_tuple(skb, &exp->tuple, CTA_EXPECT_TUPLE) < 0)
-		goto nfattr_failure;
+		goto nla_put_failure;
 	if (ctnetlink_exp_dump_mask(skb, &exp->tuple, &exp->mask) < 0)
-		goto nfattr_failure;
+		goto nla_put_failure;
 	if (ctnetlink_exp_dump_tuple(skb,
 				 &master->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
 				 CTA_EXPECT_MASTER) < 0)
-		goto nfattr_failure;
+		goto nla_put_failure;
 
-	NFA_PUT(skb, CTA_EXPECT_TIMEOUT, sizeof(timeout), &timeout);
-	NFA_PUT(skb, CTA_EXPECT_ID, sizeof(u_int32_t), &id);
+	NLA_PUT(skb, CTA_EXPECT_TIMEOUT, sizeof(timeout), &timeout);
+	NLA_PUT(skb, CTA_EXPECT_ID, sizeof(u_int32_t), &id);
 
 	return 0;
 
-nfattr_failure:
+nla_put_failure:
 	return -1;
 }
 
@@ -1176,13 +1203,13 @@ ctnetlink_exp_fill_info(struct sk_buff *skb, u32 pid, u32 seq,
 	nfmsg->res_id	    = 0;
 
 	if (ctnetlink_exp_dump_expect(skb, exp) < 0)
-		goto nfattr_failure;
+		goto nla_put_failure;
 
 	nlh->nlmsg_len = skb_tail_pointer(skb) - b;
 	return skb->len;
 
 nlmsg_failure:
-nfattr_failure:
+nla_put_failure:
 	nlmsg_trim(skb, b);
 	return -1;
 }
@@ -1224,14 +1251,14 @@ static int ctnetlink_expect_event(struct notifier_block *this,
 	nfmsg->res_id	    = 0;
 
 	if (ctnetlink_exp_dump_expect(skb, exp) < 0)
-		goto nfattr_failure;
+		goto nla_put_failure;
 
 	nlh->nlmsg_len = skb->tail - b;
 	nfnetlink_send(skb, 0, NFNLGRP_CONNTRACK_EXP_NEW, 0);
 	return NOTIFY_DONE;
 
 nlmsg_failure:
-nfattr_failure:
+nla_put_failure:
 	kfree_skb(skb);
 	return NOTIFY_DONE;
 }
@@ -1286,14 +1313,14 @@ out:
 	return skb->len;
 }
 
-static const size_t cta_min_exp[CTA_EXPECT_MAX] = {
-	[CTA_EXPECT_TIMEOUT-1]          = sizeof(u_int32_t),
-	[CTA_EXPECT_ID-1]               = sizeof(u_int32_t)
+static const size_t cta_min_exp[CTA_EXPECT_MAX+1] = {
+	[CTA_EXPECT_TIMEOUT]	= sizeof(u_int32_t),
+	[CTA_EXPECT_ID]		= sizeof(u_int32_t)
 };
 
 static int
 ctnetlink_get_expect(struct sock *ctnl, struct sk_buff *skb,
-		     struct nlmsghdr *nlh, struct nfattr *cda[])
+		     struct nlmsghdr *nlh, struct nlattr *cda[])
 {
 	struct nf_conntrack_tuple tuple;
 	struct nf_conntrack_expect *exp;
@@ -1311,7 +1338,7 @@ ctnetlink_get_expect(struct sock *ctnl, struct sk_buff *skb,
 					  ctnetlink_exp_done);
 	}
 
-	if (cda[CTA_EXPECT_MASTER-1])
+	if (cda[CTA_EXPECT_MASTER])
 		err = ctnetlink_parse_tuple(cda, &tuple, CTA_EXPECT_MASTER, u3);
 	else
 		return -EINVAL;
@@ -1323,8 +1350,8 @@ ctnetlink_get_expect(struct sock *ctnl, struct sk_buff *skb,
 	if (!exp)
 		return -ENOENT;
 
-	if (cda[CTA_EXPECT_ID-1]) {
-		__be32 id = *(__be32 *)NFA_DATA(cda[CTA_EXPECT_ID-1]);
+	if (cda[CTA_EXPECT_ID]) {
+		__be32 id = *(__be32 *)nla_data(cda[CTA_EXPECT_ID]);
 		if (exp->id != ntohl(id)) {
 			nf_ct_expect_put(exp);
 			return -ENOENT;
@@ -1355,7 +1382,7 @@ out:
 
 static int
 ctnetlink_del_expect(struct sock *ctnl, struct sk_buff *skb,
-		     struct nlmsghdr *nlh, struct nfattr *cda[])
+		     struct nlmsghdr *nlh, struct nlattr *cda[])
 {
 	struct nf_conntrack_expect *exp;
 	struct nf_conntrack_tuple tuple;
@@ -1369,7 +1396,7 @@ ctnetlink_del_expect(struct sock *ctnl, struct sk_buff *skb,
 	if (nfattr_bad_size(cda, CTA_EXPECT_MAX, cta_min_exp))
 		return -EINVAL;
 
-	if (cda[CTA_EXPECT_TUPLE-1]) {
+	if (cda[CTA_EXPECT_TUPLE]) {
 		/* delete a single expect by tuple */
 		err = ctnetlink_parse_tuple(cda, &tuple, CTA_EXPECT_TUPLE, u3);
 		if (err < 0)
@@ -1380,8 +1407,8 @@ ctnetlink_del_expect(struct sock *ctnl, struct sk_buff *skb,
 		if (!exp)
 			return -ENOENT;
 
-		if (cda[CTA_EXPECT_ID-1]) {
-			__be32 id = *(__be32 *)NFA_DATA(cda[CTA_EXPECT_ID-1]);
+		if (cda[CTA_EXPECT_ID]) {
+			__be32 id = *(__be32 *)nla_data(cda[CTA_EXPECT_ID]);
 			if (exp->id != ntohl(id)) {
 				nf_ct_expect_put(exp);
 				return -ENOENT;
@@ -1393,8 +1420,8 @@ ctnetlink_del_expect(struct sock *ctnl, struct sk_buff *skb,
 		/* have to put what we 'get' above.
 		 * after this line usage count == 0 */
 		nf_ct_expect_put(exp);
-	} else if (cda[CTA_EXPECT_HELP_NAME-1]) {
-		char *name = NFA_DATA(cda[CTA_EXPECT_HELP_NAME-1]);
+	} else if (cda[CTA_EXPECT_HELP_NAME]) {
+		char *name = nla_data(cda[CTA_EXPECT_HELP_NAME]);
 		struct nf_conn_help *m_help;
 
 		/* delete all expectations for this helper */
@@ -1436,13 +1463,13 @@ ctnetlink_del_expect(struct sock *ctnl, struct sk_buff *skb,
 	return 0;
 }
 static int
-ctnetlink_change_expect(struct nf_conntrack_expect *x, struct nfattr *cda[])
+ctnetlink_change_expect(struct nf_conntrack_expect *x, struct nlattr *cda[])
 {
 	return -EOPNOTSUPP;
 }
 
 static int
-ctnetlink_create_expect(struct nfattr *cda[], u_int8_t u3)
+ctnetlink_create_expect(struct nlattr *cda[], u_int8_t u3)
 {
 	struct nf_conntrack_tuple tuple, mask, master_tuple;
 	struct nf_conntrack_tuple_hash *h = NULL;
@@ -1499,7 +1526,7 @@ out:
 
 static int
 ctnetlink_new_expect(struct sock *ctnl, struct sk_buff *skb,
-		     struct nlmsghdr *nlh, struct nfattr *cda[])
+		     struct nlmsghdr *nlh, struct nlattr *cda[])
 {
 	struct nf_conntrack_tuple tuple;
 	struct nf_conntrack_expect *exp;
@@ -1510,9 +1537,9 @@ ctnetlink_new_expect(struct sock *ctnl, struct sk_buff *skb,
 	if (nfattr_bad_size(cda, CTA_EXPECT_MAX, cta_min_exp))
 		return -EINVAL;
 
-	if (!cda[CTA_EXPECT_TUPLE-1]
-	    || !cda[CTA_EXPECT_MASK-1]
-	    || !cda[CTA_EXPECT_MASTER-1])
+	if (!cda[CTA_EXPECT_TUPLE]
+	    || !cda[CTA_EXPECT_MASK]
+	    || !cda[CTA_EXPECT_MASTER])
 		return -EINVAL;
 
 	err = ctnetlink_parse_tuple(cda, &tuple, CTA_EXPECT_TUPLE, u3);
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index eb3fe74..1d167e6 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1067,93 +1067,96 @@ static int tcp_new(struct nf_conn *conntrack,
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nfnetlink_conntrack.h>
 
-static int tcp_to_nfattr(struct sk_buff *skb, struct nfattr *nfa,
+static int tcp_to_nfattr(struct sk_buff *skb, struct nlattr *nla,
 			 const struct nf_conn *ct)
 {
-	struct nfattr *nest_parms;
+	struct nlattr *nest_parms;
 	struct nf_ct_tcp_flags tmp = {};
 
 	read_lock_bh(&tcp_lock);
-	nest_parms = NFA_NEST(skb, CTA_PROTOINFO_TCP);
-	NFA_PUT(skb, CTA_PROTOINFO_TCP_STATE, sizeof(u_int8_t),
+	nest_parms = nla_nest_start(skb, CTA_PROTOINFO_TCP | NLA_F_NESTED);
+	if (!nest_parms)
+		goto nla_put_failure;
+
+	NLA_PUT(skb, CTA_PROTOINFO_TCP_STATE, sizeof(u_int8_t),
 		&ct->proto.tcp.state);
 
-	NFA_PUT(skb, CTA_PROTOINFO_TCP_WSCALE_ORIGINAL, sizeof(u_int8_t),
+	NLA_PUT(skb, CTA_PROTOINFO_TCP_WSCALE_ORIGINAL, sizeof(u_int8_t),
 		&ct->proto.tcp.seen[0].td_scale);
 
-	NFA_PUT(skb, CTA_PROTOINFO_TCP_WSCALE_REPLY, sizeof(u_int8_t),
+	NLA_PUT(skb, CTA_PROTOINFO_TCP_WSCALE_REPLY, sizeof(u_int8_t),
 		&ct->proto.tcp.seen[1].td_scale);
 
 	tmp.flags = ct->proto.tcp.seen[0].flags;
-	NFA_PUT(skb, CTA_PROTOINFO_TCP_FLAGS_ORIGINAL,
+	NLA_PUT(skb, CTA_PROTOINFO_TCP_FLAGS_ORIGINAL,
 		sizeof(struct nf_ct_tcp_flags), &tmp);
 
 	tmp.flags = ct->proto.tcp.seen[1].flags;
-	NFA_PUT(skb, CTA_PROTOINFO_TCP_FLAGS_REPLY,
+	NLA_PUT(skb, CTA_PROTOINFO_TCP_FLAGS_REPLY,
 		sizeof(struct nf_ct_tcp_flags), &tmp);
 	read_unlock_bh(&tcp_lock);
 
-	NFA_NEST_END(skb, nest_parms);
+	nla_nest_end(skb, nest_parms);
 
 	return 0;
 
-nfattr_failure:
+nla_put_failure:
 	read_unlock_bh(&tcp_lock);
 	return -1;
 }
 
-static const size_t cta_min_tcp[CTA_PROTOINFO_TCP_MAX] = {
-	[CTA_PROTOINFO_TCP_STATE-1]	      = sizeof(u_int8_t),
-	[CTA_PROTOINFO_TCP_WSCALE_ORIGINAL-1] = sizeof(u_int8_t),
-	[CTA_PROTOINFO_TCP_WSCALE_REPLY-1]    = sizeof(u_int8_t),
-	[CTA_PROTOINFO_TCP_FLAGS_ORIGINAL-1]  = sizeof(struct nf_ct_tcp_flags),
-	[CTA_PROTOINFO_TCP_FLAGS_REPLY-1]     = sizeof(struct nf_ct_tcp_flags)
+static const size_t cta_min_tcp[CTA_PROTOINFO_TCP_MAX+1] = {
+	[CTA_PROTOINFO_TCP_STATE]	    = sizeof(u_int8_t),
+	[CTA_PROTOINFO_TCP_WSCALE_ORIGINAL] = sizeof(u_int8_t),
+	[CTA_PROTOINFO_TCP_WSCALE_REPLY]    = sizeof(u_int8_t),
+	[CTA_PROTOINFO_TCP_FLAGS_ORIGINAL]  = sizeof(struct nf_ct_tcp_flags),
+	[CTA_PROTOINFO_TCP_FLAGS_REPLY]	    = sizeof(struct nf_ct_tcp_flags)
 };
 
-static int nfattr_to_tcp(struct nfattr *cda[], struct nf_conn *ct)
+static int nfattr_to_tcp(struct nlattr *cda[], struct nf_conn *ct)
 {
-	struct nfattr *attr = cda[CTA_PROTOINFO_TCP-1];
-	struct nfattr *tb[CTA_PROTOINFO_TCP_MAX];
+	struct nlattr *attr = cda[CTA_PROTOINFO_TCP];
+	struct nlattr *tb[CTA_PROTOINFO_TCP_MAX+1];
 
 	/* updates could not contain anything about the private
 	 * protocol info, in that case skip the parsing */
 	if (!attr)
 		return 0;
 
-	nfattr_parse_nested(tb, CTA_PROTOINFO_TCP_MAX, attr);
+	nla_parse_nested(tb, CTA_PROTOINFO_TCP_MAX, attr, NULL);
 
 	if (nfattr_bad_size(tb, CTA_PROTOINFO_TCP_MAX, cta_min_tcp))
 		return -EINVAL;
 
-	if (!tb[CTA_PROTOINFO_TCP_STATE-1])
+	if (!tb[CTA_PROTOINFO_TCP_STATE])
 		return -EINVAL;
 
 	write_lock_bh(&tcp_lock);
 	ct->proto.tcp.state =
-		*(u_int8_t *)NFA_DATA(tb[CTA_PROTOINFO_TCP_STATE-1]);
+		*(u_int8_t *)nla_data(tb[CTA_PROTOINFO_TCP_STATE]);
 
-	if (tb[CTA_PROTOINFO_TCP_FLAGS_ORIGINAL-1]) {
+	if (tb[CTA_PROTOINFO_TCP_FLAGS_ORIGINAL]) {
 		struct nf_ct_tcp_flags *attr =
-			NFA_DATA(tb[CTA_PROTOINFO_TCP_FLAGS_ORIGINAL-1]);
+			nla_data(tb[CTA_PROTOINFO_TCP_FLAGS_ORIGINAL]);
 		ct->proto.tcp.seen[0].flags &= ~attr->mask;
 		ct->proto.tcp.seen[0].flags |= attr->flags & attr->mask;
 	}
 
-	if (tb[CTA_PROTOINFO_TCP_FLAGS_REPLY-1]) {
+	if (tb[CTA_PROTOINFO_TCP_FLAGS_REPLY]) {
 		struct nf_ct_tcp_flags *attr =
-			NFA_DATA(tb[CTA_PROTOINFO_TCP_FLAGS_REPLY-1]);
+			nla_data(tb[CTA_PROTOINFO_TCP_FLAGS_REPLY]);
 		ct->proto.tcp.seen[1].flags &= ~attr->mask;
 		ct->proto.tcp.seen[1].flags |= attr->flags & attr->mask;
 	}
 
-	if (tb[CTA_PROTOINFO_TCP_WSCALE_ORIGINAL-1] &&
-	    tb[CTA_PROTOINFO_TCP_WSCALE_REPLY-1] &&
+	if (tb[CTA_PROTOINFO_TCP_WSCALE_ORIGINAL] &&
+	    tb[CTA_PROTOINFO_TCP_WSCALE_REPLY] &&
 	    ct->proto.tcp.seen[0].flags & IP_CT_TCP_FLAG_WINDOW_SCALE &&
 	    ct->proto.tcp.seen[1].flags & IP_CT_TCP_FLAG_WINDOW_SCALE) {
 		ct->proto.tcp.seen[0].td_scale = *(u_int8_t *)
-			NFA_DATA(tb[CTA_PROTOINFO_TCP_WSCALE_ORIGINAL-1]);
+			nla_data(tb[CTA_PROTOINFO_TCP_WSCALE_ORIGINAL]);
 		ct->proto.tcp.seen[1].td_scale = *(u_int8_t *)
-			NFA_DATA(tb[CTA_PROTOINFO_TCP_WSCALE_REPLY-1]);
+			nla_data(tb[CTA_PROTOINFO_TCP_WSCALE_REPLY]);
 	}
 	write_unlock_bh(&tcp_lock);
 
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 032224c..3cfa76b 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -111,44 +111,17 @@ nfnetlink_find_client(u_int16_t type, const struct nfnetlink_subsystem *ss)
 	return &ss->cb[cb_id];
 }
 
-void __nfa_fill(struct sk_buff *skb, int attrtype, int attrlen,
-		const void *data)
-{
-	struct nfattr *nfa;
-	int size = NFA_LENGTH(attrlen);
-
-	nfa = (struct nfattr *)skb_put(skb, NFA_ALIGN(size));
-	nfa->nfa_type = attrtype;
-	nfa->nfa_len  = size;
-	memcpy(NFA_DATA(nfa), data, attrlen);
-	memset(NFA_DATA(nfa) + attrlen, 0, NFA_ALIGN(size) - size);
-}
-EXPORT_SYMBOL_GPL(__nfa_fill);
-
-void nfattr_parse(struct nfattr *tb[], int maxattr, struct nfattr *nfa, int len)
-{
-	memset(tb, 0, sizeof(struct nfattr *) * maxattr);
-
-	while (NFA_OK(nfa, len)) {
-		unsigned flavor = NFA_TYPE(nfa);
-		if (flavor && flavor <= maxattr)
-			tb[flavor-1] = nfa;
-		nfa = NFA_NEXT(nfa, len);
-	}
-}
-EXPORT_SYMBOL_GPL(nfattr_parse);
-
 /**
  * nfnetlink_check_attributes - check and parse nfnetlink attributes
  *
  * subsys: nfnl subsystem for which this message is to be parsed
  * nlmsghdr: netlink message to be checked/parsed
- * cda: array of pointers, needs to be at least subsys->attr_count big
+ * cda: array of pointers, needs to be at least subsys->attr_count+1 big
  *
  */
 static int
 nfnetlink_check_attributes(const struct nfnetlink_subsystem *subsys,
-			   struct nlmsghdr *nlh, struct nfattr *cda[])
+			   struct nlmsghdr *nlh, struct nlattr *cda[])
 {
 	int min_len = NLMSG_SPACE(sizeof(struct nfgenmsg));
 	u_int8_t cb_id = NFNL_MSG_TYPE(nlh->nlmsg_type);
@@ -156,9 +129,9 @@ nfnetlink_check_attributes(const struct nfnetlink_subsystem *subsys,
 
 	/* check attribute lengths. */
 	if (likely(nlh->nlmsg_len > min_len)) {
-		struct nfattr *attr = NFM_NFA(NLMSG_DATA(nlh));
+		struct nlattr *attr = (void *)nlh + NLMSG_ALIGN(min_len);
 		int attrlen = nlh->nlmsg_len - NLMSG_ALIGN(min_len);
-		nfattr_parse(cda, attr_count, attr, attrlen);
+		nla_parse(cda, attr_count, attr, attrlen, NULL);
 	}
 
 	/* implicit: if nlmsg_len == min_len, we return 0, and an empty
@@ -230,9 +203,9 @@ static int nfnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 	{
 		u_int16_t attr_count =
 			ss->cb[NFNL_MSG_TYPE(nlh->nlmsg_type)].attr_count;
-		struct nfattr *cda[attr_count];
+		struct nlattr *cda[attr_count+1];
 
-		memset(cda, 0, sizeof(struct nfattr *) * attr_count);
+		memset(cda, 0, sizeof(struct nlattr *) * attr_count);
 
 		err = nfnetlink_check_attributes(ss, nlh, cda);
 		if (err < 0)
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index c3aa891..c7fd82f 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -244,7 +244,7 @@ nfulnl_set_mode(struct nfulnl_instance *inst, u_int8_t mode,
 
 	case NFULNL_COPY_PACKET:
 		inst->copy_mode = mode;
-		/* we're using struct nfattr which has 16bit nfa_len */
+		/* we're using struct nlattr which has 16bit nfa_len */
 		if (range > 0xffff)
 			inst->copy_range = 0xffff;
 		else
@@ -409,36 +409,36 @@ __build_packet_message(struct nfulnl_instance *inst,
 	pmsg.hw_protocol	= skb->protocol;
 	pmsg.hook		= hooknum;
 
-	NFA_PUT(inst->skb, NFULA_PACKET_HDR, sizeof(pmsg), &pmsg);
+	NLA_PUT(inst->skb, NFULA_PACKET_HDR, sizeof(pmsg), &pmsg);
 
 	if (prefix)
-		NFA_PUT(inst->skb, NFULA_PREFIX, plen, prefix);
+		NLA_PUT(inst->skb, NFULA_PREFIX, plen, prefix);
 
 	if (indev) {
 		tmp_uint = htonl(indev->ifindex);
 #ifndef CONFIG_BRIDGE_NETFILTER
-		NFA_PUT(inst->skb, NFULA_IFINDEX_INDEV, sizeof(tmp_uint),
+		NLA_PUT(inst->skb, NFULA_IFINDEX_INDEV, sizeof(tmp_uint),
 			&tmp_uint);
 #else
 		if (pf == PF_BRIDGE) {
 			/* Case 1: outdev is physical input device, we need to
 			 * look for bridge group (when called from
 			 * netfilter_bridge) */
-			NFA_PUT(inst->skb, NFULA_IFINDEX_PHYSINDEV,
+			NLA_PUT(inst->skb, NFULA_IFINDEX_PHYSINDEV,
 				sizeof(tmp_uint), &tmp_uint);
 			/* this is the bridge group "brX" */
 			tmp_uint = htonl(indev->br_port->br->dev->ifindex);
-			NFA_PUT(inst->skb, NFULA_IFINDEX_INDEV,
+			NLA_PUT(inst->skb, NFULA_IFINDEX_INDEV,
 				sizeof(tmp_uint), &tmp_uint);
 		} else {
 			/* Case 2: indev is bridge group, we need to look for
 			 * physical device (when called from ipv4) */
-			NFA_PUT(inst->skb, NFULA_IFINDEX_INDEV,
+			NLA_PUT(inst->skb, NFULA_IFINDEX_INDEV,
 				sizeof(tmp_uint), &tmp_uint);
 			if (skb->nf_bridge && skb->nf_bridge->physindev) {
 				tmp_uint =
 				    htonl(skb->nf_bridge->physindev->ifindex);
-				NFA_PUT(inst->skb, NFULA_IFINDEX_PHYSINDEV,
+				NLA_PUT(inst->skb, NFULA_IFINDEX_PHYSINDEV,
 					sizeof(tmp_uint), &tmp_uint);
 			}
 		}
@@ -448,28 +448,28 @@ __build_packet_message(struct nfulnl_instance *inst,
 	if (outdev) {
 		tmp_uint = htonl(outdev->ifindex);
 #ifndef CONFIG_BRIDGE_NETFILTER
-		NFA_PUT(inst->skb, NFULA_IFINDEX_OUTDEV, sizeof(tmp_uint),
+		NLA_PUT(inst->skb, NFULA_IFINDEX_OUTDEV, sizeof(tmp_uint),
 			&tmp_uint);
 #else
 		if (pf == PF_BRIDGE) {
 			/* Case 1: outdev is physical output device, we need to
 			 * look for bridge group (when called from
 			 * netfilter_bridge) */
-			NFA_PUT(inst->skb, NFULA_IFINDEX_PHYSOUTDEV,
+			NLA_PUT(inst->skb, NFULA_IFINDEX_PHYSOUTDEV,
 				sizeof(tmp_uint), &tmp_uint);
 			/* this is the bridge group "brX" */
 			tmp_uint = htonl(outdev->br_port->br->dev->ifindex);
-			NFA_PUT(inst->skb, NFULA_IFINDEX_OUTDEV,
+			NLA_PUT(inst->skb, NFULA_IFINDEX_OUTDEV,
 				sizeof(tmp_uint), &tmp_uint);
 		} else {
 			/* Case 2: indev is a bridge group, we need to look
 			 * for physical device (when called from ipv4) */
-			NFA_PUT(inst->skb, NFULA_IFINDEX_OUTDEV,
+			NLA_PUT(inst->skb, NFULA_IFINDEX_OUTDEV,
 				sizeof(tmp_uint), &tmp_uint);
 			if (skb->nf_bridge && skb->nf_bridge->physoutdev) {
 				tmp_uint =
 				    htonl(skb->nf_bridge->physoutdev->ifindex);
-				NFA_PUT(inst->skb, NFULA_IFINDEX_PHYSOUTDEV,
+				NLA_PUT(inst->skb, NFULA_IFINDEX_PHYSOUTDEV,
 					sizeof(tmp_uint), &tmp_uint);
 			}
 		}
@@ -478,7 +478,7 @@ __build_packet_message(struct nfulnl_instance *inst,
 
 	if (skb->mark) {
 		tmp_uint = htonl(skb->mark);
-		NFA_PUT(inst->skb, NFULA_MARK, sizeof(tmp_uint), &tmp_uint);
+		NLA_PUT(inst->skb, NFULA_MARK, sizeof(tmp_uint), &tmp_uint);
 	}
 
 	if (indev && skb->dev) {
@@ -486,7 +486,7 @@ __build_packet_message(struct nfulnl_instance *inst,
 		int len = dev_parse_header(skb, phw.hw_addr);
 		if (len > 0) {
 			phw.hw_addrlen = htons(len);
-			NFA_PUT(inst->skb, NFULA_HWADDR, sizeof(phw), &phw);
+			NLA_PUT(inst->skb, NFULA_HWADDR, sizeof(phw), &phw);
 		}
 	}
 
@@ -496,7 +496,7 @@ __build_packet_message(struct nfulnl_instance *inst,
 		ts.sec = cpu_to_be64(tv.tv_sec);
 		ts.usec = cpu_to_be64(tv.tv_usec);
 
-		NFA_PUT(inst->skb, NFULA_TIMESTAMP, sizeof(ts), &ts);
+		NLA_PUT(inst->skb, NFULA_TIMESTAMP, sizeof(ts), &ts);
 	}
 
 	/* UID */
@@ -504,9 +504,9 @@ __build_packet_message(struct nfulnl_instance *inst,
 		read_lock_bh(&skb->sk->sk_callback_lock);
 		if (skb->sk->sk_socket && skb->sk->sk_socket->file) {
 			__be32 uid = htonl(skb->sk->sk_socket->file->f_uid);
-			/* need to unlock here since NFA_PUT may goto */
+			/* need to unlock here since NLA_PUT may goto */
 			read_unlock_bh(&skb->sk->sk_callback_lock);
-			NFA_PUT(inst->skb, NFULA_UID, sizeof(uid), &uid);
+			NLA_PUT(inst->skb, NFULA_UID, sizeof(uid), &uid);
 		} else
 			read_unlock_bh(&skb->sk->sk_callback_lock);
 	}
@@ -514,28 +514,28 @@ __build_packet_message(struct nfulnl_instance *inst,
 	/* local sequence number */
 	if (inst->flags & NFULNL_CFG_F_SEQ) {
 		tmp_uint = htonl(inst->seq++);
-		NFA_PUT(inst->skb, NFULA_SEQ, sizeof(tmp_uint), &tmp_uint);
+		NLA_PUT(inst->skb, NFULA_SEQ, sizeof(tmp_uint), &tmp_uint);
 	}
 	/* global sequence number */
 	if (inst->flags & NFULNL_CFG_F_SEQ_GLOBAL) {
 		tmp_uint = htonl(atomic_inc_return(&global_seq));
-		NFA_PUT(inst->skb, NFULA_SEQ_GLOBAL, sizeof(tmp_uint), &tmp_uint);
+		NLA_PUT(inst->skb, NFULA_SEQ_GLOBAL, sizeof(tmp_uint), &tmp_uint);
 	}
 
 	if (data_len) {
-		struct nfattr *nfa;
-		int size = NFA_LENGTH(data_len);
+		struct nlattr *nla;
+		int size = nla_attr_size(data_len);
 
-		if (skb_tailroom(inst->skb) < (int)NFA_SPACE(data_len)) {
+		if (skb_tailroom(inst->skb) < nla_total_size(data_len)) {
 			printk(KERN_WARNING "nfnetlink_log: no tailroom!\n");
 			goto nlmsg_failure;
 		}
 
-		nfa = (struct nfattr *)skb_put(inst->skb, NFA_ALIGN(size));
-		nfa->nfa_type = NFULA_PAYLOAD;
-		nfa->nfa_len = size;
+		nla = (struct nlattr *)skb_put(inst->skb, nla_total_size(data_len));
+		nla->nla_type = NFULA_PAYLOAD;
+		nla->nla_len = size;
 
-		if (skb_copy_bits(skb, 0, NFA_DATA(nfa), data_len))
+		if (skb_copy_bits(skb, 0, nla_data(nla), data_len))
 			BUG();
 	}
 
@@ -544,7 +544,7 @@ __build_packet_message(struct nfulnl_instance *inst,
 
 nlmsg_failure:
 	UDEBUG("nlmsg_failure\n");
-nfattr_failure:
+nla_put_failure:
 	PRINTR(KERN_ERR "nfnetlink_log: error creating log nlmsg\n");
 	return -1;
 }
@@ -591,32 +591,31 @@ nfulnl_log_packet(unsigned int pf,
 	if (prefix)
 		plen = strlen(prefix) + 1;
 
-	/* all macros expand to constant values at compile time */
 	/* FIXME: do we want to make the size calculation conditional based on
 	 * what is actually present?  way more branches and checks, but more
 	 * memory efficient... */
-	size =    NLMSG_SPACE(sizeof(struct nfgenmsg))
-		+ NFA_SPACE(sizeof(struct nfulnl_msg_packet_hdr))
-		+ NFA_SPACE(sizeof(u_int32_t))	/* ifindex */
-		+ NFA_SPACE(sizeof(u_int32_t))	/* ifindex */
+	size =    NLMSG_ALIGN(sizeof(struct nfgenmsg))
+		+ nla_total_size(sizeof(struct nfulnl_msg_packet_hdr))
+		+ nla_total_size(sizeof(u_int32_t))	/* ifindex */
+		+ nla_total_size(sizeof(u_int32_t))	/* ifindex */
 #ifdef CONFIG_BRIDGE_NETFILTER
-		+ NFA_SPACE(sizeof(u_int32_t))	/* ifindex */
-		+ NFA_SPACE(sizeof(u_int32_t))	/* ifindex */
+		+ nla_total_size(sizeof(u_int32_t))	/* ifindex */
+		+ nla_total_size(sizeof(u_int32_t))	/* ifindex */
 #endif
-		+ NFA_SPACE(sizeof(u_int32_t))	/* mark */
-		+ NFA_SPACE(sizeof(u_int32_t))	/* uid */
-		+ NFA_SPACE(plen)		/* prefix */
-		+ NFA_SPACE(sizeof(struct nfulnl_msg_packet_hw))
-		+ NFA_SPACE(sizeof(struct nfulnl_msg_packet_timestamp));
+		+ nla_total_size(sizeof(u_int32_t))	/* mark */
+		+ nla_total_size(sizeof(u_int32_t))	/* uid */
+		+ nla_total_size(plen)			/* prefix */
+		+ nla_total_size(sizeof(struct nfulnl_msg_packet_hw))
+		+ nla_total_size(sizeof(struct nfulnl_msg_packet_timestamp));
 
 	UDEBUG("initial size=%u\n", size);
 
 	spin_lock_bh(&inst->lock);
 
 	if (inst->flags & NFULNL_CFG_F_SEQ)
-		size += NFA_SPACE(sizeof(u_int32_t));
+		size += nla_total_size(sizeof(u_int32_t));
 	if (inst->flags & NFULNL_CFG_F_SEQ_GLOBAL)
-		size += NFA_SPACE(sizeof(u_int32_t));
+		size += nla_total_size(sizeof(u_int32_t));
 
 	qthreshold = inst->qthreshold;
 	/* per-rule qthreshold overrides per-instance */
@@ -636,7 +635,7 @@ nfulnl_log_packet(unsigned int pf,
 		else
 			data_len = inst->copy_range;
 
-		size += NFA_SPACE(data_len);
+		size += nla_total_size(data_len);
 		UDEBUG("copy_packet, therefore size now %u\n", size);
 		break;
 
@@ -723,7 +722,7 @@ static struct notifier_block nfulnl_rtnl_notifier = {
 
 static int
 nfulnl_recv_unsupp(struct sock *ctnl, struct sk_buff *skb,
-		  struct nlmsghdr *nlh, struct nfattr *nfqa[])
+		  struct nlmsghdr *nlh, struct nlattr *nfqa[])
 {
 	return -ENOTSUPP;
 }
@@ -734,34 +733,34 @@ static struct nf_logger nfulnl_logger = {
 	.me	= THIS_MODULE,
 };
 
-static const int nfula_min[NFULA_MAX] = {
-	[NFULA_PACKET_HDR-1]	= sizeof(struct nfulnl_msg_packet_hdr),
-	[NFULA_MARK-1]		= sizeof(u_int32_t),
-	[NFULA_TIMESTAMP-1]	= sizeof(struct nfulnl_msg_packet_timestamp),
-	[NFULA_IFINDEX_INDEV-1]	= sizeof(u_int32_t),
-	[NFULA_IFINDEX_OUTDEV-1]= sizeof(u_int32_t),
-	[NFULA_IFINDEX_PHYSINDEV-1]	= sizeof(u_int32_t),
-	[NFULA_IFINDEX_PHYSOUTDEV-1]	= sizeof(u_int32_t),
-	[NFULA_HWADDR-1]	= sizeof(struct nfulnl_msg_packet_hw),
-	[NFULA_PAYLOAD-1]	= 0,
-	[NFULA_PREFIX-1]	= 0,
-	[NFULA_UID-1]		= sizeof(u_int32_t),
-	[NFULA_SEQ-1]		= sizeof(u_int32_t),
-	[NFULA_SEQ_GLOBAL-1]	= sizeof(u_int32_t),
+static const int nfula_min[NFULA_MAX+1] = {
+	[NFULA_PACKET_HDR]	= sizeof(struct nfulnl_msg_packet_hdr),
+	[NFULA_MARK]		= sizeof(u_int32_t),
+	[NFULA_TIMESTAMP]	= sizeof(struct nfulnl_msg_packet_timestamp),
+	[NFULA_IFINDEX_INDEV]	= sizeof(u_int32_t),
+	[NFULA_IFINDEX_OUTDEV]	= sizeof(u_int32_t),
+	[NFULA_IFINDEX_PHYSINDEV]	= sizeof(u_int32_t),
+	[NFULA_IFINDEX_PHYSOUTDEV]	= sizeof(u_int32_t),
+	[NFULA_HWADDR]		= sizeof(struct nfulnl_msg_packet_hw),
+	[NFULA_PAYLOAD]		= 0,
+	[NFULA_PREFIX]		= 0,
+	[NFULA_UID]		= sizeof(u_int32_t),
+	[NFULA_SEQ]		= sizeof(u_int32_t),
+	[NFULA_SEQ_GLOBAL]	= sizeof(u_int32_t),
 };
 
-static const int nfula_cfg_min[NFULA_CFG_MAX] = {
-	[NFULA_CFG_CMD-1]	= sizeof(struct nfulnl_msg_config_cmd),
-	[NFULA_CFG_MODE-1]	= sizeof(struct nfulnl_msg_config_mode),
-	[NFULA_CFG_TIMEOUT-1]	= sizeof(u_int32_t),
-	[NFULA_CFG_QTHRESH-1]	= sizeof(u_int32_t),
-	[NFULA_CFG_NLBUFSIZ-1]	= sizeof(u_int32_t),
-	[NFULA_CFG_FLAGS-1]	= sizeof(u_int16_t),
+static const int nfula_cfg_min[NFULA_CFG_MAX+1] = {
+	[NFULA_CFG_CMD]		= sizeof(struct nfulnl_msg_config_cmd),
+	[NFULA_CFG_MODE]	= sizeof(struct nfulnl_msg_config_mode),
+	[NFULA_CFG_TIMEOUT]	= sizeof(u_int32_t),
+	[NFULA_CFG_QTHRESH]	= sizeof(u_int32_t),
+	[NFULA_CFG_NLBUFSIZ]	= sizeof(u_int32_t),
+	[NFULA_CFG_FLAGS]	= sizeof(u_int16_t),
 };
 
 static int
 nfulnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
-		   struct nlmsghdr *nlh, struct nfattr *nfula[])
+		   struct nlmsghdr *nlh, struct nlattr *nfula[])
 {
 	struct nfgenmsg *nfmsg = NLMSG_DATA(nlh);
 	u_int16_t group_num = ntohs(nfmsg->res_id);
@@ -776,10 +775,10 @@ nfulnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 	}
 
 	inst = instance_lookup_get(group_num);
-	if (nfula[NFULA_CFG_CMD-1]) {
+	if (nfula[NFULA_CFG_CMD]) {
 		u_int8_t pf = nfmsg->nfgen_family;
 		struct nfulnl_msg_config_cmd *cmd;
-		cmd = NFA_DATA(nfula[NFULA_CFG_CMD-1]);
+		cmd = nla_data(nfula[NFULA_CFG_CMD]);
 		UDEBUG("found CFG_CMD for\n");
 
 		switch (cmd->command) {
@@ -842,38 +841,38 @@ nfulnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 		}
 	}
 
-	if (nfula[NFULA_CFG_MODE-1]) {
+	if (nfula[NFULA_CFG_MODE]) {
 		struct nfulnl_msg_config_mode *params;
-		params = NFA_DATA(nfula[NFULA_CFG_MODE-1]);
+		params = nla_data(nfula[NFULA_CFG_MODE]);
 
 		nfulnl_set_mode(inst, params->copy_mode,
 				ntohl(params->copy_range));
 	}
 
-	if (nfula[NFULA_CFG_TIMEOUT-1]) {
+	if (nfula[NFULA_CFG_TIMEOUT]) {
 		__be32 timeout =
-			*(__be32 *)NFA_DATA(nfula[NFULA_CFG_TIMEOUT-1]);
+			*(__be32 *)nla_data(nfula[NFULA_CFG_TIMEOUT]);
 
 		nfulnl_set_timeout(inst, ntohl(timeout));
 	}
 
-	if (nfula[NFULA_CFG_NLBUFSIZ-1]) {
+	if (nfula[NFULA_CFG_NLBUFSIZ]) {
 		__be32 nlbufsiz =
-			*(__be32 *)NFA_DATA(nfula[NFULA_CFG_NLBUFSIZ-1]);
+			*(__be32 *)nla_data(nfula[NFULA_CFG_NLBUFSIZ]);
 
 		nfulnl_set_nlbufsiz(inst, ntohl(nlbufsiz));
 	}
 
-	if (nfula[NFULA_CFG_QTHRESH-1]) {
+	if (nfula[NFULA_CFG_QTHRESH]) {
 		__be32 qthresh =
-			*(__be32 *)NFA_DATA(nfula[NFULA_CFG_QTHRESH-1]);
+			*(__be32 *)nla_data(nfula[NFULA_CFG_QTHRESH]);
 
 		nfulnl_set_qthresh(inst, ntohl(qthresh));
 	}
 
-	if (nfula[NFULA_CFG_FLAGS-1]) {
+	if (nfula[NFULA_CFG_FLAGS]) {
 		__be16 flags =
-			*(__be16 *)NFA_DATA(nfula[NFULA_CFG_FLAGS-1]);
+			*(__be16 *)nla_data(nfula[NFULA_CFG_FLAGS]);
 		nfulnl_set_flags(inst, ntohs(flags));
 	}
 
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index bfcc056..068e88b 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -299,7 +299,7 @@ __nfqnl_set_mode(struct nfqnl_instance *queue,
 
 	case NFQNL_COPY_PACKET:
 		queue->copy_mode = mode;
-		/* we're using struct nfattr which has 16bit nfa_len */
+		/* we're using struct nlattr which has 16bit nla_len */
 		if (range > 0xffff)
 			queue->copy_range = 0xffff;
 		else
@@ -353,18 +353,17 @@ nfqnl_build_packet_message(struct nfqnl_instance *queue,
 
 	QDEBUG("entered\n");
 
-	/* all macros expand to constant values at compile time */
-	size =    NLMSG_SPACE(sizeof(struct nfgenmsg)) +
-		+ NFA_SPACE(sizeof(struct nfqnl_msg_packet_hdr))
-		+ NFA_SPACE(sizeof(u_int32_t))	/* ifindex */
-		+ NFA_SPACE(sizeof(u_int32_t))	/* ifindex */
+	size =    NLMSG_ALIGN(sizeof(struct nfgenmsg))
+		+ nla_total_size(sizeof(struct nfqnl_msg_packet_hdr))
+		+ nla_total_size(sizeof(u_int32_t))	/* ifindex */
+		+ nla_total_size(sizeof(u_int32_t))	/* ifindex */
 #ifdef CONFIG_BRIDGE_NETFILTER
-		+ NFA_SPACE(sizeof(u_int32_t))	/* ifindex */
-		+ NFA_SPACE(sizeof(u_int32_t))	/* ifindex */
+		+ nla_total_size(sizeof(u_int32_t))	/* ifindex */
+		+ nla_total_size(sizeof(u_int32_t))	/* ifindex */
 #endif
-		+ NFA_SPACE(sizeof(u_int32_t))	/* mark */
-		+ NFA_SPACE(sizeof(struct nfqnl_msg_packet_hw))
-		+ NFA_SPACE(sizeof(struct nfqnl_msg_packet_timestamp));
+		+ nla_total_size(sizeof(u_int32_t))	/* mark */
+		+ nla_total_size(sizeof(struct nfqnl_msg_packet_hw))
+		+ nla_total_size(sizeof(struct nfqnl_msg_packet_timestamp));
 
 	outdev = entinf->outdev;
 
@@ -389,7 +388,7 @@ nfqnl_build_packet_message(struct nfqnl_instance *queue,
 		else
 			data_len = queue->copy_range;
 
-		size += NFA_SPACE(data_len);
+		size += nla_total_size(data_len);
 		break;
 
 	default:
@@ -417,33 +416,33 @@ nfqnl_build_packet_message(struct nfqnl_instance *queue,
 	pmsg.hw_protocol	= entskb->protocol;
 	pmsg.hook		= entinf->hook;
 
-	NFA_PUT(skb, NFQA_PACKET_HDR, sizeof(pmsg), &pmsg);
+	NLA_PUT(skb, NFQA_PACKET_HDR, sizeof(pmsg), &pmsg);
 
 	indev = entinf->indev;
 	if (indev) {
 		tmp_uint = htonl(indev->ifindex);
 #ifndef CONFIG_BRIDGE_NETFILTER
-		NFA_PUT(skb, NFQA_IFINDEX_INDEV, sizeof(tmp_uint), &tmp_uint);
+		NLA_PUT(skb, NFQA_IFINDEX_INDEV, sizeof(tmp_uint), &tmp_uint);
 #else
 		if (entinf->pf == PF_BRIDGE) {
 			/* Case 1: indev is physical input device, we need to
 			 * look for bridge group (when called from
 			 * netfilter_bridge) */
-			NFA_PUT(skb, NFQA_IFINDEX_PHYSINDEV, sizeof(tmp_uint),
+			NLA_PUT(skb, NFQA_IFINDEX_PHYSINDEV, sizeof(tmp_uint),
 				&tmp_uint);
 			/* this is the bridge group "brX" */
 			tmp_uint = htonl(indev->br_port->br->dev->ifindex);
-			NFA_PUT(skb, NFQA_IFINDEX_INDEV, sizeof(tmp_uint),
+			NLA_PUT(skb, NFQA_IFINDEX_INDEV, sizeof(tmp_uint),
 				&tmp_uint);
 		} else {
 			/* Case 2: indev is bridge group, we need to look for
 			 * physical device (when called from ipv4) */
-			NFA_PUT(skb, NFQA_IFINDEX_INDEV, sizeof(tmp_uint),
+			NLA_PUT(skb, NFQA_IFINDEX_INDEV, sizeof(tmp_uint),
 				&tmp_uint);
 			if (entskb->nf_bridge
 			    && entskb->nf_bridge->physindev) {
 				tmp_uint = htonl(entskb->nf_bridge->physindev->ifindex);
-				NFA_PUT(skb, NFQA_IFINDEX_PHYSINDEV,
+				NLA_PUT(skb, NFQA_IFINDEX_PHYSINDEV,
 					sizeof(tmp_uint), &tmp_uint);
 			}
 		}
@@ -453,27 +452,27 @@ nfqnl_build_packet_message(struct nfqnl_instance *queue,
 	if (outdev) {
 		tmp_uint = htonl(outdev->ifindex);
 #ifndef CONFIG_BRIDGE_NETFILTER
-		NFA_PUT(skb, NFQA_IFINDEX_OUTDEV, sizeof(tmp_uint), &tmp_uint);
+		NLA_PUT(skb, NFQA_IFINDEX_OUTDEV, sizeof(tmp_uint), &tmp_uint);
 #else
 		if (entinf->pf == PF_BRIDGE) {
 			/* Case 1: outdev is physical output device, we need to
 			 * look for bridge group (when called from
 			 * netfilter_bridge) */
-			NFA_PUT(skb, NFQA_IFINDEX_PHYSOUTDEV, sizeof(tmp_uint),
+			NLA_PUT(skb, NFQA_IFINDEX_PHYSOUTDEV, sizeof(tmp_uint),
 				&tmp_uint);
 			/* this is the bridge group "brX" */
 			tmp_uint = htonl(outdev->br_port->br->dev->ifindex);
-			NFA_PUT(skb, NFQA_IFINDEX_OUTDEV, sizeof(tmp_uint),
+			NLA_PUT(skb, NFQA_IFINDEX_OUTDEV, sizeof(tmp_uint),
 				&tmp_uint);
 		} else {
 			/* Case 2: outdev is bridge group, we need to look for
 			 * physical output device (when called from ipv4) */
-			NFA_PUT(skb, NFQA_IFINDEX_OUTDEV, sizeof(tmp_uint),
+			NLA_PUT(skb, NFQA_IFINDEX_OUTDEV, sizeof(tmp_uint),
 				&tmp_uint);
 			if (entskb->nf_bridge
 			    && entskb->nf_bridge->physoutdev) {
 				tmp_uint = htonl(entskb->nf_bridge->physoutdev->ifindex);
-				NFA_PUT(skb, NFQA_IFINDEX_PHYSOUTDEV,
+				NLA_PUT(skb, NFQA_IFINDEX_PHYSOUTDEV,
 					sizeof(tmp_uint), &tmp_uint);
 			}
 		}
@@ -482,7 +481,7 @@ nfqnl_build_packet_message(struct nfqnl_instance *queue,
 
 	if (entskb->mark) {
 		tmp_uint = htonl(entskb->mark);
-		NFA_PUT(skb, NFQA_MARK, sizeof(u_int32_t), &tmp_uint);
+		NLA_PUT(skb, NFQA_MARK, sizeof(u_int32_t), &tmp_uint);
 	}
 
 	if (indev && entskb->dev) {
@@ -490,7 +489,7 @@ nfqnl_build_packet_message(struct nfqnl_instance *queue,
 		int len = dev_parse_header(entskb, phw.hw_addr);
 		if (len) {
 			phw.hw_addrlen = htons(len);
-			NFA_PUT(skb, NFQA_HWADDR, sizeof(phw), &phw);
+			NLA_PUT(skb, NFQA_HWADDR, sizeof(phw), &phw);
 		}
 	}
 
@@ -500,23 +499,23 @@ nfqnl_build_packet_message(struct nfqnl_instance *queue,
 		ts.sec = cpu_to_be64(tv.tv_sec);
 		ts.usec = cpu_to_be64(tv.tv_usec);
 
-		NFA_PUT(skb, NFQA_TIMESTAMP, sizeof(ts), &ts);
+		NLA_PUT(skb, NFQA_TIMESTAMP, sizeof(ts), &ts);
 	}
 
 	if (data_len) {
-		struct nfattr *nfa;
-		int size = NFA_LENGTH(data_len);
+		struct nlattr *nla;
+		int size = nla_attr_size(data_len);
 
-		if (skb_tailroom(skb) < (int)NFA_SPACE(data_len)) {
+		if (skb_tailroom(skb) < nla_total_size(data_len)) {
 			printk(KERN_WARNING "nf_queue: no tailroom!\n");
 			goto nlmsg_failure;
 		}
 
-		nfa = (struct nfattr *)skb_put(skb, NFA_ALIGN(size));
-		nfa->nfa_type = NFQA_PAYLOAD;
-		nfa->nfa_len = size;
+		nla = (struct nlattr *)skb_put(skb, nla_total_size(data_len));
+		nla->nla_type = NFQA_PAYLOAD;
+		nla->nla_len = size;
 
-		if (skb_copy_bits(entskb, 0, NFA_DATA(nfa), data_len))
+		if (skb_copy_bits(entskb, 0, nla_data(nla), data_len))
 			BUG();
 	}
 
@@ -524,7 +523,7 @@ nfqnl_build_packet_message(struct nfqnl_instance *queue,
 	return skb;
 
 nlmsg_failure:
-nfattr_failure:
+nla_put_failure:
 	if (skb)
 		kfree_skb(skb);
 	*errp = -EINVAL;
@@ -778,15 +777,15 @@ static struct notifier_block nfqnl_rtnl_notifier = {
 	.notifier_call	= nfqnl_rcv_nl_event,
 };
 
-static const int nfqa_verdict_min[NFQA_MAX] = {
-	[NFQA_VERDICT_HDR-1]	= sizeof(struct nfqnl_msg_verdict_hdr),
-	[NFQA_MARK-1]		= sizeof(u_int32_t),
-	[NFQA_PAYLOAD-1]	= 0,
+static const int nfqa_verdict_min[NFQA_MAX+1] = {
+	[NFQA_VERDICT_HDR]	= sizeof(struct nfqnl_msg_verdict_hdr),
+	[NFQA_MARK]		= sizeof(u_int32_t),
+	[NFQA_PAYLOAD]		= 0,
 };
 
 static int
 nfqnl_recv_verdict(struct sock *ctnl, struct sk_buff *skb,
-		   struct nlmsghdr *nlh, struct nfattr *nfqa[])
+		   struct nlmsghdr *nlh, struct nlattr *nfqa[])
 {
 	struct nfgenmsg *nfmsg = NLMSG_DATA(nlh);
 	u_int16_t queue_num = ntohs(nfmsg->res_id);
@@ -811,12 +810,12 @@ nfqnl_recv_verdict(struct sock *ctnl, struct sk_buff *skb,
 		goto err_out_put;
 	}
 
-	if (!nfqa[NFQA_VERDICT_HDR-1]) {
+	if (!nfqa[NFQA_VERDICT_HDR]) {
 		err = -EINVAL;
 		goto err_out_put;
 	}
 
-	vhdr = NFA_DATA(nfqa[NFQA_VERDICT_HDR-1]);
+	vhdr = nla_data(nfqa[NFQA_VERDICT_HDR]);
 	verdict = ntohl(vhdr->verdict);
 
 	if ((verdict & NF_VERDICT_MASK) > NF_MAX_VERDICT) {
@@ -830,15 +829,15 @@ nfqnl_recv_verdict(struct sock *ctnl, struct sk_buff *skb,
 		goto err_out_put;
 	}
 
-	if (nfqa[NFQA_PAYLOAD-1]) {
-		if (nfqnl_mangle(NFA_DATA(nfqa[NFQA_PAYLOAD-1]),
-				 NFA_PAYLOAD(nfqa[NFQA_PAYLOAD-1]), entry) < 0)
+	if (nfqa[NFQA_PAYLOAD]) {
+		if (nfqnl_mangle(nla_data(nfqa[NFQA_PAYLOAD]),
+				 nla_len(nfqa[NFQA_PAYLOAD]), entry) < 0)
 			verdict = NF_DROP;
 	}
 
-	if (nfqa[NFQA_MARK-1])
+	if (nfqa[NFQA_MARK])
 		entry->skb->mark = ntohl(*(__be32 *)
-					 NFA_DATA(nfqa[NFQA_MARK-1]));
+					 nla_data(nfqa[NFQA_MARK]));
 
 	issue_verdict(entry, verdict);
 	instance_put(queue);
@@ -851,14 +850,14 @@ err_out_put:
 
 static int
 nfqnl_recv_unsupp(struct sock *ctnl, struct sk_buff *skb,
-		  struct nlmsghdr *nlh, struct nfattr *nfqa[])
+		  struct nlmsghdr *nlh, struct nlattr *nfqa[])
 {
 	return -ENOTSUPP;
 }
 
-static const int nfqa_cfg_min[NFQA_CFG_MAX] = {
-	[NFQA_CFG_CMD-1]	= sizeof(struct nfqnl_msg_config_cmd),
-	[NFQA_CFG_PARAMS-1]	= sizeof(struct nfqnl_msg_config_params),
+static const int nfqa_cfg_min[NFQA_CFG_MAX+1] = {
+	[NFQA_CFG_CMD]		= sizeof(struct nfqnl_msg_config_cmd),
+	[NFQA_CFG_PARAMS]	= sizeof(struct nfqnl_msg_config_params),
 };
 
 static struct nf_queue_handler nfqh = {
@@ -868,7 +867,7 @@ static struct nf_queue_handler nfqh = {
 
 static int
 nfqnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
-		  struct nlmsghdr *nlh, struct nfattr *nfqa[])
+		  struct nlmsghdr *nlh, struct nlattr *nfqa[])
 {
 	struct nfgenmsg *nfmsg = NLMSG_DATA(nlh);
 	u_int16_t queue_num = ntohs(nfmsg->res_id);
@@ -883,9 +882,9 @@ nfqnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 	}
 
 	queue = instance_lookup_get(queue_num);
-	if (nfqa[NFQA_CFG_CMD-1]) {
+	if (nfqa[NFQA_CFG_CMD]) {
 		struct nfqnl_msg_config_cmd *cmd;
-		cmd = NFA_DATA(nfqa[NFQA_CFG_CMD-1]);
+		cmd = nla_data(nfqa[NFQA_CFG_CMD]);
 		QDEBUG("found CFG_CMD\n");
 
 		switch (cmd->command) {
@@ -936,21 +935,21 @@ nfqnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 		}
 	}
 
-	if (nfqa[NFQA_CFG_PARAMS-1]) {
+	if (nfqa[NFQA_CFG_PARAMS]) {
 		struct nfqnl_msg_config_params *params;
 
 		if (!queue) {
 			ret = -ENOENT;
 			goto out_put;
 		}
-		params = NFA_DATA(nfqa[NFQA_CFG_PARAMS-1]);
+		params = nla_data(nfqa[NFQA_CFG_PARAMS]);
 		nfqnl_set_mode(queue, params->copy_mode,
 				ntohl(params->copy_range));
 	}
 
-	if (nfqa[NFQA_CFG_QUEUE_MAXLEN-1]) {
+	if (nfqa[NFQA_CFG_QUEUE_MAXLEN]) {
 		__be32 *queue_maxlen;
-		queue_maxlen = NFA_DATA(nfqa[NFQA_CFG_QUEUE_MAXLEN-1]);
+		queue_maxlen = nla_data(nfqa[NFQA_CFG_QUEUE_MAXLEN]);
 		spin_lock_bh(&queue->lock);
 		queue->queue_maxlen = ntohl(*queue_maxlen);
 		spin_unlock_bh(&queue->lock);
