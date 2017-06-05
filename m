From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: [PATCH iptables 3/3] xtables-translate: fix double space before comment
Date: Tue,  6 Jun 2017 00:08:28 +0200
Message-ID: <20170605220828.4738-3-pablombg@gmail.com>
References: <20170605220828.4738-1-pablombg@gmail.com>
Cc: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35390 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751276AbdFEWK2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Jun 2017 18:10:28 -0400
Received: by mail-wm0-f68.google.com with SMTP id g15so32005992wmc.2
        for <netfilter-devel@vger.kernel.org>; Mon, 05 Jun 2017 15:10:27 -0700 (PDT)
In-Reply-To: <20170605220828.4738-1-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When a comment translation immediately follows a counter statement, two
spaces are printed between "counter" and "comment" keywords.

The counter statement is almost always followed by a target, so we need
to move the space following "counter" to the beginning of the target
translation.

Signed-off-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
---
 iptables/nft-ipv4.c          |  2 +-
 iptables/nft-ipv6.c          |  2 +-
 iptables/xtables-translate.c | 11 ++++++-----
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index e5947a7c..cf311513 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -488,7 +488,7 @@ static int nft_ipv4_xlate(const void *data, struct xt_xlate *xl)
 		return ret;
 
 	/* Always add counters per rule, as in iptables */
-	xt_xlate_add(xl, "counter ");
+	xt_xlate_add(xl, "counter");
 	ret = xlate_action(cs, !!(cs->fw.ip.flags & IPT_F_GOTO), xl);
 
 	comment = xt_xlate_get_comment(xl);
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index 9cf4058f..53526369 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -437,7 +437,7 @@ static int nft_ipv6_xlate(const void *data, struct xt_xlate *xl)
 		return ret;
 
 	/* Always add counters per rule, as in iptables */
-	xt_xlate_add(xl, "counter ");
+	xt_xlate_add(xl, "counter");
 	ret = xlate_action(cs, !!(cs->fw6.ipv6.flags & IP6T_F_GOTO), xl);
 
 	comment = xt_xlate_get_comment(xl);
diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
index e049f24e..3e6c7051 100644
--- a/iptables/xtables-translate.c
+++ b/iptables/xtables-translate.c
@@ -60,12 +60,13 @@ int xlate_action(const struct iptables_command_state *cs, bool goto_set,
 	if (cs->target != NULL) {
 		/* Standard target? */
 		if (strcmp(cs->jumpto, XTC_LABEL_ACCEPT) == 0)
-			xt_xlate_add(xl, "accept");
+			xt_xlate_add(xl, " accept");
 		else if (strcmp(cs->jumpto, XTC_LABEL_DROP) == 0)
-			xt_xlate_add(xl, "drop");
+			xt_xlate_add(xl, " drop");
 		else if (strcmp(cs->jumpto, XTC_LABEL_RETURN) == 0)
-			xt_xlate_add(xl, "return");
+			xt_xlate_add(xl, " return");
 		else if (cs->target->xlate) {
+			xt_xlate_add(xl, " ");
 			struct xt_xlate_tg_params params = {
 				.ip		= (const void *)&cs->fw,
 				.target		= cs->target->t,
@@ -79,9 +80,9 @@ int xlate_action(const struct iptables_command_state *cs, bool goto_set,
 	} else if (strlen(cs->jumpto) > 0) {
 		/* Not standard, then it's a go / jump to chain */
 		if (goto_set)
-			xt_xlate_add(xl, "goto %s", cs->jumpto);
+			xt_xlate_add(xl, " goto %s", cs->jumpto);
 		else
-			xt_xlate_add(xl, "jump %s", cs->jumpto);
+			xt_xlate_add(xl, " jump %s", cs->jumpto);
 	}
 
 	return ret;
-- 
2.11.0

