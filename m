From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 09/21] libxt_hashlimit: default htable-expire must be in milliseconds
Date: Sun, 21 Aug 2011 13:09:24 +0200
Message-ID: <1313924977-8623-10-git-send-email-jengelh@medozas.de>
References: <1313924977-8623-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:38737 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754307Ab1HULJt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 21 Aug 2011 07:09:49 -0400
In-Reply-To: <1313924977-8623-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Bug goes back to v1.4.12~3^2~11.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_hashlimit.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_hashlimit.c b/extensions/libxt_hashlimit.c
index a838680..89320bb 100644
--- a/extensions/libxt_hashlimit.c
+++ b/extensions/libxt_hashlimit.c
@@ -315,7 +315,7 @@ static void hashlimit_check(struct xt_fcheck_call *cb)
 		xtables_error(PARAMETER_PROBLEM,
 				"You have to specify --hashlimit");
 	if (!(cb->xflags & F_HTABLE_EXPIRE))
-		info->cfg.expire = udata->mult;
+		info->cfg.expire = udata->mult * 1000; /* from s to msec */
 }
 
 static void hashlimit_mt_check(struct xt_fcheck_call *cb)
@@ -327,7 +327,7 @@ static void hashlimit_mt_check(struct xt_fcheck_call *cb)
 		xtables_error(PARAMETER_PROBLEM,
 				"You have to specify --hashlimit");
 	if (!(cb->xflags & F_HTABLE_EXPIRE))
-		info->cfg.expire = udata->mult;
+		info->cfg.expire = udata->mult * 1000; /* from s to msec */
 }
 
 static const struct rates
-- 
1.7.3.4

