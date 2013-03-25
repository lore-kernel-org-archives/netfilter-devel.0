From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH nf-next v2 08/10] netfilter: nf_log: enable nflog in un-init net namespace
Date: Mon, 25 Mar 2013 17:50:46 +0800
Message-ID: <1364205048-32632-8-git-send-email-gaofeng@cn.fujitsu.com>
References: <1364205048-32632-1-git-send-email-gaofeng@cn.fujitsu.com>
Cc: pablo@netfilter.org, Gao feng <gaofeng@cn.fujitsu.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:26027 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751599Ab3CYJuQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Mar 2013 05:50:16 -0400
In-Reply-To: <1364205048-32632-1-git-send-email-gaofeng@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Now all nf_loggers are support net namespace, we
can allow all net namespace to enable the nflog.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 net/netfilter/nf_log.c | 21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index 2aa1fc1..5f6182d 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -33,9 +33,6 @@ static struct nf_logger *__find_logger(int pf, const char *str_logger)
 
 void nf_log_set(struct net *net, u_int8_t pf, const struct nf_logger *logger)
 {
-	if (!net_eq(net, &init_net))
-		return;
-
 	if (pf != NFPROTO_UNSPEC) {
 		const struct nf_logger *log;
 		mutex_lock(&nf_log_mutex);
@@ -54,9 +51,6 @@ void nf_log_unset(struct net *net, const struct nf_logger *logger)
 	int i;
 	const struct nf_logger *log;
 
-	if (!net_eq(net, &init_net))
-		return;
-
 	mutex_lock(&nf_log_mutex);
 	for (i = 0; i < NFPROTO_NUMPROTO; i++) {
 		log = rcu_dereference_protected(net->nf.nf_loggers[i],
@@ -92,7 +86,6 @@ int nf_log_register(u_int8_t pf, struct nf_logger *logger)
 
 	mutex_unlock(&nf_log_mutex);
 
-	nf_log_set(&init_net, pf, logger);
 	return 0;
 }
 EXPORT_SYMBOL(nf_log_register);
@@ -105,17 +98,12 @@ void nf_log_unregister(struct nf_logger *logger)
 	for (i = 0; i < NFPROTO_NUMPROTO; i++)
 		list_del(&logger->list[i]);
 	mutex_unlock(&nf_log_mutex);
-
-	nf_log_unset(&init_net, logger);
 }
 EXPORT_SYMBOL(nf_log_unregister);
 
 int nf_log_bind_pf(struct net *net, u_int8_t pf,
 		   const struct nf_logger *logger)
 {
-	if (!net_eq(net, &init_net))
-		return 0;
-
 	if (pf >= ARRAY_SIZE(net->nf.nf_loggers))
 		return -EINVAL;
 	mutex_lock(&nf_log_mutex);
@@ -131,9 +119,6 @@ EXPORT_SYMBOL(nf_log_bind_pf);
 
 void nf_log_unbind_pf(struct net *net, u_int8_t pf)
 {
-	if (!net_eq(net, &init_net))
-		return;
-
 	if (pf >= ARRAY_SIZE(net->nf.nf_loggers))
 		return;
 	mutex_lock(&nf_log_mutex);
@@ -155,9 +140,6 @@ void nf_log_packet(struct net *net,
 	char prefix[NF_LOG_PREFIXLEN];
 	const struct nf_logger *logger;
 
-	if (!net_eq(net, &init_net))
-		return;
-
 	rcu_read_lock();
 	logger = rcu_dereference(net->nf.nf_loggers[pf]);
 	if (logger) {
@@ -272,9 +254,6 @@ static int nf_log_proc_dostring(ctl_table *table, int write,
 	struct net *net = current->nsproxy->net_ns;
 
 	if (write) {
-		if (!net_eq(net, &init_net))
-			return -EPERM;
-
 		if (size > sizeof(buf))
 			size = sizeof(buf);
 		if (copy_from_user(buf, buffer, size))
-- 
1.7.11.7

