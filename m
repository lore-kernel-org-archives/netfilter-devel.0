From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 11/21] xtoptions: flag use of XTOPT_POINTER without XTOPT_PUT
Date: Sun, 21 Aug 2011 13:09:26 +0200
Message-ID: <1313924977-8623-12-git-send-email-jengelh@medozas.de>
References: <1313924977-8623-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:38746 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754303Ab1HULJv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 21 Aug 2011 07:09:51 -0400
In-Reply-To: <1313924977-8623-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When XTOPT_POINTER is used (and yields a non-zero offsetof), we can
flag the absence of XTOPT_PUT.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 iptables/xtoptions.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/iptables/xtoptions.c b/iptables/xtoptions.c
index 7095e3e..04344af 100644
--- a/iptables/xtoptions.c
+++ b/iptables/xtoptions.c
@@ -847,8 +847,14 @@ void xtables_option_metavalidate(const char *name,
 			xt_params->exit_err(OTHER_PROBLEM,
 				"Extension %s uses invalid ID %u\n",
 				name, entry->id);
-		if (!(entry->flags & XTOPT_PUT))
+		if (!(entry->flags & XTOPT_PUT)) {
+			if (entry->ptroff != 0)
+				xt_params->exit_err(OTHER_PROBLEM,
+					"%s: ptroff for \"--%s\" is non-"
+					"zero but no XTOPT_PUT is specified. "
+					"Oversight?", name, entry->name);
 			continue;
+		}
 		if (entry->type >= ARRAY_SIZE(xtopt_psize) ||
 		    xtopt_psize[entry->type] == 0)
 			xt_params->exit_err(OTHER_PROBLEM,
-- 
1.7.3.4

