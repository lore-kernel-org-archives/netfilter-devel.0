From: fgao@ikuai8.com
Subject: [PATCH nf-next] netfilter: xt_multiport: Use switch case instead of multiple condition checks
Date: Mon, 26 Sep 2016 21:23:37 +0800
Message-ID: <1474896217-31351-1-git-send-email-fgao@ikuai8.com>
Cc: gfree.wind@gmail.com, Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from SMTPBG351.QQ.COM ([183.57.50.165]:39550 "EHLO smtpbg351.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932141AbcIZNYL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Sep 2016 09:24:11 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

There are multiple equality condition checks in the original codes, so it
is better to use switch case instead of them.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 net/netfilter/xt_multiport.c | 40 +++++++++++++++++++++-------------------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff --git a/net/netfilter/xt_multiport.c b/net/netfilter/xt_multiport.c
index ac1d3c3..ec06fb1 100644
--- a/net/netfilter/xt_multiport.c
+++ b/net/netfilter/xt_multiport.c
@@ -42,29 +42,31 @@ ports_match_v1(const struct xt_multiport_v1 *minfo,
 			e = minfo->ports[++i];
 			pr_debug("src or dst matches with %d-%d?\n", s, e);
 
-			if (minfo->flags == XT_MULTIPORT_SOURCE
-			    && src >= s && src <= e)
-				return true ^ minfo->invert;
-			if (minfo->flags == XT_MULTIPORT_DESTINATION
-			    && dst >= s && dst <= e)
-				return true ^ minfo->invert;
-			if (minfo->flags == XT_MULTIPORT_EITHER
-			    && ((dst >= s && dst <= e)
-				|| (src >= s && src <= e)))
-				return true ^ minfo->invert;
+			switch (minfo->flags) {
+			case XT_MULTIPORT_SOURCE:
+				return (src >= s && src <= e) ^ minfo->invert;
+			case XT_MULTIPORT_DESTINATION:
+				return (dst >= s && dst <= e) ^ minfo->invert;
+			case XT_MULTIPORT_EITHER:
+				return ((dst >= s && dst <= e) ||
+					(src >= s && src <= e)) ^ minfo->invert;
+			default:
+				break;
+			}
 		} else {
 			/* exact port matching */
 			pr_debug("src or dst matches with %d?\n", s);
 
-			if (minfo->flags == XT_MULTIPORT_SOURCE
-			    && src == s)
-				return true ^ minfo->invert;
-			if (minfo->flags == XT_MULTIPORT_DESTINATION
-			    && dst == s)
-				return true ^ minfo->invert;
-			if (minfo->flags == XT_MULTIPORT_EITHER
-			    && (src == s || dst == s))
-				return true ^ minfo->invert;
+			switch (minfo->flags) {
+			case XT_MULTIPORT_SOURCE:
+				return (src == s) ^ minfo->invert;
+			case XT_MULTIPORT_DESTINATION:
+				return (dst == s) ^ minfo->invert;
+			case XT_MULTIPORT_EITHER:
+				return (src == s || dst == s) ^ minfo->invert;
+			default:
+				break;
+			}
 		}
 	}
 
-- 
1.9.1


