From: Eric Leblond <eric@inl.fr>
Subject: [PATCH] netfilter: sysctl support of logger choice.
Date: Wed, 18 Mar 2009 00:27:38 +0100
Message-ID: <1237332458-25202-1-git-send-email-eric@inl.fr>
References: <1237331756.2708.41.camel@ice-age>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@inl.fr>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:48810 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751872AbZCQX1r (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Mar 2009 19:27:47 -0400
In-Reply-To: <1237331756.2708.41.camel@ice-age>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patchs adds support of modification of the used logger via sysctl.
It can be used to change the logger to module that can not use the bind
operation (ipt_LOG and ipt_ULOG). For this purpose, it creates a
directory /proc/sys/net/netfilter/nf_log which contains a file
per-protocol. The content of the file is the name current logger (NONE if
not set) and a logger can be setup by simply echoing its name to the file.
By echoing "NONE" to a /proc/sys/net/netfilter/nf_log/PROTO file, the
logger corresponding to this PROTO is set to NULL.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 net/netfilter/nf_log.c |   84 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 83 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index 4fcbcc7..4b0cab3 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -14,6 +14,7 @@
    LOG target modules */
 
 #define NF_LOG_PREFIXLEN		128
+#define NFLOGGER_NAME_LEN		64
 
 static const struct nf_logger *nf_loggers[NFPROTO_NUMPROTO] __read_mostly;
 static struct list_head nf_loggers_l[NFPROTO_NUMPROTO] __read_mostly;
@@ -207,18 +208,99 @@ static const struct file_operations nflog_file_ops = {
 	.release = seq_release,
 };
 
+
 #endif /* PROC_FS */
 
+#ifdef CONFIG_SYSCTL
+struct ctl_path nf_log_sysctl_path[] = {
+	{ .procname = "net", .ctl_name = CTL_NET, },
+	{ .procname = "netfilter", .ctl_name = NET_NETFILTER, },
+	{ .procname = "nf_log", .ctl_name = CTL_UNNUMBERED, },
+	{ }
+};
+
+static char nf_log_sysctl_fnames[NFPROTO_NUMPROTO-NFPROTO_UNSPEC][3];
+static struct ctl_table nf_log_sysctl_table[NFPROTO_NUMPROTO+1];
+static struct ctl_table_header *nf_log_dir_header;
 
-int __init netfilter_log_init(void)
+static int nf_log_proc_dostring(ctl_table *table, int write, struct file *filp,
+			 void *buffer, size_t *lenp, loff_t *ppos)
+{
+	const struct nf_logger *logger;
+	int r = 0;
+	int tindex = (unsigned long) table->extra1;
+
+	if (write) {
+		if (!strnicmp(buffer, "NONE", *lenp - 1)) {
+			nf_log_unbind_pf(tindex);
+			return 0;
+		}
+		mutex_lock(&nf_log_mutex);
+		logger = __find_logger(tindex, buffer);
+		if (logger == NULL) {
+			mutex_unlock(&nf_log_mutex);
+			return -EINVAL;
+		}
+		rcu_assign_pointer(nf_loggers[tindex], logger);
+		mutex_unlock(&nf_log_mutex);
+	} else {
+		rcu_read_lock();
+		logger = rcu_dereference(nf_loggers[tindex]);
+		if (! logger)
+			table->data = "NONE";
+		else
+			table->data = logger->name;
+		r = proc_dostring(table, write, filp, buffer, lenp, ppos);
+		rcu_read_unlock();
+	}
+
+	return r;
+}
+
+static int netfilter_log_sysctl_init(void)
 {
 	int i;
+
+	for (i = NFPROTO_UNSPEC; i < NFPROTO_NUMPROTO; i++) {
+		snprintf(nf_log_sysctl_fnames[i-NFPROTO_UNSPEC], 3, "%d", i);
+		nf_log_sysctl_table[i].ctl_name	= CTL_UNNUMBERED;
+		nf_log_sysctl_table[i].procname	=
+			nf_log_sysctl_fnames[i-NFPROTO_UNSPEC];
+		nf_log_sysctl_table[i].data = NULL;
+		nf_log_sysctl_table[i].maxlen =
+			NFLOGGER_NAME_LEN * sizeof(char);
+		nf_log_sysctl_table[i].mode = 0644;
+		nf_log_sysctl_table[i].proc_handler = nf_log_proc_dostring;
+		nf_log_sysctl_table[i].extra1 = (void *)(unsigned long) i;
+	}
+
+	nf_log_dir_header = register_sysctl_paths(nf_log_sysctl_path,
+				       nf_log_sysctl_table);
+	if (!nf_log_dir_header)
+		return -EINVAL;
+
+	return 0;
+}
+#else
+static int netfilter_log_sysctl_init(void)
+{
+	return 0;
+}
+#endif /* CONFIG_SYSCTL */
+
+int __init netfilter_log_init(void)
+{
+	int i, r;
 #ifdef CONFIG_PROC_FS
 	if (!proc_create("nf_log", S_IRUGO,
 			 proc_net_netfilter, &nflog_file_ops))
 		return -1;
 #endif
 
+	r = netfilter_log_sysctl_init();
+	if (r < 0)
+		return r;
+
 	for (i = NFPROTO_UNSPEC; i < NFPROTO_NUMPROTO; i++)
 		INIT_LIST_HEAD(&(nf_loggers_l[i]));
 
-- 
1.5.6.3

