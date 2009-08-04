From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 075/103] netfilter: xtables2: outsource code into xts_match_to_xt1 function
Date: Tue,  4 Aug 2009 09:25:59 +0200
Message-ID: <1249370787-17583-76-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56952 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932603AbZHDH1x (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:27:53 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h |    2 ++
 net/netfilter/xt1_support.c        |   17 +++++++++++++++++
 net/netfilter/xt1_translat.c       |   13 +------------
 3 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index bab5b38..0531f0d 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -725,6 +725,8 @@ extern void xts_rule_get_quota(const struct xt2_entry_match *,
 extern unsigned int xts_blob_prep_table(struct xt2_table *,
 	const struct xt1_xlat_info *, unsigned int *, unsigned int *,
 	unsigned int *);
+extern int xts_match_to_xt1(void __user **, int *, unsigned int *,
+	const struct xt2_entry_match *);
 extern int xts_starget_to_xt1(void __user **, int *, unsigned int *,
 	const struct xt2_entry_target *, const struct xt1_xlat_info *);
 extern int xts_target_to_xt1(void __user **, int *, unsigned int *,
diff --git a/net/netfilter/xt1_support.c b/net/netfilter/xt1_support.c
index 09bbed9..be87e75 100644
--- a/net/netfilter/xt1_support.c
+++ b/net/netfilter/xt1_support.c
@@ -203,6 +203,23 @@ xts_blob_prep_table(struct xt2_table *table, const struct xt1_xlat_info *io,
 }
 EXPORT_SYMBOL_GPL(xts_blob_prep_table);
 
+int xts_match_to_xt1(void __user **user_ptr, int *len, unsigned int *z,
+                     const struct xt2_entry_match *ematch)
+{
+	struct xt_entry_match blob;
+	int ret;
+
+	blob.u.match_size    = sizeof(blob) + ematch->dsize;
+	blob.u.user.revision = ematch->ext->revision;
+	strncpy(blob.u.user.name, ematch->ext->name, sizeof(blob.u.user.name));
+	ret = xts_copy_to_user(user_ptr, len, &blob, sizeof(blob), z);
+	if (ret < 0)
+		return ret;
+	return xts_copy_to_user(user_ptr, len, ematch->data,
+	       ematch->dsize, z);
+}
+EXPORT_SYMBOL_GPL(xts_match_to_xt1);
+
 int xts_starget_to_xt1(void __user **user_ptr, int *len, unsigned int *z,
                        const struct xt2_entry_target *etarget,
                        const struct xt1_xlat_info *io)
diff --git a/net/netfilter/xt1_translat.c b/net/netfilter/xt1_translat.c
index 515cc91..469490d 100644
--- a/net/netfilter/xt1_translat.c
+++ b/net/netfilter/xt1_translat.c
@@ -478,20 +478,9 @@ XTSUB2(rule_to_xt1)(void __user **user_ptr, int *len, unsigned int *z,
 		return ret;
 
 	list_for_each_entry_continue(ematch, &rule->match_list, anchor) {
-		struct xt_entry_match blob;
-
 		if (ematch == quota_ematch)
 			break;
-
-		blob.u.match_size    = sizeof(blob) + ematch->dsize;
-		blob.u.user.revision = ematch->ext->revision;
-		strncpy(blob.u.user.name, ematch->ext->name,
-		        sizeof(blob.u.user.name));
-		ret = xts_copy_to_user(user_ptr, len, &blob, sizeof(blob), z);
-		if (ret < 0)
-			return ret;
-		ret = xts_copy_to_user(user_ptr, len, ematch->data,
-		      ematch->dsize, z);
+		ret = xts_match_to_xt1(user_ptr, len, z, ematch);
 		if (ret < 0)
 			return ret;
 	}
-- 
1.6.3.3

