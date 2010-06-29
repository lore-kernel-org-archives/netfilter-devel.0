From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 32/56] netfilter: xtables: turn procfs entries to walk xt2 table list
Date: Tue, 29 Jun 2010 10:43:12 +0200
Message-ID: <1277801017-30600-33-git-send-email-jengelh@medozas.de>
References: <1277801017-30600-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44304 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754284Ab0F2IoP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jun 2010 04:44:15 -0400
In-Reply-To: <1277801017-30600-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This commit makes /proc/net/ip6_tables_names traverse the xt2 table
list instead of the xt1 one. Developer note: Until the remaining xt1
tables are changed to xt2 (a few commits ahead), they will not show
up momentarily.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/netfilter/x_tables.c |   24 ++++++++++--------------
 1 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index f4fce99..017f8d1 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -921,39 +921,35 @@ struct xt_names_priv {
 };
 static void *xt_table_seq_start(struct seq_file *seq, loff_t *pos)
 {
-	struct xt_names_priv *priv = seq->private;
+	const struct xt_names_priv *priv = seq->private;
 	struct net *net = seq_file_net(seq);
 	u_int8_t af = priv->af;
 
-	mutex_lock(&xt[af].mutex);
-	return seq_list_start(&net->xt.tables[af], *pos);
+	rcu_read_lock();
+	return seq_list_start(&net->xt2.table_list[af], *pos);
 }
 
 static void *xt_table_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
-	struct xt_names_priv *priv = seq->private;
+	const struct xt_names_priv *priv = seq->private;
 	struct net *net = seq_file_net(seq);
 	u_int8_t af = priv->af;
 
-	return seq_list_next(v, &net->xt.tables[af], pos);
+	return seq_list_next(v, &net->xt2.table_list[af], pos);
 }
 
 static void xt_table_seq_stop(struct seq_file *seq, void *v)
 {
-	struct xt_names_priv *priv = seq->private;
-	u_int8_t af = priv->af;
-
-	mutex_unlock(&xt[af].mutex);
+	rcu_read_unlock();
 }
 
 static int xt_table_seq_show(struct seq_file *seq, void *v)
 {
-	struct xt_table *table = list_entry(v, struct xt_table, list);
+	const struct xt2_table_link *link =
+		list_entry_rcu(v, typeof(*link), anchor);
+	const struct xt2_table *table = rcu_dereference(link->table);
 
-	if (strlen(table->name))
-		return seq_printf(seq, "%s\n", table->name);
-	else
-		return 0;
+	return seq_printf(seq, "%s\n", table->name);
 }
 
 static const struct seq_operations xt_table_seq_ops = {
-- 
1.7.1

