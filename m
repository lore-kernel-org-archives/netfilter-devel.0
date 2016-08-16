From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: [PATCH iptables 1/2] xtables-translate: add escape_quotes option to comment_xlate
Date: Tue, 16 Aug 2016 19:44:32 +0200
Message-ID: <20160816174433.28272-1-pablombg@gmail.com>
Cc: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:32778 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbcHPRpD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Aug 2016 13:45:03 -0400
Received: by mail-wm0-f68.google.com with SMTP id o80so17682416wme.0
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Aug 2016 10:45:03 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The comment_xlate function was not supporting this option that is
necessary in some situations.

Signed-off-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
---
 extensions/libxt_comment.c | 9 ++++++++-
 iptables/nft-ipv4.c        | 2 +-
 iptables/nft-ipv6.c        | 2 +-
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/extensions/libxt_comment.c b/extensions/libxt_comment.c
index 0e31edd..bf9a039 100644
--- a/extensions/libxt_comment.c
+++ b/extensions/libxt_comment.c
@@ -52,9 +52,16 @@ static int comment_xlate(struct xt_xlate *xl,
 			 const struct xt_xlate_mt_params *params)
 {
 	struct xt_comment_info *commentinfo = (void *)params->match->data;
+	char comment[XT_MAX_COMMENT_LEN];
 
 	commentinfo->comment[XT_MAX_COMMENT_LEN - 1] = '\0';
-	xt_xlate_add_comment(xl, commentinfo->comment);
+	if (params->escape_quotes)
+		snprintf(comment, XT_MAX_COMMENT_LEN, "comment \\\"%s\\\"",
+			 commentinfo->comment);
+	else
+		snprintf(comment, XT_MAX_COMMENT_LEN, "comment \"%s\"",
+			 commentinfo->comment);
+	xt_xlate_add_comment(xl, comment);
 
 	return 1;
 }
diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index 50706cb..f5c0d95 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -490,7 +490,7 @@ static int nft_ipv4_xlate(const void *data, struct xt_xlate *xl)
 
 	comment = xt_xlate_get_comment(xl);
 	if (comment)
-		xt_xlate_add(xl, "comment \\\"%s\\\" ", comment);
+		xt_xlate_add(xl, "%s", comment);
 
 	ret = xlate_action(cs, !!(cs->fw.ip.flags & IPT_F_GOTO), xl);
 
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index 8ca523c..3792c68 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -439,7 +439,7 @@ static int nft_ipv6_xlate(const void *data, struct xt_xlate *xl)
 
 	comment = xt_xlate_get_comment(xl);
 	if (comment)
-		xt_xlate_add(xl, "comment \\\"%s\\\" ", comment);
+		xt_xlate_add(xl, "%s", comment);
 
 	ret = xlate_action(cs, !!(cs->fw6.ipv6.flags & IP6T_F_GOTO), xl);
 
-- 
2.9.3

