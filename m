From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 46/64]: nf_log: constify struct nf_logger and nf_log_packet loginfo arg
Date: Tue, 18 Dec 2007 00:47:16 +0100 (MET)
Message-ID: <20071217234715.23601.6120.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39024 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760240AbXLQXrR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:47:17 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_log: constify struct nf_logger and nf_log_packet loginfo arg

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 31a70984a4c56f7141c77842bd4aa76835f4b1f1
tree c8eff1d8241016e522771f812bedbf820827b838
parent 976e0f77fc8fdb417e7d5526d5e0b2d97c64c74b
author Patrick McHardy <kaber@trash.net> Mon, 17 Dec 2007 14:58:36 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 18 Dec 2007 00:24:58 +0100

 include/net/netfilter/nf_log.h  |    6 +++---
 net/bridge/netfilter/ebt_log.c  |    2 +-
 net/bridge/netfilter/ebt_ulog.c |    2 +-
 net/ipv4/netfilter/ipt_LOG.c    |    2 +-
 net/ipv6/netfilter/ip6t_LOG.c   |    2 +-
 net/netfilter/nf_log.c          |   10 +++++-----
 net/netfilter/nfnetlink_log.c   |    2 +-
 7 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/include/net/netfilter/nf_log.h b/include/net/netfilter/nf_log.h
index f0426e5..037e824 100644
--- a/include/net/netfilter/nf_log.h
+++ b/include/net/netfilter/nf_log.h
@@ -43,8 +43,8 @@ struct nf_logger {
 };
 
 /* Function to register/unregister log function. */
-int nf_log_register(int pf, struct nf_logger *logger);
-void nf_log_unregister(struct nf_logger *logger);
+int nf_log_register(int pf, const struct nf_logger *logger);
+void nf_log_unregister(const struct nf_logger *logger);
 void nf_log_unregister_pf(int pf);
 
 /* Calls the registered backend logging function */
@@ -53,7 +53,7 @@ void nf_log_packet(int pf,
 		   const struct sk_buff *skb,
 		   const struct net_device *in,
 		   const struct net_device *out,
-		   struct nf_loginfo *li,
+		   const struct nf_loginfo *li,
 		   const char *fmt, ...);
 
 #endif /* _NF_LOG_H */
diff --git a/net/bridge/netfilter/ebt_log.c b/net/bridge/netfilter/ebt_log.c
index fcb3b54..3be9e98 100644
--- a/net/bridge/netfilter/ebt_log.c
+++ b/net/bridge/netfilter/ebt_log.c
@@ -183,7 +183,7 @@ static struct ebt_watcher log =
 	.me		= THIS_MODULE,
 };
 
-static struct nf_logger ebt_log_logger = {
+static const struct nf_logger ebt_log_logger = {
 	.name 		= "ebt_log",
 	.logfn		= &ebt_log_packet,
 	.me		= THIS_MODULE,
diff --git a/net/bridge/netfilter/ebt_ulog.c b/net/bridge/netfilter/ebt_ulog.c
index 1b9ca07..b73ba28 100644
--- a/net/bridge/netfilter/ebt_ulog.c
+++ b/net/bridge/netfilter/ebt_ulog.c
@@ -279,7 +279,7 @@ static struct ebt_watcher ulog = {
 	.me		= THIS_MODULE,
 };
 
-static struct nf_logger ebt_ulog_logger = {
+static const struct nf_logger ebt_ulog_logger = {
 	.name		= EBT_ULOG_WATCHER,
 	.logfn		= &ebt_log_packet,
 	.me		= THIS_MODULE,
diff --git a/net/ipv4/netfilter/ipt_LOG.c b/net/ipv4/netfilter/ipt_LOG.c
index 4b346e5..5acdddf 100644
--- a/net/ipv4/netfilter/ipt_LOG.c
+++ b/net/ipv4/netfilter/ipt_LOG.c
@@ -465,7 +465,7 @@ static struct xt_target log_tg_reg __read_mostly = {
 	.me		= THIS_MODULE,
 };
 
-static struct nf_logger ipt_log_logger ={
+static const struct nf_logger ipt_log_logger ={
 	.name		= "ipt_LOG",
 	.logfn		= &ipt_log_packet,
 	.me		= THIS_MODULE,
diff --git a/net/ipv6/netfilter/ip6t_LOG.c b/net/ipv6/netfilter/ip6t_LOG.c
index e6a2b1e..474c2b1 100644
--- a/net/ipv6/netfilter/ip6t_LOG.c
+++ b/net/ipv6/netfilter/ip6t_LOG.c
@@ -478,7 +478,7 @@ static struct xt_target log_tg6_reg __read_mostly = {
 	.me 		= THIS_MODULE,
 };
 
-static struct nf_logger ip6t_logger = {
+static const struct nf_logger ip6t_logger = {
 	.name		= "ip6t_LOG",
 	.logfn		= &ip6t_log_packet,
 	.me		= THIS_MODULE,
diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index fad97d6..ed9116d 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -15,12 +15,12 @@
 
 #define NF_LOG_PREFIXLEN		128
 
-static struct nf_logger *nf_loggers[NPROTO];
+static const struct nf_logger *nf_loggers[NPROTO] __read_mostly;
 static DEFINE_MUTEX(nf_log_mutex);
 
 /* return EBUSY if somebody else is registered, EEXIST if the same logger
  * is registred, 0 on success. */
-int nf_log_register(int pf, struct nf_logger *logger)
+int nf_log_register(int pf, const struct nf_logger *logger)
 {
 	int ret;
 
@@ -58,7 +58,7 @@ void nf_log_unregister_pf(int pf)
 }
 EXPORT_SYMBOL(nf_log_unregister_pf);
 
-void nf_log_unregister(struct nf_logger *logger)
+void nf_log_unregister(const struct nf_logger *logger)
 {
 	int i;
 
@@ -78,12 +78,12 @@ void nf_log_packet(int pf,
 		   const struct sk_buff *skb,
 		   const struct net_device *in,
 		   const struct net_device *out,
-		   struct nf_loginfo *loginfo,
+		   const struct nf_loginfo *loginfo,
 		   const char *fmt, ...)
 {
 	va_list args;
 	char prefix[NF_LOG_PREFIXLEN];
-	struct nf_logger *logger;
+	const struct nf_logger *logger;
 
 	rcu_read_lock();
 	logger = rcu_dereference(nf_loggers[pf]);
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 959a0cb..02e6357 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -726,7 +726,7 @@ nfulnl_recv_unsupp(struct sock *ctnl, struct sk_buff *skb,
 	return -ENOTSUPP;
 }
 
-static struct nf_logger nfulnl_logger = {
+static const struct nf_logger nfulnl_logger = {
 	.name	= "nfnetlink_log",
 	.logfn	= &nfulnl_log_packet,
 	.me	= THIS_MODULE,
