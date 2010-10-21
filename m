From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/5] netfilter: xtables: add a missing pair of parentheses
Date: Thu, 21 Oct 2010 17:06:05 +0200
Message-ID: <1287673569-8587-3-git-send-email-jengelh@medozas.de>
References: <1287673569-8587-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org, bdschuym@pandora.be
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:56814 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752921Ab0JUPGN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Oct 2010 11:06:13 -0400
In-Reply-To: <1287673569-8587-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 742bec0..9f69599 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -177,7 +177,7 @@ struct xt_counters_info {
 
 /* can only be xt_entry_match, so no use of typeof here */
 #define xt_ematch_foreach(pos, entry) \
-	for ((pos) = (struct xt_entry_match *)entry->elems; \
+	for ((pos) = (struct xt_entry_match *)(entry)->elems; \
 	     (pos) < (struct xt_entry_match *)((char *)(entry) + \
 	             (entry)->target_offset); \
 	     (pos) = (struct xt_entry_match *)((char *)(pos) + \
-- 
1.7.1

