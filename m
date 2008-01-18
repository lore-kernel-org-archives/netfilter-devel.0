From: Patrick McHardy <kaber@trash.net>
Subject: [LIBNL 06/09]: nfnetlink_log: support NUFLA_GID attribute
Date: Fri, 18 Jan 2008 17:55:55 +0100 (MET)
Message-ID: <20080118165522.13385.72025.sendpatchset@localhost.localdomain>
References: <20080118165514.13385.44695.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	philipc@snapgear.com
To: tgraf@suug.ch
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42976 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762333AbYARQz4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Jan 2008 11:55:56 -0500
In-Reply-To: <20080118165514.13385.44695.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 2c2e8051726fb34980d1e7b72c15d0a6eba4cfc0
Author: Patrick McHardy <kaber@trash.net>
Date:   Fri Jan 18 17:44:52 2008 +0100

    [LIBNL]: nfnetlink_log: support NUFLA_GID attribute
    
    The NUFLA_GID attribute (currently only in net-2.6.25) contains the
    gid of the sending process for locally generated packets.
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/include/linux/netfilter/nfnetlink_log.h b/include/linux/netfilter/nfnetlink_log.h
index 2de5df9..38fafc1 100644
--- a/include/linux/netfilter/nfnetlink_log.h
+++ b/include/linux/netfilter/nfnetlink_log.h
@@ -51,6 +51,7 @@ enum nfulnl_attr_type {
 	NFULA_UID,			/* user id of socket */
 	NFULA_SEQ,			/* instance-local sequence number */
 	NFULA_SEQ_GLOBAL,		/* global sequence number */
+	NFULA_GID,			/* group id of socket */
 
 	__NFULA_MAX
 };
diff --git a/include/netlink-types.h b/include/netlink-types.h
index f7bddca..cbf903e 100644
--- a/include/netlink-types.h
+++ b/include/netlink-types.h
@@ -751,6 +751,7 @@ struct nfnl_log {
 	int			log_payload_len;
 	char *			log_prefix;
 	uint32_t		log_uid;
+	uint32_t		log_gid;
 	uint32_t		log_seq;
 	uint32_t		log_seq_global;
 };
diff --git a/include/netlink/netfilter/log.h b/include/netlink/netfilter/log.h
index e65cc58..817de2d 100644
--- a/include/netlink/netfilter/log.h
+++ b/include/netlink/netfilter/log.h
@@ -89,6 +89,10 @@ extern void		nfnl_log_set_uid(struct nfnl_log *, uint32_t);
 extern int		nfnl_log_test_uid(const struct nfnl_log *);
 extern uint32_t		nfnl_log_get_uid(const struct nfnl_log *);
 
+extern void		nfnl_log_set_gid(struct nfnl_log *, uint32_t);
+extern int		nfnl_log_test_gid(const struct nfnl_log *);
+extern uint32_t		nfnl_log_get_gid(const struct nfnl_log *);
+
 extern void		nfnl_log_set_seq(struct nfnl_log *, uint32_t);
 extern int		nfnl_log_test_seq(const struct nfnl_log *);
 extern uint32_t		nfnl_log_get_seq(const struct nfnl_log *);
diff --git a/lib/netfilter/log.c b/lib/netfilter/log.c
index a900927..8d70e7f 100644
--- a/lib/netfilter/log.c
+++ b/lib/netfilter/log.c
@@ -58,6 +58,7 @@ static struct nla_policy log_policy[NFULA_MAX+1] = {
 	//[NFULA_PAYLOAD]
 	[NFULA_PREFIX]			= { .type = NLA_STRING, },
 	[NFULA_UID]			= { .type = NLA_U32 },
+	[NFULA_GID]			= { .type = NLA_U32 },
 	[NFULA_SEQ]			= { .type = NLA_U32 },
 	[NFULA_SEQ_GLOBAL]		= { .type = NLA_U32 },
 };
@@ -146,6 +147,10 @@ struct nfnl_log *nfnlmsg_log_parse(struct nlmsghdr *nlh)
 	if (attr)
 		nfnl_log_set_uid(log, ntohl(nla_get_u32(attr)));
 
+	attr = tb[NFULA_GID];
+	if (attr)
+		nfnl_log_set_gid(log, ntohl(nla_get_u32(attr)));
+
 	attr = tb[NFULA_SEQ];
 	if (attr)
 		nfnl_log_set_seq(log, ntohl(nla_get_u32(attr)));
diff --git a/lib/netfilter/log_obj.c b/lib/netfilter/log_obj.c
index c3adc51..0e4411e 100644
--- a/lib/netfilter/log_obj.c
+++ b/lib/netfilter/log_obj.c
@@ -29,8 +29,9 @@
 #define LOG_ATTR_PAYLOAD		(1UL << 10)
 #define LOG_ATTR_PREFIX			(1UL << 11)
 #define LOG_ATTR_UID			(1UL << 12)
-#define LOG_ATTR_SEQ			(1UL << 13)
-#define LOG_ATTR_SEQ_GLOBAL		(1UL << 14)
+#define LOG_ATTR_GID			(1UL << 13)
+#define LOG_ATTR_SEQ			(1UL << 14)
+#define LOG_ATTR_SEQ_GLOBAL		(1UL << 15)
 /** @endcond */
 
 static void log_free_data(struct nl_object *c)
@@ -144,6 +145,12 @@ static int log_dump(struct nl_object *a, struct nl_dump_params *p)
 	if (log->ce_mask & LOG_ATTR_PAYLOAD)
 		dp_dump(p, "PAYLOADLEN=%d ", log->log_payload_len);
 
+	if (log->ce_mask & LOG_ATTR_UID)
+		dp_dump(p, "UID=%u ", log->log_uid);
+
+	if (log->ce_mask & LOG_ATTR_GID)
+		dp_dump(p, "GID=%u ", log->log_gid);
+
 	if (log->ce_mask & LOG_ATTR_SEQ)
 		dp_dump(p, "SEQ=%d ", log->log_seq);
 
@@ -378,6 +385,23 @@ uint32_t nfnl_log_get_uid(const struct nfnl_log *log)
 	return log->log_uid;
 }
 
+void nfnl_log_set_gid(struct nfnl_log *log, uint32_t gid)
+{
+	log->log_gid = gid;
+	log->ce_mask |= LOG_ATTR_GID;
+}
+
+int nfnl_log_test_gid(const struct nfnl_log *log)
+{
+	return !!(log->ce_mask & LOG_ATTR_GID);
+}
+
+uint32_t nfnl_log_get_gid(const struct nfnl_log *log)
+{
+	return log->log_gid;
+}
+
+
 void nfnl_log_set_seq(struct nfnl_log *log, uint32_t seq)
 {
 	log->log_seq = seq;
