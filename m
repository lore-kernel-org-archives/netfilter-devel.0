From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 12/13]: x_tables: replace IPv4/IPv6 policy match by
	address family independant version
Date: Thu, 16 Feb 2006 22:32:26 +0100 (MET)
Message-ID: <20060216213226.6933.81840.sendpatchset@localhost.localdomain>
References: <20060216213207.6933.99672.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060216213207.6933.99672.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: x_tables: replace IPv4/IPv6 policy match by address family independant version

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 3a3198cc233706dcead7c9642201cc747579a677
tree 90d54c7679930d5121938657ae15e8399e2b2e79
parent 27e960bc61180f1028acd05990c8bcba688fc87f
author Patrick McHardy <kaber@trash.net> Thu, 16 Feb 2006 14:35:57 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 16 Feb 2006 14:35:57 +0100

 include/linux/netfilter/x_tables.h         |    4 +
 include/linux/netfilter/xt_policy.h        |   58 ++++++++
 include/linux/netfilter_ipv4/ipt_policy.h  |   67 ++-------
 include/linux/netfilter_ipv6/ip6t_policy.h |   67 ++-------
 net/ipv4/netfilter/Kconfig                 |   10 -
 net/ipv4/netfilter/Makefile                |    1 
 net/ipv4/netfilter/ipt_policy.c            |  174 -----------------------
 net/ipv6/netfilter/Kconfig                 |   10 -
 net/ipv6/netfilter/Makefile                |    1 
 net/ipv6/netfilter/ip6t_policy.c           |  174 -----------------------
 net/netfilter/Kconfig                      |   10 +
 net/netfilter/Makefile                     |    1 
 net/netfilter/xt_policy.c                  |  209 ++++++++++++++++++++++++++++
 13 files changed, 312 insertions(+), 474 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 2fdbc4a..46a0f97 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -126,6 +126,8 @@ struct xt_match
 	unsigned int matchsize;
 	unsigned int hooks;
 	unsigned short proto;
+
+	unsigned short family;
 	u_int8_t revision;
 };
 
@@ -169,6 +171,8 @@ struct xt_target
 	unsigned int targetsize;
 	unsigned int hooks;
 	unsigned short proto;
+
+	unsigned short family;
 	u_int8_t revision;
 };
 
diff --git a/include/linux/netfilter/xt_policy.h b/include/linux/netfilter/xt_policy.h
new file mode 100644
index 0000000..a8132ec
--- /dev/null
+++ b/include/linux/netfilter/xt_policy.h
@@ -0,0 +1,58 @@
+#ifndef _XT_POLICY_H
+#define _XT_POLICY_H
+
+#define XT_POLICY_MAX_ELEM	4
+
+enum xt_policy_flags
+{
+	XT_POLICY_MATCH_IN	= 0x1,
+	XT_POLICY_MATCH_OUT	= 0x2,
+	XT_POLICY_MATCH_NONE	= 0x4,
+	XT_POLICY_MATCH_STRICT	= 0x8,
+};
+
+enum xt_policy_modes
+{
+	XT_POLICY_MODE_TRANSPORT,
+	XT_POLICY_MODE_TUNNEL
+};
+
+struct xt_policy_spec
+{
+	u_int8_t	saddr:1,
+			daddr:1,
+			proto:1,
+			mode:1,
+			spi:1,
+			reqid:1;
+};
+
+union xt_policy_addr
+{
+	struct in_addr	a4;
+	struct in6_addr	a6;
+};
+
+struct xt_policy_elem
+{
+	union xt_policy_addr	saddr;
+	union xt_policy_addr	smask;
+	union xt_policy_addr	daddr;
+	union xt_policy_addr	dmask;
+	u_int32_t		spi;
+	u_int32_t		reqid;
+	u_int8_t		proto;
+	u_int8_t		mode;
+
+	struct xt_policy_spec	match;
+	struct xt_policy_spec	invert;
+};
+
+struct xt_policy_info
+{
+	struct xt_policy_elem pol[XT_POLICY_MAX_ELEM];
+	u_int16_t flags;
+	u_int16_t len;
+};
+
+#endif /* _XT_POLICY_H */
diff --git a/include/linux/netfilter_ipv4/ipt_policy.h b/include/linux/netfilter_ipv4/ipt_policy.h
index a3f6eff..b9478a2 100644
--- a/include/linux/netfilter_ipv4/ipt_policy.h
+++ b/include/linux/netfilter_ipv4/ipt_policy.h
@@ -1,58 +1,21 @@
 #ifndef _IPT_POLICY_H
 #define _IPT_POLICY_H
 
-#define IPT_POLICY_MAX_ELEM	4
+#define IPT_POLICY_MAX_ELEM		XT_POLICY_MAX_ELEM
 
-enum ipt_policy_flags
-{
-	IPT_POLICY_MATCH_IN	= 0x1,
-	IPT_POLICY_MATCH_OUT	= 0x2,
-	IPT_POLICY_MATCH_NONE	= 0x4,
-	IPT_POLICY_MATCH_STRICT	= 0x8,
-};
-
-enum ipt_policy_modes
-{
-	IPT_POLICY_MODE_TRANSPORT,
-	IPT_POLICY_MODE_TUNNEL
-};
-
-struct ipt_policy_spec
-{
-	u_int8_t	saddr:1,
-			daddr:1,
-			proto:1,
-			mode:1,
-			spi:1,
-			reqid:1;
-};
-
-union ipt_policy_addr
-{
-	struct in_addr	a4;
-	struct in6_addr	a6;
-};
-
-struct ipt_policy_elem
-{
-	union ipt_policy_addr	saddr;
-	union ipt_policy_addr	smask;
-	union ipt_policy_addr	daddr;
-	union ipt_policy_addr	dmask;
-	u_int32_t		spi;
-	u_int32_t		reqid;
-	u_int8_t		proto;
-	u_int8_t		mode;
-
-	struct ipt_policy_spec	match;
-	struct ipt_policy_spec	invert;
-};
-
-struct ipt_policy_info
-{
-	struct ipt_policy_elem pol[IPT_POLICY_MAX_ELEM];
-	u_int16_t flags;
-	u_int16_t len;
-};
+/* ipt_policy_flags */
+#define IPT_POLICY_MATCH_IN		XT_POLICY_MATCH_IN
+#define IPT_POLICY_MATCH_OUT		XT_POLICY_MATCH_OUT
+#define IPT_POLICY_MATCH_NONE		XT_POLICY_MATCH_NONE
+#define IPT_POLICY_MATCH_STRICT		XT_POLICY_MATCH_STRICT
+
+/* ipt_policy_modes */
+#define IPT_POLICY_MODE_TRANSPORT	XT_POLICY_MODE_TRANSPORT
+#define IPT_POLICY_MODE_TUNNEL		XT_POLICY_MODE_TUNNEL
+
+#define ipt_policy_spec			xt_policy_spec
+#define ipt_policy_addr			xt_policy_addr
+#define ipt_policy_elem			xt_policy_elem
+#define ipt_policy_info			xt_policy_info
 
 #endif /* _IPT_POLICY_H */
diff --git a/include/linux/netfilter_ipv6/ip6t_policy.h b/include/linux/netfilter_ipv6/ip6t_policy.h
index 671bd81..6bab316 100644
--- a/include/linux/netfilter_ipv6/ip6t_policy.h
+++ b/include/linux/netfilter_ipv6/ip6t_policy.h
@@ -1,58 +1,21 @@
 #ifndef _IP6T_POLICY_H
 #define _IP6T_POLICY_H
 
-#define IP6T_POLICY_MAX_ELEM	4
+#define IP6T_POLICY_MAX_ELEM		XT_POLICY_MAX_ELEM
 
-enum ip6t_policy_flags
-{
-	IP6T_POLICY_MATCH_IN		= 0x1,
-	IP6T_POLICY_MATCH_OUT		= 0x2,
-	IP6T_POLICY_MATCH_NONE		= 0x4,
-	IP6T_POLICY_MATCH_STRICT	= 0x8,
-};
-
-enum ip6t_policy_modes
-{
-	IP6T_POLICY_MODE_TRANSPORT,
-	IP6T_POLICY_MODE_TUNNEL
-};
-
-struct ip6t_policy_spec
-{
-	u_int8_t	saddr:1,
-			daddr:1,
-			proto:1,
-			mode:1,
-			spi:1,
-			reqid:1;
-};
-
-union ip6t_policy_addr
-{
-	struct in_addr	a4;
-	struct in6_addr	a6;
-};
-
-struct ip6t_policy_elem
-{
-	union ip6t_policy_addr	saddr;
-	union ip6t_policy_addr	smask;
-	union ip6t_policy_addr	daddr;
-	union ip6t_policy_addr	dmask;
-	u_int32_t		spi;
-	u_int32_t		reqid;
-	u_int8_t		proto;
-	u_int8_t		mode;
-
-	struct ip6t_policy_spec	match;
-	struct ip6t_policy_spec	invert;
-};
-
-struct ip6t_policy_info
-{
-	struct ip6t_policy_elem pol[IP6T_POLICY_MAX_ELEM];
-	u_int16_t flags;
-	u_int16_t len;
-};
+/* ip6t_policy_flags */
+#define IP6T_POLICY_MATCH_IN		XT_POLICY_MATCH_IN
+#define IP6T_POLICY_MATCH_OUT		XT_POLICY_MATCH_OUT
+#define IP6T_POLICY_MATCH_NONE		XT_POLICY_MATCH_NONE
+#define IP6T_POLICY_MATCH_STRICT	XT_POLICY_MATCH_STRICT
+
+/* ip6t_policy_modes */
+#define IP6T_POLICY_MODE_TRANSPORT	XT_POLICY_MODE_TRANSPORT
+#define IP6T_POLICY_MODE_TUNNEL		XT_POLICY_MODE_TUNNEL
+
+#define ip6t_policy_spec		xt_policy_spec
+#define ip6t_policy_addr		xt_policy_addr
+#define ip6t_policy_elem		xt_policy_elem
+#define ip6t_policy_info		xt_policy_info
 
 #endif /* _IP6T_POLICY_H */
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index db78303..933ee7a 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -303,16 +303,6 @@ config IP_NF_MATCH_HASHLIMIT
 	  destination IP' or `500pps from any given source IP'  with a single
 	  IPtables rule.
 
-config IP_NF_MATCH_POLICY
-       tristate "IPsec policy match support"
-       depends on IP_NF_IPTABLES && XFRM
-       help
-         Policy matching allows you to match packets based on the
-         IPsec policy that was used during decapsulation/will
-         be used during encapsulation.
-
-         To compile it as a module, choose M here.  If unsure, say N.
-
 # `filter', generic and specific targets
 config IP_NF_FILTER
 	tristate "Packet filtering"
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index e5c5b32..3fe8092 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -57,7 +57,6 @@ obj-$(CONFIG_IP_NF_MATCH_DSCP) += ipt_ds
 obj-$(CONFIG_IP_NF_MATCH_AH_ESP) += ipt_ah.o ipt_esp.o
 obj-$(CONFIG_IP_NF_MATCH_TTL) += ipt_ttl.o
 obj-$(CONFIG_IP_NF_MATCH_ADDRTYPE) += ipt_addrtype.o
-obj-$(CONFIG_IP_NF_MATCH_POLICY) += ipt_policy.o
 
 # targets
 obj-$(CONFIG_IP_NF_TARGET_REJECT) += ipt_REJECT.o
diff --git a/net/ipv4/netfilter/ipt_policy.c b/net/ipv4/netfilter/ipt_policy.c
deleted file mode 100644
index b73f590..0000000
--- a/net/ipv4/netfilter/ipt_policy.c
+++ /dev/null
@@ -1,174 +0,0 @@
-/* IP tables module for matching IPsec policy
- *
- * Copyright (c) 2004,2005 Patrick McHardy, <kaber@trash.net>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/kernel.h>
-#include <linux/config.h>
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <linux/init.h>
-#include <net/xfrm.h>
-
-#include <linux/netfilter_ipv4.h>
-#include <linux/netfilter_ipv4/ip_tables.h>
-#include <linux/netfilter_ipv4/ipt_policy.h>
-
-MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
-MODULE_DESCRIPTION("IPtables IPsec policy matching module");
-MODULE_LICENSE("GPL");
-
-
-static inline int
-match_xfrm_state(struct xfrm_state *x, const struct ipt_policy_elem *e)
-{
-#define MATCH_ADDR(x,y,z)	(!e->match.x ||				     \
-		                 ((e->x.a4.s_addr == (e->y.a4.s_addr & (z))) \
-				  ^ e->invert.x))
-#define MATCH(x,y)		(!e->match.x || ((e->x == (y)) ^ e->invert.x))
-
-	return MATCH_ADDR(saddr, smask, x->props.saddr.a4) &&
-	       MATCH_ADDR(daddr, dmask, x->id.daddr.a4) &&
-	       MATCH(proto, x->id.proto) &&
-	       MATCH(mode, x->props.mode) &&
-	       MATCH(spi, x->id.spi) &&
-	       MATCH(reqid, x->props.reqid);
-}
-
-static int
-match_policy_in(const struct sk_buff *skb, const struct ipt_policy_info *info)
-{
-	const struct ipt_policy_elem *e;
-	struct sec_path *sp = skb->sp;
-	int strict = info->flags & IPT_POLICY_MATCH_STRICT;
-	int i, pos;
-
-	if (sp == NULL)
-		return -1;
-	if (strict && info->len != sp->len)
-		return 0;
-
-	for (i = sp->len - 1; i >= 0; i--) {
-		pos = strict ? i - sp->len + 1 : 0;
-		if (pos >= info->len)
-			return 0;
-		e = &info->pol[pos];
-
-		if (match_xfrm_state(sp->x[i].xvec, e)) {
-			if (!strict)
-				return 1;
-		} else if (strict)
-			return 0;
-	}
-
-	return strict ? 1 : 0;
-}
-
-static int
-match_policy_out(const struct sk_buff *skb, const struct ipt_policy_info *info)
-{
-	const struct ipt_policy_elem *e;
-	struct dst_entry *dst = skb->dst;
-	int strict = info->flags & IPT_POLICY_MATCH_STRICT;
-	int i, pos;
-
-	if (dst->xfrm == NULL)
-		return -1;
-
-	for (i = 0; dst && dst->xfrm; dst = dst->child, i++) {
-		pos = strict ? i : 0;
-		if (pos >= info->len)
-			return 0;
-		e = &info->pol[pos];
-
-		if (match_xfrm_state(dst->xfrm, e)) {
-			if (!strict)
-				return 1;
-		} else if (strict)
-			return 0;
-	}
-
-	return strict ? i == info->len : 0;
-}
-
-static int match(const struct sk_buff *skb,
-                 const struct net_device *in,
-                 const struct net_device *out,
-		 const struct xt_match *match,
-                 const void *matchinfo,
-                 int offset,
-                 unsigned int protoff,
-                 int *hotdrop)
-{
-	const struct ipt_policy_info *info = matchinfo;
-	int ret;
-
-	if (info->flags & IPT_POLICY_MATCH_IN)
-		ret = match_policy_in(skb, info);
-	else
-		ret = match_policy_out(skb, info);
-
-	if (ret < 0)
-		ret = info->flags & IPT_POLICY_MATCH_NONE ? 1 : 0;
-	else if (info->flags & IPT_POLICY_MATCH_NONE)
-		ret = 0;
-
-	return ret;
-}
-
-static int checkentry(const char *tablename, const void *ip_void,
-		      const struct xt_match *match,
-                      void *matchinfo, unsigned int matchsize,
-                      unsigned int hook_mask)
-{
-	struct ipt_policy_info *info = matchinfo;
-
-	if (!(info->flags & (IPT_POLICY_MATCH_IN|IPT_POLICY_MATCH_OUT))) {
-		printk(KERN_ERR "ipt_policy: neither incoming nor "
-		                "outgoing policy selected\n");
-		return 0;
-	}
-	if (hook_mask & (1 << NF_IP_PRE_ROUTING | 1 << NF_IP_LOCAL_IN)
-	    && info->flags & IPT_POLICY_MATCH_OUT) {
-		printk(KERN_ERR "ipt_policy: output policy not valid in "
-		                "PRE_ROUTING and INPUT\n");
-		return 0;
-	}
-	if (hook_mask & (1 << NF_IP_POST_ROUTING | 1 << NF_IP_LOCAL_OUT)
-	    && info->flags & IPT_POLICY_MATCH_IN) {
-		printk(KERN_ERR "ipt_policy: input policy not valid in "
-		                "POST_ROUTING and OUTPUT\n");
-		return 0;
-	}
-	if (info->len > IPT_POLICY_MAX_ELEM) {
-		printk(KERN_ERR "ipt_policy: too many policy elements\n");
-		return 0;
-	}
-
-	return 1;
-}
-
-static struct ipt_match policy_match = {
-	.name		= "policy",
-	.match		= match,
-	.matchsize	= sizeof(struct ipt_policy_info),
-	.checkentry 	= checkentry,
-	.me		= THIS_MODULE,
-};
-
-static int __init init(void)
-{
-	return ipt_register_match(&policy_match);
-}
-
-static void __exit fini(void)
-{
-	ipt_unregister_match(&policy_match);
-}
-
-module_init(init);
-module_exit(fini);
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index 2d6f8ec..98f7875 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -133,16 +133,6 @@ config IP6_NF_MATCH_EUI64
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
-config IP6_NF_MATCH_POLICY
-	tristate "IPsec policy match support"
-	depends on IP6_NF_IPTABLES && XFRM
-	help
-	  Policy matching allows you to match packets based on the
-	  IPsec policy that was used during decapsulation/will
-	  be used during encapsulation.
-
-	  To compile it as a module, choose M here.  If unsure, say N.
-
 # The targets
 config IP6_NF_FILTER
 	tristate "Packet filtering"
diff --git a/net/ipv6/netfilter/Makefile b/net/ipv6/netfilter/Makefile
index db6073c..8436a1a 100644
--- a/net/ipv6/netfilter/Makefile
+++ b/net/ipv6/netfilter/Makefile
@@ -9,7 +9,6 @@ obj-$(CONFIG_IP6_NF_MATCH_OPTS) += ip6t_
 obj-$(CONFIG_IP6_NF_MATCH_IPV6HEADER) += ip6t_ipv6header.o
 obj-$(CONFIG_IP6_NF_MATCH_FRAG) += ip6t_frag.o
 obj-$(CONFIG_IP6_NF_MATCH_AHESP) += ip6t_esp.o ip6t_ah.o
-obj-$(CONFIG_IP6_NF_MATCH_POLICY) += ip6t_policy.o
 obj-$(CONFIG_IP6_NF_MATCH_EUI64) += ip6t_eui64.o
 obj-$(CONFIG_IP6_NF_MATCH_MULTIPORT) += ip6t_multiport.o
 obj-$(CONFIG_IP6_NF_MATCH_OWNER) += ip6t_owner.o
diff --git a/net/ipv6/netfilter/ip6t_policy.c b/net/ipv6/netfilter/ip6t_policy.c
deleted file mode 100644
index f2a5997..0000000
--- a/net/ipv6/netfilter/ip6t_policy.c
+++ /dev/null
@@ -1,174 +0,0 @@
-/* IP tables module for matching IPsec policy
- *
- * Copyright (c) 2004,2005 Patrick McHardy, <kaber@trash.net>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/kernel.h>
-#include <linux/config.h>
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <linux/init.h>
-#include <net/xfrm.h>
-
-#include <linux/netfilter_ipv6.h>
-#include <linux/netfilter_ipv6/ip6_tables.h>
-#include <linux/netfilter_ipv6/ip6t_policy.h>
-
-MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
-MODULE_DESCRIPTION("IPtables IPsec policy matching module");
-MODULE_LICENSE("GPL");
-
-
-static inline int
-match_xfrm_state(struct xfrm_state *x, const struct ip6t_policy_elem *e)
-{
-#define MATCH_ADDR(x,y,z)	(!e->match.x ||				       \
-				 ((!ipv6_masked_addr_cmp(&e->x.a6, &e->y.a6,   \
-							 z))                   \
-				  ^ e->invert.x))
-#define MATCH(x,y)		(!e->match.x || ((e->x == (y)) ^ e->invert.x))
-	
-	return MATCH_ADDR(saddr, smask, (struct in6_addr *)&x->props.saddr.a6) &&
-	       MATCH_ADDR(daddr, dmask, (struct in6_addr *)&x->id.daddr.a6) &&
-	       MATCH(proto, x->id.proto) &&
-	       MATCH(mode, x->props.mode) &&
-	       MATCH(spi, x->id.spi) &&
-	       MATCH(reqid, x->props.reqid);
-}
-
-static int
-match_policy_in(const struct sk_buff *skb, const struct ip6t_policy_info *info)
-{
-	const struct ip6t_policy_elem *e;
-	struct sec_path *sp = skb->sp;
-	int strict = info->flags & IP6T_POLICY_MATCH_STRICT;
-	int i, pos;
-
-	if (sp == NULL)
-		return -1;
-	if (strict && info->len != sp->len)
-		return 0;
-
-	for (i = sp->len - 1; i >= 0; i--) {
-		pos = strict ? i - sp->len + 1 : 0;
-		if (pos >= info->len)
-			return 0;
-		e = &info->pol[pos];
-
-		if (match_xfrm_state(sp->x[i].xvec, e)) {
-			if (!strict)
-				return 1;
-		} else if (strict)
-			return 0;
-	}
-
-	return strict ? 1 : 0;
-}
-
-static int
-match_policy_out(const struct sk_buff *skb, const struct ip6t_policy_info *info)
-{
-	const struct ip6t_policy_elem *e;
-	struct dst_entry *dst = skb->dst;
-	int strict = info->flags & IP6T_POLICY_MATCH_STRICT;
-	int i, pos;
-
-	if (dst->xfrm == NULL)
-		return -1;
-
-	for (i = 0; dst && dst->xfrm; dst = dst->child, i++) {
-		pos = strict ? i : 0;
-		if (pos >= info->len)
-			return 0;
-		e = &info->pol[pos];
-
-		if (match_xfrm_state(dst->xfrm, e)) {
-			if (!strict)
-				return 1;
-		} else if (strict)
-			return 0;
-	}
-
-	return strict ? i == info->len : 0;
-}
-
-static int match(const struct sk_buff *skb,
-                 const struct net_device *in,
-                 const struct net_device *out,
-		 const struct xt_match *match,
-                 const void *matchinfo,
-		 int offset,
-		 unsigned int protoff,
-		 int *hotdrop)
-{
-	const struct ip6t_policy_info *info = matchinfo;
-	int ret;
-
-	if (info->flags & IP6T_POLICY_MATCH_IN)
-		ret = match_policy_in(skb, info);
-	else
-		ret = match_policy_out(skb, info);
-
-	if (ret < 0)
-		ret = info->flags & IP6T_POLICY_MATCH_NONE ? 1 : 0;
-	else if (info->flags & IP6T_POLICY_MATCH_NONE)
-		ret = 0;
-
-	return ret;
-}
-
-static int checkentry(const char *tablename, const void *ip_void,
-                      const struct xt_match *match, void *matchinfo,
-		      unsigned int matchsize, unsigned int hook_mask)
-{
-	struct ip6t_policy_info *info = matchinfo;
-
-	if (!(info->flags & (IP6T_POLICY_MATCH_IN|IP6T_POLICY_MATCH_OUT))) {
-		printk(KERN_ERR "ip6t_policy: neither incoming nor "
-		                "outgoing policy selected\n");
-		return 0;
-	}
-	if (hook_mask & (1 << NF_IP6_PRE_ROUTING | 1 << NF_IP6_LOCAL_IN)
-	    && info->flags & IP6T_POLICY_MATCH_OUT) {
-		printk(KERN_ERR "ip6t_policy: output policy not valid in "
-		                "PRE_ROUTING and INPUT\n");
-		return 0;
-	}
-	if (hook_mask & (1 << NF_IP6_POST_ROUTING | 1 << NF_IP6_LOCAL_OUT)
-	    && info->flags & IP6T_POLICY_MATCH_IN) {
-		printk(KERN_ERR "ip6t_policy: input policy not valid in "
-		                "POST_ROUTING and OUTPUT\n");
-		return 0;
-	}
-	if (info->len > IP6T_POLICY_MAX_ELEM) {
-		printk(KERN_ERR "ip6t_policy: too many policy elements\n");
-		return 0;
-	}
-
-	return 1;
-}
-
-static struct ip6t_match policy_match = {
-	.name		= "policy",
-	.match		= match,
-	.matchsize	= sizeof(struct ip6t_policy_info),
-	.checkentry 	= checkentry,
-	.me		= THIS_MODULE,
-};
-
-static int __init init(void)
-{
-	return ip6t_register_match(&policy_match);
-}
-
-static void __exit fini(void)
-{
-	ip6t_unregister_match(&policy_match);
-}
-
-module_init(init);
-module_exit(fini);
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index a8e5544..1e6e311 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -279,6 +279,16 @@ config NETFILTER_XT_MATCH_MARK
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config NETFILTER_XT_MATCH_POLICY
+	tristate 'IPsec "policy" match support'
+	depends on NETFILTER_XTABLES && XFRM
+	help
+	  Policy matching allows you to match packets based on the
+	  IPsec policy that was used during decapsulation/will 
+	  be used during encapsulation.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 config NETFILTER_XT_MATCH_PHYSDEV
 	tristate '"physdev" match support'
 	depends on NETFILTER_XTABLES && BRIDGE_NETFILTER
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 746172e..9558727 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -40,6 +40,7 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_LENGTH) 
 obj-$(CONFIG_NETFILTER_XT_MATCH_LIMIT) += xt_limit.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_MAC) += xt_mac.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_MARK) += xt_mark.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_POLICY) += xt_policy.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_PKTTYPE) += xt_pkttype.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_REALM) += xt_realm.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_SCTP) += xt_sctp.o
diff --git a/net/netfilter/xt_policy.c b/net/netfilter/xt_policy.c
new file mode 100644
index 0000000..1ec2208
--- /dev/null
+++ b/net/netfilter/xt_policy.c
@@ -0,0 +1,209 @@
+/* IP tables module for matching IPsec policy
+ *
+ * Copyright (c) 2004,2005 Patrick McHardy, <kaber@trash.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/config.h>
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/init.h>
+#include <net/xfrm.h>
+
+#include <linux/netfilter/xt_policy.h>
+#include <linux/netfilter/x_tables.h>
+
+MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
+MODULE_DESCRIPTION("Xtables IPsec policy matching module");
+MODULE_LICENSE("GPL");
+
+static inline int
+xt_addr_cmp(const union xt_policy_addr *a1, const union xt_policy_addr *m,
+	    const union xt_policy_addr *a2, unsigned short family)
+{
+	switch (family) {
+	case AF_INET:
+		return (a1->a4.s_addr ^ a2->a4.s_addr) & m->a4.s_addr;
+	case AF_INET6:
+		return ipv6_masked_addr_cmp(&a1->a6, &m->a6, &a2->a6);
+	}
+	return 0;
+}
+
+static inline int
+match_xfrm_state(struct xfrm_state *x, const struct xt_policy_elem *e,
+		 unsigned short family)
+{
+#define MATCH_ADDR(x,y,z)	(!e->match.x ||			       \
+				 (xt_addr_cmp(&e->x, &e->y, z, family) \
+				  ^ e->invert.x))
+#define MATCH(x,y)		(!e->match.x || ((e->x == (y)) ^ e->invert.x))
+
+	return MATCH_ADDR(saddr, smask, (union xt_policy_addr *)&x->props.saddr) &&
+	       MATCH_ADDR(daddr, dmask, (union xt_policy_addr *)&x->id.daddr.a4) &&
+	       MATCH(proto, x->id.proto) &&
+	       MATCH(mode, x->props.mode) &&
+	       MATCH(spi, x->id.spi) &&
+	       MATCH(reqid, x->props.reqid);
+}
+
+static int
+match_policy_in(const struct sk_buff *skb, const struct xt_policy_info *info,
+		unsigned short family)
+{
+	const struct xt_policy_elem *e;
+	struct sec_path *sp = skb->sp;
+	int strict = info->flags & XT_POLICY_MATCH_STRICT;
+	int i, pos;
+
+	if (sp == NULL)
+		return -1;
+	if (strict && info->len != sp->len)
+		return 0;
+
+	for (i = sp->len - 1; i >= 0; i--) {
+		pos = strict ? i - sp->len + 1 : 0;
+		if (pos >= info->len)
+			return 0;
+		e = &info->pol[pos];
+
+		if (match_xfrm_state(sp->x[i].xvec, e, family)) {
+			if (!strict)
+				return 1;
+		} else if (strict)
+			return 0;
+	}
+
+	return strict ? 1 : 0;
+}
+
+static int
+match_policy_out(const struct sk_buff *skb, const struct xt_policy_info *info,
+		 unsigned short family)
+{
+	const struct xt_policy_elem *e;
+	struct dst_entry *dst = skb->dst;
+	int strict = info->flags & XT_POLICY_MATCH_STRICT;
+	int i, pos;
+
+	if (dst->xfrm == NULL)
+		return -1;
+
+	for (i = 0; dst && dst->xfrm; dst = dst->child, i++) {
+		pos = strict ? i : 0;
+		if (pos >= info->len)
+			return 0;
+		e = &info->pol[pos];
+
+		if (match_xfrm_state(dst->xfrm, e, family)) {
+			if (!strict)
+				return 1;
+		} else if (strict)
+			return 0;
+	}
+
+	return strict ? i == info->len : 0;
+}
+
+static int match(const struct sk_buff *skb,
+                 const struct net_device *in,
+                 const struct net_device *out,
+                 const struct xt_match *match,
+                 const void *matchinfo,
+                 int offset,
+                 unsigned int protoff,
+                 int *hotdrop)
+{
+	const struct xt_policy_info *info = matchinfo;
+	int ret;
+
+	if (info->flags & XT_POLICY_MATCH_IN)
+		ret = match_policy_in(skb, info, match->family);
+	else
+		ret = match_policy_out(skb, info, match->family);
+
+	if (ret < 0)
+		ret = info->flags & XT_POLICY_MATCH_NONE ? 1 : 0;
+	else if (info->flags & XT_POLICY_MATCH_NONE)
+		ret = 0;
+
+	return ret;
+}
+
+static int checkentry(const char *tablename, const void *ip_void,
+                      const struct xt_match *match,
+                      void *matchinfo, unsigned int matchsize,
+                      unsigned int hook_mask)
+{
+	struct xt_policy_info *info = matchinfo;
+
+	if (!(info->flags & (XT_POLICY_MATCH_IN|XT_POLICY_MATCH_OUT))) {
+		printk(KERN_ERR "xt_policy: neither incoming nor "
+		                "outgoing policy selected\n");
+		return 0;
+	}
+	/* hook values are equal for IPv4 and IPv6 */
+	if (hook_mask & (1 << NF_IP_PRE_ROUTING | 1 << NF_IP_LOCAL_IN)
+	    && info->flags & XT_POLICY_MATCH_OUT) {
+		printk(KERN_ERR "xt_policy: output policy not valid in "
+		                "PRE_ROUTING and INPUT\n");
+		return 0;
+	}
+	if (hook_mask & (1 << NF_IP_POST_ROUTING | 1 << NF_IP_LOCAL_OUT)
+	    && info->flags & XT_POLICY_MATCH_IN) {
+		printk(KERN_ERR "xt_policy: input policy not valid in "
+		                "POST_ROUTING and OUTPUT\n");
+		return 0;
+	}
+	if (info->len > XT_POLICY_MAX_ELEM) {
+		printk(KERN_ERR "xt_policy: too many policy elements\n");
+		return 0;
+	}
+	return 1;
+}
+
+static struct xt_match policy_match = {
+	.name		= "policy",
+	.family		= AF_INET,
+	.match		= match,
+	.matchsize	= sizeof(struct xt_policy_info),
+	.checkentry 	= checkentry,
+	.me		= THIS_MODULE,
+};
+
+static struct xt_match policy6_match = {
+	.name		= "policy",
+	.family		= AF_INET6,
+	.match		= match,
+	.matchsize	= sizeof(struct xt_policy_info),
+	.checkentry	= checkentry,
+	.me		= THIS_MODULE,
+};
+
+static int __init init(void)
+{
+	int ret;
+
+	ret = xt_register_match(AF_INET, &policy_match);
+	if (ret)
+		return ret;
+	ret = xt_register_match(AF_INET6, &policy6_match);
+	if (ret)
+		xt_unregister_match(AF_INET, &policy_match);
+	return ret;
+}
+
+static void __exit fini(void)
+{
+	xt_unregister_match(AF_INET6, &policy6_match);
+	xt_unregister_match(AF_INET, &policy_match);
+}
+
+module_init(init);
+module_exit(fini);
+MODULE_ALIAS("ipt_policy");
+MODULE_ALIAS("ip6t_policy");
