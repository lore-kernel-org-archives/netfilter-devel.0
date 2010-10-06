From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH] netfilter: xt_hashlimit: restore per-rule effectiveness
Date: Wed,  6 Oct 2010 08:28:42 +0200
Message-ID: <1286346523-9476-2-git-send-email-jengelh@medozas.de>
References: <1286346523-9476-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:47956 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758200Ab0JFG2q (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Oct 2010 02:28:46 -0400
In-Reply-To: <1286346523-9476-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When adding a second hashlimit rule with the same name, its parameters
had no effect, because it had used a copy of the first one's inner
state.

References: http://bugzilla.netfilter.org/show_bug.cgi?id=650
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/netfilter/xt_hashlimit.c |   50 ++++++++++++++++++++++-------------------
 1 files changed, 27 insertions(+), 23 deletions(-)

diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 9228ee0..c3ae0e3 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -97,7 +97,9 @@ struct xt_hashlimit_htable {
 	u_int8_t family;
 	bool rnd_initialized;
 
-	struct hashlimit_cfg1 cfg;	/* config */
+	struct {
+		u_int32_t size, max, gc_interval, expire;
+	} cfg;
 
 	/* used internally */
 	spinlock_t lock;		/* lock for list_head */
@@ -233,8 +235,10 @@ static int htable_create(struct net *net, struct xt_hashlimit_mtinfo1 *minfo,
 	minfo->hinfo = hinfo;
 
 	/* copy match config into hashtable config */
-	memcpy(&hinfo->cfg, &minfo->cfg, sizeof(hinfo->cfg));
-	hinfo->cfg.size = size;
+	hinfo->cfg.size        = size;
+	hinfo->cfg.max         = minfo->cfg.max;
+	hinfo->cfg.gc_interval = minfo->cfg.gc_interval;
+	hinfo->cfg.expire      = minfo->cfg.expire;
 	if (hinfo->cfg.max == 0)
 		hinfo->cfg.max = 8 * hinfo->cfg.size;
 	else if (hinfo->cfg.max < hinfo->cfg.size)
@@ -442,7 +446,7 @@ static void hashlimit_ipv6_mask(__be32 *i, unsigned int p)
 #endif
 
 static int
-hashlimit_init_dst(const struct xt_hashlimit_htable *hinfo,
+hashlimit_init_dst(const struct xt_hashlimit_mtinfo1 *info, u_int8_t family,
 		   struct dsthash_dst *dst,
 		   const struct sk_buff *skb, unsigned int protoff)
 {
@@ -452,34 +456,34 @@ hashlimit_init_dst(const struct xt_hashlimit_htable *hinfo,
 
 	memset(dst, 0, sizeof(*dst));
 
-	switch (hinfo->family) {
+	switch (family) {
 	case NFPROTO_IPV4:
-		if (hinfo->cfg.mode & XT_HASHLIMIT_HASH_DIP)
+		if (info->cfg.mode & XT_HASHLIMIT_HASH_DIP)
 			dst->ip.dst = maskl(ip_hdr(skb)->daddr,
-			              hinfo->cfg.dstmask);
-		if (hinfo->cfg.mode & XT_HASHLIMIT_HASH_SIP)
+			              info->cfg.dstmask);
+		if (info->cfg.mode & XT_HASHLIMIT_HASH_SIP)
 			dst->ip.src = maskl(ip_hdr(skb)->saddr,
-			              hinfo->cfg.srcmask);
+			              info->cfg.srcmask);
 
-		if (!(hinfo->cfg.mode &
+		if (!(info->cfg.mode &
 		      (XT_HASHLIMIT_HASH_DPT | XT_HASHLIMIT_HASH_SPT)))
 			return 0;
 		nexthdr = ip_hdr(skb)->protocol;
 		break;
 #if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
 	case NFPROTO_IPV6:
-		if (hinfo->cfg.mode & XT_HASHLIMIT_HASH_DIP) {
+		if (info->cfg.mode & XT_HASHLIMIT_HASH_DIP) {
 			memcpy(&dst->ip6.dst, &ipv6_hdr(skb)->daddr,
 			       sizeof(dst->ip6.dst));
-			hashlimit_ipv6_mask(dst->ip6.dst, hinfo->cfg.dstmask);
+			hashlimit_ipv6_mask(dst->ip6.dst, info->cfg.dstmask);
 		}
-		if (hinfo->cfg.mode & XT_HASHLIMIT_HASH_SIP) {
+		if (info->cfg.mode & XT_HASHLIMIT_HASH_SIP) {
 			memcpy(&dst->ip6.src, &ipv6_hdr(skb)->saddr,
 			       sizeof(dst->ip6.src));
-			hashlimit_ipv6_mask(dst->ip6.src, hinfo->cfg.srcmask);
+			hashlimit_ipv6_mask(dst->ip6.src, info->cfg.srcmask);
 		}
 
-		if (!(hinfo->cfg.mode &
+		if (!(info->cfg.mode &
 		      (XT_HASHLIMIT_HASH_DPT | XT_HASHLIMIT_HASH_SPT)))
 			return 0;
 		nexthdr = ipv6_hdr(skb)->nexthdr;
@@ -503,9 +507,9 @@ hashlimit_init_dst(const struct xt_hashlimit_htable *hinfo,
 	}
 	if (!ports)
 		return -1;
-	if (hinfo->cfg.mode & XT_HASHLIMIT_HASH_SPT)
+	if (info->cfg.mode & XT_HASHLIMIT_HASH_SPT)
 		dst->src_port = ports[0];
-	if (hinfo->cfg.mode & XT_HASHLIMIT_HASH_DPT)
+	if (info->cfg.mode & XT_HASHLIMIT_HASH_DPT)
 		dst->dst_port = ports[1];
 	return 0;
 }
@@ -519,7 +523,7 @@ hashlimit_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	struct dsthash_ent *dh;
 	struct dsthash_dst dst;
 
-	if (hashlimit_init_dst(hinfo, &dst, skb, par->thoff) < 0)
+	if (hashlimit_init_dst(info, par->family, &dst, skb, par->thoff) < 0)
 		goto hotdrop;
 
 	rcu_read_lock_bh();
@@ -532,11 +536,11 @@ hashlimit_mt(const struct sk_buff *skb, struct xt_action_param *par)
 		}
 		dh->expires = jiffies + msecs_to_jiffies(hinfo->cfg.expire);
 		dh->rateinfo.prev = jiffies;
-		dh->rateinfo.credit = user2credits(hinfo->cfg.avg *
-		                      hinfo->cfg.burst);
-		dh->rateinfo.credit_cap = user2credits(hinfo->cfg.avg *
-		                          hinfo->cfg.burst);
-		dh->rateinfo.cost = user2credits(hinfo->cfg.avg);
+		dh->rateinfo.credit = user2credits(info->cfg.avg *
+		                      info->cfg.burst);
+		dh->rateinfo.credit_cap = user2credits(info->cfg.avg *
+		                          info->cfg.burst);
+		dh->rateinfo.cost = user2credits(info->cfg.avg);
 	} else {
 		/* update expiration timeout */
 		dh->expires = now + msecs_to_jiffies(hinfo->cfg.expire);
-- 
1.7.1

