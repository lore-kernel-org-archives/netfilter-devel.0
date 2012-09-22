From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH] netfilter: have r->cost != 0 case work
Date: Sat, 22 Sep 2012 10:26:52 +0200
Message-ID: <1348302412-2811-1-git-send-email-jengelh@inai.de>
References: <alpine.LNX.2.01.1209221003280.3512@nerf07.vanv.qr>
Cc: kaber@trash.net, jrobinson@infoblox.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:33245 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754458Ab2IVI06 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 22 Sep 2012 04:26:58 -0400
In-Reply-To: <alpine.LNX.2.01.1209221003280.3512@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Commit v2.6.19-rc1~1272^2~41 tells us that r->cost != 0 can happen when
a running state is saved to userspace and then reinstated from there.

Make sure that priv is initialized with some values when that happens.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 net/netfilter/xt_limit.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/xt_limit.c b/net/netfilter/xt_limit.c
index 5c22ce8..a4c1e45 100644
--- a/net/netfilter/xt_limit.c
+++ b/net/netfilter/xt_limit.c
@@ -117,11 +117,11 @@ static int limit_mt_check(const struct xt_mtchk_param *par)
 
 	/* For SMP, we only want to use one set of state. */
 	r->master = priv;
+	/* User avg in seconds * XT_LIMIT_SCALE: convert to jiffies *
+	   128. */
+	priv->prev = jiffies;
+	priv->credit = user2credits(r->avg * r->burst); /* Credits full. */
 	if (r->cost == 0) {
-		/* User avg in seconds * XT_LIMIT_SCALE: convert to jiffies *
-		   128. */
-		priv->prev = jiffies;
-		priv->credit = user2credits(r->avg * r->burst); /* Credits full. */
 		r->credit_cap = priv->credit; /* Credits full. */
 		r->cost = user2credits(r->avg);
 	}
-- 
1.7.10.4

