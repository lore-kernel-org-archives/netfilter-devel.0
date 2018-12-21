From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 13/37] netfilter: nat: limit port clash resolution attempts
Date: Fri, 21 Dec 2018 01:28:17 +0100
Message-ID: <20181221002841.28587-14-pablo@netfilter.org>
References: <20181221002841.28587-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181221002841.28587-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

In case almost or all available ports are taken, clash resolution can
take a very long time, resulting in soft lockup.

This can happen when many to-be-natted hosts connect to same
destination:port (e.g. a proxy) and all connections pass the same SNAT.

Pick a random offset in the acceptable range, then try ever smaller
number of adjacent port numbers, until either the limit is reached or a
useable port was found.  This results in at most 248 attempts
(128 + 64 + 32 + 16 + 8, i.e. 4 restarts with new search offset)
instead of 64000+,

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_nat_proto_common.c | 29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_nat_proto_common.c b/net/netfilter/nf_nat_proto_common.c
index 136ab65c4082..dcb5d11688a1 100644
--- a/net/netfilter/nf_nat_proto_common.c
+++ b/net/netfilter/nf_nat_proto_common.c
@@ -40,9 +40,10 @@ void nf_nat_l4proto_unique_tuple(const struct nf_nat_l3proto *l3proto,
 				 enum nf_nat_manip_type maniptype,
 				 const struct nf_conn *ct)
 {
-	unsigned int range_size, min, max, i;
+	unsigned int range_size, min, max, i, attempts;
 	__be16 *portptr;
-	u_int16_t off;
+	u16 off;
+	static const unsigned int max_attempts = 128;
 
 	if (maniptype == NF_NAT_MANIP_SRC)
 		portptr = &tuple->src.u.all;
@@ -86,12 +87,28 @@ void nf_nat_l4proto_unique_tuple(const struct nf_nat_l3proto *l3proto,
 		off = prandom_u32();
 	}
 
-	for (i = 0; ; ++off) {
+	attempts = range_size;
+	if (attempts > max_attempts)
+		attempts = max_attempts;
+
+	/* We are in softirq; doing a search of the entire range risks
+	 * soft lockup when all tuples are already used.
+	 *
+	 * If we can't find any free port from first offset, pick a new
+	 * one and try again, with ever smaller search window.
+	 */
+another_round:
+	for (i = 0; i < attempts; i++, off++) {
 		*portptr = htons(min + off % range_size);
-		if (++i != range_size && nf_nat_used_tuple(tuple, ct))
-			continue;
-		return;
+		if (!nf_nat_used_tuple(tuple, ct))
+			return;
 	}
+
+	if (attempts >= range_size || attempts < 16)
+		return;
+	attempts /= 2;
+	off = prandom_u32();
+	goto another_round;
 }
 EXPORT_SYMBOL_GPL(nf_nat_l4proto_unique_tuple);
 
-- 
2.11.0
