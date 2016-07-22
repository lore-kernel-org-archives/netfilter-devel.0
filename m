From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: [PATCH iptables 1/2] xtables-translate: add new field to identify the caller
Date: Fri, 22 Jul 2016 17:48:33 +0200
Message-ID: <20160722154834.1802-1-pablombg@gmail.com>
Cc: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35488 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbcGVPtj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Jul 2016 11:49:39 -0400
Received: by mail-wm0-f67.google.com with SMTP id i5so6696912wmg.2
        for <netfilter-devel@vger.kernel.org>; Fri, 22 Jul 2016 08:49:39 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In some cases, xlate functions must print a different result if they are
invoked from nft and not from a xtables-translate command.

This commit adds a new boolean field to the xt_xlate struct. This
variable must be true when a xlate function is called from a nft
command. Additional code is required in nft in order to obtain this
behavior.

Signed-off-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
---
 include/xtables.h    |  2 ++
 libxtables/xtables.c | 12 ++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/include/xtables.h b/include/xtables.h
index 48be514..fd72623 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -576,6 +576,8 @@ void xt_xlate_add(struct xt_xlate *xl, const char *fmt, ...);
 void xt_xlate_add_comment(struct xt_xlate *xl, const char *comment);
 const char *xt_xlate_get_comment(struct xt_xlate *xl);
 const char *xt_xlate_get(struct xt_xlate *xl);
+void xt_xlate_set_nft_compat(struct xt_xlate *xl, bool nft_compat);
+bool xt_xlate_get_nft_compat(struct xt_xlate *xl);
 
 #ifdef XTABLES_INTERNAL
 
diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index 921dfe9..1c3f63d 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -2011,6 +2011,7 @@ struct xt_xlate {
 		int	off;
 	} buf;
 	char comment[NFT_USERDATA_MAXLEN];
+	bool nft_compat;
 };
 
 struct xt_xlate *xt_xlate_alloc(int size)
@@ -2029,6 +2030,7 @@ struct xt_xlate *xt_xlate_alloc(int size)
 	xl->buf.rem = size;
 	xl->buf.off = 0;
 	xl->comment[0] = '\0';
+	xl->nft_compat = false;
 
 	return xl;
 }
@@ -2069,3 +2071,13 @@ const char *xt_xlate_get(struct xt_xlate *xl)
 {
 	return xl->buf.data;
 }
+
+void xt_xlate_set_nft_compat(struct xt_xlate *xl, bool nft_compat)
+{
+	xl->nft_compat = nft_compat;
+}
+
+bool xt_xlate_get_nft_compat(struct xt_xlate *xl)
+{
+	return xl->nft_compat;
+}
-- 
2.9.0

