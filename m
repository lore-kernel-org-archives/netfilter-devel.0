From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 03/11] netfilter: xtables2: skeleton for single rules and rule buffer
Date: Fri, 16 Nov 2012 02:23:37 +0100
Message-ID: <1353029025-31635-4-git-send-email-jengelh@inai.de>
References: <1353029025-31635-1-git-send-email-jengelh@inai.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:45168 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224Ab2KPBXx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Nov 2012 20:23:53 -0500
In-Reply-To: <1353029025-31635-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

These are datastructures to keep rules in before packing.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 include/net/netfilter/xt_core.h |    9 ++++++
 net/netfilter/xt_core.c         |   67 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 76 insertions(+)

diff --git a/include/net/netfilter/xt_core.h b/include/net/netfilter/xt_core.h
index 52efc06..8139977 100644
--- a/include/net/netfilter/xt_core.h
+++ b/include/net/netfilter/xt_core.h
@@ -35,9 +35,18 @@ struct xt2_chain {
 };
 
 struct net;
+struct xt2_proto_rule;
+struct xt2_rule_buffer;
 
 extern struct xt2_pernet_data *xtables2_pernet(struct net *);
 
+extern struct xt2_proto_rule *xt2_rule_new(void);
+extern void xt2_rule_free(struct xt2_proto_rule *);
+
+extern struct xt2_rule_buffer *xt2_rulebuf_new(void);
+extern int xt2_rulebuf_push(struct xt2_rule_buffer *, struct xt2_proto_rule *);
+extern void xt2_rulebuf_free(struct xt2_rule_buffer *);
+
 extern struct xt2_chain *xt2_chain_new(struct xt2_table *, const char *);
 extern struct xt2_chain *xt2_chain_lookup(struct xt2_table *, const char *);
 extern void xt2_chain_free(struct xt2_chain *);
diff --git a/net/netfilter/xt_core.c b/net/netfilter/xt_core.c
index 62426e4..5921355 100644
--- a/net/netfilter/xt_core.c
+++ b/net/netfilter/xt_core.c
@@ -21,6 +21,27 @@
 #include <net/netfilter/xt_core.h>
 #include "xt_nfnetlink.h"
 
+/**
+ * A "prototype" rule is a data structure that collects a rule's match and
+ * target parameters in a simple linked list - in principle anything that can
+ * be easily appended to - until the rule is packed later.
+ */
+struct xt2_proto_rule {
+	struct list_head anchor;
+};
+
+/**
+ * The rule buffer, which collects multiple prototype rules for use with
+ * xt2_chain_splice(). While there is only one member here, struct
+ * xt2_rule_buffer exists on purpose, so that the function signatures do not
+ * sport a unmarked "list_head" type argument.
+ *
+ * @rule_list:	ordered collection of struct xt2_proto_rules
+ */
+struct xt2_rule_buffer {
+	struct list_head rule_list;
+};
+
 MODULE_DESCRIPTION("Netfilter Xtables2 packet filtering");
 MODULE_AUTHOR("Jan Engelhardt");
 MODULE_LICENSE("GPL");
@@ -33,6 +54,52 @@ struct xt2_pernet_data *xtables2_pernet(struct net *net)
 }
 
 /**
+ * Creates a prototype rule. These use linked lists during genesis so that we
+ * do not need to realloc over and over while adding matches and targets.
+ */
+struct xt2_proto_rule *xt2_rule_new(void)
+{
+	struct xt2_proto_rule *r;
+
+	r = kmalloc(sizeof(*r), GFP_KERNEL);
+	if (r == NULL)
+		return r;
+	return r;
+}
+
+void xt2_rule_free(struct xt2_proto_rule *r)
+{
+	kfree(r);
+}
+
+struct xt2_rule_buffer *xt2_rulebuf_new(void)
+{
+	struct xt2_rule_buffer *rb;
+
+	rb = kmalloc(sizeof(*rb), GFP_KERNEL);
+	if (rb == NULL)
+		return NULL;
+	INIT_LIST_HEAD(&rb->rule_list);
+	return rb;
+}
+
+int xt2_rulebuf_push(struct xt2_rule_buffer *rb, struct xt2_proto_rule *rule)
+{
+	INIT_LIST_HEAD(&rule->anchor);
+	list_add_tail(&rule->anchor, &rb->rule_list);
+	return 0;
+}
+
+void xt2_rulebuf_free(struct xt2_rule_buffer *rb)
+{
+	struct xt2_proto_rule *rule, *rule_next;
+
+	list_for_each_entry_safe(rule, rule_next, &rb->rule_list, anchor)
+		xt2_rule_free(rule);
+	kfree(rb);
+}
+
+/**
  * @table:	table to add the new chain to
  * @name:	name for the chain; may be %NULL
  *
-- 
1.7.10.4

