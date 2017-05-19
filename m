From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 11/12] ebtables: arpreply: Add the standard target sanity check
Date: Fri, 19 May 2017 10:33:52 +0200
Message-ID: <1495182833-2272-12-git-send-email-pablo@netfilter.org>
References: <1495182833-2272-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1495182833-2272-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Gao Feng <gfree.wind@vip.163.com>

The info->target comes from userspace and it would be used directly.
So we need to add the sanity check to make sure it is a valid standard
target, although the ebtables tool has already checked it. Kernel needs
to validate anything coming from userspace.

If the target is set as an evil value, it would break the ebtables
and cause a panic. Because the non-standard target is treated as one
offset.

Now add one helper function ebt_invalid_target, and we would replace
the macro INVALID_TARGET later.

Signed-off-by: Gao Feng <gfree.wind@vip.163.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter_bridge/ebtables.h | 5 +++++
 net/bridge/netfilter/ebt_arpreply.c       | 3 +++
 2 files changed, 8 insertions(+)

diff --git a/include/linux/netfilter_bridge/ebtables.h b/include/linux/netfilter_bridge/ebtables.h
index a30efb437e6d..e0cbf17af780 100644
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
index 5929309beaa1..db85230e49c3 100644
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
2.1.4
