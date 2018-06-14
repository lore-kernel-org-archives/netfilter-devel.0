From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net-next,RFC 02/13] net: Change priority of ipv4 and ipv6 packet offloads.
Date: Thu, 14 Jun 2018 16:19:36 +0200
Message-ID: <20180614141947.3580-3-pablo@netfilter.org>
References: <20180614141947.3580-1-pablo@netfilter.org>
Cc: netdev@vger.kernel.org, steffen.klassert@secunet.com
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180614141947.3580-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Steffen Klassert <steffen.klassert@secunet.com>

The forward fastpath needs to insert callbacks with
higher priority than the standard callbacks. So change
the priority of ipv4 and ipv6 packet offloads from zero
to one. With this we are able to insert callbacks with
priotity zero if needed.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/af_inet.c     | 1 +
 net/ipv6/ip6_offload.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 15e125558c76..fbb90f7556ea 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1841,6 +1841,7 @@ static int ipv4_proc_init(void);
 
 static struct packet_offload ip_packet_offload __read_mostly = {
 	.type = cpu_to_be16(ETH_P_IP),
+	.priority = 1,
 	.callbacks = {
 		.gso_segment = inet_gso_segment,
 		.gro_receive = inet_gro_receive,
diff --git a/net/ipv6/ip6_offload.c b/net/ipv6/ip6_offload.c
index 5b3f2f89ef41..863913fb690f 100644
--- a/net/ipv6/ip6_offload.c
+++ b/net/ipv6/ip6_offload.c
@@ -343,6 +343,7 @@ static int ip4ip6_gro_complete(struct sk_buff *skb, int nhoff)
 
 static struct packet_offload ipv6_packet_offload __read_mostly = {
 	.type = cpu_to_be16(ETH_P_IPV6),
+	.priority = 1,
 	.callbacks = {
 		.gso_segment = ipv6_gso_segment,
 		.gro_receive = ipv6_gro_receive,
-- 
2.11.0
