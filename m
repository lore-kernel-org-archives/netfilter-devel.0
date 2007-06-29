From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 12/20]: nf_conntrack_expect: convert proc functions to
	hash
Date: Fri, 29 Jun 2007 02:45:13 +0200 (MEST)
Message-ID: <20070629004411.25566.70642.sendpatchset@localhost.localdomain>
References: <20070629004354.25566.59266.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070629004354.25566.59266.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack_expect: convert proc functions to hash

Convert from the global expectation list to the hash table.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 2141115bac5b86840c97aef9b6a2481764de4779
tree 3d44abbae53da5366b11b298dfc3509590a0e678
parent 6c6d2912994c266361333f8d904b5e10dc21b5f7
author Patrick McHardy <kaber@trash.net> Fri, 29 Jun 2007 02:15:52 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 29 Jun 2007 02:15:52 +0200

 .../netfilter/nf_conntrack_l3proto_ipv4_compat.c   |   83 ++++++++++++++++------
 net/netfilter/nf_conntrack_expect.c                |   85 ++++++++++++++------
 2 files changed, 121 insertions(+), 47 deletions(-)

diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
index 12d6a63..ab8e4c6 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
@@ -207,47 +207,68 @@ static const struct file_operations ct_file_ops = {
 };
 
 /* expects */
-static void *exp_seq_start(struct seq_file *s, loff_t *pos)
+struct ct_expect_iter_state {
+	unsigned int bucket;
+};
+
+static struct hlist_node *ct_expect_get_first(struct seq_file *seq)
 {
-	struct list_head *e = &nf_ct_expect_list;
-	loff_t i;
+	struct ct_expect_iter_state *st = seq->private;
 
-	/* strange seq_file api calls stop even if we fail,
-	 * thus we need to grab lock since stop unlocks */
-	read_lock_bh(&nf_conntrack_lock);
+	for (st->bucket = 0; st->bucket < nf_ct_expect_hsize; st->bucket++) {
+		if (!hlist_empty(&nf_ct_expect_hash[st->bucket]))
+			return nf_ct_expect_hash[st->bucket].first;
+	}
+	return NULL;
+}
 
-	if (list_empty(e))
-		return NULL;
+static struct hlist_node *ct_expect_get_next(struct seq_file *seq,
+					     struct hlist_node *head)
+{
+	struct ct_expect_iter_state *st = seq->private;
 
-	for (i = 0; i <= *pos; i++) {
-		e = e->next;
-		if (e == &nf_ct_expect_list)
+	head = head->next;
+	while (head == NULL) {
+		if (++st->bucket >= nf_ct_expect_hsize)
 			return NULL;
+		head = nf_ct_expect_hash[st->bucket].first;
 	}
-	return e;
+	return head;
 }
 
-static void *exp_seq_next(struct seq_file *s, void *v, loff_t *pos)
+static struct hlist_node *ct_expect_get_idx(struct seq_file *seq, loff_t pos)
 {
-	struct list_head *e = v;
+	struct hlist_node *head = ct_expect_get_first(seq);
 
-	++*pos;
-	e = e->next;
+	if (head)
+		while (pos && (head = ct_expect_get_next(seq, head)))
+			pos--;
+	return pos ? NULL : head;
+}
 
-	if (e == &nf_ct_expect_list)
-		return NULL;
+static void *exp_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	read_lock_bh(&nf_conntrack_lock);
+	return ct_expect_get_idx(seq, *pos);
+}
 
-	return e;
+static void *exp_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	(*pos)++;
+	return ct_expect_get_next(seq, v);
 }
 
-static void exp_seq_stop(struct seq_file *s, void *v)
+static void exp_seq_stop(struct seq_file *seq, void *v)
 {
 	read_unlock_bh(&nf_conntrack_lock);
 }
 
 static int exp_seq_show(struct seq_file *s, void *v)
 {
-	struct nf_conntrack_expect *exp = v;
+	struct nf_conntrack_expect *exp;
+	struct hlist_node *n = v;
+
+	exp = hlist_entry(n, struct nf_conntrack_expect, hnode);
 
 	if (exp->tuple.src.l3num != AF_INET)
 		return 0;
@@ -276,7 +297,23 @@ static struct seq_operations exp_seq_ops = {
 
 static int exp_open(struct inode *inode, struct file *file)
 {
-	return seq_open(file, &exp_seq_ops);
+	struct seq_file *seq;
+	struct ct_expect_iter_state *st;
+	int ret;
+
+	st = kmalloc(sizeof(struct ct_expect_iter_state), GFP_KERNEL);
+	if (st == NULL)
+		return -ENOMEM;
+	ret = seq_open(file, &exp_seq_ops);
+	if (ret)
+		goto out_free;
+	seq          = file->private_data;
+	seq->private = st;
+	memset(st, 0, sizeof(struct ct_expect_iter_state));
+	return ret;
+out_free:
+	kfree(st);
+	return ret;
 }
 
 static const struct file_operations ip_exp_file_ops = {
@@ -284,7 +321,7 @@ static const struct file_operations ip_exp_file_ops = {
 	.open    = exp_open,
 	.read    = seq_read,
 	.llseek  = seq_lseek,
-	.release = seq_release
+	.release = seq_release_private,
 };
 
 static void *ct_cpu_seq_start(struct seq_file *seq, loff_t *pos)
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index d92f817..0e61c69 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -377,47 +377,68 @@ out:
 EXPORT_SYMBOL_GPL(nf_ct_expect_related);
 
 #ifdef CONFIG_PROC_FS
-static void *exp_seq_start(struct seq_file *s, loff_t *pos)
+struct ct_expect_iter_state {
+	unsigned int bucket;
+};
+
+static struct hlist_node *ct_expect_get_first(struct seq_file *seq)
 {
-	struct list_head *e = &nf_ct_expect_list;
-	loff_t i;
+	struct ct_expect_iter_state *st = seq->private;
 
-	/* strange seq_file api calls stop even if we fail,
-	 * thus we need to grab lock since stop unlocks */
-	read_lock_bh(&nf_conntrack_lock);
+	for (st->bucket = 0; st->bucket < nf_ct_expect_hsize; st->bucket++) {
+		if (!hlist_empty(&nf_ct_expect_hash[st->bucket]))
+			return nf_ct_expect_hash[st->bucket].first;
+	}
+	return NULL;
+}
 
-	if (list_empty(e))
-		return NULL;
+static struct hlist_node *ct_expect_get_next(struct seq_file *seq,
+					     struct hlist_node *head)
+{
+	struct ct_expect_iter_state *st = seq->private;
 
-	for (i = 0; i <= *pos; i++) {
-		e = e->next;
-		if (e == &nf_ct_expect_list)
+	head = head->next;
+	while (head == NULL) {
+		if (++st->bucket >= nf_ct_expect_hsize)
 			return NULL;
+		head = nf_ct_expect_hash[st->bucket].first;
 	}
-	return e;
+	return head;
 }
 
-static void *exp_seq_next(struct seq_file *s, void *v, loff_t *pos)
+static struct hlist_node *ct_expect_get_idx(struct seq_file *seq, loff_t pos)
 {
-	struct list_head *e = v;
+	struct hlist_node *head = ct_expect_get_first(seq);
 
-	++*pos;
-	e = e->next;
+	if (head)
+		while (pos && (head = ct_expect_get_next(seq, head)))
+			pos--;
+	return pos ? NULL : head;
+}
 
-	if (e == &nf_ct_expect_list)
-		return NULL;
+static void *exp_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	read_lock_bh(&nf_conntrack_lock);
+	return ct_expect_get_idx(seq, *pos);
+}
 
-	return e;
+static void *exp_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	(*pos)++;
+	return ct_expect_get_next(seq, v);
 }
 
-static void exp_seq_stop(struct seq_file *s, void *v)
+static void exp_seq_stop(struct seq_file *seq, void *v)
 {
 	read_unlock_bh(&nf_conntrack_lock);
 }
 
 static int exp_seq_show(struct seq_file *s, void *v)
 {
-	struct nf_conntrack_expect *expect = v;
+	struct nf_conntrack_expect *expect;
+	struct hlist_node *n = v;
+
+	expect = hlist_entry(n, struct nf_conntrack_expect, hnode);
 
 	if (expect->timeout.function)
 		seq_printf(s, "%ld ", timer_pending(&expect->timeout)
@@ -443,15 +464,31 @@ static struct seq_operations exp_seq_ops = {
 
 static int exp_open(struct inode *inode, struct file *file)
 {
-	return seq_open(file, &exp_seq_ops);
+	struct seq_file *seq;
+	struct ct_expect_iter_state *st;
+	int ret;
+
+	st = kmalloc(sizeof(struct ct_expect_iter_state), GFP_KERNEL);
+	if (st == NULL)
+		return -ENOMEM;
+	ret = seq_open(file, &exp_seq_ops);
+	if (ret)
+		goto out_free;
+	seq          = file->private_data;
+	seq->private = st;
+	memset(st, 0, sizeof(struct ct_expect_iter_state));
+	return ret;
+out_free:
+	kfree(st);
+	return ret;
 }
 
-const struct file_operations exp_file_ops = {
+static const struct file_operations exp_file_ops = {
 	.owner   = THIS_MODULE,
 	.open    = exp_open,
 	.read    = seq_read,
 	.llseek  = seq_lseek,
-	.release = seq_release
+	.release = seq_release_private,
 };
 #endif /* CONFIG_PROC_FS */
 
