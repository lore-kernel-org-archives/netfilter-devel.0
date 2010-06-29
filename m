From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 30/56] netfilter: xtables2: normal->compat target data translation
Date: Tue, 29 Jun 2010 10:43:10 +0200
Message-ID: <1277801017-30600-31-git-send-email-jengelh@medozas.de>
References: <1277801017-30600-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44304 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754342Ab0F2IoN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jun 2010 04:44:13 -0400
In-Reply-To: <1277801017-30600-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h |    2 +
 net/netfilter/xt1_support.c        |   43 +++++++++++++++++++++++++++++++++--
 net/netfilter/xt1_translat.c       |    5 +++-
 3 files changed, 46 insertions(+), 4 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 4103d17..aee8b92 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -753,6 +753,8 @@ extern int xts_rule_add_ctarget(struct xt2_rule *,
 				const struct xt_entry_target *);
 extern int xts_cmatch_to_xt1(void __user **, int *, unsigned int *,
 			     const struct xt2_entry_match *);
+extern int xts_ctarget_to_xt1(void __user **, int *, unsigned int *,
+			      const struct xt2_entry_target *);
 #endif
 
 extern struct xt2_rule *xt2_rule_new(struct xt2_chain *);
diff --git a/net/netfilter/xt1_support.c b/net/netfilter/xt1_support.c
index ad52d5e..b90f2ca 100644
--- a/net/netfilter/xt1_support.c
+++ b/net/netfilter/xt1_support.c
@@ -154,9 +154,15 @@ xts_blob_prep_rule(const struct xt2_rule *rule, const struct xt1_xlat_info *io,
 
 	etarget = list_first_entry(&rule->target_list,
 				   typeof(*etarget), anchor);
-	z += xt2_special_target(etarget->ext) ? io->standard_tgsize :
-				io->etarget_size +
-				XT_ALIGN(etarget->ext->targetsize);
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
 
@@ -555,6 +561,37 @@ int xts_cmatch_to_xt1(void __user **user_ptr, int *len, unsigned int *z,
 	return 0;
 }
 EXPORT_SYMBOL_GPL(xts_cmatch_to_xt1);
+
+int xts_ctarget_to_xt1(void __user **user_ptr, int *len, unsigned int *z,
+		       const struct xt2_entry_target *etarget)
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
+		sizeof(blob.u.user.name));
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
index 4e0ad52..45007c9 100644
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
@@ -490,7 +492,7 @@ XTSUB2(rule_to_xt1)(void __user **user_ptr, int *len, unsigned int *z,
 	list_for_each_entry(etarget, &rule->target_list, anchor) {
 		ret = xt2_special_target(etarget->ext) ?
 		      xts_starget_to_xt1(user_ptr, len, z, etarget, io) :
-		      xts_target_to_xt1(user_ptr, len, z, etarget);
+		      xtsub_target_to_xt1(user_ptr, len, z, etarget);
 		if (ret < 0)
 			return ret;
 	}
@@ -599,3 +601,4 @@ XTSUB2(do_replace)(struct net *net, const void __user *user, unsigned int len)
 #undef xtsub_rule_add_match
 #undef xtsub_rule_add_target
 #undef xtsub_match_to_xt1
+#undef xtsub_target_to_xt1
-- 
1.7.1

