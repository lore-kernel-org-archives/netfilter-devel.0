From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 07/24] [NETFILTER]: remove ARPT_{CONTINUE,RETURN} indirection macros
Date: Wed,  2 Apr 2008 13:11:49 +0200
Message-ID: <5bfc07f75334b4c529d6777b80b1ff8dda6eefa8.1207134547.git.jengelh@computergmbh.de>
References: <1207134726-28689-1-git-send-email-jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:43154 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755892AbYDBLMJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Apr 2008 07:12:09 -0400
In-Reply-To: <1207134726-28689-1-git-send-email-jengelh@computergmbh.de>
In-Reply-To: <455b3b0ee249d17dff621933f163b8d5e377eb8f.1207134547.git.jengelh@computergmbh.de>
References: <455b3b0ee249d17dff621933f163b8d5e377eb8f.1207134547.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
 include/linux/netfilter_arp/arp_tables.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/include/linux/netfilter_arp/arp_tables.h b/include/linux/netfilter_arp/arp_tables.h
index 2cdcc0c..f701e36 100644
--- a/include/linux/netfilter_arp/arp_tables.h
+++ b/include/linux/netfilter_arp/arp_tables.h
@@ -180,10 +180,6 @@ struct arpt_replace
 	struct arpt_entry entries[0];
 };
 
-/* The argument to ARPT_SO_ADD_COUNTERS. */
-#define arpt_counters_info xt_counters_info
-#define arpt_counters xt_counters
-
 /* The argument to ARPT_SO_GET_ENTRIES. */
 struct arpt_get_entries
 {
-- 
1.5.4.4

