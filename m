From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 4/7] netfilter: convert logger modules to new API.
Date: Mon,  9 Feb 2009 22:11:13 +0100
Message-ID: <1234213876-8176-4-git-send-email-eric@inl.fr>
References: <49909B3E.0@inl.fr>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@inl.fr>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:36905 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753707AbZBIVLW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2009 16:11:22 -0500
In-Reply-To: <49909B3E.0@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch converts the logging modules to the new API. For nfnetlink_log,
it simply switchs call to register functions to call to bind function and
adds a call to nf_log_register() during init. For other modules, it just
remove a const flag from the logger structure and replace it with a
__read_mostly.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 net/ipv4/netfilter/ipt_LOG.c  |    2 +-
 net/ipv4/netfilter/ipt_ULOG.c |    2 +-
 net/ipv6/netfilter/ip6t_LOG.c |    2 +-
 net/netfilter/nfnetlink_log.c |   11 ++++++++---
 4 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_LOG.c b/net/ipv4/netfilter/ipt_LOG.c
index 27a78fb..acc44c6 100644
--- a/net/ipv4/netfilter/ipt_LOG.c
+++ b/net/ipv4/netfilter/ipt_LOG.c
@@ -464,7 +464,7 @@ static struct xt_target log_tg_reg __read_mostly = {
 	.me		= THIS_MODULE,
 };
 
-static const struct nf_logger ipt_log_logger ={
+static struct nf_logger ipt_log_logger __read_mostly = {
 	.name		= "ipt_LOG",
 	.logfn		= &ipt_log_packet,
 	.me		= THIS_MODULE,
diff --git a/net/ipv4/netfilter/ipt_ULOG.c b/net/ipv4/netfilter/ipt_ULOG.c
index 18a2826..d32cc4b 100644
--- a/net/ipv4/netfilter/ipt_ULOG.c
+++ b/net/ipv4/netfilter/ipt_ULOG.c
@@ -379,7 +379,7 @@ static struct xt_target ulog_tg_reg __read_mostly = {
 	.me		= THIS_MODULE,
 };
 
-static struct nf_logger ipt_ulog_logger = {
+static struct nf_logger ipt_ulog_logger __read_mostly = {
 	.name		= "ipt_ULOG",
 	.logfn		= ipt_logfn,
 	.me		= THIS_MODULE,
diff --git a/net/ipv6/netfilter/ip6t_LOG.c b/net/ipv6/netfilter/ip6t_LOG.c
index 37adf5a..7018cac 100644
--- a/net/ipv6/netfilter/ip6t_LOG.c
+++ b/net/ipv6/netfilter/ip6t_LOG.c
@@ -477,7 +477,7 @@ static struct xt_target log_tg6_reg __read_mostly = {
 	.me 		= THIS_MODULE,
 };
 
-static const struct nf_logger ip6t_logger = {
+static struct nf_logger ip6t_logger __read_mostly = {
 	.name		= "ip6t_LOG",
 	.logfn		= &ip6t_log_packet,
 	.me		= THIS_MODULE,
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 580b837..88b455e 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -693,7 +693,7 @@ nfulnl_recv_unsupp(struct sock *ctnl, struct sk_buff *skb,
 	return -ENOTSUPP;
 }
 
-static const struct nf_logger nfulnl_logger = {
+static struct nf_logger nfulnl_logger __read_mostly = {
 	.name	= "nfnetlink_log",
 	.logfn	= &nfulnl_log_packet,
 	.me	= THIS_MODULE,
@@ -725,9 +725,9 @@ nfulnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 		/* Commands without queue context */
 		switch (cmd->command) {
 		case NFULNL_CFG_CMD_PF_BIND:
-			return nf_log_register(pf, &nfulnl_logger);
+			return nf_log_bind_pf(pf, &nfulnl_logger);
 		case NFULNL_CFG_CMD_PF_UNBIND:
-			nf_log_unregister_pf(pf);
+			nf_log_unbind_pf(pf);
 			return 0;
 		}
 	}
@@ -952,6 +952,11 @@ static int __init nfnetlink_log_init(void)
 		goto cleanup_netlink_notifier;
 	}
 
+	if ((status = nf_log_register(NFPROTO_UNSPEC, &nfulnl_logger)) < 0) {
+		printk(KERN_ERR "log: failed to register logger\n");
+		goto cleanup_netlink_notifier;
+	}
+
 #ifdef CONFIG_PROC_FS
 	if (!proc_create("nfnetlink_log", 0440,
 			 proc_net_netfilter, &nful_file_ops))
-- 
1.5.6.3

