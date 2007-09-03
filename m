From: Philip Craig <philipc@snapgear.com>
Subject: [PATCH 3/3] libnl: add netfilter log support
Date: Mon, 03 Sep 2007 15:12:32 +1000
Message-ID: <46DB97C0.3060602@snapgear.com>
References: <46DB9716.1020400@snapgear.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000801050201070702040103"
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
--------------000801050201070702040103
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit



--------------000801050201070702040103
Content-Type: text/x-diff;
 name="nfnl_log.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nfnl_log.patch"

---
 include/linux/netfilter/nfnetlink_log.h |   96 +++++++
 include/netlink-types.h                 |   22 +
 include/netlink/netfilter/log.h         |  105 +++++++
 lib/netfilter/log.c                     |  349 ++++++++++++++++++++++++++
 lib/netfilter/log_obj.c                 |  425 ++++++++++++++++++++++++++++++++
 src/nf-log.c                            |  142 ++++++++++
 6 files changed, 1139 insertions(+)

Index: libnl/include/netlink-types.h
===================================================================
--- libnl.orig/include/netlink-types.h	2007-09-03 14:32:20.000000000 +1000
+++ libnl/include/netlink-types.h	2007-09-03 14:32:21.000000000 +1000
@@ -839,4 +839,26 @@ struct nfnl_ct {
 	struct nfnl_ct_dir	ct_repl;
 };
 
+struct nfnl_log {
+	NLHDR_COMMON
+
+	uint8_t			log_family;
+	uint8_t			log_hook;
+	uint16_t		log_hwproto;
+	uint32_t		log_mark;
+	struct timeval		log_timestamp;
+	uint32_t		log_indev;
+	uint32_t		log_outdev;
+	uint32_t		log_physindev;
+	uint32_t		log_physoutdev;
+	uint8_t			log_hwaddr[8];
+	int			log_hwaddr_len;
+	void *			log_payload;
+	int			log_payload_len;
+	char *			log_prefix;
+	uint32_t		log_uid;
+	uint32_t		log_seq;
+	uint32_t		log_seq_global;
+};
+
 #endif
Index: libnl/include/netlink/netfilter/log.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ libnl/include/netlink/netfilter/log.h	2007-09-03 14:32:21.000000000 +1000
@@ -0,0 +1,105 @@
+/*
+ * netlink/netfilter/log.h	Netfilter Log
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
+#ifndef NETLINK_LOG_H_
+#define NETLINK_LOG_H_
+
+#include <netlink/netlink.h>
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+struct nl_handle;
+struct nlmsghdr;
+struct nfnl_log;
+
+extern struct nl_object_ops log_obj_ops;
+
+/* General */
+extern struct nfnl_log *nfnl_log_alloc(void);
+extern struct nfnl_log *nfnlmsg_log_parse(struct nlmsghdr *);
+
+extern void		nfnl_log_get(struct nfnl_log *);
+extern void		nfnl_log_put(struct nfnl_log *);
+
+extern struct nl_msg *	nfnl_log_build_bind(uint16_t);;
+extern int		nfnl_log_bind(struct nl_handle *, uint16_t);
+extern struct nl_msg *	nfnl_log_build_unbind(uint16_t);
+extern int		nfnl_log_unbind(struct nl_handle *, uint16_t);
+extern struct nl_msg *	nfnl_log_build_pf_bind(uint8_t);
+extern int		nfnl_log_pf_bind(struct nl_handle *, uint8_t);
+extern struct nl_msg *	nfnl_log_build_pf_unbind(uint8_t);
+extern int		nfnl_log_pf_unbind(struct nl_handle *, uint8_t);
+extern struct nl_msg *	nfnl_log_build_mode(uint16_t, uint8_t, uint32_t);
+extern int		nfnl_log_set_mode(struct nl_handle *, uint16_t,
+					  uint8_t, uint32_t);
+
+extern void		nfnl_log_set_family(struct nfnl_log *, uint8_t);
+extern uint8_t		nfnl_log_get_family(const struct nfnl_log *);
+
+extern void		nfnl_log_set_hwproto(struct nfnl_log *, uint16_t);
+extern int		nfnl_log_test_hwproto(const struct nfnl_log *);
+extern uint16_t		nfnl_log_get_hwproto(const struct nfnl_log *);
+
+extern void		nfnl_log_set_hook(struct nfnl_log *, uint8_t);
+extern int		nfnl_log_test_hook(const struct nfnl_log *);
+extern uint8_t		nfnl_log_get_hook(const struct nfnl_log *);
+
+extern void		nfnl_log_set_mark(struct nfnl_log *, uint32_t);
+extern int		nfnl_log_test_mark(const struct nfnl_log *);
+extern uint32_t		nfnl_log_get_mark(const struct nfnl_log *);
+
+extern void		nfnl_log_set_timestamp(struct nfnl_log *,
+					       struct timeval *);
+extern const struct timeval *nfnl_log_get_timestamp(const struct nfnl_log *);
+
+extern void		nfnl_log_set_indev(struct nfnl_log *, uint32_t);
+extern uint32_t		nfnl_log_get_indev(const struct nfnl_log *);
+
+extern void		nfnl_log_set_outdev(struct nfnl_log *, uint32_t);
+extern uint32_t		nfnl_log_get_outdev(const struct nfnl_log *);
+
+extern void		nfnl_log_set_physindev(struct nfnl_log *, uint32_t);
+extern uint32_t		nfnl_log_get_physindev(const struct nfnl_log *);
+
+extern void		nfnl_log_set_physoutdev(struct nfnl_log *, uint32_t);
+extern uint32_t		nfnl_log_get_physoutdev(const struct nfnl_log *);
+
+extern void		nfnl_log_set_hwaddr(struct nfnl_log *, uint8_t *, int);
+extern const uint8_t *	nfnl_log_get_hwaddr(const struct nfnl_log *, int *);
+
+extern int		nfnl_log_set_payload(struct nfnl_log *, uint8_t *, int);
+extern const void *	nfnl_log_get_payload(const struct nfnl_log *, int *);
+
+extern int		nfnl_log_set_prefix(struct nfnl_log *, void *);
+extern const char *	nfnl_log_get_prefix(const struct nfnl_log *);
+
+extern void		nfnl_log_set_uid(struct nfnl_log *, uint32_t);
+extern int		nfnl_log_test_uid(const struct nfnl_log *);
+extern uint32_t		nfnl_log_get_uid(const struct nfnl_log *);
+
+extern void		nfnl_log_set_seq(struct nfnl_log *, uint32_t);
+extern int		nfnl_log_test_seq(const struct nfnl_log *);
+extern uint32_t		nfnl_log_get_seq(const struct nfnl_log *);
+
+extern void		nfnl_log_set_seq_global(struct nfnl_log *, uint32_t);
+extern int		nfnl_log_test_seq_global(const struct nfnl_log *);
+extern uint32_t		nfnl_log_get_seq_global(const struct nfnl_log *);
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif
+
Index: libnl/lib/netfilter/log.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ libnl/lib/netfilter/log.c	2007-09-03 14:32:21.000000000 +1000
@@ -0,0 +1,349 @@
+/*
+ * lib/netfilter/log.c	Netfilter Log
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
+ * @defgroup log Log
+ * @brief
+ * @{
+ */
+
+#include <sys/types.h>
+#include <linux/netfilter/nfnetlink_log.h>
+
+#include <netlink-local.h>
+#include <netlink/attr.h>
+#include <netlink/netfilter/nfnl.h>
+#include <netlink/netfilter/log.h>
+
+static struct nl_cache_ops nfnl_log_ops;
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
+static struct nla_policy log_policy[NFULA_MAX+1] = {
+	[NFULA_PACKET_HDR]		= {
+		.minlen = sizeof(struct nfulnl_msg_packet_hdr)
+	},
+	[NFULA_MARK]			= { .type = NLA_U32 },
+	[NFULA_TIMESTAMP]		= {
+		.minlen = sizeof(struct nfulnl_msg_packet_timestamp)
+	},
+	[NFULA_IFINDEX_INDEV]		= { .type = NLA_U32 },
+	[NFULA_IFINDEX_OUTDEV]		= { .type = NLA_U32 },
+	[NFULA_IFINDEX_PHYSINDEV]	= { .type = NLA_U32 },
+	[NFULA_IFINDEX_PHYSOUTDEV]	= { .type = NLA_U32 },
+	[NFULA_HWADDR]			= {
+		.minlen = sizeof(struct nfulnl_msg_packet_hw)
+	},
+	//[NFULA_PAYLOAD]
+	[NFULA_PREFIX]			= { .type = NLA_STRING, },
+	[NFULA_UID]			= { .type = NLA_U32 },
+	[NFULA_SEQ]			= { .type = NLA_U32 },
+	[NFULA_SEQ_GLOBAL]		= { .type = NLA_U32 },
+};
+
+struct nfnl_log *nfnlmsg_log_parse(struct nlmsghdr *nlh)
+{
+	struct nfnl_log *log;
+	struct nlattr *tb[NFULA_MAX+1];
+	struct nlattr *attr;
+	int err;
+
+	log = nfnl_log_alloc();
+	if (!log)
+		return NULL;
+
+	log->ce_msgtype = nlh->nlmsg_type;
+
+	err = nlmsg_parse(nlh, sizeof(struct nfgenmsg), tb, NFULA_MAX,
+			  log_policy);
+	if (err < 0)
+		goto errout;
+
+	nfnl_log_set_family(log, nfnlmsg_family(nlh));
+
+	attr = tb[NFULA_PACKET_HDR];
+	if (attr) {
+		struct nfulnl_msg_packet_hdr *hdr = nla_data(attr);
+
+		nfnl_log_set_hwproto(log, hdr->hw_protocol);
+		nfnl_log_set_hook(log, hdr->hook);
+	}
+
+	attr = tb[NFULA_MARK];
+	if (attr)
+		nfnl_log_set_mark(log, ntohl(nla_get_u32(attr)));
+
+	attr = tb[NFULA_TIMESTAMP];
+	if (attr) {
+		struct nfulnl_msg_packet_timestamp *timestamp = nla_data(attr);
+		struct timeval tv;
+
+		tv.tv_sec = ntohll(timestamp->sec);
+		tv.tv_usec = ntohll(timestamp->usec);
+		nfnl_log_set_timestamp(log, &tv);
+	}
+
+	attr = tb[NFULA_IFINDEX_INDEV];
+	if (attr)
+		nfnl_log_set_indev(log, ntohl(nla_get_u32(attr)));
+
+	attr = tb[NFULA_IFINDEX_OUTDEV];
+	if (attr)
+		nfnl_log_set_outdev(log, ntohl(nla_get_u32(attr)));
+
+	attr = tb[NFULA_IFINDEX_PHYSINDEV];
+	if (attr)
+		nfnl_log_set_physindev(log, ntohl(nla_get_u32(attr)));
+
+	attr = tb[NFULA_IFINDEX_PHYSOUTDEV];
+	if (attr)
+		nfnl_log_set_physoutdev(log, ntohl(nla_get_u32(attr)));
+
+	attr = tb[NFULA_HWADDR];
+	if (attr) {
+		struct nfulnl_msg_packet_hw *hw = nla_data(attr);
+
+		nfnl_log_set_hwaddr(log, hw->hw_addr, ntohs(hw->hw_addrlen));
+	}
+
+	attr = tb[NFULA_PAYLOAD];
+	if (attr) {
+		err = nfnl_log_set_payload(log, nla_data(attr), nla_len(attr));
+		if (err < 0)
+			goto errout;
+	}
+
+	attr = tb[NFULA_PREFIX];
+	if (attr) {
+		err = nfnl_log_set_prefix(log, nla_data(attr));
+		if (err < 0)
+			goto errout;
+	}
+
+	attr = tb[NFULA_UID];
+	if (attr)
+		nfnl_log_set_uid(log, ntohl(nla_get_u32(attr)));
+
+	attr = tb[NFULA_SEQ];
+	if (attr)
+		nfnl_log_set_seq(log, ntohl(nla_get_u32(attr)));
+
+	attr = tb[NFULA_SEQ_GLOBAL];
+	if (attr)
+		nfnl_log_set_seq_global(log, ntohl(nla_get_u32(attr)));
+
+	return log;
+
+errout:
+	nfnl_log_put(log);
+	return NULL;
+}
+
+static int log_msg_parser(struct nl_cache_ops *ops, struct sockaddr_nl *who,
+			 struct nlmsghdr *nlh, void *arg)
+{
+	struct nl_parser_param *pp = arg;
+	struct nfnl_log *log;
+	int err;
+
+	log = nfnlmsg_log_parse(nlh);
+	if (log == NULL)
+		goto errout_errno;
+
+	err = pp->pp_cb((struct nl_object *) log, pp);
+	if (err < 0)
+		goto errout;
+
+	return P_ACCEPT;
+
+errout_errno:
+	err = nl_get_errno();
+errout:
+	nfnl_log_put(log);
+	return err;
+}
+
+/**
+ * @name Log Commands
+ * @{
+ */
+
+static struct nl_msg *build_log_cmd_msg(uint8_t family, uint16_t queuenum,
+					uint8_t command)
+{
+	struct nl_msg *msg;
+	struct nfulnl_msg_config_cmd cmd;
+
+	msg = nfnlmsg_alloc_simple(NFNL_SUBSYS_ULOG, NFULNL_MSG_CONFIG, 0,
+				   family, queuenum);
+	if (msg == NULL)
+		return NULL;
+
+	cmd.command = command;
+	if (nla_put(msg, NFULA_CFG_CMD, sizeof(cmd), &cmd) < 0)
+		goto nla_put_failure;
+
+	return msg;
+
+nla_put_failure:
+	nlmsg_free(msg);
+	return NULL;
+}
+
+static int send_log_msg(struct nl_handle *handle, struct nl_msg *msg)
+{
+	int err;
+
+	err = nl_send_auto_complete(handle, msg);
+	nlmsg_free(msg);
+	if (err < 0)
+		return err;
+
+	return nl_wait_for_ack(handle);
+}
+
+struct nl_msg *nfnl_log_build_bind(uint16_t queuenum)
+{
+	return build_log_cmd_msg(0, queuenum, NFULNL_CFG_CMD_BIND);
+}
+
+int nfnl_log_bind(struct nl_handle *nlh, uint16_t queuenum)
+{
+	struct nl_msg *msg;
+
+	msg = nfnl_log_build_bind(queuenum);
+	if (!msg)
+		return nl_get_errno();
+
+	return send_log_msg(nlh, msg);
+}
+
+struct nl_msg *nfnl_log_build_unbind(uint16_t queuenum)
+{
+	return build_log_cmd_msg(0, queuenum, NFULNL_CFG_CMD_UNBIND);
+}
+
+int nfnl_log_unbind(struct nl_handle *nlh, uint16_t queuenum)
+{
+	struct nl_msg *msg;
+
+	msg = nfnl_log_build_bind(queuenum);
+	if (!msg)
+		return nl_get_errno();
+
+	return send_log_msg(nlh, msg);
+}
+
+struct nl_msg *nfnl_log_build_pf_bind(uint8_t pf)
+{
+	return build_log_cmd_msg(pf, 0, NFULNL_CFG_CMD_PF_BIND);
+}
+
+int nfnl_log_pf_bind(struct nl_handle *nlh, uint8_t pf)
+{
+	struct nl_msg *msg;
+
+	msg = nfnl_log_build_pf_bind(pf);
+	if (!msg)
+		return nl_get_errno();
+
+	return send_log_msg(nlh, msg);
+}
+
+struct nl_msg *nfnl_log_build_pf_unbind(uint8_t pf)
+{
+	return build_log_cmd_msg(pf, 0, NFULNL_CFG_CMD_PF_UNBIND);
+}
+
+int nfnl_log_pf_unbind(struct nl_handle *nlh, uint8_t pf)
+{
+	struct nl_msg *msg;
+
+	msg = nfnl_log_build_pf_unbind(pf);
+	if (!msg)
+		return nl_get_errno();
+
+	return send_log_msg(nlh, msg);
+}
+
+struct nl_msg *nfnl_log_build_mode(uint16_t queuenum, uint8_t copy_mode,
+				   uint32_t copy_range)
+{
+	struct nl_msg *msg;
+	struct nfulnl_msg_config_mode mode;
+
+	msg = nfnlmsg_alloc_simple(NFNL_SUBSYS_ULOG, NFULNL_MSG_CONFIG, 0,
+			0, queuenum);
+	if (msg == NULL)
+		return NULL;
+
+	mode.copy_mode = copy_mode;
+	mode.copy_range = htonl(copy_range);
+	if (nla_put(msg, NFULA_CFG_MODE, sizeof(mode), &mode) < 0)
+		goto nla_put_failure;
+
+	return msg;
+
+nla_put_failure:
+	nlmsg_free(msg);
+	return NULL;
+}
+
+int nfnl_log_set_mode(struct nl_handle *nlh, uint16_t queuenum,
+		      uint8_t copy_mode, uint32_t copy_range)
+{
+	struct nl_msg *msg;
+
+	msg = nfnl_log_build_mode(queuenum, copy_mode, copy_range);
+	if (!msg)
+		return nl_get_errno();
+	return send_log_msg(nlh, msg);
+}
+
+/** @} */
+
+#define NFNLMSG_LOG_TYPE(type) NFNLMSG_TYPE(NFNL_SUBSYS_ULOG, (type))
+static struct nl_cache_ops nfnl_log_ops = {
+	.co_name		= "netfilter/log",
+	.co_hdrsize		= NFNL_HDRLEN,
+	.co_msgtypes		= {
+		{ NFNLMSG_LOG_TYPE(NFULNL_MSG_PACKET), NL_ACT_NEW, "new" },
+		END_OF_MSGTYPES_LIST,
+	},
+	.co_protocol		= NETLINK_NETFILTER,
+	.co_msg_parser		= log_msg_parser,
+	.co_obj_ops		= &log_obj_ops,
+};
+
+static void __init log_init(void)
+{
+	nl_cache_mngt_register(&nfnl_log_ops);
+}
+
+static void __exit log_exit(void)
+{
+	nl_cache_mngt_unregister(&nfnl_log_ops);
+}
+
+/** @} */
Index: libnl/lib/netfilter/log_obj.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ libnl/lib/netfilter/log_obj.c	2007-09-03 14:32:21.000000000 +1000
@@ -0,0 +1,425 @@
+/*
+ * lib/netfilter/log_obj.c	Netfilter Log Object
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
+#include <netlink-local.h>
+#include <netlink/netfilter/nfnl.h>
+#include <netlink/netfilter/log.h>
+
+/** @cond SKIP */
+#define LOG_ATTR_FAMILY			(1UL << 0)
+#define LOG_ATTR_HWPROTO		(1UL << 1)
+#define LOG_ATTR_HOOK			(1UL << 2)
+#define LOG_ATTR_MARK			(1UL << 3)
+#define LOG_ATTR_TIMESTAMP		(1UL << 4)
+#define LOG_ATTR_INDEV			(1UL << 5)
+#define LOG_ATTR_OUTDEV			(1UL << 6)
+#define LOG_ATTR_PHYSINDEV		(1UL << 7)
+#define LOG_ATTR_PHYSOUTDEV		(1UL << 8)
+#define LOG_ATTR_HWADDR			(1UL << 9)
+#define LOG_ATTR_PAYLOAD		(1UL << 10)
+#define LOG_ATTR_PREFIX			(1UL << 11)
+#define LOG_ATTR_UID			(1UL << 12)
+#define LOG_ATTR_SEQ			(1UL << 13)
+#define LOG_ATTR_SEQ_GLOBAL		(1UL << 14)
+/** @endcond */
+
+static void log_free_data(struct nl_object *c)
+{
+	struct nfnl_log *log = (struct nfnl_log *) c;
+
+	if (log == NULL)
+		return;
+
+	free(log->log_payload);
+	free(log->log_prefix);
+}
+
+static int log_clone(struct nl_object *_dst, struct nl_object *_src)
+{
+	struct nfnl_log *dst = (struct nfnl_log *) _dst;
+	struct nfnl_log *src = (struct nfnl_log *) _src;
+	int err;
+
+	if (src->log_payload) {
+		err = nfnl_log_set_payload(dst, src->log_payload,
+					   src->log_payload_len);
+		if (err < 0)
+			goto errout;
+	}
+
+	if (src->log_prefix) {
+		err = nfnl_log_set_prefix(dst, src->log_prefix);
+		if (err < 0)
+			goto errout;
+	}
+
+	return 0;
+errout:
+	return err;
+}
+
+static int log_dump(struct nl_object *a, struct nl_dump_params *p)
+{
+	struct nfnl_log *log = (struct nfnl_log *) a;
+	struct nl_cache *link_cache;
+	char buf[64];
+
+	link_cache = nl_cache_mngt_require("route/link");
+
+	if (log->ce_mask & LOG_ATTR_PREFIX)
+		dp_dump(p, "%s", log->log_prefix);
+
+	if (log->ce_mask & LOG_ATTR_INDEV) {
+		if (link_cache)
+			dp_dump(p, "IN=%s ",
+				rtnl_link_i2name(link_cache, log->log_indev,
+						 buf, sizeof(buf)));
+		else
+			dp_dump(p, "IN=%d ", log->log_indev);
+	}
+
+	if (log->ce_mask & LOG_ATTR_PHYSINDEV) {
+		if (link_cache)
+			dp_dump(p, "PHYSIN=%s ",
+				rtnl_link_i2name(link_cache, log->log_physindev,
+						 buf, sizeof(buf)));
+		else
+			dp_dump(p, "IN=%d ", log->log_physindev);
+	}
+
+	if (log->ce_mask & LOG_ATTR_OUTDEV) {
+		if (link_cache)
+			dp_dump(p, "OUT=%s ",
+				rtnl_link_i2name(link_cache, log->log_outdev,
+						 buf, sizeof(buf)));
+		else
+			dp_dump(p, "OUT=%d ", log->log_outdev);
+	}
+
+	if (log->ce_mask & LOG_ATTR_PHYSOUTDEV) {
+		if (link_cache)
+			dp_dump(p, "PHYSOUT=%s ",
+				rtnl_link_i2name(link_cache,log->log_physoutdev,
+						 buf, sizeof(buf)));
+		else
+			dp_dump(p, "PHYSOUT=%d ", log->log_physoutdev);
+	}
+
+	if (log->ce_mask & LOG_ATTR_HWADDR) {
+		int i;
+
+		dp_dump(p, "MAC");
+		for (i = 0; i < log->log_hwaddr_len; i++)
+			dp_dump(p, "%c%02x", i?':':'=', log->log_hwaddr[i]);
+		dp_dump(p, " ");
+	}
+
+	/* FIXME: parse the payload to get iptables LOG compatible format */
+
+	if (log->ce_mask & LOG_ATTR_FAMILY)
+		dp_dump(p, "FAMILY=%s ",
+			nl_af2str(log->log_family, buf, sizeof(buf)));
+
+	if (log->ce_mask & LOG_ATTR_HWPROTO)
+		dp_dump(p, "HWPROTO=%s ",
+			nl_ether_proto2str(ntohs(log->log_hwproto),
+					   buf, sizeof(buf)));
+
+	if (log->ce_mask & LOG_ATTR_HOOK)
+		dp_dump(p, "HOOK=%d ", log->log_hook);
+
+	if (log->ce_mask & LOG_ATTR_MARK)
+		dp_dump(p, "MARK=%d ", log->log_mark);
+
+	if (log->ce_mask & LOG_ATTR_PAYLOAD)
+		dp_dump(p, "PAYLOADLEN=%d ", log->log_payload_len);
+
+	if (log->ce_mask & LOG_ATTR_SEQ)
+		dp_dump(p, "SEQ=%d ", log->log_seq);
+
+	if (log->ce_mask & LOG_ATTR_SEQ_GLOBAL)
+		dp_dump(p, "SEQGLOBAL=%d ", log->log_seq_global);
+
+	dp_dump(p, "\n");
+
+	return 1;
+}
+
+/**
+ * @name Allocation/Freeing
+ * @{
+ */
+
+struct nfnl_log *nfnl_log_alloc(void)
+{
+	return (struct nfnl_log *) nl_object_alloc(&log_obj_ops);
+}
+
+void nfnl_log_get(struct nfnl_log *log)
+{
+	nl_object_get((struct nl_object *) log);
+}
+
+void nfnl_log_put(struct nfnl_log *log)
+{
+	nl_object_put((struct nl_object *) log);
+}
+
+/** @} */
+
+/**
+ * @name Attributes
+ * @{
+ */
+
+void nfnl_log_set_family(struct nfnl_log *log, uint8_t family)
+{
+	log->log_family = family;
+	log->ce_mask |= LOG_ATTR_FAMILY;
+}
+
+uint8_t nfnl_log_get_family(const struct nfnl_log *log)
+{
+	if (log->ce_mask & LOG_ATTR_FAMILY)
+		return log->log_family;
+	else
+		return AF_UNSPEC;
+}
+
+void nfnl_log_set_hwproto(struct nfnl_log *log, uint16_t hwproto)
+{
+	log->log_hwproto = hwproto;
+	log->ce_mask |= LOG_ATTR_HWPROTO;
+}
+
+int nfnl_log_test_hwproto(const struct nfnl_log *log)
+{
+	return !!(log->ce_mask & LOG_ATTR_HWPROTO);
+}
+
+uint16_t nfnl_log_get_hwproto(const struct nfnl_log *log)
+{
+	return log->log_hwproto;
+}
+
+void nfnl_log_set_hook(struct nfnl_log *log, uint8_t hook)
+{
+	log->log_hook = hook;
+	log->ce_mask |= LOG_ATTR_HOOK;
+}
+
+int nfnl_log_test_hook(const struct nfnl_log *log)
+{
+	return !!(log->ce_mask & LOG_ATTR_HOOK);
+}
+
+uint8_t nfnl_log_get_hook(const struct nfnl_log *log)
+{
+	return log->log_hook;
+}
+
+void nfnl_log_set_mark(struct nfnl_log *log, uint32_t mark)
+{
+	log->log_mark = mark;
+	log->ce_mask |= LOG_ATTR_MARK;
+}
+
+int nfnl_log_test_mark(const struct nfnl_log *log)
+{
+	return !!(log->ce_mask & LOG_ATTR_MARK);
+}
+
+uint32_t nfnl_log_get_mark(const struct nfnl_log *log)
+{
+	return log->log_mark;
+}
+
+void nfnl_log_set_timestamp(struct nfnl_log *log, struct timeval *tv)
+{
+	log->log_timestamp.tv_sec = tv->tv_sec;
+	log->log_timestamp.tv_usec = tv->tv_usec;
+	log->ce_mask |= LOG_ATTR_TIMESTAMP;
+}
+
+const struct timeval *nfnl_log_get_timestamp(const struct nfnl_log *log)
+{
+	if (!(log->ce_mask & LOG_ATTR_TIMESTAMP))
+		return NULL;
+	return &log->log_timestamp;
+}
+
+void nfnl_log_set_indev(struct nfnl_log *log, uint32_t indev)
+{
+	log->log_indev = indev;
+	log->ce_mask |= LOG_ATTR_INDEV;
+}
+
+uint32_t nfnl_log_get_indev(const struct nfnl_log *log)
+{
+	return log->log_indev;
+}
+
+void nfnl_log_set_outdev(struct nfnl_log *log, uint32_t outdev)
+{
+	log->log_outdev = outdev;
+	log->ce_mask |= LOG_ATTR_OUTDEV;
+}
+
+uint32_t nfnl_log_get_outdev(const struct nfnl_log *log)
+{
+	return log->log_outdev;
+}
+
+void nfnl_log_set_physindev(struct nfnl_log *log, uint32_t physindev)
+{
+	log->log_physindev = physindev;
+	log->ce_mask |= LOG_ATTR_PHYSINDEV;
+}
+
+uint32_t nfnl_log_get_physindev(const struct nfnl_log *log)
+{
+	return log->log_physindev;
+}
+
+void nfnl_log_set_physoutdev(struct nfnl_log *log, uint32_t physoutdev)
+{
+	log->log_physoutdev = physoutdev;
+	log->ce_mask |= LOG_ATTR_PHYSOUTDEV;
+}
+
+uint32_t nfnl_log_get_physoutdev(const struct nfnl_log *log)
+{
+	return log->log_physoutdev;
+}
+
+void nfnl_log_set_hwaddr(struct nfnl_log *log, uint8_t *hwaddr, int len)
+{
+	if (len > sizeof(log->log_hwaddr))
+		len = sizeof(log->log_hwaddr);
+	log->log_hwaddr_len = len;
+	memcpy(log->log_hwaddr, hwaddr, len);
+	log->ce_mask |= LOG_ATTR_HWADDR;
+}
+
+const uint8_t *nfnl_log_get_hwaddr(const struct nfnl_log *log, int *len)
+{
+	if (!(log->ce_mask & LOG_ATTR_HWADDR)) {
+		*len = 0;
+		return NULL;
+	}
+
+	*len = log->log_hwaddr_len;
+	return log->log_hwaddr;
+}
+
+int nfnl_log_set_payload(struct nfnl_log *log, uint8_t *payload, int len)
+{
+	free(log->log_payload);
+	log->log_payload = malloc(len);
+	if (!log->log_payload)
+		return nl_errno(ENOMEM);
+
+	memcpy(log->log_payload, payload, len);
+	log->log_payload_len = len;
+	log->ce_mask |= LOG_ATTR_PAYLOAD;
+	return 0;
+}
+
+const void *nfnl_log_get_payload(const struct nfnl_log *log, int *len)
+{
+	if (!(log->ce_mask & LOG_ATTR_PAYLOAD)) {
+		*len = 0;
+		return NULL;
+	}
+
+	*len = log->log_payload_len;
+	return log->log_payload;
+}
+
+int nfnl_log_set_prefix(struct nfnl_log *log, void *prefix)
+{
+	free(log->log_prefix);
+	log->log_prefix = strdup(prefix);
+	if (!log->log_prefix)
+		return nl_errno(ENOMEM);
+
+	log->ce_mask |= LOG_ATTR_PREFIX;
+	return 0;
+}
+
+const char *nfnl_log_get_prefix(const struct nfnl_log *log)
+{
+	return log->log_prefix;
+}
+
+void nfnl_log_set_uid(struct nfnl_log *log, uint32_t uid)
+{
+	log->log_uid = uid;
+	log->ce_mask |= LOG_ATTR_UID;
+}
+
+int nfnl_log_test_uid(const struct nfnl_log *log)
+{
+	return !!(log->ce_mask & LOG_ATTR_UID);
+}
+
+uint32_t nfnl_log_get_uid(const struct nfnl_log *log)
+{
+	return log->log_uid;
+}
+
+void nfnl_log_set_seq(struct nfnl_log *log, uint32_t seq)
+{
+	log->log_seq = seq;
+	log->ce_mask |= LOG_ATTR_SEQ;
+}
+
+int nfnl_log_test_seq(const struct nfnl_log *log)
+{
+	return !!(log->ce_mask & LOG_ATTR_SEQ);
+}
+
+uint32_t nfnl_log_get_seq(const struct nfnl_log *log)
+{
+	return log->log_seq;
+}
+
+void nfnl_log_set_seq_global(struct nfnl_log *log, uint32_t seq_global)
+{
+	log->log_seq_global = seq_global;
+	log->ce_mask |= LOG_ATTR_SEQ_GLOBAL;
+}
+
+int nfnl_log_test_seq_global(const struct nfnl_log *log)
+{
+	return !!(log->ce_mask & LOG_ATTR_SEQ_GLOBAL);
+}
+
+uint32_t nfnl_log_get_seq_global(const struct nfnl_log *log)
+{
+	return log->log_seq_global;
+}
+
+/** @} */
+
+struct nl_object_ops log_obj_ops = {
+	.oo_name		= "netfilter/log",
+	.oo_size		= sizeof(struct nfnl_log),
+	.oo_free_data		= log_free_data,
+	.oo_clone		= log_clone,
+	.oo_dump[NL_DUMP_BRIEF]	= log_dump,
+	.oo_dump[NL_DUMP_FULL]	= log_dump,
+	.oo_dump[NL_DUMP_STATS]	= log_dump,
+};
+
+/** @} */
Index: libnl/src/nf-log.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ libnl/src/nf-log.c	2007-09-03 14:39:32.000000000 +1000
@@ -0,0 +1,142 @@
+/*
+ * src/nf-log.c     Monitor netfilter log events
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
+#include <linux/netfilter/nfnetlink_log.h>
+
+#include "utils.h"
+#include <netlink/netfilter/nfnl.h>
+#include <netlink/netfilter/log.h>
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
+	struct nl_handle *nfnlh;
+	struct nl_handle *rtnlh;
+        struct nl_cache *link_cache;
+	int err = 1;
+	int family, group;
+
+	if (nltool_init(argc, argv) < 0)
+		return -1;
+
+	nfnlh = nltool_alloc_handle();
+	if (nfnlh == NULL)
+		return -1;
+
+	nl_disable_sequence_check(nfnlh);
+
+	nl_socket_modify_cb(nfnlh, NL_CB_VALID, NL_CB_CUSTOM, event_input, NULL);
+
+	if ((argc > 1 && !strcasecmp(argv[1], "-h")) || argc < 3) {
+		printf("Usage: nf-log family group\n");
+		return 2;
+	}
+
+	if (nfnl_connect(nfnlh) < 0) {
+		fprintf(stderr, "%s\n", nl_geterror());
+		goto errout;
+	}
+
+	family = nl_str2af(argv[1]);
+	if (family == AF_UNSPEC) {
+		fprintf(stderr, "Unknown family: %s\n", argv[1]);
+		goto errout;
+	}
+	if (nfnl_log_pf_unbind(nfnlh, family) < 0) {
+		fprintf(stderr, "%s\n", nl_geterror());
+		goto errout;
+	}
+	if (nfnl_log_pf_bind(nfnlh, family) < 0) {
+		fprintf(stderr, "%s\n", nl_geterror());
+		goto errout;
+	}
+
+	group = nl_str2af(argv[2]);
+	if (nfnl_log_bind(nfnlh, group) < 0) {
+		fprintf(stderr, "%s\n", nl_geterror());
+		goto errout;
+	}
+
+	if (nfnl_log_set_mode(nfnlh, 0, NFULNL_COPY_PACKET, 0xffff) < 0) {
+		fprintf(stderr, "%s\n", nl_geterror());
+		goto errout;
+	}
+
+	rtnlh = nltool_alloc_handle();
+	if (rtnlh == NULL) {
+		goto errout_close;
+	}
+
+	if (nl_connect(rtnlh, NETLINK_ROUTE) < 0) {
+		fprintf(stderr, "%s\n", nl_geterror());
+		goto errout;
+	}
+
+	if ((link_cache = rtnl_link_alloc_cache(rtnlh)) == NULL) {
+		fprintf(stderr, "%s\n", nl_geterror());
+		goto errout_close;
+	}
+
+	nl_cache_mngt_provide(link_cache);
+
+	while (1) {
+		fd_set rfds;
+		int nffd, rtfd, maxfd, retval;
+
+		FD_ZERO(&rfds);
+
+		maxfd = nffd = nl_socket_get_fd(nfnlh);
+		FD_SET(nffd, &rfds);
+
+		rtfd = nl_socket_get_fd(rtnlh);
+		FD_SET(rtfd, &rfds);
+		if (maxfd < rtfd)
+			maxfd = rtfd;
+
+		/* wait for an incoming message on the netlink socket */
+		retval = select(maxfd+1, &rfds, NULL, NULL, NULL);
+
+		if (retval) {
+			if (FD_ISSET(nffd, &rfds))
+				nl_recvmsgs_def(nfnlh);
+			if (FD_ISSET(rtfd, &rfds))
+				nl_recvmsgs_def(rtnlh);
+		}
+	}
+
+	nl_close(rtnlh);
+errout_close:
+	nl_close(nfnlh);
+errout:
+	return err;
+}
Index: libnl/include/linux/netfilter/nfnetlink_log.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ libnl/include/linux/netfilter/nfnetlink_log.h	2007-09-03 14:32:21.000000000 +1000
@@ -0,0 +1,96 @@
+#ifndef _NFNETLINK_LOG_H
+#define _NFNETLINK_LOG_H
+
+/* This file describes the netlink messages (i.e. 'protocol packets'),
+ * and not any kind of function definitions.  It is shared between kernel and
+ * userspace.  Don't put kernel specific stuff in here */
+
+#ifndef aligned_be64
+#define aligned_be64 u_int64_t __attribute__((aligned(8)))
+#endif
+
+#include <linux/types.h>
+#include <linux/netfilter/nfnetlink.h>
+
+enum nfulnl_msg_types {
+	NFULNL_MSG_PACKET,		/* packet from kernel to userspace */
+	NFULNL_MSG_CONFIG,		/* connect to a particular queue */
+
+	NFULNL_MSG_MAX
+};
+
+struct nfulnl_msg_packet_hdr {
+	__be16		hw_protocol;	/* hw protocol (network order) */
+	u_int8_t	hook;		/* netfilter hook */
+	u_int8_t	_pad;
+};
+
+struct nfulnl_msg_packet_hw {
+	__be16		hw_addrlen;
+	u_int16_t	_pad;
+	u_int8_t	hw_addr[8];
+};
+
+struct nfulnl_msg_packet_timestamp {
+	aligned_be64	sec;
+	aligned_be64	usec;
+};
+
+enum nfulnl_attr_type {
+	NFULA_UNSPEC,
+	NFULA_PACKET_HDR,
+	NFULA_MARK,			/* u_int32_t nfmark */
+	NFULA_TIMESTAMP,		/* nfulnl_msg_packet_timestamp */
+	NFULA_IFINDEX_INDEV,		/* u_int32_t ifindex */
+	NFULA_IFINDEX_OUTDEV,		/* u_int32_t ifindex */
+	NFULA_IFINDEX_PHYSINDEV,	/* u_int32_t ifindex */
+	NFULA_IFINDEX_PHYSOUTDEV,	/* u_int32_t ifindex */
+	NFULA_HWADDR,			/* nfulnl_msg_packet_hw */
+	NFULA_PAYLOAD,			/* opaque data payload */
+	NFULA_PREFIX,			/* string prefix */
+	NFULA_UID,			/* user id of socket */
+	NFULA_SEQ,			/* instance-local sequence number */
+	NFULA_SEQ_GLOBAL,		/* global sequence number */
+
+	__NFULA_MAX
+};
+#define NFULA_MAX (__NFULA_MAX - 1)
+
+enum nfulnl_msg_config_cmds {
+	NFULNL_CFG_CMD_NONE,
+	NFULNL_CFG_CMD_BIND,
+	NFULNL_CFG_CMD_UNBIND,
+	NFULNL_CFG_CMD_PF_BIND,
+	NFULNL_CFG_CMD_PF_UNBIND,
+};
+
+struct nfulnl_msg_config_cmd {
+	u_int8_t	command;	/* nfulnl_msg_config_cmds */
+} __attribute__ ((packed));
+
+struct nfulnl_msg_config_mode {
+	__be32		copy_range;
+	u_int8_t	copy_mode;
+	u_int8_t	_pad;
+} __attribute__ ((packed));
+
+enum nfulnl_attr_config {
+	NFULA_CFG_UNSPEC,
+	NFULA_CFG_CMD,			/* nfulnl_msg_config_cmd */
+	NFULA_CFG_MODE,			/* nfulnl_msg_config_mode */
+	NFULA_CFG_NLBUFSIZ,		/* u_int32_t buffer size */
+	NFULA_CFG_TIMEOUT,		/* u_int32_t in 1/100 s */
+	NFULA_CFG_QTHRESH,		/* u_int32_t */
+	NFULA_CFG_FLAGS,		/* u_int16_t */
+	__NFULA_CFG_MAX
+};
+#define NFULA_CFG_MAX (__NFULA_CFG_MAX -1)
+
+#define NFULNL_COPY_NONE	0x00
+#define NFULNL_COPY_META	0x01
+#define NFULNL_COPY_PACKET	0x02
+
+#define NFULNL_CFG_F_SEQ	0x0001
+#define NFULNL_CFG_F_SEQ_GLOBAL	0x0002
+
+#endif /* _NFNETLINK_LOG_H */

--------------000801050201070702040103--
