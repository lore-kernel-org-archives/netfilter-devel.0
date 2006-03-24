From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 2/2] x_tables: unify IPv4/IPv6 multiport match
Date: Fri, 24 Mar 2006 15:26:57 +0900 (JST)
Message-ID: <200603240626.k2O6QwKw003253@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Fri_Mar_24_15_26_57_2006_605)--"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

----Next_Part(Fri_Mar_24_15_26_57_2006_605)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


This unifies ipt_multiport and ip6t_multiport to xt_multiport.

-- Yasuyuki Kozakai

----Next_Part(Fri_Mar_24_15_26_57_2006_605)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="02-xt_multiport.patch"

[NETFILTER] x_tables: unify IPv4/IPv6 multiport match

This unifies ipt_multiport and ip6t_multiport to xt_multiport.
As a result, this addes support for inversion and port range match
to IPv6 packets.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit 25cf4ad4d4d5c0bded49d09e92b969e6dec15263
tree a69c504c35fc7edfb556a17e60e4376b16bff52d
parent 25955cb65e976291c257fd41c992ec997e3fe1e0
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Fri, 24 Mar 2006 13:31:14 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Fri, 24 Mar 2006 13:31:14 +0900

 include/linux/netfilter/xt_multiport.h        |   30 ++
 include/linux/netfilter_ipv4/ipt_multiport.h  |   31 +-
 include/linux/netfilter_ipv6/ip6t_multiport.h |   25 +-
 net/ipv4/netfilter/Kconfig                    |   10 -
 net/ipv4/netfilter/Makefile                   |    1 
 net/ipv4/netfilter/ipt_multiport.c            |  195 ----------------
 net/ipv6/netfilter/Kconfig                    |   10 -
 net/ipv6/netfilter/Makefile                   |    1 
 net/ipv6/netfilter/ip6t_multiport.c           |  125 ----------
 net/netfilter/Kconfig                         |   10 +
 net/netfilter/Makefile                        |    1 
 net/netfilter/xt_multiport.c                  |  314 +++++++++++++++++++++++++
 12 files changed, 372 insertions(+), 381 deletions(-)

diff --git a/include/linux/netfilter/xt_multiport.h b/include/linux/netfilter/xt_multiport.h
new file mode 100644
index 0000000..d49ee41
--- /dev/null
+++ b/include/linux/netfilter/xt_multiport.h
@@ -0,0 +1,30 @@
+#ifndef _XT_MULTIPORT_H
+#define _XT_MULTIPORT_H
+
+enum xt_multiport_flags
+{
+	XT_MULTIPORT_SOURCE,
+	XT_MULTIPORT_DESTINATION,
+	XT_MULTIPORT_EITHER
+};
+
+#define XT_MULTI_PORTS	15
+
+/* Must fit inside union xt_matchinfo: 16 bytes */
+struct xt_multiport
+{
+	u_int8_t flags;				/* Type of comparison */
+	u_int8_t count;				/* Number of ports */
+	u_int16_t ports[XT_MULTI_PORTS];	/* Ports */
+};
+
+struct xt_multiport_v1
+{
+	u_int8_t flags;				/* Type of comparison */
+	u_int8_t count;				/* Number of ports */
+	u_int16_t ports[XT_MULTI_PORTS];	/* Ports */
+	u_int8_t pflags[XT_MULTI_PORTS];	/* Port flags */
+	u_int8_t invert;			/* Invert flag */
+};
+
+#endif /*_XT_MULTIPORT_H*/
diff --git a/include/linux/netfilter_ipv4/ipt_multiport.h b/include/linux/netfilter_ipv4/ipt_multiport.h
index e6b6fff..55fe85e 100644
--- a/include/linux/netfilter_ipv4/ipt_multiport.h
+++ b/include/linux/netfilter_ipv4/ipt_multiport.h
@@ -1,30 +1,15 @@
 #ifndef _IPT_MULTIPORT_H
 #define _IPT_MULTIPORT_H
-#include <linux/netfilter_ipv4/ip_tables.h>
 
-enum ipt_multiport_flags
-{
-	IPT_MULTIPORT_SOURCE,
-	IPT_MULTIPORT_DESTINATION,
-	IPT_MULTIPORT_EITHER
-};
+#include <linux/netfilter/xt_multiport.h>
 
-#define IPT_MULTI_PORTS	15
+#define IPT_MULTIPORT_SOURCE		XT_MULTIPORT_SOURCE
+#define IPT_MULTIPORT_DESTINATION	XT_MULTIPORT_DESTINATION
+#define IPT_MULTIPORT_EITHER		XT_MULTIPORT_EITHER
 
-/* Must fit inside union ipt_matchinfo: 16 bytes */
-struct ipt_multiport
-{
-	u_int8_t flags;				/* Type of comparison */
-	u_int8_t count;				/* Number of ports */
-	u_int16_t ports[IPT_MULTI_PORTS];	/* Ports */
-};
+#define IPT_MULTI_PORTS			XT_MULTI_PORTS
+
+#define ipt_multiport			xt_multiport
+#define ipt_multiport_v1		xt_multiport_v1
 
-struct ipt_multiport_v1
-{
-	u_int8_t flags;				/* Type of comparison */
-	u_int8_t count;				/* Number of ports */
-	u_int16_t ports[IPT_MULTI_PORTS];	/* Ports */
-	u_int8_t pflags[IPT_MULTI_PORTS];	/* Port flags */
-	u_int8_t invert;			/* Invert flag */
-};
 #endif /*_IPT_MULTIPORT_H*/
diff --git a/include/linux/netfilter_ipv6/ip6t_multiport.h b/include/linux/netfilter_ipv6/ip6t_multiport.h
index efe4954..042c926 100644
--- a/include/linux/netfilter_ipv6/ip6t_multiport.h
+++ b/include/linux/netfilter_ipv6/ip6t_multiport.h
@@ -1,21 +1,14 @@
 #ifndef _IP6T_MULTIPORT_H
 #define _IP6T_MULTIPORT_H
-#include <linux/netfilter_ipv6/ip6_tables.h>
 
-enum ip6t_multiport_flags
-{
-	IP6T_MULTIPORT_SOURCE,
-	IP6T_MULTIPORT_DESTINATION,
-	IP6T_MULTIPORT_EITHER
-};
+#include <linux/netfilter/xt_multiport.h>
 
-#define IP6T_MULTI_PORTS	15
+#define IP6T_MULTIPORT_SOURCE		XT_MULTIPORT_SOURCE
+#define IP6T_MULTIPORT_DESTINATION	XT_MULTIPORT_DESTINATION
+#define IP6T_MULTIPORT_EITHER		XT_MULTIPORT_EITHER
 
-/* Must fit inside union ip6t_matchinfo: 16 bytes */
-struct ip6t_multiport
-{
-	u_int8_t flags;				/* Type of comparison */
-	u_int8_t count;				/* Number of ports */
-	u_int16_t ports[IP6T_MULTI_PORTS];	/* Ports */
-};
-#endif /*_IPT_MULTIPORT_H*/
+#define IP6T_MULTI_PORTS		XT_MULTI_PORTS
+
+#define ip6t_multiport			xt_multiport
+
+#endif /*_IP6T_MULTIPORT_H*/
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index ebbd644..77855cc 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -221,16 +221,6 @@ config IP_NF_MATCH_IPRANGE
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
-config IP_NF_MATCH_MULTIPORT
-	tristate "Multiple port match support"
-	depends on IP_NF_IPTABLES
-	help
-	  Multiport matching allows you to match TCP or UDP packets based on
-	  a series of source or destination ports: normally a rule can only
-	  match a single range of ports.
-
-	  To compile it as a module, choose M here.  If unsure, say N.
-
 config IP_NF_MATCH_TOS
 	tristate "TOS match support"
 	depends on IP_NF_IPTABLES
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index 09ae167..461cb1e 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -53,7 +53,6 @@ obj-$(CONFIG_IP_NF_RAW) += iptable_raw.o
 # matches
 obj-$(CONFIG_IP_NF_MATCH_HASHLIMIT) += ipt_hashlimit.o
 obj-$(CONFIG_IP_NF_MATCH_IPRANGE) += ipt_iprange.o
-obj-$(CONFIG_IP_NF_MATCH_MULTIPORT) += ipt_multiport.o
 obj-$(CONFIG_IP_NF_MATCH_OWNER) += ipt_owner.o
 obj-$(CONFIG_IP_NF_MATCH_TOS) += ipt_tos.o
 obj-$(CONFIG_IP_NF_MATCH_RECENT) += ipt_recent.o
diff --git a/net/ipv4/netfilter/ipt_multiport.c b/net/ipv4/netfilter/ipt_multiport.c
deleted file mode 100644
index bd07f7c..0000000
--- a/net/ipv4/netfilter/ipt_multiport.c
+++ /dev/null
@@ -1,195 +0,0 @@
-/* Kernel module to match one of a list of TCP/UDP ports: ports are in
-   the same place so we can treat them as equal. */
-
-/* (C) 1999-2001 Paul `Rusty' Russell
- * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/module.h>
-#include <linux/types.h>
-#include <linux/udp.h>
-#include <linux/skbuff.h>
-
-#include <linux/netfilter_ipv4/ipt_multiport.h>
-#include <linux/netfilter_ipv4/ip_tables.h>
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
-MODULE_DESCRIPTION("iptables multiple port match module");
-
-#if 0
-#define duprintf(format, args...) printk(format , ## args)
-#else
-#define duprintf(format, args...)
-#endif
-
-/* Returns 1 if the port is matched by the test, 0 otherwise. */
-static inline int
-ports_match(const u_int16_t *portlist, enum ipt_multiport_flags flags,
-	    u_int8_t count, u_int16_t src, u_int16_t dst)
-{
-	unsigned int i;
-	for (i=0; i<count; i++) {
-		if (flags != IPT_MULTIPORT_DESTINATION
-		    && portlist[i] == src)
-			return 1;
-
-		if (flags != IPT_MULTIPORT_SOURCE
-		    && portlist[i] == dst)
-			return 1;
-	}
-
-	return 0;
-}
-
-/* Returns 1 if the port is matched by the test, 0 otherwise. */
-static inline int
-ports_match_v1(const struct ipt_multiport_v1 *minfo,
-	       u_int16_t src, u_int16_t dst)
-{
-	unsigned int i;
-	u_int16_t s, e;
-
-	for (i=0; i < minfo->count; i++) {
-		s = minfo->ports[i];
-
-		if (minfo->pflags[i]) {
-			/* range port matching */
-			e = minfo->ports[++i];
-			duprintf("src or dst matches with %d-%d?\n", s, e);
-
-			if (minfo->flags == IPT_MULTIPORT_SOURCE
-			    && src >= s && src <= e)
-				return 1 ^ minfo->invert;
-			if (minfo->flags == IPT_MULTIPORT_DESTINATION
-			    && dst >= s && dst <= e)
-				return 1 ^ minfo->invert;
-			if (minfo->flags == IPT_MULTIPORT_EITHER
-			    && ((dst >= s && dst <= e)
-				|| (src >= s && src <= e)))
-				return 1 ^ minfo->invert;
-		} else {
-			/* exact port matching */
-			duprintf("src or dst matches with %d?\n", s);
-
-			if (minfo->flags == IPT_MULTIPORT_SOURCE
-			    && src == s)
-				return 1 ^ minfo->invert;
-			if (minfo->flags == IPT_MULTIPORT_DESTINATION
-			    && dst == s)
-				return 1 ^ minfo->invert;
-			if (minfo->flags == IPT_MULTIPORT_EITHER
-			    && (src == s || dst == s))
-				return 1 ^ minfo->invert;
-		}
-	}
- 
- 	return minfo->invert;
-}
-
-static int
-match(const struct sk_buff *skb,
-      const struct net_device *in,
-      const struct net_device *out,
-      const struct xt_match *match,
-      const void *matchinfo,
-      int offset,
-      unsigned int protoff,
-      int *hotdrop)
-{
-	u16 _ports[2], *pptr;
-	const struct ipt_multiport *multiinfo = matchinfo;
-
-	if (offset)
-		return 0;
-
-	pptr = skb_header_pointer(skb, protoff,
-				  sizeof(_ports), _ports);
-	if (pptr == NULL) {
-		/* We've been asked to examine this packet, and we
-		 * can't.  Hence, no choice but to drop.
-		 */
-		duprintf("ipt_multiport:"
-			 " Dropping evil offset=0 tinygram.\n");
-		*hotdrop = 1;
-		return 0;
-	}
-
-	return ports_match(multiinfo->ports,
-			   multiinfo->flags, multiinfo->count,
-			   ntohs(pptr[0]), ntohs(pptr[1]));
-}
-
-static int
-match_v1(const struct sk_buff *skb,
-	 const struct net_device *in,
-	 const struct net_device *out,
-	 const struct xt_match *match,
-	 const void *matchinfo,
-	 int offset,
-	 unsigned int protoff,
-	 int *hotdrop)
-{
-	u16 _ports[2], *pptr;
-	const struct ipt_multiport_v1 *multiinfo = matchinfo;
-
-	if (offset)
-		return 0;
-
-	pptr = skb_header_pointer(skb, protoff,
-				  sizeof(_ports), _ports);
-	if (pptr == NULL) {
-		/* We've been asked to examine this packet, and we
-		 * can't.  Hence, no choice but to drop.
-		 */
-		duprintf("ipt_multiport:"
-			 " Dropping evil offset=0 tinygram.\n");
-		*hotdrop = 1;
-		return 0;
-	}
-
-	return ports_match_v1(multiinfo, ntohs(pptr[0]), ntohs(pptr[1]));
-}
-
-static struct ipt_match multiport_match = {
-	.name		= "multiport",
-	.revision	= 0,
-	.match		= match,
-	.matchsize	= sizeof(struct ipt_multiport),
-	.me		= THIS_MODULE,
-};
-
-static struct ipt_match multiport_match_v1 = {
-	.name		= "multiport",
-	.revision	= 1,
-	.match		= match_v1,
-	.matchsize	= sizeof(struct ipt_multiport_v1),
-	.me		= THIS_MODULE,
-};
-
-static int __init init(void)
-{
-	int err;
-
-	err = ipt_register_match(&multiport_match);
-	if (!err) {
-		err = ipt_register_match(&multiport_match_v1);
-		if (err)
-			ipt_unregister_match(&multiport_match);
-	}
-
-	return err;
-}
-
-static void __exit fini(void)
-{
-	ipt_unregister_match(&multiport_match);
-	ipt_unregister_match(&multiport_match_v1);
-}
-
-module_init(init);
-module_exit(fini);
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index bdd569f..4bc4e5b 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -87,16 +87,6 @@ config IP6_NF_MATCH_HL
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
-config IP6_NF_MATCH_MULTIPORT
-	tristate "Multiple port match support"
-	depends on IP6_NF_IPTABLES
-	help
-	  Multiport matching allows you to match TCP or UDP packets based on
-	  a series of source or destination ports: normally a rule can only
-	  match a single range of ports.
-
-	  To compile it as a module, choose M here.  If unsure, say N.
-
 config IP6_NF_MATCH_OWNER
 	tristate "Owner match support"
 	depends on IP6_NF_IPTABLES
diff --git a/net/ipv6/netfilter/Makefile b/net/ipv6/netfilter/Makefile
index c387170..eeeb57d 100644
--- a/net/ipv6/netfilter/Makefile
+++ b/net/ipv6/netfilter/Makefile
@@ -10,7 +10,6 @@ obj-$(CONFIG_IP6_NF_MATCH_IPV6HEADER) +=
 obj-$(CONFIG_IP6_NF_MATCH_FRAG) += ip6t_frag.o
 obj-$(CONFIG_IP6_NF_MATCH_AH) += ip6t_ah.o
 obj-$(CONFIG_IP6_NF_MATCH_EUI64) += ip6t_eui64.o
-obj-$(CONFIG_IP6_NF_MATCH_MULTIPORT) += ip6t_multiport.o
 obj-$(CONFIG_IP6_NF_MATCH_OWNER) += ip6t_owner.o
 obj-$(CONFIG_IP6_NF_FILTER) += ip6table_filter.o
 obj-$(CONFIG_IP6_NF_MANGLE) += ip6table_mangle.o
diff --git a/net/ipv6/netfilter/ip6t_multiport.c b/net/ipv6/netfilter/ip6t_multiport.c
deleted file mode 100644
index 752b65d..0000000
--- a/net/ipv6/netfilter/ip6t_multiport.c
+++ /dev/null
@@ -1,125 +0,0 @@
-/* Kernel module to match one of a list of TCP/UDP ports: ports are in
-   the same place so we can treat them as equal. */
-
-/* (C) 1999-2001 Paul `Rusty' Russell
- * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/module.h>
-#include <linux/types.h>
-#include <linux/udp.h>
-#include <linux/skbuff.h>
-#include <linux/in.h>
-
-#include <linux/netfilter_ipv6/ip6t_multiport.h>
-#include <linux/netfilter_ipv6/ip6_tables.h>
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
-MODULE_DESCRIPTION("ip6tables match for multiple ports");
-
-#if 0
-#define duprintf(format, args...) printk(format , ## args)
-#else
-#define duprintf(format, args...)
-#endif
-
-/* Returns 1 if the port is matched by the test, 0 otherwise. */
-static inline int
-ports_match(const u_int16_t *portlist, enum ip6t_multiport_flags flags,
-	    u_int8_t count, u_int16_t src, u_int16_t dst)
-{
-	unsigned int i;
-	for (i=0; i<count; i++) {
-		if (flags != IP6T_MULTIPORT_DESTINATION
-		    && portlist[i] == src)
-			return 1;
-
-		if (flags != IP6T_MULTIPORT_SOURCE
-		    && portlist[i] == dst)
-			return 1;
-	}
-
-	return 0;
-}
-
-static int
-match(const struct sk_buff *skb,
-      const struct net_device *in,
-      const struct net_device *out,
-      const struct xt_match *match,
-      const void *matchinfo,
-      int offset,
-      unsigned int protoff,
-      int *hotdrop)
-{
-	u16 _ports[2], *pptr;
-	const struct ip6t_multiport *multiinfo = matchinfo;
-
-	/* Must not be a fragment. */
-	if (offset)
-		return 0;
-
-	/* Must be big enough to read ports (both UDP and TCP have
-	   them at the start). */
-	pptr = skb_header_pointer(skb, protoff, sizeof(_ports), &_ports[0]);
-	if (pptr == NULL) {
-		/* We've been asked to examine this packet, and we
-		 * can't.  Hence, no choice but to drop.
-		 */
-		duprintf("ip6t_multiport:"
-			 " Dropping evil offset=0 tinygram.\n");
-		*hotdrop = 1;
-		return 0;
-	}
-
-	return ports_match(multiinfo->ports,
-			   multiinfo->flags, multiinfo->count,
-			   ntohs(pptr[0]), ntohs(pptr[1]));
-}
-
-/* Called when user tries to insert an entry of this type. */
-static int
-checkentry(const char *tablename,
-	   const void *info,
-	   const struct xt_match *match,
-	   void *matchinfo,
-	   unsigned int matchsize,
-	   unsigned int hook_mask)
-{
-	const struct ip6t_ip6 *ip = info;
-	const struct ip6t_multiport *multiinfo = matchinfo;
-
-	/* Must specify proto == TCP/UDP, no unknown flags or bad count */
-	return (ip->proto == IPPROTO_TCP || ip->proto == IPPROTO_UDP)
-		&& !(ip->invflags & IP6T_INV_PROTO)
-		&& (multiinfo->flags == IP6T_MULTIPORT_SOURCE
-		    || multiinfo->flags == IP6T_MULTIPORT_DESTINATION
-		    || multiinfo->flags == IP6T_MULTIPORT_EITHER)
-		&& multiinfo->count <= IP6T_MULTI_PORTS;
-}
-
-static struct ip6t_match multiport_match = {
-	.name		= "multiport",
-	.match		= match,
-	.matchsize	= sizeof(struct ip6t_multiport),
-	.checkentry	= checkentry,
-	.me		= THIS_MODULE,
-};
-
-static int __init init(void)
-{
-	return ip6t_register_match(&multiport_match);
-}
-
-static void __exit fini(void)
-{
-	ip6t_unregister_match(&multiport_match);
-}
-
-module_init(init);
-module_exit(fini);
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 5fe5189..e2893ef 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -298,6 +298,16 @@ config NETFILTER_XT_MATCH_POLICY
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config NETFILTER_XT_MATCH_MULTIPORT
+	tristate "Multiple port match support"
+	depends on NETFILTER_XTABLES
+	help
+	  Multiport matching allows you to match TCP or UDP packets based on
+	  a series of source or destination ports: normally a rule can only
+	  match a single range of ports.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 config NETFILTER_XT_MATCH_PHYSDEV
 	tristate '"physdev" match support'
 	depends on NETFILTER_XTABLES && BRIDGE_NETFILTER
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 8f02486..95b7e41 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -41,6 +41,7 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_LENGTH) 
 obj-$(CONFIG_NETFILTER_XT_MATCH_LIMIT) += xt_limit.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_MAC) += xt_mac.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_MARK) += xt_mark.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_MULTIPORT) += xt_multiport.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_POLICY) += xt_policy.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_PKTTYPE) += xt_pkttype.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_REALM) += xt_realm.o
diff --git a/net/netfilter/xt_multiport.c b/net/netfilter/xt_multiport.c
new file mode 100644
index 0000000..1e7cb61
--- /dev/null
+++ b/net/netfilter/xt_multiport.c
@@ -0,0 +1,314 @@
+/* Kernel module to match one of a list of TCP/UDP ports: ports are in
+   the same place so we can treat them as equal. */
+
+/* (C) 1999-2001 Paul `Rusty' Russell
+ * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/udp.h>
+#include <linux/skbuff.h>
+#include <linux/in.h>
+
+#include <linux/netfilter/xt_multiport.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv6/ip6_tables.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
+MODULE_DESCRIPTION("x_tables multiple port match module");
+MODULE_ALIAS("ipt_multiport");
+MODULE_ALIAS("ip6t_multiport");
+
+#if 0
+#define duprintf(format, args...) printk(format , ## args)
+#else
+#define duprintf(format, args...)
+#endif
+
+/* Returns 1 if the port is matched by the test, 0 otherwise. */
+static inline int
+ports_match(const u_int16_t *portlist, enum xt_multiport_flags flags,
+	    u_int8_t count, u_int16_t src, u_int16_t dst)
+{
+	unsigned int i;
+	for (i = 0; i < count; i++) {
+		if (flags != XT_MULTIPORT_DESTINATION && portlist[i] == src)
+			return 1;
+
+		if (flags != XT_MULTIPORT_SOURCE && portlist[i] == dst)
+			return 1;
+	}
+
+	return 0;
+}
+
+/* Returns 1 if the port is matched by the test, 0 otherwise. */
+static inline int
+ports_match_v1(const struct xt_multiport_v1 *minfo,
+	       u_int16_t src, u_int16_t dst)
+{
+	unsigned int i;
+	u_int16_t s, e;
+
+	for (i = 0; i < minfo->count; i++) {
+		s = minfo->ports[i];
+
+		if (minfo->pflags[i]) {
+			/* range port matching */
+			e = minfo->ports[++i];
+			duprintf("src or dst matches with %d-%d?\n", s, e);
+
+			if (minfo->flags == XT_MULTIPORT_SOURCE
+			    && src >= s && src <= e)
+				return 1 ^ minfo->invert;
+			if (minfo->flags == XT_MULTIPORT_DESTINATION
+			    && dst >= s && dst <= e)
+				return 1 ^ minfo->invert;
+			if (minfo->flags == XT_MULTIPORT_EITHER
+			    && ((dst >= s && dst <= e)
+				|| (src >= s && src <= e)))
+				return 1 ^ minfo->invert;
+		} else {
+			/* exact port matching */
+			duprintf("src or dst matches with %d?\n", s);
+
+			if (minfo->flags == XT_MULTIPORT_SOURCE
+			    && src == s)
+				return 1 ^ minfo->invert;
+			if (minfo->flags == XT_MULTIPORT_DESTINATION
+			    && dst == s)
+				return 1 ^ minfo->invert;
+			if (minfo->flags == XT_MULTIPORT_EITHER
+			    && (src == s || dst == s))
+				return 1 ^ minfo->invert;
+		}
+	}
+ 
+ 	return minfo->invert;
+}
+
+static int
+match(const struct sk_buff *skb,
+      const struct net_device *in,
+      const struct net_device *out,
+      const struct xt_match *match,
+      const void *matchinfo,
+      int offset,
+      unsigned int protoff,
+      int *hotdrop)
+{
+	u16 _ports[2], *pptr;
+	const struct xt_multiport *multiinfo = matchinfo;
+
+	if (offset)
+		return 0;
+
+	pptr = skb_header_pointer(skb, protoff, sizeof(_ports), _ports);
+	if (pptr == NULL) {
+		/* We've been asked to examine this packet, and we
+		 * can't.  Hence, no choice but to drop.
+		 */
+		duprintf("xt_multiport: Dropping evil offset=0 tinygram.\n");
+		*hotdrop = 1;
+		return 0;
+	}
+
+	return ports_match(multiinfo->ports,
+			   multiinfo->flags, multiinfo->count,
+			   ntohs(pptr[0]), ntohs(pptr[1]));
+}
+
+static int
+match_v1(const struct sk_buff *skb,
+	 const struct net_device *in,
+	 const struct net_device *out,
+	 const struct xt_match *match,
+	 const void *matchinfo,
+	 int offset,
+	 unsigned int protoff,
+	 int *hotdrop)
+{
+	u16 _ports[2], *pptr;
+	const struct xt_multiport_v1 *multiinfo = matchinfo;
+
+	if (offset)
+		return 0;
+
+	pptr = skb_header_pointer(skb, protoff, sizeof(_ports), _ports);
+	if (pptr == NULL) {
+		/* We've been asked to examine this packet, and we
+		 * can't.  Hence, no choice but to drop.
+		 */
+		duprintf("xt_multiport: Dropping evil offset=0 tinygram.\n");
+		*hotdrop = 1;
+		return 0;
+	}
+
+	return ports_match_v1(multiinfo, ntohs(pptr[0]), ntohs(pptr[1]));
+}
+
+static inline int
+check(u_int16_t proto,
+      u_int8_t ip_invflags,
+      u_int8_t match_flags,
+      u_int8_t count)
+{
+	/* Must specify proto == TCP/UDP, no unknown flags or bad count */
+	return (proto == IPPROTO_TCP || proto == IPPROTO_UDP)
+		&& !(ip_invflags & XT_INV_PROTO)
+		&& (match_flags == XT_MULTIPORT_SOURCE
+		    || match_flags == XT_MULTIPORT_DESTINATION
+		    || match_flags == XT_MULTIPORT_EITHER)
+		&& count <= XT_MULTI_PORTS;
+}
+
+/* Called when user tries to insert an entry of this type. */
+static int
+checkentry(const char *tablename,
+	   const void *info,
+	   const struct xt_match *match,
+	   void *matchinfo,
+	   unsigned int matchsize,
+	   unsigned int hook_mask)
+{
+	const struct ipt_ip *ip = info;
+	const struct xt_multiport *multiinfo = matchinfo;
+
+	return check(ip->proto, ip->invflags, multiinfo->flags,
+		     multiinfo->count);
+}
+
+static int
+checkentry_v1(const char *tablename,
+	      const void *info,
+	      const struct xt_match *match,
+	      void *matchinfo,
+	      unsigned int matchsize,
+	      unsigned int hook_mask)
+{
+	const struct ipt_ip *ip = info;
+	const struct xt_multiport_v1 *multiinfo = matchinfo;
+
+	return check(ip->proto, ip->invflags, multiinfo->flags,
+		     multiinfo->count);
+}
+
+static int
+checkentry6(const char *tablename,
+	    const void *info,
+	    const struct xt_match *match,
+	    void *matchinfo,
+	    unsigned int matchsize,
+	    unsigned int hook_mask)
+{
+	const struct ip6t_ip6 *ip = info;
+	const struct xt_multiport *multiinfo = matchinfo;
+
+	return check(ip->proto, ip->invflags, multiinfo->flags,
+		     multiinfo->count);
+}
+
+static int
+checkentry6_v1(const char *tablename,
+	       const void *info,
+	       const struct xt_match *match,
+	       void *matchinfo,
+	       unsigned int matchsize,
+	       unsigned int hook_mask)
+{
+	const struct ip6t_ip6 *ip = info;
+	const struct xt_multiport_v1 *multiinfo = matchinfo;
+
+	return check(ip->proto, ip->invflags, multiinfo->flags,
+		     multiinfo->count);
+}
+
+static struct xt_match multiport_match = {
+	.name		= "multiport",
+	.revision	= 0,
+	.matchsize	= sizeof(struct xt_multiport),
+	.match		= &match,
+	.checkentry	= &checkentry,
+	.family		= AF_INET,
+	.me		= THIS_MODULE,
+};
+
+static struct xt_match multiport_match_v1 = {
+	.name		= "multiport",
+	.revision	= 1,
+	.matchsize	= sizeof(struct xt_multiport_v1),
+	.match		= &match_v1,
+	.checkentry	= &checkentry_v1,
+	.family		= AF_INET,
+	.me		= THIS_MODULE,
+};
+
+static struct xt_match multiport6_match = {
+	.name		= "multiport",
+	.revision	= 0,
+	.matchsize	= sizeof(struct xt_multiport),
+	.match		= &match,
+	.checkentry	= &checkentry6,
+	.family		= AF_INET6,
+	.me		= THIS_MODULE,
+};
+
+static struct xt_match multiport6_match_v1 = {
+	.name		= "multiport",
+	.revision	= 1,
+	.matchsize	= sizeof(struct xt_multiport_v1),
+	.match		= &match_v1,
+	.checkentry	= &checkentry6_v1,
+	.family		= AF_INET6,
+	.me		= THIS_MODULE,
+};
+
+static int __init init(void)
+{
+	int ret;
+
+	ret = xt_register_match(&multiport_match);
+	if (ret)
+		goto out;
+
+	ret = xt_register_match(&multiport_match_v1);
+	if (ret)
+		goto out_unreg_multi_v0;
+
+	ret = xt_register_match(&multiport6_match);
+	if (ret)
+		goto out_unreg_multi_v1;
+
+	ret = xt_register_match(&multiport6_match_v1);
+	if (ret)
+		goto out_unreg_multi6_v0;
+
+	return ret;
+
+out_unreg_multi6_v0:
+	xt_unregister_match(&multiport6_match);
+out_unreg_multi_v1:
+	xt_unregister_match(&multiport_match_v1);
+out_unreg_multi_v0:
+	xt_unregister_match(&multiport_match);
+out:
+	return ret;
+}
+
+static void __exit fini(void)
+{
+	xt_unregister_match(&multiport_match);
+	xt_unregister_match(&multiport_match_v1);
+	xt_unregister_match(&multiport6_match);
+	xt_unregister_match(&multiport6_match_v1);
+}
+
+module_init(init);
+module_exit(fini);

----Next_Part(Fri_Mar_24_15_26_57_2006_605)----
