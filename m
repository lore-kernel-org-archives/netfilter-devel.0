From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf 2/3] netfilter: cttimeout: put back l4proto when replacing timeout policy
Date: Mon, 22 Aug 2016 21:58:17 +0800
Message-ID: <1471874298-20503-2-git-send-email-zlpnobody@163.com>
References: <1471874298-20503-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-18.163.com ([220.181.12.18]:52217 "EHLO m12-18.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755702AbcHVN7S (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Aug 2016 09:59:18 -0400
In-Reply-To: <1471874298-20503-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

We forget to call nf_ct_l4proto_put when replacing the existing
timeout policy. Acctually, there's no need to get ct l4proto
before doing replace, so we can move it to a later position.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 net/netfilter/nfnetlink_cttimeout.c | 33 +++++++++++++++------------------
 1 file changed, 15 insertions(+), 18 deletions(-)

diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index f74fee1..6844c7a 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -98,31 +98,28 @@ static int cttimeout_new_timeout(struct net *net, struct sock *ctnl,
 		break;
 	}
 
-	l4proto = nf_ct_l4proto_find_get(l3num, l4num);
-
-	/* This protocol is not supportted, skip. */
-	if (l4proto->l4proto != l4num) {
-		ret = -EOPNOTSUPP;
-		goto err_proto_put;
-	}
-
 	if (matching) {
 		if (nlh->nlmsg_flags & NLM_F_REPLACE) {
 			/* You cannot replace one timeout policy by another of
 			 * different kind, sorry.
 			 */
 			if (matching->l3num != l3num ||
-			    matching->l4proto->l4proto != l4num) {
-				ret = -EINVAL;
-				goto err_proto_put;
-			}
-
-			ret = ctnl_timeout_parse_policy(&matching->data,
-							l4proto, net,
-							cda[CTA_TIMEOUT_DATA]);
-			return ret;
+			    matching->l4proto->l4proto != l4num)
+				return -EINVAL;
+
+			return ctnl_timeout_parse_policy(&matching->data,
+							 matching->l4proto, net,
+							 cda[CTA_TIMEOUT_DATA]);
 		}
-		ret = -EBUSY;
+
+		return -EBUSY;
+	}
+
+	l4proto = nf_ct_l4proto_find_get(l3num, l4num);
+
+	/* This protocol is not supportted, skip. */
+	if (l4proto->l4proto != l4num) {
+		ret = -EOPNOTSUPP;
 		goto err_proto_put;
 	}
 
-- 
2.5.5


