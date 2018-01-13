From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] netfilter: delete /proc THIS_MODULE references
Date: Sat, 13 Jan 2018 20:08:31 +0300
Message-ID: <20180113170831.GA1016@avx2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org, kadlec@blackhole.kfki.hu, fw@strlen.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:42992 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751715AbeAMRIf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 13 Jan 2018 12:08:35 -0500
Received: by mail-wm0-f41.google.com with SMTP id b141so17773547wme.1
        for <netfilter-devel@vger.kernel.org>; Sat, 13 Jan 2018 09:08:34 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

/proc has been ignoring struct file_operations::owner field for ages.

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
