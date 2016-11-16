From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 1/2] netfilter: nat: fix cmp return value
Date: Wed, 16 Nov 2016 15:13:35 +0100
Message-ID: <1479305616-4171-2-git-send-email-fw@strlen.de>
References: <1479305616-4171-1-git-send-email-fw@strlen.de>
Cc: herbert@gondor.apana.org.au, Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:49174 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932119AbcKPONb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Nov 2016 09:13:31 -0500
In-Reply-To: <1479305616-4171-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The comparator works like memcmp, i.e. 0 means objects are equal.
In other words, when objects are distinct they are treated as identical,
when they are distinct they are allegedly the same.

The first case is rare (distinct objects are unlikely to get hashed to
same bucket).

The second case results in unneeded port conflict resolutions attempts.

Fixes: 870190a9ec907 ("netfilter: nat: convert nat bysrc hash to rhashtable")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_nat_core.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index bbb8f3df79f7..c632429706eb 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -193,9 +193,12 @@ static int nf_nat_bysource_cmp(struct rhashtable_compare_arg *arg,
 	const struct nf_nat_conn_key *key = arg->key;
 	const struct nf_conn *ct = obj;
 
-	return same_src(ct, key->tuple) &&
-	       net_eq(nf_ct_net(ct), key->net) &&
-	       nf_ct_zone_equal(ct, key->zone, IP_CT_DIR_ORIGINAL);
+	if (!same_src(ct, key->tuple) ||
+	    !net_eq(nf_ct_net(ct), key->net) ||
+	    !nf_ct_zone_equal(ct, key->zone, IP_CT_DIR_ORIGINAL))
+		return 1;
+
+	return 0;
 }
 
 static struct rhashtable_params nf_nat_bysource_params = {
-- 
2.7.3

