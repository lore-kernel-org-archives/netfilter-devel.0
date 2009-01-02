From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 3/5] netfilter: convert logger modules to new API.
Date: Fri,  2 Jan 2009 18:07:33 +0100
Message-ID: <1230916055-15448-3-git-send-email-eric@inl.fr>
References: <1230915875.28326.87.camel@ice-age>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@inl.fr>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:49072 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757282AbZABRHp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 Jan 2009 12:07:45 -0500
In-Reply-To: <1230915875.28326.87.camel@ice-age>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch converts the logging modules to the new API. For all modules
but nfnetlink_log the only change is a call to nf_log_register() and
nf_log_bind_pf instead of a simple call of nf_log_register(). For nfnetlink_log,
the patch simply switchs call to register functions to call to bind function
and adds a call to nflog_register during init. Backward compatibility
should be preserved by this patch.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 net/ipv4/netfilter/ipt_LOG.c  |    4 +++-
 net/ipv4/netfilter/ipt_ULOG.c |    4 +++-
 net/ipv6/netfilter/ip6t_LOG.c |    1 +
 net/netfilter/nfnetlink_log.c |   11 ++++++++---
 4 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_LOG.c b/net/ipv4/netfilter/ipt_LOG.c
index 4614a69..f1f0338 100644
--- a/net/ipv4/netfilter/ipt_LOG.c
+++ b/net/ipv4/netfilter/ipt_LOG.c
@@ -464,7 +464,7 @@ static struct xt_target log_tg_reg __read_mostly = {
 	.me		= THIS_MODULE,
 };
 
-static const struct nf_logger ipt_log_logger ={
+static struct nf_logger ipt_log_logger ={
 	.name		= "ipt_LOG",
 	.logfn		= &ipt_log_packet,
 	.me		= THIS_MODULE,
@@ -477,7 +477,9 @@ static int __init log_tg_init(void)
 	ret = xt_register_target(&log_tg_reg);
 	if (ret < 0)
 		return ret;
+
 	nf_log_register(NFPROTO_IPV4, &ipt_log_logger);
+	nf_log_bind_pf(NFPROTO_IPV4, &ipt_log_logger);
 	return 0;
 }
 
diff --git a/net/ipv4/netfilter/ipt_ULOG.c b/net/ipv4/netfilter/ipt_ULOG.c
index 18a2826..b895b65 100644
--- a/net/ipv4/netfilter/ipt_ULOG.c
+++ b/net/ipv4/netfilter/ipt_ULOG.c
@@ -411,8 +411,10 @@ static int __init ulog_tg_init(void)
 		netlink_kernel_release(nflognl);
 		return ret;
 	}
-	if (nflog)
+	if (nflog) {
 		nf_log_register(NFPROTO_IPV4, &ipt_ulog_logger);
+		nf_log_bind_pf(NFPROTO_IPV4, &ipt_ulog_logger);
+	}
 
 	return 0;
 }
diff --git a/net/ipv6/netfilter/ip6t_LOG.c b/net/ipv6/netfilter/ip6t_LOG.c
index 7c668c6..64042b3 100644
--- a/net/ipv6/netfilter/ip6t_LOG.c
+++ b/net/ipv6/netfilter/ip6t_LOG.c
@@ -491,6 +491,7 @@ static int __init log_tg6_init(void)
 	if (ret < 0)
 		return ret;
 	nf_log_register(NFPROTO_IPV6, &ip6t_logger);
+	nf_log_bind_pf(NFPROTO_IPV6, &ip6t_logger);
 	return 0;
 }
 
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 2770b4e..c18b809 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -690,7 +690,7 @@ nfulnl_recv_unsupp(struct sock *ctnl, struct sk_buff *skb,
 	return -ENOTSUPP;
 }
 
-static const struct nf_logger nfulnl_logger = {
+static struct nf_logger nfulnl_logger = {
 	.name	= "nfnetlink_log",
 	.logfn	= &nfulnl_log_packet,
 	.me	= THIS_MODULE,
@@ -722,9 +722,9 @@ nfulnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
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
@@ -949,6 +949,11 @@ static int __init nfnetlink_log_init(void)
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

