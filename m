From: Florian Westphal <fwestphal@astaro.com>
Subject: [PATCH 1/1] libxt_conntrack: fix --ctdir save/dump output format
Date: Wed, 17 Nov 2010 15:27:12 +0100
Message-ID: <1290004032-7711-1-git-send-email-fwestphal@astaro.com>
Cc: Florian Westphal <fwestphal@astaro.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dhost002-73.dex002.intermedia.net ([64.78.20.109]:57561 "EHLO
	DHOST002-73.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933812Ab0KQOlJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Nov 2010 09:41:09 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

$ iptables-save | iptables-restore
iptables-restore v1.4.6: conntrack: Bad value for "--ctdir" option: "ORIGINAL-j"

Signed-off-by: Florian Westphal <fwestphal@astaro.com>
---
 extensions/libxt_conntrack.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index 6c4a9cd..dd3fb6f 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -974,9 +974,9 @@ matchinfo_print(const void *ip, const struct xt_entry_match *match, int numeric,
 
 	if (sinfo->flags & XT_CONNTRACK_DIRECTION) {
 		if (sinfo->invflags & XT_CONNTRACK_DIRECTION)
-			printf("%sctdir REPLY", optpfx);
+			printf("%sctdir REPLY ", optpfx);
 		else
-			printf("%sctdir ORIGINAL", optpfx);
+			printf("%sctdir ORIGINAL ", optpfx);
 	}
 
 }
@@ -1079,9 +1079,9 @@ conntrack_dump(const struct xt_conntrack_mtinfo2 *info, const char *prefix,
 
 	if (info->match_flags & XT_CONNTRACK_DIRECTION) {
 		if (info->invert_flags & XT_CONNTRACK_DIRECTION)
-			printf("%sctdir REPLY", prefix);
+			printf("%sctdir REPLY ", prefix);
 		else
-			printf("%sctdir ORIGINAL", prefix);
+			printf("%sctdir ORIGINAL ", prefix);
 	}
 }
 
-- 
1.7.2.2

