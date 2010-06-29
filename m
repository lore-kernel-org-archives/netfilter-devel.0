From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 29/56] netfilter: xtables2: normal->compat match data translation
Date: Tue, 29 Jun 2010 10:43:09 +0200
Message-ID: <1277801017-30600-30-git-send-email-jengelh@medozas.de>
References: <1277801017-30600-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44300 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754284Ab0F2IoM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jun 2010 04:44:12 -0400
In-Reply-To: <1277801017-30600-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h |    5 ++++
 net/ipv6/netfilter/ip6_tables.c    |    1 +
 net/netfilter/xt1_support.c        |   42 +++++++++++++++++++++++++++++++++++-
 net/netfilter/xt1_translat.c       |    5 +++-
 4 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 7ccc3fb..4103d17 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -422,6 +422,8 @@ struct xt_table_info {
  * @etarget_size:	size of the etarget header
  * @standard_tgsize:	size of the complete standard target, includes
  * 			etarget_size and alignment padding
+ * @compat:		whether requestor is in normal or compat mode
+ * 			affects selection of ematch->dsize vs compatsize
  */
 struct xt1_xlat_info {
 	unsigned int marker_size;
@@ -429,6 +431,7 @@ struct xt1_xlat_info {
 	unsigned int ematch_size, etarget_size;
 	unsigned int standard_tgsize;
 	const char *first_match;
+	bool compat;
 };
 
 /*
@@ -748,6 +751,8 @@ extern int xts_rule_add_cmatch(struct xt2_rule *,
 			       const struct xt_entry_match *);
 extern int xts_rule_add_ctarget(struct xt2_rule *,
 				const struct xt_entry_target *);
+extern int xts_cmatch_to_xt1(void __user **, int *, unsigned int *,
+			     const struct xt2_entry_match *);
 #endif
 
 extern struct xt2_rule *xt2_rule_new(struct xt2_chain *);
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index a3db2e0..586cd48 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1095,6 +1095,7 @@ static const struct xt1_xlat_info ip6t_compat_xlat_info = {
 	.etarget_size    = sizeof(struct xt_entry_target),
 	.standard_tgsize = COMPAT_XT_ALIGN(sizeof(struct xt_entry_target) +
 	                   sizeof(compat_uint_t)),
+	.compat          = true,
 #endif
 };
 
diff --git a/net/netfilter/xt1_support.c b/net/netfilter/xt1_support.c
index 5844b0d..ad52d5e 100644
--- a/net/netfilter/xt1_support.c
+++ b/net/netfilter/xt1_support.c
@@ -142,7 +142,14 @@ xts_blob_prep_rule(const struct xt2_rule *rule, const struct xt1_xlat_info *io,
 		if (ematch == quota_stop)
 			/* quotas included in entry_hdr */
 			break;
-		z += io->ematch_size + ematch->dsize;
+		z += io->ematch_size;
+#ifdef CONFIG_COMPAT
+		if (ematch->ext->matchsize != -1 && io->compat &&
+		    ematch->ext->compatsize != 0)
+			z += COMPAT_XT_ALIGN(ematch->ext->compatsize);
+		else
+#endif
+			z += ematch->dsize;
 	}
 
 	etarget = list_first_entry(&rule->target_list,
@@ -515,6 +522,39 @@ int xts_rule_add_ctarget(struct xt2_rule *rule,
 	return ret;
 }
 EXPORT_SYMBOL_GPL(xts_rule_add_ctarget);
+
+int xts_cmatch_to_xt1(void __user **user_ptr, int *len, unsigned int *z,
+		      const struct xt2_entry_match *ematch)
+{
+	struct xt_entry_match blob;
+	unsigned int dsize;
+	int ret;
+
+	if (ematch->ext->compatsize == 0)
+		return xts_match_to_xt1(user_ptr, len, z, ematch);
+
+	dsize = COMPAT_XT_ALIGN(ematch->ext->compatsize);
+	blob.u.match_size    = sizeof(blob) + dsize;
+	blob.u.user.revision = ematch->ext->revision;
+	strncpy(blob.u.user.name, ematch->ext->name, sizeof(blob.u.user.name));
+	ret = xts_copy_to_user(user_ptr, len, &blob, sizeof(blob), z);
+	if (ret < 0)
+		return ret;
+	/*
+	 * The awkward semantics of compat_to_user means we cannot
+	 * use xts_copy_to_user.
+	 */
+	if (*len < dsize)
+		return -ENOSPC;
+	ret = ematch->ext->compat_to_user(*user_ptr, ematch->data);
+	if (ret < 0)
+		return ret;
+	*user_ptr += dsize;
+	*z        += dsize;
+	*len      -= dsize;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(xts_cmatch_to_xt1);
 #endif
 
 MODULE_LICENSE("GPL");
diff --git a/net/netfilter/xt1_translat.c b/net/netfilter/xt1_translat.c
index c1e82b9..4e0ad52 100644
--- a/net/netfilter/xt1_translat.c
+++ b/net/netfilter/xt1_translat.c
@@ -19,9 +19,11 @@
 #ifdef XTSUB_DO_COMPAT
 #	define xtsub_rule_add_match  xts_rule_add_cmatch
 #	define xtsub_rule_add_target xts_rule_add_ctarget
+#	define xtsub_match_to_xt1    xts_cmatch_to_xt1
 #else
 #	define xtsub_rule_add_match  xt2_rule_add_oldmatch
 #	define xtsub_rule_add_target xt2_rule_add_oldtarget
+#	define xtsub_match_to_xt1    xts_match_to_xt1
 #endif
 
 #ifdef XTSUB_NFPROTO_IPV6
@@ -477,7 +479,7 @@ XTSUB2(rule_to_xt1)(void __user **user_ptr, int *len, unsigned int *z,
 	list_for_each_entry_continue(ematch, &rule->match_list, anchor) {
 		if (ematch == quota_ematch)
 			break;
-		ret = xts_match_to_xt1(user_ptr, len, z, ematch);
+		ret = xtsub_match_to_xt1(user_ptr, len, z, ematch);
 		if (ret < 0)
 			return ret;
 	}
@@ -596,3 +598,4 @@ XTSUB2(do_replace)(struct net *net, const void __user *user, unsigned int len)
 
 #undef xtsub_rule_add_match
 #undef xtsub_rule_add_target
+#undef xtsub_match_to_xt1
-- 
1.7.1

