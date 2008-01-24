From: Stephen Hemminger <shemminger@vyatta.com>
Subject: [PATCH 4/8] netfilter: more sparse warning fixes
Date: Thu, 24 Jan 2008 10:15:40 -0800
Message-ID: <20080124181628.238890645@vyatta.com>
References: <20080124181536.446214111@vyatta.com>
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.vyatta.com ([216.93.170.194]:48247 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753380AbYAXSYU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jan 2008 13:24:20 -0500
Content-Disposition: inline; filename=nf-queue-sparse.patch
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Get rif of sparse warnings about variable overlap, and locking.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>


--- a/net/netfilter/nfnetlink_log.c	2008-01-23 10:04:58.000000000 -0800
+++ b/net/netfilter/nfnetlink_log.c	2008-01-23 10:05:15.000000000 -0800
@@ -866,6 +866,7 @@ static struct hlist_node *get_idx(struct
 }
 
 static void *seq_start(struct seq_file *seq, loff_t *pos)
+	__acquires(instances_lock)
 {
 	read_lock_bh(&instances_lock);
 	return get_idx(seq->private, *pos);
@@ -878,6 +879,7 @@ static void *seq_next(struct seq_file *s
 }
 
 static void seq_stop(struct seq_file *s, void *v)
+	__releases(instances_lock)
 {
 	read_unlock_bh(&instances_lock);
 }
--- a/net/netfilter/nfnetlink_queue.c	2008-01-23 10:04:00.000000000 -0800
+++ b/net/netfilter/nfnetlink_queue.c	2008-01-23 10:04:43.000000000 -0800
@@ -360,7 +360,7 @@ nfqnl_build_packet_message(struct nfqnl_
 
 	if (data_len) {
 		struct nlattr *nla;
-		int size = nla_attr_size(data_len);
+		size = nla_attr_size(data_len);
 
 		if (skb_tailroom(skb) < nla_total_size(data_len)) {
 			printk(KERN_WARNING "nf_queue: no tailroom!\n");
@@ -845,6 +845,7 @@ static struct hlist_node *get_idx(struct
 }
 
 static void *seq_start(struct seq_file *seq, loff_t *pos)
+	__acquires(instances_lock)
 {
 	spin_lock(&instances_lock);
 	return get_idx(seq, *pos);
@@ -857,6 +858,7 @@ static void *seq_next(struct seq_file *s
 }
 
 static void seq_stop(struct seq_file *s, void *v)
+	__releases(instances_lock)
 {
 	spin_unlock(&instances_lock);
 }

-- 
Stephen Hemminger <stephen.hemminger@vyatta.com>

