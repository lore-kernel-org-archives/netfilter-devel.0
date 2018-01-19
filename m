From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 30/32] netfilter: delete /proc THIS_MODULE references
Date: Fri, 19 Jan 2018 20:10:39 +0100
Message-ID: <20180119191041.25804-31-pablo@netfilter.org>
References: <20180119191041.25804-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45188 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756313AbeASTLi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Jan 2018 14:11:38 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 757232EFEC3
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jan 2018 20:11:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 57D8EDA851
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jan 2018 20:11:13 +0100 (CET)
In-Reply-To: <20180119191041.25804-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Alexey Dobriyan <adobriyan@gmail.com>

/proc has been ignoring struct file_operations::owner field for 10 years.
Specifically, it started with commit 786d7e1612f0b0adb6046f19b906609e4fe8b1ba
("Fix rmmod/read/write races in /proc entries"). Notice the chunk where
inode->i_fop is initialized with proxy struct file_operations for
regular files:

	-               if (de->proc_fops)
	-                       inode->i_fop = de->proc_fops;
	+               if (de->proc_fops) {
	+                       if (S_ISREG(inode->i_mode))
	+                               inode->i_fop = &proc_reg_file_ops;
	+                       else
	+                               inode->i_fop = de->proc_fops;
	+               }

VFS stopped pinning module at this point.

# ipvs
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_app.c          | 1 -
 net/netfilter/ipvs/ip_vs_conn.c         | 2 --
 net/netfilter/ipvs/ip_vs_ctl.c          | 3 ---
 net/netfilter/nf_conntrack_expect.c     | 1 -
 net/netfilter/nf_conntrack_standalone.c | 2 --
 net/netfilter/nf_log.c                  | 1 -
 net/netfilter/nf_synproxy_core.c        | 1 -
 net/netfilter/nfnetlink_log.c           | 1 -
 net/netfilter/nfnetlink_queue.c         | 1 -
 net/netfilter/x_tables.c                | 3 ---
 net/netfilter/xt_hashlimit.c            | 3 ---
 11 files changed, 19 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_app.c b/net/netfilter/ipvs/ip_vs_app.c
index 299edc6add5a..1c98c907bc63 100644
--- a/net/netfilter/ipvs/ip_vs_app.c
+++ b/net/netfilter/ipvs/ip_vs_app.c
@@ -595,7 +595,6 @@ static int ip_vs_app_open(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations ip_vs_app_fops = {
-	.owner	 = THIS_MODULE,
 	.open	 = ip_vs_app_open,
 	.read	 = seq_read,
 	.llseek  = seq_lseek,
diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index f489b8db2406..370abbf6f421 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -1143,7 +1143,6 @@ static int ip_vs_conn_open(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations ip_vs_conn_fops = {
-	.owner	 = THIS_MODULE,
 	.open    = ip_vs_conn_open,
 	.read    = seq_read,
 	.llseek  = seq_lseek,
@@ -1221,7 +1220,6 @@ static int ip_vs_conn_sync_open(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations ip_vs_conn_sync_fops = {
-	.owner	 = THIS_MODULE,
 	.open    = ip_vs_conn_sync_open,
 	.read    = seq_read,
 	.llseek  = seq_lseek,
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index fff213eacf2a..5ebde4b15810 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -2116,7 +2116,6 @@ static int ip_vs_info_open(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations ip_vs_info_fops = {
-	.owner	 = THIS_MODULE,
 	.open    = ip_vs_info_open,
 	.read    = seq_read,
 	.llseek  = seq_lseek,
@@ -2161,7 +2160,6 @@ static int ip_vs_stats_seq_open(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations ip_vs_stats_fops = {
-	.owner = THIS_MODULE,
 	.open = ip_vs_stats_seq_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -2230,7 +2228,6 @@ static int ip_vs_stats_percpu_seq_open(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations ip_vs_stats_percpu_fops = {
-	.owner = THIS_MODULE,
 	.open = ip_vs_stats_percpu_seq_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index d6748a8a79c5..8ef21d9f9a00 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -649,7 +649,6 @@ static int exp_open(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations exp_file_ops = {
-	.owner   = THIS_MODULE,
 	.open    = exp_open,
 	.read    = seq_read,
 	.llseek  = seq_lseek,
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 46d32baad095..9123fdec5e14 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -382,7 +382,6 @@ static int ct_open(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations ct_file_ops = {
-	.owner   = THIS_MODULE,
 	.open    = ct_open,
 	.read    = seq_read,
 	.llseek  = seq_lseek,
@@ -475,7 +474,6 @@ static int ct_cpu_seq_open(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations ct_cpu_seq_fops = {
-	.owner	 = THIS_MODULE,
 	.open	 = ct_cpu_seq_open,
 	.read	 = seq_read,
 	.llseek	 = seq_lseek,
diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index 8bb152a7cca4..c2c1b16b7538 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -402,7 +402,6 @@ static int nflog_open(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations nflog_file_ops = {
-	.owner	 = THIS_MODULE,
 	.open	 = nflog_open,
 	.read	 = seq_read,
 	.llseek	 = seq_lseek,
diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index 49bd8bb16b18..92139a087260 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -317,7 +317,6 @@ static int synproxy_cpu_seq_open(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations synproxy_cpu_seq_fops = {
-	.owner		= THIS_MODULE,
 	.open		= synproxy_cpu_seq_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index e955bec0acc6..7b46aa4c478d 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -1054,7 +1054,6 @@ static int nful_open(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations nful_file_ops = {
-	.owner	 = THIS_MODULE,
 	.open	 = nful_open,
 	.read	 = seq_read,
 	.llseek	 = seq_lseek,
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 2db35f2d553d..8bba23160a68 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1477,7 +1477,6 @@ static int nfqnl_open(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations nfqnl_file_ops = {
-	.owner	 = THIS_MODULE,
 	.open	 = nfqnl_open,
 	.read	 = seq_read,
 	.llseek	 = seq_lseek,
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 3c2548787d78..0b56bf05c169 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1362,7 +1362,6 @@ static int xt_table_open(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations xt_table_ops = {
-	.owner	 = THIS_MODULE,
 	.open	 = xt_table_open,
 	.read	 = seq_read,
 	.llseek	 = seq_lseek,
@@ -1498,7 +1497,6 @@ static int xt_match_open(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations xt_match_ops = {
-	.owner	 = THIS_MODULE,
 	.open	 = xt_match_open,
 	.read	 = seq_read,
 	.llseek	 = seq_lseek,
@@ -1551,7 +1549,6 @@ static int xt_target_open(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations xt_target_ops = {
-	.owner	 = THIS_MODULE,
 	.open	 = xt_target_open,
 	.read	 = seq_read,
 	.llseek	 = seq_lseek,
diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index ec51d9a9512d..ca6847403ca2 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -1266,7 +1266,6 @@ static int dl_proc_open(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations dl_file_ops_v2 = {
-	.owner   = THIS_MODULE,
 	.open    = dl_proc_open_v2,
 	.read    = seq_read,
 	.llseek  = seq_lseek,
@@ -1274,7 +1273,6 @@ static const struct file_operations dl_file_ops_v2 = {
 };
 
 static const struct file_operations dl_file_ops_v1 = {
-	.owner   = THIS_MODULE,
 	.open    = dl_proc_open_v1,
 	.read    = seq_read,
 	.llseek  = seq_lseek,
@@ -1282,7 +1280,6 @@ static const struct file_operations dl_file_ops_v1 = {
 };
 
 static const struct file_operations dl_file_ops = {
-	.owner   = THIS_MODULE,
 	.open    = dl_proc_open,
 	.read    = seq_read,
 	.llseek  = seq_lseek,
-- 
2.11.0

