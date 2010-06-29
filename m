From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 27/56] netfilter: xtables2: compat->normal target data translation
Date: Tue, 29 Jun 2010 10:43:07 +0200
Message-ID: <1277801017-30600-28-git-send-email-jengelh@medozas.de>
References: <1277801017-30600-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44294 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754327Ab0F2IoK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jun 2010 04:44:10 -0400
In-Reply-To: <1277801017-30600-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

By this, `ip6tables -S` will now correctly receive 0x3C for xt_limit too.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h |    2 +
 net/netfilter/xt1_support.c        |   52 ++++++++++++++++++++++++++++++++++++
 net/netfilter/xt1_translat.c       |    5 +++-
 3 files changed, 58 insertions(+), 1 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index b6aff51..ad95d1d 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -744,6 +744,8 @@ extern int xts_get_counters(struct xt2_table *,
 #ifdef CONFIG_COMPAT
 extern int xts_rule_add_cmatch(struct xt2_rule *,
 			       const struct xt_entry_match *);
+extern int xts_rule_add_ctarget(struct xt2_rule *,
+				const struct xt_entry_target *);
 #endif
 
 extern struct xt2_rule *xt2_rule_new(struct xt2_chain *);
diff --git a/net/netfilter/xt1_support.c b/net/netfilter/xt1_support.c
index e0dcadd..e308844 100644
--- a/net/netfilter/xt1_support.c
+++ b/net/netfilter/xt1_support.c
@@ -446,6 +446,58 @@ int xts_rule_add_cmatch(struct xt2_rule *rule, const struct xt_entry_match *m)
 	return ret;
 }
 EXPORT_SYMBOL_GPL(xts_rule_add_cmatch);
+
+int xts_rule_add_ctarget(struct xt2_rule *rule,
+			 const struct xt_entry_target *t)
+{
+	const uint8_t nfproto = rule->chain->table->nfproto;
+	const struct xt_target *ext;
+	unsigned int dsize, required;
+	void *data;
+	int ret;
+
+	ext = try_then_request_module(xt_find_target(nfproto,
+						     t->u.user.name,
+						     t->u.user.revision),
+				      "%st_%s", xt_prefix[nfproto],
+				      t->u.user.name);
+	if (ext == NULL)
+		return -ENOENT;
+	if (IS_ERR(ext))
+		return PTR_ERR(ext);
+
+	dsize = t->u.target_size - sizeof(*t);
+	if (ext->compatsize == 0 && dsize == XT_ALIGN(ext->targetsize)) {
+		ret = xt2_rule_add_oldtarget(rule, t);
+		goto put_module;
+	}
+	required = (ext->compatsize == 0) ? ext->targetsize : ext->compatsize;
+	if (dsize != COMPAT_XT_ALIGN(required)) {
+		pr_err("%s_tables: %s.%u target: invalid size "
+		       "(expected) %u != (given by user) %u\n",
+		       xt_prefix[rule->chain->table->nfproto],
+		       ext->name, ext->revision, required, dsize);
+		ret = -EINVAL;
+		goto put_module;
+	}
+
+	data = kzalloc(XT_ALIGN(ext->targetsize), GFP_KERNEL);
+	if (data == NULL) {
+		ret = -ENOMEM;
+		goto put_module;
+	}
+	if (ext->compat_from_user == NULL)
+		memcpy(data, t->data, dsize);
+	else
+		ext->compat_from_user(data, t->data);
+	ret = xt2_rule_add_target(rule, t->u.user.name, t->u.user.revision,
+				  data, XT_ALIGN(ext->targetsize), true);
+	kfree(data);
+ put_module:
+	module_put(ext->me);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(xts_rule_add_ctarget);
 #endif
 
 MODULE_LICENSE("GPL");
diff --git a/net/netfilter/xt1_translat.c b/net/netfilter/xt1_translat.c
index 071cabe..d000fe2 100644
--- a/net/netfilter/xt1_translat.c
+++ b/net/netfilter/xt1_translat.c
@@ -18,8 +18,10 @@
 #endif
 #ifdef XTSUB_DO_COMPAT
 #	define xtsub_rule_add_match  xts_rule_add_cmatch
+#	define xtsub_rule_add_target xts_rule_add_ctarget
 #else
 #	define xtsub_rule_add_match  xt2_rule_add_oldmatch
+#	define xtsub_rule_add_target xt2_rule_add_oldtarget
 #endif
 
 #ifdef XTSUB_NFPROTO_IPV6
@@ -123,7 +125,7 @@ XTSUB2(target_to_xt2)(struct xt2_rule *rule, const struct xtsub_entry *entry,
 	struct xt2_entry_target *ntarget;
 
 	if (strcmp(etarget->u.user.name, XT_STANDARD_TARGET) != 0)
-		return xt2_rule_add_oldtarget(rule, etarget);
+		return xtsub_rule_add_target(rule, etarget);
 
 	ntarget = kmalloc(sizeof(*ntarget), GFP_KERNEL);
 	if (ntarget == NULL)
@@ -604,3 +606,4 @@ XTSUB2(do_replace)(struct net *net, const void __user *user, unsigned int len)
 }
 
 #undef xtsub_rule_add_match
+#undef xtsub_rule_add_target
-- 
1.7.1

