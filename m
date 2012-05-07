From: Florian Westphal <fw@strlen.de>
Subject: [PATCH next 1/3] netfilter: limit, hashlimit: avoid duplicated inline
Date: Mon,  7 May 2012 22:51:43 +0200
Message-ID: <1336423905-23919-1-git-send-email-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:50621 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932355Ab2EGV1o (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 May 2012 17:27:44 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

credit_cap can be set to credit, which avoids inlining user2credits
twice. Also, remove inline keyword and let compiler decide.

old:
    684     192       0     876     36c net/netfilter/xt_limit.o
   4927     344      32    5303    14b7 net/netfilter/xt_hashlimit.o
now:
    668     192       0     860     35c net/netfilter/xt_limit.o
   4793     344      32    5169    1431 net/netfilter/xt_hashlimit.o

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/xt_hashlimit.c |    8 +++-----
 net/netfilter/xt_limit.c     |    5 ++---
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index d95f9c9..2195eb0 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -389,8 +389,7 @@ static void htable_put(struct xt_hashlimit_htable *hinfo)
 #define CREDITS_PER_JIFFY POW2_BELOW32(MAX_CPJ)
 
 /* Precision saver. */
-static inline u_int32_t
-user2credits(u_int32_t user)
+static u32 user2credits(u32 user)
 {
 	/* If multiplying would overflow... */
 	if (user > 0xFFFFFFFF / (HZ*CREDITS_PER_JIFFY))
@@ -400,7 +399,7 @@ user2credits(u_int32_t user)
 	return (user * HZ * CREDITS_PER_JIFFY) / XT_HASHLIMIT_SCALE;
 }
 
-static inline void rateinfo_recalc(struct dsthash_ent *dh, unsigned long now)
+static void rateinfo_recalc(struct dsthash_ent *dh, unsigned long now)
 {
 	dh->rateinfo.credit += (now - dh->rateinfo.prev) * CREDITS_PER_JIFFY;
 	if (dh->rateinfo.credit > dh->rateinfo.credit_cap)
@@ -535,8 +534,7 @@ hashlimit_mt(const struct sk_buff *skb, struct xt_action_param *par)
 		dh->rateinfo.prev = jiffies;
 		dh->rateinfo.credit = user2credits(hinfo->cfg.avg *
 		                      hinfo->cfg.burst);
-		dh->rateinfo.credit_cap = user2credits(hinfo->cfg.avg *
-		                          hinfo->cfg.burst);
+		dh->rateinfo.credit_cap = dh->rateinfo.credit;
 		dh->rateinfo.cost = user2credits(hinfo->cfg.avg);
 	} else {
 		/* update expiration timeout */
diff --git a/net/netfilter/xt_limit.c b/net/netfilter/xt_limit.c
index 32b7a57..5c22ce8 100644
--- a/net/netfilter/xt_limit.c
+++ b/net/netfilter/xt_limit.c
@@ -88,8 +88,7 @@ limit_mt(const struct sk_buff *skb, struct xt_action_param *par)
 }
 
 /* Precision saver. */
-static u_int32_t
-user2credits(u_int32_t user)
+static u32 user2credits(u32 user)
 {
 	/* If multiplying would overflow... */
 	if (user > 0xFFFFFFFF / (HZ*CREDITS_PER_JIFFY))
@@ -123,7 +122,7 @@ static int limit_mt_check(const struct xt_mtchk_param *par)
 		   128. */
 		priv->prev = jiffies;
 		priv->credit = user2credits(r->avg * r->burst); /* Credits full. */
-		r->credit_cap = user2credits(r->avg * r->burst); /* Credits full. */
+		r->credit_cap = priv->credit; /* Credits full. */
 		r->cost = user2credits(r->avg);
 	}
 	return 0;
-- 
1.7.3.4

