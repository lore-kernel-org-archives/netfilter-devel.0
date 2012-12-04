From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 8/8] netfilter: xtables2: execute targets in live rule traversal
Date: Tue,  4 Dec 2012 02:00:49 +0100
Message-ID: <1354582849-26888-9-git-send-email-jengelh@inai.de>
References: <1354582849-26888-1-git-send-email-jengelh@inai.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:49571 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751817Ab2LDBBA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Dec 2012 20:01:00 -0500
In-Reply-To: <1354582849-26888-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 net/netfilter/xt_core.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/netfilter/xt_core.c b/net/netfilter/xt_core.c
index 8615fe4..830260c 100644
--- a/net/netfilter/xt_core.c
+++ b/net/netfilter/xt_core.c
@@ -111,6 +111,14 @@ xt2_do_rule(struct sk_buff *skb, const struct xt2_packed_rule *rule,
 			acpar->matchinfo = pa->data;
 			if (!pa->match_ext->match(skb, acpar))
 				break;
+		} else if (pa->type == NFXT_ACTION_TARGET) {
+			unsigned int verdict;
+
+			acpar->target   = pa->target_ext;
+			acpar->targinfo = pa->data;
+			verdict = pa->target_ext->target(skb, acpar);
+			if (verdict != XT_CONTINUE)
+				return verdict;
 		}
 
 	return XT_CONTINUE;
-- 
1.7.10.4

