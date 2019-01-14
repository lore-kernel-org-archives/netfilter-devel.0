From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4/7] netfilter: nft_flow_offload: Fix reverse route lookup
Date: Mon, 14 Jan 2019 22:29:37 +0100
Message-ID: <20190114212940.5704-5-pablo@netfilter.org>
References: <20190114212940.5704-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190114212940.5704-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Using the following example:

	client 1.1.1.7 ---> 2.2.2.7 which dnat to 10.0.0.7 server

The first reply packet (ie. syn+ack) uses an incorrect destination
address for the reverse route lookup since it uses:

	daddr = ct->tuplehash[!dir].tuple.dst.u3.ip;

which is 2.2.2.7 in the scenario that is described above, while this
should be:

	daddr = ct->tuplehash[dir].tuple.src.u3.ip;

that is 10.0.0.7.

Signed-off-by: wenxu <wenxu@ucloud.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_flow_offload.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 974525eb92df..ccdb8f5ababb 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -29,10 +29,10 @@ static int nft_flow_route(const struct nft_pktinfo *pkt,
 	memset(&fl, 0, sizeof(fl));
 	switch (nft_pf(pkt)) {
 	case NFPROTO_IPV4:
-		fl.u.ip4.daddr = ct->tuplehash[!dir].tuple.dst.u3.ip;
+		fl.u.ip4.daddr = ct->tuplehash[dir].tuple.src.u3.ip;
 		break;
 	case NFPROTO_IPV6:
-		fl.u.ip6.daddr = ct->tuplehash[!dir].tuple.dst.u3.in6;
+		fl.u.ip6.daddr = ct->tuplehash[dir].tuple.src.u3.in6;
 		break;
 	}
 
-- 
2.11.0
