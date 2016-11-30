From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 05/11] netfilter: nat: fix cmp return value
Date: Wed, 30 Nov 2016 22:57:19 +0100
Message-ID: <1480543045-3389-6-git-send-email-pablo@netfilter.org>
References: <1480543045-3389-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1480543045-3389-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

The comparator works like memcmp, i.e. 0 means objects are equal.
In other words, when objects are distinct they are treated as identical,
when they are distinct they are allegedly the same.

The first case is rare (distinct objects are unlikely to get hashed to
same bucket).

The second case results in unneeded port conflict resolutions attempts.

Fixes: 870190a9ec907 ("netfilter: nat: convert nat bysrc hash to rhashtable")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.1.4
