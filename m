From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 08/22]: nf_log: minor cleanups
Date: Mon, 12 Feb 2007 11:36:32 +0100 (MET)
Message-ID: <20070212103632.661.85670.sendpatchset@localhost.localdomain>
References: <20070212103621.661.65165.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070212103621.661.65165.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: nf_log: minor cleanups

- rename nf_logging to nf_loggers since its an array of registered loggers

- rename nf_log_unregister_logger() to nf_log_unregister() to make it
  symetrical to nf_log_register() and convert all users

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 5187c6343d6eac0b2fc995bfb607f817565ec258
tree c0290f3d2891089ca4f7d231cd21d3e081890ddc
parent 99c46fbd857a8a2d01987650bd1492b5379ac250
author Patrick McHardy <kaber@trash.net> Mon, 12 Feb 2007 10:37:47 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 12 Feb 2007 10:37:47 +0100

 include/linux/netfilter.h       |    2 +-
 net/bridge/netfilter/ebt_log.c  |    2 +-
 net/bridge/netfilter/ebt_ulog.c |    2 +-
 net/ipv4/netfilter/ipt_LOG.c    |    2 +-
 net/ipv4/netfilter/ipt_ULOG.c   |    2 +-
 net/ipv6/netfilter/ip6t_LOG.c   |    2 +-
 net/netfilter/nf_log.c          |   22 +++++++++++-----------
 net/netfilter/nfnetlink_log.c   |    2 +-
 8 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 18a6790..70d3b4f 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -172,8 +172,8 @@ struct nf_logger {
 
 /* Function to register/unregister log function. */
 int nf_log_register(int pf, struct nf_logger *logger);
+void nf_log_unregister(struct nf_logger *logger);
 void nf_log_unregister_pf(int pf);
-void nf_log_unregister_logger(struct nf_logger *logger);
 
 /* Calls the registered backend logging function */
 void nf_log_packet(int pf,
diff --git a/net/bridge/netfilter/ebt_log.c b/net/bridge/netfilter/ebt_log.c
index f9a5ae9..45712ae 100644
--- a/net/bridge/netfilter/ebt_log.c
+++ b/net/bridge/netfilter/ebt_log.c
@@ -208,7 +208,7 @@ static int __init ebt_log_init(void)
 
 static void __exit ebt_log_fini(void)
 {
-	nf_log_unregister_logger(&ebt_log_logger);
+	nf_log_unregister(&ebt_log_logger);
 	ebt_unregister_watcher(&log);
 }
 
diff --git a/net/bridge/netfilter/ebt_ulog.c b/net/bridge/netfilter/ebt_ulog.c
index 2e4cb24..8e15cc4 100644
--- a/net/bridge/netfilter/ebt_ulog.c
+++ b/net/bridge/netfilter/ebt_ulog.c
@@ -323,7 +323,7 @@ static void __exit ebt_ulog_fini(void)
 	ebt_ulog_buff_t *ub;
 	int i;
 
-	nf_log_unregister_logger(&ebt_ulog_logger);
+	nf_log_unregister(&ebt_ulog_logger);
 	ebt_unregister_watcher(&ulog);
 	for (i = 0; i < EBT_ULOG_MAXNLGROUPS; i++) {
 		ub = &ulog_buffers[i];
diff --git a/net/ipv4/netfilter/ipt_LOG.c b/net/ipv4/netfilter/ipt_LOG.c
index f4a62f2..d9c37fd 100644
--- a/net/ipv4/netfilter/ipt_LOG.c
+++ b/net/ipv4/netfilter/ipt_LOG.c
@@ -489,7 +489,7 @@ static int __init ipt_log_init(void)
 
 static void __exit ipt_log_fini(void)
 {
-	nf_log_unregister_logger(&ipt_log_logger);
+	nf_log_unregister(&ipt_log_logger);
 	xt_unregister_target(&ipt_log_reg);
 }
 
diff --git a/net/ipv4/netfilter/ipt_ULOG.c b/net/ipv4/netfilter/ipt_ULOG.c
index 3a1eacc..a26404d 100644
--- a/net/ipv4/netfilter/ipt_ULOG.c
+++ b/net/ipv4/netfilter/ipt_ULOG.c
@@ -419,7 +419,7 @@ static void __exit ipt_ulog_fini(void)
 	DEBUGP("ipt_ULOG: cleanup_module\n");
 
 	if (nflog)
-		nf_log_unregister_logger(&ipt_ulog_logger);
+		nf_log_unregister(&ipt_ulog_logger);
 	xt_unregister_target(&ipt_ulog_reg);
 	sock_release(nflognl->sk_socket);
 
diff --git a/net/ipv6/netfilter/ip6t_LOG.c b/net/ipv6/netfilter/ip6t_LOG.c
index dc9ec93..afaa039 100644
--- a/net/ipv6/netfilter/ip6t_LOG.c
+++ b/net/ipv6/netfilter/ip6t_LOG.c
@@ -501,7 +501,7 @@ static int __init ip6t_log_init(void)
 
 static void __exit ip6t_log_fini(void)
 {
-	nf_log_unregister_logger(&ip6t_logger);
+	nf_log_unregister(&ip6t_logger);
 	xt_unregister_target(&ip6t_log_reg);
 }
 
diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index b942cd5..0db2fd8 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -14,7 +14,7 @@ #include "nf_internals.h"
 
 #define NF_LOG_PREFIXLEN		128
 
-static struct nf_logger *nf_logging[NPROTO]; /* = NULL */
+static struct nf_logger *nf_loggers[NPROTO];
 static DEFINE_MUTEX(nf_log_mutex);
 
 /* return EBUSY if somebody else is registered, EEXIST if the same logger
@@ -32,9 +32,9 @@ int nf_log_register(int pf, struct nf_lo
 	if (ret < 0)
 		return ret;
 
-	if (!nf_logging[pf])
-		rcu_assign_pointer(nf_logging[pf], logger);
-	else if (nf_logging[pf] == logger)
+	if (!nf_loggers[pf])
+		rcu_assign_pointer(nf_loggers[pf], logger);
+	else if (nf_loggers[pf] == logger)
 		ret = -EEXIST;
 	else
 		ret = -EBUSY;
@@ -49,7 +49,7 @@ void nf_log_unregister_pf(int pf)
 	if (pf >= NPROTO)
 		return;
 	mutex_lock(&nf_log_mutex);
-	rcu_assign_pointer(nf_logging[pf], NULL);
+	rcu_assign_pointer(nf_loggers[pf], NULL);
 	mutex_unlock(&nf_log_mutex);
 
 	/* Give time to concurrent readers. */
@@ -57,20 +57,20 @@ void nf_log_unregister_pf(int pf)
 }
 EXPORT_SYMBOL(nf_log_unregister_pf);
 
-void nf_log_unregister_logger(struct nf_logger *logger)
+void nf_log_unregister(struct nf_logger *logger)
 {
 	int i;
 
 	mutex_lock(&nf_log_mutex);
 	for (i = 0; i < NPROTO; i++) {
-		if (nf_logging[i] == logger)
-			rcu_assign_pointer(nf_logging[i], NULL);
+		if (nf_loggers[i] == logger)
+			rcu_assign_pointer(nf_loggers[i], NULL);
 	}
 	mutex_unlock(&nf_log_mutex);
 
 	synchronize_rcu();
 }
-EXPORT_SYMBOL(nf_log_unregister_logger);
+EXPORT_SYMBOL(nf_log_unregister);
 
 void nf_log_packet(int pf,
 		   unsigned int hooknum,
@@ -85,7 +85,7 @@ void nf_log_packet(int pf,
 	struct nf_logger *logger;
 	
 	rcu_read_lock();
-	logger = rcu_dereference(nf_logging[pf]);
+	logger = rcu_dereference(nf_loggers[pf]);
 	if (logger) {
 		va_start(args, fmt);
 		vsnprintf(prefix, sizeof(prefix), fmt, args);
@@ -132,7 +132,7 @@ static int seq_show(struct seq_file *s, 
 	loff_t *pos = v;
 	const struct nf_logger *logger;
 
-	logger = rcu_dereference(nf_logging[*pos]);
+	logger = rcu_dereference(nf_loggers[*pos]);
 
 	if (!logger)
 		return seq_printf(s, "%2lld NONE\n", *pos);
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index d1505dd..6511bb0 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -1077,7 +1077,7 @@ cleanup_netlink_notifier:
 
 static void __exit nfnetlink_log_fini(void)
 {
-	nf_log_unregister_logger(&nfulnl_logger);
+	nf_log_unregister(&nfulnl_logger);
 #ifdef CONFIG_PROC_FS
 	remove_proc_entry("nfnetlink_log", proc_net_netfilter);
 #endif
