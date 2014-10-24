From: Marcelo Ricardo Leitner <mleitner@redhat.com>
Subject: [PATCH 1/3] Introduce nft_log_dereference() macro
Date: Fri, 24 Oct 2014 10:59:49 -0200
Message-ID: <12a99ae77aa9969692d847d8d2929deb13485e72.1414155204.git.mleitner@redhat.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756357AbaJXM76 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Oct 2014 08:59:58 -0400
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s9OCxuBE010621
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Oct 2014 08:59:57 -0400
Received: from localhost.localdomain.com (vpn1-6-197.gru2.redhat.com [10.97.6.197])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id s9OCxt4F024829
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Oct 2014 08:59:55 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Wrap up a common call pattern in an easier to handle call.

Signed-off-by: Marcelo Ricardo Leitner <mleitner@redhat.com>
---
 net/netfilter/nf_log.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index daad6022c689c47a66a47e7a89a83c0c848c53d6..f1409d95f810c689ec70755eb8a85125d291ad47 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -19,6 +19,9 @@
 static struct nf_logger __rcu *loggers[NFPROTO_NUMPROTO][NF_LOG_TYPE_MAX] __read_mostly;
 static DEFINE_MUTEX(nf_log_mutex);
 
+#define nft_log_dereference(logger) \
+	rcu_dereference_protected(logger, lockdep_is_held(&nf_log_mutex))
+
 static struct nf_logger *__find_logger(int pf, const char *str_logger)
 {
 	struct nf_logger *log;
@@ -28,8 +31,7 @@ static struct nf_logger *__find_logger(int pf, const char *str_logger)
 		if (loggers[pf][i] == NULL)
 			continue;
 
-		log = rcu_dereference_protected(loggers[pf][i],
-						lockdep_is_held(&nf_log_mutex));
+		log = nft_log_dereference(loggers[pf][i]);
 		if (!strnicmp(str_logger, log->name, strlen(log->name)))
 			return log;
 	}
@@ -45,8 +47,7 @@ void nf_log_set(struct net *net, u_int8_t pf, const struct nf_logger *logger)
 		return;
 
 	mutex_lock(&nf_log_mutex);
-	log = rcu_dereference_protected(net->nf.nf_loggers[pf],
-					lockdep_is_held(&nf_log_mutex));
+	log = nft_log_dereference(net->nf.nf_loggers[pf]);
 	if (log == NULL)
 		rcu_assign_pointer(net->nf.nf_loggers[pf], logger);
 
@@ -61,8 +62,7 @@ void nf_log_unset(struct net *net, const struct nf_logger *logger)
 
 	mutex_lock(&nf_log_mutex);
 	for (i = 0; i < NFPROTO_NUMPROTO; i++) {
-		log = rcu_dereference_protected(net->nf.nf_loggers[i],
-				lockdep_is_held(&nf_log_mutex));
+		log = nft_log_dereference(net->nf.nf_loggers[i]);
 		if (log == logger)
 			RCU_INIT_POINTER(net->nf.nf_loggers[i], NULL);
 	}
@@ -297,8 +297,7 @@ static int seq_show(struct seq_file *s, void *v)
 	int i, ret;
 	struct net *net = seq_file_net(s);
 
-	logger = rcu_dereference_protected(net->nf.nf_loggers[*pos],
-					   lockdep_is_held(&nf_log_mutex));
+	logger = nft_log_dereference(net->nf.nf_loggers[*pos]);
 
 	if (!logger)
 		ret = seq_printf(s, "%2lld NONE (", *pos);
@@ -312,8 +311,7 @@ static int seq_show(struct seq_file *s, void *v)
 		if (loggers[*pos][i] == NULL)
 			continue;
 
-		logger = rcu_dereference_protected(loggers[*pos][i],
-					   lockdep_is_held(&nf_log_mutex));
+		logger = nft_log_dereference(loggers[*pos][i]);
 		ret = seq_printf(s, "%s", logger->name);
 		if (ret < 0)
 			return ret;
@@ -385,8 +383,7 @@ static int nf_log_proc_dostring(struct ctl_table *table, int write,
 		mutex_unlock(&nf_log_mutex);
 	} else {
 		mutex_lock(&nf_log_mutex);
-		logger = rcu_dereference_protected(net->nf.nf_loggers[tindex],
-						   lockdep_is_held(&nf_log_mutex));
+		logger = nft_log_dereference(net->nf.nf_loggers[tindex]);
 		if (!logger)
 			table->data = "NONE";
 		else
-- 
1.9.3

