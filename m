From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 29/50] netfilter: xt_multiport: Fix wrong unmatch result with multiple ports
Date: Wed,  7 Dec 2016 22:52:35 +0100
Message-ID: <1481147576-5690-30-git-send-email-pablo@netfilter.org>
References: <1481147576-5690-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1481147576-5690-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Gao Feng <fgao@ikuai8.com>

I lost one test case in the last commit for xt_multiport.
For example, the rule is "-m multiport --dports 22,80,443".
When first port is unmatched and the second is matched, the curent codes
could not return the right result.
It would return false directly when the first port is unmatched.

Fixes: dd2602d00f80 ("netfilter: xt_multiport: Use switch case instead
of multiple condition checks")
Signed-off-by: Gao Feng <fgao@ikuai8.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_multiport.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/xt_multiport.c b/net/netfilter/xt_multiport.c
index ec06fb1cb16f..1cde0e4985b7 100644
--- a/net/netfilter/xt_multiport.c
+++ b/net/netfilter/xt_multiport.c
@@ -44,12 +44,18 @@ ports_match_v1(const struct xt_multiport_v1 *minfo,
 
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
@@ -59,11 +65,17 @@ ports_match_v1(const struct xt_multiport_v1 *minfo,
 
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
2.1.4
