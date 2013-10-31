From: Vytas Dauksa <vytas.dauksa@smoothwall.net>
Subject: [PATCH] add hash:ip,mark data type to ipset
Date: Thu, 31 Oct 2013 14:39:41 +0000
Message-ID: <1383230381-19847-1-git-send-email-vytas.dauksa@smoothwall.net>
Cc: Vytas Dauksa <vytas.dauksa@smoothwall.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from exprod7og104.obsmtp.com ([64.18.2.161]:51678 "HELO
	exprod7og104.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754435Ab3JaOkN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Oct 2013 10:40:13 -0400
Received: by mail-we0-f176.google.com with SMTP id w62so2756368wes.21
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Oct 2013 07:40:10 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Introduce packet mark support with new ip,mark hash set. This includes
userspace and kernelspace code, hash:ip,mark set tests and updates man
page.
---
 include/libipset/data.h                            |    3 +
 include/libipset/linux_ip_set.h                    |    1 +
 include/libipset/parse.h                           |    2 +
 include/libipset/print.h                           |    3 +
 kernel/include/linux/netfilter/ipset/ip_set.h      |    6 +-
 kernel/include/uapi/linux/netfilter/ipset/ip_set.h |    1 +
 kernel/net/netfilter/ipset/Kbuild                  |    2 +-
 kernel/net/netfilter/ipset/Kconfig                 |    9 +
 kernel/net/netfilter/ipset/ip_set_hash_ipmark.c    |  318 ++++++++++++++++++++
 lib/Makefile.am                                    |    1 +
 lib/data.c                                         |    8 +
 lib/debug.c                                        |    2 +
 lib/ipset_hash_ipmark.c                            |  168 +++++++++++
 lib/libipset.map                                   |    2 +
 lib/parse.c                                        |   30 ++
 lib/print.c                                        |   35 +++
 lib/session.c                                      |    8 +
 src/ipset.8                                        |   49 +++
 tests/hash:ip,mark.t                               |  125 ++++++++
 tests/hash:ip,mark.t.list0                         |   10 +
 tests/hash:ip,mark.t.list1                         |    6 +
 tests/hash:ip6,mark.t                              |  227 ++++++++++++++
 tests/hash:ip6,mark.t.list0                        |   10 +
 tests/hash:ip6,mark.t.list1                        |    6 +
 tests/ipmarkhash.t                                 |   71 +++++
 tests/ipmarkhash.t.list0                           |   10 +
 tests/ipmarkhash.t.list1                           |   10 +
 tests/resizet.sh                                   |    8 +
 tests/runtest.sh                                   |    1 +
 tests/setlist_resize.sh                            |    2 +-
 30 files changed, 1130 insertions(+), 4 deletions(-)
 create mode 100644 kernel/net/netfilter/ipset/ip_set_hash_ipmark.c
 create mode 100644 lib/ipset_hash_ipmark.c
 create mode 100644 tests/hash:ip,mark.t
 create mode 100644 tests/hash:ip,mark.t.list0
 create mode 100644 tests/hash:ip,mark.t.list1
 create mode 100644 tests/hash:ip6,mark.t
 create mode 100644 tests/hash:ip6,mark.t.list0
 create mode 100644 tests/hash:ip6,mark.t.list1
 create mode 100644 tests/ipmarkhash.t
 create mode 100644 tests/ipmarkhash.t.list0
 create mode 100644 tests/ipmarkhash.t.list1

diff --git a/include/libipset/data.h b/include/libipset/data.h
index b6e75e8..c3a8ac4 100644
--- a/include/libipset/data.h
+++ b/include/libipset/data.h
@@ -22,6 +22,7 @@ enum ipset_opt {
 	IPSET_OPT_IP_FROM = IPSET_OPT_IP,
 	IPSET_OPT_IP_TO,
 	IPSET_OPT_CIDR,
+	IPSET_OPT_MARK,
 	IPSET_OPT_PORT,
 	IPSET_OPT_PORT_FROM = IPSET_OPT_PORT,
 	IPSET_OPT_PORT_TO,
@@ -80,6 +81,7 @@ enum ipset_opt {
 	| IPSET_FLAG(IPSET_OPT_IP)	\
 	| IPSET_FLAG(IPSET_OPT_IP_TO)	\
 	| IPSET_FLAG(IPSET_OPT_CIDR)	\
+	| IPSET_FLAG(IPSET_OPT_MARK)	\
 	| IPSET_FLAG(IPSET_OPT_PORT)	\
 	| IPSET_FLAG(IPSET_OPT_PORT_TO)	\
 	| IPSET_FLAG(IPSET_OPT_TIMEOUT)	\
@@ -96,6 +98,7 @@ enum ipset_opt {
 	(IPSET_FLAG(IPSET_OPT_IP)	\
 	| IPSET_FLAG(IPSET_OPT_IP_TO)	\
 	| IPSET_FLAG(IPSET_OPT_CIDR)	\
+	| IPSET_FLAG(IPSET_OPT_MARK)	\
 	| IPSET_FLAG(IPSET_OPT_PORT)	\
 	| IPSET_FLAG(IPSET_OPT_PORT_TO)	\
 	| IPSET_FLAG(IPSET_OPT_TIMEOUT)	\
diff --git a/include/libipset/linux_ip_set.h b/include/libipset/linux_ip_set.h
index 847bbff..c57f81e 100644
--- a/include/libipset/linux_ip_set.h
+++ b/include/libipset/linux_ip_set.h
@@ -83,6 +83,7 @@ enum {
 	IPSET_ATTR_PROTO,	/* 7 */
 	IPSET_ATTR_CADT_FLAGS,	/* 8 */
 	IPSET_ATTR_CADT_LINENO = IPSET_ATTR_LINENO,	/* 9 */
+	IPSET_ATTR_MARK,	/* 10 */
 	/* Reserve empty slots */
 	IPSET_ATTR_CADT_MAX = 16,
 	/* Create-only specific attributes */
diff --git a/include/libipset/parse.h b/include/libipset/parse.h
index 5c46a88..55981f2 100644
--- a/include/libipset/parse.h
+++ b/include/libipset/parse.h
@@ -29,6 +29,8 @@ extern int ipset_parse_ether(struct ipset_session *session,
 extern int ipset_parse_port(struct ipset_session *session,
 			    enum ipset_opt opt, const char *str,
 			    const char *proto);
+extern int ipset_parse_mark(struct ipset_session *session,
+			    enum ipset_opt opt, const char *str);
 extern int ipset_parse_tcpudp_port(struct ipset_session *session,
 				   enum ipset_opt opt, const char *str,
 				   const char *proto);
diff --git a/include/libipset/print.h b/include/libipset/print.h
index f2a6095..b8fa709 100644
--- a/include/libipset/print.h
+++ b/include/libipset/print.h
@@ -37,6 +37,9 @@ extern int ipset_print_name(char *buf, unsigned int len,
 extern int ipset_print_port(char *buf, unsigned int len,
 			    const struct ipset_data *data,
 			    enum ipset_opt opt, uint8_t env);
+extern int ipset_print_mark(char *buf, unsigned int len,
+			    const struct ipset_data *data,
+			    enum ipset_opt opt, uint8_t env);
 extern int ipset_print_iface(char *buf, unsigned int len,
 			     const struct ipset_data *data,
 			     enum ipset_opt opt, uint8_t env);
diff --git a/kernel/include/linux/netfilter/ipset/ip_set.h b/kernel/include/linux/netfilter/ipset/ip_set.h
index 7cde1cf..f5cb44f 100644
--- a/kernel/include/linux/netfilter/ipset/ip_set.h
+++ b/kernel/include/linux/netfilter/ipset/ip_set.h
@@ -40,11 +40,13 @@ enum ip_set_feature {
 	IPSET_TYPE_NAME = (1 << IPSET_TYPE_NAME_FLAG),
 	IPSET_TYPE_IFACE_FLAG = 5,
 	IPSET_TYPE_IFACE = (1 << IPSET_TYPE_IFACE_FLAG),
-	IPSET_TYPE_NOMATCH_FLAG = 6,
+	IPSET_TYPE_MARK_FLAG = 6,
+	IPSET_TYPE_MARK = (1 << IPSET_TYPE_MARK_FLAG),
+	IPSET_TYPE_NOMATCH_FLAG = 7,
 	IPSET_TYPE_NOMATCH = (1 << IPSET_TYPE_NOMATCH_FLAG),
 	/* Strictly speaking not a feature, but a flag for dumping:
 	 * this settype must be dumped last */
-	IPSET_DUMP_LAST_FLAG = 7,
+	IPSET_DUMP_LAST_FLAG = 8,
 	IPSET_DUMP_LAST = (1 << IPSET_DUMP_LAST_FLAG),
 };
 
diff --git a/kernel/include/uapi/linux/netfilter/ipset/ip_set.h b/kernel/include/uapi/linux/netfilter/ipset/ip_set.h
index 847bbff..c57f81e 100644
--- a/kernel/include/uapi/linux/netfilter/ipset/ip_set.h
+++ b/kernel/include/uapi/linux/netfilter/ipset/ip_set.h
@@ -83,6 +83,7 @@ enum {
 	IPSET_ATTR_PROTO,	/* 7 */
 	IPSET_ATTR_CADT_FLAGS,	/* 8 */
 	IPSET_ATTR_CADT_LINENO = IPSET_ATTR_LINENO,	/* 9 */
+	IPSET_ATTR_MARK,	/* 10 */
 	/* Reserve empty slots */
 	IPSET_ATTR_CADT_MAX = 16,
 	/* Create-only specific attributes */
diff --git a/kernel/net/netfilter/ipset/Kbuild b/kernel/net/netfilter/ipset/Kbuild
index 5564cb5..6495523 100644
--- a/kernel/net/netfilter/ipset/Kbuild
+++ b/kernel/net/netfilter/ipset/Kbuild
@@ -5,7 +5,7 @@ ip_set-y := ip_set_core.o ip_set_getport.o pfxlen.o
 obj-m += ip_set.o
 obj-m += ip_set_bitmap_ip.o ip_set_bitmap_ipmac.o ip_set_bitmap_port.o
 obj-m += ip_set_hash_ip.o ip_set_hash_ipport.o ip_set_hash_ipportip.o
-obj-m += ip_set_hash_ipportnet.o
+obj-m += ip_set_hash_ipportnet.o ip_set_hash_ipmark.o
 obj-m += ip_set_hash_net.o ip_set_hash_netport.o ip_set_hash_netiface.o
 obj-m += ip_set_hash_netnet.o ip_set_hash_netportnet.o
 obj-m += ip_set_list_set.o
diff --git a/kernel/net/netfilter/ipset/Kconfig b/kernel/net/netfilter/ipset/Kconfig
index a2d6263..638faa7 100644
--- a/kernel/net/netfilter/ipset/Kconfig
+++ b/kernel/net/netfilter/ipset/Kconfig
@@ -61,6 +61,15 @@ config IP_SET_HASH_IP
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config IP_SET_HASH_IPMARK
+	tristate "hash:ip,mark set support"
+	depends on IP_SET
+	help
+	  This option adds the hash:ip,mark set type support, by which one
+	  can store IPv4/IPv6 address and mark pairs.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 config IP_SET_HASH_IPPORT
 	tristate "hash:ip,port set support"
 	depends on IP_SET
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_ipmark.c b/kernel/net/netfilter/ipset/ip_set_hash_ipmark.c
new file mode 100644
index 0000000..e2b8f36
--- /dev/null
+++ b/kernel/net/netfilter/ipset/ip_set_hash_ipmark.c
@@ -0,0 +1,318 @@
+/* Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+ * Copyright (C) 2013 Smoothwall Ltd. <vytas.dauksa@smoothwall.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+/* Kernel module implementing an IP set type: the hash:ip,mark type */
+
+#include <linux/jhash.h>
+#include <linux/module.h>
+#include <linux/ip.h>
+#include <linux/skbuff.h>
+#include <linux/errno.h>
+#include <linux/random.h>
+#include <net/ip.h>
+#include <net/ipv6.h>
+#include <net/netlink.h>
+#include <net/tcp.h>
+
+#include <linux/netfilter.h>
+#include <linux/netfilter/ipset/pfxlen.h>
+#include <linux/netfilter/ipset/ip_set.h>
+#include <linux/netfilter/ipset/ip_set_hash.h>
+
+#define IPSET_TYPE_REV_MIN	0
+#define IPSET_TYPE_REV_MAX	0
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Vytas Dauksa <vytas.dauksa@smoothwall.net>");
+IP_SET_MODULE_DESC("hash:ip,mark", IPSET_TYPE_REV_MIN, IPSET_TYPE_REV_MAX);
+MODULE_ALIAS("ip_set_hash:ip,mark");
+
+/* Type specific function prefix */
+#define HTYPE		hash_ipmark
+
+/* IPv4 variant */
+
+/* Member elements */
+struct hash_ipmark4_elem {
+	__be32 ip;
+	__be32 mark;
+};
+
+/* Common functions */
+
+static inline bool
+hash_ipmark4_data_equal(const struct hash_ipmark4_elem *ip1,
+			const struct hash_ipmark4_elem *ip2,
+			u32 *multi)
+{
+	return ip1->ip == ip2->ip &&
+	       ip1->mark == ip2->mark;
+}
+
+static bool
+hash_ipmark4_data_list(struct sk_buff *skb,
+		       const struct hash_ipmark4_elem *data)
+{
+	if (nla_put_ipaddr4(skb, IPSET_ATTR_IP, data->ip) ||
+	    nla_put_net32(skb, IPSET_ATTR_MARK, data->mark))
+		goto nla_put_failure;
+	return 0;
+
+nla_put_failure:
+	return 1;
+}
+
+static inline void
+hash_ipmark4_data_next(struct hash_ipmark4_elem *next,
+		       const struct hash_ipmark4_elem *d)
+{
+	next->ip = d->ip;
+}
+
+#define MTYPE           hash_ipmark4
+#define PF              4
+#define HOST_MASK       32
+#define HKEY_DATALEN	sizeof(struct hash_ipmark4_elem)
+#include "ip_set_hash_gen.h"
+
+static int
+hash_ipmark4_kadt(struct ip_set *set, const struct sk_buff *skb,
+		  const struct xt_action_param *par,
+		  enum ipset_adt adt, struct ip_set_adt_opt *opt)
+{
+	ipset_adtfn adtfn = set->variant->adt[adt];
+	struct hash_ipmark4_elem e = { };
+	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
+
+	e.mark = ntohl(skb->mark);
+
+	ip4addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip);
+	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
+}
+
+static int
+hash_ipmark4_uadt(struct ip_set *set, struct nlattr *tb[],
+		  enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
+{
+	const struct hash_ipmark *h = set->data;
+	ipset_adtfn adtfn = set->variant->adt[adt];
+	struct hash_ipmark4_elem e = { };
+	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
+	u32 ip, ip_to = 0;
+	int ret;
+
+	if (unlikely(!tb[IPSET_ATTR_IP] ||
+		     !ip_set_attr_netorder(tb, IPSET_ATTR_MARK) ||
+		     !ip_set_optattr_netorder(tb, IPSET_ATTR_TIMEOUT) ||
+		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PACKETS) ||
+		     !ip_set_optattr_netorder(tb, IPSET_ATTR_BYTES)))
+		return -IPSET_ERR_PROTOCOL;
+
+	if (tb[IPSET_ATTR_LINENO])
+		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
+
+	ret = ip_set_get_ipaddr4(tb[IPSET_ATTR_IP], &e.ip) ||
+	      ip_set_get_extensions(set, tb, &ext);
+	if (ret)
+		return ret;
+
+	if (tb[IPSET_ATTR_MARK])
+		e.mark = nla_get_be32(tb[IPSET_ATTR_MARK]);
+	else
+		return -IPSET_ERR_PROTOCOL;
+
+	if (adt == IPSET_TEST ||
+	    !(tb[IPSET_ATTR_IP_TO] || tb[IPSET_ATTR_CIDR])) {
+		ret = adtfn(set, &e, &ext, &ext, flags);
+		return ip_set_eexist(ret, flags) ? 0 : ret;
+	}
+
+	ip_to = ip = ntohl(e.ip);
+	if (tb[IPSET_ATTR_IP_TO]) {
+		ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP_TO], &ip_to);
+		if (ret)
+			return ret;
+		if (ip > ip_to)
+			swap(ip, ip_to);
+	} else if (tb[IPSET_ATTR_CIDR]) {
+		u8 cidr = nla_get_u8(tb[IPSET_ATTR_CIDR]);
+
+		if (!cidr || cidr > 32)
+			return -IPSET_ERR_INVALID_CIDR;
+		ip_set_mask_from_to(ip, ip_to, cidr);
+	}
+
+	if (retried)
+		ip = ntohl(h->next.ip);
+	for (; !before(ip_to, ip); ip++) {
+		e.ip = htonl(ip);
+		ret = adtfn(set, &e, &ext, &ext, flags);
+
+		if (ret && !ip_set_eexist(ret, flags))
+			return ret;
+		else
+			ret = 0;
+	}
+	return ret;
+}
+
+/* IPv6 variant */
+
+struct hash_ipmark6_elem {
+	union nf_inet_addr ip;
+	__be32 mark;
+};
+
+/* Common functions */
+
+static inline bool
+hash_ipmark6_data_equal(const struct hash_ipmark6_elem *ip1,
+			const struct hash_ipmark6_elem *ip2,
+			u32 *multi)
+{
+	return ipv6_addr_equal(&ip1->ip.in6, &ip2->ip.in6) &&
+	       ip1->mark == ip2->mark;
+}
+
+static bool
+hash_ipmark6_data_list(struct sk_buff *skb,
+		       const struct hash_ipmark6_elem *data)
+{
+	if (nla_put_ipaddr6(skb, IPSET_ATTR_IP, &data->ip.in6) ||
+	    nla_put_net32(skb, IPSET_ATTR_MARK, data->mark))
+		goto nla_put_failure;
+	return 0;
+
+nla_put_failure:
+	return 1;
+}
+
+static inline void
+hash_ipmark6_data_next(struct hash_ipmark4_elem *next,
+		       const struct hash_ipmark6_elem *d)
+{
+}
+
+#undef MTYPE
+#undef PF
+#undef HOST_MASK
+#undef HKEY_DATALEN
+
+#define MTYPE		hash_ipmark6
+#define PF		6
+#define HOST_MASK	128
+#define HKEY_DATALEN	sizeof(struct hash_ipmark6_elem)
+#define	IP_SET_EMIT_CREATE
+#include "ip_set_hash_gen.h"
+
+
+static int
+hash_ipmark6_kadt(struct ip_set *set, const struct sk_buff *skb,
+		  const struct xt_action_param *par,
+		  enum ipset_adt adt, struct ip_set_adt_opt *opt)
+{
+	ipset_adtfn adtfn = set->variant->adt[adt];
+	struct hash_ipmark6_elem e = { };
+	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
+
+	e.mark = ntohl(skb->mark);
+
+	ip6addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip.in6);
+	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
+}
+
+static int
+hash_ipmark6_uadt(struct ip_set *set, struct nlattr *tb[],
+		  enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
+{
+	ipset_adtfn adtfn = set->variant->adt[adt];
+	struct hash_ipmark6_elem e = { };
+	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
+	int ret;
+
+	if (unlikely(!tb[IPSET_ATTR_IP] ||
+		     !ip_set_attr_netorder(tb, IPSET_ATTR_MARK) ||
+		     !ip_set_optattr_netorder(tb, IPSET_ATTR_TIMEOUT) ||
+		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PACKETS) ||
+		     !ip_set_optattr_netorder(tb, IPSET_ATTR_BYTES) ||
+		     tb[IPSET_ATTR_IP_TO] ||
+		     tb[IPSET_ATTR_CIDR]))
+		return -IPSET_ERR_PROTOCOL;
+
+	if (tb[IPSET_ATTR_LINENO])
+		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
+
+	ret = ip_set_get_ipaddr6(tb[IPSET_ATTR_IP], &e.ip) ||
+	      ip_set_get_extensions(set, tb, &ext);
+	if (ret)
+		return ret;
+
+	if (tb[IPSET_ATTR_MARK])
+		e.mark = nla_get_be32(tb[IPSET_ATTR_MARK]);
+	else
+		return -IPSET_ERR_PROTOCOL;
+
+	if (adt == IPSET_TEST) {
+		ret = adtfn(set, &e, &ext, &ext, flags);
+		return ip_set_eexist(ret, flags) ? 0 : ret;
+	}
+
+	ret = adtfn(set, &e, &ext, &ext, flags);
+	if (ret && !ip_set_eexist(ret, flags))
+		return ret;
+	else
+		ret = 0;
+
+	return ret;
+}
+
+static struct ip_set_type hash_ipmark_type __read_mostly = {
+	.name		= "hash:ip,mark",
+	.protocol	= IPSET_PROTOCOL,
+	.features	= IPSET_TYPE_IP | IPSET_TYPE_MARK,
+	.dimension	= IPSET_DIM_TWO,
+	.family		= NFPROTO_UNSPEC,
+	.revision_min	= IPSET_TYPE_REV_MIN,
+	.revision_max	= IPSET_TYPE_REV_MAX,
+	.create		= hash_ipmark_create,
+	.create_policy	= {
+		[IPSET_ATTR_HASHSIZE]	= { .type = NLA_U32 },
+		[IPSET_ATTR_MAXELEM]	= { .type = NLA_U32 },
+		[IPSET_ATTR_PROBES]	= { .type = NLA_U8 },
+		[IPSET_ATTR_RESIZE]	= { .type = NLA_U8  },
+		[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
+		[IPSET_ATTR_CADT_FLAGS]	= { .type = NLA_U32 },
+	},
+	.adt_policy	= {
+		[IPSET_ATTR_IP]		= { .type = NLA_NESTED },
+		[IPSET_ATTR_IP_TO]	= { .type = NLA_NESTED },
+		[IPSET_ATTR_MARK]	= { .type = NLA_U32 },
+		[IPSET_ATTR_CIDR]	= { .type = NLA_U8 },
+		[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
+		[IPSET_ATTR_LINENO]	= { .type = NLA_U32 },
+		[IPSET_ATTR_BYTES]	= { .type = NLA_U64 },
+		[IPSET_ATTR_PACKETS]	= { .type = NLA_U64 },
+		[IPSET_ATTR_COMMENT]	= { .type = NLA_NUL_STRING },
+	},
+	.me		= THIS_MODULE,
+};
+
+static int __init
+hash_ipmark_init(void)
+{
+	return ip_set_type_register(&hash_ipmark_type);
+}
+
+static void __exit
+hash_ipmark_fini(void)
+{
+	ip_set_type_unregister(&hash_ipmark_type);
+}
+
+module_init(hash_ipmark_init);
+module_exit(hash_ipmark_fini);
diff --git a/lib/Makefile.am b/lib/Makefile.am
index 2234670..6398be4 100644
--- a/lib/Makefile.am
+++ b/lib/Makefile.am
@@ -6,6 +6,7 @@ IPSET_SETTYPE_LIST = \
 	ipset_bitmap_port.c \
 	ipset_hash_ip.c \
 	ipset_hash_ipport.c \
+	ipset_hash_ipmark.c \
 	ipset_hash_ipportip.c \
 	ipset_hash_ipportnet.c \
 	ipset_hash_net.c \
diff --git a/lib/data.c b/lib/data.c
index ba4ed57..1f74cd5 100644
--- a/lib/data.c
+++ b/lib/data.c
@@ -41,6 +41,7 @@ struct ipset_data {
 	uint32_t timeout;
 	union nf_inet_addr ip;
 	union nf_inet_addr ip_to;
+	uint32_t mark;
 	uint16_t port;
 	uint16_t port_to;
 	union {
@@ -264,6 +265,9 @@ ipset_data_set(struct ipset_data *data, enum ipset_opt opt, const void *value)
 	case IPSET_OPT_CIDR:
 		data->cidr = *(const uint8_t *) value;
 		break;
+	case IPSET_OPT_MARK:
+		data->mark = *(const uint32_t *) value;
+		break;
 	case IPSET_OPT_PORT:
 		data->port = *(const uint16_t *) value;
 		break;
@@ -448,6 +452,8 @@ ipset_data_get(const struct ipset_data *data, enum ipset_opt opt)
 		 return &data->ip_to;
 	case IPSET_OPT_CIDR:
 		return &data->cidr;
+	case IPSET_OPT_MARK:
+		return &data->mark;
 	case IPSET_OPT_PORT:
 		return &data->port;
 	case IPSET_OPT_PORT_TO:
@@ -542,6 +548,8 @@ ipset_data_sizeof(enum ipset_opt opt, uint8_t family)
 	case IPSET_OPT_IP2_TO:
 		return family == NFPROTO_IPV4 ? sizeof(uint32_t)
 					 : sizeof(struct in6_addr);
+	case IPSET_OPT_MARK:
+		return sizeof(uint32_t);
 	case IPSET_OPT_PORT:
 	case IPSET_OPT_PORT_TO:
 		return sizeof(uint16_t);
diff --git a/lib/debug.c b/lib/debug.c
index a204940..56196ab 100644
--- a/lib/debug.c
+++ b/lib/debug.c
@@ -29,6 +29,7 @@ static const struct ipset_attrname createattr2name[] = {
 	[IPSET_ATTR_IP]		= { .name = "IP" },
 	[IPSET_ATTR_IP_TO]	= { .name = "IP_TO" },
 	[IPSET_ATTR_CIDR]	= { .name = "CIDR" },
+	[IPSET_ATTR_MARK]	= { .name = "MARK" },
 	[IPSET_ATTR_PORT]	= { .name = "PORT" },
 	[IPSET_ATTR_PORT_TO]	= { .name = "PORT_TO" },
 	[IPSET_ATTR_TIMEOUT]	= { .name = "TIMEOUT" },
@@ -51,6 +52,7 @@ static const struct ipset_attrname adtattr2name[] = {
 	[IPSET_ATTR_IP]		= { .name = "IP" },
 	[IPSET_ATTR_IP_TO]	= { .name = "IP_TO" },
 	[IPSET_ATTR_CIDR]	= { .name = "CIDR" },
+	[IPSET_ATTR_MARK]	= { .name = "MARK" },
 	[IPSET_ATTR_PORT]	= { .name = "PORT" },
 	[IPSET_ATTR_PORT_TO]	= { .name = "PORT_TO" },
 	[IPSET_ATTR_TIMEOUT]	= { .name = "TIMEOUT" },
diff --git a/lib/ipset_hash_ipmark.c b/lib/ipset_hash_ipmark.c
new file mode 100644
index 0000000..6976371
--- /dev/null
+++ b/lib/ipset_hash_ipmark.c
@@ -0,0 +1,168 @@
+/* Copyright 2007-2013 Jozsef Kadlecsik (kadlec@blackhole.kfki.hu)
+ * Copyright 2013 Smoothwall Ltd. (vytas.dauksa@smoothwall.net)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <libipset/data.h>			/* IPSET_OPT_* */
+#include <libipset/parse.h>			/* parser functions */
+#include <libipset/print.h>			/* printing functions */
+#include <libipset/types.h>			/* prototypes */
+
+/* Parse commandline arguments */
+static const struct ipset_arg hash_ipmark_create_args0[] = {
+	{ .name = { "family", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_FAMILY,
+	  .parse = ipset_parse_family,		.print = ipset_print_family,
+	},
+	/* Alias: family inet */
+	{ .name = { "-4", NULL },
+	  .has_arg = IPSET_NO_ARG,		.opt = IPSET_OPT_FAMILY,
+	  .parse = ipset_parse_family,
+	},
+	/* Alias: family inet6 */
+	{ .name = { "-6", NULL },
+	  .has_arg = IPSET_NO_ARG,		.opt = IPSET_OPT_FAMILY,
+	  .parse = ipset_parse_family,
+	},
+	{ .name = { "hashsize", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_HASHSIZE,
+	  .parse = ipset_parse_uint32,		.print = ipset_print_number,
+	},
+	{ .name = { "maxelem", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_MAXELEM,
+	  .parse = ipset_parse_uint32,		.print = ipset_print_number,
+	},
+	{ .name = { "timeout", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_TIMEOUT,
+	  .parse = ipset_parse_timeout,		.print = ipset_print_number,
+	},
+	{ .name = { "counters", NULL },
+	  .has_arg = IPSET_NO_ARG,		.opt = IPSET_OPT_COUNTERS,
+	  .parse = ipset_parse_flag,		.print = ipset_print_flag,
+	},
+	{ .name = { "comment", NULL },
+	  .has_arg = IPSET_NO_ARG,		.opt = IPSET_OPT_CREATE_COMMENT,
+	  .parse = ipset_parse_flag,		.print = ipset_print_flag,
+	},
+	/* Backward compatibility */
+	{ .name = { "probes", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_PROBES,
+	  .parse = ipset_parse_ignored,		.print = ipset_print_number,
+	},
+	{ .name = { "resize", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_RESIZE,
+	  .parse = ipset_parse_ignored,		.print = ipset_print_number,
+	},
+	{ .name = { "from", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_IP,
+	  .parse = ipset_parse_ignored,
+	},
+	{ .name = { "to", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_IP_TO,
+	  .parse = ipset_parse_ignored,
+	},
+	{ .name = { "network", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_IP,
+	  .parse = ipset_parse_ignored,
+	},
+	{ },
+};
+
+static const struct ipset_arg hash_ipmark_add_args0[] = {
+	{ .name = { "timeout", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_TIMEOUT,
+	  .parse = ipset_parse_timeout,		.print = ipset_print_number,
+	},
+	{ .name = { "packets", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_PACKETS,
+	  .parse = ipset_parse_uint64,		.print = ipset_print_number,
+	},
+	{ .name = { "bytes", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_BYTES,
+	  .parse = ipset_parse_uint64,		.print = ipset_print_number,
+	},
+	{ .name = { "comment", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_ADT_COMMENT,
+	  .parse = ipset_parse_comment,		.print = ipset_print_comment,
+	},
+	{ },
+};
+
+static const char hash_ipmark_usage0[] =
+"create SETNAME hash:ip,mark\n"
+"		[family inet|inet6]\n"
+"               [hashsize VALUE] [maxelem VALUE]\n"
+"               [timeout VALUE] [counters] [comment]\n"
+"add    SETNAME IP,MARK [timeout VALUE]\n"
+"               [packets VALUE] [bytes VALUE] [comment \"string\"]\n"
+"del    SETNAME IP,MARK\n"
+"test   SETNAME IP,MARK\n\n"
+"where depending on the INET family\n"
+"      IP is a valid IPv4 or IPv6 address (or hostname).\n"
+"      Adding/deleting multiple elements in IP/CIDR or FROM-TO form\n"
+"      is supported for IPv4.\n"
+"      Adding/deleting single mark element\n"
+"      is supported both for IPv4 and IPv6.\n";
+
+static struct ipset_type ipset_hash_ipmark0 = {
+	.name = "hash:ip,mark",
+	.alias = { "ipmarkhash", NULL },
+	.revision = 0,
+	.family = NFPROTO_IPSET_IPV46,
+	.dimension = IPSET_DIM_TWO,
+	.elem = {
+		[IPSET_DIM_ONE - 1] = {
+			.parse = ipset_parse_ip4_single6,
+			.print = ipset_print_ip,
+			.opt = IPSET_OPT_IP
+		},
+		[IPSET_DIM_TWO - 1] = {
+			.parse = ipset_parse_mark,
+			.print = ipset_print_mark,
+			.opt = IPSET_OPT_MARK
+		},
+	},
+	.args = {
+		[IPSET_CREATE] = hash_ipmark_create_args0,
+		[IPSET_ADD] = hash_ipmark_add_args0,
+	},
+	.mandatory = {
+		[IPSET_CREATE] = 0,
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_MARK),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_MARK),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_MARK),
+	},
+	.full = {
+		[IPSET_CREATE] = IPSET_FLAG(IPSET_OPT_HASHSIZE)
+			| IPSET_FLAG(IPSET_OPT_MAXELEM)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
+			| IPSET_FLAG(IPSET_OPT_COUNTERS)
+			| IPSET_FLAG(IPSET_OPT_CREATE_COMMENT),
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_IP_TO)
+			| IPSET_FLAG(IPSET_OPT_MARK)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
+			| IPSET_FLAG(IPSET_OPT_PACKETS)
+			| IPSET_FLAG(IPSET_OPT_BYTES)
+			| IPSET_FLAG(IPSET_OPT_ADT_COMMENT),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_IP_TO)
+			| IPSET_FLAG(IPSET_OPT_MARK),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_MARK),
+	},
+
+	.usage = hash_ipmark_usage0,
+	.description = "initial revision",
+};
+
+void _init(void);
+void _init(void)
+{
+	ipset_type_add(&ipset_hash_ipmark0);
+}
diff --git a/lib/libipset.map b/lib/libipset.map
index 1080f0d..fc7ac95 100644
--- a/lib/libipset.map
+++ b/lib/libipset.map
@@ -28,6 +28,7 @@ global:
   name_to_icmpv6;
   ipset_get_nlmsg_type;
   ipset_parse_ether;
+  ipset_parse_mark;
   ipset_parse_port;
   ipset_parse_tcpudp_port;
   ipset_parse_tcp_port;
@@ -69,6 +70,7 @@ global:
   ipset_print_ipaddr;
   ipset_print_number;
   ipset_print_name;
+  ipset_print_mark;
   ipset_print_port;
   ipset_print_iface;
   ipset_print_proto;
diff --git a/lib/parse.c b/lib/parse.c
index 8ea8542..97ff435 100644
--- a/lib/parse.c
+++ b/lib/parse.c
@@ -328,6 +328,36 @@ ipset_parse_port(struct ipset_session *session,
 }
 
 /**
+ * ipset_parse_mark - parse a mark
+ * @session: session structure
+ * @opt: option kind of the data
+ * @str: string to parse
+ *
+ * Parse string as a mark. The parsed mark number is
+ * stored in the data blob of the session.
+ *
+ * Returns 0 on success or a negative error code.
+ */
+int
+ipset_parse_mark(struct ipset_session *session,
+		 enum ipset_opt opt, const char *str)
+{
+	uint32_t mark;
+	int err;
+
+	assert(session);
+	assert(str);
+
+	if ((err = string_to_u32(session, str, &mark)) == 0)
+		err = ipset_session_data_set(session, opt, &mark);
+
+	if (!err)
+		/* No error, so reset false error messages! */
+		ipset_session_report_reset(session);
+	return err;
+}
+
+/**
  * ipset_parse_tcpudp_port - parse TCP/UDP port name, number, or range of them
  * @session: session structure
  * @opt: option kind of the data
diff --git a/lib/print.c b/lib/print.c
index abdfd34..6634802 100644
--- a/lib/print.c
+++ b/lib/print.c
@@ -491,6 +491,41 @@ ipset_print_port(char *buf, unsigned int len,
 }
 
 /**
+ * ipset_print_mark - print mark to string
+ * @buf: printing buffer
+ * @len: length of available buffer space
+ * @data: data blob
+ * @opt: the option kind
+ * @env: environment flags
+ *
+ * Print mark to output buffer.
+ *
+ * Return lenght of printed string or error size.
+ */
+int
+ipset_print_mark(char *buf, unsigned int len,
+		   const struct ipset_data *data,
+		   enum ipset_opt opt ASSERT_UNUSED,
+		   uint8_t env UNUSED)
+{
+	const uint32_t *mark;
+	int size, offset = 0;
+
+	assert(buf);
+	assert(len > 0);
+	assert(data);
+	assert(opt == IPSET_OPT_MARK);
+
+	mark = ipset_data_get(data, IPSET_OPT_MARK);
+	assert(mark);
+
+	size = snprintf(buf, len, "%u", *mark);
+	SNPRINTF_FAILURE(size, len, offset);
+
+	return offset;
+}
+
+/**
  * ipset_print_iface - print interface element string
  * @buf: printing buffer
  * @len: length of available buffer space
diff --git a/lib/session.c b/lib/session.c
index 6f89281..673b440 100644
--- a/lib/session.c
+++ b/lib/session.c
@@ -349,6 +349,10 @@ static const struct ipset_attr_policy create_attrs[] = {
 		.type = MNL_TYPE_U8,
 		.opt = IPSET_OPT_CIDR,
 	},
+	[IPSET_ATTR_MARK] = {
+		.type = MNL_TYPE_U32,
+		.opt = IPSET_OPT_MARK,
+	},
 	[IPSET_ATTR_PORT] = {
 		.type = MNL_TYPE_U16,
 		.opt = IPSET_OPT_PORT,
@@ -424,6 +428,10 @@ static const struct ipset_attr_policy adt_attrs[] = {
 		.type = MNL_TYPE_U8,
 		.opt = IPSET_OPT_CIDR,
 	},
+	[IPSET_ATTR_MARK] = {
+		.type = MNL_TYPE_U32,
+		.opt = IPSET_OPT_MARK,
+	},
 	[IPSET_ATTR_PORT] = {
 		.type = MNL_TYPE_U16,
 		.opt = IPSET_OPT_PORT,
diff --git a/src/ipset.8 b/src/ipset.8
index 8a21eaf..b401863 100644
--- a/src/ipset.8
+++ b/src/ipset.8
@@ -878,6 +878,55 @@ ipset add foo 192.168.1,80,10.0.0/24
 ipset add foo 192.168.2,25,10.1.0.0/16
 .IP 
 ipset test foo 192.168.1,80.10.0.0/24
+.SS hash:ip,mark
+The \fBhash:ip,mark\fR set type uses a hash to store IP address and packet mark pairs.
+.PP
+\fICREATE\-OPTIONS\fR := [ \fBfamily\fR { \fBinet\fR | \fBinet6\fR } ] | [ \fBhashsize\fR \fIvalue\fR ] [ \fBmaxelem\fR \fIvalue\fR ] [ \fBtimeout\fR \fIvalue\fR ] [ \fBcounters\fP ] [ \fBcomment\fP ]
+.PP
+\fIADD\-ENTRY\fR := \fIipaddr\fR,\fImark\fR
+.PP
+\fIADD\-OPTIONS\fR := [ \fBtimeout\fR \fIvalue\fR ] [ \fBpackets\fR \fIvalue\fR ] [ \fBbytes\fR \fIvalue\fR ] [ \fBcomment\fR \fIstring\fR ]
+.PP
+\fIDEL\-ENTRY\fR := \fIipaddr\fR,\fImark\fR
+.PP
+\fITEST\-ENTRY\fR := \fIipaddr\fR,\fImark\fR
+.PP
+Optional \fBcreate\fR options:
+.TP
+\fBfamily\fR { \fBinet\fR | \fBinet6\fR }
+The protocol family of the IP addresses to be stored in the set. The default is
+\fBinet\fR, i.e IPv4.
+.TP
+\fBhashsize\fR \fIvalue\fR
+The initial hash size for the set, default is 1024. The hash size must be a power
+of two, the kernel automatically rounds up non power of two hash sizes to the first
+correct value
+.TP
+\fBmaxelem\fR \fIvalue\fR
+The maximal number of elements which can be stored in the set, default 65536.
+.PP
+For the \fBinet\fR family one can add or delete multiple entries by specifying
+a range or a network of IPv4 addresses in the IP address part of the entry:
+.PP
+\fIipaddr\fR := { \fIip\fR | \fIfromaddr\fR\-\fItoaddr\fR | \fIip\fR/\fIcidr\fR }
+.PP
+The
+\fImark\fR
+can be any value between 0 and 4294967295.
+.PP
+The \fBhash:ip,mark\fR type of sets require
+two \fBsrc\fR/\fBdst\fR parameters of the \fBset\fR match and \fBSET\fR
+target kernel modules.
+.PP
+Examples:
+.IP
+ipset create foo hash:ip,mark
+.IP
+ipset add foo 192.168.1.0/24,555
+.IP
+ipset add foo 192.168.1.1,0x63
+.IP
+ipset add foo 192.168.1.1,111236
 .SS hash:net,port,net
 The \fBhash:net,port,net\fR set type behaves similarly to hash:ip,port,net but accepts a
 cidr value for both the first and last parameter. Either subnet is permitted to be a /0
diff --git a/tests/hash:ip,mark.t b/tests/hash:ip,mark.t
new file mode 100644
index 0000000..bd5c237
--- /dev/null
+++ b/tests/hash:ip,mark.t
@@ -0,0 +1,125 @@
+# Create a set with timeout
+0 ipset create test hash:ip,mark timeout 5
+# Add partly zero valued element
+0 ipset add test 2.0.0.1,0
+# Test partly zero valued element
+0 ipset test test 2.0.0.1,0
+# Delete partly zero valued element
+0 ipset del test 2.0.0.1,0
+# Add first random value
+0 ipset add test 2.0.0.1,5
+# Add second random value
+0 ipset add test 2.1.0.0,128
+# Test first random value
+0 ipset test test 2.0.0.1,5
+# Test second random value
+0 ipset test test 2.1.0.0,128
+# Test value not added to the set
+1 ipset test test 2.0.0.1,4
+# Delete value not added to the set
+1 ipset del test 2.0.0.1,6
+# Test value before first random value
+1 ipset test test 2.0.0.0,5
+# Test value after second random value
+1 ipset test test 2.1.0.1,128
+# Try to add value before first random value
+0 ipset add test 2.0.0.0,5
+# Try to add value after second random value
+0 ipset add test 2.1.0.1,128
+# List set
+0 ipset list test | grep -v Revision: | sed 's/timeout ./timeout x/' > .foo0 && ./sort.sh .foo0
+# Check listing
+0 diff -u -I 'Size in memory.*' .foo hash:ip,mark.t.list0
+# Sleep 5s so that elements can time out
+0 sleep 5
+# List set
+0 ipset list test | grep -v Revision: > .foo0 && ./sort.sh .foo0
+# Check listing
+0 diff -u -I 'Size in memory.*' .foo hash:ip,mark.t.list1
+# Flush test set
+0 ipset flush test
+# Add multiple elements in one step
+0 ipset add test 1.1.1.1-1.1.1.18,80
+# Delete multiple elements in one step
+0 ipset del test 1.1.1.2-1.1.1.3,80
+# Check number of elements after multi-add/multi-del
+0 n=`ipset save test|wc -l` && test $n -eq 17
+# Delete test set
+0 ipset destroy test
+# Create set to add a range
+0 ipset new test hash:ip,mark hashsize 64
+# Add a range which forces a resizing
+0 ipset add test 10.0.0.0-10.0.3.255,80
+# Check that correct number of elements are added
+0 n=`ipset list test|grep '^10.0'|wc -l` && test $n -eq 1024
+# Flush set
+0 ipset flush test
+# Add an single element
+0 ipset add test 10.0.0.1,80
+# Check number of elements
+0 n=`ipset save test|wc -l` && test $n -eq 2
+# Delete the single element
+0 ipset del test 10.0.0.1,80
+# Check number of elements
+0 n=`ipset save test|wc -l` && test $n -eq 1
+# Add an IP range
+0 ipset add test 10.0.0.1-10.0.0.10,80
+# Check number of elements
+0 n=`ipset save test|wc -l` && test $n -eq 11
+# Delete the IP range
+0 ipset del test 10.0.0.1-10.0.0.10,80
+# Check number of elements
+0 n=`ipset save test|wc -l` && test $n -eq 1
+# Destroy set
+0 ipset -X test
+# Timeout: Check that resizing keeps timeout values
+0 ./resizet.sh -4 ipmark
+# Counters: create set
+0 ipset n test hash:ip,mark counters
+# Counters: add element with packet, byte counters
+0 ipset a test 2.0.0.1,80 packets 5 bytes 3456
+# Counters: check element
+0 ipset t test 2.0.0.1,80
+# Counters: check counters
+0 ./check_counters test 2.0.0.1 5 3456
+# Counters: delete element
+0 ipset d test 2.0.0.1,80
+# Counters: test deleted element
+1 ipset t test 2.0.0.1,80
+# Counters: add element with packet, byte counters
+0 ipset a test 2.0.0.20,453 packets 12 bytes 9876
+# Counters: check counters
+0 ./check_counters test 2.0.0.20 12 9876
+# Counters: update counters
+0 ipset -! a test 2.0.0.20,453 packets 13 bytes 12479
+# Counters: check counters
+0 ./check_counters test 2.0.0.20 13 12479
+# Counters: destroy set
+0 ipset x test
+# Counters and timeout: create set
+0 ipset n test hash:ip,mark counters timeout 600
+# Counters and timeout: add element with packet, byte counters
+0 ipset a test 2.0.0.1,80 packets 5 bytes 3456
+# Counters and timeout: check element
+0 ipset t test 2.0.0.1,80
+# Counters and timeout: check counters
+0 ./check_extensions test 2.0.0.1 600 5 3456
+# Counters and timeout: delete element
+0 ipset d test 2.0.0.1,80
+# Counters and timeout: test deleted element
+1 ipset t test 2.0.0.1,80
+# Counters and timeout: add element with packet, byte counters
+0 ipset a test 2.0.0.20,453 packets 12 bytes 9876
+# Counters and timeout: check counters
+0 ./check_extensions test 2.0.0.20 600 12 9876
+# Counters and timeout: update counters
+0 ipset -! a test 2.0.0.20,453 packets 13 bytes 12479
+# Counters and timeout: check counters
+0 ./check_extensions test 2.0.0.20 600 13 12479
+# Counters and timeout: update timeout
+0 ipset -! a test 2.0.0.20,453 timeout 700
+# Counters and timeout: check counters
+0 ./check_extensions test 2.0.0.20 700 13 12479
+# Counters and timeout: destroy set
+0 ipset x test
+# eof
diff --git a/tests/hash:ip,mark.t.list0 b/tests/hash:ip,mark.t.list0
new file mode 100644
index 0000000..378dabe
--- /dev/null
+++ b/tests/hash:ip,mark.t.list0
@@ -0,0 +1,10 @@
+Name: test
+Type: hash:ip,mark
+Header: family inet hashsize 1024 maxelem 65536 timeout x
+Size in memory: 8836
+References: 0
+Members:
+2.0.0.0,5 timeout x
+2.0.0.1,5 timeout x
+2.1.0.0,128 timeout x
+2.1.0.1,128 timeout x
diff --git a/tests/hash:ip,mark.t.list1 b/tests/hash:ip,mark.t.list1
new file mode 100644
index 0000000..af8a38b
--- /dev/null
+++ b/tests/hash:ip,mark.t.list1
@@ -0,0 +1,6 @@
+Name: test
+Type: hash:ip,mark
+Header: family inet hashsize 1024 maxelem 65536 timeout 5
+Size in memory: 8836
+References: 0
+Members:
diff --git a/tests/hash:ip6,mark.t b/tests/hash:ip6,mark.t
new file mode 100644
index 0000000..bc7757b
--- /dev/null
+++ b/tests/hash:ip6,mark.t
@@ -0,0 +1,227 @@
+# Create a set with timeout
+0 ipset create test hash:ip,mark family inet6 timeout 5
+# Add partly zero valued element
+0 ipset add test 2:0:0::1,0
+# Test partly zero valued element
+0 ipset test test 2:0:0::1,0
+# Delete partly zero valued element
+0 ipset del test 2:0:0::1,0
+# Add first random value
+0 ipset add test 2:0:0::1,5
+# Add second random value
+0 ipset add test 2:1:0::0,128
+# Test first random value
+0 ipset test test 2:0:0::1,5
+# Test second random value
+0 ipset test test 2:1:0::0,128
+# Test value not added to the set
+1 ipset test test 2:0:0::1,4
+# Delete value not added to the set
+1 ipset del test 2:0:0::1,6
+# Test value before first random value
+1 ipset test test 2:0:0::0,5
+# Test value after second random value
+1 ipset test test 2:1:0::1,128
+# Try to add value before first random value
+0 ipset add test 2:0:0::0,5
+# Try to add value after second random value
+0 ipset add test 2:1:0::1,128
+# List set
+0 ipset list test | grep -v Revision: | sed 's/timeout ./timeout x/' > .foo0 && ./sort.sh .foo0
+# Check listing
+0 diff -u -I 'Size in memory.*' .foo hash:ip6,mark.t.list0
+# Sleep 5s so that elements can time out
+0 sleep 5
+# List set
+0 ipset list test | grep -v Revision: > .foo0 && ./sort.sh .foo0
+# Check listing
+0 diff -u -I 'Size in memory.*' .foo hash:ip6,mark.t.list1
+# Delete test set
+0 ipset destroy test
+# Create set to add a range
+0 ipset new test hash:ip,mark -6 hashsize 64
+# Add a random value 1
+0 ipset add test 1::1,800000
+# Add a random value 2
+0 ipset add test 1::1,8900000
+# Add a random value 3
+0 ipset add test 1::3,8900000
+# Add a random value 4
+0 ipset add test 1::4,8900000
+# Add a random value 5
+0 ipset add test 1::5,8900000
+# Add a random value 6
+0 ipset add test 1::6,8900000
+# Add a random value 7
+0 ipset add test 1::7,8900000
+# Add a random value 8
+0 ipset add test 1::8,8900000
+# Add a random value 9
+0 ipset add test 1::9,8900000
+# Add a random value 10
+0 ipset add test 1::101,8900000
+# Add a random value 11
+0 ipset add test 1::11,8900000
+# Add a random value 12
+0 ipset add test 1::12,8900000
+# Add a random value 13
+0 ipset add test 1::13,8900000
+# Add a random value 14
+0 ipset add test 1::14,8900000
+# Add a random value 15
+0 ipset add test 1::15,8900000
+# Add a random value 16
+0 ipset add test 1::16,8900000
+# Add a random value 17
+0 ipset add test 1::17,8900000
+# Add a random value 18
+0 ipset add test 1::18,8900000
+# Add a random value 19
+0 ipset add test 1::19,8900000
+# Add a random value 20
+0 ipset add test 1::20,8900000
+# Add a random value 21
+0 ipset add test 1::21,8900000
+# Add a random value 22
+0 ipset add test 1::22,8900000
+# Add a random value 23
+0 ipset add test 1::23,8900000
+# Add a random value 24
+0 ipset add test 1::24,8900000
+# Add a random value 25
+0 ipset add test 1::25,8900000
+# Add a random value 26
+0 ipset add test 1::26,8900000
+# Add a random value 27
+0 ipset add test 1::27,8900000
+# Add a random value 28
+0 ipset add test 1::28,8900000
+# Add a random value 29
+0 ipset add test 1::29,8900000
+# Add a random value 30
+0 ipset add test 1::301,8900000
+# Add a random value 31
+0 ipset add test 1::31,8900000
+# Add a random value 32
+0 ipset add test 1::32,8900000
+# Add a random value 33
+0 ipset add test 1::33,8900000
+# Add a random value 34
+0 ipset add test 1::34,8900000
+# Add a random value 35
+0 ipset add test 1::35,8900000
+# Add a random value 36
+0 ipset add test 1::36,8900000
+# Add a random value 37
+0 ipset add test 1::37,8900000
+# Add a random value 38
+0 ipset add test 1::38,8900000
+# Add a random value 39
+0 ipset add test 1::39,8900000
+# Add a random value 40
+0 ipset add test 1::401,8900000
+# Add a random value 41
+0 ipset add test 1::41,8900000
+# Add a random value 42
+0 ipset add test 1::42,8900000
+# Add a random value 43
+0 ipset add test 1::43,8900000
+# Add a random value 44
+0 ipset add test 1::44,8900000
+# Add a random value 45
+0 ipset add test 1::45,8900000
+# Add a random value 46
+0 ipset add test 1::46,8900000
+# Add a random value 47
+0 ipset add test 1::47,8900000
+# Add a random value 48
+0 ipset add test 1::48,8900000
+# Add a random value 49
+0 ipset add test 1::49,8900000
+# Add a random value 50
+0 ipset add test 1::501,8900000
+# Add a random value 51
+0 ipset add test 1::51,8900000
+# Add a random value 52
+0 ipset add test 1::52,8900000
+# Add a random value 53
+0 ipset add test 1::53,8900000
+# Add a random value 54
+0 ipset add test 1::54,8900000
+# Add a random value 55
+0 ipset add test 1::55,8900000
+# Add a random value 56
+0 ipset add test 1::56,8900000
+# Add a random value 57
+0 ipset add test 1::57,8900000
+# Add a random value 58
+0 ipset add test 1::58,8900000
+# Add a random value 59
+0 ipset add test 1::59,8900000
+# Add a random value 60
+0 ipset add test 1::601,8900000
+# Add a random value 61
+0 ipset add test 1::61,8900000
+# Add a random value 62
+0 ipset add test 1::62,8900000
+# Add a random value 63
+0 ipset add test 1::63,8900000
+# Add a random value 64
+0 ipset add test 1::64,8900000
+# Add a random value 65, that forces a resizing
+0 ipset add test 1::65,8900000
+# Check that correct number of elements are added
+0 n=`ipset list test|grep 1::|wc -l` && test $n -eq 65
+# Destroy set
+0 ipset -X test
+# Timeout: Check that resizing keeps timeout values
+0 ./resizet.sh -6 ipmark
+# Counters: create set
+0 ipset n test hash:ip,mark -6 counters
+# Counters: add element with packet, byte counters
+0 ipset a test 2:0:0::1,80 packets 5 bytes 3456
+# Counters: check element
+0 ipset t test 2:0:0::1,80
+# Counters: check counters
+0 ./check_counters test 2::1 5 3456
+# Counters: delete element
+0 ipset d test 2:0:0::1,80
+# Counters: test deleted element
+1 ipset t test 2:0:0::1,80
+# Counters: add element with packet, byte counters
+0 ipset a test 2:0:0::20,453 packets 12 bytes 9876
+# Counters: check counters
+0 ./check_counters test 2::20 12 9876
+# Counters: update counters
+0 ipset -! a test 2:0:0::20,453 packets 13 bytes 12479
+# Counters: check counters
+0 ./check_counters test 2::20 13 12479
+# Counters: destroy set
+0 ipset x test
+# Counters and timeout: create set
+0 ipset n test hash:ip,mark -6 counters timeout 600
+# Counters and timeout: add element with packet, byte counters
+0 ipset a test 2:0:0::1,80 packets 5 bytes 3456
+# Counters and timeout: check element
+0 ipset t test 2:0:0::1,80
+# Counters and timeout: check counters
+0 ./check_extensions test 2::1 600 5 3456
+# Counters and timeout: delete element
+0 ipset d test 2:0:0::1,80
+# Counters and timeout: test deleted element
+1 ipset t test 2:0:0::1,80
+# Counters and timeout: add element with packet, byte counters
+0 ipset a test 2:0:0::20,453 packets 12 bytes 9876
+# Counters and timeout: check counters
+0 ./check_extensions test 2::20 600 12 9876
+# Counters and timeout: update counters
+0 ipset -! a test 2:0:0::20,453 packets 13 bytes 12479
+# Counters and timeout: check counters
+0 ./check_extensions test 2::20 600 13 12479
+# Counters and timeout: update timeout
+0 ipset -! a test 2:0:0::20,453 timeout 700
+# Counters and timeout: check counters
+0 ./check_extensions test 2::20 700 13 12479
+# Counters and timeout: destroy set
+0 ipset x test
+# eof
diff --git a/tests/hash:ip6,mark.t.list0 b/tests/hash:ip6,mark.t.list0
new file mode 100644
index 0000000..3ddc56a
--- /dev/null
+++ b/tests/hash:ip6,mark.t.list0
@@ -0,0 +1,10 @@
+Name: test
+Type: hash:ip,mark
+Header: family inet6 hashsize 1024 maxelem 65536 timeout x
+Size in memory: 9316
+References: 0
+Members:
+2:1::,128 timeout x
+2:1::1,128 timeout x
+2::,5 timeout x
+2::1,5 timeout x
diff --git a/tests/hash:ip6,mark.t.list1 b/tests/hash:ip6,mark.t.list1
new file mode 100644
index 0000000..3759448
--- /dev/null
+++ b/tests/hash:ip6,mark.t.list1
@@ -0,0 +1,6 @@
+Name: test
+Type: hash:ip,mark
+Header: family inet6 hashsize 1024 maxelem 65536 timeout 5
+Size in memory: 9316
+References: 0
+Members:
diff --git a/tests/ipmarkhash.t b/tests/ipmarkhash.t
new file mode 100644
index 0000000..30301fb
--- /dev/null
+++ b/tests/ipmarkhash.t
@@ -0,0 +1,71 @@
+# Create a set from a range (range ignored)
+0 ipset -N test ipmarkhash --from 2.0.0.1 --to 2.1.0.0
+# Destroy set
+0 ipset -X test
+# Create a set
+0 ipset -N test ipmarkhash
+# Add partly zero valued element
+0 ipset -A test 2.0.0.1,0
+# Test partly zero valued element
+0 ipset -T test 2.0.0.1,0
+# Delete partly zero valued element
+0 ipset -D test 2.0.0.1,0
+# Add first random value
+0 ipset -A test 2.0.0.1,5
+# Add second random value
+0 ipset -A test 2.1.0.0,128
+# Test first random value
+0 ipset -T test 2.0.0.1,5
+# Test second random value
+0 ipset -T test 2.1.0.0,128
+# Test value not added to the set
+1 ipset -T test 2.0.0.1,4
+# Delete value not added to the set
+1 ipset -D test 2.0.0.1,6
+# Test value before first random value
+1 ipset -T test 2.0.0.0,5
+# Test value after second random value
+1 ipset -T test 2.1.0.1,128
+# Try to add value before first random value
+0 ipset -A test 2.0.0.0,5
+# Try to add value after second random value
+0 ipset -A test 2.1.0.1,128
+# List set
+0 ipset -L test | grep -v Revision: > .foo0 && ./sort.sh .foo0
+# Check listing
+0 diff -u -I 'Size in memory.*' .foo ipmarkhash.t.list0
+# Flush test set
+0 ipset -F test
+# Delete test set
+0 ipset -X test
+# Create a set from a network (network ignored)
+0 ipset -N test ipmarkhash --network 2.0.0.0/16
+# Add first random value
+0 ipset -A test 2.0.0.0,5
+# Add second random value
+0 ipset -A test 2.0.255.255,128
+# Test first random value
+0 ipset -T test 2.0.0.0,5
+# Test second random value
+0 ipset -T test 2.0.255.255,128
+# Test value not added to the set
+1 ipset -T test 2.0.0.0,4
+# Delete value not added to the set
+1 ipset -D test 2.0.0.0,6
+# Test value before first random value
+1 ipset -T test 1.255.255.255,5
+# Test value after second random value
+1 ipset -T test 2.1.0.0,128
+# Try to add value before first random value
+0 ipset -A test 1.255.255.255,5
+# Try to add value after second random value
+0 ipset -A test 2.1.0.0,128
+# List set
+0 ipset -L test | grep -v Revision: > .foo0 && ./sort.sh .foo0
+# Check listing
+0 diff -u -I 'Size in memory.*' .foo ipmarkhash.t.list1
+# Flush test set
+0 ipset -F test
+# Delete test set
+0 ipset -X test
+# eof
diff --git a/tests/ipmarkhash.t.list0 b/tests/ipmarkhash.t.list0
new file mode 100644
index 0000000..201a687
--- /dev/null
+++ b/tests/ipmarkhash.t.list0
@@ -0,0 +1,10 @@
+Name: test
+Type: hash:ip,mark
+Header: family inet hashsize 1024 maxelem 65536
+Size in memory: 8516
+References: 0
+Members:
+2.0.0.0,5
+2.0.0.1,5
+2.1.0.0,128
+2.1.0.1,128
diff --git a/tests/ipmarkhash.t.list1 b/tests/ipmarkhash.t.list1
new file mode 100644
index 0000000..2b0265b
--- /dev/null
+++ b/tests/ipmarkhash.t.list1
@@ -0,0 +1,10 @@
+Name: test
+Type: hash:ip,mark
+Header: family inet hashsize 1024 maxelem 65536
+Size in memory: 8468
+References: 0
+Members:
+1.255.255.255,5
+2.0.0.0,5
+2.0.255.255,128
+2.1.0.0,128
diff --git a/tests/resizet.sh b/tests/resizet.sh
index c121357..753c08e 100644
--- a/tests/resizet.sh
+++ b/tests/resizet.sh
@@ -29,6 +29,14 @@ case "$2" in
     	    done
     	done
     	;;
+    ipmark)
+    	$ipset n test hash:ip,mark $1 hashsize 64 timeout 100
+    	for x in `seq 0 16`; do
+    	    for y in `seq 0 255`; do
+    	    	$ipset a test $ip$x$sep$y,1023
+    	    done
+    	done
+    	;;
     ipport)
     	$ipset n test hash:ip,port $1 hashsize 64 timeout 100
     	for x in `seq 0 16`; do
diff --git a/tests/runtest.sh b/tests/runtest.sh
index a82b802..99e5e6c 100755
--- a/tests/runtest.sh
+++ b/tests/runtest.sh
@@ -7,6 +7,7 @@ tests="$tests ipmap bitmap:ip"
 tests="$tests macipmap portmap"
 tests="$tests iphash hash:ip hash:ip6"
 tests="$tests ipporthash hash:ip,port hash:ip6,port"
+tests="$tests ipmarkhash hash:ip,mark hash:ip6,mark"
 tests="$tests ipportiphash hash:ip,port,ip hash:ip6,port,ip6"
 tests="$tests nethash hash:net hash:net6 hash:net,port hash:net6,port"
 tests="$tests hash:ip,port,net hash:ip6,port,net6 hash:net,net hash:net6,net6"
diff --git a/tests/setlist_resize.sh b/tests/setlist_resize.sh
index bdf762b..7e7ad24 100755
--- a/tests/setlist_resize.sh
+++ b/tests/setlist_resize.sh
@@ -7,7 +7,7 @@ loop=8
 for x in ip_set_list_set ip_set_hash_netiface ip_set_hash_ipportnet \
 	 ip_set_hash_netport ip_set_hash_net ip_set_hash_ipportip \
 	 ip_set_hash_ipport ip_set_hash_ip ip_set_hash_netnet \
-	 ip_set_hash_netportnet \
+	 ip_set_hash_netportnet ip_set_hash_ipmark \
 	 ip_set_bitmap_port ip_set_bitmap_ipmac \
 	 ip_set_bitmap_ip xt_set ip_set; do
     rmmod $x
-- 
1.7.9.5

