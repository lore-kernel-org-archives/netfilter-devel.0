From: Patrick McHardy <kaber@trash.net>
Subject: [LIBNL 04/09]: Add nfnetlink_queue support
Date: Fri, 18 Jan 2008 17:55:52 +0100 (MET)
Message-ID: <20080118165519.13385.36701.sendpatchset@localhost.localdomain>
References: <20080118165514.13385.44695.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	philipc@snapgear.com
To: tgraf@suug.ch
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42971 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762035AbYARQzy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Jan 2008 11:55:54 -0500
In-Reply-To: <20080118165514.13385.44695.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 1782a5fba82778d0d10838f511f57b2b2b70966a
Author: Patrick McHardy <kaber@trash.net>
Date:   Fri Jan 18 17:44:08 2008 +0100

    [LIBNL]: Add nfnetlink_queue support
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/include/linux/netfilter/nfnetlink_queue.h b/include/linux/netfilter/nfnetlink_queue.h
new file mode 100644
index 0000000..bf7cfb6
--- /dev/null
+++ b/include/linux/netfilter/nfnetlink_queue.h
@@ -0,0 +1,94 @@
+#ifndef _NFNETLINK_QUEUE_H
+#define _NFNETLINK_QUEUE_H
+
+#include <linux/types.h>
+#include <linux/netfilter/nfnetlink.h>
+
+#ifndef aligned_be64
+#define aligned_be64 u_int64_t __attribute__((aligned(8)))
+#endif
+
+enum nfqnl_msg_types {
+	NFQNL_MSG_PACKET,		/* packet from kernel to userspace */
+	NFQNL_MSG_VERDICT,		/* verdict from userspace to kernel */
+	NFQNL_MSG_CONFIG,		/* connect to a particular queue */
+
+	NFQNL_MSG_MAX
+};
+
+struct nfqnl_msg_packet_hdr {
+	__be32		packet_id;	/* unique ID of packet in queue */
+	__be16		hw_protocol;	/* hw protocol (network order) */
+	u_int8_t	hook;		/* netfilter hook */
+} __attribute__ ((packed));
+
+struct nfqnl_msg_packet_hw {
+	__be16		hw_addrlen;
+	u_int16_t	_pad;
+	u_int8_t	hw_addr[8];
+};
+
+struct nfqnl_msg_packet_timestamp {
+	aligned_be64	sec;
+	aligned_be64	usec;
+};
+
+enum nfqnl_attr_type {
+	NFQA_UNSPEC,
+	NFQA_PACKET_HDR,
+	NFQA_VERDICT_HDR,		/* nfqnl_msg_verdict_hrd */
+	NFQA_MARK,			/* u_int32_t nfmark */
+	NFQA_TIMESTAMP,			/* nfqnl_msg_packet_timestamp */
+	NFQA_IFINDEX_INDEV,		/* u_int32_t ifindex */
+	NFQA_IFINDEX_OUTDEV,		/* u_int32_t ifindex */
+	NFQA_IFINDEX_PHYSINDEV,		/* u_int32_t ifindex */
+	NFQA_IFINDEX_PHYSOUTDEV,	/* u_int32_t ifindex */
+	NFQA_HWADDR,			/* nfqnl_msg_packet_hw */
+	NFQA_PAYLOAD,			/* opaque data payload */
+
+	__NFQA_MAX
+};
+#define NFQA_MAX (__NFQA_MAX - 1)
+
+struct nfqnl_msg_verdict_hdr {
+	__be32 verdict;
+	__be32 id;
+};
+
+
+enum nfqnl_msg_config_cmds {
+	NFQNL_CFG_CMD_NONE,
+	NFQNL_CFG_CMD_BIND,
+	NFQNL_CFG_CMD_UNBIND,
+	NFQNL_CFG_CMD_PF_BIND,
+	NFQNL_CFG_CMD_PF_UNBIND,
+};
+
+struct nfqnl_msg_config_cmd {
+	u_int8_t	command;	/* nfqnl_msg_config_cmds */
+	u_int8_t	_pad;
+	__be16		pf;		/* AF_xxx for PF_[UN]BIND */
+};
+
+enum nfqnl_config_mode {
+	NFQNL_COPY_NONE,
+	NFQNL_COPY_META,
+	NFQNL_COPY_PACKET,
+};
+
+struct nfqnl_msg_config_params {
+	__be32		copy_range;
+	u_int8_t	copy_mode;	/* enum nfqnl_config_mode */
+} __attribute__ ((packed));
+
+
+enum nfqnl_attr_config {
+	NFQA_CFG_UNSPEC,
+	NFQA_CFG_CMD,			/* nfqnl_msg_config_cmd */
+	NFQA_CFG_PARAMS,		/* nfqnl_msg_config_params */
+	NFQA_CFG_QUEUE_MAXLEN,		/* u_int32_t */
+	__NFQA_CFG_MAX
+};
+#define NFQA_CFG_MAX (__NFQA_CFG_MAX-1)
+
+#endif /* _NFNETLINK_QUEUE_H */
diff --git a/include/netlink-types.h b/include/netlink-types.h
index f7c6437..f7bddca 100644
--- a/include/netlink-types.h
+++ b/include/netlink-types.h
@@ -755,4 +755,34 @@ struct nfnl_log {
 	uint32_t		log_seq_global;
 };
 
+struct nfnl_queue {
+	NLHDR_COMMON
+
+	uint16_t		queue_group;
+	uint32_t		queue_maxlen;
+	uint32_t		queue_copy_range;
+	uint8_t			queue_copy_mode;
+};
+
+struct nfnl_queue_msg {
+	NLHDR_COMMON
+
+	uint16_t		queue_msg_group;
+	uint8_t			queue_msg_family;
+	uint8_t			queue_msg_hook;
+	uint16_t		queue_msg_hwproto;
+	uint32_t		queue_msg_packetid;
+	uint32_t		queue_msg_mark;
+	struct timeval		queue_msg_timestamp;
+	uint32_t		queue_msg_indev;
+	uint32_t		queue_msg_outdev;
+	uint32_t		queue_msg_physindev;
+	uint32_t		queue_msg_physoutdev;
+	uint8_t			queue_msg_hwaddr[8];
+	int			queue_msg_hwaddr_len;
+	void *			queue_msg_payload;
+	int			queue_msg_payload_len;
+	uint32_t		queue_msg_verdict;
+};
+
 #endif
diff --git a/include/netlink/netfilter/queue.h b/include/netlink/netfilter/queue.h
new file mode 100644
index 0000000..c88abe2
--- /dev/null
+++ b/include/netlink/netfilter/queue.h
@@ -0,0 +1,86 @@
+/*
+ * netlink/netfilter/queue.h	Netfilter Queue
+ *
+ *	This library is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU Lesser General Public
+ *	License as published by the Free Software Foundation version 2.1
+ *	of the License.
+ *
+ * Copyright (c) 2007, 2008 Patrick McHardy <kaber@trash.net>
+ */
+
+#ifndef NETLINK_QUEUE_H_
+#define NETLINK_QUEUE_H_
+
+#include <netlink/netlink.h>
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+struct nl_handle;
+struct nlmsghdr;
+struct nfnl_queue;
+
+extern struct nl_object_ops queue_obj_ops;
+
+enum nfnl_queue_copy_mode {
+	NFNL_QUEUE_COPY_NONE,
+	NFNL_QUEUE_COPY_META,
+	NFNL_QUEUE_COPY_PACKET,
+};
+
+/* General */
+extern struct nfnl_queue *	nfnl_queue_alloc(void);
+
+extern void			nfnl_queue_get(struct nfnl_queue *);
+extern void			nfnl_queue_put(struct nfnl_queue *);
+
+/* Attributes */
+extern void			nfnl_queue_set_group(struct nfnl_queue *, uint16_t);
+extern int			nfnl_queue_test_group(const struct nfnl_queue *);
+extern uint16_t			nfnl_queue_get_group(const struct nfnl_queue *);
+
+extern void			nfnl_queue_set_maxlen(struct nfnl_queue *, uint32_t);
+extern int			nfnl_queue_test_maxlen(const struct nfnl_queue *);
+extern uint32_t			nfnl_queue_get_maxlen(const struct nfnl_queue *);
+
+extern void			nfnl_queue_set_copy_mode(struct nfnl_queue *,
+							 enum nfnl_queue_copy_mode);
+extern int			nfnl_queue_test_copy_mode(const struct nfnl_queue *);
+extern enum nfnl_queue_copy_mode nfnl_queue_get_copy_mode(const struct nfnl_queue *);
+
+extern char *			nfnl_queue_copy_mode2str(enum nfnl_queue_copy_mode,
+							 char *, size_t);
+extern enum nfnl_queue_copy_mode nfnl_queue_str2copy_mode(const char *);
+
+extern void			nfnl_queue_set_copy_range(struct nfnl_queue *,
+							  uint32_t);
+extern int			nfnl_queue_test_copy_range(const struct nfnl_queue *);
+extern uint32_t			nfnl_queue_get_copy_range(const struct nfnl_queue *);
+
+/* Message construction / sending */
+extern struct nl_msg *		nfnl_queue_build_pf_bind(uint8_t);
+extern int			nfnl_queue_pf_bind(struct nl_handle *, uint8_t);
+
+extern struct nl_msg *		nfnl_queue_build_pf_unbind(uint8_t);
+extern int			nfnl_queue_pf_unbind(struct nl_handle *, uint8_t);
+
+extern struct nl_msg *		nfnl_queue_build_create_request(const struct nfnl_queue *);
+extern int			nfnl_queue_create(struct nl_handle *,
+						  const struct nfnl_queue *);
+
+extern struct nl_msg *		nfnl_queue_build_change_request(const struct nfnl_queue *);
+extern int			nfnl_queue_change(struct nl_handle *,
+						  const struct nfnl_queue *);
+
+extern struct nl_msg *		nfnl_queue_build_delete_request(const struct nfnl_queue *);
+extern int			nfnl_queue_delete(struct nl_handle *,
+						  const struct nfnl_queue *);
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif
+
diff --git a/include/netlink/netfilter/queue_msg.h b/include/netlink/netfilter/queue_msg.h
new file mode 100644
index 0000000..daf7b3c
--- /dev/null
+++ b/include/netlink/netfilter/queue_msg.h
@@ -0,0 +1,101 @@
+/*
+ * netlink/netfilter/queue_msg.h	Netfilter Queue Messages
+ *
+ *	This library is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU Lesser General Public
+ *	License as published by the Free Software Foundation version 2.1
+ *	of the License.
+ *
+ * Copyright (c) 2007, 2008 Patrick McHardy <kaber@trash.net>
+ */
+
+#ifndef NETLINK_QUEUE_MSG_H_
+#define NETLINK_QUEUE_MSG_H_
+
+#include <netlink/netlink.h>
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+struct nl_handle;
+struct nlmsghdr;
+struct nfnl_queue_msg;
+
+extern struct nl_object_ops queue_msg_obj_ops;
+
+/* General */
+extern struct nfnl_queue_msg *	nfnl_queue_msg_alloc(void);
+extern struct nfnl_queue_msg *	nfnlmsg_queue_msg_parse(struct nlmsghdr *);
+
+extern void			nfnl_queue_msg_get(struct nfnl_queue_msg *);
+extern void			nfnl_queue_msg_put(struct nfnl_queue_msg *);
+
+extern void			nfnl_queue_msg_set_group(struct nfnl_queue_msg *, uint16_t);
+extern int			nfnl_queue_msg_test_group(const struct nfnl_queue_msg *);
+extern uint16_t			nfnl_queue_msg_get_group(const struct nfnl_queue_msg *);
+
+extern void			nfnl_queue_msg_set_family(struct nfnl_queue_msg *, uint8_t);
+extern int			nfnl_queue_msg_test_family(const struct nfnl_queue_msg *);
+extern uint8_t			nfnl_queue_msg_get_family(const struct nfnl_queue_msg *);
+
+extern void			nfnl_queue_msg_set_packetid(struct nfnl_queue_msg *, uint32_t);
+extern int			nfnl_queue_msg_test_packetid(const struct nfnl_queue_msg *);
+extern uint16_t			nfnl_queue_msg_get_packetid(const struct nfnl_queue_msg *);
+
+extern void			nfnl_queue_msg_set_hwproto(struct nfnl_queue_msg *, uint16_t);
+extern int			nfnl_queue_msg_test_hwproto(const struct nfnl_queue_msg *);
+extern uint16_t			nfnl_queue_msg_get_hwproto(const struct nfnl_queue_msg *);
+
+extern void			nfnl_queue_msg_set_hook(struct nfnl_queue_msg *, uint8_t);
+extern int			nfnl_queue_msg_test_hook(const struct nfnl_queue_msg *);
+extern uint8_t			nfnl_queue_msg_get_hook(const struct nfnl_queue_msg *);
+
+extern void			nfnl_queue_msg_set_mark(struct nfnl_queue_msg *, uint32_t);
+extern int			nfnl_queue_msg_test_mark(const struct nfnl_queue_msg *);
+extern uint32_t			nfnl_queue_msg_get_mark(const struct nfnl_queue_msg *);
+
+extern void			nfnl_queue_msg_set_timestamp(struct nfnl_queue_msg *,
+							      struct timeval *);
+extern int			nfnl_queue_msg_test_timestamp(const struct nfnl_queue_msg *);
+extern const struct timeval *	nfnl_queue_msg_get_timestamp(const struct nfnl_queue_msg *);
+
+extern void			nfnl_queue_msg_set_indev(struct nfnl_queue_msg *, uint32_t);
+extern int			nfnl_queue_msg_test_indev(const struct nfnl_queue_msg *);
+extern uint32_t			nfnl_queue_msg_get_indev(const struct nfnl_queue_msg *);
+
+extern void			nfnl_queue_msg_set_outdev(struct nfnl_queue_msg *, uint32_t);
+extern int			nfnl_queue_msg_test_outdev(const struct nfnl_queue_msg *);
+extern uint32_t			nfnl_queue_msg_get_outdev(const struct nfnl_queue_msg *);
+
+extern void			nfnl_queue_msg_set_physindev(struct nfnl_queue_msg *, uint32_t);
+extern int			nfnl_queue_msg_test_physindev(const struct nfnl_queue_msg *);
+extern uint32_t			nfnl_queue_msg_get_physindev(const struct nfnl_queue_msg *);
+
+extern void			nfnl_queue_msg_set_physoutdev(struct nfnl_queue_msg *, uint32_t);
+extern int			nfnl_queue_msg_test_physoutdev(const struct nfnl_queue_msg *);
+extern uint32_t			nfnl_queue_msg_get_physoutdev(const struct nfnl_queue_msg *);
+
+extern void			nfnl_queue_msg_set_hwaddr(struct nfnl_queue_msg *, uint8_t *, int);
+extern int			nfnl_queue_msg_test_hwaddr(const struct nfnl_queue_msg *);
+extern const uint8_t *		nfnl_queue_msg_get_hwaddr(const struct nfnl_queue_msg *, int *);
+
+extern int			nfnl_queue_msg_set_payload(struct nfnl_queue_msg *, uint8_t *, int);
+extern int			nfnl_queue_msg_test_payload(const struct nfnl_queue_msg *);
+extern const void *		nfnl_queue_msg_get_payload(const struct nfnl_queue_msg *, int *);
+
+extern void			nfnl_queue_msg_set_verdict(struct nfnl_queue_msg *,
+							   unsigned int);
+extern int			nfnl_queue_msg_test_verdict(const struct nfnl_queue_msg *);
+extern unsigned int		nfnl_queue_msg_get_verdict(const struct nfnl_queue_msg *);
+
+extern struct nl_msg *		nfnl_queue_msg_build_verdict(const struct nfnl_queue_msg *);
+extern int			nfnl_queue_msg_send_verdict(struct nl_handle *,
+							    const struct nfnl_queue_msg *);
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif
+
diff --git a/lib/netfilter/queue.c b/lib/netfilter/queue.c
new file mode 100644
index 0000000..c056eef
--- /dev/null
+++ b/lib/netfilter/queue.c
@@ -0,0 +1,233 @@
+/*
+ * lib/netfilter/queue.c	Netfilter Queue
+ *
+ *	This library is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU Lesser General Public
+ *	License as published by the Free Software Foundation version 2.1
+ *	of the License.
+ *
+ * Copyright (c) 2007, 2008 Patrick McHardy <kaber@trash.net>
+ */
+
+/**
+ * @ingroup nfnl
+ * @defgroup queue Queue
+ * @brief
+ * @{
+ */
+
+#include <sys/types.h>
+#include <linux/netfilter/nfnetlink_queue.h>
+
+#include <netlink-local.h>
+#include <netlink/attr.h>
+#include <netlink/netfilter/nfnl.h>
+#include <netlink/netfilter/queue.h>
+
+static int send_queue_request(struct nl_handle *handle, struct nl_msg *msg)
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
+/**
+ * @name Queue Commands
+ * @{
+ */
+
+static struct nl_msg *build_queue_cmd_request(uint8_t family, uint16_t queuenum,
+					      uint8_t command)
+{
+	struct nl_msg *msg;
+	struct nfqnl_msg_config_cmd cmd;
+
+	msg = nfnlmsg_alloc_simple(NFNL_SUBSYS_QUEUE, NFQNL_MSG_CONFIG, 0,
+				   family, queuenum);
+	if (msg == NULL)
+		return NULL;
+
+	cmd.pf = htons(family);
+	cmd._pad = 0;
+	cmd.command = command;
+	if (nla_put(msg, NFQA_CFG_CMD, sizeof(cmd), &cmd) < 0)
+		goto nla_put_failure;
+
+	return msg;
+
+nla_put_failure:
+	nlmsg_free(msg);
+	return NULL;
+}
+
+struct nl_msg *nfnl_queue_build_pf_bind(uint8_t pf)
+{
+	return build_queue_cmd_request(pf, 0, NFQNL_CFG_CMD_PF_BIND);
+}
+
+int nfnl_queue_pf_bind(struct nl_handle *nlh, uint8_t pf)
+{
+	struct nl_msg *msg;
+
+	msg = nfnl_queue_build_pf_bind(pf);
+	if (!msg)
+		return nl_get_errno();
+
+	return send_queue_request(nlh, msg);
+}
+
+struct nl_msg *nfnl_queue_build_pf_unbind(uint8_t pf)
+{
+	return build_queue_cmd_request(pf, 0, NFQNL_CFG_CMD_PF_UNBIND);
+}
+
+int nfnl_queue_pf_unbind(struct nl_handle *nlh, uint8_t pf)
+{
+	struct nl_msg *msg;
+
+	msg = nfnl_queue_build_pf_unbind(pf);
+	if (!msg)
+		return nl_get_errno();
+
+	return send_queue_request(nlh, msg);
+}
+
+static struct nl_msg *nfnl_queue_build_request(const struct nfnl_queue *queue)
+{
+	struct nl_msg *msg;
+
+	if (!nfnl_queue_test_group(queue))
+		return NULL;
+
+	msg = nfnlmsg_alloc_simple(NFNL_SUBSYS_QUEUE, NFQNL_MSG_CONFIG, 0,
+				   0, nfnl_queue_get_group(queue));
+	if (msg == NULL)
+		return NULL;
+
+	if (nfnl_queue_test_maxlen(queue) &&
+	    nla_put_u32(msg, NFQA_CFG_QUEUE_MAXLEN,
+			htonl(nfnl_queue_get_maxlen(queue))) < 0)
+		goto nla_put_failure;
+
+	/* This sucks, the nfnetlink_queue interface always expects both
+	 * parameters to be present. Needs to be done properly.
+	 */
+	if (nfnl_queue_test_copy_mode(queue)) {
+		struct nfqnl_msg_config_params params;
+
+		switch (nfnl_queue_get_copy_mode(queue)) {
+		case NFNL_QUEUE_COPY_NONE:
+			params.copy_mode = NFQNL_COPY_NONE;
+			break;
+		case NFNL_QUEUE_COPY_META:
+			params.copy_mode = NFQNL_COPY_META;
+			break;
+		case NFNL_QUEUE_COPY_PACKET:
+			params.copy_mode = NFQNL_COPY_PACKET;
+			break;
+		}
+		params.copy_range = htonl(nfnl_queue_get_copy_range(queue));
+
+		if (nla_put(msg, NFQA_CFG_PARAMS, sizeof(params), &params) < 0)
+			goto nla_put_failure;
+	}
+	return msg;
+
+nla_put_failure:
+	nlmsg_free(msg);
+	return NULL;
+}
+
+struct nl_msg *nfnl_queue_build_create_request(const struct nfnl_queue *queue)
+{
+	struct nl_msg *msg;
+	struct nfqnl_msg_config_cmd cmd;
+
+	msg = nfnl_queue_build_request(queue);
+	if (msg == NULL)
+		return NULL;
+
+	cmd.pf = 0;
+	cmd._pad = 0;
+	cmd.command = NFQNL_CFG_CMD_BIND;
+
+	if (nla_put(msg, NFQA_CFG_CMD, sizeof(cmd), &cmd) < 0)
+		goto nla_put_failure;
+
+	return msg;
+
+nla_put_failure:
+	nlmsg_free(msg);
+	return NULL;
+}
+
+int nfnl_queue_create(struct nl_handle *nlh, const struct nfnl_queue *queue)
+{
+	struct nl_msg *msg;
+
+	msg = nfnl_queue_build_create_request(queue);
+	if (msg == NULL)
+		return nl_errno(ENOMEM);
+
+	return send_queue_request(nlh, msg);
+}
+
+struct nl_msg *nfnl_queue_build_change_request(const struct nfnl_queue *queue)
+{
+	return nfnl_queue_build_request(queue);
+}
+
+int nfnl_queue_change(struct nl_handle *nlh, const struct nfnl_queue *queue)
+{
+	struct nl_msg *msg;
+
+	msg = nfnl_queue_build_change_request(queue);
+	if (msg == NULL)
+		return nl_errno(ENOMEM);
+
+	return send_queue_request(nlh, msg);
+}
+
+struct nl_msg *nfnl_queue_build_delete_request(const struct nfnl_queue *queue)
+{
+	if (!nfnl_queue_test_group(queue))
+		return NULL;
+
+	return build_queue_cmd_request(0, nfnl_queue_get_group(queue),
+				       NFQNL_CFG_CMD_UNBIND);
+}
+
+int nfnl_queue_delete(struct nl_handle *nlh, const struct nfnl_queue *queue)
+{
+	struct nl_msg *msg;
+
+	msg = nfnl_queue_build_delete_request(queue);
+	if (msg == NULL)
+		return nl_errno(ENOMEM);
+
+	return send_queue_request(nlh, msg);
+}
+
+/** @} */
+
+static struct nl_cache_ops nfnl_queue_ops = {
+	.co_name		= "netfilter/queue",
+	.co_obj_ops		= &queue_obj_ops,
+};
+
+static void __init nfnl_queue_init(void)
+{
+	nl_cache_mngt_register(&nfnl_queue_ops);
+}
+
+static void __exit nfnl_queue_exit(void)
+{
+	nl_cache_mngt_unregister(&nfnl_queue_ops);
+}
+
+/** @} */
diff --git a/lib/netfilter/queue_msg.c b/lib/netfilter/queue_msg.c
new file mode 100644
index 0000000..82e79a6
--- /dev/null
+++ b/lib/netfilter/queue_msg.c
@@ -0,0 +1,240 @@
+/*
+ * lib/netfilter/queue_msg.c	Netfilter Queue Messages
+ *
+ *	This library is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU Lesser General Public
+ *	License as published by the Free Software Foundation version 2.1
+ *	of the License.
+ *
+ * Copyright (c) 2007, 2008 Patrick McHardy <kaber@trash.net>
+ */
+
+/**
+ * @ingroup nfnl
+ * @defgroup queue Queue
+ * @brief
+ * @{
+ */
+
+#include <sys/types.h>
+#include <linux/netfilter/nfnetlink_queue.h>
+
+#include <netlink-local.h>
+#include <netlink/attr.h>
+#include <netlink/netfilter/nfnl.h>
+#include <netlink/netfilter/queue_msg.h>
+
+static struct nl_cache_ops nfnl_queue_msg_ops;
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
+static struct nla_policy queue_policy[NFQA_MAX+1] = {
+	[NFQA_PACKET_HDR]		= {
+		.minlen	= sizeof(struct nfqnl_msg_packet_hdr),
+	},
+	[NFQA_VERDICT_HDR]		= {
+		.minlen	= sizeof(struct nfqnl_msg_verdict_hdr),
+	},
+	[NFQA_MARK]			= { .type = NLA_U32 },
+	[NFQA_TIMESTAMP]		= {
+		.minlen = sizeof(struct nfqnl_msg_packet_timestamp),
+	},
+	[NFQA_IFINDEX_INDEV]		= { .type = NLA_U32 },
+	[NFQA_IFINDEX_OUTDEV]		= { .type = NLA_U32 },
+	[NFQA_IFINDEX_PHYSINDEV]	= { .type = NLA_U32 },
+	[NFQA_IFINDEX_PHYSOUTDEV]	= { .type = NLA_U32 },
+	[NFQA_HWADDR]			= {
+		.minlen	= sizeof(struct nfqnl_msg_packet_timestamp),
+	},
+};
+
+struct nfnl_queue_msg *nfnlmsg_queue_msg_parse(struct nlmsghdr *nlh)
+{
+	struct nfnl_queue_msg *msg;
+	struct nlattr *tb[NFQA_MAX+1];
+	struct nlattr *attr;
+	int err;
+
+	msg = nfnl_queue_msg_alloc();
+	if (!msg)
+		return NULL;
+
+	msg->ce_msgtype = nlh->nlmsg_type;
+
+	err = nlmsg_parse(nlh, sizeof(struct nfgenmsg), tb, NFQA_MAX,
+			  queue_policy);
+	if (err < 0)
+		goto errout;
+
+	nfnl_queue_msg_set_group(msg, nfnlmsg_res_id(nlh));
+	nfnl_queue_msg_set_family(msg, nfnlmsg_family(nlh));
+
+	attr = tb[NFQA_PACKET_HDR];
+	if (attr) {
+		struct nfqnl_msg_packet_hdr *hdr = nla_data(attr);
+
+		nfnl_queue_msg_set_packetid(msg, ntohl(hdr->packet_id));
+		if (hdr->hw_protocol)
+			nfnl_queue_msg_set_hwproto(msg, hdr->hw_protocol);
+		nfnl_queue_msg_set_hook(msg, hdr->hook);
+	}
+
+	attr = tb[NFQA_MARK];
+	if (attr)
+		nfnl_queue_msg_set_mark(msg, ntohl(nla_get_u32(attr)));
+
+	attr = tb[NFQA_TIMESTAMP];
+	if (attr) {
+		struct nfqnl_msg_packet_timestamp *timestamp = nla_data(attr);
+		struct timeval tv;
+
+		tv.tv_sec = ntohll(timestamp->sec);
+		tv.tv_usec = ntohll(timestamp->usec);
+		nfnl_queue_msg_set_timestamp(msg, &tv);
+	}
+
+	attr = tb[NFQA_IFINDEX_INDEV];
+	if (attr)
+		nfnl_queue_msg_set_indev(msg, ntohl(nla_get_u32(attr)));
+
+	attr = tb[NFQA_IFINDEX_OUTDEV];
+	if (attr)
+		nfnl_queue_msg_set_outdev(msg, ntohl(nla_get_u32(attr)));
+
+	attr = tb[NFQA_IFINDEX_PHYSINDEV];
+	if (attr)
+		nfnl_queue_msg_set_physindev(msg, ntohl(nla_get_u32(attr)));
+
+	attr = tb[NFQA_IFINDEX_PHYSOUTDEV];
+	if (attr)
+		nfnl_queue_msg_set_physoutdev(msg, ntohl(nla_get_u32(attr)));
+
+	attr = tb[NFQA_HWADDR];
+	if (attr) {
+		struct nfqnl_msg_packet_hw *hw = nla_data(attr);
+
+		nfnl_queue_msg_set_hwaddr(msg, hw->hw_addr,
+					  ntohs(hw->hw_addrlen));
+	}
+
+	attr = tb[NFQA_PAYLOAD];
+	if (attr) {
+		err = nfnl_queue_msg_set_payload(msg, nla_data(attr),
+						 nla_len(attr));
+		if (err < 0)
+			goto errout;
+	}
+
+	return msg;
+
+errout:
+	nfnl_queue_msg_put(msg);
+	return NULL;
+}
+
+static int queue_msg_parser(struct nl_cache_ops *ops, struct sockaddr_nl *who,
+			    struct nlmsghdr *nlh, struct nl_parser_param *pp)
+{
+	struct nfnl_queue_msg *msg;
+	int err;
+
+	msg = nfnlmsg_queue_msg_parse(nlh);
+	if (msg == NULL)
+		goto errout_errno;
+
+	err = pp->pp_cb((struct nl_object *) msg, pp);
+	if (err < 0)
+		goto errout;
+
+	err = P_ACCEPT;
+
+errout:
+	nfnl_queue_msg_put(msg);
+	return err;
+
+errout_errno:
+	err = nl_get_errno();
+	goto errout;
+}
+
+/** @} */
+
+struct nl_msg *nfnl_queue_msg_build_verdict(const struct nfnl_queue_msg *msg)
+{
+	struct nl_msg *nlmsg;
+	struct nfqnl_msg_verdict_hdr verdict;
+
+	nlmsg = nfnlmsg_alloc_simple(NFNL_SUBSYS_QUEUE, NFQNL_MSG_VERDICT, 0,
+				     nfnl_queue_msg_get_family(msg),
+				     nfnl_queue_msg_get_group(msg));
+	if (nlmsg == NULL)
+		return NULL;
+
+	verdict.id = htonl(nfnl_queue_msg_get_packetid(msg));
+	verdict.verdict = htonl(nfnl_queue_msg_get_verdict(msg));
+	if (nla_put(nlmsg, NFQA_VERDICT_HDR, sizeof(verdict), &verdict) < 0)
+		goto nla_put_failure;
+
+	if (nfnl_queue_msg_test_mark(msg) &&
+	    nla_put_u32(nlmsg, NFQA_MARK,
+			ntohl(nfnl_queue_msg_get_mark(msg))) < 0)
+		goto nla_put_failure;
+
+	return nlmsg;
+
+nla_put_failure:
+	nlmsg_free(nlmsg);
+	return NULL;
+}
+
+int nfnl_queue_msg_send_verdict(struct nl_handle *nlh,
+				const struct nfnl_queue_msg *msg)
+{
+	struct nl_msg *nlmsg;
+	int err;
+
+	nlmsg = nfnl_queue_msg_build_verdict(msg);
+	if (nlmsg == NULL)
+		return nl_errno(ENOMEM);
+
+	err = nl_send_auto_complete(nlh, nlmsg);
+	nlmsg_free(nlmsg);
+	if (err < 0)
+		return err;
+	return nl_wait_for_ack(nlh);
+}
+
+#define NFNLMSG_QUEUE_TYPE(type) NFNLMSG_TYPE(NFNL_SUBSYS_QUEUE, (type))
+static struct nl_cache_ops nfnl_queue_msg_ops = {
+	.co_name		= "netfilter/queue_msg",
+	.co_hdrsize		= NFNL_HDRLEN,
+	.co_msgtypes		= {
+		{ NFNLMSG_QUEUE_TYPE(NFQNL_MSG_PACKET), NL_ACT_NEW, "new" },
+		END_OF_MSGTYPES_LIST,
+	},
+	.co_protocol		= NETLINK_NETFILTER,
+	.co_msg_parser		= queue_msg_parser,
+	.co_obj_ops		= &queue_msg_obj_ops,
+};
+
+static void __init nfnl_msg_queue_init(void)
+{
+	nl_cache_mngt_register(&nfnl_queue_msg_ops);
+}
+
+static void __exit nfnl_queue_msg_exit(void)
+{
+	nl_cache_mngt_unregister(&nfnl_queue_msg_ops);
+}
+
+/** @} */
diff --git a/lib/netfilter/queue_msg_obj.c b/lib/netfilter/queue_msg_obj.c
new file mode 100644
index 0000000..f86d6f6
--- /dev/null
+++ b/lib/netfilter/queue_msg_obj.c
@@ -0,0 +1,480 @@
+/*
+ * lib/netfilter/queue_msg_obj.c	Netfilter Queue Message Object
+ *
+ *	This library is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU Lesser General Public
+ *	License as published by the Free Software Foundation version 2.1
+ *	of the License.
+ *
+ * Copyright (c) 2007, 2008 Patrick McHardy <kaber@trash.net>
+ */
+
+#include <netlink-local.h>
+#include <netlink/netfilter/nfnl.h>
+#include <netlink/netfilter/netfilter.h>
+#include <netlink/netfilter/queue_msg.h>
+#include <linux/netfilter.h>
+
+/** @cond SKIP */
+#define QUEUE_MSG_ATTR_GROUP		(1UL << 0)
+#define QUEUE_MSG_ATTR_FAMILY		(1UL << 1)
+#define QUEUE_MSG_ATTR_PACKETID		(1UL << 2)
+#define QUEUE_MSG_ATTR_HWPROTO		(1UL << 3)
+#define QUEUE_MSG_ATTR_HOOK		(1UL << 4)
+#define QUEUE_MSG_ATTR_MARK		(1UL << 5)
+#define QUEUE_MSG_ATTR_TIMESTAMP	(1UL << 6)
+#define QUEUE_MSG_ATTR_INDEV		(1UL << 7)
+#define QUEUE_MSG_ATTR_OUTDEV		(1UL << 8)
+#define QUEUE_MSG_ATTR_PHYSINDEV	(1UL << 9)
+#define QUEUE_MSG_ATTR_PHYSOUTDEV	(1UL << 10)
+#define QUEUE_MSG_ATTR_HWADDR		(1UL << 11)
+#define QUEUE_MSG_ATTR_PAYLOAD		(1UL << 12)
+#define QUEUE_MSG_ATTR_VERDICT		(1UL << 13)
+/** @endcond */
+
+static void nfnl_queue_msg_free_data(struct nl_object *c)
+{
+	struct nfnl_queue_msg *msg = (struct nfnl_queue_msg *) c;
+
+	if (msg == NULL)
+		return;
+
+	free(msg->queue_msg_payload);
+}
+
+static int nfnl_queue_msg_clone(struct nl_object *_dst, struct nl_object *_src)
+{
+	struct nfnl_queue_msg *dst = (struct nfnl_queue_msg *) _dst;
+	struct nfnl_queue_msg *src = (struct nfnl_queue_msg *) _src;
+	int err;
+
+	if (src->queue_msg_payload) {
+		err = nfnl_queue_msg_set_payload(dst, src->queue_msg_payload,
+						 src->queue_msg_payload_len);
+		if (err < 0)
+			goto errout;
+	}
+
+	return 0;
+errout:
+	return err;
+}
+
+static int nfnl_queue_msg_dump(struct nl_object *a, struct nl_dump_params *p)
+{
+	struct nfnl_queue_msg *msg = (struct nfnl_queue_msg *) a;
+	struct nl_cache *link_cache;
+	char buf[64];
+
+	link_cache = nl_cache_mngt_require("route/link");
+
+	if (msg->ce_mask & QUEUE_MSG_ATTR_GROUP)
+		dp_dump(p, "GROUP=%u ", msg->queue_msg_group);
+
+	if (msg->ce_mask & QUEUE_MSG_ATTR_INDEV) {
+		if (link_cache)
+			dp_dump(p, "IN=%s ",
+				rtnl_link_i2name(link_cache,
+						 msg->queue_msg_indev,
+						 buf, sizeof(buf)));
+		else
+			dp_dump(p, "IN=%d ", msg->queue_msg_indev);
+	}
+
+	if (msg->ce_mask & QUEUE_MSG_ATTR_PHYSINDEV) {
+		if (link_cache)
+			dp_dump(p, "PHYSIN=%s ",
+				rtnl_link_i2name(link_cache,
+						 msg->queue_msg_physindev,
+						 buf, sizeof(buf)));
+		else
+			dp_dump(p, "IN=%d ", msg->queue_msg_physindev);
+	}
+
+	if (msg->ce_mask & QUEUE_MSG_ATTR_OUTDEV) {
+		if (link_cache)
+			dp_dump(p, "OUT=%s ",
+				rtnl_link_i2name(link_cache,
+						 msg->queue_msg_outdev,
+						 buf, sizeof(buf)));
+		else
+			dp_dump(p, "OUT=%d ", msg->queue_msg_outdev);
+	}
+
+	if (msg->ce_mask & QUEUE_MSG_ATTR_PHYSOUTDEV) {
+		if (link_cache)
+			dp_dump(p, "PHYSOUT=%s ",
+				rtnl_link_i2name(link_cache,
+						 msg->queue_msg_physoutdev,
+						 buf, sizeof(buf)));
+		else
+			dp_dump(p, "PHYSOUT=%d ", msg->queue_msg_physoutdev);
+	}
+
+	if (msg->ce_mask & QUEUE_MSG_ATTR_HWADDR) {
+		int i;
+
+		dp_dump(p, "MAC");
+		for (i = 0; i < msg->queue_msg_hwaddr_len; i++)
+			dp_dump(p, "%c%02x", i?':':'=',
+				msg->queue_msg_hwaddr[i]);
+		dp_dump(p, " ");
+	}
+
+	if (msg->ce_mask & QUEUE_MSG_ATTR_FAMILY)
+		dp_dump(p, "FAMILY=%s ",
+			nl_af2str(msg->queue_msg_family, buf, sizeof(buf)));
+
+	if (msg->ce_mask & QUEUE_MSG_ATTR_HWPROTO)
+		dp_dump(p, "HWPROTO=%s ",
+			nl_ether_proto2str(ntohs(msg->queue_msg_hwproto),
+					   buf, sizeof(buf)));
+
+	if (msg->ce_mask & QUEUE_MSG_ATTR_HOOK)
+		dp_dump(p, "HOOK=%s ",
+			nfnl_inet_hook2str(msg->queue_msg_hook,
+					   buf, sizeof(buf)));
+
+	if (msg->ce_mask & QUEUE_MSG_ATTR_MARK)
+		dp_dump(p, "MARK=%d ", msg->queue_msg_mark);
+
+	if (msg->ce_mask & QUEUE_MSG_ATTR_PAYLOAD)
+		dp_dump(p, "PAYLOADLEN=%d ", msg->queue_msg_payload_len);
+
+	if (msg->ce_mask & QUEUE_MSG_ATTR_PACKETID)
+		dp_dump(p, "PACKETID=%u ", msg->queue_msg_packetid);
+
+	if (msg->ce_mask & QUEUE_MSG_ATTR_VERDICT)
+		dp_dump(p, "VERDICT=%s ",
+			nfnl_verdict2str(msg->queue_msg_verdict,
+					 buf, sizeof(buf)));
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
+struct nfnl_queue_msg *nfnl_queue_msg_alloc(void)
+{
+	return (struct nfnl_queue_msg *) nl_object_alloc(&queue_msg_obj_ops);
+}
+
+void nfnl_queue_msg_get(struct nfnl_queue_msg *msg)
+{
+	nl_object_get((struct nl_object *) msg);
+}
+
+void nfnl_queue_msg_put(struct nfnl_queue_msg *msg)
+{
+	nl_object_put((struct nl_object *) msg);
+}
+
+/** @} */
+
+/**
+ * @name Attributes
+ * @{
+ */
+
+void nfnl_queue_msg_set_group(struct nfnl_queue_msg *msg, uint16_t group)
+{
+	msg->queue_msg_group = group;
+	msg->ce_mask |= QUEUE_MSG_ATTR_GROUP;
+}
+
+int nfnl_queue_msg_test_group(const struct nfnl_queue_msg *msg)
+{
+	return !!(msg->ce_mask & QUEUE_MSG_ATTR_GROUP);
+}
+
+uint16_t nfnl_queue_msg_get_group(const struct nfnl_queue_msg *msg)
+{
+	return msg->queue_msg_group;
+}
+
+void nfnl_queue_msg_set_family(struct nfnl_queue_msg *msg, uint8_t family)
+{
+	msg->queue_msg_family = family;
+	msg->ce_mask |= QUEUE_MSG_ATTR_FAMILY;
+}
+
+int nfnl_queue_msg_test_family(const struct nfnl_queue_msg *msg)
+{
+	return !!(msg->ce_mask & QUEUE_MSG_ATTR_FAMILY);
+}
+
+uint8_t nfnl_queue_msg_get_family(const struct nfnl_queue_msg *msg)
+{
+	if (msg->ce_mask & QUEUE_MSG_ATTR_FAMILY)
+		return msg->queue_msg_family;
+	else
+		return AF_UNSPEC;
+}
+
+void nfnl_queue_msg_set_packetid(struct nfnl_queue_msg *msg, uint32_t packetid)
+{
+	msg->queue_msg_packetid = packetid;
+	msg->ce_mask |= QUEUE_MSG_ATTR_PACKETID;
+}
+
+int nfnl_queue_msg_test_packetid(const struct nfnl_queue_msg *msg)
+{
+	return !!(msg->ce_mask & QUEUE_MSG_ATTR_PACKETID);
+}
+
+uint16_t nfnl_queue_msg_get_packetid(const struct nfnl_queue_msg *msg)
+{
+	return msg->queue_msg_packetid;
+}
+
+void nfnl_queue_msg_set_hwproto(struct nfnl_queue_msg *msg, uint16_t hwproto)
+{
+	msg->queue_msg_hwproto = hwproto;
+	msg->ce_mask |= QUEUE_MSG_ATTR_HWPROTO;
+}
+
+int nfnl_queue_msg_test_hwproto(const struct nfnl_queue_msg *msg)
+{
+	return !!(msg->ce_mask & QUEUE_MSG_ATTR_HWPROTO);
+}
+
+uint16_t nfnl_queue_msg_get_hwproto(const struct nfnl_queue_msg *msg)
+{
+	return msg->queue_msg_hwproto;
+}
+
+void nfnl_queue_msg_set_hook(struct nfnl_queue_msg *msg, uint8_t hook)
+{
+	msg->queue_msg_hook = hook;
+	msg->ce_mask |= QUEUE_MSG_ATTR_HOOK;
+}
+
+int nfnl_queue_msg_test_hook(const struct nfnl_queue_msg *msg)
+{
+	return !!(msg->ce_mask & QUEUE_MSG_ATTR_HOOK);
+}
+
+uint8_t nfnl_queue_msg_get_hook(const struct nfnl_queue_msg *msg)
+{
+	return msg->queue_msg_hook;
+}
+
+void nfnl_queue_msg_set_mark(struct nfnl_queue_msg *msg, uint32_t mark)
+{
+	msg->queue_msg_mark = mark;
+	msg->ce_mask |= QUEUE_MSG_ATTR_MARK;
+}
+
+int nfnl_queue_msg_test_mark(const struct nfnl_queue_msg *msg)
+{
+	return !!(msg->ce_mask & QUEUE_MSG_ATTR_MARK);
+}
+
+uint32_t nfnl_queue_msg_get_mark(const struct nfnl_queue_msg *msg)
+{
+	return msg->queue_msg_mark;
+}
+
+void nfnl_queue_msg_set_timestamp(struct nfnl_queue_msg *msg,
+				  struct timeval *tv)
+{
+	msg->queue_msg_timestamp.tv_sec = tv->tv_sec;
+	msg->queue_msg_timestamp.tv_usec = tv->tv_usec;
+	msg->ce_mask |= QUEUE_MSG_ATTR_TIMESTAMP;
+}
+
+int nfnl_queue_msg_test_timestamp(const struct nfnl_queue_msg *msg)
+{
+	return !!(msg->ce_mask & QUEUE_MSG_ATTR_TIMESTAMP);
+}
+
+const struct timeval *nfnl_queue_msg_get_timestamp(const struct nfnl_queue_msg *msg)
+{
+	if (!(msg->ce_mask & QUEUE_MSG_ATTR_TIMESTAMP))
+		return NULL;
+	return &msg->queue_msg_timestamp;
+}
+
+void nfnl_queue_msg_set_indev(struct nfnl_queue_msg *msg, uint32_t indev)
+{
+	msg->queue_msg_indev = indev;
+	msg->ce_mask |= QUEUE_MSG_ATTR_INDEV;
+}
+
+int nfnl_queue_msg_test_indev(const struct nfnl_queue_msg *msg)
+{
+	return !!(msg->ce_mask & QUEUE_MSG_ATTR_INDEV);
+}
+
+uint32_t nfnl_queue_msg_get_indev(const struct nfnl_queue_msg *msg)
+{
+	return msg->queue_msg_indev;
+}
+
+void nfnl_queue_msg_set_outdev(struct nfnl_queue_msg *msg, uint32_t outdev)
+{
+	msg->queue_msg_outdev = outdev;
+	msg->ce_mask |= QUEUE_MSG_ATTR_OUTDEV;
+}
+
+int nfnl_queue_msg_test_outdev(const struct nfnl_queue_msg *msg)
+{
+	return !!(msg->ce_mask & QUEUE_MSG_ATTR_OUTDEV);
+}
+
+uint32_t nfnl_queue_msg_get_outdev(const struct nfnl_queue_msg *msg)
+{
+	return msg->queue_msg_outdev;
+}
+
+void nfnl_queue_msg_set_physindev(struct nfnl_queue_msg *msg,
+				  uint32_t physindev)
+{
+	msg->queue_msg_physindev = physindev;
+	msg->ce_mask |= QUEUE_MSG_ATTR_PHYSINDEV;
+}
+
+int nfnl_queue_msg_test_physindev(const struct nfnl_queue_msg *msg)
+{
+	return !!(msg->ce_mask & QUEUE_MSG_ATTR_PHYSINDEV);
+}
+
+uint32_t nfnl_queue_msg_get_physindev(const struct nfnl_queue_msg *msg)
+{
+	return msg->queue_msg_physindev;
+}
+
+void nfnl_queue_msg_set_physoutdev(struct nfnl_queue_msg *msg,
+				   uint32_t physoutdev)
+{
+	msg->queue_msg_physoutdev = physoutdev;
+	msg->ce_mask |= QUEUE_MSG_ATTR_PHYSOUTDEV;
+}
+
+int nfnl_queue_msg_test_physoutdev(const struct nfnl_queue_msg *msg)
+{
+	return !!(msg->ce_mask & QUEUE_MSG_ATTR_PHYSOUTDEV);
+}
+
+uint32_t nfnl_queue_msg_get_physoutdev(const struct nfnl_queue_msg *msg)
+{
+	return msg->queue_msg_physoutdev;
+}
+
+void nfnl_queue_msg_set_hwaddr(struct nfnl_queue_msg *msg, uint8_t *hwaddr,
+			       int len)
+{
+	if (len > sizeof(msg->queue_msg_hwaddr))
+		len = sizeof(msg->queue_msg_hwaddr);
+
+	msg->queue_msg_hwaddr_len = len;
+	memcpy(msg->queue_msg_hwaddr, hwaddr, len);
+	msg->ce_mask |= QUEUE_MSG_ATTR_HWADDR;
+}
+
+int nfnl_queue_msg_test_hwaddr(const struct nfnl_queue_msg *msg)
+{
+	return !!(msg->ce_mask & QUEUE_MSG_ATTR_HWADDR);
+}
+
+const uint8_t *nfnl_queue_msg_get_hwaddr(const struct nfnl_queue_msg *msg,
+					 int *len)
+{
+	if (!(msg->ce_mask & QUEUE_MSG_ATTR_HWADDR)) {
+		*len = 0;
+		return NULL;
+	}
+
+	*len = msg->queue_msg_hwaddr_len;
+	return msg->queue_msg_hwaddr;
+}
+
+int nfnl_queue_msg_set_payload(struct nfnl_queue_msg *msg, uint8_t *payload,
+			       int len)
+{
+	free(msg->queue_msg_payload);
+	msg->queue_msg_payload = malloc(len);
+	if (!msg->queue_msg_payload)
+		return nl_errno(ENOMEM);
+
+	memcpy(msg->queue_msg_payload, payload, len);
+	msg->queue_msg_payload_len = len;
+	msg->ce_mask |= QUEUE_MSG_ATTR_PAYLOAD;
+	return 0;
+}
+
+int nfnl_queue_msg_test_payload(const struct nfnl_queue_msg *msg)
+{
+	return !!(msg->ce_mask & QUEUE_MSG_ATTR_PAYLOAD);
+}
+
+const void *nfnl_queue_msg_get_payload(const struct nfnl_queue_msg *msg, int *len)
+{
+	if (!(msg->ce_mask & QUEUE_MSG_ATTR_PAYLOAD)) {
+		*len = 0;
+		return NULL;
+	}
+
+	*len = msg->queue_msg_payload_len;
+	return msg->queue_msg_payload;
+}
+
+void nfnl_queue_msg_set_verdict(struct nfnl_queue_msg *msg,
+				unsigned int verdict)
+{
+	msg->queue_msg_verdict = verdict;
+	msg->ce_mask |= QUEUE_MSG_ATTR_VERDICT;
+}
+
+int nfnl_queue_msg_test_verdict(const struct nfnl_queue_msg *msg)
+{
+	return !!(msg->ce_mask & QUEUE_MSG_ATTR_VERDICT);
+}
+
+unsigned int nfnl_queue_msg_get_verdict(const struct nfnl_queue_msg *msg)
+{
+	return msg->queue_msg_verdict;
+}
+
+static struct trans_tbl nfnl_queue_msg_attrs[] = {
+	__ADD(QUEUE_MSG_ATTR_GROUP,		group)
+	__ADD(QUEUE_MSG_ATTR_FAMILY,		family)
+	__ADD(QUEUE_MSG_ATTR_PACKETID,		packetid)
+	__ADD(QUEUE_MSG_ATTR_HWPROTO,		hwproto)
+	__ADD(QUEUE_MSG_ATTR_HOOK,		hook)
+	__ADD(QUEUE_MSG_ATTR_MARK,		mark)
+	__ADD(QUEUE_MSG_ATTR_TIMESTAMP,		timestamp)
+	__ADD(QUEUE_MSG_ATTR_INDEV,		indev)
+	__ADD(QUEUE_MSG_ATTR_OUTDEV,		outdev)
+	__ADD(QUEUE_MSG_ATTR_PHYSINDEV,		physindev)
+	__ADD(QUEUE_MSG_ATTR_PHYSOUTDEV,	physoutdev)
+	__ADD(QUEUE_MSG_ATTR_HWADDR,		hwaddr)
+	__ADD(QUEUE_MSG_ATTR_PAYLOAD,		payload)
+	__ADD(QUEUE_MSG_ATTR_VERDICT,		verdict)
+};
+
+static char *nfnl_queue_msg_attrs2str(int attrs, char *buf, size_t len)
+{
+	return __flags2str(attrs, buf, len, nfnl_queue_msg_attrs,
+			   ARRAY_SIZE(nfnl_queue_msg_attrs));
+}
+
+/** @} */
+
+struct nl_object_ops queue_msg_obj_ops = {
+	.oo_name		= "netfilter/queuemsg",
+	.oo_size		= sizeof(struct nfnl_queue_msg),
+	.oo_free_data		= nfnl_queue_msg_free_data,
+	.oo_clone		= nfnl_queue_msg_clone,
+	.oo_dump[NL_DUMP_BRIEF]	= nfnl_queue_msg_dump,
+	.oo_dump[NL_DUMP_FULL]	= nfnl_queue_msg_dump,
+	.oo_dump[NL_DUMP_STATS]	= nfnl_queue_msg_dump,
+	.oo_attrs2str		= nfnl_queue_msg_attrs2str,
+};
+
+/** @} */
diff --git a/lib/netfilter/queue_obj.c b/lib/netfilter/queue_obj.c
new file mode 100644
index 0000000..68e1e5a
--- /dev/null
+++ b/lib/netfilter/queue_obj.c
@@ -0,0 +1,213 @@
+/*
+ * lib/netfilter/queue_obj.c	Netfilter Queue
+ *
+ *	This library is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU Lesser General Public
+ *	License as published by the Free Software Foundation version 2.1
+ *	of the License.
+ *
+ * Copyright (c) 2007, 2008 Patrick McHardy <kaber@trash.net>
+ */
+
+/**
+ * @ingroup nfnl
+ * @defgroup queue Queue
+ * @brief
+ * @{
+ */
+
+#include <netlink-local.h>
+#include <netlink/netfilter/nfnl.h>
+#include <netlink/netfilter/queue.h>
+
+/** @cond SKIP */
+#define QUEUE_ATTR_GROUP		(1UL << 0)
+#define QUEUE_ATTR_MAXLEN		(1UL << 1)
+#define QUEUE_ATTR_COPY_MODE		(1UL << 2)
+#define QUEUE_ATTR_COPY_RANGE		(1UL << 3)
+/** @endcond */
+
+
+static int nfnl_queue_dump(struct nl_object *a, struct nl_dump_params *p)
+{
+	struct nfnl_queue *queue = (struct nfnl_queue *) a;
+	char buf[64];
+
+	if (queue->ce_mask & QUEUE_ATTR_GROUP)
+		dp_dump(p, "group=%u ", queue->queue_group);
+
+	if (queue->ce_mask & QUEUE_ATTR_MAXLEN)
+		dp_dump(p, "maxlen=%u ", queue->queue_maxlen);
+
+	if (queue->ce_mask & QUEUE_ATTR_COPY_MODE)
+		dp_dump(p, "copy_mode=%s ",
+			nfnl_queue_copy_mode2str(queue->queue_copy_mode,
+						 buf, sizeof(buf)));
+
+	if (queue->ce_mask & QUEUE_ATTR_COPY_RANGE)
+		dp_dump(p, "copy_range=%u ", queue->queue_copy_range);
+
+	dp_dump(p, "\n");
+
+	return 1;
+}
+
+static struct trans_tbl copy_modes[] = {
+	__ADD(NFNL_QUEUE_COPY_NONE,	none)
+	__ADD(NFNL_QUEUE_COPY_META,	meta)
+	__ADD(NFNL_QUEUE_COPY_PACKET,	packet)
+};
+
+char *nfnl_queue_copy_mode2str(enum nfnl_queue_copy_mode copy_mode, char *buf,
+			       size_t len)
+{
+	return __type2str(copy_mode, buf, len, copy_modes,
+			   ARRAY_SIZE(copy_modes));
+}
+
+enum nfnl_queue_copy_mode nfnl_queue_str2copy_mode(const char *name)
+{
+	return __str2type(name, copy_modes, ARRAY_SIZE(copy_modes));
+}
+
+/**
+ * @name Allocation/Freeing
+ * @{
+ */
+
+struct nfnl_queue *nfnl_queue_alloc(void)
+{
+	return (struct nfnl_queue *) nl_object_alloc(&queue_obj_ops);
+}
+
+void nfnl_queue_get(struct nfnl_queue *queue)
+{
+	nl_object_get((struct nl_object *) queue);
+}
+
+void nfnl_queue_put(struct nfnl_queue *queue)
+{
+	nl_object_put((struct nl_object *) queue);
+}
+
+/** @} */
+
+/**
+ * @name Attributes
+ * @{
+ */
+
+void nfnl_queue_set_group(struct nfnl_queue *queue, uint16_t group)
+{
+	queue->queue_group = group;
+	queue->ce_mask |= QUEUE_ATTR_GROUP;
+}
+
+int nfnl_queue_test_group(const struct nfnl_queue *queue)
+{
+	return !!(queue->ce_mask & QUEUE_ATTR_GROUP);
+}
+
+uint16_t nfnl_queue_get_group(const struct nfnl_queue *queue)
+{
+	return queue->queue_group;
+}
+
+void nfnl_queue_set_maxlen(struct nfnl_queue *queue, uint32_t maxlen)
+{
+	queue->queue_maxlen = maxlen;
+	queue->ce_mask |= QUEUE_ATTR_MAXLEN;
+}
+
+int nfnl_queue_test_maxlen(const struct nfnl_queue *queue)
+{
+	return !!(queue->ce_mask & QUEUE_ATTR_MAXLEN);
+}
+
+uint32_t nfnl_queue_get_maxlen(const struct nfnl_queue *queue)
+{
+	return queue->queue_maxlen;
+}
+
+void nfnl_queue_set_copy_mode(struct nfnl_queue *queue, enum nfnl_queue_copy_mode mode)
+{
+	queue->queue_copy_mode = mode;
+	queue->ce_mask |= QUEUE_ATTR_COPY_MODE;
+}
+
+int nfnl_queue_test_copy_mode(const struct nfnl_queue *queue)
+{
+	return !!(queue->ce_mask & QUEUE_ATTR_COPY_MODE);
+}
+
+enum nfnl_queue_copy_mode nfnl_queue_get_copy_mode(const struct nfnl_queue *queue)
+{
+	return queue->queue_copy_mode;
+}
+
+void nfnl_queue_set_copy_range(struct nfnl_queue *queue, uint32_t copy_range)
+{
+	queue->queue_copy_range = copy_range;
+	queue->ce_mask |= QUEUE_ATTR_COPY_RANGE;
+}
+
+int nfnl_queue_test_copy_range(const struct nfnl_queue *queue)
+{
+	return !!(queue->ce_mask & QUEUE_ATTR_COPY_RANGE);
+}
+
+uint32_t nfnl_queue_get_copy_range(const struct nfnl_queue *queue)
+{
+	return queue->queue_copy_range;
+}
+
+static int nfnl_queue_compare(struct nl_object *_a, struct nl_object *_b,
+			      uint32_t attrs, int flags)
+{
+	struct nfnl_queue *a = (struct nfnl_queue *) _a;
+	struct nfnl_queue *b = (struct nfnl_queue *) _b;
+	int diff = 0;
+
+#define NFNL_QUEUE_DIFF(ATTR, EXPR) \
+	ATTR_DIFF(attrs, QUEUE_ATTR_##ATTR, a, b, EXPR)
+#define NFNL_QUEUE_DIFF_VAL(ATTR, FIELD) \
+	NFNL_QUEUE_DIFF(ATTR, a->FIELD != b->FIELD)
+
+	diff |= NFNL_QUEUE_DIFF_VAL(GROUP,	queue_group);
+	diff |= NFNL_QUEUE_DIFF_VAL(MAXLEN,	queue_maxlen);
+	diff |= NFNL_QUEUE_DIFF_VAL(COPY_MODE,	queue_copy_mode);
+	diff |= NFNL_QUEUE_DIFF_VAL(COPY_RANGE,	queue_copy_range);
+
+#undef NFNL_QUEUE_DIFF
+#undef NFNL_QUEUE_DIFF_VAL
+
+	return diff;
+}
+
+static struct trans_tbl nfnl_queue_attrs[] = {
+	__ADD(QUEUE_ATTR_GROUP,		group)
+	__ADD(QUEUE_ATTR_MAXLEN,	maxlen)
+	__ADD(QUEUE_ATTR_COPY_MODE,	copy_mode)
+	__ADD(QUEUE_ATTR_COPY_RANGE,	copy_range)
+};
+
+static char *nfnl_queue_attrs2str(int attrs, char *buf, size_t len)
+{
+	return __flags2str(attrs, buf, len, nfnl_queue_attrs,
+			   ARRAY_SIZE(nfnl_queue_attrs));
+}
+
+/** @} */
+
+struct nl_object_ops queue_obj_ops = {
+	.oo_name		= "netfilter/queue",
+	.oo_size		= sizeof(struct nfnl_queue),
+	.oo_dump[NL_DUMP_BRIEF]	= nfnl_queue_dump,
+	.oo_dump[NL_DUMP_FULL]	= nfnl_queue_dump,
+	.oo_dump[NL_DUMP_STATS]	= nfnl_queue_dump,
+	.oo_compare		= nfnl_queue_compare,
+	.oo_attrs2str		= nfnl_queue_attrs2str,
+	.oo_id_attrs		= QUEUE_ATTR_GROUP,
+};
+
+/** @} */
diff --git a/src/nf-queue.c b/src/nf-queue.c
new file mode 100644
index 0000000..1420273
--- /dev/null
+++ b/src/nf-queue.c
@@ -0,0 +1,172 @@
+/*
+ * src/nf-log.c     Monitor netfilter queue events
+ *
+ *	This library is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU Lesser General Public
+ *	License as published by the Free Software Foundation version 2.1
+ *	of the License.
+ *
+ * Copyright (c) 2007, 2008 Patrick McHardy <kaber@trash.net>
+ */
+
+#include <sys/types.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter/nfnetlink_queue.h>
+
+#include "utils.h"
+#include <netlink/netfilter/nfnl.h>
+#include <netlink/netfilter/queue.h>
+#include <netlink/netfilter/queue_msg.h>
+
+static struct nl_handle *nfnlh;
+
+static void obj_input(struct nl_object *obj, void *arg)
+{
+	struct nfnl_queue_msg *msg = (struct nfnl_queue_msg *) obj;
+	struct nl_dump_params dp = {
+		.dp_type = NL_DUMP_STATS,
+		.dp_fd = stdout,
+		.dp_dump_msgtype = 1,
+	};
+
+	nfnl_queue_msg_set_verdict(msg, NF_ACCEPT);
+	nl_object_dump(obj, &dp);
+	nfnl_queue_msg_send_verdict(nfnlh, msg);
+}
+
+static int event_input(struct nl_msg *msg, void *arg)
+{
+	if (nl_msg_parse(msg, &obj_input, NULL) < 0)
+		fprintf(stderr, "<<EVENT>> Unknown message type\n");
+
+	/* Exit nl_recvmsgs_def() and return to the main select() */
+	return NL_STOP;
+}
+
+int main(int argc, char *argv[])
+{
+	struct nl_handle *rtnlh;
+	struct nl_cache *link_cache;
+	struct nfnl_queue *queue;
+	enum nfnl_queue_copy_mode copy_mode;
+	uint32_t copy_range;
+	int err = 1;
+	int family;
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
+		printf("Usage: nf-queue family group [ copy_mode ] "
+		       "[ copy_range ]\n");
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
+
+	nfnl_queue_pf_unbind(nfnlh, family);
+	if (nfnl_queue_pf_bind(nfnlh, family) < 0) {
+		fprintf(stderr, "%s\n", nl_geterror());
+		goto errout;
+	}
+
+	queue = nfnl_queue_alloc();
+	if (queue == NULL) {
+		fprintf(stderr, "%s\n", nl_geterror());
+		goto errout;
+	}
+
+	nfnl_queue_set_group(queue, atoi(argv[2]));
+
+	copy_mode = NFNL_QUEUE_COPY_PACKET;
+	if (argc > 3) {
+		copy_mode = nfnl_queue_str2copy_mode(argv[3]);
+		if (copy_mode < 0) {
+			fprintf(stderr, "%s\n", nl_geterror());
+			goto errout;
+		}
+	}
+	nfnl_queue_set_copy_mode(queue, copy_mode);
+
+	copy_range = 0xFFFF;
+	if (argc > 4)
+		copy_range = atoi(argv[4]);
+	nfnl_queue_set_copy_range(queue, copy_range);
+
+	if (nfnl_queue_create(nfnlh, queue) < 0) {
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
+				nl_recvmsgs_default(nfnlh);
+			if (FD_ISSET(rtfd, &rfds))
+				nl_recvmsgs_default(rtnlh);
+		}
+	}
+
+	nl_cache_mngt_unprovide(link_cache);
+	nl_cache_free(link_cache);
+
+	nfnl_queue_put(queue);
+
+	nl_close(rtnlh);
+	nl_handle_destroy(rtnlh);
+errout_close:
+	nl_close(nfnlh);
+	nl_handle_destroy(nfnlh);
+errout:
+	return err;
+}
