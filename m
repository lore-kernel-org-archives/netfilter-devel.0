From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 04/11] netfilter: xtables2: core part for splice operation
Date: Fri, 16 Nov 2012 02:23:38 +0100
Message-ID: <1353029025-31635-5-git-send-email-jengelh@inai.de>
References: <1353029025-31635-1-git-send-email-jengelh@inai.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:45173 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433Ab2KPBXx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Nov 2012 20:23:53 -0500
In-Reply-To: <1353029025-31635-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This adds the function for rule splicing within a chain. It is
versatile to do both deletion and insertion of a group of rules at
once.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 include/net/netfilter/xt_core.h |   58 ++++++++
 net/netfilter/xt_core.c         |  303 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 359 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/xt_core.h b/include/net/netfilter/xt_core.h
index 8139977..ae55b3b 100644
--- a/include/net/netfilter/xt_core.h
+++ b/include/net/netfilter/xt_core.h
@@ -4,6 +4,38 @@
 #include <linux/list.h>
 #include <linux/mutex.h>
 #include <linux/rcupdate.h>
+#include <uapi/linux/netfilter/x_tables.h> /* for _xt_align */
+
+/*
+ * For internal structures not exported to userspace, we can align
+ * to whatever is convenient and need not use aligned(8).
+ */
+#define __xt_int_aligned \
+	__attribute__((aligned(__alignof__(struct _xt_align))))
+#define xt2_chain_stop_rule(chain_block) \
+	((struct xt2_packed_rule *)((chain_block)->data + (chain_block)->size))
+#define xt2_chain_next_rule(rule) \
+	((struct xt2_packed_rule *)((rule)->data + (rule)->dsize))
+#define xt2_foreach_rule(rule, chain_block) \
+	for ((rule) = ((chain_block) == NULL) ? NULL : \
+	              (struct xt2_packed_rule *)(chain_block)->data; \
+	     (rule) != NULL && (rule) < xt2_chain_stop_rule(chain_block); \
+	     (rule) = xt2_chain_next_rule(rule))
+
+/**
+ * Misc constants.
+ *
+ * %XT_CHAIN_SPLICE_APPEND may be used for the "offset" parameter of
+ * xt2_chain_splice() to mean the last position. The "dlength" parameter
+ * must be 0 (since there are no rules to delete after the last rule anyway).
+ *
+ * %XT_CHAIN_SPLICE_FLUSH may be used for the "dlength" parameter of
+ * xt2_chain_splice() to indicate deleting all rules.
+ */
+enum {
+	XT_CHAIN_SPLICE_APPEND = -1,
+	XT_CHAIN_SPLICE_FLUSH  = -1,
+};
 
 /**
  * @master:	the master table
@@ -24,16 +56,40 @@ struct xt2_table {
 };
 
 /**
+ * We can't have "void __rcu *rules" directly in struct xt2_chain, because
+ * then any accompanying size field would not be under RCU. With this
+ * structure, we also follow up on the xt2_p_chain idea from the commit
+ * "netfilter: xtables2: chain renaming support". (Recheck!)
+ */
+struct xt2_rcu_block {
+	struct rcu_head rcu;
+	size_t size;
+	char data[] __xt_int_aligned;
+};
+
+/**
+ * @rules:	serialized stream of "struct xt2_packed_rule"s
  * @anchor:	list anchor for parent (struct xt2_table.chain_list)
  * @name:	name of chain
  * @rcu:	rcu head for delayed deletion
  */
 struct xt2_chain {
+	struct xt2_rcu_block __rcu *rules;
 	struct list_head anchor;
 	char name[48];
 	struct rcu_head rcu;
 };
 
+/**
+ * This structure provides a "view" into chain->rules.
+ * @dsize:	size of the data block
+ * @data:	packed data of action (match, target) data
+ */
+struct xt2_packed_rule {
+	unsigned int dsize;
+	char data[] __xt_int_aligned;
+};
+
 struct net;
 struct xt2_proto_rule;
 struct xt2_rule_buffer;
@@ -54,6 +110,8 @@ extern struct xt2_chain *xt2_chain_move(struct xt2_table *, const char *,
 					const char *);
 extern struct xt2_chain *xt2_chain_dup(struct xt2_table *,
 				       const struct xt2_chain *);
+extern int xt2_chain_splice(struct xt2_chain *, struct xt2_rule_buffer *,
+			    unsigned int, unsigned int);
 
 extern struct xt2_table *xt2_table_new(void);
 extern void xt2_table_free(struct xt2_table *);
diff --git a/net/netfilter/xt_core.c b/net/netfilter/xt_core.c
index 5921355..7b5d48d 100644
--- a/net/netfilter/xt_core.c
+++ b/net/netfilter/xt_core.c
@@ -16,18 +16,31 @@
 #include <linux/rculist.h>
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <linux/vmalloc.h>
+#include <linux/workqueue.h>
+#include <linux/netfilter/x_tables.h>
 #include <net/net_namespace.h>
 #include <net/netns/generic.h>
 #include <net/netfilter/xt_core.h>
 #include "xt_nfnetlink.h"
 
+#define xt2_foreach_rule_continue(rule, chain) \
+	for (; \
+	     (rule) != NULL && (rule) < xt2_chain_stop_rule(chain); \
+	     (rule) = xt2_chain_next_rule(rule))
+
 /**
  * A "prototype" rule is a data structure that collects a rule's match and
  * target parameters in a simple linked list - in principle anything that can
  * be easily appended to - until the rule is packed later.
+ *
+ * @anchor:		for parent xt2_rule_buffer
+ * @packed_size:	projected size for packed rule
+ * 			(without xt2_packed_rule header)
  */
 struct xt2_proto_rule {
 	struct list_head anchor;
+	unsigned int packed_size;
 };
 
 /**
@@ -42,6 +55,35 @@ struct xt2_rule_buffer {
 	struct list_head rule_list;
 };
 
+/**
+ * @chain:		chain to operate on
+ * @rule_list:		list of new rules
+ * @i_offset:		rule offset to start splicing at
+ * @b_offset:		byte offset to start splicing at
+ * 			(derived from i_offset)
+ * @i_delete:		number of rules to remove starting from splice point
+ * @b_delete:		length of deletion segment in bytes
+ * @b_insert:		length of insertion segment in bytes
+ */
+struct xt2_splice_state {
+	const struct xt2_chain *chain;
+	struct list_head *rule_list;
+	unsigned int i_offset, i_delete;
+	size_t b_offset, b_delete, b_insert;
+};
+
+/**
+ * A data structure at the end of the @chain->rules blob used for
+ * delayed deletion by means of RCU/WQ.
+ *
+ * @rcu:	storage for call_rcu
+ * @rules:	pointer to the start of the block
+ */
+struct xt2_blob_kill {
+	struct rcu_head rcu;
+	void *rules;
+};
+
 MODULE_DESCRIPTION("Netfilter Xtables2 packet filtering");
 MODULE_AUTHOR("Jan Engelhardt");
 MODULE_LICENSE("GPL");
@@ -99,6 +141,98 @@ void xt2_rulebuf_free(struct xt2_rule_buffer *rb)
 	kfree(rb);
 }
 
+static void xt2_blob_vfree(struct work_struct *work)
+{
+	vfree(work);
+}
+
+/**
+ * We are using vmalloc to hold the packed rule set, but freeing vmalloc areas
+ * may sleep (IIRC), so a dedicated work queue item is needed to get rid of an
+ * old block. Since the rules are no longer in use by the time this function is
+ * executed, the entire space can just be reused for the work_struct.
+ */
+static void xt2_blob_free(struct rcu_head *rcu)
+{
+	void *blob = container_of(rcu, struct xt2_rcu_block, rcu);
+	struct work_struct *work = blob;
+
+	INIT_WORK(work, xt2_blob_vfree);
+	schedule_work(work);
+}
+
+/**
+ * @oldp:	current blob
+ * @old_size:	current size
+ * @offset:	offset at which the operation is to be made
+ * @change:	negative to remove @change bytes at @offset,
+ * 		positive to add a hole of @change bytes.
+ *
+ * Shrinks/enlarges the input blob by allocating a new memory block and
+ * copying it over. (Freeing is done in the caller.)
+ */
+static void *
+xt2_blob_renew(struct xt2_rcu_block *oldp, size_t offset, ssize_t change)
+{
+	struct xt2_rcu_block *newp;
+	size_t old_size = (oldp != NULL) ? oldp->size : 0;
+	void *old_data = (oldp != NULL) ? oldp->data : NULL;
+	size_t new_size, act_size;
+
+	if (old_data == NULL && offset > 0) {
+		/*
+		 * If there is no rule blob, we cannot delete from the
+		 * middle of it.
+		 */
+		WARN_ON(old_data == NULL && offset > 0);
+		return NULL;
+	}
+	/*
+	 * change==0 is valid case. It happens when a set of rules is deleted
+	 * and a different set of same byte size is put into its place instead.
+	 * And we do need to obtain a new memory block in any case, because the
+	 * old block is potentially still active in some RCU reader.
+	 */
+	if (change < 0 && offset - change > old_size) {
+		/* Cannot take away more than there is. */
+		WARN_ON(offset - change > old_size);
+		return ERR_PTR(-EIO);
+	}
+	new_size = old_size + change;
+	if (new_size == 0)
+		/* If there are no rules in it, no blob will be needed. */
+		return NULL;
+
+	/*
+	 * Add extra room for the prepended xt2_rcu_block, and make sure the
+	 * region is big enough to hold a work_struct as well.
+	 * (See xt2_blob_free.)
+	 */
+	act_size = new_size + XT_ALIGN(sizeof(*newp));
+	if (act_size < sizeof(struct work_struct))
+		act_size = sizeof(struct work_struct);
+	newp = vmalloc(act_size);
+	if (newp == NULL)
+		return ERR_PTR(-ENOMEM);
+	newp->size = new_size;
+
+	/*
+	 * When @old_data == %NULL, the values for @offset and @change have
+	 * already been constrained by above checks, such that nothing actually
+	 * gets copied from @old_data.
+	 */
+	memcpy(newp->data, old_data, offset);
+	if (change < 0) {
+		memcpy(newp->data + offset, old_data + offset - change,
+		       old_size - offset + change);
+		return newp;
+	}
+	memset(newp->data + offset, 0xAF, change); /* poison mark */
+	memcpy(newp->data + offset + change, old_data + offset,
+	       old_size - offset);
+	return newp;
+}
+
 /**
  * @table:	table to add the new chain to
  * @name:	name for the chain; may be %NULL
@@ -124,6 +258,12 @@ struct xt2_chain *xt2_chain_new(struct xt2_table *table, const char *name)
 	else
 		*chain->name = '\0';
 	chain->name[sizeof(chain->name)-1] = '\0';
+	chain->rules = NULL;
+	/*
+	 * Do we need wmb() or something else here at this spot?
+	 * Something to avoid the chain becoming part of the list before
+	 * the members are initialized...
+	 */
 	if (table != NULL)
 		list_add_tail_rcu(&chain->anchor, &table->chain_list);
 	return chain;
@@ -148,10 +288,19 @@ struct xt2_chain *xt2_chain_lookup(struct xt2_table *table, const char *name)
 	return NULL;
 }
 
+static void xt2_chain_free_rcu(struct rcu_head *rcu)
+{
+	struct xt2_chain *chain = container_of(rcu, struct xt2_chain, rcu);
+
+	if (chain->rules != NULL)
+		xt2_blob_free(&chain->rules->rcu);
+	kfree(chain);
+}
+
 void xt2_chain_free(struct xt2_chain *chain)
 {
 	list_del_rcu(&chain->anchor);
-	kfree_rcu(chain, rcu);
+	call_rcu(&chain->rcu, xt2_chain_free_rcu);
 }
 
 /**
@@ -187,10 +336,160 @@ struct xt2_chain *xt2_chain_move(struct xt2_table *table, const char *old_name,
 struct xt2_chain *
 xt2_chain_dup(struct xt2_table *new_table, const struct xt2_chain *old)
 {
+	struct xt2_chain *chain;
+	int ret;
+
 	WARN_ON(old == NULL);
 	if (old == NULL)
 		return ERR_PTR(-EINVAL);
-	return xt2_chain_new(new_table, old->name);
+	chain = xt2_chain_new(new_table, old->name);
+	if (IS_ERR(chain))
+		return chain;
+
+	chain->rules = (old->rules == NULL) ? NULL :
+		       xt2_blob_renew(old->rules, 0, 0);
+	if (!IS_ERR(chain->rules))
+		return chain;
+
+	ret = PTR_ERR(chain->rules);
+	chain->rules = NULL;
+	xt2_chain_free(chain);
+	return ERR_PTR(ret);
+}
+
+/**
+ * Compute the packed size from all the actions (matches and targets) attached
+ * to a prototype rule.
+ */
+static void xt2_splice_prepare_rules(struct xt2_rule_buffer *buffer)
+{
+	struct xt2_proto_rule *rule;
+
+	list_for_each_entry(rule, &buffer->rule_list, anchor)
+		rule->packed_size = 0;
+}
+
+/**
+ * Calculate the byte offsets for use with xt2_blob_renew. In particular, find
+ * out where to start deletion, and how large that delete region is.
+ *
+ * Requires that each proto_rule has its .packed_size already computed.
+ */
+static int xt2_splice_find_offsets(struct xt2_splice_state *spl)
+{
+#define delta() \
+	((spl->chain->rules == NULL) ? 0 : \
+	((const char *)packed_rule - (const char *)spl->chain->rules->data))
+
+	const struct xt2_packed_rule *packed_rule;
+	const struct xt2_proto_rule *proto_rule;
+	bool flush = spl->i_delete == XT_CHAIN_SPLICE_FLUSH;
+
+	spl->b_offset = 0;
+	spl->b_delete = 0;
+	if (spl->i_offset == XT_CHAIN_SPLICE_APPEND) {
+		if (spl->i_delete != 0)
+			/* There is never going to be a rule like that. */
+			return -EDOM;
+		if (spl->chain->rules != NULL)
+			spl->b_offset = spl->chain->rules->size;
+	} else {
+		/* Count down until we found the start... */
+		xt2_foreach_rule(packed_rule, spl->chain->rules) {
+			if (spl->i_offset == 0)
+				break;
+			--spl->i_offset;
+		}
+		if (spl->i_offset > 0)
+			/* Reached end of chain before getting to rule. */
+			return -EDOM;
+		spl->b_offset = delta();
+
+		/* Count down until the end of the delete region... */
+		xt2_foreach_rule_continue(packed_rule, spl->chain->rules) {
+			if (spl->i_delete == 0)
+				break;
+			--spl->i_delete;
+		}
+		if (spl->i_delete > 0 && !flush)
+			return -EDOM;
+		spl->b_delete = delta() - spl->b_offset;
+	}
+
+	spl->b_insert = 0;
+	list_for_each_entry(proto_rule, spl->rule_list, anchor)
+		spl->b_insert += sizeof(struct xt2_packed_rule) +
+		                 proto_rule->packed_size;
+	return 0;
+#undef delta
+}
+
+/**
+ * @packed_rule:	target buffer for packed rule
+ * @proto_rule:		prototype rule
+ *
+ * Serializes @proto_rule into @packed_rule.
+ */
+static void xt2_rule_xfrm(struct xt2_packed_rule *packed_rule,
+			  struct xt2_proto_rule *proto_rule)
+{
+	packed_rule->dsize = proto_rule->packed_size;
+}
+
+/**
+ * xt2_chain_splice - combined delete and insert operation for rules
+ * @offset:	rule index to delete from
+ * @dlength:	number of rules to delete
+ *
+ * Turn the set of prototype rules into packed rules and splice it into the
+ * chain. Returns an error if the blob cannot be resized.
+ * Caller is to hold appropriate table lock.
+ */
+int xt2_chain_splice(struct xt2_chain *chain, struct xt2_rule_buffer *rulebuf,
+		     unsigned int offset, unsigned int dlength)
+{
+	struct xt2_splice_state spl = {
+		.chain     = chain,
+		.rule_list = &rulebuf->rule_list,
+		.i_offset  = offset,
+		.i_delete  = dlength,
+	};
+	struct xt2_proto_rule *proto_rule;
+	struct xt2_packed_rule *packed_rule;
+	struct xt2_rcu_block *blob, *old_blob;
+	int ret;
+
+	xt2_splice_prepare_rules(rulebuf);
+	/* Find byte offsets to integer offsets given in splice request. */
+	ret = xt2_splice_find_offsets(&spl);
+	if (ret < 0)
+		return ret;
+
+	/* Get a new memory block. */
+	blob = xt2_blob_renew(spl.chain->rules, spl.b_offset,
+			      (ssize_t)spl.b_insert - (ssize_t)spl.b_delete);
+	if (IS_ERR(blob))
+		return PTR_ERR(blob);
+	if (blob == NULL) {
+		WARN_ON_ONCE(spl.b_insert != 0);
+		WARN_ON_ONCE(!list_empty(spl.rule_list));
+		if (spl.b_insert != 0 || !list_empty(spl.rule_list))
+			/* Should not happen, but safe guards are cool. */
+			return -EOVERFLOW;
+	}
+
+	/* Read proto rules and stream them into the blob. */
+	packed_rule = (void *)(blob->data + spl.b_offset);
+	list_for_each_entry(proto_rule, spl.rule_list, anchor) {
+		xt2_rule_xfrm(packed_rule, proto_rule);
+		packed_rule = xt2_chain_next_rule(packed_rule);
+	}
+
+	old_blob = chain->rules;
+	rcu_assign_pointer(chain->rules, blob);
+	if (old_blob != NULL)
+		call_rcu(&old_blob->rcu, xt2_blob_free);
+	return 0;
 }
 
 /**
-- 
1.7.10.4

