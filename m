From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 6/7] policy: fix error message showing wrong option
Date: Mon,  1 Feb 2010 01:19:52 +0100
Message-ID: <1264983594-20871-7-git-send-email-jengelh@medozas.de>
References: <1264983594-20871-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49661 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754577Ab0BAAUE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 31 Jan 2010 19:20:04 -0500
In-Reply-To: <1264983594-20871-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 extensions/libxt_policy.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/extensions/libxt_policy.c b/extensions/libxt_policy.c
index 521bac1..a87ddd8 100644
--- a/extensions/libxt_policy.c
+++ b/extensions/libxt_policy.c
@@ -292,7 +292,7 @@ static void policy_check(unsigned int flags)
 
 	if (!(info->flags & (XT_POLICY_MATCH_IN | XT_POLICY_MATCH_OUT)))
 		xtables_error(PARAMETER_PROBLEM,
-		           "policy match: neither --in nor --out specified");
+		           "policy match: neither --dir in nor --dir out specified");
 
 	if (info->flags & XT_POLICY_MATCH_NONE) {
 		if (info->flags & XT_POLICY_MATCH_STRICT)
-- 
1.6.6.1

