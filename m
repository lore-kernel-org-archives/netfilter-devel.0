From: Eric Leblond <eric@inl.fr>
Subject: [PATCH] Don't call nf_log_packet in NFLOG module.
Date: Mon,  6 Oct 2008 21:40:24 +0200
Message-ID: <1223322024-20336-1-git-send-email-eric@inl.fr>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@inl.fr>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:55847 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752333AbYJFTk1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Oct 2008 15:40:27 -0400
In-Reply-To: <>
References: <>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch modifies xt_NFLOG to suppress the call to nf_log_packet()
function. The call of this wrapper in xt_NFLOG was causing NFLOG to
use the first initialized module. Thus, if ipt_ULOG is loaded before
nfnetlink_log all NFLOG rules are treated as plain LOG rules.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 include/net/netfilter/nfnetlink_log.h |   13 +++++++++++++
 net/netfilter/nfnetlink_log.c         |    3 ++-
 net/netfilter/xt_NFLOG.c              |    5 +++--
 3 files changed, 18 insertions(+), 3 deletions(-)
 create mode 100644 include/net/netfilter/nfnetlink_log.h

diff --git a/include/net/netfilter/nfnetlink_log.h b/include/net/netfilter/nfnetlink_log.h
new file mode 100644
index 0000000..c920259
--- /dev/null
+++ b/include/net/netfilter/nfnetlink_log.h
@@ -0,0 +1,13 @@
+#ifndef _KER_NFNETLINK_LOG_H
+#define _KER_NFNETLINK_LOG_H
+
+void
+nfulnl_log_packet(unsigned int pf,
+		  unsigned int hooknum,
+		  const struct sk_buff *skb,
+		  const struct net_device *in,
+		  const struct net_device *out,
+		  const struct nf_loginfo *li_user,
+		  const char *prefix);
+
+#endif /* _KER_NFNETLINK_LOG_H */
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 9a35b57..494329a 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -533,7 +533,7 @@ static struct nf_loginfo default_loginfo = {
 };
 
 /* log handler for internal netfilter logging api */
-static void
+void
 nfulnl_log_packet(unsigned int pf,
 		  unsigned int hooknum,
 		  const struct sk_buff *skb,
@@ -648,6 +648,7 @@ alloc_failure:
 	/* FIXME: statistics */
 	goto unlock_and_release;
 }
+EXPORT_SYMBOL(nfulnl_log_packet);
 
 static int
 nfulnl_rcv_nl_event(struct notifier_block *this,
diff --git a/net/netfilter/xt_NFLOG.c b/net/netfilter/xt_NFLOG.c
index 19ae8ef..bb94aaa 100644
--- a/net/netfilter/xt_NFLOG.c
+++ b/net/netfilter/xt_NFLOG.c
@@ -13,6 +13,7 @@
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_NFLOG.h>
 #include <net/netfilter/nf_log.h>
+#include <net/netfilter/nfnetlink_log.h>
 
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
 MODULE_DESCRIPTION("Xtables: packet logging to netlink using NFLOG");
@@ -33,8 +34,8 @@ nflog_tg(struct sk_buff *skb, const struct net_device *in,
 	li.u.ulog.group	     = info->group;
 	li.u.ulog.qthreshold = info->threshold;
 
-	nf_log_packet(target->family, hooknum, skb, in, out, &li,
-		      "%s", info->prefix);
+	nfulnl_log_packet(target->family, hooknum, skb, in, out, &li,
+			  info->prefix);
 	return XT_CONTINUE;
 }
 
-- 
1.5.6.5

