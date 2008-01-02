From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 11/27] xt_hashlimit: use the new union nf_inet_addr
Date: Wed, 2 Jan 2008 21:28:36 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801022128240.14900@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56924 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470AbYABU2h (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Jan 2008 15:28:37 -0500
In-Reply-To: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 80d12da7b0d6cce28719db2a4ced58e46f28107f
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Wed Jan 2 17:56:28 2008 +0100

    [NETFILTER]: xt_hashlimit: use the new union nf_inet_addr
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

 net/netfilter/xt_hashlimit.c |   34 ++++++++++++----------------------
 1 files changed, 12 insertions(+), 22 deletions(-)

diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 1b48153..8439ee4 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -46,18 +46,8 @@ static const struct file_operations dl_file_ops;
 
 /* hash table crap */
 struct dsthash_dst {
-	union {
-		struct {
-			__be32 src;
-			__be32 dst;
-		} ip;
-#if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
-		struct {
-			__be32 src[4];
-			__be32 dst[4];
-		} ip6;
-#endif
-	} addr;
+	union nf_inet_addr src;
+	union nf_inet_addr dst;
 	__be16 src_port;
 	__be16 dst_port;
 };
@@ -401,9 +391,9 @@ hashlimit_init_dst(const struct xt_hashlimit_htable *hinfo,
 	switch (hinfo->family) {
 	case AF_INET:
 		if (hinfo->cfg.mode & XT_HASHLIMIT_HASH_DIP)
-			dst->addr.ip.dst = ip_hdr(skb)->daddr;
+			dst->dst.ip = ip_hdr(skb)->daddr;
 		if (hinfo->cfg.mode & XT_HASHLIMIT_HASH_SIP)
-			dst->addr.ip.src = ip_hdr(skb)->saddr;
+			dst->src.ip = ip_hdr(skb)->saddr;
 
 		if (!(hinfo->cfg.mode &
 		      (XT_HASHLIMIT_HASH_DPT | XT_HASHLIMIT_HASH_SPT)))
@@ -413,11 +403,11 @@ hashlimit_init_dst(const struct xt_hashlimit_htable *hinfo,
 #if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
 	case AF_INET6:
 		if (hinfo->cfg.mode & XT_HASHLIMIT_HASH_DIP)
-			memcpy(&dst->addr.ip6.dst, &ipv6_hdr(skb)->daddr,
-			       sizeof(dst->addr.ip6.dst));
+			memcpy(&dst->dst.in6, &ipv6_hdr(skb)->daddr,
+			       sizeof(dst->dst.in6));
 		if (hinfo->cfg.mode & XT_HASHLIMIT_HASH_SIP)
-			memcpy(&dst->addr.ip6.src, &ipv6_hdr(skb)->saddr,
-			       sizeof(dst->addr.ip6.src));
+			memcpy(&dst->src.in6, &ipv6_hdr(skb)->saddr,
+			       sizeof(dst->src.in6));
 
 		if (!(hinfo->cfg.mode &
 		      (XT_HASHLIMIT_HASH_DPT | XT_HASHLIMIT_HASH_SPT)))
@@ -642,9 +632,9 @@ static int dl_seq_real_show(struct dsthash_ent *ent, int family,
 		return seq_printf(s, "%ld %u.%u.%u.%u:%u->"
 				     "%u.%u.%u.%u:%u %u %u %u\n",
 				 (long)(ent->expires - jiffies)/HZ,
-				 NIPQUAD(ent->dst.addr.ip.src),
+				 NIPQUAD(ent->dst.src.in),
 				 ntohs(ent->dst.src_port),
-				 NIPQUAD(ent->dst.addr.ip.dst),
+				 NIPQUAD(ent->dst.dst.in),
 				 ntohs(ent->dst.dst_port),
 				 ent->rateinfo.credit, ent->rateinfo.credit_cap,
 				 ent->rateinfo.cost);
@@ -653,9 +643,9 @@ static int dl_seq_real_show(struct dsthash_ent *ent, int family,
 		return seq_printf(s, "%ld " NIP6_FMT ":%u->"
 				     NIP6_FMT ":%u %u %u %u\n",
 				 (long)(ent->expires - jiffies)/HZ,
-				 NIP6(*(struct in6_addr *)&ent->dst.addr.ip6.src),
+				 NIP6(ent->dst.src.in6),
 				 ntohs(ent->dst.src_port),
-				 NIP6(*(struct in6_addr *)&ent->dst.addr.ip6.dst),
+				 NIP6(ent->dst.dst.in6),
 				 ntohs(ent->dst.dst_port),
 				 ent->rateinfo.credit, ent->rateinfo.credit_cap,
 				 ent->rateinfo.cost);
