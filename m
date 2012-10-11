From: pablo@netfilter.org
Subject: [PATCH 6/6] netfilter: xt_limit: have r->cost != 0 case work
Date: Thu, 11 Oct 2012 12:15:39 +0200
Message-ID: <1349950539-12491-7-git-send-email-pablo@netfilter.org>
References: <1349950539-12491-1-git-send-email-pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
To: stable@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52418 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758379Ab2JKKPz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Oct 2012 06:15:55 -0400
In-Reply-To: <1349950539-12491-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jan Engelhardt <jengelh@inai.de>

Commit v2.6.19-rc1~1272^2~41 tells us that r->cost != 0 can happen when
a running state is saved to userspace and then reinstated from there.

Make sure that private xt_limit area is initialized with correct values.
Otherwise, random matchings due to use of uninitialized memory.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

This patch requires:

commit 7a909ac70f6b0823d9f23a43f19598d4b57ac901
Author: Florian Westphal <fw@strlen.de>
Date:   Mon May 7 10:51:43 2012 +0000

    netfilter: limit, hashlimit: avoid duplicated inline

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

