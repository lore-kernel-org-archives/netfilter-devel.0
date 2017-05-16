From: gfree.wind@vip.163.com
Subject: [PATCH nf v2] ebtables: arpreply: Add the standard target sanity check
Date: Tue, 16 May 2017 09:30:18 +0800
Message-ID: <1494898218-97426-1-git-send-email-gfree.wind@vip.163.com>
Cc: Gao Feng <gfree.wind@vip.163.com>
To: stephen@networkplumber.org, pablo@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m181-177.vip.163.com ([123.58.177.181]:47357 "EHLO
        m181-177.vip.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750997AbdEPBgK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 May 2017 21:36:10 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <gfree.wind@vip.163.com>

The info->target is from userspace and it would be used directly.
So we need to add the sanity check to make sure it is a valid standard
target, although the ebtables tool has already checked it. Kernel need
to check anything from userspace.

If the target was set as an evil value, it would break the ebtables
and cause a panic. Because the non-standard target is treated as one
offset.

Now add one helper function ebt_invalid_target, and we would replace
the macro INVALID_TARGET later.

Signed-off-by: Gao Feng <gfree.wind@vip.163.com>
---
 v2: Add one helper function ebt_invalid_target instead of INVALID_TARGET, per Pablo
 v1: initial version

 include/linux/netfilter_bridge/ebtables.h | 5 +++++
 net/bridge/netfilter/ebt_arpreply.c       | 3 +++
 2 files changed, 8 insertions(+)

diff --git a/include/linux/netfilter_bridge/ebtables.h b/include/linux/netfilter_bridge/ebtables.h
index a30efb4..e0cbf17 100644
--- a/include/linux/netfilter_bridge/ebtables.h
+++ b/include/linux/netfilter_bridge/ebtables.h
@@ -125,4 +125,9 @@ extern unsigned int ebt_do_table(struct sk_buff *skb,
 /* True if the target is not a standard target */
 #define INVALID_TARGET (info->target < -NUM_STANDARD_TARGETS || info->target >= 0)
 
+static inline bool ebt_invalid_target(int target)
+{
+	return (target < -NUM_STANDARD_TARGETS || target >= 0);
+}
+
 #endif
diff --git a/net/bridge/netfilter/ebt_arpreply.c b/net/bridge/netfilter/ebt_arpreply.c
index 5929309..db85230 100644
--- a/net/bridge/netfilter/ebt_arpreply.c
+++ b/net/bridge/netfilter/ebt_arpreply.c
@@ -68,6 +68,9 @@ static int ebt_arpreply_tg_check(const struct xt_tgchk_param *par)
 	if (e->ethproto != htons(ETH_P_ARP) ||
 	    e->invflags & EBT_IPROTO)
 		return -EINVAL;
+	if (ebt_invalid_target(info->target))
+		return -EINVAL;
+
 	return 0;
 }
 
-- 
1.9.1


