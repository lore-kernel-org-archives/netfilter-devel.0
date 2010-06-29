From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 21/56] netfilter: xtables2: return counters after SET_REPLACE
Date: Tue, 29 Jun 2010 10:43:01 +0200
Message-ID: <1277801017-30600-22-git-send-email-jengelh@medozas.de>
References: <1277801017-30600-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44277 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754238Ab0F2IoC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jun 2010 04:44:02 -0400
In-Reply-To: <1277801017-30600-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h |    3 +-
 net/netfilter/xt1_support.c        |   58 ++++++++++++++++++++++++++++++++++-
 net/netfilter/xt1_translat.c       |    2 +-
 3 files changed, 59 insertions(+), 4 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index d905a44..d672b3d 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -737,7 +737,8 @@ extern int xts_starget_to_xt1(void __user **, int *, unsigned int *,
 			      const struct xt1_xlat_info *);
 extern int xts_target_to_xt1(void __user **, int *, unsigned int *,
 			     const struct xt2_entry_target *);
-extern int xts_table_replace(struct net *, struct xt2_table *);
+extern int xts_table_replace(void __user *, unsigned int, struct net *,
+			     struct xt2_table *);
 
 extern struct xt2_rule *xt2_rule_new(struct xt2_chain *);
 extern int xt2_rule_add_match(struct xt2_rule *, const char *, uint8_t,
diff --git a/net/netfilter/xt1_support.c b/net/netfilter/xt1_support.c
index 04126d0..d87e0ab 100644
--- a/net/netfilter/xt1_support.c
+++ b/net/netfilter/xt1_support.c
@@ -241,11 +241,64 @@ int xts_target_to_xt1(void __user **user_ptr, int *len, unsigned int *z,
 EXPORT_SYMBOL_GPL(xts_target_to_xt1);
 
 /**
+ * @ptr:	room for counters
+ * @cnum:	maximum number of counters to copy
+ * @table:	input xt2 table
+ */
+static int xts_put_counters(struct xt_counters __user *ptr, unsigned int cnum,
+			    const struct xt2_table *table)
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
+		      struct net *net, struct xt2_table *table)
 {
 	struct xt2_table *old_table;
+	int ret;
 
 	old_table = try_then_request_module(xt2_table_lookup(net,
 							     table->name,
@@ -267,8 +320,9 @@ int xts_table_replace(struct net *net, struct xt2_table *table)
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
index 669b2b2..159a6c5 100644
--- a/net/netfilter/xt1_translat.c
+++ b/net/netfilter/xt1_translat.c
@@ -478,7 +478,7 @@ XTSUB2(do_replace)(struct net *net, const void __user *user, unsigned int len)
 	vfree(blob);
 	if (ret < 0)
 		goto out;
-	ret = xts_table_replace(net, table);
+	ret = xts_table_replace(repl.counters, repl.num_counters, net, table);
 	if (ret < 0)
 		goto out;
 	return 0;
-- 
1.7.1

