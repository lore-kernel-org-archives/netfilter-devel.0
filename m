From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net-next,RFC 11/13] netfilter: nft_flow_offload: enable offload after second packet is seen
Date: Thu, 14 Jun 2018 16:19:45 +0200
Message-ID: <20180614141947.3580-12-pablo@netfilter.org>
References: <20180614141947.3580-1-pablo@netfilter.org>
Cc: netdev@vger.kernel.org, steffen.klassert@secunet.com
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180614141947.3580-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Once we have a confirmed conntrack, ie. a packet went through the stack
and a conntrack was added, then allow second packet to configure the
flowtable offload.

This allows UDP media traffic going in only one direction to enable offloads.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/netfilter/nft_flow_offload.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index d6bab8c3cbb0..f2e95edfb4de 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -88,14 +88,9 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 		goto out;
 	}
 
-	if (test_bit(IPS_HELPER_BIT, &ct->status))
-		goto out;
-
-	if (ctinfo == IP_CT_NEW ||
-	    ctinfo == IP_CT_RELATED)
-		goto out;
-
-	if (test_and_set_bit(IPS_OFFLOAD_BIT, &ct->status))
+	if (test_bit(IPS_HELPER_BIT, &ct->status) ||
+	    !test_bit(IPS_CONFIRMED_BIT, &ct->status) ||
+	    test_and_set_bit(IPS_OFFLOAD_BIT, &ct->status))
 		goto out;
 
 	dir = CTINFO2DIR(ctinfo);
-- 
2.11.0
