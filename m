From: pablo@netfilter.org
Subject: [stable-3.7 10/14] netfilter: xt_hashlimit: fix race that results in duplicated entries
Date: Mon, 28 Jan 2013 20:31:29 +0100
Message-ID: <1359401493-6196-11-git-send-email-pablo@netfilter.org>
References: <1359401493-6196-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netfilter-devel@vger.kernel.org
To: stable@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50502 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753648Ab3A1TcB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Jan 2013 14:32:01 -0500
In-Reply-To: <1359401493-6196-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Two packets may race to create the same entry in the hashtable,
double check if this packet lost race. This double checking only
happens in the path of the packet that creates the hashtable for
first time.

Note that, with this patch, no packet drops occur if the race happens.

Reported-by: Feng Gao <gfree.wind@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_hashlimit.c |   25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 30ad0b62..a9d7af9 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -157,11 +157,22 @@ dsthash_find(const struct xt_hashlimit_htable *ht,
 /* allocate dsthash_ent, initialize dst, put in htable and lock it */
 static struct dsthash_ent *
 dsthash_alloc_init(struct xt_hashlimit_htable *ht,
-		   const struct dsthash_dst *dst)
+		   const struct dsthash_dst *dst, bool *race)
 {
 	struct dsthash_ent *ent;
 
 	spin_lock(&ht->lock);
+
+	/* Two or more packets may race to create the same entry in the
+	 * hashtable, double check if this packet lost race.
+	 */
+	ent = dsthash_find(ht, dst);
+	if (ent != NULL) {
+		spin_unlock(&ht->lock);
+		*race = true;
+		return ent;
+	}
+
 	/* initialize hash with random val at the time we allocate
 	 * the first hashtable entry */
 	if (unlikely(!ht->rnd_initialized)) {
@@ -588,6 +599,7 @@ hashlimit_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	unsigned long now = jiffies;
 	struct dsthash_ent *dh;
 	struct dsthash_dst dst;
+	bool race = false;
 	u32 cost;
 
 	if (hashlimit_init_dst(hinfo, &dst, skb, par->thoff) < 0)
@@ -596,13 +608,18 @@ hashlimit_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	rcu_read_lock_bh();
 	dh = dsthash_find(hinfo, &dst);
 	if (dh == NULL) {
-		dh = dsthash_alloc_init(hinfo, &dst);
+		dh = dsthash_alloc_init(hinfo, &dst, &race);
 		if (dh == NULL) {
 			rcu_read_unlock_bh();
 			goto hotdrop;
+		} else if (race) {
+			/* Already got an entry, update expiration timeout */
+			dh->expires = now + msecs_to_jiffies(hinfo->cfg.expire);
+			rateinfo_recalc(dh, now, hinfo->cfg.mode);
+		} else {
+			dh->expires = jiffies + msecs_to_jiffies(hinfo->cfg.expire);
+			rateinfo_init(dh, hinfo);
 		}
-		dh->expires = jiffies + msecs_to_jiffies(hinfo->cfg.expire);
-		rateinfo_init(dh, hinfo);
 	} else {
 		/* update expiration timeout */
 		dh->expires = now + msecs_to_jiffies(hinfo->cfg.expire);
-- 
1.7.10.4

