From: Marcelo Ricardo Leitner <mleitner@redhat.com>
Subject: [PATCH v2] Introduce nft_log_dereference() macro
Date: Wed, 29 Oct 2014 10:04:51 -0200
Message-ID: <ace1b8fe8ea5baf9446204b0577a05fdd7639644.1414583877.git.mleitner@redhat.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40867 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932479AbaJ2MFF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 Oct 2014 08:05:05 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s9TC55u7018347
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Oct 2014 08:05:05 -0400
Received: from localhost.localdomain.com (vpn1-7-3.gru2.redhat.com [10.97.7.3])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id s9TC54SQ026188
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Oct 2014 08:05:04 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Wrap up a common call pattern in an easier to handle call.

Signed-off-by: Marcelo Ricardo Leitner <mleitner@redhat.com>
---

Notes:
    Removed from patchset because now they aren't really related.

 net/netfilter/nf_log.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index d7197649dba689bae96edb10848e8c1c3d4a63f6..5eaf047ed37facad0df59e70428c08ef8717a70d 100644
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
 		if (!strncasecmp(str_logger, log->name, strlen(log->name)))
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

