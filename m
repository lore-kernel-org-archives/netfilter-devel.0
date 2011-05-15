From: pablo@netfilter.org
Subject: [PATCH] IPVS: fix netns if reading ip_vs_* procfs entries
Date: Sun, 15 May 2011 17:57:57 +0200
Message-ID: <1305475077-3283-2-git-send-email-pablo@netfilter.org>
References: <1305475077-3283-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net,
	Hans Schillstrom <hans.schillstrom@ericsson.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41023 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756656Ab1EOP6N (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 15 May 2011 11:58:13 -0400
In-Reply-To: <1305475077-3283-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Hans Schillstrom <hans.schillstrom@ericsson.com>

Without this patch every access to ip_vs in procfs will increase
the netns count i.e. an unbalanced get_net()/put_net().
(ipvsadm commands also use procfs.)
The result is you can't exit a netns if reading ip_vs_* procfs entries.

Signed-off-by: Hans Schillstrom <hans.schillstrom@ericsson.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_app.c  |    2 +-
 net/netfilter/ipvs/ip_vs_conn.c |    4 ++--
 net/netfilter/ipvs/ip_vs_ctl.c  |    6 +++---
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_app.c b/net/netfilter/ipvs/ip_vs_app.c
index 51f3af7..059af31 100644
--- a/net/netfilter/ipvs/ip_vs_app.c
+++ b/net/netfilter/ipvs/ip_vs_app.c
@@ -572,7 +572,7 @@ static const struct file_operations ip_vs_app_fops = {
 	.open	 = ip_vs_app_open,
 	.read	 = seq_read,
 	.llseek  = seq_lseek,
-	.release = seq_release,
+	.release = seq_release_net,
 };
 #endif
 
diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index d3fd91b..bf28ac2 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -1046,7 +1046,7 @@ static const struct file_operations ip_vs_conn_fops = {
 	.open    = ip_vs_conn_open,
 	.read    = seq_read,
 	.llseek  = seq_lseek,
-	.release = seq_release,
+	.release = seq_release_net,
 };
 
 static const char *ip_vs_origin_name(unsigned flags)
@@ -1114,7 +1114,7 @@ static const struct file_operations ip_vs_conn_sync_fops = {
 	.open    = ip_vs_conn_sync_open,
 	.read    = seq_read,
 	.llseek  = seq_lseek,
-	.release = seq_release,
+	.release = seq_release_net,
 };
 
 #endif
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index ea72281..37890f2 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -2066,7 +2066,7 @@ static const struct file_operations ip_vs_info_fops = {
 	.open    = ip_vs_info_open,
 	.read    = seq_read,
 	.llseek  = seq_lseek,
-	.release = seq_release_private,
+	.release = seq_release_net,
 };
 
 #endif
@@ -2109,7 +2109,7 @@ static const struct file_operations ip_vs_stats_fops = {
 	.open = ip_vs_stats_seq_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
-	.release = single_release,
+	.release = single_release_net,
 };
 
 static int ip_vs_stats_percpu_show(struct seq_file *seq, void *v)
@@ -2178,7 +2178,7 @@ static const struct file_operations ip_vs_stats_percpu_fops = {
 	.open = ip_vs_stats_percpu_seq_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
-	.release = single_release,
+	.release = single_release_net,
 };
 #endif
 
-- 
1.7.2.5

