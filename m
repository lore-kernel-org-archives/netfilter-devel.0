From: Ian Morris <ipm@chirality.org.uk>
Subject: [PATCH nf-next 4/4] netfilter-bridge: layout of if statements
Date: Mon, 26 Oct 2015 09:10:43 +0000
Message-ID: <1445850643-9186-5-git-send-email-ipm@chirality.org.uk>
References: <1445850643-9186-1-git-send-email-ipm@chirality.org.uk>
Cc: Ian Morris <ipm@chirality.org.uk>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from inet-gw.chirality.org.uk ([88.97.209.22]:56044 "EHLO
	cedar.ipmorris.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750971AbbJZJKs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Oct 2015 05:10:48 -0400
In-Reply-To: <1445850643-9186-1-git-send-email-ipm@chirality.org.uk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eliminate some checkpatch issues by improved layout of if statements.

No changes detected by objdiff.

Signed-off-by: Ian Morris <ipm@chirality.org.uk>
---
 net/bridge/netfilter/ebt_ip6.c  | 4 ++--
 net/bridge/netfilter/ebtables.c | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/bridge/netfilter/ebt_ip6.c b/net/bridge/netfilter/ebt_ip6.c
index 17fd5f2..98de6e7 100644
--- a/net/bridge/netfilter/ebt_ip6.c
+++ b/net/bridge/netfilter/ebt_ip6.c
@@ -65,8 +65,8 @@ ebt_ip6_mt(const struct sk_buff *skb, struct xt_action_param *par)
 			return false;
 		if (FWINV(info->protocol != nexthdr, EBT_IP6_PROTO))
 			return false;
-		if (!(info->bitmask & ( EBT_IP6_DPORT |
-					EBT_IP6_SPORT | EBT_IP6_ICMP6)))
+		if (!(info->bitmask & (EBT_IP6_DPORT |
+				       EBT_IP6_SPORT | EBT_IP6_ICMP6)))
 			return true;
 
 		/* min icmpv6 headersize is 4, so sizeof(_pkthdr) is ok. */
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index b13ea69..67b2e27 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -161,7 +161,7 @@ ebt_basic_match(const struct ebt_entry *e, const struct sk_buff *skb,
 		for (i = 0; i < 6; i++)
 			verdict |= (h->h_source[i] ^ e->sourcemac[i]) &
 			   e->sourcemsk[i];
-		if (FWINV2(verdict != 0, EBT_ISOURCE) )
+		if (FWINV2(verdict != 0, EBT_ISOURCE))
 			return 1;
 	}
 	if (e->bitmask & EBT_DESTMAC) {
@@ -169,7 +169,7 @@ ebt_basic_match(const struct ebt_entry *e, const struct sk_buff *skb,
 		for (i = 0; i < 6; i++)
 			verdict |= (h->h_dest[i] ^ e->destmac[i]) &
 			   e->destmsk[i];
-		if (FWINV2(verdict != 0, EBT_IDEST) )
+		if (FWINV2(verdict != 0, EBT_IDEST))
 			return 1;
 	}
 	return 0;
@@ -673,7 +673,7 @@ ebt_check_entry(struct ebt_entry *e, struct net *net,
 		BUGPRINT("Unknown flag for inv bitmask\n");
 		return -EINVAL;
 	}
-	if ( (e->bitmask & EBT_NOPROTO) && (e->bitmask & EBT_802_3) ) {
+	if ((e->bitmask & EBT_NOPROTO) && (e->bitmask & EBT_802_3)) {
 		BUGPRINT("NOPROTO & 802_3 not allowed\n");
 		return -EINVAL;
 	}
@@ -1370,7 +1370,7 @@ static inline int ebt_make_watchername(const struct ebt_entry_watcher *w,
 	char name[EBT_FUNCTION_MAXNAMELEN] = {};
 
 	strlcpy(name, w->u.watcher->name, sizeof(name));
-	if (copy_to_user(hlp , name, EBT_FUNCTION_MAXNAMELEN))
+	if (copy_to_user(hlp, name, EBT_FUNCTION_MAXNAMELEN))
 		return -EFAULT;
 	return 0;
 }
-- 
1.9.1

