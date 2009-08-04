From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 077/103] netfilter: xtables2: normal->compat target data translation
Date: Tue,  4 Aug 2009 09:26:01 +0200
Message-ID: <1249370787-17583-78-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56954 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932608AbZHDH14 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:27:56 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h |    2 +
 net/netfilter/xt1_support.c        |   42 ++++++++++++++++++++++++++++++++++-
 net/netfilter/xt1_translat.c       |    5 +++-
 3 files changed, 46 insertions(+), 3 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index ccd012a..77573a5 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -745,6 +745,8 @@ extern int xts_rule_add_ctarget(struct xt2_rule *,
 	const struct xt_entry_target *);
 extern int xts_cmatch_to_xt1(void __user **, int *, unsigned int *,
 	const struct xt2_entry_match *);
+extern int xts_ctarget_to_xt1(void __user **, int *, unsigned int *,
+	const struct xt2_entry_target *);
 #endif
 
 extern struct xt2_rule *xt2_rule_new(struct xt2_chain *);
diff --git a/net/netfilter/xt1_support.c b/net/netfilter/xt1_support.c
index 48cfaba..f02eff8 100644
--- a/net/netfilter/xt1_support.c
+++ b/net/netfilter/xt1_support.c
@@ -154,8 +154,15 @@ xts_blob_prep_rule(const struct xt2_rule *rule, const struct xt1_xlat_info *io,
 
 	etarget = list_first_entry(&rule->target_list,
 	          typeof(*etarget), anchor);
-	z += xt2_special_target(etarget->ext) ? io->standard_tgsize :
-	     io->etarget_size + XT_ALIGN(etarget->ext->targetsize);
+	if (xt2_special_target(etarget->ext))
+		z += io->standard_tgsize;
+#ifdef CONFIG_COMPAT
+	else if (io->compat && etarget->ext->compatsize != 0)
+		z += io->etarget_size +
+		     COMPAT_XT_ALIGN(etarget->ext->compatsize);
+#endif
+	else
+		z += io->etarget_size + XT_ALIGN(etarget->ext->targetsize);
 	return z;
 }
 
@@ -547,6 +554,37 @@ int xts_cmatch_to_xt1(void __user **user_ptr, int *len, unsigned int *z,
 	return 0;
 }
 EXPORT_SYMBOL_GPL(xts_cmatch_to_xt1);
+
+int xts_ctarget_to_xt1(void __user **user_ptr, int *len, unsigned int *z,
+                       const struct xt2_entry_target *etarget)
+{
+	struct xt_entry_target blob;
+	unsigned int dsize;
+	int ret;
+
+	if (etarget->ext->compatsize == 0)
+		return xts_target_to_xt1(user_ptr, len, z, etarget);
+
+	dsize = COMPAT_XT_ALIGN(etarget->ext->compatsize);
+	blob.u.target_size   = sizeof(blob) + dsize;
+	blob.u.user.revision = etarget->ext->revision;
+	strncpy(blob.u.user.name, etarget->ext->name,
+	        sizeof(blob.u.user.name));
+	ret = xts_copy_to_user(user_ptr, len, &blob, sizeof(blob), z);
+	if (ret < 0)
+		return ret;
+
+	if (*len < dsize)
+		return -ENOSPC;
+	ret = etarget->ext->compat_to_user(*user_ptr, etarget->data);
+	if (ret < 0)
+		return ret;
+	*user_ptr += dsize;
+	*z        += dsize;
+	*len      -= dsize;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(xts_ctarget_to_xt1);
 #endif
 
 MODULE_LICENSE("GPL");
diff --git a/net/netfilter/xt1_translat.c b/net/netfilter/xt1_translat.c
index ebcc3df..994fcc5 100644
--- a/net/netfilter/xt1_translat.c
+++ b/net/netfilter/xt1_translat.c
@@ -20,10 +20,12 @@
 #	define xtsub_rule_add_match  xts_rule_add_cmatch
 #	define xtsub_rule_add_target xts_rule_add_ctarget
 #	define xtsub_match_to_xt1    xts_cmatch_to_xt1
+#	define xtsub_target_to_xt1   xts_ctarget_to_xt1
 #else
 #	define xtsub_rule_add_match  xt2_rule_add_oldmatch
 #	define xtsub_rule_add_target xt2_rule_add_oldtarget
 #	define xtsub_match_to_xt1    xts_match_to_xt1
+#	define xtsub_target_to_xt1   xts_target_to_xt1
 #endif
 
 #ifdef XTSUB_NFPROTO_IPV6
@@ -493,7 +495,7 @@ XTSUB2(rule_to_xt1)(void __user **user_ptr, int *len, unsigned int *z,
 	list_for_each_entry(etarget, &rule->target_list, anchor) {
 		ret = xt2_special_target(etarget->ext) ?
 		      xts_starget_to_xt1(user_ptr, len, z, etarget, io) :
-		      xts_target_to_xt1(user_ptr, len, z, etarget);
+		      xtsub_target_to_xt1(user_ptr, len, z, etarget);
 		if (ret < 0)
 			return ret;
 	}
@@ -600,3 +602,4 @@ XTSUB2(do_replace)(struct net *net, const void __user *user, unsigned int len)
 #undef xtsub_rule_add_match
 #undef xtsub_rule_add_target
 #undef xtsub_match_to_xt1
+#undef xtsub_target_to_xt1
-- 
1.6.3.3

