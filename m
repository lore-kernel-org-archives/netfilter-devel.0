From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 06/51] netfilter: xt_NFLOG: use nf_log_packet instead of nfulnl_log_packet.
Date: Mon,  7 May 2018 00:46:24 +0200
Message-ID: <20180506224709.29100-7-pablo@netfilter.org>
References: <20180506224709.29100-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180506224709.29100-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

The nfulnl_log_packet() is added to make sure that the NFLOG target
works as only user-space logger. but now, nf_log_packet() can find proper
log function using NF_LOG_TYPE_ULOG and NF_LOG_TYPE_LOG.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nfnetlink_log.h | 17 -----------------
 net/netfilter/nfnetlink_log.c         |  8 +++-----
 net/netfilter/xt_NFLOG.c              | 15 +++++++++++----
 3 files changed, 14 insertions(+), 26 deletions(-)

diff --git a/include/net/netfilter/nfnetlink_log.h b/include/net/netfilter/nfnetlink_log.h
index 612cfb63ac68..ea32a7d3cf1b 100644
--- a/include/net/netfilter/nfnetlink_log.h
+++ b/include/net/netfilter/nfnetlink_log.h
@@ -1,18 +1 @@
 /* SPDX-License-Identifier: GPL-2.0 */
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
index 7b46aa4c478d..e5cc4d9b9ce7 100644
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
@@ -618,7 +618,7 @@ static const struct nf_loginfo default_loginfo = {
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
index c7f8958cea4a..1ed0cac585c4 100644
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
2.11.0
