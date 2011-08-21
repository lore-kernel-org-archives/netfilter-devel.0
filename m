From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 19/21] libxt_policy: remove superfluous inversion
Date: Sun, 21 Aug 2011 13:09:34 +0200
Message-ID: <1313924977-8623-20-git-send-email-jengelh@medozas.de>
References: <1313924977-8623-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:38779 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754418Ab1HULKA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 21 Aug 2011 07:10:00 -0400
In-Reply-To: <1313924977-8623-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--dir cannot be inverted.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_policy.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_policy.c b/extensions/libxt_policy.c
index 97722d6..54ec229 100644
--- a/extensions/libxt_policy.c
+++ b/extensions/libxt_policy.c
@@ -40,8 +40,7 @@ static void policy_help(void)
 }
 
 static const struct xt_option_entry policy_opts[] = {
-	{.name = "dir", .id = O_DIRECTION, .type = XTTYPE_STRING,
-	 .flags = XTOPT_INVERT},
+	{.name = "dir", .id = O_DIRECTION, .type = XTTYPE_STRING},
 	{.name = "pol", .id = O_POLICY, .type = XTTYPE_STRING},
 	{.name = "strict", .id = O_STRICT, .type = XTTYPE_NONE},
 	{.name = "reqid", .id = O_REQID, .type = XTTYPE_UINT32,
-- 
1.7.3.4

