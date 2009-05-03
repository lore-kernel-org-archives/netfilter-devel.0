From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 5/9] libxt_helper: fix invalid passed option to check_inverse
Date: Sun,  3 May 2009 21:54:29 +0200
Message-ID: <1241380473-22262-6-git-send-email-jengelh@medozas.de>
References: <1241380473-22262-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34572 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395AbZECTyg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 May 2009 15:54:36 -0400
In-Reply-To: <1241380473-22262-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

(Next commit found this.)

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_helper.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/extensions/libxt_helper.c b/extensions/libxt_helper.c
index bfb5ae3..2dda021 100644
--- a/extensions/libxt_helper.c
+++ b/extensions/libxt_helper.c
@@ -32,7 +32,7 @@ helper_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags)
 			xtables_error(PARAMETER_PROBLEM,
 					"helper match: Only use --helper ONCE!");
-		xtables_check_inverse(optarg, &invert, &invert, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		strncpy(info->name, optarg, 29);
 		info->name[29] = '\0';
 		if (invert)
-- 
1.6.2.2

