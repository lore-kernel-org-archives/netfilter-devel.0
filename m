From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH v2] netfilter: delete /proc THIS_MODULE references
Date: Tue, 16 Jan 2018 00:45:32 +0300
Message-ID: <20180115214532.GD6942@avx2>
References: <20180113170831.GA1016@avx2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, ja@ssi.bg
To: pablo@netfilter.org, kadlec@blackhole.kfki.hu, fw@strlen.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wr0-f174.google.com ([209.85.128.174]:34318 "EHLO
        mail-wr0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750716AbeAOVpg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Jan 2018 16:45:36 -0500
Received: by mail-wr0-f174.google.com with SMTP id 36so13224172wrh.1
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Jan 2018 13:45:35 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20180113170831.GA1016@avx2>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

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
---

 net/netfilter/ipvs/ip_vs_app.c          |    1 -
 net/netfilter/ipvs/ip_vs_conn.c         |    2 --
 net/netfilter/ipvs/ip_vs_ctl.c          |    3 ---
 net/netfilter/nf_conntrack_expect.c     |    1 -
 net/netfilter/nf_conntrack_standalone.c |    2 --
 net/netfilter/nf_log.c                  |    1 -
 net/netfilter/nf_synproxy_core.c        |    1 -
 net/netfilter/nfnetlink_log.c           |    1 -
 net/netfilter/nfnetlink_queue.c         |    1 -
 net/netfilter/x_tables.c                |    3 ---
 net/netfilter/xt_hashlimit.c            |    3 ---
 11 files changed, 19 deletions(-)

--- a/net/netfilter/ipvs/ip_vs_app.c
+++ b/net/netfilter/ipvs/ip_vs_app.c
@@ -595,7 +595,6 @@ static int ip_vs_app_open(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations ip_vs_app_fops = {
-	.owner	 = THIS_MODULE,
 	.open	 = ip_vs_app_open,
 	.read	 = seq_read,
 	.llseek  = seq_lseek,
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
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -649,7 +649,6 @@ static int exp_open(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations exp_file_ops = {
-	.owner   = THIS_MODULE,
 	.open    = exp_open,
 	.read    = seq_read,
 	.llseek  = seq_lseek,
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
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -402,7 +402,6 @@ static int nflog_open(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations nflog_file_ops = {
-	.owner	 = THIS_MODULE,
 	.open	 = nflog_open,
 	.read	 = seq_read,
 	.llseek	 = seq_lseek,
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -317,7 +317,6 @@ static int synproxy_cpu_seq_open(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations synproxy_cpu_seq_fops = {
-	.owner		= THIS_MODULE,
 	.open		= synproxy_cpu_seq_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -1054,7 +1054,6 @@ static int nful_open(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations nful_file_ops = {
-	.owner	 = THIS_MODULE,
 	.open	 = nful_open,
 	.read	 = seq_read,
 	.llseek	 = seq_lseek,
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1477,7 +1477,6 @@ static int nfqnl_open(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations nfqnl_file_ops = {
-	.owner	 = THIS_MODULE,
 	.open	 = nfqnl_open,
 	.read	 = seq_read,
 	.llseek	 = seq_lseek,
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
