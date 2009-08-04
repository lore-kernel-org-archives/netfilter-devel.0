From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 067/103] netfilter: xtables2: return counters after SET_REPLACE
Date: Tue,  4 Aug 2009 09:25:51 +0200
Message-ID: <1249370787-17583-68-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56947 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932593AbZHDH1p (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:27:45 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h |    3 +-
 net/netfilter/xt1_support.c        |   58 ++++++++++++++++++++++++++++++++++-
 net/netfilter/xt1_translat.c       |    2 +-
 3 files changed, 59 insertions(+), 4 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 9514002..a65a848 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -729,7 +729,8 @@ extern int xts_starget_to_xt1(void __user **, int *, unsigned int *,
 	const struct xt2_entry_target *, const struct xt1_xlat_info *);
 extern int xts_target_to_xt1(void __user **, int *, unsigned int *,
 	const struct xt2_entry_target *);
-extern int xts_table_replace(struct net *, struct xt2_table *);
+extern int xts_table_replace(void __user *, unsigned int, struct net *,
+	struct xt2_table *);
 
 extern struct xt2_rule *xt2_rule_new(struct xt2_chain *);
 extern int xt2_rule_add_match(struct xt2_rule *, const char *, uint8_t,
diff --git a/net/netfilter/xt1_support.c b/net/netfilter/xt1_support.c
index d7270dc..9e66e25 100644
--- a/net/netfilter/xt1_support.c
+++ b/net/netfilter/xt1_support.c
@@ -240,11 +240,64 @@ int xts_target_to_xt1(void __user **user_ptr, int *len, unsigned int *z,
 EXPORT_SYMBOL_GPL(xts_target_to_xt1);
 
 /**
+ * @ptr:	room for counters
+ * @cnum:	maximum number of counters to copy
+ * @table:	input xt2 table
+ */
+static int xts_put_counters(struct xt_counters __user *ptr, unsigned int cnum,
+                            const struct xt2_table *table)
+{
+	const struct xt2_entry_match *ematch;
+	const struct xt2_chain *chain;
+	const struct xt2_rule *rule;
+	struct xt_counters ctinfo;
+	unsigned int i = 0;
+	int ret = 0;
+
+	rcu_read_lock();
+	list_for_each_entry(chain, &table->chain_list, anchor) {
+		if (i == cnum)
+			break;
+		if (!xt2_builtin_chain(chain)) {
+			ctinfo.bcnt = ctinfo.pcnt = 0;
+			ret = copy_to_user(&ptr[i++], &ctinfo, sizeof(ctinfo));
+			if (ret < 0)
+				goto out;
+		}
+
+		list_for_each_entry(rule, &chain->rule_list, anchor) {
+			if (i == cnum)
+				break;
+			ematch = xts_rule_quota_ptr(rule);
+			if (ematch == NULL) {
+				ret = -EIO;
+				goto out;
+			}
+			xts_rule_get_quota(ematch, &ctinfo.bcnt, &ctinfo.pcnt);
+			ret = copy_to_user(&ptr[i++], &ctinfo, sizeof(ctinfo));
+			if (ret < 0)
+				goto out;
+		}
+	}
+
+	if (i < cnum) {
+		/* end of ruleset marker: */
+		ctinfo.bcnt = ctinfo.pcnt = 0;
+		ret = copy_to_user(&ptr[i], &ctinfo, sizeof(ctinfo));
+	}
+ out:
+	rcu_read_unlock();
+	return ret;
+}
+
+/**
  * Load table module, check hook masks, replace table.
  */
-int xts_table_replace(struct net *net, struct xt2_table *table)
+int xts_table_replace(void __user *counters_ptr, unsigned int num_counters,
+                      struct net *net, struct xt2_table *table)
 {
 	struct xt2_table *old_table;
+	int ret;
 
 	old_table = try_then_request_module(xt2_table_lookup(net,
 	            table->name, table->nfproto, XT2_TAKE_RCULOCK),
@@ -262,8 +315,9 @@ int xts_table_replace(struct net *net, struct xt2_table *table)
 	old_table = xt2_table_replace(net, table);
 	if (IS_ERR(old_table))
 		return PTR_ERR(old_table);
+	ret = xts_put_counters(counters_ptr, num_counters, old_table);
 	xt2_table_destroy(NULL, old_table);
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(xts_table_replace);
 
diff --git a/net/netfilter/xt1_translat.c b/net/netfilter/xt1_translat.c
index af413f5..f88a72b 100644
--- a/net/netfilter/xt1_translat.c
+++ b/net/netfilter/xt1_translat.c
@@ -479,7 +479,7 @@ XTSUB2(do_replace)(struct net *net, const void __user *user, unsigned int len)
 	vfree(blob);
 	if (ret < 0)
 		goto out;
-	ret = xts_table_replace(net, table);
+	ret = xts_table_replace(repl.counters, repl.num_counters, net, table);
 	if (ret < 0)
 		goto out;
 	return 0;
-- 
1.6.3.3

