From: Philip Craig <philipc@snapgear.com>
Subject: [PATCH 2/3] libnl: add netfilter conntrack support
Date: Mon, 03 Sep 2007 15:11:54 +1000
Message-ID: <46DB979A.2010501@snapgear.com>
References: <46DB9716.1020400@snapgear.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090800060000070204090406"
To: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46DB9716.1020400@snapgear.com>
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

This is a multi-part message in MIME format.
--------------090800060000070204090406
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit



--------------090800060000070204090406
Content-Type: text/x-diff;
 name="nfnl_ct.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nfnl_ct.patch"

---
 include/linux/netfilter/nfnetlink_conntrack.h |  140 +++++
 include/netlink-types.h                       |   44 +
 include/netlink/addr.h                        |    1 
 include/netlink/netfilter/ct.h                |  115 ++++
 include/netlink/utils.h                       |    4 
 lib/addr.c                                    |   28 +
 lib/netfilter/ct.c                            |  422 ++++++++++++++++
 lib/netfilter/ct_obj.c                        |  667 ++++++++++++++++++++++++++
 lib/utils.c                                   |   36 +
 src/Makefile                                  |    6 
 src/f_ct.c                                    |  153 +++++
 src/nf-ct-dump.c                              |   88 +++
 src/nf-monitor.c                              |  115 ++++
 13 files changed, 1818 insertions(+), 1 deletion(-)

Index: libnl/include/netlink-types.h
===================================================================
--- libnl.orig/include/netlink-types.h	2007-09-03 14:24:29.000000000 +1000
+++ libnl/include/netlink-types.h	2007-09-03 14:24:52.000000000 +1000
@@ -795,4 +795,48 @@ struct genl_family
 	struct nl_list_head	gf_ops;
 };
 
+union nfnl_ct_proto
+{
+	struct {
+		uint16_t	src;
+		uint16_t	dst;
+	} port;
+	struct {
+		uint16_t	id;
+		uint8_t		type;
+		uint8_t		code;
+	} icmp;
+};
+
+struct nfnl_ct_dir {
+	struct nl_addr *	src;
+	struct nl_addr *	dst;
+	union nfnl_ct_proto	proto;
+	uint64_t		packets;
+	uint64_t		bytes;
+};
+
+union nfnl_ct_protoinfo {
+	struct {
+		uint8_t		state;
+	} tcp;
+};
+
+struct nfnl_ct {
+	NLHDR_COMMON
+
+	uint8_t			ct_family;
+	uint8_t			ct_proto;
+	union nfnl_ct_protoinfo	ct_protoinfo;
+
+	uint32_t		ct_status;
+	uint32_t		ct_timeout;
+	uint32_t		ct_mark;
+	uint32_t		ct_use;
+	uint32_t		ct_id;
+
+	struct nfnl_ct_dir	ct_orig;
+	struct nfnl_ct_dir	ct_repl;
+};
+
 #endif
Index: libnl/include/netlink/netfilter/ct.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ libnl/include/netlink/netfilter/ct.h	2007-09-03 14:24:52.000000000 +1000
@@ -0,0 +1,115 @@
+/*
+ * netlink/netfilter/ct.h	Conntrack
+ *
+ *	This library is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU Lesser General Public
+ *	License as published by the Free Software Foundation version 2.1
+ *	of the License.
+ *
+ * Copyright (c) 2003-2006 Thomas Graf <tgraf@suug.ch>
+ * Copyright (c) 2007 Philip Craig <philipc@snapgear.com>
+ * Copyright (c) 2007 Secure Computing Corporation
+ */
+
+#ifndef NETLINK_CT_H_
+#define NETLINK_CT_H_
+
+#include <netlink/netlink.h>
+#include <netlink/addr.h>
+#include <netlink/cache.h>
+#include <netlink/msg.h>
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+struct nfnl_ct;
+
+extern struct nl_object_ops ct_obj_ops;
+
+/* General */
+extern struct nfnl_ct *	nfnl_ct_alloc(void);
+extern struct nl_cache *nfnl_ct_alloc_cache(struct nl_handle *);
+
+extern int		nfnlmsg_ct_group(struct nlmsghdr *);
+extern struct nfnl_ct *	nfnlmsg_ct_parse(struct nlmsghdr *);
+
+extern void		nfnl_ct_get(struct nfnl_ct *);
+extern void		nfnl_ct_put(struct nfnl_ct *);
+
+extern int		nfnl_ct_dump_request(struct nl_handle *);
+
+extern void		nfnl_ct_set_family(struct nfnl_ct *, uint8_t);
+extern uint8_t		nfnl_ct_get_family(const struct nfnl_ct *);
+
+extern void		nfnl_ct_set_proto(struct nfnl_ct *, uint8_t);
+extern int		nfnl_ct_test_proto(const struct nfnl_ct *);
+extern uint8_t		nfnl_ct_get_proto(const struct nfnl_ct *);
+
+extern void		nfnl_ct_set_tcp_state(struct nfnl_ct *, uint8_t);
+extern int		nfnl_ct_test_tcp_state(const struct nfnl_ct *);
+extern uint8_t		nfnl_ct_get_tcp_state(const struct nfnl_ct *);
+extern char *		nfnl_ct_tcp_state2str(uint8_t, char *, size_t);
+extern int		nfnl_ct_str2tcp_state(const char *name);
+
+extern void		nfnl_ct_set_status(struct nfnl_ct *, uint32_t);
+extern int		nfnl_ct_test_status(const struct nfnl_ct *);
+extern uint32_t		nfnl_ct_get_status(const struct nfnl_ct *);
+
+extern void		nfnl_ct_set_timeout(struct nfnl_ct *, uint32_t);
+extern int		nfnl_ct_test_timeout(const struct nfnl_ct *);
+extern uint32_t		nfnl_ct_get_timeout(const struct nfnl_ct *);
+
+extern void		nfnl_ct_set_mark(struct nfnl_ct *, uint32_t);
+extern int		nfnl_ct_test_mark(const struct nfnl_ct *);
+extern uint32_t		nfnl_ct_get_mark(const struct nfnl_ct *);
+
+extern void		nfnl_ct_set_use(struct nfnl_ct *, uint32_t);
+extern int		nfnl_ct_test_use(const struct nfnl_ct *);
+extern uint32_t		nfnl_ct_get_use(const struct nfnl_ct *);
+
+extern void		nfnl_ct_set_id(struct nfnl_ct *, uint32_t);
+extern int		nfnl_ct_test_id(const struct nfnl_ct *);
+extern uint32_t		nfnl_ct_get_id(const struct nfnl_ct *);
+
+extern int		nfnl_ct_set_src(struct nfnl_ct *, int,
+					struct nl_addr *);
+extern struct nl_addr *	nfnl_ct_get_src(const struct nfnl_ct *, int);
+
+extern int		nfnl_ct_set_dst(struct nfnl_ct *, int,
+					struct nl_addr *);
+extern struct nl_addr *	nfnl_ct_get_dst(const struct nfnl_ct *, int);
+
+extern void		nfnl_ct_set_src_port(struct nfnl_ct *, int, uint16_t);
+extern int		nfnl_ct_test_src_port(const struct nfnl_ct *, int);
+extern uint16_t		nfnl_ct_get_src_port(const struct nfnl_ct *, int);
+
+extern void		nfnl_ct_set_dst_port(struct nfnl_ct *, int, uint16_t);
+extern int		nfnl_ct_test_dst_port(const struct nfnl_ct *, int);
+extern uint16_t		nfnl_ct_get_dst_port(const struct nfnl_ct *, int);
+
+extern void		nfnl_ct_set_icmp_id(struct nfnl_ct *, int, uint16_t);
+extern int		nfnl_ct_test_icmp_id(const struct nfnl_ct *, int);
+extern uint16_t		nfnl_ct_get_icmp_id(const struct nfnl_ct *, int);
+
+extern void		nfnl_ct_set_icmp_type(struct nfnl_ct *, int, uint8_t);
+extern int		nfnl_ct_test_icmp_type(const struct nfnl_ct *, int);
+extern uint8_t		nfnl_ct_get_icmp_type(const struct nfnl_ct *, int);
+
+extern void		nfnl_ct_set_icmp_code(struct nfnl_ct *, int, uint8_t);
+extern int		nfnl_ct_test_icmp_code(const struct nfnl_ct *, int);
+extern uint8_t		nfnl_ct_get_icmp_code(const struct nfnl_ct *, int);
+
+extern void		nfnl_ct_set_packets(struct nfnl_ct *, int, uint64_t);
+extern int		nfnl_ct_test_packets(const struct nfnl_ct *, int);
+extern uint64_t		nfnl_ct_get_packets(const struct nfnl_ct *,int);
+
+extern void		nfnl_ct_set_bytes(struct nfnl_ct *, int, uint64_t);
+extern int		nfnl_ct_test_bytes(const struct nfnl_ct *, int);
+extern uint64_t		nfnl_ct_get_bytes(const struct nfnl_ct *, int);
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif
Index: libnl/lib/netfilter/ct.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ libnl/lib/netfilter/ct.c	2007-09-03 14:24:52.000000000 +1000
@@ -0,0 +1,422 @@
+/*
+ * lib/netfilter/ct.c	Conntrack
+ *
+ *	This library is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU Lesser General Public
+ *	License as published by the Free Software Foundation version 2.1
+ *	of the License.
+ *
+ * Copyright (c) 2003-2006 Thomas Graf <tgraf@suug.ch>
+ * Copyright (c) 2007 Philip Craig <philipc@snapgear.com>
+ * Copyright (c) 2007 Secure Computing Corporation
+ */
+
+/**
+ * @ingroup nfnl
+ * @defgroup ct Conntrack
+ * @brief
+ * @{
+ */
+
+#include <byteswap.h>
+#include <sys/types.h>
+#include <linux/netfilter/nfnetlink_conntrack.h>
+
+#include <netlink-local.h>
+#include <netlink/attr.h>
+#include <netlink/netfilter/nfnl.h>
+#include <netlink/netfilter/ct.h>
+
+static struct nl_cache_ops nfnl_ct_ops;
+
+#if __BYTE_ORDER == __BIG_ENDIAN
+static uint64_t ntohll(uint64_t x)
+{
+	return x;
+}
+#elif __BYTE_ORDER == __LITTLE_ENDIAN
+static uint64_t ntohll(uint64_t x)
+{
+	return __bswap_64(x);
+}
+#endif
+
+static struct nla_policy ct_policy[CTA_MAX+1] = {
+	[CTA_TUPLE_ORIG]	= { .type = NLA_NESTED },
+	[CTA_TUPLE_REPLY]	= { .type = NLA_NESTED },
+	[CTA_STATUS]		= { .type = NLA_U32 },
+	[CTA_PROTOINFO]		= { .type = NLA_NESTED },
+	//[CTA_HELP]
+	//[CTA_NAT_SRC]
+	[CTA_TIMEOUT]		= { .type = NLA_U32 },
+	[CTA_MARK]		= { .type = NLA_U32 },
+	[CTA_COUNTERS_ORIG]	= { .type = NLA_NESTED },
+	[CTA_COUNTERS_REPLY]	= { .type = NLA_NESTED },
+	[CTA_USE]		= { .type = NLA_U32 },
+	[CTA_ID]		= { .type = NLA_U32 },
+	//[CTA_NAT_DST]
+};
+
+static struct nla_policy ct_tuple_policy[CTA_TUPLE_MAX+1] = {
+	[CTA_TUPLE_IP]		= { .type = NLA_NESTED },
+	[CTA_TUPLE_PROTO]	= { .type = NLA_NESTED },
+};
+
+static struct nla_policy ct_ip_policy[CTA_IP_MAX+1] = {
+	[CTA_IP_V4_SRC]		= { .type = NLA_U32 },
+	[CTA_IP_V4_DST]		= { .type = NLA_U32 },
+	[CTA_IP_V6_SRC]		= { .minlen = 16 },
+	[CTA_IP_V6_DST]		= { .minlen = 16 },
+};
+
+static struct nla_policy ct_proto_policy[CTA_PROTO_MAX+1] = {
+	[CTA_PROTO_NUM]		= { .type = NLA_U8 },
+	[CTA_PROTO_SRC_PORT]	= { .type = NLA_U16 },
+	[CTA_PROTO_DST_PORT]	= { .type = NLA_U16 },
+	[CTA_PROTO_ICMP_ID]	= { .type = NLA_U16 },
+	[CTA_PROTO_ICMP_TYPE]	= { .type = NLA_U8 },
+	[CTA_PROTO_ICMP_CODE]	= { .type = NLA_U8 },
+	[CTA_PROTO_ICMPV6_ID]	= { .type = NLA_U16 },
+	[CTA_PROTO_ICMPV6_TYPE]	= { .type = NLA_U8 },
+	[CTA_PROTO_ICMPV6_CODE]	= { .type = NLA_U8 },
+};
+
+static struct nla_policy ct_protoinfo_policy[CTA_PROTOINFO_MAX+1] = {
+	[CTA_PROTOINFO_TCP]	= { .type = NLA_NESTED },
+};
+
+static struct nla_policy ct_protoinfo_tcp_policy[CTA_PROTOINFO_TCP_MAX+1] = {
+	[CTA_PROTOINFO_TCP_STATE]		= { .type = NLA_U8 },
+	[CTA_PROTOINFO_TCP_WSCALE_ORIGINAL]	= { .type = NLA_U8 },
+	[CTA_PROTOINFO_TCP_WSCALE_REPLY]	= { .type = NLA_U8 },
+	[CTA_PROTOINFO_TCP_FLAGS_ORIGINAL]	= { .minlen = 2 },
+	[CTA_PROTOINFO_TCP_FLAGS_REPLY]		= { .minlen = 2 },
+
+};
+
+static struct nla_policy ct_counters_policy[CTA_COUNTERS_MAX+1] = {
+	[CTA_COUNTERS_PACKETS]	= { .type = NLA_U64 },
+	[CTA_COUNTERS_BYTES]	= { .type = NLA_U64 },
+	[CTA_COUNTERS32_PACKETS]= { .type = NLA_U32 },
+	[CTA_COUNTERS32_BYTES]	= { .type = NLA_U32 },
+};
+
+static int ct_parse_ip(struct nfnl_ct *ct, int repl, struct nlattr *attr)
+{
+	struct nlattr *tb[CTA_IP_MAX+1];
+	struct nl_addr *addr;
+	int err;
+
+        nla_parse_nested(tb, CTA_IP_MAX, attr, ct_ip_policy);
+
+	if (tb[CTA_IP_V4_SRC]) {
+		addr = nla_get_addr(tb[CTA_IP_V4_SRC], AF_INET);
+		if (addr == NULL)
+			goto errout_errno;
+		err = nfnl_ct_set_src(ct, repl, addr);
+		nl_addr_put(addr);
+		if (err < 0)
+			goto errout;
+	}
+	if (tb[CTA_IP_V4_DST]) {
+		addr = nla_get_addr(tb[CTA_IP_V4_DST], AF_INET);
+		if (addr == NULL)
+			goto errout_errno;
+		err = nfnl_ct_set_dst(ct, repl, addr);
+		nl_addr_put(addr);
+		if (err < 0)
+			goto errout;
+	}
+	if (tb[CTA_IP_V6_SRC]) {
+		addr = nla_get_addr(tb[CTA_IP_V6_SRC], AF_INET6);
+		if (addr == NULL)
+			goto errout_errno;
+		err = nfnl_ct_set_src(ct, repl, addr);
+		nl_addr_put(addr);
+		if (err < 0)
+			goto errout;
+	}
+	if (tb[CTA_IP_V6_DST]) {
+		addr = nla_get_addr(tb[CTA_IP_V6_DST], AF_INET6);
+		if (addr == NULL)
+			goto errout_errno;
+		err = nfnl_ct_set_dst(ct, repl, addr);
+		nl_addr_put(addr);
+		if (err < 0)
+			goto errout;
+	}
+
+	return 0;
+
+errout_errno:
+	return nl_get_errno();
+errout:
+	return err;
+}
+
+static void ct_parse_proto(struct nfnl_ct *ct, int repl, struct nlattr *attr)
+{
+	struct nlattr *tb[CTA_PROTO_MAX+1];
+
+	nla_parse_nested(tb, CTA_PROTO_MAX, attr, ct_proto_policy);
+
+	if (!repl && tb[CTA_PROTO_NUM])
+		nfnl_ct_set_proto(ct, nla_get_u8(tb[CTA_PROTO_NUM]));
+	if (tb[CTA_PROTO_SRC_PORT])
+		nfnl_ct_set_src_port(ct, repl,
+				nla_get_u16(tb[CTA_PROTO_SRC_PORT]));
+	if (tb[CTA_PROTO_DST_PORT])
+		nfnl_ct_set_dst_port(ct, repl,
+				nla_get_u16(tb[CTA_PROTO_DST_PORT]));
+	if (tb[CTA_PROTO_ICMP_ID])
+		nfnl_ct_set_icmp_id(ct, repl,
+				nla_get_u16(tb[CTA_PROTO_ICMP_ID]));
+	if (tb[CTA_PROTO_ICMP_TYPE])
+		nfnl_ct_set_icmp_type(ct, repl,
+				nla_get_u8(tb[CTA_PROTO_ICMP_TYPE]));
+	if (tb[CTA_PROTO_ICMP_CODE])
+		nfnl_ct_set_icmp_code(ct, repl,
+				nla_get_u8(tb[CTA_PROTO_ICMP_CODE]));
+}
+
+static int ct_parse_tuple(struct nfnl_ct *ct, int repl, struct nlattr *attr)
+{
+	struct nlattr *tb[CTA_TUPLE_MAX+1];
+	int err;
+
+	nla_parse_nested(tb, CTA_TUPLE_MAX, attr, ct_tuple_policy);
+
+	if (tb[CTA_TUPLE_IP]) {
+		err = ct_parse_ip(ct, repl, tb[CTA_TUPLE_IP]);
+		if (err < 0)
+			return err;
+	}
+	if (tb[CTA_TUPLE_PROTO])
+		ct_parse_proto(ct, repl, tb[CTA_TUPLE_PROTO]);
+	return 0;
+}
+
+static void ct_parse_protoinfo_tcp(struct nfnl_ct *ct, struct nlattr *attr)
+{
+	struct nlattr *tb[CTA_PROTOINFO_TCP_MAX+1];
+
+	nla_parse_nested(tb, CTA_PROTOINFO_TCP_MAX, attr,
+			 ct_protoinfo_tcp_policy);
+
+	if (tb[CTA_PROTOINFO_TCP_STATE])
+		nfnl_ct_set_tcp_state(ct,
+				nla_get_u8(tb[CTA_PROTOINFO_TCP_STATE]));
+}
+
+static void ct_parse_protoinfo(struct nfnl_ct *ct, struct nlattr *attr)
+{
+	struct nlattr *tb[CTA_PROTOINFO_MAX+1];
+
+	nla_parse_nested(tb, CTA_PROTOINFO_MAX, attr, ct_protoinfo_policy);
+
+	if (tb[CTA_PROTOINFO_TCP])
+		ct_parse_protoinfo_tcp(ct, tb[CTA_PROTOINFO_TCP]);
+}
+
+static void ct_parse_counters(struct nfnl_ct *ct, int repl, struct nlattr *attr)
+{
+	struct nlattr *tb[CTA_COUNTERS_MAX+1];
+
+	nla_parse_nested(tb, CTA_COUNTERS_MAX, attr, ct_counters_policy);
+
+	if (tb[CTA_COUNTERS_PACKETS])
+		nfnl_ct_set_packets(ct, repl,
+			ntohll(nla_get_u64(tb[CTA_COUNTERS_PACKETS])));
+	if (tb[CTA_COUNTERS32_PACKETS])
+		nfnl_ct_set_packets(ct, repl,
+			ntohl(nla_get_u32(tb[CTA_COUNTERS32_PACKETS])));
+	if (tb[CTA_COUNTERS_BYTES])
+		nfnl_ct_set_bytes(ct, repl,
+			ntohll(nla_get_u64(tb[CTA_COUNTERS_BYTES])));
+	if (tb[CTA_COUNTERS32_BYTES])
+		nfnl_ct_set_bytes(ct, repl,
+			ntohl(nla_get_u32(tb[CTA_COUNTERS32_BYTES])));
+}
+
+int nfnlmsg_ct_group(struct nlmsghdr *nlh)
+{
+	switch (nfnlmsg_subtype(nlh)) {
+	case IPCTNL_MSG_CT_NEW:
+		if (nlh->nlmsg_flags & (NLM_F_CREATE|NLM_F_EXCL))
+			return NFNLGRP_CONNTRACK_NEW;
+		else
+			return NFNLGRP_CONNTRACK_UPDATE;
+	case IPCTNL_MSG_CT_DELETE:
+		return NFNLGRP_CONNTRACK_DESTROY;
+	default:
+		return NFNLGRP_NONE;
+	}
+}
+
+struct nfnl_ct *nfnlmsg_ct_parse(struct nlmsghdr *nlh)
+{
+	struct nfnl_ct *ct;
+	struct nlattr *tb[CTA_MAX+1];
+	int err;
+
+	ct = nfnl_ct_alloc();
+	if (!ct)
+		return NULL;
+
+	ct->ce_msgtype = nlh->nlmsg_type;
+
+	err = nlmsg_parse(nlh, sizeof(struct nfgenmsg), tb, CTA_MAX,
+			  ct_policy);
+	if (err < 0)
+		goto errout;
+
+	nfnl_ct_set_family(ct, nfnlmsg_family(nlh));
+
+	if (tb[CTA_TUPLE_ORIG]) {
+		err = ct_parse_tuple(ct, 0, tb[CTA_TUPLE_ORIG]);
+		if (err < 0)
+			goto errout;
+	}
+	if (tb[CTA_TUPLE_REPLY]) {
+		err = ct_parse_tuple(ct, 1, tb[CTA_TUPLE_REPLY]);
+		if (err < 0)
+			goto errout;
+	}
+
+	if (tb[CTA_PROTOINFO])
+		ct_parse_protoinfo(ct, tb[CTA_PROTOINFO]);
+
+	if (tb[CTA_STATUS])
+		nfnl_ct_set_status(ct, ntohl(nla_get_u32(tb[CTA_STATUS])));
+	if (tb[CTA_TIMEOUT])
+		nfnl_ct_set_timeout(ct, ntohl(nla_get_u32(tb[CTA_TIMEOUT])));
+	if (tb[CTA_MARK])
+		nfnl_ct_set_mark(ct, ntohl(nla_get_u32(tb[CTA_MARK])));
+	if (tb[CTA_USE])
+		nfnl_ct_set_use(ct, ntohl(nla_get_u32(tb[CTA_USE])));
+	if (tb[CTA_ID])
+		nfnl_ct_set_id(ct, ntohl(nla_get_u32(tb[CTA_ID])));
+
+	if (tb[CTA_COUNTERS_ORIG])
+		ct_parse_counters(ct, 0, tb[CTA_COUNTERS_ORIG]);
+	if (tb[CTA_COUNTERS_REPLY])
+		ct_parse_counters(ct, 1, tb[CTA_COUNTERS_REPLY]);
+
+	return ct;
+
+errout:
+	nfnl_ct_put(ct);
+	return NULL;
+}
+
+static int ct_msg_parser(struct nl_cache_ops *ops, struct sockaddr_nl *who,
+			 struct nlmsghdr *nlh, void *arg)
+{
+	struct nl_parser_param *pp = arg;
+	struct nfnl_ct *ct;
+	int err;
+
+	ct = nfnlmsg_ct_parse(nlh);
+	if (ct == NULL)
+		goto errout_errno;
+
+	err = pp->pp_cb((struct nl_object *) ct, pp);
+	if (err < 0)
+		goto errout;
+
+	return P_ACCEPT;
+
+errout_errno:
+	err = nl_get_errno();
+errout:
+	nfnl_ct_put(ct);
+	return err;
+}
+
+int nfnl_ct_dump_request(struct nl_handle *h)
+{
+	return nfnl_send_simple(h, NFNL_SUBSYS_CTNETLINK, IPCTNL_MSG_CT_GET,
+				NLM_F_DUMP, AF_UNSPEC, 0);
+}
+
+static int ct_request_update(struct nl_cache *c, struct nl_handle *h)
+{
+	return nfnl_ct_dump_request(h);
+}
+
+/**
+ * @name Cache Management
+ * @{
+ */
+
+/**
+ * Build a conntrack cache holding all conntrack currently in the kernel
+ * @arg handle		netlink handle
+ *
+ * Allocates a new cache, initializes it properly and updates it to
+ * contain all conntracks currently in the kernel.
+ *
+ * @note The caller is responsible for destroying and freeing the
+ *       cache after using it.
+ * @return The cache or NULL if an error has occured.
+ */
+struct nl_cache *nfnl_ct_alloc_cache(struct nl_handle *handle)
+{
+	struct nl_cache *cache;
+
+	cache = nl_cache_alloc(&nfnl_ct_ops);
+	if (!cache)
+		return NULL;
+
+	if (handle && nl_cache_refill(handle, cache) < 0) {
+		free(cache);
+		return NULL;
+	}
+
+	return cache;
+}
+
+/** @} */
+
+/**
+ * @name Conntrack Addition
+ * @{
+ */
+
+/** @} */
+
+static struct nl_af_group ct_groups[] = {
+	{ 0, NFNLGRP_CONNTRACK_NEW },
+	{ 0, NFNLGRP_CONNTRACK_UPDATE },
+	{ 0, NFNLGRP_CONNTRACK_DESTROY },
+	{ END_OF_GROUP_LIST },
+};
+
+#define NFNLMSG_CT_TYPE(type) NFNLMSG_TYPE(NFNL_SUBSYS_CTNETLINK, (type))
+static struct nl_cache_ops nfnl_ct_ops = {
+	.co_name		= "netfilter/ct",
+	.co_hdrsize		= NFNL_HDRLEN,
+	.co_msgtypes		= {
+		{ NFNLMSG_CT_TYPE(IPCTNL_MSG_CT_NEW), NL_ACT_NEW, "new" },
+		{ NFNLMSG_CT_TYPE(IPCTNL_MSG_CT_GET), NL_ACT_GET, "get" },
+		{ NFNLMSG_CT_TYPE(IPCTNL_MSG_CT_DELETE), NL_ACT_DEL, "del" },
+		END_OF_MSGTYPES_LIST,
+	},
+	.co_protocol		= NETLINK_NETFILTER,
+	.co_groups		= ct_groups,
+	.co_request_update	= ct_request_update,
+	.co_msg_parser		= ct_msg_parser,
+	.co_obj_ops		= &ct_obj_ops,
+};
+
+static void __init ct_init(void)
+{
+	nl_cache_mngt_register(&nfnl_ct_ops);
+}
+
+static void __exit ct_exit(void)
+{
+	nl_cache_mngt_unregister(&nfnl_ct_ops);
+}
+
+/** @} */
Index: libnl/lib/netfilter/ct_obj.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ libnl/lib/netfilter/ct_obj.c	2007-09-03 14:24:52.000000000 +1000
@@ -0,0 +1,667 @@
+/*
+ * lib/netfilter/ct_obj.c	Conntrack Object
+ *
+ *	This library is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU Lesser General Public
+ *	License as published by the Free Software Foundation version 2.1
+ *	of the License.
+ *
+ * Copyright (c) 2003-2006 Thomas Graf <tgraf@suug.ch>
+ * Copyright (c) 2007 Philip Craig <philipc@snapgear.com>
+ * Copyright (c) 2007 Secure Computing Corporation
+ */
+
+#include <sys/types.h>
+#include <linux/netfilter/nfnetlink_conntrack.h>
+#include <linux/netfilter/nf_conntrack_common.h>
+#include <linux/netfilter/nf_conntrack_tcp.h>
+
+#include <netlink-local.h>
+#include <netlink/netfilter/nfnl.h>
+#include <netlink/netfilter/ct.h>
+
+/** @cond SKIP */
+#define CT_ATTR_FAMILY		(1UL << 0)
+#define CT_ATTR_PROTO		(1UL << 1)
+
+#define CT_ATTR_TCP_STATE	(1UL << 2)
+
+#define CT_ATTR_STATUS		(1UL << 3)
+#define CT_ATTR_TIMEOUT		(1UL << 4)
+#define CT_ATTR_MARK		(1UL << 5)
+#define CT_ATTR_USE		(1UL << 6)
+#define CT_ATTR_ID		(1UL << 7)
+
+#define CT_ATTR_ORIG_SRC	(1UL << 8)
+#define CT_ATTR_ORIG_DST	(1UL << 9)
+#define CT_ATTR_ORIG_SRC_PORT	(1UL << 10)
+#define CT_ATTR_ORIG_DST_PORT	(1UL << 11)
+#define CT_ATTR_ORIG_ICMP_ID	(1UL << 12)
+#define CT_ATTR_ORIG_ICMP_TYPE	(1UL << 13)
+#define CT_ATTR_ORIG_ICMP_CODE	(1UL << 14)
+#define CT_ATTR_ORIG_PACKETS	(1UL << 15)
+#define CT_ATTR_ORIG_BYTES	(1UL << 16)
+
+#define CT_ATTR_REPL_SRC	(1UL << 17)
+#define CT_ATTR_REPL_DST	(1UL << 18)
+#define CT_ATTR_REPL_SRC_PORT	(1UL << 19)
+#define CT_ATTR_REPL_DST_PORT	(1UL << 20)
+#define CT_ATTR_REPL_ICMP_ID	(1UL << 21)
+#define CT_ATTR_REPL_ICMP_TYPE	(1UL << 22)
+#define CT_ATTR_REPL_ICMP_CODE	(1UL << 23)
+#define CT_ATTR_REPL_PACKETS	(1UL << 24)
+#define CT_ATTR_REPL_BYTES	(1UL << 25)
+/** @endcond */
+
+static void ct_free_data(struct nl_object *c)
+{
+	struct nfnl_ct *ct = (struct nfnl_ct *) c;
+
+	if (ct == NULL)
+		return;
+
+	nl_addr_put(ct->ct_orig.src);
+	nl_addr_put(ct->ct_orig.dst);
+	nl_addr_put(ct->ct_repl.src);
+	nl_addr_put(ct->ct_repl.dst);
+}
+
+static int ct_clone(struct nl_object *_dst, struct nl_object *_src)
+{
+	struct nfnl_ct *dst = (struct nfnl_ct *) _dst;
+	struct nfnl_ct *src = (struct nfnl_ct *) _src;
+	struct nl_addr *addr;
+
+	if (src->ct_orig.src) {
+		addr = nl_addr_clone(src->ct_orig.src);
+		if (!addr)
+			goto errout;
+		dst->ct_orig.src = addr;
+	}
+
+	if (src->ct_orig.dst) {
+		addr = nl_addr_clone(src->ct_orig.dst);
+		if (!addr)
+			goto errout;
+		dst->ct_orig.dst = addr;
+	}
+
+	if (src->ct_repl.src) {
+		addr = nl_addr_clone(src->ct_repl.src);
+		if (!addr)
+			goto errout;
+		dst->ct_repl.src = addr;
+	}
+
+	if (src->ct_repl.dst) {
+		addr = nl_addr_clone(src->ct_repl.dst);
+		if (!addr)
+			goto errout;
+		dst->ct_repl.dst = addr;
+	}
+
+	return 0;
+errout:
+	return nl_get_errno();
+}
+
+static void ct_dump_dir(struct nfnl_ct *ct, int repl,
+			struct nl_dump_params *p)
+{
+	struct nl_addr *addr;
+	char addrbuf[64];
+
+	addr = nfnl_ct_get_src(ct, repl);
+	if (addr)
+		dp_dump(p, "src=%s ",
+			nl_addr2str(addr, addrbuf, sizeof(addrbuf)));
+
+	addr = nfnl_ct_get_dst(ct, repl);
+	if (addr)
+		dp_dump(p, "dst=%s ",
+			nl_addr2str(addr, addrbuf, sizeof(addrbuf)));
+
+	if (nfnl_ct_test_src_port(ct, repl))
+		dp_dump(p, "sport=%u ", ntohs(nfnl_ct_get_src_port(ct, repl)));
+	if (nfnl_ct_test_dst_port(ct, repl))
+		dp_dump(p, "dport=%u ", ntohs(nfnl_ct_get_dst_port(ct, repl)));
+
+	if (nfnl_ct_test_icmp_type(ct, repl))
+		dp_dump(p, "type=%d ", nfnl_ct_get_icmp_type(ct, repl));
+	if (nfnl_ct_test_icmp_type(ct, repl))
+		dp_dump(p, "code=%d ", nfnl_ct_get_icmp_code(ct, repl));
+	if (nfnl_ct_test_icmp_type(ct, repl))
+		dp_dump(p, "id=%d ", ntohs(nfnl_ct_get_icmp_id(ct, repl)));
+
+	if (nfnl_ct_test_packets(ct, repl))
+		dp_dump(p, "packets=%llu ", nfnl_ct_get_packets(ct, repl));
+	if (nfnl_ct_test_bytes(ct, repl))
+		dp_dump(p, "bytes=%llu ", nfnl_ct_get_bytes(ct, repl));
+}
+
+/* Compatible with /proc/net/nf_conntrack */
+static int ct_dump(struct nl_object *a, struct nl_dump_params *p)
+{
+	struct nfnl_ct *ct = (struct nfnl_ct *) a;
+	char buf[64];
+	uint32_t status;
+	uint8_t family;
+	uint8_t proto;
+
+	family = nfnl_ct_get_family(ct);
+	dp_dump(p, "%-8s %u ", nl_af2str(family, buf, sizeof(buf)), family);
+
+	if (nfnl_ct_test_proto(ct)) {
+		proto = nfnl_ct_get_proto(ct);
+		dp_dump(p, "%-8s %u ",
+			nl_ip_proto2str(proto, buf, sizeof(buf)), proto);
+	}
+
+	if (nfnl_ct_test_timeout(ct))
+		dp_dump(p, "%ld ", nfnl_ct_get_timeout(ct));
+
+	if (nfnl_ct_test_tcp_state(ct))
+		dp_dump(p, "%s ",
+			nfnl_ct_tcp_state2str(nfnl_ct_get_tcp_state(ct),
+					      buf, sizeof(buf)));
+
+	ct_dump_dir(ct, 0, p);
+
+	status = nfnl_ct_get_status(ct);
+	if (!(status & IPS_SEEN_REPLY))
+		dp_dump(p, "[UNREPLIED] ");
+
+	ct_dump_dir(ct, 1, p);
+
+	if (status & IPS_ASSURED)
+		dp_dump(p, "[ASSURED] ");
+
+	if (nfnl_ct_test_mark(ct))
+		dp_dump(p, "mark=%u ", nfnl_ct_get_mark(ct));
+
+	if (nfnl_ct_test_use(ct))
+		dp_dump(p, "use=%u ", nfnl_ct_get_use(ct));
+
+	dp_dump(p, "\n");
+
+	return 1;
+}
+
+static int ct_compare(struct nl_object *_a, struct nl_object *_b,
+			uint32_t attrs, int flags)
+{
+	struct nfnl_ct *a = (struct nfnl_ct *) _a;
+	struct nfnl_ct *b = (struct nfnl_ct *) _b;
+	int diff = 0;
+
+#define CT_DIFF(ATTR, EXPR) ATTR_DIFF(attrs, CT_ATTR_##ATTR, a, b, EXPR)
+#define CT_DIFF_VAL(ATTR, FIELD) CT_DIFF(ATTR, a->FIELD != b->FIELD)
+#define CT_DIFF_ADDR(ATTR, FIELD) \
+	((flags & LOOSE_FLAG_COMPARISON) \
+		? CT_DIFF(ATTR, nl_addr_cmp_prefix(a->FIELD, b->FIELD)) \
+		: CT_DIFF(ATTR, nl_addr_cmp(a->FIELD, b->FIELD)))
+
+	diff |= CT_DIFF_VAL(FAMILY,		ct_family);
+	diff |= CT_DIFF_VAL(PROTO,		ct_proto);
+	diff |= CT_DIFF_VAL(TCP_STATE,		ct_protoinfo.tcp.state);
+	diff |= CT_DIFF_VAL(STATUS,		ct_status);
+	diff |= CT_DIFF_VAL(TIMEOUT,		ct_timeout);
+	diff |= CT_DIFF_VAL(MARK,		ct_mark);
+	diff |= CT_DIFF_VAL(USE,		ct_use);
+	diff |= CT_DIFF_VAL(ID,			ct_id);
+	diff |= CT_DIFF_ADDR(ORIG_SRC,		ct_orig.src);
+	diff |= CT_DIFF_ADDR(ORIG_DST,		ct_orig.dst);
+	diff |= CT_DIFF_VAL(ORIG_SRC_PORT,	ct_orig.proto.port.src);
+	diff |= CT_DIFF_VAL(ORIG_DST_PORT,	ct_orig.proto.port.dst);
+	diff |= CT_DIFF_VAL(ORIG_ICMP_ID,	ct_orig.proto.icmp.id);
+	diff |= CT_DIFF_VAL(ORIG_ICMP_TYPE,	ct_orig.proto.icmp.type);
+	diff |= CT_DIFF_VAL(ORIG_ICMP_CODE,	ct_orig.proto.icmp.code);
+	diff |= CT_DIFF_VAL(ORIG_PACKETS,	ct_orig.packets);
+	diff |= CT_DIFF_VAL(ORIG_BYTES,		ct_orig.bytes);
+	diff |= CT_DIFF_ADDR(REPL_SRC,		ct_repl.src);
+	diff |= CT_DIFF_ADDR(ORIG_DST,		ct_repl.dst);
+	diff |= CT_DIFF_VAL(REPL_SRC_PORT,	ct_repl.proto.port.src);
+	diff |= CT_DIFF_VAL(REPL_DST_PORT,	ct_repl.proto.port.dst);
+	diff |= CT_DIFF_VAL(REPL_ICMP_ID,	ct_repl.proto.icmp.id);
+	diff |= CT_DIFF_VAL(REPL_ICMP_TYPE,	ct_repl.proto.icmp.type);
+	diff |= CT_DIFF_VAL(REPL_ICMP_CODE,	ct_repl.proto.icmp.code);
+	diff |= CT_DIFF_VAL(REPL_PACKETS,	ct_repl.packets);
+	diff |= CT_DIFF_VAL(REPL_BYTES,		ct_repl.bytes);
+
+#undef CT_DIFF
+#undef CT_DIFF_VAL
+#undef CT_DIFF_ADDR
+
+	return diff;
+}
+
+static struct trans_tbl ct_attrs[] = {
+	__ADD(CT_ATTR_FAMILY,		family)
+	__ADD(CT_ATTR_PROTO,		proto)
+	__ADD(CT_ATTR_TCP_STATE,	tcpstate)
+	__ADD(CT_ATTR_STATUS,		status)
+	__ADD(CT_ATTR_TIMEOUT,		timeout)
+	__ADD(CT_ATTR_MARK,		mark)
+	__ADD(CT_ATTR_USE,		use)
+	__ADD(CT_ATTR_ID,		id)
+	__ADD(CT_ATTR_ORIG_SRC,		origsrc)
+	__ADD(CT_ATTR_ORIG_DST,		origdst)
+	__ADD(CT_ATTR_ORIG_SRC_PORT,	origsrcport)
+	__ADD(CT_ATTR_ORIG_DST_PORT,	origdstport)
+	__ADD(CT_ATTR_ORIG_ICMP_ID,	origicmpid)
+	__ADD(CT_ATTR_ORIG_ICMP_TYPE,	origicmptype)
+	__ADD(CT_ATTR_ORIG_ICMP_CODE,	origicmpcode)
+	__ADD(CT_ATTR_ORIG_PACKETS,	origpackets)
+	__ADD(CT_ATTR_ORIG_BYTES,	origbytes)
+	__ADD(CT_ATTR_REPL_SRC,		replysrc)
+	__ADD(CT_ATTR_REPL_DST,		replydst)
+	__ADD(CT_ATTR_REPL_SRC_PORT,	replysrcport)
+	__ADD(CT_ATTR_REPL_DST_PORT,	replydstport)
+	__ADD(CT_ATTR_REPL_ICMP_ID,	replyicmpid)
+	__ADD(CT_ATTR_REPL_ICMP_TYPE,	replyicmptype)
+	__ADD(CT_ATTR_REPL_ICMP_CODE,	replyicmpcode)
+	__ADD(CT_ATTR_REPL_PACKETS,	replypackets)
+	__ADD(CT_ATTR_REPL_BYTES,	replybytes)
+};
+
+static char *ct_attrs2str(int attrs, char *buf, size_t len)
+{
+	return __flags2str(attrs, buf, len, ct_attrs, ARRAY_SIZE(ct_attrs));
+}
+
+/**
+ * @name Allocation/Freeing
+ * @{
+ */
+
+struct nfnl_ct *nfnl_ct_alloc(void)
+{
+	return (struct nfnl_ct *) nl_object_alloc(&ct_obj_ops);
+}
+
+void nfnl_ct_get(struct nfnl_ct *ct)
+{
+	nl_object_get((struct nl_object *) ct);
+}
+
+void nfnl_ct_put(struct nfnl_ct *ct)
+{
+	nl_object_put((struct nl_object *) ct);
+}
+
+/** @} */
+
+/**
+ * @name Attributes
+ * @{
+ */
+
+void nfnl_ct_set_family(struct nfnl_ct *ct, uint8_t family)
+{
+	ct->ct_family = family;
+	ct->ce_mask |= CT_ATTR_FAMILY;
+}
+
+uint8_t nfnl_ct_get_family(const struct nfnl_ct *ct)
+{
+	if (ct->ce_mask & CT_ATTR_FAMILY)
+		return ct->ct_family;
+	else
+		return AF_UNSPEC;
+}
+
+void nfnl_ct_set_proto(struct nfnl_ct *ct, uint8_t proto)
+{
+	ct->ct_proto = proto;
+	ct->ce_mask |= CT_ATTR_PROTO;
+}
+
+int nfnl_ct_test_proto(const struct nfnl_ct *ct)
+{
+	return !!(ct->ce_mask & CT_ATTR_PROTO);
+}
+
+uint8_t nfnl_ct_get_proto(const struct nfnl_ct *ct)
+{
+	return ct->ct_proto;
+}
+
+void nfnl_ct_set_tcp_state(struct nfnl_ct *ct, uint8_t state)
+{
+	ct->ct_protoinfo.tcp.state = state;
+	ct->ce_mask |= CT_ATTR_TCP_STATE;
+}
+
+int nfnl_ct_test_tcp_state(const struct nfnl_ct *ct)
+{
+	return !!(ct->ce_mask & CT_ATTR_TCP_STATE);
+}
+
+uint8_t nfnl_ct_get_tcp_state(const struct nfnl_ct *ct)
+{
+	return ct->ct_protoinfo.tcp.state;
+}
+
+static struct trans_tbl tcp_states[] = {
+	__ADD(TCP_CONNTRACK_NONE,NONE)
+	__ADD(TCP_CONNTRACK_SYN_SENT,SYN_SENT)
+	__ADD(TCP_CONNTRACK_SYN_RECV,SYN_RECV)
+	__ADD(TCP_CONNTRACK_ESTABLISHED,ESTABLISHED)
+	__ADD(TCP_CONNTRACK_FIN_WAIT,FIN_WAIT)
+	__ADD(TCP_CONNTRACK_CLOSE_WAIT,CLOSE_WAIT)
+	__ADD(TCP_CONNTRACK_LAST_ACK,LAST_ACK)
+	__ADD(TCP_CONNTRACK_TIME_WAIT,TIME_WAIT)
+	__ADD(TCP_CONNTRACK_CLOSE,CLOSE)
+	__ADD(TCP_CONNTRACK_LISTEN,LISTEN)
+};
+
+char *nfnl_ct_tcp_state2str(uint8_t state, char *buf, size_t len)
+{
+	return __type2str(state, buf, len, tcp_states, ARRAY_SIZE(tcp_states));
+}
+
+int nfnl_ct_str2tcp_state(const char *name)
+{
+        return __str2type(name, tcp_states, ARRAY_SIZE(tcp_states));
+}
+
+void nfnl_ct_set_status(struct nfnl_ct *ct, uint32_t status)
+{
+	ct->ct_status = status;
+	ct->ce_mask |= CT_ATTR_STATUS;
+}
+
+int nfnl_ct_test_status(const struct nfnl_ct *ct)
+{
+	return !!(ct->ce_mask & CT_ATTR_STATUS);
+}
+
+uint32_t nfnl_ct_get_status(const struct nfnl_ct *ct)
+{
+	return ct->ct_status;
+}
+
+void nfnl_ct_set_timeout(struct nfnl_ct *ct, uint32_t timeout)
+{
+	ct->ct_timeout = timeout;
+	ct->ce_mask |= CT_ATTR_TIMEOUT;
+}
+
+int nfnl_ct_test_timeout(const struct nfnl_ct *ct)
+{
+	return !!(ct->ce_mask & CT_ATTR_TIMEOUT);
+}
+
+uint32_t nfnl_ct_get_timeout(const struct nfnl_ct *ct)
+{
+	return ct->ct_timeout;
+}
+
+void nfnl_ct_set_mark(struct nfnl_ct *ct, uint32_t mark)
+{
+	ct->ct_mark = mark;
+	ct->ce_mask |= CT_ATTR_MARK;
+}
+
+int nfnl_ct_test_mark(const struct nfnl_ct *ct)
+{
+	return !!(ct->ce_mask & CT_ATTR_MARK);
+}
+
+uint32_t nfnl_ct_get_mark(const struct nfnl_ct *ct)
+{
+	return ct->ct_mark;
+}
+
+void nfnl_ct_set_use(struct nfnl_ct *ct, uint32_t use)
+{
+	ct->ct_use = use;
+	ct->ce_mask |= CT_ATTR_USE;
+}
+
+int nfnl_ct_test_use(const struct nfnl_ct *ct)
+{
+	return !!(ct->ce_mask & CT_ATTR_USE);
+}
+
+uint32_t nfnl_ct_get_use(const struct nfnl_ct *ct)
+{
+	return ct->ct_use;
+}
+
+void nfnl_ct_set_id(struct nfnl_ct *ct, uint32_t id)
+{
+	ct->ct_id = id;
+	ct->ce_mask |= CT_ATTR_ID;
+}
+
+int nfnl_ct_test_id(const struct nfnl_ct *ct)
+{
+	return !!(ct->ce_mask & CT_ATTR_ID);
+}
+
+uint32_t nfnl_ct_get_id(const struct nfnl_ct *ct)
+{
+	return ct->ct_id;
+}
+
+static int ct_set_addr(struct nfnl_ct *ct, struct nl_addr *addr,
+		int attr, struct nl_addr ** ct_addr)
+{
+	if (ct->ce_mask & CT_ATTR_FAMILY) {
+		if (addr->a_family != ct->ct_family)
+			return nl_error(EINVAL, "Address family mismatch");
+	} else
+		nfnl_ct_set_family(ct, addr->a_family);
+
+	if (*ct_addr)
+		nl_addr_put(*ct_addr);
+
+	nl_addr_get(addr);
+	*ct_addr = addr;
+	ct->ce_mask |= attr;
+
+	return 0;
+}
+
+int nfnl_ct_set_src(struct nfnl_ct *ct, int repl, struct nl_addr *addr)
+{
+	struct nfnl_ct_dir *dir = repl ? &ct->ct_repl : &ct->ct_orig;
+	int attr = repl ? CT_ATTR_REPL_SRC : CT_ATTR_ORIG_SRC;
+	return ct_set_addr(ct, addr, attr, &dir->src);
+}
+
+int nfnl_ct_set_dst(struct nfnl_ct *ct, int repl, struct nl_addr *addr)
+{
+	struct nfnl_ct_dir *dir = repl ? &ct->ct_repl : &ct->ct_orig;
+	int attr = repl ? CT_ATTR_REPL_DST : CT_ATTR_ORIG_DST;
+	return ct_set_addr(ct, addr, attr, &dir->dst);
+}
+
+struct nl_addr *nfnl_ct_get_src(const struct nfnl_ct *ct, int repl)
+{
+	const struct nfnl_ct_dir *dir = repl ? &ct->ct_repl : &ct->ct_orig;
+	int attr = repl ? CT_ATTR_REPL_SRC : CT_ATTR_ORIG_SRC;
+	if (!(ct->ce_mask & attr))
+		return NULL;
+	return dir->src;
+}
+
+struct nl_addr *nfnl_ct_get_dst(const struct nfnl_ct *ct, int repl)
+{
+	const struct nfnl_ct_dir *dir = repl ? &ct->ct_repl : &ct->ct_orig;
+	int attr = repl ? CT_ATTR_REPL_DST : CT_ATTR_ORIG_DST;
+	if (!(ct->ce_mask & attr))
+		return NULL;
+	return dir->dst;
+}
+
+void nfnl_ct_set_src_port(struct nfnl_ct *ct, int repl, uint16_t port)
+{
+	struct nfnl_ct_dir *dir = repl ? &ct->ct_repl : &ct->ct_orig;
+	int attr = repl ? CT_ATTR_REPL_SRC_PORT : CT_ATTR_ORIG_SRC_PORT;
+
+	dir->proto.port.src = port;
+	ct->ce_mask |= attr;
+}
+
+int nfnl_ct_test_src_port(const struct nfnl_ct *ct, int repl)
+{
+	int attr = repl ? CT_ATTR_REPL_SRC_PORT : CT_ATTR_ORIG_SRC_PORT;
+	return !!(ct->ce_mask & attr);
+}
+
+uint16_t nfnl_ct_get_src_port(const struct nfnl_ct *ct, int repl)
+{
+	const struct nfnl_ct_dir *dir = repl ? &ct->ct_repl : &ct->ct_orig;
+
+	return dir->proto.port.src;
+}
+
+void nfnl_ct_set_dst_port(struct nfnl_ct *ct, int repl, uint16_t port)
+{
+	struct nfnl_ct_dir *dir = repl ? &ct->ct_repl : &ct->ct_orig;
+	int attr = repl ? CT_ATTR_REPL_DST_PORT : CT_ATTR_ORIG_DST_PORT;
+
+	dir->proto.port.dst = port;
+	ct->ce_mask |= attr;
+}
+
+int nfnl_ct_test_dst_port(const struct nfnl_ct *ct, int repl)
+{
+	int attr = repl ? CT_ATTR_REPL_DST_PORT : CT_ATTR_ORIG_DST_PORT;
+	return !!(ct->ce_mask & attr);
+}
+
+uint16_t nfnl_ct_get_dst_port(const struct nfnl_ct *ct, int repl)
+{
+	const struct nfnl_ct_dir *dir = repl ? &ct->ct_repl : &ct->ct_orig;
+
+	return dir->proto.port.dst;
+}
+
+void nfnl_ct_set_icmp_id(struct nfnl_ct *ct, int repl, uint16_t id)
+{
+	struct nfnl_ct_dir *dir = repl ? &ct->ct_repl : &ct->ct_orig;
+	int attr = repl ? CT_ATTR_REPL_ICMP_ID : CT_ATTR_ORIG_ICMP_ID;
+
+	dir->proto.icmp.id = id;
+	ct->ce_mask |= attr;
+}
+
+int nfnl_ct_test_icmp_id(const struct nfnl_ct *ct, int repl)
+{
+	int attr = repl ? CT_ATTR_REPL_ICMP_ID : CT_ATTR_ORIG_ICMP_ID;
+	return !!(ct->ce_mask & attr);
+}
+
+uint16_t nfnl_ct_get_icmp_id(const struct nfnl_ct *ct, int repl)
+{
+	const struct nfnl_ct_dir *dir = repl ? &ct->ct_repl : &ct->ct_orig;
+
+	return dir->proto.icmp.id;
+}
+
+void nfnl_ct_set_icmp_type(struct nfnl_ct *ct, int repl, uint8_t type)
+{
+	struct nfnl_ct_dir *dir = repl ? &ct->ct_repl : &ct->ct_orig;
+	int attr = repl ? CT_ATTR_REPL_ICMP_TYPE : CT_ATTR_ORIG_ICMP_TYPE;
+
+	dir->proto.icmp.type = type;
+	ct->ce_mask |= attr;
+}
+
+int nfnl_ct_test_icmp_type(const struct nfnl_ct *ct, int repl)
+{
+	int attr = repl ? CT_ATTR_REPL_ICMP_TYPE : CT_ATTR_ORIG_ICMP_TYPE;
+	return !!(ct->ce_mask & attr);
+}
+
+uint8_t nfnl_ct_get_icmp_type(const struct nfnl_ct *ct, int repl)
+{
+	const struct nfnl_ct_dir *dir = repl ? &ct->ct_repl : &ct->ct_orig;
+
+	return dir->proto.icmp.type;
+}
+
+void nfnl_ct_set_icmp_code(struct nfnl_ct *ct, int repl, uint8_t code)
+{
+	struct nfnl_ct_dir *dir = repl ? &ct->ct_repl : &ct->ct_orig;
+	int attr = repl ? CT_ATTR_REPL_ICMP_CODE : CT_ATTR_ORIG_ICMP_CODE;
+
+	dir->proto.icmp.code = code;
+	ct->ce_mask |= attr;
+}
+
+int nfnl_ct_test_icmp_code(const struct nfnl_ct *ct, int repl)
+{
+	int attr = repl ? CT_ATTR_REPL_ICMP_CODE : CT_ATTR_ORIG_ICMP_CODE;
+	return !!(ct->ce_mask & attr);
+}
+
+uint8_t nfnl_ct_get_icmp_code(const struct nfnl_ct *ct, int repl)
+{
+	const struct nfnl_ct_dir *dir = repl ? &ct->ct_repl : &ct->ct_orig;
+
+	return dir->proto.icmp.code;
+}
+
+void nfnl_ct_set_packets(struct nfnl_ct *ct, int repl, uint64_t packets)
+{
+	struct nfnl_ct_dir *dir = repl ? &ct->ct_repl : &ct->ct_orig;
+	int attr = repl ? CT_ATTR_REPL_PACKETS : CT_ATTR_ORIG_PACKETS;
+
+	dir->packets = packets;
+	ct->ce_mask |= attr;
+}
+
+int nfnl_ct_test_packets(const struct nfnl_ct *ct, int repl)
+{
+	int attr = repl ? CT_ATTR_REPL_PACKETS : CT_ATTR_ORIG_PACKETS;
+	return !!(ct->ce_mask & attr);
+}
+
+uint64_t nfnl_ct_get_packets(const struct nfnl_ct *ct, int repl)
+{
+	const struct nfnl_ct_dir *dir = repl ? &ct->ct_repl : &ct->ct_orig;
+
+	return dir->packets;
+}
+
+void nfnl_ct_set_bytes(struct nfnl_ct *ct, int repl, uint64_t bytes)
+{
+	struct nfnl_ct_dir *dir = repl ? &ct->ct_repl : &ct->ct_orig;
+	int attr = repl ? CT_ATTR_REPL_BYTES : CT_ATTR_ORIG_BYTES;
+
+	dir->bytes = bytes;
+	ct->ce_mask |= attr;
+}
+
+int nfnl_ct_test_bytes(const struct nfnl_ct *ct, int repl)
+{
+	int attr = repl ? CT_ATTR_REPL_BYTES : CT_ATTR_ORIG_BYTES;
+	return !!(ct->ce_mask & attr);
+}
+
+uint64_t nfnl_ct_get_bytes(const struct nfnl_ct *ct, int repl)
+{
+	const struct nfnl_ct_dir *dir = repl ? &ct->ct_repl : &ct->ct_orig;
+
+	return dir->bytes;
+}
+
+/** @} */
+
+struct nl_object_ops ct_obj_ops = {
+	.oo_name		= "netfilter/ct",
+	.oo_size		= sizeof(struct nfnl_ct),
+	.oo_free_data		= ct_free_data,
+	.oo_clone		= ct_clone,
+	.oo_dump[NL_DUMP_BRIEF]	= ct_dump,
+	.oo_dump[NL_DUMP_FULL]	= ct_dump,
+	.oo_dump[NL_DUMP_STATS]	= ct_dump,
+	.oo_compare		= ct_compare,
+	.oo_attrs2str		= ct_attrs2str,
+};
+
+/** @} */
Index: libnl/src/Makefile
===================================================================
--- libnl.orig/src/Makefile	2007-09-03 14:24:29.000000000 +1000
+++ libnl/src/Makefile	2007-09-03 14:24:52.000000000 +1000
@@ -14,7 +14,7 @@ ifeq ($(shell [ ! -r ../Makefile.opts ] 
 endif
 
 LDFLAGS	+= -L../lib -lnl utils.o
-CIN 	:= $(wildcard nl-*.c) $(wildcard genl-*.c)
+CIN 	:= $(wildcard nl-*.c) $(wildcard genl-*.c) $(wildcard nf-*.c)
 TOOLS	:= $(CIN:%.c=%)
 
 all: $(TOOLS)
@@ -29,6 +29,10 @@ genl-%: genl-%.c
 	@echo "  LD $@"; \
 	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)
 
+nf-%: nf-%.c
+	@echo "  LD $@"; \
+	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)
+
 clean:
 	@echo "  CLEAN src"; \
 	rm -f $(TOOLS) utils.o
Index: libnl/src/f_ct.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ libnl/src/f_ct.c	2007-09-03 14:24:52.000000000 +1000
@@ -0,0 +1,153 @@
+/*
+ * src/f_ct.c     	Conntrack Filter
+ *
+ *	This library is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU Lesser General Public
+ *	License as published by the Free Software Foundation version 2.1
+ *	of the License.
+ *
+ * Copyright (c) 2003-2006 Thomas Graf <tgraf@suug.ch>
+ * Copyright (c) 2007 Philip Craig <philipc@snapgear.com>
+ * Copyright (c) 2007 Secure Computing Corporation
+ */
+
+static void get_filter(struct nfnl_ct *ct, int argc, char **argv, int idx)
+{
+	struct nl_addr *a;
+
+	while (argc > idx) {
+		if (arg_match("family")) {
+			if (argc > ++idx) {
+				int family = nl_str2af(argv[idx++]);
+				if (family == AF_UNSPEC)
+					goto err_invaf;
+				nfnl_ct_set_family(ct, family);
+			}
+		} else if (arg_match("proto")) {
+			if (argc > ++idx) {
+				int proto = nl_str2ip_proto(argv[idx++]);
+				if (proto < 0)
+					goto err_invproto;
+				nfnl_ct_set_proto(ct, proto);
+			}
+		} else if (arg_match("tcpstate")) {
+			if (argc > ++idx) {
+				int state = nfnl_ct_str2tcp_state(argv[idx++]);
+				if (state < 0)
+					goto err_invtcpstate;
+				nfnl_ct_set_tcp_state(ct, state);
+			}
+		} else if (arg_match("status")) {
+			if (argc > ++idx)
+				nfnl_ct_set_status(ct, strtoul(argv[idx++], NULL, 0));
+		} else if (arg_match("timeout")) {
+			if (argc > ++idx)
+				nfnl_ct_set_timeout(ct, strtoul(argv[idx++], NULL, 0));
+		} else if (arg_match("mark")) {
+			if (argc > ++idx)
+				nfnl_ct_set_mark(ct, strtoul(argv[idx++], NULL, 0));
+		} else if (arg_match("use")) {
+			if (argc > ++idx)
+				nfnl_ct_set_use(ct, strtoul(argv[idx++], NULL, 0));
+		} else if (arg_match("id")) {
+			if (argc > ++idx)
+				nfnl_ct_set_id(ct, strtoul(argv[idx++], NULL, 0));
+		} else if (arg_match("origsrc")) {
+			if (argc > ++idx) {
+				a = nl_addr_parse(argv[idx++],
+						  nfnl_ct_get_family(ct));
+				if (!a)
+					goto err_invaddr;
+				nfnl_ct_set_src(ct, 0, a);
+				nl_addr_put(a);
+			}
+		} else if (arg_match("origdst")) {
+			if (argc > ++idx) {
+				a = nl_addr_parse(argv[idx++],
+						  nfnl_ct_get_family(ct));
+				if (!a)
+					goto err_invaddr;
+				nfnl_ct_set_dst(ct, 0, a);
+				nl_addr_put(a);
+			}
+		} else if (arg_match("origsrcport")) {
+			if (argc > ++idx)
+				nfnl_ct_set_src_port(ct, 0, strtoul(argv[idx++], NULL, 0));
+		} else if (arg_match("origdstport")) {
+			if (argc > ++idx)
+				nfnl_ct_set_dst_port(ct, 0, strtoul(argv[idx++], NULL, 0));
+		} else if (arg_match("origicmpid")) {
+			if (argc > ++idx)
+				nfnl_ct_set_icmp_id(ct, 0, strtoul(argv[idx++], NULL, 0));
+		} else if (arg_match("origicmptype")) {
+			if (argc > ++idx)
+				nfnl_ct_set_icmp_type(ct, 0, strtoul(argv[idx++], NULL, 0));
+		} else if (arg_match("origicmpcode")) {
+			if (argc > ++idx)
+				nfnl_ct_set_icmp_code(ct, 0, strtoul(argv[idx++], NULL, 0));
+		} else if (arg_match("origpackets")) {
+			if (argc > ++idx)
+				nfnl_ct_set_packets(ct, 0, strtoul(argv[idx++], NULL, 0));
+		} else if (arg_match("origbytes")) {
+			if (argc > ++idx)
+				nfnl_ct_set_bytes(ct, 0, strtoul(argv[idx++], NULL, 0));
+		} else if (arg_match("replysrc")) {
+			if (argc > ++idx) {
+				a = nl_addr_parse(argv[idx++],
+						  nfnl_ct_get_family(ct));
+				if (!a)
+					goto err_invaddr;
+				nfnl_ct_set_src(ct, 1, a);
+				nl_addr_put(a);
+			}
+		} else if (arg_match("replydst")) {
+			if (argc > ++idx) {
+				a = nl_addr_parse(argv[idx++],
+						  nfnl_ct_get_family(ct));
+				if (!a)
+					goto err_invaddr;
+				nfnl_ct_set_dst(ct, 1, a);
+				nl_addr_put(a);
+			}
+		} else if (arg_match("replysrcport")) {
+			if (argc > ++idx)
+				nfnl_ct_set_src_port(ct, 1, strtoul(argv[idx++], NULL, 0));
+		} else if (arg_match("replydstport")) {
+			if (argc > ++idx)
+				nfnl_ct_set_dst_port(ct, 1, strtoul(argv[idx++], NULL, 0));
+		} else if (arg_match("replyicmpid")) {
+			if (argc > ++idx)
+				nfnl_ct_set_icmp_id(ct, 1, strtoul(argv[idx++], NULL, 0));
+		} else if (arg_match("replyicmptype")) {
+			if (argc > ++idx)
+				nfnl_ct_set_icmp_type(ct, 1, strtoul(argv[idx++], NULL, 0));
+		} else if (arg_match("replyicmpcode")) {
+			if (argc > ++idx)
+				nfnl_ct_set_icmp_code(ct, 1, strtoul(argv[idx++], NULL, 0));
+		} else if (arg_match("replypackets")) {
+			if (argc > ++idx)
+				nfnl_ct_set_packets(ct, 1, strtoul(argv[idx++], NULL, 0));
+		} else if (arg_match("replybytes")) {
+			if (argc > ++idx)
+				nfnl_ct_set_bytes(ct, 1, strtoul(argv[idx++], NULL, 0));
+		} else {
+			fprintf(stderr, "What is '%s'?\n", argv[idx]);
+			exit(1);
+		}
+	}
+
+	return;
+
+err_invproto:
+	fprintf(stderr, "Invalid IP protocol \"%s\".\n", argv[idx-1]);
+	exit(1);
+err_invtcpstate:
+	fprintf(stderr, "Invalid TCP state \"%s\".\n", argv[idx-1]);
+	exit(1);
+err_invaf:
+	fprintf(stderr, "Invalid address family \"%s\"\n", argv[idx-1]);
+	exit(1);
+err_invaddr:
+	fprintf(stderr, "Invalid address \"%s\": %s\n", argv[idx-1], nl_geterror());
+	exit(1);
+}
Index: libnl/src/nf-ct-dump.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ libnl/src/nf-ct-dump.c	2007-09-03 14:24:52.000000000 +1000
@@ -0,0 +1,88 @@
+/*
+ * src/nf-ct-dump.c     Dump conntrack attributes
+ *
+ *	This library is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU Lesser General Public
+ *	License as published by the Free Software Foundation version 2.1
+ *	of the License.
+ *
+ * Copyright (c) 2003-2006 Thomas Graf <tgraf@suug.ch>
+ * Copyright (c) 2007 Philip Craig <philipc@snapgear.com>
+ * Copyright (c) 2007 Secure Computing Corporation
+ */
+
+#include "utils.h"
+#include <netlink/netfilter/ct.h>
+
+#include "f_ct.c"
+
+static void print_usage(void)
+{
+	printf(
+	"Usage: nf-ct-dump <mode> [<filter>]\n"
+	"  mode := { brief | detailed | stats | xml }\n"
+	"  filter := [family FAMILY] [proto PROTO] [tcpstate TCPSTATE]\n"
+	"            [status STATUS] [timeout TIMEOUT] [mark MARK] [use USE] [id ID]\n"
+	"            [origsrc ADDR] [origdst ADDR] [origsrcport PORT] [origdstport PORT]\n"
+	"            [origicmpid ID] [origicmptype TYPE] [origicmpcode CODE]\n"
+	"            [origpackets PACKETS] [origbytes BYTES]\n"
+	"            [replysrc ADDR] [replydst ADDR] [replysrcport PORT] [replydstport PORT]\n"
+	"            [replyicmpid ID] [replyicmptype TYPE] [replyicmpcode CODE]\n"
+	"            [replypackets PACKETS] [replybytes BYTES]\n");
+	exit(1);
+}
+
+int main(int argc, char *argv[])
+{
+	struct nl_handle *nlh;
+	struct nl_cache *ct_cache;
+	struct nfnl_ct *ct;
+	struct nl_dump_params params = {
+		.dp_fd = stdout,
+		.dp_type = NL_DUMP_BRIEF
+	};
+	int err = 1;
+
+	if (nltool_init(argc, argv) < 0)
+		return -1;
+
+	if (argc < 2 || !strcmp(argv[1], "-h"))
+		print_usage();
+
+	nlh = nltool_alloc_handle();
+	if (!nlh)
+		return -1;
+
+	ct = nfnl_ct_alloc();
+	if (!ct)
+		goto errout;
+
+	if (nltool_connect(nlh, NETLINK_NETFILTER) < 0)
+		goto errout_free;
+
+	ct_cache = nfnl_ct_alloc_cache(nlh);
+        if (!ct_cache) {
+		fprintf(stderr, "Unable to retrieve ct cache: %s\n",
+			nl_geterror());
+		goto errout_close;
+	}
+	nl_cache_mngt_provide(ct_cache);
+
+	params.dp_type = nltool_parse_dumptype(argv[1]);
+	if (params.dp_type < 0)
+		goto errout_ct_cache;
+
+	get_filter(ct, argc, argv, 2);
+	nl_cache_dump_filter(ct_cache, &params, (struct nl_object *) ct);
+
+	err = 0;
+
+errout_ct_cache:
+	nl_cache_free(ct_cache);
+errout_close:
+	nl_close(nlh);
+errout_free:
+	nfnl_ct_put(ct);
+errout:
+	return err;
+}
Index: libnl/src/nf-monitor.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ libnl/src/nf-monitor.c	2007-09-03 14:24:52.000000000 +1000
@@ -0,0 +1,115 @@
+/*
+ * src/nf-monitor.c     Monitor netfilter events
+ *
+ *	This library is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU Lesser General Public
+ *	License as published by the Free Software Foundation version 2.1
+ *	of the License.
+ *
+ * Copyright (c) 2003-2006 Thomas Graf <tgraf@suug.ch>
+ * Copyright (c) 2007 Philip Craig <philipc@snapgear.com>
+ * Copyright (c) 2007 Secure Computing Corporation
+ */
+
+#include "utils.h"
+#include <netlink/netfilter/nfnl.h>
+
+static void obj_input(struct nl_object *obj, void *arg)
+{
+	struct nl_dump_params dp = {
+		.dp_type = NL_DUMP_STATS,
+		.dp_fd = stdout,
+		.dp_dump_msgtype = 1,
+	};
+
+	nl_object_dump(obj, &dp);
+}
+
+static int event_input(struct nl_msg *msg, void *arg)
+{
+	if (nl_msg_parse(msg, &obj_input, NULL) < 0)
+		fprintf(stderr, "<<EVENT>> Unknown message type\n");
+
+	/* Exit nl_recvmsgs_def() and return to the main select() */
+	return NL_EXIT;
+}
+
+int main(int argc, char *argv[])
+{
+	struct nl_handle *nlh;
+	int err = 1;
+	int i, idx;
+
+	static const struct {
+		enum nfnetlink_groups gr_id;
+		const char* gr_name;
+	} known_groups[] = {
+		{ NFNLGRP_CONNTRACK_NEW, "ct-new" },
+		{ NFNLGRP_CONNTRACK_UPDATE, "ct-update" },
+		{ NFNLGRP_CONNTRACK_DESTROY, "ct-destroy" },
+		{ NFNLGRP_NONE, NULL }
+	};
+
+	if (nltool_init(argc, argv) < 0)
+		return -1;
+
+	nlh = nltool_alloc_handle();
+	if (nlh == NULL)
+		return -1;
+
+	nl_disable_sequence_check(nlh);
+
+	nl_socket_modify_cb(nlh, NL_CB_VALID, NL_CB_CUSTOM, event_input, NULL);
+
+	if (argc > 1 && !strcasecmp(argv[1], "-h")) {
+		printf("Usage: nf-monitor [<groups>]\n");
+
+		printf("Known groups:");
+		for (i = 0; known_groups[i].gr_id != NFNLGRP_NONE; i++)
+			printf(" %s", known_groups[i].gr_name);
+		printf("\n");
+		return 2;
+	}
+
+	if (nfnl_connect(nlh) < 0) {
+		fprintf(stderr, "%s\n", nl_geterror());
+		goto errout;
+	}
+
+	for (idx = 1; argc > idx; idx++) {
+		for (i = 0; known_groups[i].gr_id != NFNLGRP_NONE; i++) {
+			if (!strcmp(argv[idx], known_groups[i].gr_name)) {
+
+				if (nl_socket_add_membership(nlh, known_groups[i].gr_id) < 0) {
+					fprintf(stderr, "%s: %s\n", argv[idx], nl_geterror());
+					goto errout;
+				}
+
+				break;
+			}
+		}
+		if (known_groups[i].gr_id == NFNLGRP_NONE)
+			fprintf(stderr, "Warning: Unknown group: %s\n", argv[idx]);
+	}
+
+	while (1) {
+		fd_set rfds;
+		int fd, retval;
+
+		fd = nl_socket_get_fd(nlh);
+
+		FD_ZERO(&rfds);
+		FD_SET(fd, &rfds);
+		/* wait for an incoming message on the netlink socket */
+		retval = select(fd+1, &rfds, NULL, NULL, NULL);
+
+		if (retval) {
+			/* FD_ISSET(fd, &rfds) will be true */
+			nl_recvmsgs_def(nlh);
+		}
+	}
+
+	nl_close(nlh);
+errout:
+	return err;
+}
Index: libnl/include/linux/netfilter/nfnetlink_conntrack.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ libnl/include/linux/netfilter/nfnetlink_conntrack.h	2007-09-03 14:24:52.000000000 +1000
@@ -0,0 +1,140 @@
+#ifndef _IPCONNTRACK_NETLINK_H
+#define _IPCONNTRACK_NETLINK_H
+#include <linux/netfilter/nfnetlink.h>
+
+enum cntl_msg_types {
+	IPCTNL_MSG_CT_NEW,
+	IPCTNL_MSG_CT_GET,
+	IPCTNL_MSG_CT_DELETE,
+	IPCTNL_MSG_CT_GET_CTRZERO,
+
+	IPCTNL_MSG_MAX
+};
+
+enum ctnl_exp_msg_types {
+	IPCTNL_MSG_EXP_NEW,
+	IPCTNL_MSG_EXP_GET,
+	IPCTNL_MSG_EXP_DELETE,
+
+	IPCTNL_MSG_EXP_MAX
+};
+
+
+enum ctattr_type {
+	CTA_UNSPEC,
+	CTA_TUPLE_ORIG,
+	CTA_TUPLE_REPLY,
+	CTA_STATUS,
+	CTA_PROTOINFO,
+	CTA_HELP,
+	CTA_NAT_SRC,
+#define CTA_NAT	CTA_NAT_SRC	/* backwards compatibility */
+	CTA_TIMEOUT,
+	CTA_MARK,
+	CTA_COUNTERS_ORIG,
+	CTA_COUNTERS_REPLY,
+	CTA_USE,
+	CTA_ID,
+	CTA_NAT_DST,
+	__CTA_MAX
+};
+#define CTA_MAX (__CTA_MAX - 1)
+
+enum ctattr_tuple {
+	CTA_TUPLE_UNSPEC,
+	CTA_TUPLE_IP,
+	CTA_TUPLE_PROTO,
+	__CTA_TUPLE_MAX
+};
+#define CTA_TUPLE_MAX (__CTA_TUPLE_MAX - 1)
+
+enum ctattr_ip {
+	CTA_IP_UNSPEC,
+	CTA_IP_V4_SRC,
+	CTA_IP_V4_DST,
+	CTA_IP_V6_SRC,
+	CTA_IP_V6_DST,
+	__CTA_IP_MAX
+};
+#define CTA_IP_MAX (__CTA_IP_MAX - 1)
+
+enum ctattr_l4proto {
+	CTA_PROTO_UNSPEC,
+	CTA_PROTO_NUM,
+	CTA_PROTO_SRC_PORT,
+	CTA_PROTO_DST_PORT,
+	CTA_PROTO_ICMP_ID,
+	CTA_PROTO_ICMP_TYPE,
+	CTA_PROTO_ICMP_CODE,
+	CTA_PROTO_ICMPV6_ID,
+	CTA_PROTO_ICMPV6_TYPE,
+	CTA_PROTO_ICMPV6_CODE,
+	__CTA_PROTO_MAX
+};
+#define CTA_PROTO_MAX (__CTA_PROTO_MAX - 1)
+
+enum ctattr_protoinfo {
+	CTA_PROTOINFO_UNSPEC,
+	CTA_PROTOINFO_TCP,
+	__CTA_PROTOINFO_MAX
+};
+#define CTA_PROTOINFO_MAX (__CTA_PROTOINFO_MAX - 1)
+
+enum ctattr_protoinfo_tcp {
+	CTA_PROTOINFO_TCP_UNSPEC,
+	CTA_PROTOINFO_TCP_STATE,
+	CTA_PROTOINFO_TCP_WSCALE_ORIGINAL,
+	CTA_PROTOINFO_TCP_WSCALE_REPLY,
+	CTA_PROTOINFO_TCP_FLAGS_ORIGINAL,
+	CTA_PROTOINFO_TCP_FLAGS_REPLY,
+	__CTA_PROTOINFO_TCP_MAX
+};
+#define CTA_PROTOINFO_TCP_MAX (__CTA_PROTOINFO_TCP_MAX - 1)
+
+enum ctattr_counters {
+	CTA_COUNTERS_UNSPEC,
+	CTA_COUNTERS_PACKETS,		/* old 64bit counters */
+	CTA_COUNTERS_BYTES,		/* old 64bit counters */
+	CTA_COUNTERS32_PACKETS,
+	CTA_COUNTERS32_BYTES,
+	__CTA_COUNTERS_MAX
+};
+#define CTA_COUNTERS_MAX (__CTA_COUNTERS_MAX - 1)
+
+enum ctattr_nat {
+	CTA_NAT_UNSPEC,
+	CTA_NAT_MINIP,
+	CTA_NAT_MAXIP,
+	CTA_NAT_PROTO,
+	__CTA_NAT_MAX
+};
+#define CTA_NAT_MAX (__CTA_NAT_MAX - 1)
+
+enum ctattr_protonat {
+	CTA_PROTONAT_UNSPEC,
+	CTA_PROTONAT_PORT_MIN,
+	CTA_PROTONAT_PORT_MAX,
+	__CTA_PROTONAT_MAX
+};
+#define CTA_PROTONAT_MAX (__CTA_PROTONAT_MAX - 1)
+
+enum ctattr_expect {
+	CTA_EXPECT_UNSPEC,
+	CTA_EXPECT_MASTER,
+	CTA_EXPECT_TUPLE,
+	CTA_EXPECT_MASK,
+	CTA_EXPECT_TIMEOUT,
+	CTA_EXPECT_ID,
+	CTA_EXPECT_HELP_NAME,
+	__CTA_EXPECT_MAX
+};
+#define CTA_EXPECT_MAX (__CTA_EXPECT_MAX - 1)
+
+enum ctattr_help {
+	CTA_HELP_UNSPEC,
+	CTA_HELP_NAME,
+	__CTA_HELP_MAX
+};
+#define CTA_HELP_MAX (__CTA_HELP_MAX - 1)
+
+#endif /* _IPCONNTRACK_NETLINK_H */
Index: libnl/include/netlink/addr.h
===================================================================
--- libnl.orig/include/netlink/addr.h	2007-09-03 14:24:40.000000000 +1000
+++ libnl/include/netlink/addr.h	2007-09-03 14:24:52.000000000 +1000
@@ -35,6 +35,7 @@ extern void		nl_addr_put(struct nl_addr 
 extern int		nl_addr_shared(struct nl_addr *);
 
 extern int		nl_addr_cmp(struct nl_addr *, struct nl_addr *);
+extern int		nl_addr_cmp_prefix(struct nl_addr *, struct nl_addr *);
 extern int		nl_addr_valid(char *, int);
 extern int      	nl_addr_guess_family(struct nl_addr *);
 extern int		nl_addr_fill_sockaddr(struct nl_addr *,
Index: libnl/include/netlink/utils.h
===================================================================
--- libnl.orig/include/netlink/utils.h	2007-09-03 14:24:29.000000000 +1000
+++ libnl/include/netlink/utils.h	2007-09-03 14:24:52.000000000 +1000
@@ -65,6 +65,10 @@ extern int	nl_str2llproto(const char *);
 extern char *	nl_ether_proto2str(int, char *, size_t);
 extern int	nl_str2ether_proto(const char *);
 
+/* IP protocol translations */
+extern char *	nl_ip_proto2str(int, char *, size_t);
+extern int	nl_str2ip_proto(const char *);
+
 #ifdef __cplusplus
 }
 #endif
Index: libnl/lib/addr.c
===================================================================
--- libnl.orig/lib/addr.c	2007-09-03 14:24:40.000000000 +1000
+++ libnl/lib/addr.c	2007-09-03 14:24:52.000000000 +1000
@@ -501,6 +501,34 @@ int nl_addr_cmp(struct nl_addr *a, struc
 }
 
 /**
+ * Compares the prefix of two abstract address objects.
+ * @arg a		A abstract address object.
+ * @arg b		Another abstract address object.
+ *
+ * @return Integer less than, equal to or greather than zero if \c is found,
+ *         respectively to be less than, to, or be greater than \c b.
+ */
+int nl_addr_cmp_prefix(struct nl_addr *a, struct nl_addr *b)
+{
+	int d = a->a_family - b->a_family;
+
+	if (d == 0) {
+		int len = min(a->a_prefixlen, b->a_prefixlen);
+		int bytes = len / 8;
+
+		d = memcmp(a->a_addr, b->a_addr, bytes);
+		if (d == 0) {
+			int mask = (1UL << (len % 8)) - 1UL;
+
+			d = (a->a_addr[bytes] & mask) -
+			    (b->a_addr[bytes] & mask);
+		}
+	}
+
+	return d;
+}
+
+/**
  * Check if an address matches a certain family.
  * @arg addr		Address represented as character string.
  * @arg family		Desired address family.
Index: libnl/lib/utils.c
===================================================================
--- libnl.orig/lib/utils.c	2007-09-03 14:24:29.000000000 +1000
+++ libnl/lib/utils.c	2007-09-03 14:24:52.000000000 +1000
@@ -662,4 +662,40 @@ int nl_str2ether_proto(const char *name)
 
 /** @} */
 
+/**
+ * @name IP Protocol Translations
+ * @{
+ */
+
+char *nl_ip_proto2str(int proto, char *buf, size_t len)
+{
+	struct protoent *p = getprotobynumber(proto);
+
+	if (p) {
+		snprintf(buf, len, "%s", p->p_name);
+		return buf;
+	}
+
+	snprintf(buf, len, "0x%x", proto);
+	return buf;
+}
+
+int nl_str2ip_proto(const char *name)
+{
+	struct protoent *p = getprotobyname(name);
+	unsigned long l;
+	char *end;
+
+	if (p)
+		return p->p_proto;
+
+	l = strtoul(name, &end, 0);
+	if (l == ULONG_MAX || *end != '\0')
+		return -1;
+
+	return (int) l;
+}
+
+/** @} */
+
 /** @} */

--------------090800060000070204090406--
