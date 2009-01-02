From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 5/5] netfilter: sysctl support of logger choice.
Date: Fri,  2 Jan 2009 18:07:35 +0100
Message-ID: <1230916055-15448-5-git-send-email-eric@inl.fr>
References: <1230915875.28326.87.camel@ice-age>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@inl.fr>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:49077 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757382AbZABRHp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 Jan 2009 12:07:45 -0500
In-Reply-To: <1230915875.28326.87.camel@ice-age>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patchs adds support of modification of the used logger via sysctl.
It can be used to change the logger to module that can not use the bind
operation (ipt_LOG and ipt_ULOG). For this purpose, it creates a
directory /proc/sys/net/netfilter/nf_log which contains a file
per-protocol. The content of the file is the name current logger (NONE if
not set) and a logger can be setup by simply echoing its name to the file.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 include/linux/sysctl.h |    1 +
 net/netfilter/nf_log.c |   74 +++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 74 insertions(+), 1 deletions(-)

diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 39d471d..aa11b1c 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -335,6 +335,7 @@ enum
 	NET_NF_CONNTRACK_FRAG6_LOW_THRESH=30,
 	NET_NF_CONNTRACK_FRAG6_HIGH_THRESH=31,
 	NET_NF_CONNTRACK_CHECKSUM=32,
+	NET_NF_LOG=33,
 };
 
 /* /proc/sys/net/ipv4 */
diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index ed03c20..17698e3 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -14,7 +14,7 @@
    LOG target modules */
 
 #define NF_LOG_PREFIXLEN		128
-#define NFLOGGER_NAME_LEN		12
+#define NFLOGGER_NAME_LEN		24
 
 static const struct nf_logger *nf_loggers[NFPROTO_NUMPROTO] __read_mostly;
 static struct list_head nf_loggers_l[NFPROTO_NUMPROTO] __read_mostly;
@@ -211,16 +211,88 @@ static const struct file_operations nflog_file_ops = {
 
 #endif /* PROC_FS */
 
+#ifdef CONFIG_SYSCTL
+struct ctl_path nf_log_sysctl_path[] = {
+	{ .procname = "net", .ctl_name = CTL_NET, },
+	{ .procname = "netfilter", .ctl_name = NET_NETFILTER, },
+	{ .procname = "nf_log", .ctl_name = NET_NF_LOG, },
+	{ }
+};
+
+static struct ctl_table nf_log_sysctl_table[NFPROTO_NUMPROTO+1];
+static struct ctl_table_header *nf_log_dir_header;
+
+static int nf_log_proc_dostring(ctl_table *table, int write, struct file *filp,
+			 void *buffer, size_t *lenp, loff_t *ppos)
+{
+	const struct nf_logger *logger;
+	int r;
+	char ln_name[NFLOGGER_NAME_LEN];
+
+	rcu_read_lock();
+	if (write) {
+		logger = __find_logger(table->ctl_name, buffer);
+		if (logger == NULL) {
+			rcu_read_unlock();
+			return -EINVAL;
+		}
+		r = nf_log_bind_pf(table->ctl_name, logger);
+	} else {
+		logger = rcu_dereference(nf_loggers[table->ctl_name]);
+		if (! logger)
+			table->data = "NONE";
+		else {
+			memcpy(ln_name, logger->name, NFLOGGER_NAME_LEN);
+			table->data = ln_name;
+		}
+		r = proc_dostring(table, write, filp, buffer, lenp, ppos);
+	}
+	rcu_read_unlock();
+
+	return r;
+}
+
+static int netfilter_log_sysctl_init(void)
+{
+	int i;
+
+	for (i = NFPROTO_UNSPEC; i < NFPROTO_NUMPROTO; i++) {
+		char *pr_name = kmalloc(3, GFP_KERNEL);
+		/* FIXME free at deinit but there is currently no deinit */
+		snprintf(pr_name, 3, "%d", i);
+		nf_log_sysctl_table[i].ctl_name	= i;
+		nf_log_sysctl_table[i].procname	= pr_name;
+		nf_log_sysctl_table[i].data = NULL;
+		nf_log_sysctl_table[i].maxlen = NFLOGGER_NAME_LEN * sizeof(char);
+		nf_log_sysctl_table[i].mode = 0644;
+		nf_log_sysctl_table[i].proc_handler = nf_log_proc_dostring;
+	}
+
+	nf_log_dir_header = register_sysctl_paths(nf_log_sysctl_path,
+				       nf_log_sysctl_table);
+
+	return 0;
+}
+#else
+static int netfilter_log_sysctl_init(void)
+{
+	return 0;
+}
+#endif /* CONFIG_SYSCTL */
 
 int __init netfilter_log_init(void)
 {
 	int i;
+
 #ifdef CONFIG_PROC_FS
 	if (!proc_create("nf_log", S_IRUGO,
 			 proc_net_netfilter, &nflog_file_ops))
 		return -1;
 #endif
 
+	if (netfilter_log_sysctl_init() < 0)
+		return -1;
+
 	for (i = NFPROTO_UNSPEC; i < NFPROTO_NUMPROTO; i++) {
 		INIT_LIST_HEAD(&(nf_loggers_l[i]));
 	}
-- 
1.5.6.3

