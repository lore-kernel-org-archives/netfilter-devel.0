From: gfree.wind@vip.163.com
Subject: [PATCH nf-next] netfilter: ebt: Use ebt_invalid_target instead of INVALID_TARGET
Date: Wed, 31 May 2017 09:28:12 +0800
Message-ID: <1496194092-92995-1-git-send-email-gfree.wind@vip.163.com>
Cc: Gao Feng <gfree.wind@vip.163.com>
To: pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-177180.vip.163.com ([123.58.177.180]:49833 "EHLO
        mail-177180.vip.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750911AbdEaBdv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 May 2017 21:33:51 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <gfree.wind@vip.163.com>

Use the new helper function ebt_invalid_target instead of the old
macro INVALID_TARGET to enhance the readability.

Signed-off-by: Gao Feng <gfree.wind@vip.163.com>
---
 include/linux/netfilter_bridge/ebtables.h | 2 --
 net/bridge/netfilter/ebt_dnat.c           | 2 +-
 net/bridge/netfilter/ebt_redirect.c       | 2 +-
 3 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/linux/netfilter_bridge/ebtables.h b/include/linux/netfilter_bridge/ebtables.h
index e0cbf17..2c2a551 100644
--- a/include/linux/netfilter_bridge/ebtables.h
+++ b/include/linux/netfilter_bridge/ebtables.h
@@ -122,8 +122,6 @@ extern unsigned int ebt_do_table(struct sk_buff *skb,
 #define BASE_CHAIN (par->hook_mask & (1 << NF_BR_NUMHOOKS))
 /* Clear the bit in the hook mask that tells if the rule is on a base chain */
 #define CLEAR_BASE_CHAIN_BIT (par->hook_mask &= ~(1 << NF_BR_NUMHOOKS))
-/* True if the target is not a standard target */
-#define INVALID_TARGET (info->target < -NUM_STANDARD_TARGETS || info->target >= 0)
 
 static inline bool ebt_invalid_target(int target)
 {
diff --git a/net/bridge/netfilter/ebt_dnat.c b/net/bridge/netfilter/ebt_dnat.c
index e0bb624..dfc86a0 100644
--- a/net/bridge/netfilter/ebt_dnat.c
+++ b/net/bridge/netfilter/ebt_dnat.c
@@ -61,7 +61,7 @@ static int ebt_dnat_tg_check(const struct xt_tgchk_param *par)
 	    (strcmp(par->table, "broute") != 0 ||
 	    hook_mask & ~(1 << NF_BR_BROUTING)))
 		return -EINVAL;
-	if (INVALID_TARGET)
+	if (ebt_invalid_target(info->target))
 		return -EINVAL;
 	return 0;
 }
diff --git a/net/bridge/netfilter/ebt_redirect.c b/net/bridge/netfilter/ebt_redirect.c
index 8d2a85e..a7223ea 100644
--- a/net/bridge/netfilter/ebt_redirect.c
+++ b/net/bridge/netfilter/ebt_redirect.c
@@ -47,7 +47,7 @@ static int ebt_redirect_tg_check(const struct xt_tgchk_param *par)
 	    (strcmp(par->table, "broute") != 0 ||
 	    hook_mask & ~(1 << NF_BR_BROUTING)))
 		return -EINVAL;
-	if (INVALID_TARGET)
+	if (ebt_invalid_target(info->target))
 		return -EINVAL;
 	return 0;
 }
-- 
1.9.1


