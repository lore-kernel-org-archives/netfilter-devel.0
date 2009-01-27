From: Jan Engelhardt <jengelh@medozas.de>
Subject: netfilter: half a patch for the pseudoregression
Date: Tue, 27 Jan 2009 23:30:37 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901272322210.31372@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50704 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbZA0Waj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Jan 2009 17:30:39 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



Here is the sample patch that fixes ip_tables_matches, but I still 
challenge the usefulness of /proc/net/ip_tables_* altogether.
Those files should have been removed, or appropriately upgraded when 
revision support was introduced.

http://picpaste.de/usefulornot_1.png

I am not fond of it, at all. Doing the same for targets - code
replication here we come. The LOC for it would have been
better spent at the previously-posted pretty-printer (knowing
that text printing meets the usual resistance).

---8<---
parent d8bf62a172295f26d960cea92aead0ce78ca524c (v2.6.29-rc2-21-gd8bf62a)
commit 3f1d7c73afeeb637ef05eba0ad7ccb55305ab8f2
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Tue Jan 27 23:21:16 2009 +0100

netfilter: make proc/net/ip_tables_matches print names from foreign NFPROTO

The ugliness this code adds could have been better spent at
a full and much more helpful dump.
---
 net/netfilter/x_tables.c |  115 +++++++++++++++++++++++++++++--------
 1 files changed, 90 insertions(+), 25 deletions(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index bfbf521..329c01c 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -827,39 +827,96 @@ static const struct file_operations xt_table_ops = {
 	.release = seq_release_net,
 };
 
-static void *xt_match_seq_start(struct seq_file *seq, loff_t *pos)
+struct match_trav {
+	struct list_head *head, *curr;
+	uint8_t class, nfproto;
+};
+
+enum {
+	MATCHTRAV_INIT,
+	MATCHTRAV_NFP_UNSPEC,
+	MATCHTRAV_NFP_SPEC,
+	MATCHTRAV_DONE,
+};
+
+static void *xt_match_seq_next(struct seq_file *seq, void *v, loff_t *ppos)
 {
-	struct proc_dir_entry *pde = (struct proc_dir_entry *)seq->private;
-	u_int16_t af = (unsigned long)pde->data;
+	static const uint8_t next_class[] = {
+		[MATCHTRAV_NFP_UNSPEC] = MATCHTRAV_NFP_SPEC,
+		[MATCHTRAV_NFP_SPEC]   = MATCHTRAV_DONE,
+	};
+	struct match_trav *trav = seq->private;
+
+	switch (trav->class) {
+	case MATCHTRAV_INIT:
+		trav->class = MATCHTRAV_NFP_UNSPEC;
+		mutex_lock(&xt[NFPROTO_UNSPEC].mutex);
+		trav->head = trav->curr = &xt[NFPROTO_UNSPEC].match;
+		break;
+	case MATCHTRAV_NFP_UNSPEC:
+		trav->curr = trav->curr->next;
+		if (trav->curr != trav->head)
+			break;
+		mutex_unlock(&xt[NFPROTO_UNSPEC].mutex);
+		mutex_lock(&xt[trav->nfproto].mutex);
+		trav->head = trav->curr = &xt[trav->nfproto].match;
+		trav->class = next_class[trav->class];
+		break;
+	case MATCHTRAV_NFP_SPEC:
+		trav->curr = trav->curr->next;
+		if (trav->curr != trav->head)
+			break;
+		/* fallthru, _stop will unlock */
+	default:
+		return NULL;
+	}
 
-	mutex_lock(&xt[af].mutex);
-	return seq_list_start(&xt[af].match, *pos);
+	if (ppos != NULL)
+		++*ppos;
+	return trav;
 }
 
-static void *xt_match_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+static void *xt_match_seq_start(struct seq_file *seq, loff_t *pos)
 {
-	struct proc_dir_entry *pde = (struct proc_dir_entry *)seq->private;
-	u_int16_t af = (unsigned long)pde->data;
+	struct match_trav *trav = seq->private;
+	unsigned int j;
 
-	return seq_list_next(v, &xt[af].match, pos);
+	trav->class = MATCHTRAV_INIT;
+	for (j = 0; j < *pos; ++j)
+		if (xt_match_seq_next(seq, NULL, NULL) == NULL)
+			return NULL;
+	return trav;
 }
 
 static void xt_match_seq_stop(struct seq_file *seq, void *v)
 {
-	struct proc_dir_entry *pde = seq->private;
-	u_int16_t af = (unsigned long)pde->data;
-
-	mutex_unlock(&xt[af].mutex);
+	struct match_trav *trav = seq->private;
+
+	switch (trav->class) {
+	case MATCHTRAV_NFP_UNSPEC:
+		mutex_unlock(&xt[NFPROTO_UNSPEC].mutex);
+		break;
+	case MATCHTRAV_NFP_SPEC:
+		mutex_unlock(&xt[trav->nfproto].mutex);
+		break;
+	}
 }
 
 static int xt_match_seq_show(struct seq_file *seq, void *v)
 {
-	struct xt_match *match = list_entry(v, struct xt_match, list);
-
-	if (strlen(match->name))
-		return seq_printf(seq, "%s\n", match->name);
-	else
-		return 0;
+	const struct match_trav *trav = seq->private;
+	const struct xt_match *match;
+
+	switch (trav->class) {
+	case MATCHTRAV_NFP_UNSPEC:
+	case MATCHTRAV_NFP_SPEC:
+		if (trav->curr == trav->head)
+			return 0;
+		match = list_entry(trav->curr, struct xt_match, list);
+		return (*match->name == '\0') ? 0 :
+		       seq_printf(seq, "%s\n", match->name);
+	}
+	return 0;
 }
 
 static const struct seq_operations xt_match_seq_ops = {
@@ -871,15 +928,23 @@ static const struct seq_operations xt_match_seq_ops = {
 
 static int xt_match_open(struct inode *inode, struct file *file)
 {
+	struct seq_file *seq;
+	struct match_trav *trav;
 	int ret;
 
-	ret = seq_open(file, &xt_match_seq_ops);
-	if (!ret) {
-		struct seq_file *seq = file->private_data;
+	trav = kmalloc(sizeof(*trav), GFP_KERNEL);
+	if (trav == NULL)
+		return -ENOMEM;
 
-		seq->private = PDE(inode);
+	ret = seq_open(file, &xt_match_seq_ops);
+	if (ret < 0) {
+		kfree(trav);
+		return ret;
 	}
-	return ret;
+
+	seq = file->private_data;
+	seq->private = trav;
+	return 0;
 }
 
 static const struct file_operations xt_match_ops = {
@@ -887,7 +952,7 @@ static const struct file_operations xt_match_ops = {
 	.open	 = xt_match_open,
 	.read	 = seq_read,
 	.llseek	 = seq_lseek,
-	.release = seq_release,
+	.release = seq_release_private,
 };
 
 static void *xt_target_seq_start(struct seq_file *seq, loff_t *pos)
-- 
# Created with git-export-patch
