From: Florian Westphal <fw@strlen.de>
Subject: [PATCH next 2/3] netfilter: hashlimit: move rateinfo initialization to helper
Date: Mon,  7 May 2012 22:51:44 +0200
Message-ID: <1336423905-23919-2-git-send-email-fw@strlen.de>
References: <1336423905-23919-1-git-send-email-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:50622 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932423Ab2EGV1p (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 May 2012 17:27:45 -0400
In-Reply-To: <1336423905-23919-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

followup patch would bloat main match function too much.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/xt_hashlimit.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 2195eb0..b6bbd06 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -407,6 +407,15 @@ static void rateinfo_recalc(struct dsthash_ent *dh, unsigned long now)
 	dh->rateinfo.prev = now;
 }
 
+static void rateinfo_init(struct dsthash_ent *dh,
+			  struct xt_hashlimit_htable *hinfo)
+{
+	dh->rateinfo.prev = jiffies;
+	dh->rateinfo.credit = user2credits(hinfo->cfg.avg * hinfo->cfg.burst);
+	dh->rateinfo.cost = user2credits(hinfo->cfg.avg);
+	dh->rateinfo.credit_cap = dh->rateinfo.credit;
+}
+
 static inline __be32 maskl(__be32 a, unsigned int l)
 {
 	return l ? htonl(ntohl(a) & ~0 << (32 - l)) : 0;
@@ -531,11 +540,7 @@ hashlimit_mt(const struct sk_buff *skb, struct xt_action_param *par)
 			goto hotdrop;
 		}
 		dh->expires = jiffies + msecs_to_jiffies(hinfo->cfg.expire);
-		dh->rateinfo.prev = jiffies;
-		dh->rateinfo.credit = user2credits(hinfo->cfg.avg *
-		                      hinfo->cfg.burst);
-		dh->rateinfo.credit_cap = dh->rateinfo.credit;
-		dh->rateinfo.cost = user2credits(hinfo->cfg.avg);
+		rateinfo_init(dh, hinfo);
 	} else {
 		/* update expiration timeout */
 		dh->expires = now + msecs_to_jiffies(hinfo->cfg.expire);
-- 
1.7.3.4

