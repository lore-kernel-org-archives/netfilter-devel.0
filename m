From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 54/69]: x_tables: netns propagation for /proc/net/*_tables_names
Date: Wed, 30 Jan 2008 21:18:17 +0100 (MET)
Message-ID: <20080130201814.29874.66046.sendpatchset@localhost.localdomain>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60801 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765314AbYA3USS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:18:18 -0500
In-Reply-To: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: x_tables: netns propagation for /proc/net/*_tables_names

Propagate netns together with AF down to ->start/->next/->stop
iterators. Choose table based on netns and AF for showing.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 513f43dcb3326e0f5273191d368a17585e865afc
tree 33e9aa9f7a1a993512840fc84708167ac9d62cf6
parent 738a61f2bcd7ded174cdac25f330e7bb1e3fb2c5
author Alexey Dobriyan <adobriyan@sw.ru> Wed, 30 Jan 2008 21:03:13 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 21:03:13 +0100

 net/netfilter/x_tables.c |   31 +++++++++++++++++++------------
 1 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 89e322d..12ed64c 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -720,27 +720,33 @@ void *xt_unregister_table(struct xt_table *table)
 EXPORT_SYMBOL_GPL(xt_unregister_table);
 
 #ifdef CONFIG_PROC_FS
+struct xt_names_priv {
+	struct seq_net_private p;
+	int af;
+};
 static void *xt_table_seq_start(struct seq_file *seq, loff_t *pos)
 {
-	struct proc_dir_entry *pde = (struct proc_dir_entry *)seq->private;
-	u_int16_t af = (unsigned long)pde->data;
+	struct xt_names_priv *priv = seq->private;
+	struct net *net = priv->p.net;
+	int af = priv->af;
 
 	mutex_lock(&xt[af].mutex);
-	return seq_list_start(&init_net.xt.tables[af], *pos);
+	return seq_list_start(&net->xt.tables[af], *pos);
 }
 
 static void *xt_table_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
-	struct proc_dir_entry *pde = (struct proc_dir_entry *)seq->private;
-	u_int16_t af = (unsigned long)pde->data;
+	struct xt_names_priv *priv = seq->private;
+	struct net *net = priv->p.net;
+	int af = priv->af;
 
-	return seq_list_next(v, &init_net.xt.tables[af], pos);
+	return seq_list_next(v, &net->xt.tables[af], pos);
 }
 
 static void xt_table_seq_stop(struct seq_file *seq, void *v)
 {
-	struct proc_dir_entry *pde = seq->private;
-	u_int16_t af = (unsigned long)pde->data;
+	struct xt_names_priv *priv = seq->private;
+	int af = priv->af;
 
 	mutex_unlock(&xt[af].mutex);
 }
@@ -765,12 +771,13 @@ static const struct seq_operations xt_table_seq_ops = {
 static int xt_table_open(struct inode *inode, struct file *file)
 {
 	int ret;
+	struct xt_names_priv *priv;
 
-	ret = seq_open(file, &xt_table_seq_ops);
+	ret = seq_open_net(inode, file, &xt_table_seq_ops,
+			   sizeof(struct xt_names_priv));
 	if (!ret) {
-		struct seq_file *seq = file->private_data;
-
-		seq->private = PDE(inode);
+		priv = ((struct seq_file *)file->private_data)->private;
+		priv->af = (unsigned long)PDE(inode)->data;
 	}
 	return ret;
 }
