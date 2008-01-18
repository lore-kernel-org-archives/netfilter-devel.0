From: Patrick McHardy <kaber@trash.net>
Subject: [LIBNL 07/09]: Split up nfnetlink_log into log and msg objects
Date: Fri, 18 Jan 2008 17:55:57 +0100 (MET)
Message-ID: <20080118165524.13385.49205.sendpatchset@localhost.localdomain>
References: <20080118165514.13385.44695.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	philipc@snapgear.com
To: tgraf@suug.ch
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42974 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762376AbYARQz6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Jan 2008 11:55:58 -0500
In-Reply-To: <20080118165514.13385.44695.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit c566db4405200994482d36fac45089aba4e2360a
Author: Patrick McHardy <kaber@trash.net>
Date:   Fri Jan 18 17:52:41 2008 +0100

    [LIBNL]: Split up nfnetlink_log into log and msg objects
    
    Split the nfnetlink_log code into two seperate objects, "netfilter/log"
    to represent logging instances and "netfilter/log_msg" to represent
    log messages. Also perform some function name unification for consistency
    with other libnl object types, mainly renaming nfnl_log_build_*_msg
    to nfnl_log_build_*_request.
    
    This changes the API in an incompatible way, but since this feature is
    new and the libnl netfilter headers haven't been installed so far,
    there shouldn't be any users affected by this.
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/include/netlink-types.h b/include/netlink-types.h
index cbf903e..a690cb2 100644
--- a/include/netlink-types.h
+++ b/include/netlink-types.h
@@ -736,24 +736,37 @@ struct nfnl_ct {
 struct nfnl_log {
 	NLHDR_COMMON
 
-	uint8_t			log_family;
-	uint8_t			log_hook;
-	uint16_t		log_hwproto;
-	uint32_t		log_mark;
-	struct timeval		log_timestamp;
-	uint32_t		log_indev;
-	uint32_t		log_outdev;
-	uint32_t		log_physindev;
-	uint32_t		log_physoutdev;
-	uint8_t			log_hwaddr[8];
-	int			log_hwaddr_len;
-	void *			log_payload;
-	int			log_payload_len;
-	char *			log_prefix;
-	uint32_t		log_uid;
-	uint32_t		log_gid;
-	uint32_t		log_seq;
-	uint32_t		log_seq_global;
+	uint16_t		log_group;
+	uint8_t			log_copy_mode;
+	uint32_t		log_copy_range;
+	uint32_t		log_flush_timeout;
+	uint32_t		log_alloc_size;
+	uint32_t		log_queue_threshold;
+	uint32_t		log_flags;
+	uint32_t		log_flag_mask;
+};
+
+struct nfnl_log_msg {
+	NLHDR_COMMON
+
+	uint8_t			log_msg_family;
+	uint8_t			log_msg_hook;
+	uint16_t		log_msg_hwproto;
+	uint32_t		log_msg_mark;
+	struct timeval		log_msg_timestamp;
+	uint32_t		log_msg_indev;
+	uint32_t		log_msg_outdev;
+	uint32_t		log_msg_physindev;
+	uint32_t		log_msg_physoutdev;
+	uint8_t			log_msg_hwaddr[8];
+	int			log_msg_hwaddr_len;
+	void *			log_msg_payload;
+	int			log_msg_payload_len;
+	char *			log_msg_prefix;
+	uint32_t		log_msg_uid;
+	uint32_t		log_msg_gid;
+	uint32_t		log_msg_seq;
+	uint32_t		log_msg_seq_global;
 };
 
 struct nfnl_queue {
diff --git a/include/netlink/netfilter/log.h b/include/netlink/netfilter/log.h
index 817de2d..51f4a90 100644
--- a/include/netlink/netfilter/log.h
+++ b/include/netlink/netfilter/log.h
@@ -9,6 +9,7 @@
  * Copyright (c) 2003-2006 Thomas Graf <tgraf@suug.ch>
  * Copyright (c) 2007 Philip Craig <philipc@snapgear.com>
  * Copyright (c) 2007 Secure Computing Corporation
+ * Copyright (c) 2008 Patrick McHardy <kaber@trash.net>
  */
 
 #ifndef NETLINK_LOG_H_
@@ -26,80 +27,79 @@ struct nfnl_log;
 
 extern struct nl_object_ops log_obj_ops;
 
-/* General */
-extern struct nfnl_log *nfnl_log_alloc(void);
-extern struct nfnl_log *nfnlmsg_log_parse(struct nlmsghdr *);
-
-extern void		nfnl_log_get(struct nfnl_log *);
-extern void		nfnl_log_put(struct nfnl_log *);
+enum nfnl_log_copy_mode {
+	NFNL_LOG_COPY_NONE,
+	NFNL_LOG_COPY_META,
+	NFNL_LOG_COPY_PACKET,
+};
 
-extern struct nl_msg *	nfnl_log_build_bind(uint16_t);;
-extern int		nfnl_log_bind(struct nl_handle *, uint16_t);
-extern struct nl_msg *	nfnl_log_build_unbind(uint16_t);
-extern int		nfnl_log_unbind(struct nl_handle *, uint16_t);
-extern struct nl_msg *	nfnl_log_build_pf_bind(uint8_t);
-extern int		nfnl_log_pf_bind(struct nl_handle *, uint8_t);
-extern struct nl_msg *	nfnl_log_build_pf_unbind(uint8_t);
-extern int		nfnl_log_pf_unbind(struct nl_handle *, uint8_t);
-extern struct nl_msg *	nfnl_log_build_mode(uint16_t, uint8_t, uint32_t);
-extern int		nfnl_log_set_mode(struct nl_handle *, uint16_t,
-					  uint8_t, uint32_t);
+enum nfnl_log_flags {
+	NFNL_LOG_FLAG_SEQ		= 0x1,
+	NFNL_LOG_FLAG_SEQ_GLOBAL	= 0x2,
+};
 
-extern void		nfnl_log_set_family(struct nfnl_log *, uint8_t);
-extern uint8_t		nfnl_log_get_family(const struct nfnl_log *);
+/* General */
+extern struct nfnl_log *	nfnl_log_alloc(void);
+extern struct nfnl_log *	nfnlmsg_log_parse(struct nlmsghdr *);
 
-extern void		nfnl_log_set_hwproto(struct nfnl_log *, uint16_t);
-extern int		nfnl_log_test_hwproto(const struct nfnl_log *);
-extern uint16_t		nfnl_log_get_hwproto(const struct nfnl_log *);
+extern void			nfnl_log_get(struct nfnl_log *);
+extern void			nfnl_log_put(struct nfnl_log *);
 
-extern void		nfnl_log_set_hook(struct nfnl_log *, uint8_t);
-extern int		nfnl_log_test_hook(const struct nfnl_log *);
-extern uint8_t		nfnl_log_get_hook(const struct nfnl_log *);
+/* Attributes */
+extern void			nfnl_log_set_group(struct nfnl_log *, uint16_t);
+extern int			nfnl_log_test_group(const struct nfnl_log *);
+extern uint16_t			nfnl_log_get_group(const struct nfnl_log *);
 
-extern void		nfnl_log_set_mark(struct nfnl_log *, uint32_t);
-extern int		nfnl_log_test_mark(const struct nfnl_log *);
-extern uint32_t		nfnl_log_get_mark(const struct nfnl_log *);
+extern void			nfnl_log_set_copy_mode(struct nfnl_log *,
+						       enum nfnl_log_copy_mode);
+extern int			nfnl_log_test_copy_mode(const struct nfnl_log *);
+extern enum nfnl_log_copy_mode	nfnl_log_get_copy_mode(const struct nfnl_log *);
 
-extern void		nfnl_log_set_timestamp(struct nfnl_log *,
-					       struct timeval *);
-extern const struct timeval *nfnl_log_get_timestamp(const struct nfnl_log *);
+extern char *			nfnl_log_copy_mode2str(enum nfnl_log_copy_mode,
+						       char *, size_t);
+extern enum nfnl_log_copy_mode	nfnl_log_str2copy_mode(const char *);
 
-extern void		nfnl_log_set_indev(struct nfnl_log *, uint32_t);
-extern uint32_t		nfnl_log_get_indev(const struct nfnl_log *);
+extern void			nfnl_log_set_copy_range(struct nfnl_log *, uint32_t);
+extern int			nfnl_log_test_copy_range(const struct nfnl_log *);
+extern uint32_t			nfnl_log_get_copy_range(const struct nfnl_log *);
 
-extern void		nfnl_log_set_outdev(struct nfnl_log *, uint32_t);
-extern uint32_t		nfnl_log_get_outdev(const struct nfnl_log *);
+extern void			nfnl_log_set_flush_timeout(struct nfnl_log *, uint32_t);
+extern int			nfnl_log_test_flush_timeout(const struct nfnl_log *);
+extern uint32_t			nfnl_log_get_flush_timeout(const struct nfnl_log *);
 
-extern void		nfnl_log_set_physindev(struct nfnl_log *, uint32_t);
-extern uint32_t		nfnl_log_get_physindev(const struct nfnl_log *);
+extern void			nfnl_log_set_alloc_size(struct nfnl_log *, uint32_t);
+extern int			nfnl_log_test_alloc_size(const struct nfnl_log *);
+extern uint32_t			nfnl_log_get_alloc_size(const struct nfnl_log *);
 
-extern void		nfnl_log_set_physoutdev(struct nfnl_log *, uint32_t);
-extern uint32_t		nfnl_log_get_physoutdev(const struct nfnl_log *);
+extern void			nfnl_log_set_queue_threshold(struct nfnl_log *, uint32_t);
+extern int			nfnl_log_test_queue_threshold(const struct nfnl_log *);
+extern uint32_t			nfnl_log_get_queue_threshold(const struct nfnl_log *);
 
-extern void		nfnl_log_set_hwaddr(struct nfnl_log *, uint8_t *, int);
-extern const uint8_t *	nfnl_log_get_hwaddr(const struct nfnl_log *, int *);
+extern void			nfnl_log_set_flags(struct nfnl_log *, unsigned int);
+extern void			nfnl_log_unset_flags(struct nfnl_log *, unsigned int);
+extern unsigned int		nfnl_log_get_flags(const struct nfnl_log *);
 
-extern int		nfnl_log_set_payload(struct nfnl_log *, uint8_t *, int);
-extern const void *	nfnl_log_get_payload(const struct nfnl_log *, int *);
+extern char *			nfnl_log_flags2str(unsigned int, char *, size_t);
+extern unsigned int		nfnl_log_str2flags(const char *);
 
-extern int		nfnl_log_set_prefix(struct nfnl_log *, void *);
-extern const char *	nfnl_log_get_prefix(const struct nfnl_log *);
+/* Message construction / sending */
+extern struct nl_msg *		nfnl_log_build_pf_bind(uint8_t);
+extern int			nfnl_log_pf_bind(struct nl_handle *, uint8_t);
 
-extern void		nfnl_log_set_uid(struct nfnl_log *, uint32_t);
-extern int		nfnl_log_test_uid(const struct nfnl_log *);
-extern uint32_t		nfnl_log_get_uid(const struct nfnl_log *);
+extern struct nl_msg *		nfnl_log_build_pf_unbind(uint8_t);
+extern int			nfnl_log_pf_unbind(struct nl_handle *, uint8_t);
 
-extern void		nfnl_log_set_gid(struct nfnl_log *, uint32_t);
-extern int		nfnl_log_test_gid(const struct nfnl_log *);
-extern uint32_t		nfnl_log_get_gid(const struct nfnl_log *);
+extern struct nl_msg *		nfnl_log_build_create_request(const struct nfnl_log *);
+extern int			nfnl_log_create(struct nl_handle *,
+						const struct nfnl_log *);
 
-extern void		nfnl_log_set_seq(struct nfnl_log *, uint32_t);
-extern int		nfnl_log_test_seq(const struct nfnl_log *);
-extern uint32_t		nfnl_log_get_seq(const struct nfnl_log *);
+extern struct nl_msg *		nfnl_log_build_change_request(const struct nfnl_log *);
+extern int			nfnl_log_change(struct nl_handle *,
+						const struct nfnl_log *);
 
-extern void		nfnl_log_set_seq_global(struct nfnl_log *, uint32_t);
-extern int		nfnl_log_test_seq_global(const struct nfnl_log *);
-extern uint32_t		nfnl_log_get_seq_global(const struct nfnl_log *);
+extern struct nl_msg *		nfnl_log_build_delete_request(const struct nfnl_log *);
+extern int			nfnl_log_delete(struct nl_handle *,
+						const struct nfnl_log *);
 
 #ifdef __cplusplus
 }
diff --git a/include/netlink/netfilter/log_msg.h b/include/netlink/netfilter/log_msg.h
new file mode 100644
index 0000000..0cdb6c6
--- /dev/null
+++ b/include/netlink/netfilter/log_msg.h
@@ -0,0 +1,98 @@
+/*
+ * netlink/netfilter/log_msg.h	Netfilter Log Message
+ *
+ *	This library is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU Lesser General Public
+ *	License as published by the Free Software Foundation version 2.1
+ *	of the License.
+ *
+ * Copyright (c) 2003-2006 Thomas Graf <tgraf@suug.ch>
+ * Copyright (c) 2007 Philip Craig <philipc@snapgear.com>
+ * Copyright (c) 2007 Secure Computing Corporation
+ * Copyright (c) 2008 Patrick McHardy <kaber@trash.net>
+ */
+
+#ifndef NETLINK_LOG_MSG_H_
+#define NETLINK_LOG_MSG_H_
+
+#include <netlink/netlink.h>
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+struct nl_handle;
+struct nlmsghdr;
+struct nfnl_log_msg;
+
+extern struct nl_object_ops log_msg_obj_ops;
+
+/* General */
+extern struct nfnl_log_msg *nfnl_log_msg_alloc(void);
+extern struct nfnl_log_msg *nfnlmsg_log_msg_parse(struct nlmsghdr *);
+
+extern void		nfnl_log_msg_get(struct nfnl_log_msg *);
+extern void		nfnl_log_msg_put(struct nfnl_log_msg *);
+
+extern void		nfnl_log_msg_set_family(struct nfnl_log_msg *, uint8_t);
+extern uint8_t		nfnl_log_msg_get_family(const struct nfnl_log_msg *);
+
+extern void		nfnl_log_msg_set_hwproto(struct nfnl_log_msg *, uint16_t);
+extern int		nfnl_log_msg_test_hwproto(const struct nfnl_log_msg *);
+extern uint16_t		nfnl_log_msg_get_hwproto(const struct nfnl_log_msg *);
+
+extern void		nfnl_log_msg_set_hook(struct nfnl_log_msg *, uint8_t);
+extern int		nfnl_log_msg_test_hook(const struct nfnl_log_msg *);
+extern uint8_t		nfnl_log_msg_get_hook(const struct nfnl_log_msg *);
+
+extern void		nfnl_log_msg_set_mark(struct nfnl_log_msg *, uint32_t);
+extern int		nfnl_log_msg_test_mark(const struct nfnl_log_msg *);
+extern uint32_t		nfnl_log_msg_get_mark(const struct nfnl_log_msg *);
+
+extern void		nfnl_log_msg_set_timestamp(struct nfnl_log_msg *,
+					       struct timeval *);
+extern const struct timeval *nfnl_log_msg_get_timestamp(const struct nfnl_log_msg *);
+
+extern void		nfnl_log_msg_set_indev(struct nfnl_log_msg *, uint32_t);
+extern uint32_t		nfnl_log_msg_get_indev(const struct nfnl_log_msg *);
+
+extern void		nfnl_log_msg_set_outdev(struct nfnl_log_msg *, uint32_t);
+extern uint32_t		nfnl_log_msg_get_outdev(const struct nfnl_log_msg *);
+
+extern void		nfnl_log_msg_set_physindev(struct nfnl_log_msg *, uint32_t);
+extern uint32_t		nfnl_log_msg_get_physindev(const struct nfnl_log_msg *);
+
+extern void		nfnl_log_msg_set_physoutdev(struct nfnl_log_msg *, uint32_t);
+extern uint32_t		nfnl_log_msg_get_physoutdev(const struct nfnl_log_msg *);
+
+extern void		nfnl_log_msg_set_hwaddr(struct nfnl_log_msg *, uint8_t *, int);
+extern const uint8_t *	nfnl_log_msg_get_hwaddr(const struct nfnl_log_msg *, int *);
+
+extern int		nfnl_log_msg_set_payload(struct nfnl_log_msg *, uint8_t *, int);
+extern const void *	nfnl_log_msg_get_payload(const struct nfnl_log_msg *, int *);
+
+extern int		nfnl_log_msg_set_prefix(struct nfnl_log_msg *, void *);
+extern const char *	nfnl_log_msg_get_prefix(const struct nfnl_log_msg *);
+
+extern void		nfnl_log_msg_set_uid(struct nfnl_log_msg *, uint32_t);
+extern int		nfnl_log_msg_test_uid(const struct nfnl_log_msg *);
+extern uint32_t		nfnl_log_msg_get_uid(const struct nfnl_log_msg *);
+
+extern void		nfnl_log_msg_set_gid(struct nfnl_log_msg *, uint32_t);
+extern int		nfnl_log_msg_test_gid(const struct nfnl_log_msg *);
+extern uint32_t		nfnl_log_msg_get_gid(const struct nfnl_log_msg *);
+
+extern void		nfnl_log_msg_set_seq(struct nfnl_log_msg *, uint32_t);
+extern int		nfnl_log_msg_test_seq(const struct nfnl_log_msg *);
+extern uint32_t		nfnl_log_msg_get_seq(const struct nfnl_log_msg *);
+
+extern void		nfnl_log_msg_set_seq_global(struct nfnl_log_msg *, uint32_t);
+extern int		nfnl_log_msg_test_seq_global(const struct nfnl_log_msg *);
+extern uint32_t		nfnl_log_msg_get_seq_global(const struct nfnl_log_msg *);
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif
+
diff --git a/lib/netfilter/log.c b/lib/netfilter/log.c
index 8d70e7f..c92d401 100644
--- a/lib/netfilter/log.c
+++ b/lib/netfilter/log.c
@@ -26,178 +26,13 @@
 #include <netlink/netfilter/nfnl.h>
 #include <netlink/netfilter/log.h>
 
-static struct nl_cache_ops nfnl_log_ops;
-
-#if __BYTE_ORDER == __BIG_ENDIAN
-static uint64_t ntohll(uint64_t x)
-{
-	return x;
-}
-#elif __BYTE_ORDER == __LITTLE_ENDIAN
-static uint64_t ntohll(uint64_t x)
-{
-	return __bswap_64(x);
-}
-#endif
-
-static struct nla_policy log_policy[NFULA_MAX+1] = {
-	[NFULA_PACKET_HDR]		= {
-		.minlen = sizeof(struct nfulnl_msg_packet_hdr)
-	},
-	[NFULA_MARK]			= { .type = NLA_U32 },
-	[NFULA_TIMESTAMP]		= {
-		.minlen = sizeof(struct nfulnl_msg_packet_timestamp)
-	},
-	[NFULA_IFINDEX_INDEV]		= { .type = NLA_U32 },
-	[NFULA_IFINDEX_OUTDEV]		= { .type = NLA_U32 },
-	[NFULA_IFINDEX_PHYSINDEV]	= { .type = NLA_U32 },
-	[NFULA_IFINDEX_PHYSOUTDEV]	= { .type = NLA_U32 },
-	[NFULA_HWADDR]			= {
-		.minlen = sizeof(struct nfulnl_msg_packet_hw)
-	},
-	//[NFULA_PAYLOAD]
-	[NFULA_PREFIX]			= { .type = NLA_STRING, },
-	[NFULA_UID]			= { .type = NLA_U32 },
-	[NFULA_GID]			= { .type = NLA_U32 },
-	[NFULA_SEQ]			= { .type = NLA_U32 },
-	[NFULA_SEQ_GLOBAL]		= { .type = NLA_U32 },
-};
-
-struct nfnl_log *nfnlmsg_log_parse(struct nlmsghdr *nlh)
-{
-	struct nfnl_log *log;
-	struct nlattr *tb[NFULA_MAX+1];
-	struct nlattr *attr;
-	int err;
-
-	log = nfnl_log_alloc();
-	if (!log)
-		return NULL;
-
-	log->ce_msgtype = nlh->nlmsg_type;
-
-	err = nlmsg_parse(nlh, sizeof(struct nfgenmsg), tb, NFULA_MAX,
-			  log_policy);
-	if (err < 0)
-		goto errout;
-
-	nfnl_log_set_family(log, nfnlmsg_family(nlh));
-
-	attr = tb[NFULA_PACKET_HDR];
-	if (attr) {
-		struct nfulnl_msg_packet_hdr *hdr = nla_data(attr);
-
-		if (hdr->hw_protocol)
-			nfnl_log_set_hwproto(log, hdr->hw_protocol);
-		nfnl_log_set_hook(log, hdr->hook);
-	}
-
-	attr = tb[NFULA_MARK];
-	if (attr)
-		nfnl_log_set_mark(log, ntohl(nla_get_u32(attr)));
-
-	attr = tb[NFULA_TIMESTAMP];
-	if (attr) {
-		struct nfulnl_msg_packet_timestamp *timestamp = nla_data(attr);
-		struct timeval tv;
-
-		tv.tv_sec = ntohll(timestamp->sec);
-		tv.tv_usec = ntohll(timestamp->usec);
-		nfnl_log_set_timestamp(log, &tv);
-	}
-
-	attr = tb[NFULA_IFINDEX_INDEV];
-	if (attr)
-		nfnl_log_set_indev(log, ntohl(nla_get_u32(attr)));
-
-	attr = tb[NFULA_IFINDEX_OUTDEV];
-	if (attr)
-		nfnl_log_set_outdev(log, ntohl(nla_get_u32(attr)));
-
-	attr = tb[NFULA_IFINDEX_PHYSINDEV];
-	if (attr)
-		nfnl_log_set_physindev(log, ntohl(nla_get_u32(attr)));
-
-	attr = tb[NFULA_IFINDEX_PHYSOUTDEV];
-	if (attr)
-		nfnl_log_set_physoutdev(log, ntohl(nla_get_u32(attr)));
-
-	attr = tb[NFULA_HWADDR];
-	if (attr) {
-		struct nfulnl_msg_packet_hw *hw = nla_data(attr);
-
-		nfnl_log_set_hwaddr(log, hw->hw_addr, ntohs(hw->hw_addrlen));
-	}
-
-	attr = tb[NFULA_PAYLOAD];
-	if (attr) {
-		err = nfnl_log_set_payload(log, nla_data(attr), nla_len(attr));
-		if (err < 0)
-			goto errout;
-	}
-
-	attr = tb[NFULA_PREFIX];
-	if (attr) {
-		err = nfnl_log_set_prefix(log, nla_data(attr));
-		if (err < 0)
-			goto errout;
-	}
-
-	attr = tb[NFULA_UID];
-	if (attr)
-		nfnl_log_set_uid(log, ntohl(nla_get_u32(attr)));
-
-	attr = tb[NFULA_GID];
-	if (attr)
-		nfnl_log_set_gid(log, ntohl(nla_get_u32(attr)));
-
-	attr = tb[NFULA_SEQ];
-	if (attr)
-		nfnl_log_set_seq(log, ntohl(nla_get_u32(attr)));
-
-	attr = tb[NFULA_SEQ_GLOBAL];
-	if (attr)
-		nfnl_log_set_seq_global(log, ntohl(nla_get_u32(attr)));
-
-	return log;
-
-errout:
-	nfnl_log_put(log);
-	return NULL;
-}
-
-static int log_msg_parser(struct nl_cache_ops *ops, struct sockaddr_nl *who,
-			 struct nlmsghdr *nlh, struct nl_parser_param *pp)
-{
-	struct nfnl_log *log;
-	int err;
-
-	log = nfnlmsg_log_parse(nlh);
-	if (log == NULL)
-		goto errout_errno;
-
-	err = pp->pp_cb((struct nl_object *) log, pp);
-	if (err < 0)
-		goto errout;
-
-	err = P_ACCEPT;
-
-errout:
-	nfnl_log_put(log);
-	return err;
-
-errout_errno:
-	err = nl_get_errno();
-	goto errout;
-}
-
 /**
  * @name Log Commands
  * @{
  */
 
-static struct nl_msg *build_log_cmd_msg(uint8_t family, uint16_t queuenum,
-					uint8_t command)
+static struct nl_msg *build_log_cmd_request(uint8_t family, uint16_t queuenum,
+					    uint8_t command)
 {
 	struct nl_msg *msg;
 	struct nfulnl_msg_config_cmd cmd;
@@ -218,7 +53,7 @@ nla_put_failure:
 	return NULL;
 }
 
-static int send_log_msg(struct nl_handle *handle, struct nl_msg *msg)
+static int send_log_request(struct nl_handle *handle, struct nl_msg *msg)
 {
 	int err;
 
@@ -230,84 +65,108 @@ static int send_log_msg(struct nl_handle *handle, struct nl_msg *msg)
 	return nl_wait_for_ack(handle);
 }
 
-struct nl_msg *nfnl_log_build_bind(uint16_t queuenum)
+struct nl_msg *nfnl_log_build_pf_bind(uint8_t pf)
 {
-	return build_log_cmd_msg(0, queuenum, NFULNL_CFG_CMD_BIND);
+	return build_log_cmd_request(pf, 0, NFULNL_CFG_CMD_PF_BIND);
 }
 
-int nfnl_log_bind(struct nl_handle *nlh, uint16_t queuenum)
+int nfnl_log_pf_bind(struct nl_handle *nlh, uint8_t pf)
 {
 	struct nl_msg *msg;
 
-	msg = nfnl_log_build_bind(queuenum);
+	msg = nfnl_log_build_pf_bind(pf);
 	if (!msg)
 		return nl_get_errno();
 
-	return send_log_msg(nlh, msg);
+	return send_log_request(nlh, msg);
 }
 
-struct nl_msg *nfnl_log_build_unbind(uint16_t queuenum)
+struct nl_msg *nfnl_log_build_pf_unbind(uint8_t pf)
 {
-	return build_log_cmd_msg(0, queuenum, NFULNL_CFG_CMD_UNBIND);
+	return build_log_cmd_request(pf, 0, NFULNL_CFG_CMD_PF_UNBIND);
 }
 
-int nfnl_log_unbind(struct nl_handle *nlh, uint16_t queuenum)
+int nfnl_log_pf_unbind(struct nl_handle *nlh, uint8_t pf)
 {
 	struct nl_msg *msg;
 
-	msg = nfnl_log_build_bind(queuenum);
+	msg = nfnl_log_build_pf_unbind(pf);
 	if (!msg)
 		return nl_get_errno();
 
-	return send_log_msg(nlh, msg);
-}
-
-struct nl_msg *nfnl_log_build_pf_bind(uint8_t pf)
-{
-	return build_log_cmd_msg(pf, 0, NFULNL_CFG_CMD_PF_BIND);
+	return send_log_request(nlh, msg);
 }
 
-int nfnl_log_pf_bind(struct nl_handle *nlh, uint8_t pf)
+static struct nl_msg *nfnl_log_build_request(const struct nfnl_log *log)
 {
 	struct nl_msg *msg;
 
-	msg = nfnl_log_build_pf_bind(pf);
-	if (!msg)
-		return nl_get_errno();
+	if (!nfnl_log_test_group(log))
+		return NULL;
 
-	return send_log_msg(nlh, msg);
-}
+	msg = nfnlmsg_alloc_simple(NFNL_SUBSYS_ULOG, NFULNL_MSG_CONFIG, 0,
+				   0, nfnl_log_get_group(log));
+	if (msg == NULL)
+		return NULL;
 
-struct nl_msg *nfnl_log_build_pf_unbind(uint8_t pf)
-{
-	return build_log_cmd_msg(pf, 0, NFULNL_CFG_CMD_PF_UNBIND);
-}
+	/* This sucks. The nfnetlink_log interface always expects both
+	 * parameters to be present. Needs to be done properly.
+	 */
+	if (nfnl_log_test_copy_mode(log)) {
+		struct nfulnl_msg_config_mode mode;
+
+		switch (nfnl_log_get_copy_mode(log)) {
+		case NFNL_LOG_COPY_NONE:
+			mode.copy_mode = NFULNL_COPY_NONE;
+			break;
+		case NFNL_LOG_COPY_META:
+			mode.copy_mode = NFULNL_COPY_META;
+			break;
+		case NFNL_LOG_COPY_PACKET:
+			mode.copy_mode = NFULNL_COPY_PACKET;
+			break;
+		}
+		mode.copy_range = htonl(nfnl_log_get_copy_range(log));
+		mode._pad = 0;
+
+		if (nla_put(msg, NFULA_CFG_MODE, sizeof(mode), &mode) < 0)
+			goto nla_put_failure;
+	}
 
-int nfnl_log_pf_unbind(struct nl_handle *nlh, uint8_t pf)
-{
-	struct nl_msg *msg;
+	if (nfnl_log_test_flush_timeout(log) &&
+	    nla_put_u32(msg, NFULA_CFG_TIMEOUT,
+	    		htonl(nfnl_log_get_flush_timeout(log))) < 0)
+		goto nla_put_failure;
 
-	msg = nfnl_log_build_pf_unbind(pf);
-	if (!msg)
-		return nl_get_errno();
+	if (nfnl_log_test_alloc_size(log) &&
+	    nla_put_u32(msg, NFULA_CFG_NLBUFSIZ,
+	    		htonl(nfnl_log_get_alloc_size(log))) < 0)
+		goto nla_put_failure;
 
-	return send_log_msg(nlh, msg);
+	if (nfnl_log_test_queue_threshold(log) &&
+	    nla_put_u32(msg, NFULA_CFG_QTHRESH,
+	    		htonl(nfnl_log_get_queue_threshold(log))) < 0)
+		goto nla_put_failure;
+
+	return msg;
+
+nla_put_failure:
+	nlmsg_free(msg);
+	return NULL;
 }
 
-struct nl_msg *nfnl_log_build_mode(uint16_t queuenum, uint8_t copy_mode,
-				   uint32_t copy_range)
+struct nl_msg *nfnl_log_build_create_request(const struct nfnl_log *log)
 {
 	struct nl_msg *msg;
-	struct nfulnl_msg_config_mode mode;
+	struct nfulnl_msg_config_cmd cmd;
 
-	msg = nfnlmsg_alloc_simple(NFNL_SUBSYS_ULOG, NFULNL_MSG_CONFIG, 0,
-			0, queuenum);
+	msg = nfnl_log_build_request(log);
 	if (msg == NULL)
 		return NULL;
 
-	mode.copy_mode = copy_mode;
-	mode.copy_range = htonl(copy_range);
-	if (nla_put(msg, NFULA_CFG_MODE, sizeof(mode), &mode) < 0)
+	cmd.command = NFULNL_CFG_CMD_BIND;
+
+	if (nla_put(msg, NFULA_CFG_CMD, sizeof(cmd), &cmd) < 0)
 		goto nla_put_failure;
 
 	return msg;
@@ -317,29 +176,57 @@ nla_put_failure:
 	return NULL;
 }
 
-int nfnl_log_set_mode(struct nl_handle *nlh, uint16_t queuenum,
-		      uint8_t copy_mode, uint32_t copy_range)
+int nfnl_log_create(struct nl_handle *nlh, const struct nfnl_log *log)
 {
 	struct nl_msg *msg;
 
-	msg = nfnl_log_build_mode(queuenum, copy_mode, copy_range);
-	if (!msg)
-		return nl_get_errno();
-	return send_log_msg(nlh, msg);
+	msg = nfnl_log_build_create_request(log);
+	if (msg == NULL)
+		return nl_errno(ENOMEM);
+
+	return send_log_request(nlh, msg);
+}
+
+struct nl_msg *nfnl_log_build_change_request(const struct nfnl_log *log)
+{
+	return nfnl_log_build_request(log);
+}
+
+int nfnl_log_change(struct nl_handle *nlh, const struct nfnl_log *log)
+{
+	struct nl_msg *msg;
+
+	msg = nfnl_log_build_change_request(log);
+	if (msg == NULL)
+		return nl_errno(ENOMEM);
+
+	return send_log_request(nlh, msg);
+}
+
+struct nl_msg *nfnl_log_build_delete_request(const struct nfnl_log *log)
+{
+	if (!nfnl_log_test_group(log))
+		return NULL;
+
+	return build_log_cmd_request(0, nfnl_log_get_group(log),
+				     NFULNL_CFG_CMD_UNBIND);
+}
+
+int nfnl_log_delete(struct nl_handle *nlh, const struct nfnl_log *log)
+{
+	struct nl_msg *msg;
+
+	msg = nfnl_log_build_delete_request(log);
+	if (msg == NULL)
+		return nl_errno(ENOMEM);
+
+	return send_log_request(nlh, msg);
 }
 
 /** @} */
 
-#define NFNLMSG_LOG_TYPE(type) NFNLMSG_TYPE(NFNL_SUBSYS_ULOG, (type))
 static struct nl_cache_ops nfnl_log_ops = {
 	.co_name		= "netfilter/log",
-	.co_hdrsize		= NFNL_HDRLEN,
-	.co_msgtypes		= {
-		{ NFNLMSG_LOG_TYPE(NFULNL_MSG_PACKET), NL_ACT_NEW, "new" },
-		END_OF_MSGTYPES_LIST,
-	},
-	.co_protocol		= NETLINK_NETFILTER,
-	.co_msg_parser		= log_msg_parser,
 	.co_obj_ops		= &log_obj_ops,
 };
 
diff --git a/lib/netfilter/log_msg.c b/lib/netfilter/log_msg.c
new file mode 100644
index 0000000..5243338
--- /dev/null
+++ b/lib/netfilter/log_msg.c
@@ -0,0 +1,218 @@
+/*
+ * lib/netfilter/log_msg.c	Netfilter Log Message
+ *
+ *	This library is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU Lesser General Public
+ *	License as published by the Free Software Foundation version 2.1
+ *	of the License.
+ *
+ * Copyright (c) 2003-2006 Thomas Graf <tgraf@suug.ch>
+ * Copyright (c) 2007 Philip Craig <philipc@snapgear.com>
+ * Copyright (c) 2007 Secure Computing Corporation
+ * Copyright (c) 2008 Patrick McHardy <kaber@trash.net>
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
+#include <netlink/netfilter/log_msg.h>
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
+static struct nla_policy log_msg_policy[NFULA_MAX+1] = {
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
+	[NFULA_GID]			= { .type = NLA_U32 },
+	[NFULA_SEQ]			= { .type = NLA_U32 },
+	[NFULA_SEQ_GLOBAL]		= { .type = NLA_U32 },
+};
+
+struct nfnl_log_msg *nfnlmsg_log_msg_parse(struct nlmsghdr *nlh)
+{
+	struct nfnl_log_msg *msg;
+	struct nlattr *tb[NFULA_MAX+1];
+	struct nlattr *attr;
+	int err;
+
+	msg = nfnl_log_msg_alloc();
+	if (!msg)
+		return NULL;
+
+	msg->ce_msgtype = nlh->nlmsg_type;
+
+	err = nlmsg_parse(nlh, sizeof(struct nfgenmsg), tb, NFULA_MAX,
+			  log_msg_policy);
+	if (err < 0)
+		goto errout;
+
+	nfnl_log_msg_set_family(msg, nfnlmsg_family(nlh));
+
+	attr = tb[NFULA_PACKET_HDR];
+	if (attr) {
+		struct nfulnl_msg_packet_hdr *hdr = nla_data(attr);
+
+		if (hdr->hw_protocol)
+			nfnl_log_msg_set_hwproto(msg, hdr->hw_protocol);
+		nfnl_log_msg_set_hook(msg, hdr->hook);
+	}
+
+	attr = tb[NFULA_MARK];
+	if (attr)
+		nfnl_log_msg_set_mark(msg, ntohl(nla_get_u32(attr)));
+
+	attr = tb[NFULA_TIMESTAMP];
+	if (attr) {
+		struct nfulnl_msg_packet_timestamp *timestamp = nla_data(attr);
+		struct timeval tv;
+
+		tv.tv_sec = ntohll(timestamp->sec);
+		tv.tv_usec = ntohll(timestamp->usec);
+		nfnl_log_msg_set_timestamp(msg, &tv);
+	}
+
+	attr = tb[NFULA_IFINDEX_INDEV];
+	if (attr)
+		nfnl_log_msg_set_indev(msg, ntohl(nla_get_u32(attr)));
+
+	attr = tb[NFULA_IFINDEX_OUTDEV];
+	if (attr)
+		nfnl_log_msg_set_outdev(msg, ntohl(nla_get_u32(attr)));
+
+	attr = tb[NFULA_IFINDEX_PHYSINDEV];
+	if (attr)
+		nfnl_log_msg_set_physindev(msg, ntohl(nla_get_u32(attr)));
+
+	attr = tb[NFULA_IFINDEX_PHYSOUTDEV];
+	if (attr)
+		nfnl_log_msg_set_physoutdev(msg, ntohl(nla_get_u32(attr)));
+
+	attr = tb[NFULA_HWADDR];
+	if (attr) {
+		struct nfulnl_msg_packet_hw *hw = nla_data(attr);
+
+		nfnl_log_msg_set_hwaddr(msg, hw->hw_addr, ntohs(hw->hw_addrlen));
+	}
+
+	attr = tb[NFULA_PAYLOAD];
+	if (attr) {
+		err = nfnl_log_msg_set_payload(msg, nla_data(attr), nla_len(attr));
+		if (err < 0)
+			goto errout;
+	}
+
+	attr = tb[NFULA_PREFIX];
+	if (attr) {
+		err = nfnl_log_msg_set_prefix(msg, nla_data(attr));
+		if (err < 0)
+			goto errout;
+	}
+
+	attr = tb[NFULA_UID];
+	if (attr)
+		nfnl_log_msg_set_uid(msg, ntohl(nla_get_u32(attr)));
+
+	attr = tb[NFULA_GID];
+	if (attr)
+		nfnl_log_msg_set_gid(msg, ntohl(nla_get_u32(attr)));
+
+	attr = tb[NFULA_SEQ];
+	if (attr)
+		nfnl_log_msg_set_seq(msg, ntohl(nla_get_u32(attr)));
+
+	attr = tb[NFULA_SEQ_GLOBAL];
+	if (attr)
+		nfnl_log_msg_set_seq_global(msg, ntohl(nla_get_u32(attr)));
+
+	return msg;
+
+errout:
+	nfnl_log_msg_put(msg);
+	return NULL;
+}
+
+static int log_msg_parser(struct nl_cache_ops *ops, struct sockaddr_nl *who,
+			  struct nlmsghdr *nlh, struct nl_parser_param *pp)
+{
+	struct nfnl_log_msg *msg;
+	int err;
+
+	msg = nfnlmsg_log_msg_parse(nlh);
+	if (log == NULL)
+		goto errout_errno;
+
+	err = pp->pp_cb((struct nl_object *) msg, pp);
+	if (err < 0)
+		goto errout;
+
+	err = P_ACCEPT;
+
+errout:
+	nfnl_log_msg_put(msg);
+	return err;
+
+errout_errno:
+	err = nl_get_errno();
+	goto errout;
+}
+
+/** @} */
+
+#define NFNLMSG_LOG_TYPE(type) NFNLMSG_TYPE(NFNL_SUBSYS_ULOG, (type))
+static struct nl_cache_ops nfnl_log_msg_ops = {
+	.co_name		= "netfilter/log_msg",
+	.co_hdrsize		= NFNL_HDRLEN,
+	.co_msgtypes		= {
+		{ NFNLMSG_LOG_TYPE(NFULNL_MSG_PACKET), NL_ACT_NEW, "new" },
+		END_OF_MSGTYPES_LIST,
+	},
+	.co_protocol		= NETLINK_NETFILTER,
+	.co_msg_parser		= log_msg_parser,
+	.co_obj_ops		= &log_msg_obj_ops,
+};
+
+static void __init log_msg_init(void)
+{
+	nl_cache_mngt_register(&nfnl_log_msg_ops);
+}
+
+static void __exit log_msg_exit(void)
+{
+	nl_cache_mngt_unregister(&nfnl_log_msg_ops);
+}
+
+/** @} */
diff --git a/lib/netfilter/log_msg_obj.c b/lib/netfilter/log_msg_obj.c
new file mode 100644
index 0000000..ee85090
--- /dev/null
+++ b/lib/netfilter/log_msg_obj.c
@@ -0,0 +1,456 @@
+/*
+ * lib/netfilter/log_msg_obj.c	Netfilter Log Object
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
+#include <netlink/netfilter/netfilter.h>
+#include <netlink/netfilter/log_msg.h>
+
+/** @cond SKIP */
+#define LOG_MSG_ATTR_FAMILY		(1UL << 0)
+#define LOG_MSG_ATTR_HWPROTO		(1UL << 1)
+#define LOG_MSG_ATTR_HOOK		(1UL << 2)
+#define LOG_MSG_ATTR_MARK		(1UL << 3)
+#define LOG_MSG_ATTR_TIMESTAMP		(1UL << 4)
+#define LOG_MSG_ATTR_INDEV		(1UL << 5)
+#define LOG_MSG_ATTR_OUTDEV		(1UL << 6)
+#define LOG_MSG_ATTR_PHYSINDEV		(1UL << 7)
+#define LOG_MSG_ATTR_PHYSOUTDEV		(1UL << 8)
+#define LOG_MSG_ATTR_HWADDR		(1UL << 9)
+#define LOG_MSG_ATTR_PAYLOAD		(1UL << 10)
+#define LOG_MSG_ATTR_PREFIX		(1UL << 11)
+#define LOG_MSG_ATTR_UID		(1UL << 12)
+#define LOG_MSG_ATTR_GID		(1UL << 13)
+#define LOG_MSG_ATTR_SEQ		(1UL << 14)
+#define LOG_MSG_ATTR_SEQ_GLOBAL		(1UL << 15)
+/** @endcond */
+
+static void log_msg_free_data(struct nl_object *c)
+{
+	struct nfnl_log_msg *msg = (struct nfnl_log_msg *) c;
+
+	if (msg == NULL)
+		return;
+
+	free(msg->log_msg_payload);
+	free(msg->log_msg_prefix);
+}
+
+static int log_msg_clone(struct nl_object *_dst, struct nl_object *_src)
+{
+	struct nfnl_log_msg *dst = (struct nfnl_log_msg *) _dst;
+	struct nfnl_log_msg *src = (struct nfnl_log_msg *) _src;
+	int err;
+
+	if (src->log_msg_payload) {
+		err = nfnl_log_msg_set_payload(dst, src->log_msg_payload,
+					       src->log_msg_payload_len);
+		if (err < 0)
+			goto errout;
+	}
+
+	if (src->log_msg_prefix) {
+		err = nfnl_log_msg_set_prefix(dst, src->log_msg_prefix);
+		if (err < 0)
+			goto errout;
+	}
+
+	return 0;
+errout:
+	return err;
+}
+
+static int log_msg_dump(struct nl_object *a, struct nl_dump_params *p)
+{
+	struct nfnl_log_msg *msg = (struct nfnl_log_msg *) a;
+	struct nl_cache *link_cache;
+	char buf[64];
+
+	link_cache = nl_cache_mngt_require("route/link");
+
+	if (msg->ce_mask & LOG_MSG_ATTR_PREFIX)
+		dp_dump(p, "%s", msg->log_msg_prefix);
+
+	if (msg->ce_mask & LOG_MSG_ATTR_INDEV) {
+		if (link_cache)
+			dp_dump(p, "IN=%s ",
+				rtnl_link_i2name(link_cache,
+						 msg->log_msg_indev,
+						 buf, sizeof(buf)));
+		else
+			dp_dump(p, "IN=%d ", msg->log_msg_indev);
+	}
+
+	if (msg->ce_mask & LOG_MSG_ATTR_PHYSINDEV) {
+		if (link_cache)
+			dp_dump(p, "PHYSIN=%s ",
+				rtnl_link_i2name(link_cache,
+						 msg->log_msg_physindev,
+						 buf, sizeof(buf)));
+		else
+			dp_dump(p, "IN=%d ", msg->log_msg_physindev);
+	}
+
+	if (msg->ce_mask & LOG_MSG_ATTR_OUTDEV) {
+		if (link_cache)
+			dp_dump(p, "OUT=%s ",
+				rtnl_link_i2name(link_cache,
+						 msg->log_msg_outdev,
+						 buf, sizeof(buf)));
+		else
+			dp_dump(p, "OUT=%d ", msg->log_msg_outdev);
+	}
+
+	if (msg->ce_mask & LOG_MSG_ATTR_PHYSOUTDEV) {
+		if (link_cache)
+			dp_dump(p, "PHYSOUT=%s ",
+				rtnl_link_i2name(link_cache,
+						 msg->log_msg_physoutdev,
+						 buf, sizeof(buf)));
+		else
+			dp_dump(p, "PHYSOUT=%d ", msg->log_msg_physoutdev);
+	}
+
+	if (msg->ce_mask & LOG_MSG_ATTR_HWADDR) {
+		int i;
+
+		dp_dump(p, "MAC");
+		for (i = 0; i < msg->log_msg_hwaddr_len; i++)
+			dp_dump(p, "%c%02x", i?':':'=', msg->log_msg_hwaddr[i]);
+		dp_dump(p, " ");
+	}
+
+	/* FIXME: parse the payload to get iptables LOG compatible format */
+
+	if (msg->ce_mask & LOG_MSG_ATTR_FAMILY)
+		dp_dump(p, "FAMILY=%s ",
+			nl_af2str(msg->log_msg_family, buf, sizeof(buf)));
+
+	if (msg->ce_mask & LOG_MSG_ATTR_HWPROTO)
+		dp_dump(p, "HWPROTO=%s ",
+			nl_ether_proto2str(ntohs(msg->log_msg_hwproto),
+					   buf, sizeof(buf)));
+
+	if (msg->ce_mask & LOG_MSG_ATTR_HOOK)
+		dp_dump(p, "HOOK=%s ",
+			nfnl_inet_hook2str(msg->log_msg_hook,
+					   buf, sizeof(buf)));
+
+	if (msg->ce_mask & LOG_MSG_ATTR_MARK)
+		dp_dump(p, "MARK=%u ", msg->log_msg_mark);
+
+	if (msg->ce_mask & LOG_MSG_ATTR_PAYLOAD)
+		dp_dump(p, "PAYLOADLEN=%d ", msg->log_msg_payload_len);
+
+	if (msg->ce_mask & LOG_MSG_ATTR_UID)
+		dp_dump(p, "UID=%u ", msg->log_msg_uid);
+
+	if (msg->ce_mask & LOG_MSG_ATTR_GID)
+		dp_dump(p, "GID=%u ", msg->log_msg_gid);
+
+	if (msg->ce_mask & LOG_MSG_ATTR_SEQ)
+		dp_dump(p, "SEQ=%d ", msg->log_msg_seq);
+
+	if (msg->ce_mask & LOG_MSG_ATTR_SEQ_GLOBAL)
+		dp_dump(p, "SEQGLOBAL=%d ", msg->log_msg_seq_global);
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
+struct nfnl_log_msg *nfnl_log_msg_alloc(void)
+{
+	return (struct nfnl_log_msg *) nl_object_alloc(&log_msg_obj_ops);
+}
+
+void nfnl_log_msg_get(struct nfnl_log_msg *msg)
+{
+	nl_object_get((struct nl_object *) msg);
+}
+
+void nfnl_log_msg_put(struct nfnl_log_msg *msg)
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
+void nfnl_log_msg_set_family(struct nfnl_log_msg *msg, uint8_t family)
+{
+	msg->log_msg_family = family;
+	msg->ce_mask |= LOG_MSG_ATTR_FAMILY;
+}
+
+uint8_t nfnl_log_msg_get_family(const struct nfnl_log_msg *msg)
+{
+	if (msg->ce_mask & LOG_MSG_ATTR_FAMILY)
+		return msg->log_msg_family;
+	else
+		return AF_UNSPEC;
+}
+
+void nfnl_log_msg_set_hwproto(struct nfnl_log_msg *msg, uint16_t hwproto)
+{
+	msg->log_msg_hwproto = hwproto;
+	msg->ce_mask |= LOG_MSG_ATTR_HWPROTO;
+}
+
+int nfnl_log_msg_test_hwproto(const struct nfnl_log_msg *msg)
+{
+	return !!(msg->ce_mask & LOG_MSG_ATTR_HWPROTO);
+}
+
+uint16_t nfnl_log_msg_get_hwproto(const struct nfnl_log_msg *msg)
+{
+	return msg->log_msg_hwproto;
+}
+
+void nfnl_log_msg_set_hook(struct nfnl_log_msg *msg, uint8_t hook)
+{
+	msg->log_msg_hook = hook;
+	msg->ce_mask |= LOG_MSG_ATTR_HOOK;
+}
+
+int nfnl_log_msg_test_hook(const struct nfnl_log_msg *msg)
+{
+	return !!(msg->ce_mask & LOG_MSG_ATTR_HOOK);
+}
+
+uint8_t nfnl_log_msg_get_hook(const struct nfnl_log_msg *msg)
+{
+	return msg->log_msg_hook;
+}
+
+void nfnl_log_msg_set_mark(struct nfnl_log_msg *msg, uint32_t mark)
+{
+	msg->log_msg_mark = mark;
+	msg->ce_mask |= LOG_MSG_ATTR_MARK;
+}
+
+int nfnl_log_msg_test_mark(const struct nfnl_log_msg *msg)
+{
+	return !!(msg->ce_mask & LOG_MSG_ATTR_MARK);
+}
+
+uint32_t nfnl_log_msg_get_mark(const struct nfnl_log_msg *msg)
+{
+	return msg->log_msg_mark;
+}
+
+void nfnl_log_msg_set_timestamp(struct nfnl_log_msg *msg, struct timeval *tv)
+{
+	msg->log_msg_timestamp.tv_sec = tv->tv_sec;
+	msg->log_msg_timestamp.tv_usec = tv->tv_usec;
+	msg->ce_mask |= LOG_MSG_ATTR_TIMESTAMP;
+}
+
+const struct timeval *nfnl_log_msg_get_timestamp(const struct nfnl_log_msg *msg)
+{
+	if (!(msg->ce_mask & LOG_MSG_ATTR_TIMESTAMP))
+		return NULL;
+	return &msg->log_msg_timestamp;
+}
+
+void nfnl_log_msg_set_indev(struct nfnl_log_msg *msg, uint32_t indev)
+{
+	msg->log_msg_indev = indev;
+	msg->ce_mask |= LOG_MSG_ATTR_INDEV;
+}
+
+uint32_t nfnl_log_msg_get_indev(const struct nfnl_log_msg *msg)
+{
+	return msg->log_msg_indev;
+}
+
+void nfnl_log_msg_set_outdev(struct nfnl_log_msg *msg, uint32_t outdev)
+{
+	msg->log_msg_outdev = outdev;
+	msg->ce_mask |= LOG_MSG_ATTR_OUTDEV;
+}
+
+uint32_t nfnl_log_msg_get_outdev(const struct nfnl_log_msg *msg)
+{
+	return msg->log_msg_outdev;
+}
+
+void nfnl_log_msg_set_physindev(struct nfnl_log_msg *msg, uint32_t physindev)
+{
+	msg->log_msg_physindev = physindev;
+	msg->ce_mask |= LOG_MSG_ATTR_PHYSINDEV;
+}
+
+uint32_t nfnl_log_msg_get_physindev(const struct nfnl_log_msg *msg)
+{
+	return msg->log_msg_physindev;
+}
+
+void nfnl_log_msg_set_physoutdev(struct nfnl_log_msg *msg, uint32_t physoutdev)
+{
+	msg->log_msg_physoutdev = physoutdev;
+	msg->ce_mask |= LOG_MSG_ATTR_PHYSOUTDEV;
+}
+
+uint32_t nfnl_log_msg_get_physoutdev(const struct nfnl_log_msg *msg)
+{
+	return msg->log_msg_physoutdev;
+}
+
+void nfnl_log_msg_set_hwaddr(struct nfnl_log_msg *msg, uint8_t *hwaddr, int len)
+{
+	if (len > sizeof(msg->log_msg_hwaddr))
+		len = sizeof(msg->log_msg_hwaddr);
+	msg->log_msg_hwaddr_len = len;
+	memcpy(msg->log_msg_hwaddr, hwaddr, len);
+	msg->ce_mask |= LOG_MSG_ATTR_HWADDR;
+}
+
+const uint8_t *nfnl_log_msg_get_hwaddr(const struct nfnl_log_msg *msg, int *len)
+{
+	if (!(msg->ce_mask & LOG_MSG_ATTR_HWADDR)) {
+		*len = 0;
+		return NULL;
+	}
+
+	*len = msg->log_msg_hwaddr_len;
+	return msg->log_msg_hwaddr;
+}
+
+int nfnl_log_msg_set_payload(struct nfnl_log_msg *msg, uint8_t *payload, int len)
+{
+	free(msg->log_msg_payload);
+	msg->log_msg_payload = malloc(len);
+	if (!msg->log_msg_payload)
+		return nl_errno(ENOMEM);
+
+	memcpy(msg->log_msg_payload, payload, len);
+	msg->log_msg_payload_len = len;
+	msg->ce_mask |= LOG_MSG_ATTR_PAYLOAD;
+	return 0;
+}
+
+const void *nfnl_log_msg_get_payload(const struct nfnl_log_msg *msg, int *len)
+{
+	if (!(msg->ce_mask & LOG_MSG_ATTR_PAYLOAD)) {
+		*len = 0;
+		return NULL;
+	}
+
+	*len = msg->log_msg_payload_len;
+	return msg->log_msg_payload;
+}
+
+int nfnl_log_msg_set_prefix(struct nfnl_log_msg *msg, void *prefix)
+{
+	free(msg->log_msg_prefix);
+	msg->log_msg_prefix = strdup(prefix);
+	if (!msg->log_msg_prefix)
+		return nl_errno(ENOMEM);
+
+	msg->ce_mask |= LOG_MSG_ATTR_PREFIX;
+	return 0;
+}
+
+const char *nfnl_log_msg_get_prefix(const struct nfnl_log_msg *msg)
+{
+	return msg->log_msg_prefix;
+}
+
+void nfnl_log_msg_set_uid(struct nfnl_log_msg *msg, uint32_t uid)
+{
+	msg->log_msg_uid = uid;
+	msg->ce_mask |= LOG_MSG_ATTR_UID;
+}
+
+int nfnl_log_msg_test_uid(const struct nfnl_log_msg *msg)
+{
+	return !!(msg->ce_mask & LOG_MSG_ATTR_UID);
+}
+
+uint32_t nfnl_log_msg_get_uid(const struct nfnl_log_msg *msg)
+{
+	return msg->log_msg_uid;
+}
+
+void nfnl_log_msg_set_gid(struct nfnl_log_msg *msg, uint32_t gid)
+{
+	msg->log_msg_gid = gid;
+	msg->ce_mask |= LOG_MSG_ATTR_GID;
+}
+
+int nfnl_log_msg_test_gid(const struct nfnl_log_msg *msg)
+{
+	return !!(msg->ce_mask & LOG_MSG_ATTR_GID);
+}
+
+uint32_t nfnl_log_msg_get_gid(const struct nfnl_log_msg *msg)
+{
+	return msg->log_msg_gid;
+}
+
+
+void nfnl_log_msg_set_seq(struct nfnl_log_msg *msg, uint32_t seq)
+{
+	msg->log_msg_seq = seq;
+	msg->ce_mask |= LOG_MSG_ATTR_SEQ;
+}
+
+int nfnl_log_msg_test_seq(const struct nfnl_log_msg *msg)
+{
+	return !!(msg->ce_mask & LOG_MSG_ATTR_SEQ);
+}
+
+uint32_t nfnl_log_msg_get_seq(const struct nfnl_log_msg *msg)
+{
+	return msg->log_msg_seq;
+}
+
+void nfnl_log_msg_set_seq_global(struct nfnl_log_msg *msg, uint32_t seq_global)
+{
+	msg->log_msg_seq_global = seq_global;
+	msg->ce_mask |= LOG_MSG_ATTR_SEQ_GLOBAL;
+}
+
+int nfnl_log_msg_test_seq_global(const struct nfnl_log_msg *msg)
+{
+	return !!(msg->ce_mask & LOG_MSG_ATTR_SEQ_GLOBAL);
+}
+
+uint32_t nfnl_log_msg_get_seq_global(const struct nfnl_log_msg *msg)
+{
+	return msg->log_msg_seq_global;
+}
+
+/** @} */
+
+struct nl_object_ops log_msg_obj_ops = {
+	.oo_name		= "netfilter/log_msg",
+	.oo_size		= sizeof(struct nfnl_log_msg),
+	.oo_free_data		= log_msg_free_data,
+	.oo_clone		= log_msg_clone,
+	.oo_dump[NL_DUMP_BRIEF]	= log_msg_dump,
+	.oo_dump[NL_DUMP_FULL]	= log_msg_dump,
+	.oo_dump[NL_DUMP_STATS]	= log_msg_dump,
+};
+
+/** @} */
diff --git a/lib/netfilter/log_obj.c b/lib/netfilter/log_obj.c
index 0e4411e..ce65443 100644
--- a/lib/netfilter/log_obj.c
+++ b/lib/netfilter/log_obj.c
@@ -9,6 +9,7 @@
  * Copyright (c) 2003-2006 Thomas Graf <tgraf@suug.ch>
  * Copyright (c) 2007 Philip Craig <philipc@snapgear.com>
  * Copyright (c) 2007 Secure Computing Corporation
+ * Copyright (c) 2008 Patrick McHardy <kaber@trash.net>
  */
 
 #include <netlink-local.h>
@@ -16,152 +17,63 @@
 #include <netlink/netfilter/log.h>
 
 /** @cond SKIP */
-#define LOG_ATTR_FAMILY			(1UL << 0)
-#define LOG_ATTR_HWPROTO		(1UL << 1)
-#define LOG_ATTR_HOOK			(1UL << 2)
-#define LOG_ATTR_MARK			(1UL << 3)
-#define LOG_ATTR_TIMESTAMP		(1UL << 4)
-#define LOG_ATTR_INDEV			(1UL << 5)
-#define LOG_ATTR_OUTDEV			(1UL << 6)
-#define LOG_ATTR_PHYSINDEV		(1UL << 7)
-#define LOG_ATTR_PHYSOUTDEV		(1UL << 8)
-#define LOG_ATTR_HWADDR			(1UL << 9)
-#define LOG_ATTR_PAYLOAD		(1UL << 10)
-#define LOG_ATTR_PREFIX			(1UL << 11)
-#define LOG_ATTR_UID			(1UL << 12)
-#define LOG_ATTR_GID			(1UL << 13)
-#define LOG_ATTR_SEQ			(1UL << 14)
-#define LOG_ATTR_SEQ_GLOBAL		(1UL << 15)
+#define LOG_ATTR_GROUP			(1UL << 0)
+#define LOG_ATTR_COPY_MODE		(1UL << 1)
+#define LOG_ATTR_COPY_RANGE		(1UL << 3)
+#define LOG_ATTR_FLUSH_TIMEOUT		(1UL << 4)
+#define LOG_ATTR_ALLOC_SIZE		(1UL << 5)
+#define LOG_ATTR_QUEUE_THRESHOLD	(1UL << 6)
+
 /** @endcond */
 
-static void log_free_data(struct nl_object *c)
+static int nfnl_log_dump(struct nl_object *a, struct nl_dump_params *p)
 {
-	struct nfnl_log *log = (struct nfnl_log *) c;
+	struct nfnl_log *log = (struct nfnl_log *) a;
+	char buf[64];
 
-	if (log == NULL)
-		return;
+	if (log->ce_mask & LOG_ATTR_GROUP)
+		dp_dump(p, "group=%u ", log->log_group);
 
-	free(log->log_payload);
-	free(log->log_prefix);
-}
+	if (log->ce_mask & LOG_ATTR_COPY_MODE)
+		dp_dump(p, "copy_mode=%s ",
+			nfnl_log_copy_mode2str(log->log_copy_mode,
+					       buf, sizeof(buf)));
 
-static int log_clone(struct nl_object *_dst, struct nl_object *_src)
-{
-	struct nfnl_log *dst = (struct nfnl_log *) _dst;
-	struct nfnl_log *src = (struct nfnl_log *) _src;
-	int err;
-
-	if (src->log_payload) {
-		err = nfnl_log_set_payload(dst, src->log_payload,
-					   src->log_payload_len);
-		if (err < 0)
-			goto errout;
-	}
-
-	if (src->log_prefix) {
-		err = nfnl_log_set_prefix(dst, src->log_prefix);
-		if (err < 0)
-			goto errout;
-	}
-
-	return 0;
-errout:
-	return err;
-}
+	if (log->ce_mask & LOG_ATTR_COPY_RANGE)
+		dp_dump(p, "copy_range=%u ", log->log_copy_range);
 
-static int log_dump(struct nl_object *a, struct nl_dump_params *p)
-{
-	struct nfnl_log *log = (struct nfnl_log *) a;
-	struct nl_cache *link_cache;
-	char buf[64];
+	if (log->ce_mask & LOG_ATTR_FLUSH_TIMEOUT)
+		dp_dump(p, "flush_timeout=%u ", log->log_flush_timeout);
+
+	if (log->ce_mask & LOG_ATTR_ALLOC_SIZE)
+		dp_dump(p, "alloc_size=%u ", log->log_alloc_size);
 
-	link_cache = nl_cache_mngt_require("route/link");
-
-	if (log->ce_mask & LOG_ATTR_PREFIX)
-		dp_dump(p, "%s", log->log_prefix);
-
-	if (log->ce_mask & LOG_ATTR_INDEV) {
-		if (link_cache)
-			dp_dump(p, "IN=%s ",
-				rtnl_link_i2name(link_cache, log->log_indev,
-						 buf, sizeof(buf)));
-		else
-			dp_dump(p, "IN=%d ", log->log_indev);
-	}
-
-	if (log->ce_mask & LOG_ATTR_PHYSINDEV) {
-		if (link_cache)
-			dp_dump(p, "PHYSIN=%s ",
-				rtnl_link_i2name(link_cache, log->log_physindev,
-						 buf, sizeof(buf)));
-		else
-			dp_dump(p, "IN=%d ", log->log_physindev);
-	}
-
-	if (log->ce_mask & LOG_ATTR_OUTDEV) {
-		if (link_cache)
-			dp_dump(p, "OUT=%s ",
-				rtnl_link_i2name(link_cache, log->log_outdev,
-						 buf, sizeof(buf)));
-		else
-			dp_dump(p, "OUT=%d ", log->log_outdev);
-	}
-
-	if (log->ce_mask & LOG_ATTR_PHYSOUTDEV) {
-		if (link_cache)
-			dp_dump(p, "PHYSOUT=%s ",
-				rtnl_link_i2name(link_cache,log->log_physoutdev,
-						 buf, sizeof(buf)));
-		else
-			dp_dump(p, "PHYSOUT=%d ", log->log_physoutdev);
-	}
-
-	if (log->ce_mask & LOG_ATTR_HWADDR) {
-		int i;
-
-		dp_dump(p, "MAC");
-		for (i = 0; i < log->log_hwaddr_len; i++)
-			dp_dump(p, "%c%02x", i?':':'=', log->log_hwaddr[i]);
-		dp_dump(p, " ");
-	}
-
-	/* FIXME: parse the payload to get iptables LOG compatible format */
-
-	if (log->ce_mask & LOG_ATTR_FAMILY)
-		dp_dump(p, "FAMILY=%s ",
-			nl_af2str(log->log_family, buf, sizeof(buf)));
-
-	if (log->ce_mask & LOG_ATTR_HWPROTO)
-		dp_dump(p, "HWPROTO=%s ",
-			nl_ether_proto2str(ntohs(log->log_hwproto),
-					   buf, sizeof(buf)));
-
-	if (log->ce_mask & LOG_ATTR_HOOK)
-		dp_dump(p, "HOOK=%d ", log->log_hook);
-
-	if (log->ce_mask & LOG_ATTR_MARK)
-		dp_dump(p, "MARK=%d ", log->log_mark);
-
-	if (log->ce_mask & LOG_ATTR_PAYLOAD)
-		dp_dump(p, "PAYLOADLEN=%d ", log->log_payload_len);
-
-	if (log->ce_mask & LOG_ATTR_UID)
-		dp_dump(p, "UID=%u ", log->log_uid);
-
-	if (log->ce_mask & LOG_ATTR_GID)
-		dp_dump(p, "GID=%u ", log->log_gid);
-
-	if (log->ce_mask & LOG_ATTR_SEQ)
-		dp_dump(p, "SEQ=%d ", log->log_seq);
-
-	if (log->ce_mask & LOG_ATTR_SEQ_GLOBAL)
-		dp_dump(p, "SEQGLOBAL=%d ", log->log_seq_global);
+	if (log->ce_mask & LOG_ATTR_QUEUE_THRESHOLD)
+		dp_dump(p, "queue_threshold=%u ", log->log_queue_threshold);
 
 	dp_dump(p, "\n");
 
 	return 1;
 }
 
+static struct trans_tbl copy_modes[] = {
+	__ADD(NFNL_LOG_COPY_NONE,	none)
+	__ADD(NFNL_LOG_COPY_META,	meta)
+	__ADD(NFNL_LOG_COPY_PACKET,	packet)
+};
+
+char *nfnl_log_copy_mode2str(enum nfnl_log_copy_mode copy_mode, char *buf,
+			     size_t len)
+{
+	return __type2str(copy_mode, buf, len, copy_modes,
+			  ARRAY_SIZE(copy_modes));
+}
+
+enum nfnl_log_copy_mode nfnl_log_str2copy_mode(const char *name)
+{
+	return __str2type(name, copy_modes, ARRAY_SIZE(copy_modes));
+}
+
 /**
  * @name Allocation/Freeing
  * @{
@@ -189,249 +101,172 @@ void nfnl_log_put(struct nfnl_log *log)
  * @{
  */
 
-void nfnl_log_set_family(struct nfnl_log *log, uint8_t family)
-{
-	log->log_family = family;
-	log->ce_mask |= LOG_ATTR_FAMILY;
-}
-
-uint8_t nfnl_log_get_family(const struct nfnl_log *log)
-{
-	if (log->ce_mask & LOG_ATTR_FAMILY)
-		return log->log_family;
-	else
-		return AF_UNSPEC;
-}
-
-void nfnl_log_set_hwproto(struct nfnl_log *log, uint16_t hwproto)
-{
-	log->log_hwproto = hwproto;
-	log->ce_mask |= LOG_ATTR_HWPROTO;
-}
-
-int nfnl_log_test_hwproto(const struct nfnl_log *log)
-{
-	return !!(log->ce_mask & LOG_ATTR_HWPROTO);
-}
-
-uint16_t nfnl_log_get_hwproto(const struct nfnl_log *log)
-{
-	return log->log_hwproto;
-}
-
-void nfnl_log_set_hook(struct nfnl_log *log, uint8_t hook)
-{
-	log->log_hook = hook;
-	log->ce_mask |= LOG_ATTR_HOOK;
-}
-
-int nfnl_log_test_hook(const struct nfnl_log *log)
-{
-	return !!(log->ce_mask & LOG_ATTR_HOOK);
-}
-
-uint8_t nfnl_log_get_hook(const struct nfnl_log *log)
-{
-	return log->log_hook;
-}
-
-void nfnl_log_set_mark(struct nfnl_log *log, uint32_t mark)
-{
-	log->log_mark = mark;
-	log->ce_mask |= LOG_ATTR_MARK;
-}
-
-int nfnl_log_test_mark(const struct nfnl_log *log)
+void nfnl_log_set_group(struct nfnl_log *log, uint16_t group)
 {
-	return !!(log->ce_mask & LOG_ATTR_MARK);
+	log->log_group = group;
+	log->ce_mask |= LOG_ATTR_GROUP;
 }
 
-uint32_t nfnl_log_get_mark(const struct nfnl_log *log)
+int nfnl_log_test_group(const struct nfnl_log *log)
 {
-	return log->log_mark;
+	return !!(log->ce_mask & LOG_ATTR_GROUP);
 }
 
-void nfnl_log_set_timestamp(struct nfnl_log *log, struct timeval *tv)
+uint16_t nfnl_log_get_group(const struct nfnl_log *log)
 {
-	log->log_timestamp.tv_sec = tv->tv_sec;
-	log->log_timestamp.tv_usec = tv->tv_usec;
-	log->ce_mask |= LOG_ATTR_TIMESTAMP;
+	return log->log_group;
 }
 
-const struct timeval *nfnl_log_get_timestamp(const struct nfnl_log *log)
+void nfnl_log_set_copy_mode(struct nfnl_log *log, enum nfnl_log_copy_mode mode)
 {
-	if (!(log->ce_mask & LOG_ATTR_TIMESTAMP))
-		return NULL;
-	return &log->log_timestamp;
+	log->log_copy_mode = mode;
+	log->ce_mask |= LOG_ATTR_COPY_MODE;
 }
 
-void nfnl_log_set_indev(struct nfnl_log *log, uint32_t indev)
+int nfnl_log_test_copy_mode(const struct nfnl_log *log)
 {
-	log->log_indev = indev;
-	log->ce_mask |= LOG_ATTR_INDEV;
+	return !!(log->ce_mask & LOG_ATTR_COPY_MODE);
 }
 
-uint32_t nfnl_log_get_indev(const struct nfnl_log *log)
+enum nfnl_log_copy_mode nfnl_log_get_copy_mode(const struct nfnl_log *log)
 {
-	return log->log_indev;
+	return log->log_copy_mode;
 }
 
-void nfnl_log_set_outdev(struct nfnl_log *log, uint32_t outdev)
+void nfnl_log_set_copy_range(struct nfnl_log *log, uint32_t copy_range)
 {
-	log->log_outdev = outdev;
-	log->ce_mask |= LOG_ATTR_OUTDEV;
+	log->log_copy_range = copy_range;
+	log->ce_mask |= LOG_ATTR_COPY_RANGE;
 }
 
-uint32_t nfnl_log_get_outdev(const struct nfnl_log *log)
+int nfnl_log_test_copy_range(const struct nfnl_log *log)
 {
-	return log->log_outdev;
+	return !!(log->ce_mask & LOG_ATTR_COPY_RANGE);
 }
 
-void nfnl_log_set_physindev(struct nfnl_log *log, uint32_t physindev)
+uint32_t nfnl_log_get_copy_range(const struct nfnl_log *log)
 {
-	log->log_physindev = physindev;
-	log->ce_mask |= LOG_ATTR_PHYSINDEV;
+	return log->log_copy_range;
 }
 
-uint32_t nfnl_log_get_physindev(const struct nfnl_log *log)
+void nfnl_log_set_flush_timeout(struct nfnl_log *log, uint32_t timeout)
 {
-	return log->log_physindev;
+	log->log_flush_timeout = timeout;
+	log->ce_mask |= LOG_ATTR_FLUSH_TIMEOUT;
 }
 
-void nfnl_log_set_physoutdev(struct nfnl_log *log, uint32_t physoutdev)
+int nfnl_log_test_flush_timeout(const struct nfnl_log *log)
 {
-	log->log_physoutdev = physoutdev;
-	log->ce_mask |= LOG_ATTR_PHYSOUTDEV;
+	return !!(log->ce_mask & LOG_ATTR_FLUSH_TIMEOUT);
 }
 
-uint32_t nfnl_log_get_physoutdev(const struct nfnl_log *log)
+uint32_t nfnl_log_get_flush_timeout(const struct nfnl_log *log)
 {
-	return log->log_physoutdev;
+	return log->log_flush_timeout;
 }
 
-void nfnl_log_set_hwaddr(struct nfnl_log *log, uint8_t *hwaddr, int len)
+void nfnl_log_set_alloc_size(struct nfnl_log *log, uint32_t alloc_size)
 {
-	if (len > sizeof(log->log_hwaddr))
-		len = sizeof(log->log_hwaddr);
-	log->log_hwaddr_len = len;
-	memcpy(log->log_hwaddr, hwaddr, len);
-	log->ce_mask |= LOG_ATTR_HWADDR;
+	log->log_alloc_size = alloc_size;
+	log->ce_mask |= LOG_ATTR_ALLOC_SIZE;
 }
 
-const uint8_t *nfnl_log_get_hwaddr(const struct nfnl_log *log, int *len)
+int nfnl_log_test_alloc_size(const struct nfnl_log *log)
 {
-	if (!(log->ce_mask & LOG_ATTR_HWADDR)) {
-		*len = 0;
-		return NULL;
-	}
-
-	*len = log->log_hwaddr_len;
-	return log->log_hwaddr;
+	return !!(log->ce_mask & LOG_ATTR_ALLOC_SIZE);
 }
 
-int nfnl_log_set_payload(struct nfnl_log *log, uint8_t *payload, int len)
+uint32_t nfnl_log_get_alloc_size(const struct nfnl_log *log)
 {
-	free(log->log_payload);
-	log->log_payload = malloc(len);
-	if (!log->log_payload)
-		return nl_errno(ENOMEM);
-
-	memcpy(log->log_payload, payload, len);
-	log->log_payload_len = len;
-	log->ce_mask |= LOG_ATTR_PAYLOAD;
-	return 0;
+	return log->log_alloc_size;
 }
 
-const void *nfnl_log_get_payload(const struct nfnl_log *log, int *len)
+void nfnl_log_set_queue_threshold(struct nfnl_log *log, uint32_t threshold)
 {
-	if (!(log->ce_mask & LOG_ATTR_PAYLOAD)) {
-		*len = 0;
-		return NULL;
-	}
-
-	*len = log->log_payload_len;
-	return log->log_payload;
+	log->log_queue_threshold = threshold;
+	log->ce_mask |= LOG_ATTR_QUEUE_THRESHOLD;
 }
 
-int nfnl_log_set_prefix(struct nfnl_log *log, void *prefix)
+int nfnl_log_test_queue_threshold(const struct nfnl_log *log)
 {
-	free(log->log_prefix);
-	log->log_prefix = strdup(prefix);
-	if (!log->log_prefix)
-		return nl_errno(ENOMEM);
-
-	log->ce_mask |= LOG_ATTR_PREFIX;
-	return 0;
+	return !!(log->ce_mask & LOG_ATTR_QUEUE_THRESHOLD);
 }
 
-const char *nfnl_log_get_prefix(const struct nfnl_log *log)
+uint32_t nfnl_log_get_queue_threshold(const struct nfnl_log *log)
 {
-	return log->log_prefix;
+	return log->log_queue_threshold;
 }
 
-void nfnl_log_set_uid(struct nfnl_log *log, uint32_t uid)
+/* We don't actually use the flags for anything yet since the
+ * nfnetlog_log interface truly sucks - it only contains the
+ * flag value, but not mask, so we would have to make assumptions
+ * about the supported flags.
+ */
+void nfnl_log_set_flags(struct nfnl_log *log, unsigned int flags)
 {
-	log->log_uid = uid;
-	log->ce_mask |= LOG_ATTR_UID;
+	log->log_flags |= flags;
+	log->log_flag_mask |= flags;
 }
 
-int nfnl_log_test_uid(const struct nfnl_log *log)
+void nfnl_log_unset_flags(struct nfnl_log *log, unsigned int flags)
 {
-	return !!(log->ce_mask & LOG_ATTR_UID);
+	log->log_flags &= ~flags;
+	log->log_flag_mask |= flags;
 }
 
-uint32_t nfnl_log_get_uid(const struct nfnl_log *log)
-{
-	return log->log_uid;
-}
+static struct trans_tbl log_flags[] = {
+	__ADD(NFNL_LOG_FLAG_SEQ,	seq)
+	__ADD(NFNL_LOG_FLAG_SEQ_GLOBAL,	seq_global)
+};
 
-void nfnl_log_set_gid(struct nfnl_log *log, uint32_t gid)
+char *nfnl_log_flags2str(unsigned int flags, char *buf, size_t len)
 {
-	log->log_gid = gid;
-	log->ce_mask |= LOG_ATTR_GID;
+	return __flags2str(flags, buf, len, log_flags, ARRAY_SIZE(log_flags));
 }
 
-int nfnl_log_test_gid(const struct nfnl_log *log)
+unsigned int nfnl_log_str2flags(const char *name)
 {
-	return !!(log->ce_mask & LOG_ATTR_GID);
+	return __str2flags(name, log_flags, ARRAY_SIZE(log_flags));
 }
 
-uint32_t nfnl_log_get_gid(const struct nfnl_log *log)
+static int nfnl_log_compare(struct nl_object *_a, struct nl_object *_b,
+			    uint32_t attrs, int flags)
 {
-	return log->log_gid;
-}
-
+	struct nfnl_log *a = (struct nfnl_log *) _a;
+	struct nfnl_log *b = (struct nfnl_log *) _b;
+	int diff = 0;
 
-void nfnl_log_set_seq(struct nfnl_log *log, uint32_t seq)
-{
-	log->log_seq = seq;
-	log->ce_mask |= LOG_ATTR_SEQ;
-}
+#define NFNL_LOG_DIFF(ATTR, EXPR) \
+	ATTR_DIFF(attrs, LOG_ATTR_##ATTR, a, b, EXPR)
+#define NFNL_LOG_DIFF_VAL(ATTR, FIELD) \
+	NFNL_LOG_DIFF(ATTR, a->FIELD != b->FIELD)
 
-int nfnl_log_test_seq(const struct nfnl_log *log)
-{
-	return !!(log->ce_mask & LOG_ATTR_SEQ);
-}
+	diff |= NFNL_LOG_DIFF_VAL(GROUP,		log_group);
+	diff |= NFNL_LOG_DIFF_VAL(COPY_MODE,		log_copy_mode);
+	diff |= NFNL_LOG_DIFF_VAL(COPY_RANGE,		log_copy_range);
+	diff |= NFNL_LOG_DIFF_VAL(FLUSH_TIMEOUT,	log_flush_timeout);
+	diff |= NFNL_LOG_DIFF_VAL(ALLOC_SIZE,		log_alloc_size);
+	diff |= NFNL_LOG_DIFF_VAL(QUEUE_THRESHOLD,	log_queue_threshold);
 
-uint32_t nfnl_log_get_seq(const struct nfnl_log *log)
-{
-	return log->log_seq;
-}
+#undef NFNL_LOG_DIFF
+#undef NFNL_LOG_DIFF_VAL
 
-void nfnl_log_set_seq_global(struct nfnl_log *log, uint32_t seq_global)
-{
-	log->log_seq_global = seq_global;
-	log->ce_mask |= LOG_ATTR_SEQ_GLOBAL;
+	return diff;
 }
 
-int nfnl_log_test_seq_global(const struct nfnl_log *log)
-{
-	return !!(log->ce_mask & LOG_ATTR_SEQ_GLOBAL);
-}
+static struct trans_tbl nfnl_log_attrs[] = {
+	__ADD(LOG_ATTR_GROUP,		group)
+	__ADD(LOG_ATTR_COPY_MODE,	copy_mode)
+	__ADD(LOG_ATTR_COPY_RANGE,	copy_range)
+	__ADD(LOG_ATTR_FLUSH_TIMEOUT,	flush_timeout)
+	__ADD(LOG_ATTR_ALLOC_SIZE,	alloc_size)
+	__ADD(LOG_ATTR_QUEUE_THRESHOLD, queue_threshold)
+};
 
-uint32_t nfnl_log_get_seq_global(const struct nfnl_log *log)
+static char *nfnl_log_attrs2str(int attrs, char *buf, size_t len)
 {
-	return log->log_seq_global;
+	return __flags2str(attrs, buf, len, nfnl_log_attrs,
+			   ARRAY_SIZE(nfnl_log_attrs));
 }
 
 /** @} */
@@ -439,11 +274,12 @@ uint32_t nfnl_log_get_seq_global(const struct nfnl_log *log)
 struct nl_object_ops log_obj_ops = {
 	.oo_name		= "netfilter/log",
 	.oo_size		= sizeof(struct nfnl_log),
-	.oo_free_data		= log_free_data,
-	.oo_clone		= log_clone,
-	.oo_dump[NL_DUMP_BRIEF]	= log_dump,
-	.oo_dump[NL_DUMP_FULL]	= log_dump,
-	.oo_dump[NL_DUMP_STATS]	= log_dump,
+	.oo_dump[NL_DUMP_BRIEF]	= nfnl_log_dump,
+	.oo_dump[NL_DUMP_FULL]	= nfnl_log_dump,
+	.oo_dump[NL_DUMP_STATS]	= nfnl_log_dump,
+	.oo_compare		= nfnl_log_compare,
+	.oo_attrs2str		= nfnl_log_attrs2str,
+	.oo_id_attrs		= LOG_ATTR_GROUP,
 };
 
 /** @} */
diff --git a/src/nf-log.c b/src/nf-log.c
index 2c100f8..d1f0ed6 100644
--- a/src/nf-log.c
+++ b/src/nf-log.c
@@ -43,8 +43,11 @@ int main(int argc, char *argv[])
 	struct nl_handle *nfnlh;
 	struct nl_handle *rtnlh;
         struct nl_cache *link_cache;
+	struct nfnl_log *log;
+	enum nfnl_log_copy_mode copy_mode;
+	uint32_t copy_range;
 	int err = 1;
-	int family, group;
+	int family;
 
 	if (nltool_init(argc, argv) < 0)
 		return -1;
@@ -58,7 +61,8 @@ int main(int argc, char *argv[])
 	nl_socket_modify_cb(nfnlh, NL_CB_VALID, NL_CB_CUSTOM, event_input, NULL);
 
 	if ((argc > 1 && !strcasecmp(argv[1], "-h")) || argc < 3) {
-		printf("Usage: nf-log family group\n");
+		printf("Usage: nf-log family group [ copy_mode ] "
+		       "[copy_range] \n");
 		return 2;
 	}
 
@@ -72,26 +76,52 @@ int main(int argc, char *argv[])
 		fprintf(stderr, "Unknown family: %s\n", argv[1]);
 		goto errout;
 	}
-	if (nfnl_log_pf_unbind(nfnlh, family) < 0) {
-		fprintf(stderr, "%s\n", nl_geterror());
-		goto errout;
-	}
+
+	nfnl_log_pf_unbind(nfnlh, family);
 	if (nfnl_log_pf_bind(nfnlh, family) < 0) {
 		fprintf(stderr, "%s\n", nl_geterror());
 		goto errout;
 	}
 
-	group = nl_str2af(argv[2]);
-	if (nfnl_log_bind(nfnlh, group) < 0) {
+	log = nfnl_log_alloc();
+	if (log == NULL) {
 		fprintf(stderr, "%s\n", nl_geterror());
 		goto errout;
 	}
 
-	if (nfnl_log_set_mode(nfnlh, 0, NFULNL_COPY_PACKET, 0xffff) < 0) {
+	nfnl_log_set_group(log, atoi(argv[2]));
+
+	copy_mode = NFNL_LOG_COPY_META;
+	if (argc > 3) {
+		copy_mode = nfnl_log_str2copy_mode(argv[3]);
+		if (copy_mode < 0) {
+			fprintf(stderr, "%s\n", nl_geterror());
+			goto errout;
+		}
+	}
+	nfnl_log_set_copy_mode(log, copy_mode);
+
+	copy_range = 0xFFFF;
+	if (argc > 4)
+		copy_mode = atoi(argv[4]);
+	nfnl_log_set_copy_range(log, copy_range);
+
+	if (nfnl_log_create(nfnlh, log) <0) {
 		fprintf(stderr, "%s\n", nl_geterror());
 		goto errout;
 	}
 
+	{
+		struct nl_dump_params dp = {
+			.dp_type = NL_DUMP_STATS,
+			.dp_fd = stdout,
+			.dp_dump_msgtype = 1,
+		};
+
+		printf("log params: ");
+		nl_object_dump((struct nl_object *) log, &dp);
+	}
+
 	rtnlh = nltool_alloc_handle();
 	if (rtnlh == NULL) {
 		goto errout_close;
@@ -134,9 +164,16 @@ int main(int argc, char *argv[])
 		}
 	}
 
+	nl_cache_mngt_unprovide(link_cache);
+	nl_cache_free(link_cache);
+
+	nfnl_log_put(log);
+
 	nl_close(rtnlh);
+	nl_handle_destroy(rtnlh);
 errout_close:
 	nl_close(nfnlh);
+	nl_handle_destroy(nfnlh);
 errout:
 	return err;
 }
