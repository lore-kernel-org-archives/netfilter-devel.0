From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/5] libxt_recent: add a missing space in output
Date: Tue,  6 Apr 2010 12:52:41 +0200
Message-ID: <1270551164-2945-4-git-send-email-jengelh@medozas.de>
References: <1270551164-2945-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:36860 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753240Ab0DFKww (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Apr 2010 06:52:52 -0400
In-Reply-To: <1270551164-2945-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_recent.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/extensions/libxt_recent.c b/extensions/libxt_recent.c
index 4ac32f7..ecc17ad 100644
--- a/extensions/libxt_recent.c
+++ b/extensions/libxt_recent.c
@@ -183,7 +183,7 @@ static void recent_print(const void *ip, const struct xt_entry_match *match,
 	if (info->side == XT_RECENT_SOURCE)
 		printf("side: source ");
 	if (info->side == XT_RECENT_DEST)
-		printf("side: dest");
+		printf("side: dest ");
 }
 
 static void recent_save(const void *ip, const struct xt_entry_match *match)
-- 
1.7.0.2

