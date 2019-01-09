From: wenxu@ucloud.cn
Subject: [PATCH RESEND] nft_flow_offload: Fix the peer route get from wrong daddr
Date: Wed,  9 Jan 2019 10:40:11 +0800
Message-ID: <1547001611-26793-1-git-send-email-wenxu@ucloud.cn>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

For nat example:
client 1.1.1.7 ---> 2.2.2.7 which dnat to 10.0.0.7 server

When syn_rcv pkt from server it get the peer(client->server) route
through daddr = ct->tuplehash[!dir].tuple.dst.u3.ip, the value 2.2.2.7
is not correct in this situation. it should be 10.0.0.7
ct->tuplehash[dir].tuple.src.u3.ip

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/netfilter/nft_flow_offload.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 974525e..ccdb8f5 100644
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
1.8.3.1
