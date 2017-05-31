From: gfree.wind@vip.163.com
Subject: [PATCH v2 nf-next] netfilter: ebt: Use new helper ebt_invalid_target to check target
Date: Wed, 31 May 2017 16:55:43 +0800
Message-ID: <1496220943-98621-1-git-send-email-gfree.wind@vip.163.com>
Cc: Gao Feng <gfree.wind@vip.163.com>
To: pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-177180.vip.163.com ([123.58.177.180]:55123 "EHLO
        mail-177180.vip.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750869AbdEaI4J (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 May 2017 04:56:09 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <gfree.wind@vip.163.com>

Use the new helper function ebt_invalid_target instead of the old
macro INVALID_TARGET and other duplicated codes to enhance the readability.

Signed-off-by: Gao Feng <gfree.wind@vip.163.com>
---
 v2: Replace the target check of ebt_mark/snat, per Pablo
 v1: Initial version

 include/linux/netfilter_bridge/ebtables.h | 2 --
 net/bridge/netfilter/ebt_dnat.c           | 2 +-
 net/bridge/netfilter/ebt_mark.c           | 2 +-
 net/bridge/netfilter/ebt_redirect.c       | 2 +-
 net/bridge/netfilter/ebt_snat.c           | 2 +-
 5 files changed, 4 insertions(+), 6 deletions(-)

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
diff --git a/net/bridge/netfilter/ebt_mark.c b/net/bridge/netfilter/ebt_mark.c
index 66697cb..19f0f95 100644
--- a/net/bridge/netfilter/ebt_mark.c
+++ b/net/bridge/netfilter/ebt_mark.c
@@ -44,7 +44,7 @@ static int ebt_mark_tg_check(const struct xt_tgchk_param *par)
 	tmp = info->target | ~EBT_VERDICT_BITS;
 	if (BASE_CHAIN && tmp == EBT_RETURN)
 		return -EINVAL;
-	if (tmp < -NUM_STANDARD_TARGETS || tmp >= 0)
+	if (ebt_invalid_target(tmp))
 		return -EINVAL;
 	tmp = info->target & ~EBT_VERDICT_BITS;
 	if (tmp != MARK_SET_VALUE && tmp != MARK_OR_VALUE &&
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
diff --git a/net/bridge/netfilter/ebt_snat.c b/net/bridge/netfilter/ebt_snat.c
index e56ccd0..11cf9e9 100644
--- a/net/bridge/netfilter/ebt_snat.c
+++ b/net/bridge/netfilter/ebt_snat.c
@@ -51,7 +51,7 @@ static int ebt_snat_tg_check(const struct xt_tgchk_param *par)
 	if (BASE_CHAIN && tmp == EBT_RETURN)
 		return -EINVAL;
 
-	if (tmp < -NUM_STANDARD_TARGETS || tmp >= 0)
+	if (ebt_invalid_target(tmp))
 		return -EINVAL;
 	tmp = info->target | EBT_VERDICT_BITS;
 	if ((tmp & ~NAT_ARP_BIT) != ~NAT_ARP_BIT)
-- 
1.9.1


