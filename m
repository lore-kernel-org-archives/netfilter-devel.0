From: fgao@ikuai8.com
Subject: [PATCH net-next 1/1] netfilter: xt_multiport: Fix wrong unmatch result with multiple ports
Date: Fri, 25 Nov 2016 11:58:57 +0800
Message-ID: <1480046337-9521-1-git-send-email-fgao@ikuai8.com>
Cc: gfree.wind@gmail.com, Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbg291.qq.com ([113.108.11.223]:57379 "EHLO smtpbg291.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751499AbcKYEHK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Nov 2016 23:07:10 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

I lost one test case in the commit for xt_multiport.
For example, the rule is "-m multiport --dports 22,80,443".
When first port is unmatched and the second is matched, the curent codes
could not return the right result.
It would return false directly when the first port is unmatched.

Fixes: dd2602d00f80 ("netfilter: xt_multiport: Use switch case instead
of multiple condition checks")

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 net/netfilter/xt_multiport.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/xt_multiport.c b/net/netfilter/xt_multiport.c
index ec06fb1..a99da44 100644
--- a/net/netfilter/xt_multiport.c
+++ b/net/netfilter/xt_multiport.c
@@ -41,29 +41,39 @@
 			/* range port matching */
 			e = minfo->ports[++i];
 			pr_debug("src or dst matches with %d-%d?\n", s, e);
-
 			switch (minfo->flags) {
 			case XT_MULTIPORT_SOURCE:
-				return (src >= s && src <= e) ^ minfo->invert;
+				if (src >= s && src <= e)
+					return true ^ minfo->invert;
+				break;
 			case XT_MULTIPORT_DESTINATION:
-				return (dst >= s && dst <= e) ^ minfo->invert;
+				if (dst >= s && dst <= e)
+					return true ^ minfo->invert;
+				break;
 			case XT_MULTIPORT_EITHER:
-				return ((dst >= s && dst <= e) ||
-					(src >= s && src <= e)) ^ minfo->invert;
+				if ((dst >= s && dst <= e) ||
+				    (src >= s && src <= e))
+					return true ^ minfo->invert;
+				break;
 			default:
 				break;
 			}
 		} else {
 			/* exact port matching */
 			pr_debug("src or dst matches with %d?\n", s);
-
 			switch (minfo->flags) {
 			case XT_MULTIPORT_SOURCE:
-				return (src == s) ^ minfo->invert;
+				if (src == s)
+					return true ^ minfo->invert;
+				break;
 			case XT_MULTIPORT_DESTINATION:
-				return (dst == s) ^ minfo->invert;
+				if (dst == s)
+					return true ^ minfo->invert;
+				break;
 			case XT_MULTIPORT_EITHER:
-				return (src == s || dst == s) ^ minfo->invert;
+				if (src == s || dst == s)
+					return true ^ minfo->invert;
+				break;
 			default:
 				break;
 			}
-- 
1.9.1


