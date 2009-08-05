From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/2] libxt_helper: fix invalid passed option to check_inverse
Date: Wed,  5 Aug 2009 18:22:35 +0200
Message-ID: <1249489355-20598-3-git-send-email-jengelh@medozas.de>
References: <1249489355-20598-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:55954 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934321AbZHEQWl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Aug 2009 12:22:41 -0400
In-Reply-To: <1249489355-20598-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_helper.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/extensions/libxt_helper.c b/extensions/libxt_helper.c
index 7b56bef..b136d8a 100644
--- a/extensions/libxt_helper.c
+++ b/extensions/libxt_helper.c
@@ -31,7 +31,7 @@ helper_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags)
 			xtables_error(PARAMETER_PROBLEM,
 					"helper match: Only use --helper ONCE!");
-		xtables_check_inverse(optarg, &invert, &invert, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		strncpy(info->name, optarg, 29);
 		info->name[29] = '\0';
 		if (invert)
-- 
1.6.3.3

