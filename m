From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/5] libxt_connlimit: initialize v6_mask
Date: Thu, 11 Jun 2009 13:11:20 +0200
Message-ID: <1244718682-2497-4-git-send-email-jengelh@medozas.de>
References: <1244718682-2497-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38298 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762773AbZFKLLX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Jun 2009 07:11:23 -0400
In-Reply-To: <1244718682-2497-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: kd6lvw <kd6lvw@yahoo.com>

When converting "--connlimit-mask $bits" to a 128-bit v6 mask, the
code uses a left shift on v6_mask[n]. This requires v6_mask to be
filled with all one-bits beforehand, but this initialization was not
done.

References: http://bugzilla.netfilter.org/show_bug.cgi?id=597
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_connlimit.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/extensions/libxt_connlimit.c b/extensions/libxt_connlimit.c
index f001a2e..403e7e6 100644
--- a/extensions/libxt_connlimit.c
+++ b/extensions/libxt_connlimit.c
@@ -26,7 +26,9 @@ static const struct option connlimit_opts[] = {
 static void connlimit_init(struct xt_entry_match *match)
 {
 	struct xt_connlimit_info *info = (void *)match->data;
-	info->v4_mask = 0xFFFFFFFFUL;
+
+	/* This will also initialize the v4 mask correctly */
+	memset(info->v6_mask, 0xFF, sizeof(info->v6_mask));
 }
 
 static void prefix_to_netmask(u_int32_t *mask, unsigned int prefix_len)
-- 
1.6.3.1

