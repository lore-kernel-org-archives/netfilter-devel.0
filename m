From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH] libxt_owner: restore inversion support
Date: Sun, 29 May 2011 17:12:15 +0200
Message-ID: <1306681936-30866-2-git-send-email-jengelh@medozas.de>
References: <1306681936-30866-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:52076 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753252Ab1E2PMS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 29 May 2011 11:12:18 -0400
In-Reply-To: <1306681936-30866-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_owner.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_owner.c b/extensions/libxt_owner.c
index b60f907..d2fdfa9 100644
--- a/extensions/libxt_owner.c
+++ b/extensions/libxt_owner.c
@@ -125,8 +125,10 @@ static const struct xt_option_entry owner_mt6_opts_v0[] = {
 #undef s
 
 static const struct xt_option_entry owner_mt_opts[] = {
-	{.name = "uid-owner", .id = O_USER, .type = XTTYPE_STRING},
-	{.name = "gid-owner", .id = O_GROUP, .type = XTTYPE_STRING},
+	{.name = "uid-owner", .id = O_USER, .type = XTTYPE_STRING,
+	 .flags = XTOPT_INVERT},
+	{.name = "gid-owner", .id = O_GROUP, .type = XTTYPE_STRING,
+	 .flags = XTOPT_INVERT},
 	{.name = "socket-exists", .id = O_SOCK_EXISTS, .type = XTTYPE_NONE},
 	XTOPT_TABLEEND,
 };
-- 
1.7.3.4

