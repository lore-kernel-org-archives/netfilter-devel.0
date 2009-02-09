From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 1/7] netfilter: use a linked list of loggers.
Date: Mon,  9 Feb 2009 22:11:10 +0100
Message-ID: <1234213876-8176-1-git-send-email-eric@inl.fr>
References: <49909B3E.0@inl.fr>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@inl.fr>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:36901 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753696AbZBIVLX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2009 16:11:23 -0500
In-Reply-To: <49909B3E.0@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch modifies nf_log to use a linked list of loggers for each
protocol. It also separate registration and binding. To be used as
logging module, a module has to register calling nf_log_register()
and to bind to a protocol it has to call nf_log_bind_pf().

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 include/net/netfilter/nf_log.h |   10 +++-
 net/netfilter/nf_log.c         |  107 +++++++++++++++++++++++++++++++---------
 2 files changed, 91 insertions(+), 26 deletions(-)

diff --git a/include/net/netfilter/nf_log.h b/include/net/netfilter/nf_log.h
index 7182c06..08b4f18 100644
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
@@ -40,13 +42,17 @@ struct nf_logger {
 	struct module	*me;
 	nf_logfn 	*logfn;
 	char		*name;
+	struct list_head	list[NFPROTO_NUMPROTO];
 };
 
 /* Function to register/unregister log function. */
-int nf_log_register(u_int8_t pf, const struct nf_logger *logger);
-void nf_log_unregister(const struct nf_logger *logger);
+int nf_log_register(u_int8_t pf, struct nf_logger *logger);
+void nf_log_unregister(struct nf_logger *logger);
 void nf_log_unregister_pf(u_int8_t pf);
 
+int nf_log_bind_pf(u_int8_t pf, const struct nf_logger *logger);
+int nf_log_unbind_pf(u_int8_t pf);
+
 /* Calls the registered backend logging function */
 void nf_log_packet(u_int8_t pf,
 		   unsigned int hooknum,
diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index fa8ae5d..8a5e4aa 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -14,13 +14,25 @@
    LOG target modules */
 
 #define NF_LOG_PREFIXLEN		128
+#define NFLOGGER_NAME_LEN		12
 
 static const struct nf_logger *nf_loggers[NFPROTO_NUMPROTO] __read_mostly;
-static DEFINE_MUTEX(nf_log_mutex);
+static struct list_head nf_loggers_l[NFPROTO_NUMPROTO] __read_mostly;
+static DEFINE_SPINLOCK(nf_log_lock);
 
-/* return EBUSY if somebody else is registered, EEXIST if the same logger
- * is registred, 0 on success. */
-int nf_log_register(u_int8_t pf, const struct nf_logger *logger)
+static struct nf_logger *__find_logger(int pf, const char *str_logger)
+{
+	struct nf_logger *t;
+
+	list_for_each_entry(t, &nf_loggers_l[pf], list[pf])
+		if (!strnicmp(str_logger, t->name, NFLOGGER_NAME_LEN))
+			return t;
+
+	return NULL;
+}
+
+/* return EEXIST if the same logger is registred, 0 on success. */
+int nf_log_register(u_int8_t pf, struct nf_logger *logger)
 {
 	int ret;
 
@@ -29,50 +41,91 @@ int nf_log_register(u_int8_t pf, const struct nf_logger *logger)
 
 	/* Any setup of logging members must be done before
 	 * substituting pointer. */
-	ret = mutex_lock_interruptible(&nf_log_mutex);
-	if (ret < 0)
-		return ret;
-
-	if (!nf_loggers[pf])
-		rcu_assign_pointer(nf_loggers[pf], logger);
-	else if (nf_loggers[pf] == logger)
-		ret = -EEXIST;
-	else
-		ret = -EBUSY;
-
-	mutex_unlock(&nf_log_mutex);
+	spin_lock_bh(&nf_log_lock);
+
+	ret = -EEXIST;
+	if (pf == NFPROTO_UNSPEC) {
+		int i;
+		for (i = NFPROTO_UNSPEC; i < NFPROTO_NUMPROTO; i++) {
+			if (__find_logger(i, logger->name) == NULL) {
+				ret = 0;
+				INIT_LIST_HEAD(&(logger->list[i]));
+				list_add_tail(&(logger->list[i]),
+						  &(nf_loggers_l[i]));
+			}
+		}
+	} else {
+		if (__find_logger(pf, logger->name) == NULL) {
+			ret = 0;
+			INIT_LIST_HEAD(&(logger->list[pf]));
+			/* register at end of list to honor first register win */
+			list_add_tail(&(logger->list[pf]),
+					  &nf_loggers_l[pf]);
+		}
+	}
+
+	spin_unlock_bh(&nf_log_lock);
 	return ret;
 }
 EXPORT_SYMBOL(nf_log_register);
 
 void nf_log_unregister_pf(u_int8_t pf)
 {
+	struct nf_logger *e;
 	if (pf >= ARRAY_SIZE(nf_loggers))
 		return;
-	mutex_lock(&nf_log_mutex);
-	rcu_assign_pointer(nf_loggers[pf], NULL);
-	mutex_unlock(&nf_log_mutex);
+	spin_lock_bh(&nf_log_lock);
+	list_for_each_entry(e, &(nf_loggers_l[pf]), list[pf])
+		list_del(&(e->list[pf]));
+	spin_unlock_bh(&nf_log_lock);
 
 	/* Give time to concurrent readers. */
 	synchronize_rcu();
 }
 EXPORT_SYMBOL(nf_log_unregister_pf);
 
-void nf_log_unregister(const struct nf_logger *logger)
+void nf_log_unregister(struct nf_logger *logger)
 {
 	int i;
+	struct nf_logger *llog;
 
-	mutex_lock(&nf_log_mutex);
+	spin_lock_bh(&nf_log_lock);
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
-	mutex_unlock(&nf_log_mutex);
+	spin_unlock_bh(&nf_log_lock);
 
 	synchronize_rcu();
 }
 EXPORT_SYMBOL(nf_log_unregister);
 
+int nf_log_bind_pf(u_int8_t pf, const struct nf_logger *logger)
+{
+	if (__find_logger(pf, logger->name) == NULL)
+		return -1;
+
+	spin_lock_bh(&nf_log_lock);
+	rcu_assign_pointer(nf_loggers[pf], logger);
+	spin_unlock_bh(&nf_log_lock);
+	return 0;
+}
+EXPORT_SYMBOL(nf_log_bind_pf);
+
+int nf_log_unbind_pf(u_int8_t pf)
+{
+	spin_lock_bh(&nf_log_lock);
+	rcu_assign_pointer(nf_loggers[pf], NULL);
+	spin_unlock_bh(&nf_log_lock);
+	return 0;
+}
+EXPORT_SYMBOL(nf_log_unbind_pf);
+
 void nf_log_packet(u_int8_t pf,
 		   unsigned int hooknum,
 		   const struct sk_buff *skb,
@@ -163,10 +216,16 @@ static const struct file_operations nflog_file_ops = {
 
 int __init netfilter_log_init(void)
 {
+	int i;
 #ifdef CONFIG_PROC_FS
 	if (!proc_create("nf_log", S_IRUGO,
 			 proc_net_netfilter, &nflog_file_ops))
 		return -1;
 #endif
+
+	for (i = NFPROTO_UNSPEC; i < NFPROTO_NUMPROTO; i++) {
+		INIT_LIST_HEAD(&(nf_loggers_l[i]));
+	}
+
 	return 0;
 }
-- 
1.5.6.3

