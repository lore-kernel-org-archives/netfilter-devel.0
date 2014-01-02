From: Eric Leblond <eric@regit.org>
Subject: [PATCH] netfilter: CT: improve error treatment
Date: Thu,  2 Jan 2014 10:03:45 +0100
Message-ID: <1388653425-30466-1-git-send-email-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: -pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:54749 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbaABJEA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Jan 2014 04:04:00 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If setting event mask fails then we were returning 0 for success.
This patch updates return code to -EINVAL in case of problem.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 net/netfilter/xt_CT.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index da35ac0..5929be6 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -211,8 +211,10 @@ static int xt_ct_tg_check(const struct xt_tgchk_param *par,
 	ret = 0;
 	if ((info->ct_events || info->exp_events) &&
 	    !nf_ct_ecache_ext_add(ct, info->ct_events, info->exp_events,
-				  GFP_KERNEL))
+				  GFP_KERNEL)) {
+		ret = -EINVAL;
 		goto err3;
+	}
 
 	if (info->helper[0]) {
 		ret = xt_ct_set_helper(ct, info->helper, par);
-- 
1.8.5.2

