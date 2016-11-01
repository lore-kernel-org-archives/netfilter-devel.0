From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 01/12] netfilter: xt_multiport: Use switch case instead of multiple condition checks
Date: Tue,  1 Nov 2016 22:26:22 +0100
Message-ID: <1478035593-1362-2-git-send-email-pablo@netfilter.org>
References: <1478035593-1362-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52488 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751022AbcKAV0r (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Nov 2016 17:26:47 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6E079168383
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Nov 2016 22:26:44 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 57562DA91B
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Nov 2016 22:26:44 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4756FDA84D
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Nov 2016 22:26:39 +0100 (CET)
In-Reply-To: <1478035593-1362-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

There are multiple equality condition checks in the original codes, so it
is better to use switch case instead of them.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_multiport.c | 40 +++++++++++++++++++++-------------------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff --git a/net/netfilter/xt_multiport.c b/net/netfilter/xt_multiport.c
index ac1d3c3d09e7..ec06fb1cb16f 100644
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
2.1.4

