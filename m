From: fgao@ikuai8.com
Subject: [PATCH nf-next v2 1/1] netfilter: xt_multiport: Fix wrong unmatch result with multiple ports
Date: Fri, 25 Nov 2016 12:07:07 +0800
Message-ID: <1480046827-9956-1-git-send-email-fgao@ikuai8.com>
Cc: gfree.wind@gmail.com, Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from SMTPBG252.QQ.COM ([183.60.52.105]:52296 "EHLO smtpbg252.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751500AbcKYEQA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Nov 2016 23:16:00 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

I lost one test case in the last commit for xt_multiport.
For example, the rule is "-m multiport --dports 22,80,443".
When first port is unmatched and the second is matched, the curent codes
could not return the right result.
It would return false directly when the first port is unmatched.

Fixes: dd2602d00f80 ("netfilter: xt_multiport: Use switch case instead
of multiple condition checks")

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 v2: Correct the title and rollback the space lines
 v1: Initial version

 net/netfilter/xt_multiport.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/xt_multiport.c b/net/netfilter/xt_multiport.c
index ec06fb1..1cde0e4 100644
--- a/net/netfilter/xt_multiport.c
+++ b/net/netfilter/xt_multiport.c
@@ -44,12 +44,18 @@
 
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
@@ -59,11 +65,17 @@
 
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


