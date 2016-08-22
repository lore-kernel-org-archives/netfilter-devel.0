From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: [PATCH iptables v2 1/2] xtables-translate: add escape_quotes option to comment_xlate
Date: Mon, 22 Aug 2016 12:56:14 +0200
Message-ID: <20160822105615.32483-1-pablombg@gmail.com>
Cc: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35404 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752859AbcHVK4t (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Aug 2016 06:56:49 -0400
Received: by mail-wm0-f66.google.com with SMTP id i5so12878388wmg.2
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2016 03:56:49 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The comment_xlate function was not supporting this option that is
necessary in some situations.

Signed-off-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
---

Changes in v2:
  - Ensure that the comment string is null-terminated.

 extensions/libxt_comment.c | 11 ++++++++++-
 iptables/nft-ipv4.c        |  2 +-
 iptables/nft-ipv6.c        |  2 +-
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/extensions/libxt_comment.c b/extensions/libxt_comment.c
index 0e31edd..b635d16 100644
--- a/extensions/libxt_comment.c
+++ b/extensions/libxt_comment.c
@@ -52,9 +52,18 @@ static int comment_xlate(struct xt_xlate *xl,
 			 const struct xt_xlate_mt_params *params)
 {
 	struct xt_comment_info *commentinfo = (void *)params->match->data;
+	char comment[XT_MAX_COMMENT_LEN];
 
 	commentinfo->comment[XT_MAX_COMMENT_LEN - 1] = '\0';
-	xt_xlate_add_comment(xl, commentinfo->comment);
+	if (params->escape_quotes)
+		snprintf(comment, XT_MAX_COMMENT_LEN, "\\\"%s\\\"",
+			 commentinfo->comment);
+	else
+		snprintf(comment, XT_MAX_COMMENT_LEN, "\"%s\"",
+			 commentinfo->comment);
+
+	comment[XT_MAX_COMMENT_LEN - 1] = '\0';
+	xt_xlate_add_comment(xl, comment);
 
 	return 1;
 }
diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index 50706cb..295dd42 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -490,7 +490,7 @@ static int nft_ipv4_xlate(const void *data, struct xt_xlate *xl)
 
 	comment = xt_xlate_get_comment(xl);
 	if (comment)
-		xt_xlate_add(xl, "comment \\\"%s\\\" ", comment);
+		xt_xlate_add(xl, "comment %s", comment);
 
 	ret = xlate_action(cs, !!(cs->fw.ip.flags & IPT_F_GOTO), xl);
 
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index 8ca523c..8bebf6b 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -439,7 +439,7 @@ static int nft_ipv6_xlate(const void *data, struct xt_xlate *xl)
 
 	comment = xt_xlate_get_comment(xl);
 	if (comment)
-		xt_xlate_add(xl, "comment \\\"%s\\\" ", comment);
+		xt_xlate_add(xl, "comment %s", comment);
 
 	ret = xlate_action(cs, !!(cs->fw6.ipv6.flags & IP6T_F_GOTO), xl);
 
-- 
2.9.3

