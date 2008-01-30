From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/69]: Supress some sparse warnings
Date: Wed, 30 Jan 2008 21:16:54 +0100 (MET)
Message-ID: <20080130201651.29874.55097.sendpatchset@localhost.localdomain>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60624 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933427AbYA3UQz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:16:55 -0500
In-Reply-To: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: Supress some sparse warnings

  CHECK   net/netfilter/nf_conntrack_expect.c
net/netfilter/nf_conntrack_expect.c:429:13: warning: context imbalance in 'exp_seq_start' - wrong count at exit
net/netfilter/nf_conntrack_expect.c:441:13: warning: context imbalance in 'exp_seq_stop' - unexpected unlock
  CHECK   net/netfilter/nf_log.c
net/netfilter/nf_log.c:105:13: warning: context imbalance in 'seq_start' - wrong count at exit
net/netfilter/nf_log.c:125:13: warning: context imbalance in 'seq_stop' - unexpected unlock
  CHECK   net/netfilter/nfnetlink_queue.c
net/netfilter/nfnetlink_queue.c:363:7: warning: symbol 'size' shadows an earlier one
net/netfilter/nfnetlink_queue.c:217:9: originally declared here
net/netfilter/nfnetlink_queue.c:847:13: warning: context imbalance in 'seq_start' - wrong count at exit
net/netfilter/nfnetlink_queue.c:859:13: warning: context imbalance in 'seq_stop' - unexpected unlock

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 529b54d47425038bf231b8ce446447e957b3c89d
tree 939739c042fb1ec1423af3794e14dc9304b5c3fe
parent dd430ca20c40ecccd6954a7efd13d4398f507728
author Eric Dumazet <dada1@cosmosbay.com> Tue, 29 Jan 2008 16:21:48 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 15:04:11 +0100

 net/netfilter/nf_conntrack_expect.c |    2 ++
 net/netfilter/nf_log.c              |    2 ++
 net/netfilter/nfnetlink_queue.c     |    6 ++++--
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index e0cd9d0..e405079 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -427,6 +427,7 @@ static struct hlist_node *ct_expect_get_idx(struct seq_file *seq, loff_t pos)
 }
 
 static void *exp_seq_start(struct seq_file *seq, loff_t *pos)
+	__acquires(nf_conntrack_lock)
 {
 	read_lock_bh(&nf_conntrack_lock);
 	return ct_expect_get_idx(seq, *pos);
@@ -439,6 +440,7 @@ static void *exp_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 }
 
 static void exp_seq_stop(struct seq_file *seq, void *v)
+	__releases(nf_conntrack_lock)
 {
 	read_unlock_bh(&nf_conntrack_lock);
 }
diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index 4f5f288..cec9976 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -103,6 +103,7 @@ EXPORT_SYMBOL(nf_log_packet);
 
 #ifdef CONFIG_PROC_FS
 static void *seq_start(struct seq_file *seq, loff_t *pos)
+	__acquires(RCU)
 {
 	rcu_read_lock();
 
@@ -123,6 +124,7 @@ static void *seq_next(struct seq_file *s, void *v, loff_t *pos)
 }
 
 static void seq_stop(struct seq_file *s, void *v)
+	__releases(RCU)
 {
 	rcu_read_unlock();
 }
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 51476f8..a48b20f 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -360,7 +360,7 @@ nfqnl_build_packet_message(struct nfqnl_instance *queue,
 
 	if (data_len) {
 		struct nlattr *nla;
-		int size = nla_attr_size(data_len);
+		int sz = nla_attr_size(data_len);
 
 		if (skb_tailroom(skb) < nla_total_size(data_len)) {
 			printk(KERN_WARNING "nf_queue: no tailroom!\n");
@@ -369,7 +369,7 @@ nfqnl_build_packet_message(struct nfqnl_instance *queue,
 
 		nla = (struct nlattr *)skb_put(skb, nla_total_size(data_len));
 		nla->nla_type = NFQA_PAYLOAD;
-		nla->nla_len = size;
+		nla->nla_len = sz;
 
 		if (skb_copy_bits(entskb, 0, nla_data(nla), data_len))
 			BUG();
@@ -845,6 +845,7 @@ static struct hlist_node *get_idx(struct seq_file *seq, loff_t pos)
 }
 
 static void *seq_start(struct seq_file *seq, loff_t *pos)
+	__acquires(instances_lock)
 {
 	spin_lock(&instances_lock);
 	return get_idx(seq, *pos);
@@ -857,6 +858,7 @@ static void *seq_next(struct seq_file *s, void *v, loff_t *pos)
 }
 
 static void seq_stop(struct seq_file *s, void *v)
+	__releases(instances_lock)
 {
 	spin_unlock(&instances_lock);
 }
