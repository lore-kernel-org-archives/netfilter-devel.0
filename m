From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 4/6] netfilter: convert logger modules to new API.
Date: Wed,  7 Jan 2009 21:05:32 +0100
Message-ID: <1231358734-20958-4-git-send-email-eric@inl.fr>
References: <1231312622.4137.7.camel@ice-age>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@inl.fr>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:42373 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753915AbZAGUFj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Jan 2009 15:05:39 -0500
In-Reply-To: <1231312622.4137.7.camel@ice-age>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch converts the logging modules to the new API. For nfnetlink_log,
it simply switchs call to register functions to call to bind function and
adds a call to nf_log_register() during init. For other modules, it just
remove a const flag from the logger structure.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 net/ipv4/netfilter/ipt_LOG.c  |    2 +-
 net/ipv6/netfilter/ip6t_LOG.c |    2 +-
 net/netfilter/nfnetlink_log.c |   11 ++++++++---
 3 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_LOG.c b/net/ipv4/netfilter/ipt_LOG.c
index 4614a69..6c94e4e 100644
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
diff --git a/net/ipv6/netfilter/ip6t_LOG.c b/net/ipv6/netfilter/ip6t_LOG.c
index 7c668c6..c80978e 100644
--- a/net/ipv6/netfilter/ip6t_LOG.c
+++ b/net/ipv6/netfilter/ip6t_LOG.c
@@ -477,7 +477,7 @@ static struct xt_target log_tg6_reg __read_mostly = {
 	.me 		= THIS_MODULE,
 };
 
-static const struct nf_logger ip6t_logger = {
+static struct nf_logger ip6t_logger = {
 	.name		= "ip6t_LOG",
 	.logfn		= &ip6t_log_packet,
 	.me		= THIS_MODULE,
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
1.6.1

