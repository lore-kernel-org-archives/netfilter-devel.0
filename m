From: Taehee Yoo <ap420073@gmail.com>
Subject: [PATCH] netfilter: xt_NFLOG: use nf_log_packet instead of nfulnl_log_packet.
Date: Wed,  9 Aug 2017 16:59:49 +0900
Message-ID: <20170809075949.28553-1-ap420073@gmail.com>
Cc: ap420073@gmail.com
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:36067 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750879AbdHIIAi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Aug 2017 04:00:38 -0400
Received: by mail-pg0-f66.google.com with SMTP id y129so5263279pgy.3
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Aug 2017 01:00:38 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The nfulnl_log_packet() is added to make sure that the NFLOG target
works as only user-space logger. but now, nf_log_packet() can find proper
log function using NF_LOG_TYPE_ULOG and NF_LOG_TYPE_LOG.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 include/net/netfilter/nfnetlink_log.h | 17 -----------------
 net/netfilter/nfnetlink_log.c         |  8 +++-----
 net/netfilter/xt_NFLOG.c              | 15 +++++++++++----
 3 files changed, 14 insertions(+), 26 deletions(-)
 delete mode 100644 include/net/netfilter/nfnetlink_log.h

diff --git a/include/net/netfilter/nfnetlink_log.h b/include/net/netfilter/nfnetlink_log.h
deleted file mode 100644
index 5ca3f14..0000000
--- a/include/net/netfilter/nfnetlink_log.h
+++ /dev/null
@@ -1,17 +0,0 @@
-#ifndef _KER_NFNETLINK_LOG_H
-#define _KER_NFNETLINK_LOG_H
-
-void
-nfulnl_log_packet(struct net *net,
-		  u_int8_t pf,
-		  unsigned int hooknum,
-		  const struct sk_buff *skb,
-		  const struct net_device *in,
-		  const struct net_device *out,
-		  const struct nf_loginfo *li_user,
-		  const char *prefix);
-
-#define NFULNL_COPY_DISABLED    0xff
-
-#endif /* _KER_NFNETLINK_LOG_H */
-
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index c684ba9..0ea69fc 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -37,7 +37,6 @@
 #include <net/sock.h>
 #include <net/netfilter/nf_log.h>
 #include <net/netns/generic.h>
-#include <net/netfilter/nfnetlink_log.h>
 
 #include <linux/atomic.h>
 #include <linux/refcount.h>
@@ -47,6 +46,7 @@
 #include "../bridge/br_private.h"
 #endif
 
+#define NFULNL_COPY_DISABLED	0xff
 #define NFULNL_NLBUFSIZ_DEFAULT	NLMSG_GOODSIZE
 #define NFULNL_TIMEOUT_DEFAULT 	100	/* every second */
 #define NFULNL_QTHRESH_DEFAULT 	100	/* 100 packets */
@@ -618,7 +618,7 @@ static struct nf_loginfo default_loginfo = {
 };
 
 /* log handler for internal netfilter logging api */
-void
+static void
 nfulnl_log_packet(struct net *net,
 		  u_int8_t pf,
 		  unsigned int hooknum,
@@ -633,7 +633,7 @@ nfulnl_log_packet(struct net *net,
 	struct nfulnl_instance *inst;
 	const struct nf_loginfo *li;
 	unsigned int qthreshold;
-	unsigned int plen;
+	unsigned int plen = 0;
 	struct nfnl_log_net *log = nfnl_log_pernet(net);
 	const struct nfnl_ct_hook *nfnl_ct = NULL;
 	struct nf_conn *ct = NULL;
@@ -648,7 +648,6 @@ nfulnl_log_packet(struct net *net,
 	if (!inst)
 		return;
 
-	plen = 0;
 	if (prefix)
 		plen = strlen(prefix) + 1;
 
@@ -760,7 +759,6 @@ nfulnl_log_packet(struct net *net,
 	/* FIXME: statistics */
 	goto unlock_and_release;
 }
-EXPORT_SYMBOL_GPL(nfulnl_log_packet);
 
 static int
 nfulnl_rcv_nl_event(struct notifier_block *this,
diff --git a/net/netfilter/xt_NFLOG.c b/net/netfilter/xt_NFLOG.c
index c7f8958..1ed0cac 100644
--- a/net/netfilter/xt_NFLOG.c
+++ b/net/netfilter/xt_NFLOG.c
@@ -13,7 +13,6 @@
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_NFLOG.h>
 #include <net/netfilter/nf_log.h>
-#include <net/netfilter/nfnetlink_log.h>
 
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
 MODULE_DESCRIPTION("Xtables: packet logging to netlink using NFLOG");
@@ -37,8 +36,9 @@ nflog_tg(struct sk_buff *skb, const struct xt_action_param *par)
 	if (info->flags & XT_NFLOG_F_COPY_LEN)
 		li.u.ulog.flags |= NF_LOG_F_COPY_LEN;
 
-	nfulnl_log_packet(net, xt_family(par), xt_hooknum(par), skb,
-			  xt_in(par), xt_out(par), &li, info->prefix);
+	nf_log_packet(net, xt_family(par), xt_hooknum(par), skb, xt_in(par),
+		      xt_out(par), &li, "%s", info->prefix);
+
 	return XT_CONTINUE;
 }
 
@@ -50,7 +50,13 @@ static int nflog_tg_check(const struct xt_tgchk_param *par)
 		return -EINVAL;
 	if (info->prefix[sizeof(info->prefix) - 1] != '\0')
 		return -EINVAL;
-	return 0;
+
+	return nf_logger_find_get(par->family, NF_LOG_TYPE_ULOG);
+}
+
+static void nflog_tg_destroy(const struct xt_tgdtor_param *par)
+{
+	nf_logger_put(par->family, NF_LOG_TYPE_ULOG);
 }
 
 static struct xt_target nflog_tg_reg __read_mostly = {
@@ -58,6 +64,7 @@ static struct xt_target nflog_tg_reg __read_mostly = {
 	.revision   = 0,
 	.family     = NFPROTO_UNSPEC,
 	.checkentry = nflog_tg_check,
+	.destroy    = nflog_tg_destroy,
 	.target     = nflog_tg,
 	.targetsize = sizeof(struct xt_nflog_info),
 	.me         = THIS_MODULE,
-- 
2.9.3

