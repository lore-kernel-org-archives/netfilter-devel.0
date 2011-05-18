From: Lutz Jaenicke <ljaenicke@innominate.com>
Subject: [PATCH] libipt_REDIRECT: "--to-ports" is not mandatory
Date: Wed, 18 May 2011 15:11:47 +0200
Message-ID: <1305724307-13698-1-git-send-email-ljaenicke@innominate.com>
Cc: Lutz Jaenicke <ljaenicke@innominate.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.innominate.com ([77.245.32.75]:33357 "EHLO
	home.innominate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757011Ab1ERNMA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 May 2011 09:12:00 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The REDIRECT target can be called without the --to-ports option
being specified. From the manual page:
  ...without this, the destination port is never altered.

Signed-off-by: Lutz Jaenicke <ljaenicke@innominate.com>
---
 extensions/libipt_REDIRECT.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/extensions/libipt_REDIRECT.c b/extensions/libipt_REDIRECT.c
index 426a746..e67360a 100644
--- a/extensions/libipt_REDIRECT.c
+++ b/extensions/libipt_REDIRECT.c
@@ -23,8 +23,7 @@ static void REDIRECT_help(void)
 }
 
 static const struct xt_option_entry REDIRECT_opts[] = {
-	{.name = "to-ports", .id = O_TO_PORTS, .type = XTTYPE_STRING,
-	 .flags = XTOPT_MAND},
+	{.name = "to-ports", .id = O_TO_PORTS, .type = XTTYPE_STRING},
 	{.name = "random", .id = O_RANDOM, .type = XTTYPE_NONE},
 	XTOPT_TABLEEND,
 };
-- 
1.7.2.5

