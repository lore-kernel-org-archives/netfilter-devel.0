From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 26/56] netfilter: xtables2: compat->normal match data translation
Date: Tue, 29 Jun 2010 10:43:06 +0200
Message-ID: <1277801017-30600-27-git-send-email-jengelh@medozas.de>
References: <1277801017-30600-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44291 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754284Ab0F2IoJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jun 2010 04:44:09 -0400
In-Reply-To: <1277801017-30600-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch will translate userspace requests in compat format
to the normalized format. Testable with e.g. `ip6tables -t filter2
-A INPUT -m limit --limit 1/s`, which will submit a struct
xt_entry_match with size 0x3C, and retrieving the ruleset will show
that it has been translated into a struct xt_entry_match with the
size field containing 0x48.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h |    4 ++
 net/ipv6/netfilter/ip6_tables.c    |    1 +
 net/netfilter/xt1_support.c        |   59 ++++++++++++++++++++++++++++++++++++
 net/netfilter/xt1_translat.c       |    9 +++++-
 4 files changed, 72 insertions(+), 1 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 99d05ba..b6aff51 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -741,6 +741,10 @@ extern int xts_table_replace(void __user *, unsigned int, struct net *,
 			     struct xt2_table *);
 extern int xts_get_counters(struct xt2_table *,
 			    const struct xt_counters __user *, unsigned int);
+#ifdef CONFIG_COMPAT
+extern int xts_rule_add_cmatch(struct xt2_rule *,
+			       const struct xt_entry_match *);
+#endif
 
 extern struct xt2_rule *xt2_rule_new(struct xt2_chain *);
 extern int xt2_rule_add_match(struct xt2_rule *, const char *, uint8_t,
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 5522533..a3db2e0 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -79,6 +79,7 @@ MODULE_DESCRIPTION("IPv6 packet filter");
 #undef xtsub_replace
 
 #ifdef CONFIG_COMPAT
+#define XTSUB_DO_COMPAT
 #define xtsub_entry           compat_ip6t_entry
 #define xtsub_replace         compat_ip6t_replace
 #define XTSUB2(x)             ip6t2_compat_ ## x
diff --git a/net/netfilter/xt1_support.c b/net/netfilter/xt1_support.c
index 675428c..e0dcadd 100644
--- a/net/netfilter/xt1_support.c
+++ b/net/netfilter/xt1_support.c
@@ -389,4 +389,63 @@ int xts_get_counters(struct xt2_table *table,
 }
 EXPORT_SYMBOL_GPL(xts_get_counters);
 
+#ifdef CONFIG_COMPAT
+int xts_rule_add_cmatch(struct xt2_rule *rule, const struct xt_entry_match *m)
+{
+	const uint8_t nfproto = rule->chain->table->nfproto;
+	const struct xt_match *ext;
+	unsigned int dsize, required;
+	void *data;
+	int ret;
+
+	ext = try_then_request_module(xt_find_match(nfproto,
+						    m->u.user.name,
+						    m->u.user.revision),
+				      "%st_%s", xt_prefix[nfproto],
+				      m->u.user.name);
+	if (ext == NULL)
+		return -ENOENT;
+	if (IS_ERR(ext))
+		return PTR_ERR(ext);
+
+	dsize = m->u.match_size - sizeof(*m);
+	if ((ext->compatsize == 0 && dsize == XT_ALIGN(ext->matchsize)) ||
+	    ext->matchsize == -1) {
+		/*
+		 * If extension does not have special ->compat_* functions and
+		 * is already padded, proceed.
+		 * ebt_among uses the -1 special case.
+		 */
+		ret = xt2_rule_add_oldmatch(rule, m);
+		goto put_module;
+	}
+	required = (ext->compatsize == 0) ? ext->matchsize : ext->compatsize;
+	if (dsize != COMPAT_XT_ALIGN(required)) {
+		pr_err("%s_tables: %s.%u match: invalid size "
+		       "(expected) %u != (given by user) %u\n",
+		       xt_prefix[rule->chain->table->nfproto],
+		       ext->name, ext->revision, required, dsize);
+		ret = -EINVAL;
+		goto put_module;
+	}
+
+	data = kzalloc(XT_ALIGN(ext->matchsize), GFP_KERNEL);
+	if (data == NULL) {
+		ret = -ENOMEM;
+		goto put_module;
+	}
+	if (ext->compat_from_user == NULL)
+		memcpy(data, m->data, dsize);
+	else
+		ext->compat_from_user(data, m->data);
+	ret = xt2_rule_add_match(rule, m->u.user.name, m->u.user.revision,
+				 data, XT_ALIGN(ext->matchsize), true);
+	kfree(data);
+ put_module:
+	module_put(ext->me);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(xts_rule_add_cmatch);
+#endif
+
 MODULE_LICENSE("GPL");
diff --git a/net/netfilter/xt1_translat.c b/net/netfilter/xt1_translat.c
index bd8fc2d..071cabe 100644
--- a/net/netfilter/xt1_translat.c
+++ b/net/netfilter/xt1_translat.c
@@ -16,6 +16,11 @@
 #if !defined(XTSUB_NFPROTO_IPV6)
 #	error Need to define XTSUB_NFPROTO_xxx.
 #endif
+#ifdef XTSUB_DO_COMPAT
+#	define xtsub_rule_add_match  xts_rule_add_cmatch
+#else
+#	define xtsub_rule_add_match  xt2_rule_add_oldmatch
+#endif
 
 #ifdef XTSUB_NFPROTO_IPV6
 static const struct ip6t_ip6 xtsub_uncond;
@@ -186,7 +191,7 @@ XTSUB2(rule_to_xt2)(struct xt2_chain *chain, const struct xtsub_entry *entry,
 		goto out;
 
 	xt_ematch_foreach(ematch, entry) {
-		ret = xt2_rule_add_oldmatch(rule, ematch);
+		ret = xtsub_rule_add_match(rule, ematch);
 		if (ret < 0)
 			goto out;
 	}
@@ -597,3 +602,5 @@ XTSUB2(do_replace)(struct net *net, const void __user *user, unsigned int len)
 	xt2_table_destroy(NULL, table);
 	return ret;
 }
+
+#undef xtsub_rule_add_match
-- 
1.7.1

