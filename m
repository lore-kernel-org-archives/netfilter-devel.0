From: Pierre Chifflier <chifflier@edenwall.com>
Subject: [PATCH 2/3] bridge: add support for the EBT_QUEUE target
Date: Thu,  3 Feb 2011 15:32:19 +0100
Message-ID: <1296743540-8148-3-git-send-email-chifflier@edenwall.com>
References: <4D49E1E0.50304@trash.net>
Cc: Pierre Chifflier <chifflier@edenwall.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sd-6807.dedibox.fr ([88.191.37.40]:44575 "EHLO
	sd-6807.edenwall.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756261Ab1BCPMH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Feb 2011 10:12:07 -0500
Received: from [88.171.131.12] (helo=fydelkass.edenwall.com)
	by sd-6807.edenwall.com with esmtp (Exim 4.69)
	(envelope-from <chifflier@edenwall.com>)
	id 1Pl0ER-0007TZ-8R
	for netfilter-devel@vger.kernel.org; Thu, 03 Feb 2011 15:32:23 +0100
In-Reply-To: <4D49E1E0.50304@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add the EBT_QUEUE standard target for ebtables.

Signed-off-by: Pierre Chifflier <chifflier@edenwall.com>
---
 include/linux/netfilter_bridge/ebtables.h |    3 ++-
 net/bridge/netfilter/ebtables.c           |    5 +++++
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/include/linux/netfilter_bridge/ebtables.h b/include/linux/netfilter_bridge/ebtables.h
index 1c6f0c5..d5085eb 100644
--- a/include/linux/netfilter_bridge/ebtables.h
+++ b/include/linux/netfilter_bridge/ebtables.h
@@ -25,7 +25,8 @@
 #define EBT_DROP     -2
 #define EBT_CONTINUE -3
 #define EBT_RETURN   -4
-#define NUM_STANDARD_TARGETS   4
+#define EBT_QUEUE    -5
+#define NUM_STANDARD_TARGETS   5
 /* ebtables target modules store the verdict inside an int. We can
  * reclaim a part of this int for backwards compatible extensions.
  * The 4 lsb are more than enough to store the verdict. */
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 5f1825d..156a7d7 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -251,6 +251,11 @@ unsigned int ebt_do_table (unsigned int hook, struct sk_buff *skb,
 			read_unlock_bh(&table->lock);
 			return NF_ACCEPT;
 		}
+		if (verdict == EBT_QUEUE) {
+			u32 queue_num = 1; // XXX hardcoded
+			read_unlock_bh(&table->lock);
+			return NF_QUEUE_NR(queue_num);
+		}
 		if (verdict == EBT_DROP) {
 			read_unlock_bh(&table->lock);
 			return NF_DROP;
-- 
1.7.2.3

