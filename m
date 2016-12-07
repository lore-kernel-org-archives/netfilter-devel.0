From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 07/50] netfilter: nf_log: do not assume ethernet header in netdev family
Date: Wed,  7 Dec 2016 22:52:13 +0100
Message-ID: <1481147576-5690-8-git-send-email-pablo@netfilter.org>
References: <1481147576-5690-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1481147576-5690-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Liping Zhang <zlpnobody@gmail.com>

In netdev family, we will handle non ethernet packets, so using
eth_hdr(skb)->h_proto is incorrect.

Meanwhile, we can use socket(AF_PACKET...) to sending packets, so
skb->protocol is not always set in bridge family.

Add an extra parameter into nf_log_l2packet to solve this issue.

Fixes: 1fddf4bad0ac ("netfilter: nf_log: add packet logging for netdev family")
Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_log.h       | 4 +++-
 net/bridge/netfilter/nf_log_bridge.c | 3 ++-
 net/netfilter/nf_log_common.c        | 3 ++-
 net/netfilter/nf_log_netdev.c        | 3 ++-
 4 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_log.h b/include/net/netfilter/nf_log.h
index a559aa41253c..450f87f95415 100644
--- a/include/net/netfilter/nf_log.h
+++ b/include/net/netfilter/nf_log.h
@@ -109,7 +109,9 @@ void nf_log_dump_packet_common(struct nf_log_buf *m, u_int8_t pf,
 			       const struct net_device *out,
 			       const struct nf_loginfo *loginfo,
 			       const char *prefix);
-void nf_log_l2packet(struct net *net, u_int8_t pf, unsigned int hooknum,
+void nf_log_l2packet(struct net *net, u_int8_t pf,
+		     __be16 protocol,
+		     unsigned int hooknum,
 		     const struct sk_buff *skb,
 		     const struct net_device *in,
 		     const struct net_device *out,
diff --git a/net/bridge/netfilter/nf_log_bridge.c b/net/bridge/netfilter/nf_log_bridge.c
index c197b1f844ee..bd2b3c78f59b 100644
--- a/net/bridge/netfilter/nf_log_bridge.c
+++ b/net/bridge/netfilter/nf_log_bridge.c
@@ -24,7 +24,8 @@ static void nf_log_bridge_packet(struct net *net, u_int8_t pf,
 				 const struct nf_loginfo *loginfo,
 				 const char *prefix)
 {
-	nf_log_l2packet(net, pf, hooknum, skb, in, out, loginfo, prefix);
+	nf_log_l2packet(net, pf, eth_hdr(skb)->h_proto, hooknum, skb,
+			in, out, loginfo, prefix);
 }
 
 static struct nf_logger nf_bridge_logger __read_mostly = {
diff --git a/net/netfilter/nf_log_common.c b/net/netfilter/nf_log_common.c
index ed9b80815fa0..dc61399e30be 100644
--- a/net/netfilter/nf_log_common.c
+++ b/net/netfilter/nf_log_common.c
@@ -177,6 +177,7 @@ EXPORT_SYMBOL_GPL(nf_log_dump_packet_common);
 
 /* bridge and netdev logging families share this code. */
 void nf_log_l2packet(struct net *net, u_int8_t pf,
+		     __be16 protocol,
 		     unsigned int hooknum,
 		     const struct sk_buff *skb,
 		     const struct net_device *in,
@@ -184,7 +185,7 @@ void nf_log_l2packet(struct net *net, u_int8_t pf,
 		     const struct nf_loginfo *loginfo,
 		     const char *prefix)
 {
-	switch (eth_hdr(skb)->h_proto) {
+	switch (protocol) {
 	case htons(ETH_P_IP):
 		nf_log_packet(net, NFPROTO_IPV4, hooknum, skb, in, out,
 			      loginfo, "%s", prefix);
diff --git a/net/netfilter/nf_log_netdev.c b/net/netfilter/nf_log_netdev.c
index 1f645949f3d8..350eb147754d 100644
--- a/net/netfilter/nf_log_netdev.c
+++ b/net/netfilter/nf_log_netdev.c
@@ -23,7 +23,8 @@ static void nf_log_netdev_packet(struct net *net, u_int8_t pf,
 				 const struct nf_loginfo *loginfo,
 				 const char *prefix)
 {
-	nf_log_l2packet(net, pf, hooknum, skb, in, out, loginfo, prefix);
+	nf_log_l2packet(net, pf, skb->protocol, hooknum, skb, in, out,
+			loginfo, prefix);
 }
 
 static struct nf_logger nf_netdev_logger __read_mostly = {
-- 
2.1.4
