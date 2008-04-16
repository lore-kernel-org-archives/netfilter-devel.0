From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 06/13] [NETFILTER]: Introduce NFPROTO_* constants
Date: Wed, 16 Apr 2008 17:30:58 +0200
Message-ID: <4eb3e643bba6b17a2c55c4b2c666edd050dee59b.1208359825.git.jengelh@computergmbh.de>
References: <1208359865-3022-1-git-send-email-jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38085 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760021AbYDPPbI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Apr 2008 11:31:08 -0400
In-Reply-To: <1208359865-3022-1-git-send-email-jengelh@computergmbh.de>
In-Reply-To: <540dfb29c6c573830cbde9bf579ddef33657ed20.1208359825.git.jengelh@computergmbh.de>
References: <540dfb29c6c573830cbde9bf579ddef33657ed20.1208359825.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The netfilter subsystem only supports a handful of protocols (much
less than PF_*) and even non-PF protocols like ARP and
pseudo-protocols like PF_BRIDGE. By creating NFPROTO_*, we can earn a
few memory savings on arrays that previously were always PF_MAX-sized
and keep the pseudo-protocols to ourselves.
---
 include/linux/netfilter.h |   13 +++++++++++--
 net/netfilter/core.c      |    6 +++---
 net/netfilter/nf_log.c    |   12 ++++++------
 net/netfilter/nf_queue.c  |   12 ++++++------
 net/netfilter/x_tables.c  |   18 ++++++++++--------
 5 files changed, 36 insertions(+), 25 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index dd4aebf..0eb42fc 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -52,6 +52,15 @@ enum nf_inet_hooks {
 	NF_INET_NUMHOOKS
 };
 
+enum {
+	NFPROTO_UNSPEC =  0,
+	NFPROTO_IPV4   =  2,
+	NFPROTO_ARP    =  3,
+	NFPROTO_BRIDGE =  7,
+	NFPROTO_IPV6   = 10,
+	NFPROTO_NUMPROTO,
+};
+
 union nf_inet_addr {
 	__u32		all[4];
 	__be32		ip;
@@ -138,7 +147,7 @@ extern struct ctl_path nf_net_netfilter_sysctl_path[];
 extern struct ctl_path nf_net_ipv4_netfilter_sysctl_path[];
 #endif /* CONFIG_SYSCTL */
 
-extern struct list_head nf_hooks[NPROTO][NF_MAX_HOOKS];
+extern struct list_head nf_hooks[NFPROTO_NUMPROTO][NF_MAX_HOOKS];
 
 int nf_hook_slow(u_int8_t pf, unsigned int hook, struct sk_buff *skb,
 		 struct net_device *indev, struct net_device *outdev,
@@ -247,7 +256,7 @@ struct nf_afinfo {
 	int		route_key_size;
 };
 
-extern const struct nf_afinfo *nf_afinfo[NPROTO];
+extern const struct nf_afinfo *nf_afinfo[NFPROTO_NUMPROTO];
 static inline const struct nf_afinfo *nf_get_afinfo(unsigned short family)
 {
 	return rcu_dereference(nf_afinfo[family]);
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 26b8f48..b16cd79 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -26,7 +26,7 @@
 
 static DEFINE_MUTEX(afinfo_mutex);
 
-const struct nf_afinfo *nf_afinfo[NPROTO] __read_mostly;
+const struct nf_afinfo *nf_afinfo[NFPROTO_NUMPROTO] __read_mostly;
 EXPORT_SYMBOL(nf_afinfo);
 
 int nf_register_afinfo(const struct nf_afinfo *afinfo)
@@ -51,7 +51,7 @@ void nf_unregister_afinfo(const struct nf_afinfo *afinfo)
 }
 EXPORT_SYMBOL_GPL(nf_unregister_afinfo);
 
-struct list_head nf_hooks[NPROTO][NF_MAX_HOOKS] __read_mostly;
+struct list_head nf_hooks[NFPROTO_NUMPROTO][NF_MAX_HOOKS] __read_mostly;
 EXPORT_SYMBOL(nf_hooks);
 static DEFINE_MUTEX(nf_hook_mutex);
 
@@ -264,7 +264,7 @@ EXPORT_SYMBOL(proc_net_netfilter);
 void __init netfilter_init(void)
 {
 	int i, h;
-	for (i = 0; i < NPROTO; i++) {
+	for (i = 0; i < ARRAY_SIZE(nf_hooks); i++) {
 		for (h = 0; h < NF_MAX_HOOKS; h++)
 			INIT_LIST_HEAD(&nf_hooks[i][h]);
 	}
diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index 0dca036..af55460 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -15,7 +15,7 @@
 
 #define NF_LOG_PREFIXLEN		128
 
-static const struct nf_logger *nf_loggers[NPROTO] __read_mostly;
+static const struct nf_logger *nf_loggers[NFPROTO_NUMPROTO] __read_mostly;
 static DEFINE_MUTEX(nf_log_mutex);
 
 /* return EBUSY if somebody else is registered, EEXIST if the same logger
@@ -24,7 +24,7 @@ int nf_log_register(u_int8_t pf, const struct nf_logger *logger)
 {
 	int ret;
 
-	if (pf >= NPROTO)
+	if (pf >= ARRAY_SIZE(nf_loggers))
 		return -EINVAL;
 
 	/* Any setup of logging members must be done before
@@ -47,7 +47,7 @@ EXPORT_SYMBOL(nf_log_register);
 
 void nf_log_unregister_pf(u_int8_t pf)
 {
-	if (pf >= NPROTO)
+	if (pf >= ARRAY_SIZE(nf_loggers))
 		return;
 	mutex_lock(&nf_log_mutex);
 	rcu_assign_pointer(nf_loggers[pf], NULL);
@@ -63,7 +63,7 @@ void nf_log_unregister(const struct nf_logger *logger)
 	int i;
 
 	mutex_lock(&nf_log_mutex);
-	for (i = 0; i < NPROTO; i++) {
+	for (i = 0; i < ARRAY_SIZE(nf_loggers); i++) {
 		if (nf_loggers[i] == logger)
 			rcu_assign_pointer(nf_loggers[i], NULL);
 	}
@@ -107,7 +107,7 @@ static void *seq_start(struct seq_file *seq, loff_t *pos)
 {
 	rcu_read_lock();
 
-	if (*pos >= NPROTO)
+	if (*pos >= ARRAY_SIZE(nf_loggers))
 		return NULL;
 
 	return pos;
@@ -117,7 +117,7 @@ static void *seq_next(struct seq_file *s, void *v, loff_t *pos)
 {
 	(*pos)++;
 
-	if (*pos >= NPROTO)
+	if (*pos >= ARRAY_SIZE(nf_loggers))
 		return NULL;
 
 	return pos;
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 863ac60..9fe984d 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -16,7 +16,7 @@
  * long term mutex.  The handler must provide an an outfn() to accept packets
  * for queueing and must reinject all packets it receives, no matter what.
  */
-static const struct nf_queue_handler *queue_handler[NPROTO];
+static const struct nf_queue_handler *queue_handler[NFPROTO_NUMPROTO] __read_mostly;
 
 static DEFINE_MUTEX(queue_handler_mutex);
 
@@ -26,7 +26,7 @@ int nf_register_queue_handler(u_int8_t pf, const struct nf_queue_handler *qh)
 {
 	int ret;
 
-	if (pf >= NPROTO)
+	if (pf >= ARRAY_SIZE(queue_handler))
 		return -EINVAL;
 
 	mutex_lock(&queue_handler_mutex);
@@ -47,7 +47,7 @@ EXPORT_SYMBOL(nf_register_queue_handler);
 /* The caller must flush their queue before this */
 int nf_unregister_queue_handler(u_int8_t pf, const struct nf_queue_handler *qh)
 {
-	if (pf >= NPROTO)
+	if (pf >= ARRAY_SIZE(queue_handler))
 		return -EINVAL;
 
 	mutex_lock(&queue_handler_mutex);
@@ -70,7 +70,7 @@ void nf_unregister_queue_handlers(const struct nf_queue_handler *qh)
 	u_int8_t pf;
 
 	mutex_lock(&queue_handler_mutex);
-	for (pf = 0; pf < NPROTO; pf++)  {
+	for (pf = 0; pf < ARRAY_SIZE(queue_handler); pf++)  {
 		if (queue_handler[pf] == qh)
 			rcu_assign_pointer(queue_handler[pf], NULL);
 	}
@@ -285,7 +285,7 @@ EXPORT_SYMBOL(nf_reinject);
 #ifdef CONFIG_PROC_FS
 static void *seq_start(struct seq_file *seq, loff_t *pos)
 {
-	if (*pos >= NPROTO)
+	if (*pos >= ARRAY_SIZE(queue_handler))
 		return NULL;
 
 	return pos;
@@ -295,7 +295,7 @@ static void *seq_next(struct seq_file *s, void *v, loff_t *pos)
 {
 	(*pos)++;
 
-	if (*pos >= NPROTO)
+	if (*pos >= ARRAY_SIZE(queue_handler))
 		return NULL;
 
 	return pos;
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 027cbd4..f44bcc3 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -58,10 +58,12 @@ static struct xt_af *xt;
 #define duprintf(format, args...)
 #endif
 
-static const char *const xt_prefix[NPROTO] = {
-	[AF_INET]	= "ip",
-	[AF_INET6]	= "ip6",
-	[NF_ARP]	= "arp",
+static const char *const xt_prefix[NFPROTO_NUMPROTO] = {
+	[NFPROTO_UNSPEC] = "x",
+	[NFPROTO_IPV4]   = "ip",
+	[NFPROTO_ARP]    = "arp",
+	[NFPROTO_BRIDGE] = "eb",
+	[NFPROTO_IPV6]   = "ip6",
 };
 
 /* Registration hooks for targets. */
@@ -933,7 +935,7 @@ int xt_proto_init(struct net *net, u_int8_t af)
 	struct proc_dir_entry *proc;
 #endif
 
-	if (af >= NPROTO)
+	if (af >= ARRAY_SIZE(xt_prefix))
 		return -EINVAL;
 
 
@@ -1003,7 +1005,7 @@ static int __net_init xt_net_init(struct net *net)
 {
 	int i;
 
-	for (i = 0; i < NPROTO; i++)
+	for (i = 0; i < NFPROTO_NUMPROTO; i++)
 		INIT_LIST_HEAD(&net->xt.tables[i]);
 	return 0;
 }
@@ -1016,11 +1018,11 @@ static int __init xt_init(void)
 {
 	int i, rv;
 
-	xt = kmalloc(sizeof(struct xt_af) * NPROTO, GFP_KERNEL);
+	xt = kmalloc(sizeof(struct xt_af) * NFPROTO_NUMPROTO, GFP_KERNEL);
 	if (!xt)
 		return -ENOMEM;
 
-	for (i = 0; i < NPROTO; i++) {
+	for (i = 0; i < NFPROTO_NUMPROTO; i++) {
 		mutex_init(&xt[i].mutex);
 #ifdef CONFIG_COMPAT
 		mutex_init(&xt[i].compat_mutex);
-- 
1.5.5

