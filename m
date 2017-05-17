From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: [PATCH nf] xtables: fix build failure from COMPAT_XT_ALIGN outside CONFIG_COMPAT
Date: Wed, 17 May 2017 11:24:47 -0400
Message-ID: <20170517152447.140777-1-willemdebruijn.kernel@gmail.com>
Cc: pablo@netfilter.org, Willem de Bruijn <willemb@google.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:36239 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751991AbdEQPY5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 May 2017 11:24:57 -0400
Received: by mail-qt0-f196.google.com with SMTP id j13so1987577qta.3
        for <netfilter-devel@vger.kernel.org>; Wed, 17 May 2017 08:24:56 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Willem de Bruijn <willemb@google.com>

The patch in the Fixes references COMPAT_XT_ALIGN in the definition
of XT_DATA_TO_USER, outside an #ifdef CONFIG_COMPAT block.

Split XT_DATA_TO_USER into separate compat and non compat variants and
define the first inside an CONFIG_COMPAT block.

This simplifies both variants by removing branches inside the macro.

Fixes: 324318f0248c ("netfilter: xtables: zero padding in data_to_user")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 net/netfilter/x_tables.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index d17769599c10..1770c1d9b37f 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -296,18 +296,17 @@ int xt_data_to_user(void __user *dst, const void *src,
 }
 EXPORT_SYMBOL_GPL(xt_data_to_user);
 
-#define XT_DATA_TO_USER(U, K, TYPE, C_SIZE)				\
+#define XT_DATA_TO_USER(U, K, TYPE)					\
 	xt_data_to_user(U->data, K->data,				\
 			K->u.kernel.TYPE->usersize,			\
-			C_SIZE ? : K->u.kernel.TYPE->TYPE##size,	\
-			C_SIZE ? COMPAT_XT_ALIGN(C_SIZE) :		\
-				 XT_ALIGN(K->u.kernel.TYPE->TYPE##size))
+			K->u.kernel.TYPE->TYPE##size,			\
+			XT_ALIGN(K->u.kernel.TYPE->TYPE##size))
 
 int xt_match_to_user(const struct xt_entry_match *m,
 		     struct xt_entry_match __user *u)
 {
 	return XT_OBJ_TO_USER(u, m, match, 0) ||
-	       XT_DATA_TO_USER(u, m, match, 0);
+	       XT_DATA_TO_USER(u, m, match);
 }
 EXPORT_SYMBOL_GPL(xt_match_to_user);
 
@@ -315,7 +314,7 @@ int xt_target_to_user(const struct xt_entry_target *t,
 		      struct xt_entry_target __user *u)
 {
 	return XT_OBJ_TO_USER(u, t, target, 0) ||
-	       XT_DATA_TO_USER(u, t, target, 0);
+	       XT_DATA_TO_USER(u, t, target);
 }
 EXPORT_SYMBOL_GPL(xt_target_to_user);
 
@@ -614,6 +613,12 @@ void xt_compat_match_from_user(struct xt_entry_match *m, void **dstptr,
 }
 EXPORT_SYMBOL_GPL(xt_compat_match_from_user);
 
+#define COMPAT_XT_DATA_TO_USER(U, K, TYPE, C_SIZE)			\
+	xt_data_to_user(U->data, K->data,				\
+			K->u.kernel.TYPE->usersize,			\
+			C_SIZE,						\
+			COMPAT_XT_ALIGN(C_SIZE))
+
 int xt_compat_match_to_user(const struct xt_entry_match *m,
 			    void __user **dstptr, unsigned int *size)
 {
@@ -629,7 +634,7 @@ int xt_compat_match_to_user(const struct xt_entry_match *m,
 		if (match->compat_to_user((void __user *)cm->data, m->data))
 			return -EFAULT;
 	} else {
-		if (XT_DATA_TO_USER(cm, m, match, msize - sizeof(*cm)))
+		if (COMPAT_XT_DATA_TO_USER(cm, m, match, msize - sizeof(*cm)))
 			return -EFAULT;
 	}
 
@@ -975,7 +980,7 @@ int xt_compat_target_to_user(const struct xt_entry_target *t,
 		if (target->compat_to_user((void __user *)ct->data, t->data))
 			return -EFAULT;
 	} else {
-		if (XT_DATA_TO_USER(ct, t, target, tsize - sizeof(*ct)))
+		if (COMPAT_XT_DATA_TO_USER(ct, t, target, tsize - sizeof(*ct)))
 			return -EFAULT;
 	}
 
-- 
2.13.0.303.g4ebf302169-goog

