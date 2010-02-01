From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/7] recent: reorder cases in code (cosmetic cleanup)
Date: Mon,  1 Feb 2010 01:19:48 +0100
Message-ID: <1264983594-20871-3-git-send-email-jengelh@medozas.de>
References: <1264983594-20871-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49647 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754575Ab0BAAT7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 31 Jan 2010 19:19:59 -0500
In-Reply-To: <1264983594-20871-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_recent.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/extensions/libxt_recent.c b/extensions/libxt_recent.c
index 5add228..4ac32f7 100644
--- a/extensions/libxt_recent.c
+++ b/extensions/libxt_recent.c
@@ -101,6 +101,14 @@ static int recent_parse(int c, char **argv, int invert, unsigned int *flags,
 			*flags |= XT_RECENT_UPDATE;
 			break;
 
+		case 204:
+			info->seconds = atoi(optarg);
+			break;
+
+		case 205:
+			info->hit_count = atoi(optarg);
+			break;
+
 		case 206:
 			if (*flags & RECENT_CMDS)
 				xtables_error(PARAMETER_PROBLEM,
@@ -112,14 +120,6 @@ static int recent_parse(int c, char **argv, int invert, unsigned int *flags,
 			*flags |= XT_RECENT_REMOVE;
 			break;
 
-		case 204:
-			info->seconds = atoi(optarg);
-			break;
-
-		case 205:
-			info->hit_count = atoi(optarg);
-			break;
-
 		case 207:
 			info->check_set |= XT_RECENT_TTL;
 			*flags |= XT_RECENT_TTL;
-- 
1.6.6.1

