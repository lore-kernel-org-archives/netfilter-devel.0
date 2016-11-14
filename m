From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next] netfilter: nf_log: do not assume ethernet header in netdev family
Date: Mon, 14 Nov 2016 22:39:25 +0800
Message-ID: <1479134365-18623-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-13.163.com ([220.181.12.13]:33285 "EHLO m12-13.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753374AbcKNOj6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Nov 2016 09:39:58 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

In netdev family, we will handle non ethernet packets, so using
eth_hdr(skb)->h_proto is incorrect.

Meanwhile, we can use socket(AF_PACKET...) to sending packets, so
skb->protocol is not always set in bridge family.

Add an extra parameter into nf_log_l2packet to solve this issue.

Fixes: 1fddf4bad0ac ("netfilter: nf_log: add packet logging for netdev family")
Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 include/net/netfilter/nf_log.h       | 4 +++-
 net/bridge/netfilter/nf_log_bridge.c | 3 ++-
 net/netfilter/nf_log_common.c        | 3 ++-
 net/netfilter/nf_log_netdev.c        | 3 ++-
 4 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_log.h b/include/net/netfilter/nf_log.h
index a559aa4..450f87f 100644
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
index c197b1f..bd2b3c7 100644
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
index ed9b808..dc61399 100644
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
index 1f64594..350eb14 100644
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
2.5.5


