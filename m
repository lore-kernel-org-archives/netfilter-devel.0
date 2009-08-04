From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 058/103] netfilter: xtables2: jumpstack (de)allocation functions
Date: Tue,  4 Aug 2009 09:25:42 +0200
Message-ID: <1249370787-17583-59-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56942 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932570AbZHDH1f (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:27:35 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h |   13 ++++++
 net/netfilter/x_tables.c           |   76 +++++++++++++++++++++++++++++++++++-
 2 files changed, 88 insertions(+), 1 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index bba75b2..f94820c 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -508,6 +508,14 @@ enum {
  * @chain_list:		list of chains (struct xt2_chain)
  * @name:		name of this table
  * @nfproto:		nfproto the table is used exclusively with
+ * @rq_stacksize:	Size of the jumpstack. This is usually set to the
+ * 			number of user chains -- since tables cannot have
+ * 			loops, at most that many jumps can possibly be made --
+ * 			or a value dependent thereof, such as when it is
+ * 			multiplied to allow for reentry.
+ * @stacksize:		current size of the stack (@stackptr, @jumpstack)
+ * @stackptr:		current stack pointer, one per CPU
+ * @jumpstack:		our stack, also one per CPU
  * @entrypoint:		start chains for hooks
  * @underflow:		base chain policy (rule)
  * @owner:		encompassing module
@@ -516,6 +524,11 @@ struct xt2_table {
 	struct list_head chain_list;
 	char name[11];
 	uint8_t nfproto;
+
+	unsigned int rq_stacksize, stacksize;
+	unsigned int *stackptr;
+	const struct xt2_rule ***jumpstack;
+
 	const struct xt2_chain *entrypoint[NF_INET_NUMHOOKS];
 	const struct xt2_rule *underflow[NF_INET_NUMHOOKS];
 	struct module *owner;
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 6e6ff1c..574d562 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1513,6 +1513,7 @@ struct xt2_chain *xt2_chain_new(struct xt2_table *table, const char *name)
 	if (chain == NULL)
 		return NULL;
 
+	++table->rq_stacksize;
 	chain->table = table;
 	INIT_LIST_HEAD(&chain->anchor);
 	INIT_LIST_HEAD(&chain->rule_list);
@@ -1541,11 +1542,79 @@ static void xt2_chain_free(struct xt2_chain *chain)
 	struct xt2_rule *rule, *next_rule;
 
 	list_del(&chain->anchor);
+	--chain->table->rq_stacksize;
 	list_for_each_entry_safe(rule, next_rule, &chain->rule_list, anchor)
 		xt2_rule_free(rule);
 	kfree(chain);
 }
 
+/**
+ * Allocate jumpstacks. This is normally called sometime after the chain
+ * have all been added to the table.
+ */
+static int xt2_jumpstack_alloc(struct xt2_table *table)
+{
+	unsigned int size;
+	int cpu;
+
+	size = sizeof(unsigned int) * nr_cpu_ids;
+	if (size > PAGE_SIZE)
+		table->stackptr = vmalloc(size);
+	else
+		table->stackptr = kmalloc(size, GFP_KERNEL);
+	if (table->stackptr == NULL)
+		return -ENOMEM;
+	memset(table->stackptr, 0, size);
+
+	size = sizeof(struct xt2_rule **) * nr_cpu_ids;
+	if (size > PAGE_SIZE)
+		table->jumpstack = vmalloc(size);
+	else
+		table->jumpstack = kmalloc(size, GFP_KERNEL);
+	if (table->jumpstack == NULL)
+		return -ENOMEM;
+	memset(table->jumpstack, 0, size);
+
+	table->stacksize = table->rq_stacksize * xt_jumpstack_multiplier;
+	size = sizeof(struct xt2_rule *) * table->stacksize;
+	for_each_possible_cpu(cpu) {
+		if (size > PAGE_SIZE)
+			table->jumpstack[cpu] = vmalloc_node(size,
+				cpu_to_node(cpu));
+		else
+			table->jumpstack[cpu] = kmalloc_node(size,
+				GFP_KERNEL, cpu_to_node(cpu));
+		if (table->jumpstack[cpu] == NULL)
+			return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static void xt2_jumpstack_free(struct xt2_table *table)
+{
+	int cpu;
+
+	if (table->jumpstack != NULL) {
+		if (sizeof(struct xt2_rule *) * table->stacksize > PAGE_SIZE) {
+			for_each_possible_cpu(cpu)
+				vfree(table->jumpstack[cpu]);
+		} else {
+			for_each_possible_cpu(cpu)
+				kfree(table->jumpstack[cpu]);
+		}
+		if (sizeof(struct xt2_rule **) * nr_cpu_ids > PAGE_SIZE)
+			vfree(table->jumpstack);
+		else
+			kfree(table->jumpstack);
+	}
+
+	if (sizeof(unsigned int) * nr_cpu_ids > PAGE_SIZE)
+		vfree(table->stackptr);
+	else
+		kfree(table->stackptr);
+}
+
 struct xt2_table *xt2_table_new(void)
 {
 	struct xt2_table *table;
@@ -1587,7 +1656,7 @@ EXPORT_SYMBOL_GPL(xt2_tlink_lookup);
 int xt2_table_register(struct net *net, struct xt2_table *table)
 {
 	struct xt2_table_link *link;
-	int ret = 0;
+	int ret;
 
 	if (*table->name == '\0')
 		/* Empty names don't fly with our strcmp. */
@@ -1600,6 +1669,10 @@ int xt2_table_register(struct net *net, struct xt2_table *table)
 		goto out;
 	}
 
+	ret = xt2_jumpstack_alloc(table);
+	if (ret < 0)
+		goto out;
+
 	link = kmalloc(sizeof(*link), GFP_KERNEL);
 	if (link == NULL) {
 		ret = -ENOMEM;
@@ -1683,6 +1756,7 @@ void xt2_table_destroy(struct net *net, struct xt2_table *table)
 	if (net != NULL)
 		xt2_table_unregister(net, table);
 
+	xt2_jumpstack_free(table);
 	list_for_each_entry_safe(chain, next_chain, &table->chain_list, anchor)
 		xt2_chain_free(chain);
 	kfree(table);
-- 
1.6.3.3

