From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/9] netfilter: ipvs: do not create conn for ABORT packet in sctp_conn_schedule
Date: Fri,  8 Sep 2017 19:45:41 +0200
Message-ID: <1504892748-1605-3-git-send-email-pablo@netfilter.org>
References: <1504892748-1605-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1504892748-1605-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

There's no reason for ipvs to create a conn for an ABORT packet
even if sysctl_sloppy_sctp is set.

This patch is to accept it without creating a conn, just as ipvs
does for tcp's RST packet.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_proto_sctp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/ipvs/ip_vs_proto_sctp.c b/net/netfilter/ipvs/ip_vs_proto_sctp.c
index 81f08198b125..57c8ee66491e 100644
--- a/net/netfilter/ipvs/ip_vs_proto_sctp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_sctp.c
@@ -25,7 +25,8 @@ sctp_conn_schedule(struct netns_ipvs *ipvs, int af, struct sk_buff *skb,
 			sch = skb_header_pointer(skb, iph->len + sizeof(_sctph),
 						 sizeof(_schunkh), &_schunkh);
 			if (sch) {
-				if (!(sysctl_sloppy_sctp(ipvs) ||
+				if (sch->type == SCTP_CID_ABORT ||
+				    !(sysctl_sloppy_sctp(ipvs) ||
 				      sch->type == SCTP_CID_INIT))
 					return 1;
 				ports = &sh->source;
-- 
2.1.4
