From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 02/13] libipt_REDIRECT: "--to-ports" is not mandatory
Date: Mon, 23 May 2011 16:39:12 +0200
Message-ID: <1306161564-4370-3-git-send-email-jengelh@medozas.de>
References: <1306161564-4370-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:44608 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755436Ab1EWOj2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 May 2011 10:39:28 -0400
In-Reply-To: <1306161564-4370-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Lutz Jaenicke <ljaenicke@innominate.com>

The REDIRECT target can be called without the --to-ports option
being specified. From the manual page:
  ...without this, the destination port is never altered.

Signed-off-by: Lutz Jaenicke <ljaenicke@innominate.com>
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
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
1.7.3.4

