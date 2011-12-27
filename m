From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 4/4] netfilter: xtables: collapse conditions in xt_ecn
Date: Tue, 27 Dec 2011 19:57:52 +0100
Message-ID: <1325012273-11779-5-git-send-email-jengelh@medozas.de>
References: <1325012273-11779-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:35712 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902Ab1L0S57 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Dec 2011 13:57:59 -0500
In-Reply-To: <1325012273-11779-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

One simplifcation of an if clause.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/netfilter/xt_ecn.c |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/xt_ecn.c b/net/netfilter/xt_ecn.c
index 6ccc35d..3c831a8 100644
--- a/net/netfilter/xt_ecn.c
+++ b/net/netfilter/xt_ecn.c
@@ -37,9 +37,8 @@ static bool match_tcp(const struct sk_buff *skb, struct xt_action_param *par)
 	 * be good citizens.
 	 */
 	th = skb_header_pointer(skb, par->thoff, sizeof(_tcph), &_tcph);
-	if (th == NULL) {
+	if (th == NULL)
 		return false;
-	}
 
 	if (einfo->operation & XT_ECN_OP_MATCH_ECE) {
 		if (einfo->invert & XT_ECN_OP_MATCH_ECE) {
@@ -75,14 +74,12 @@ static bool ecn_mt4(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_ecn_info *info = par->matchinfo;
 
-	if (info->operation & XT_ECN_OP_MATCH_IP)
-		if (!match_ip(skb, info))
-			return false;
+	if (info->operation & XT_ECN_OP_MATCH_IP && !match_ip(skb, info))
+		return false;
 
-	if (info->operation & (XT_ECN_OP_MATCH_ECE | XT_ECN_OP_MATCH_CWR)) {
-		if (!match_tcp(skb, par))
-			return false;
-	}
+	if (info->operation & (XT_ECN_OP_MATCH_ECE | XT_ECN_OP_MATCH_CWR) &&
+	    !match_tcp(skb, par))
+		return false;
 
 	return true;
 }
-- 
1.7.3.4

