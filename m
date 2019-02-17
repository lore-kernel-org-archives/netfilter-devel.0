From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 09/11] netfilter: reject: skip csum verification for protocols that don't support it
Date: Mon, 18 Feb 2019 00:23:55 +0100
Message-ID: <20190217232357.29858-10-pablo@netfilter.org>
References: <20190217232357.29858-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190217232357.29858-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Alin Nastac <alin.nastac@gmail.com>

Some protocols have other means to verify the payload integrity
(AH, ESP, SCTP) while others are incompatible with nf_ip(6)_checksum
implementation because checksum is either optional or might be
partial (UDPLITE, DCCP, GRE). Because nf_ip(6)_checksum was used
to validate the packets, ip(6)tables REJECT rules were not capable
to generate ICMP(v6) errors for the protocols mentioned above.

This commit also fixes the incorrect pseudo-header protocol used
for IPv4 packets that carry other transport protocols than TCP or
UDP (pseudo-header used protocol 0 iso the proper value).

Signed-off-by: Alin Nastac <alin.nastac@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/ipv4/nf_reject.h   |  1 +
 include/net/netfilter/ipv6/nf_reject.h   |  1 +
 include/net/netfilter/nf_reject.h        | 27 +++++++++++++++++++++++++++
 net/bridge/netfilter/nft_reject_bridge.c | 10 +++++-----
 net/ipv4/netfilter/nf_reject_ipv4.c      |  9 ++-------
 net/ipv6/netfilter/nf_reject_ipv6.c      |  3 +++
 6 files changed, 39 insertions(+), 12 deletions(-)
 create mode 100644 include/net/netfilter/nf_reject.h

diff --git a/include/net/netfilter/ipv4/nf_reject.h b/include/net/netfilter/ipv4/nf_reject.h
index 2eb43fcefc50..40e0e0623f46 100644
--- a/include/net/netfilter/ipv4/nf_reject.h
+++ b/include/net/netfilter/ipv4/nf_reject.h
@@ -5,6 +5,7 @@
 #include <linux/skbuff.h>
 #include <net/ip.h>
 #include <net/icmp.h>
+#include <net/netfilter/nf_reject.h>
 
 void nf_send_unreach(struct sk_buff *skb_in, int code, int hook);
 void nf_send_reset(struct net *net, struct sk_buff *oldskb, int hook);
diff --git a/include/net/netfilter/ipv6/nf_reject.h b/include/net/netfilter/ipv6/nf_reject.h
index 3a5a9a36a0b2..4a3ef9ebdf6f 100644
--- a/include/net/netfilter/ipv6/nf_reject.h
+++ b/include/net/netfilter/ipv6/nf_reject.h
@@ -3,6 +3,7 @@
 #define _IPV6_NF_REJECT_H
 
 #include <linux/icmpv6.h>
+#include <net/netfilter/nf_reject.h>
 
 void nf_send_unreach6(struct net *net, struct sk_buff *skb_in, unsigned char code,
 		      unsigned int hooknum);
diff --git a/include/net/netfilter/nf_reject.h b/include/net/netfilter/nf_reject.h
new file mode 100644
index 000000000000..221f877f29d1
--- /dev/null
+++ b/include/net/netfilter/nf_reject.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _NF_REJECT_H
+#define _NF_REJECT_H
+
+static inline bool nf_reject_verify_csum(__u8 proto)
+{
+	/* Skip protocols that don't use 16-bit one's complement checksum
+	 * of the entire payload.
+	 */
+	switch (proto) {
+		/* Protocols with other integrity checks. */
+		case IPPROTO_AH:
+		case IPPROTO_ESP:
+		case IPPROTO_SCTP:
+
+		/* Protocols with partial checksums. */
+		case IPPROTO_UDPLITE:
+		case IPPROTO_DCCP:
+
+		/* Protocols with optional checksums. */
+		case IPPROTO_GRE:
+			return false;
+	}
+	return true;
+}
+
+#endif /* _NF_REJECT_H */
diff --git a/net/bridge/netfilter/nft_reject_bridge.c b/net/bridge/netfilter/nft_reject_bridge.c
index 419e8edf23ba..1b1856744c80 100644
--- a/net/bridge/netfilter/nft_reject_bridge.c
+++ b/net/bridge/netfilter/nft_reject_bridge.c
@@ -125,13 +125,10 @@ static void nft_reject_br_send_v4_unreach(struct net *net,
 	if (pskb_trim_rcsum(oldskb, ntohs(ip_hdr(oldskb)->tot_len)))
 		return;
 
-	if (ip_hdr(oldskb)->protocol == IPPROTO_TCP ||
-	    ip_hdr(oldskb)->protocol == IPPROTO_UDP)
-		proto = ip_hdr(oldskb)->protocol;
-	else
-		proto = 0;
+	proto = ip_hdr(oldskb)->protocol;
 
 	if (!skb_csum_unnecessary(oldskb) &&
+	    nf_reject_verify_csum(proto) &&
 	    nf_ip_checksum(oldskb, hook, ip_hdrlen(oldskb), proto))
 		return;
 
@@ -234,6 +231,9 @@ static bool reject6_br_csum_ok(struct sk_buff *skb, int hook)
 	if (thoff < 0 || thoff >= skb->len || (fo & htons(~0x7)) != 0)
 		return false;
 
+	if (!nf_reject_verify_csum(proto))
+		return true;
+
 	return nf_ip6_checksum(skb, hook, thoff, proto) == 0;
 }
 
diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index aa8304c618b8..7dc3c324b911 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -173,21 +173,16 @@ EXPORT_SYMBOL_GPL(nf_send_reset);
 void nf_send_unreach(struct sk_buff *skb_in, int code, int hook)
 {
 	struct iphdr *iph = ip_hdr(skb_in);
-	u8 proto;
+	u8 proto = iph->protocol;
 
 	if (iph->frag_off & htons(IP_OFFSET))
 		return;
 
-	if (skb_csum_unnecessary(skb_in)) {
+	if (skb_csum_unnecessary(skb_in) || !nf_reject_verify_csum(proto)) {
 		icmp_send(skb_in, ICMP_DEST_UNREACH, code, 0);
 		return;
 	}
 
-	if (iph->protocol == IPPROTO_TCP || iph->protocol == IPPROTO_UDP)
-		proto = iph->protocol;
-	else
-		proto = 0;
-
 	if (nf_ip_checksum(skb_in, hook, ip_hdrlen(skb_in), proto) == 0)
 		icmp_send(skb_in, ICMP_DEST_UNREACH, code, 0);
 }
diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
index b9c8a763c863..02e9228641e0 100644
--- a/net/ipv6/netfilter/nf_reject_ipv6.c
+++ b/net/ipv6/netfilter/nf_reject_ipv6.c
@@ -233,6 +233,9 @@ static bool reject6_csum_ok(struct sk_buff *skb, int hook)
 	if (thoff < 0 || thoff >= skb->len || (fo & htons(~0x7)) != 0)
 		return false;
 
+	if (!nf_reject_verify_csum(proto))
+		return true;
+
 	return nf_ip6_checksum(skb, hook, thoff, proto) == 0;
 }
 
-- 
2.11.0
