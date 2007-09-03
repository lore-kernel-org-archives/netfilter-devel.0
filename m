From: Philip Craig <philipc@snapgear.com>
Subject: [PATCH 1/3] libnl: add netfilter support
Date: Mon, 03 Sep 2007 15:11:18 +1000
Message-ID: <46DB9776.8020209@snapgear.com>
References: <46DB9716.1020400@snapgear.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090302080301080205000602"
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
--------------090302080301080205000602
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit



--------------090302080301080205000602
Content-Type: text/x-diff;
 name="nfnl.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nfnl.patch"

---
 include/linux/netfilter/nfnetlink.h |  106 +++++++++++++++
 include/netlink/netfilter/nfnl.h    |   44 ++++++
 include/netlink/netlink.h           |    1 
 lib/Makefile                        |    2 
 lib/attr.c                          |    3 
 lib/netfilter/nfnl.c                |  246 ++++++++++++++++++++++++++++++++++++
 6 files changed, 401 insertions(+), 1 deletion(-)

Index: libnl/lib/Makefile
===================================================================
--- libnl.orig/lib/Makefile	2007-09-03 14:24:29.000000000 +1000
+++ libnl/lib/Makefile	2007-09-03 14:24:45.000000000 +1000
@@ -25,6 +25,8 @@ CIN      += $(wildcard route/cls/*.c)
 CIN      += $(wildcard genl/*.c)
 # fib lookup
 CIN      += $(wildcard fib_lookup/*.c)
+# Netfilter
+CIN      += $(wildcard netfilter/*.c)
 
 DEPS     := $(CIN:%.c=%.d)
 OBJ      := $(CIN:%.c=%.o)
Index: libnl/lib/attr.c
===================================================================
--- libnl.orig/lib/attr.c	2007-09-03 14:24:29.000000000 +1000
+++ libnl/lib/attr.c	2007-09-03 14:24:45.000000000 +1000
@@ -261,7 +261,8 @@ int nla_parse(struct nlattr *tb[], int m
 	memset(tb, 0, sizeof(struct nlattr *) * (maxtype + 1));
 
 	nla_for_each_attr(nla, head, len, rem) {
-		uint16_t type = nla->nla_type;
+		/* Ignore NFNL_NFA_NEST bit, hope nothing else uses it */
+		uint16_t type = nla->nla_type & 0x7fff;
 
 		if (type == 0) {
 			fprintf(stderr, "Illegal nla->nla_type == 0\n");
Index: libnl/include/netlink/netfilter/nfnl.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ libnl/include/netlink/netfilter/nfnl.h	2007-09-03 14:24:45.000000000 +1000
@@ -0,0 +1,44 @@
+/*
+ * netlink/nfnl/nfnl.h		Netfilter Netlink
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
+#ifndef NETLINK_NFNL_H_
+#define NETLINK_NFNL_H_
+
+#include <netlink/netlink.h>
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+#define NFNL_HDRLEN NLMSG_ALIGN(sizeof(struct nfgenmsg))
+#define NFNLMSG_TYPE(subsys, subtype) (((subsys) << 8) | (subtype))
+
+extern int		nfnl_connect(struct nl_handle *);
+
+extern uint8_t		nfnlmsg_subsys(struct nlmsghdr *);
+extern uint8_t		nfnlmsg_subtype(struct nlmsghdr *);
+extern uint8_t		nfnlmsg_family(struct nlmsghdr *);
+extern uint16_t		nfnlmsg_res_id(struct nlmsghdr *);
+
+extern int		nfnl_send_simple(struct nl_handle *, uint8_t, uint8_t,
+					 int, uint8_t, uint16_t);
+extern struct nl_msg *	nfnlmsg_alloc_simple(uint8_t, uint8_t, int,
+					     uint8_t, uint16_t);
+extern int		nfnlmsg_put(struct nl_msg *, uint32_t, uint32_t,
+				    uint8_t, uint8_t, int, uint8_t, uint16_t);
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif
Index: libnl/lib/netfilter/nfnl.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ libnl/lib/netfilter/nfnl.c	2007-09-03 14:24:45.000000000 +1000
@@ -0,0 +1,246 @@
+/*
+ * lib/netfilter/nfnl.c		Netfilter Netlink
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
+ * @ingroup nlfam
+ * @defgroup nfnl Netfilter Netlink
+ *
+ * @par Message Format
+ * @code
+ *  <------- NLMSG_ALIGN(hlen) ------> <---- NLMSG_ALIGN(len) --->
+ * +----------------------------+- - -+- - - - - - - - - - -+- - -+
+ * |           Header           | Pad |       Payload       | Pad |
+ * |      struct nlmsghdr       |     |                     |     |
+ * +----------------------------+- - -+- - - - - - - - - - -+- - -+
+ * @endcode
+ * @code
+ *  <-------- NFNL_HDRLEN --------->
+ * +--------------------------+- - -+------------+
+ * | Netfilter Netlink Header | Pad | Attributes |
+ * |    struct nfgenmsg       |     |            |
+ * +--------------------------+- - -+------------+
+ * nfnlmsg_attrdata(nfg, hdrlen)-----^
+ * @endcode
+ *
+ * @par 1) Creating a new netfilter netlink message
+ * @code
+ * struct nl_msg *msg;
+ *
+ * // Create a new empty netlink message
+ * msg = nlmsg_alloc();
+ *
+ * // Append the netlink and netfilter netlink message header
+ * hdr = nfnlmsg_put(msg, PID, SEQ, SUBSYS, TYPE, NLM_F_ECHO,
+ *                   FAMILY, RES_ID);
+ *
+ * // Append the attributes.
+ * nla_put_u32(msg, 1, 0x10);
+ *
+ * // Message is ready to be sent.
+ * nl_send_auto_complete(nl_handle, msg);
+ *
+ * // All done? Free the message.
+ * nlmsg_free(msg);
+ * @endcode
+ *
+ * @par 2) Sending of trivial messages
+ * @code
+ * // For trivial messages not requiring any subsys specific header or
+ * // attributes, nfnl_send_simple() may be used to send messages directly.
+ * nfnl_send_simple(nl_handle, SUBSYS, TYPE, 0, FAMILY, RES_ID);
+ * @endcode
+ * @{
+ */
+
+#include <netlink-local.h>
+#include <netlink/netlink.h>
+#include <netlink/netfilter/nfnl.h>
+
+/**
+ * @name Socket Creating
+ * @{
+ */
+
+/**
+ * Create and connect netfilter netlink socket.
+ * @arg handle		Netlink handle.
+ *
+ * Creates a NETLINK_NETFILTER netlink socket, binds the socket and
+ * issues a connection attempt.
+ *
+ * @see nl_connect()
+ *
+ * @return 0 on success or a negative error code.
+ */
+int nfnl_connect(struct nl_handle *handle)
+{
+	return nl_connect(handle, NETLINK_NETFILTER);
+}
+
+/** @} */
+
+/**
+ * @name Sending
+ * @{
+ */
+
+/**
+ * Send trivial netfilter netlink message
+ * @arg handle		Netlink handle.
+ * @arg subsys_id	nfnetlink subsystem
+ * @arg type		nfnetlink message type
+ * @arg flags		message flags
+ * @arg family		nfnetlink address family
+ * @arg res_id		nfnetlink resource id
+ *
+ * @return Newly allocated netlink message or NULL.
+ */
+int nfnl_send_simple(struct nl_handle *handle, uint8_t subsys_id, uint8_t type,
+		     int flags, uint8_t family, uint16_t res_id)
+{
+	struct nfgenmsg hdr = {
+		.nfgen_family = family,
+		.version = NFNETLINK_V0,
+		.res_id = htons(res_id),
+	};
+
+	return nl_send_simple(handle, NFNLMSG_TYPE(subsys_id, type), flags,
+			      &hdr, sizeof(hdr));
+}
+
+/** @} */
+
+/**
+ * @name Message Parsing
+ * @{
+ */
+
+/**
+ * Get netfilter subsystem id from message
+ * @arg nlh	netlink messsage header
+ */
+uint8_t nfnlmsg_subsys(struct nlmsghdr *nlh)
+{
+	return NFNL_SUBSYS_ID(nlh->nlmsg_type);
+}
+
+/**
+ * Get netfilter message type from message
+ * @arg nlh	netlink messsage header
+ */
+uint8_t nfnlmsg_subtype(struct nlmsghdr *nlh)
+{
+	return NFNL_MSG_TYPE(nlh->nlmsg_type);
+}
+
+/**
+ * Get netfilter family from message
+ * @arg nlh	netlink messsage header
+ */
+uint8_t nfnlmsg_family(struct nlmsghdr *nlh)
+{
+	struct nfgenmsg *nfg = nlmsg_data(nlh);
+
+	return nfg->nfgen_family;
+}
+
+/**
+ * Get netfilter resource id from message
+ * @arg nlh	netlink messsage header
+ */
+uint16_t nfnlmsg_res_id(struct nlmsghdr *nlh)
+{
+	struct nfgenmsg *nfg = nlmsg_data(nlh);
+
+	return ntohs(nfg->res_id);
+}
+
+/** @} */
+
+/**
+ * @name Message Building
+ * @{
+ */
+
+static int nfnlmsg_append(struct nl_msg *msg, uint8_t family, uint16_t res_id)
+{
+	struct nfgenmsg *nfg;
+
+	nfg = nlmsg_reserve(msg, sizeof(*nfg), NLMSG_ALIGNTO);
+	if (nfg == NULL)
+		return nl_errno(ENOMEM);
+
+	nfg->nfgen_family = family;
+	nfg->version = NFNETLINK_V0;
+	nfg->res_id = htons(res_id);
+	NL_DBG(2, "msg %p: Added nfnetlink header family=%d res_id=%d\n",
+	       msg, family, res_id);
+	return 0;
+}
+
+/**
+ * Allocate a new netfilter netlink message
+ * @arg subsys_id	nfnetlink subsystem
+ * @arg type		nfnetlink message type
+ * @arg flags		message flags
+ * @arg family		nfnetlink address family
+ * @arg res_id		nfnetlink resource id
+ *
+ * @return Newly allocated netlink message or NULL.
+ */
+struct nl_msg *nfnlmsg_alloc_simple(uint8_t subsys_id, uint8_t type, int flags,
+				    uint8_t family, uint16_t res_id)
+{
+	struct nl_msg *msg;
+
+	msg = nlmsg_alloc_simple(NFNLMSG_TYPE(subsys_id, type), flags);
+	if (msg == NULL)
+		return NULL;
+
+	if (nfnlmsg_append(msg, family, res_id) < 0)
+		goto nla_put_failure;
+
+	return msg;
+
+nla_put_failure:
+	nlmsg_free(msg);
+	return NULL;
+}
+
+/**
+ * Add netlink and netfilter netlink headers to netlink message
+ * @arg msg		netlink message
+ * @arg pid		netlink process id
+ * @arg seq		sequence number of message
+ * @arg subsys_id	nfnetlink subsystem
+ * @arg type		nfnetlink message type
+ * @arg flags		message flags
+ * @arg family		nfnetlink address family
+ * @arg res_id		nfnetlink resource id
+ */
+int nfnlmsg_put(struct nl_msg *msg, uint32_t pid, uint32_t seq,
+		uint8_t subsys_id, uint8_t type, int flags, uint8_t family,
+		uint16_t res_id)
+{
+	struct nlmsghdr *nlh;
+
+	nlh = nlmsg_put(msg, pid, seq, NFNLMSG_TYPE(subsys_id, type), 0, flags);
+	if (nlh == NULL)
+		return nl_get_errno();
+
+	return nfnlmsg_append(msg, family, res_id);
+}
+
+/** @} */
+
+/** @} */
Index: libnl/include/netlink/netlink.h
===================================================================
--- libnl.orig/include/netlink/netlink.h	2007-09-03 14:24:29.000000000 +1000
+++ libnl/include/netlink/netlink.h	2007-09-03 14:24:45.000000000 +1000
@@ -25,6 +25,7 @@
 #include <linux/rtnetlink.h>
 #include <linux/genetlink.h>
 #include <linux/ip_mp_alg.h>
+#include <linux/netfilter/nfnetlink.h>
 #include <netlink/types.h>
 #include <netlink/handlers.h>
 #include <netlink/socket.h>
Index: libnl/include/linux/netfilter/nfnetlink.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ libnl/include/linux/netfilter/nfnetlink.h	2007-09-03 14:24:45.000000000 +1000
@@ -0,0 +1,106 @@
+#ifndef _NFNETLINK_H
+#define _NFNETLINK_H
+#include <linux/types.h>
+
+#ifndef __KERNEL__
+/* nfnetlink groups: Up to 32 maximum - backwards compatibility for userspace */
+#define NF_NETLINK_CONNTRACK_NEW 		0x00000001
+#define NF_NETLINK_CONNTRACK_UPDATE		0x00000002
+#define NF_NETLINK_CONNTRACK_DESTROY		0x00000004
+#define NF_NETLINK_CONNTRACK_EXP_NEW		0x00000008
+#define NF_NETLINK_CONNTRACK_EXP_UPDATE		0x00000010
+#define NF_NETLINK_CONNTRACK_EXP_DESTROY	0x00000020
+#endif
+
+enum nfnetlink_groups {
+	NFNLGRP_NONE,
+#define NFNLGRP_NONE			NFNLGRP_NONE
+	NFNLGRP_CONNTRACK_NEW,
+#define NFNLGRP_CONNTRACK_NEW		NFNLGRP_CONNTRACK_NEW
+	NFNLGRP_CONNTRACK_UPDATE,
+#define NFNLGRP_CONNTRACK_UPDATE	NFNLGRP_CONNTRACK_UPDATE
+	NFNLGRP_CONNTRACK_DESTROY,
+#define NFNLGRP_CONNTRACK_DESTROY	NFNLGRP_CONNTRACK_DESTROY
+	NFNLGRP_CONNTRACK_EXP_NEW,
+#define	NFNLGRP_CONNTRACK_EXP_NEW	NFNLGRP_CONNTRACK_EXP_NEW
+	NFNLGRP_CONNTRACK_EXP_UPDATE,
+#define NFNLGRP_CONNTRACK_EXP_UPDATE	NFNLGRP_CONNTRACK_EXP_UPDATE
+	NFNLGRP_CONNTRACK_EXP_DESTROY,
+#define NFNLGRP_CONNTRACK_EXP_DESTROY	NFNLGRP_CONNTRACK_EXP_DESTROY
+	__NFNLGRP_MAX,
+};
+#define NFNLGRP_MAX	(__NFNLGRP_MAX - 1)
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
+/* General form of address family dependent message.
+ */
+struct nfgenmsg {
+	u_int8_t  nfgen_family;		/* AF_xxx */
+	u_int8_t  version;		/* nfnetlink version */
+	__be16    res_id;		/* resource id */
+};
+
+#define NFNETLINK_V0	0
+
+#define NFM_NFA(n)      ((struct nfattr *)(((char *)(n)) \
+        + NLMSG_ALIGN(sizeof(struct nfgenmsg))))
+#define NFM_PAYLOAD(n)  NLMSG_PAYLOAD(n, sizeof(struct nfgenmsg))
+
+/* netfilter netlink message types are split in two pieces:
+ * 8 bit subsystem, 8bit operation.
+ */
+
+#define NFNL_SUBSYS_ID(x)	((x & 0xff00) >> 8)
+#define NFNL_MSG_TYPE(x)	(x & 0x00ff)
+
+/* No enum here, otherwise __stringify() trick of MODULE_ALIAS_NFNL_SUBSYS()
+ * won't work anymore */
+#define NFNL_SUBSYS_NONE 		0
+#define NFNL_SUBSYS_CTNETLINK		1
+#define NFNL_SUBSYS_CTNETLINK_EXP	2
+#define NFNL_SUBSYS_QUEUE		3
+#define NFNL_SUBSYS_ULOG		4
+#define NFNL_SUBSYS_COUNT		5
+
+#endif	/* _NFNETLINK_H */

--------------090302080301080205000602--
