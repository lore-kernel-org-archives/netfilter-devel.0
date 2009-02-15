From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 1/4] netfilter: use a linked list of loggers.
Date: Sun, 15 Feb 2009 13:37:14 +0100
Message-ID: <1234701437-2754-1-git-send-email-eric@inl.fr>
References: <49980BA7.2040108@inl.fr>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@inl.fr>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:54393 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753122AbZBOMhW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 15 Feb 2009 07:37:22 -0500
In-Reply-To: <49980BA7.2040108@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch modifies nf_log to use a linked list of loggers for each
protocol. This list of loggers is read and write protected with a
mutex.
This patch separates registration and binding. To be used as
logging module, a module has to register calling nf_log_register()
and to bind to a protocol it has to call nf_log_bind_pf().
This patch also converts the logging modules to the new API. For nfnetlink_log,
it simply switchs call to register functions to call to bind function and
adds a call to nf_log_register() during init. For other modules, it just
remove a const flag from the logger structure and replace it with a
__read_mostly.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 include/net/netfilter/nf_log.h |   11 ++++-
 net/ipv4/netfilter/ipt_LOG.c   |    2 +-
 net/ipv4/netfilter/ipt_ULOG.c  |    2 +-
 net/ipv6/netfilter/ip6t_LOG.c  |    2 +-
 net/netfilter/nf_log.c         |   91 ++++++++++++++++++++++++++++++++-------
 net/netfilter/nfnetlink_log.c  |   11 ++++-
 6 files changed, 93 insertions(+), 26 deletions(-)

diff --git a/include/net/netfilter/nf_log.h b/include/net/netfilter/nf_log.h
index 7182c06..ccaa43a 100644
--- a/include/net/netfilter/nf_log.h
+++ b/include/net/netfilter/nf_log.h
@@ -1,6 +1,8 @@
 #ifndef _NF_LOG_H
 #define _NF_LOG_H
 
+#include <linux/netfilter.h>
+
 /* those NF_LOG_* defines and struct nf_loginfo are legacy definitios that will
  * disappear once iptables is replaced with pkttables.  Please DO NOT use them
  * for any new code! */
@@ -40,12 +42,15 @@ struct nf_logger {
 	struct module	*me;
 	nf_logfn 	*logfn;
 	char		*name;
+	struct list_head	list[NFPROTO_NUMPROTO];
 };
 
 /* Function to register/unregister log function. */
-int nf_log_register(u_int8_t pf, const struct nf_logger *logger);
-void nf_log_unregister(const struct nf_logger *logger);
-void nf_log_unregister_pf(u_int8_t pf);
+int nf_log_register(u_int8_t pf, struct nf_logger *logger);
+void nf_log_unregister(struct nf_logger *logger);
+
+int nf_log_bind_pf(u_int8_t pf, const struct nf_logger *logger);
+int nf_log_unbind_pf(u_int8_t pf);
 
 /* Calls the registered backend logging function */
 void nf_log_packet(u_int8_t pf,
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
diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index fa8ae5d..50d34db 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -16,31 +16,55 @@
 #define NF_LOG_PREFIXLEN		128
 
 static const struct nf_logger *nf_loggers[NFPROTO_NUMPROTO] __read_mostly;
+static struct list_head nf_loggers_l[NFPROTO_NUMPROTO] __read_mostly;
 static DEFINE_MUTEX(nf_log_mutex);
 
-/* return EBUSY if somebody else is registered, EEXIST if the same logger
- * is registred, 0 on success. */
-int nf_log_register(u_int8_t pf, const struct nf_logger *logger)
+static struct nf_logger *__find_logger(int pf, const char *str_logger)
+{
+	struct nf_logger *t;
+
+	list_for_each_entry(t, &nf_loggers_l[pf], list[pf])
+		if (!strnicmp(str_logger, t->name, strlen(t->name))) {
+			return t;
+		}
+
+	return NULL;
+}
+
+/* return EEXIST if the same logger is registred, 0 on success. */
+int nf_log_register(u_int8_t pf, struct nf_logger *logger)
 {
 	int ret;
+	const struct nf_logger *llog;
 
 	if (pf >= ARRAY_SIZE(nf_loggers))
 		return -EINVAL;
 
-	/* Any setup of logging members must be done before
-	 * substituting pointer. */
-	ret = mutex_lock_interruptible(&nf_log_mutex);
-	if (ret < 0)
-		return ret;
+	mutex_lock(&nf_log_mutex);
 
-	if (!nf_loggers[pf])
-		rcu_assign_pointer(nf_loggers[pf], logger);
-	else if (nf_loggers[pf] == logger)
-		ret = -EEXIST;
-	else
-		ret = -EBUSY;
+	ret = -EEXIST;
+	if (pf == NFPROTO_UNSPEC) {
+		int i;
+		for (i = NFPROTO_UNSPEC; i < NFPROTO_NUMPROTO; i++)
+			if (__find_logger(i, logger->name) == NULL) {
+				ret = 0;
+				list_add_tail(&(logger->list[i]),
+						&(nf_loggers_l[i]));
+			}
+	} else {
+		if (__find_logger(pf, logger->name) == NULL) {
+			ret = 0;
+			/* register at end of list to honor first register win */
+			list_add_tail(&(logger->list[pf]),
+					  &nf_loggers_l[pf]);
+			llog = rcu_dereference(nf_loggers[pf]);
+			if (llog == NULL)
+				rcu_assign_pointer(nf_loggers[pf], logger);
+		}
+	}
 
 	mutex_unlock(&nf_log_mutex);
+
 	return ret;
 }
 EXPORT_SYMBOL(nf_log_register);
@@ -58,14 +82,20 @@ void nf_log_unregister_pf(u_int8_t pf)
 }
 EXPORT_SYMBOL(nf_log_unregister_pf);
 
-void nf_log_unregister(const struct nf_logger *logger)
+void nf_log_unregister(struct nf_logger *logger)
 {
 	int i;
+	struct nf_logger *llog;
 
 	mutex_lock(&nf_log_mutex);
 	for (i = 0; i < ARRAY_SIZE(nf_loggers); i++) {
-		if (nf_loggers[i] == logger)
-			rcu_assign_pointer(nf_loggers[i], NULL);
+		llog = __find_logger(i, logger->name);
+		if (llog) {
+			const struct nf_logger *c_logger = rcu_dereference(nf_loggers[i]);
+			if (c_logger == llog)
+				rcu_assign_pointer(nf_loggers[i], NULL);
+			list_del(&(logger->list[i]));
+		}
 	}
 	mutex_unlock(&nf_log_mutex);
 
@@ -73,6 +103,28 @@ void nf_log_unregister(const struct nf_logger *logger)
 }
 EXPORT_SYMBOL(nf_log_unregister);
 
+int nf_log_bind_pf(u_int8_t pf, const struct nf_logger *logger)
+{
+	mutex_lock(&nf_log_mutex);
+	if (__find_logger(pf, logger->name) == NULL) {
+		mutex_unlock(&nf_log_mutex);
+		return -1;
+	}
+	rcu_assign_pointer(nf_loggers[pf], logger);
+	mutex_unlock(&nf_log_mutex);
+	return 0;
+}
+EXPORT_SYMBOL(nf_log_bind_pf);
+
+int nf_log_unbind_pf(u_int8_t pf)
+{
+	mutex_lock(&nf_log_mutex);
+	rcu_assign_pointer(nf_loggers[pf], NULL);
+	mutex_unlock(&nf_log_mutex);
+	return 0;
+}
+EXPORT_SYMBOL(nf_log_unbind_pf);
+
 void nf_log_packet(u_int8_t pf,
 		   unsigned int hooknum,
 		   const struct sk_buff *skb,
@@ -163,10 +215,15 @@ static const struct file_operations nflog_file_ops = {
 
 int __init netfilter_log_init(void)
 {
+	int i;
 #ifdef CONFIG_PROC_FS
 	if (!proc_create("nf_log", S_IRUGO,
 			 proc_net_netfilter, &nflog_file_ops))
 		return -1;
 #endif
+
+	for (i = NFPROTO_UNSPEC; i < NFPROTO_NUMPROTO; i++)
+		INIT_LIST_HEAD(&(nf_loggers_l[i]));
+
 	return 0;
 }
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index c712e9f..42e7de9 100644
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

