From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 1/2] [NETFILTER]: xt_TCPMSS: Consider incoming device's MTU
 in clamp-to-pmtu
Date: Sun, 20 Jan 2008 13:18:47 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801201318040.14598@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:49379 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbYATMSt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Jan 2008 07:18:49 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


`git log -p` just flies better than `git-format-patch` I guess.

===
commit 1ed78bbf75455dfe77a028f2da2f351cff4028f2
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Sun Jan 20 13:13:33 2008 +0100

    [NETFILTER]: xt_TCPMSS: Consider incoming device's MTU in clamp-to-pmtu
    
    The TCPMSS target in Xtables should consider the MTU of the input
    device on forwarded packets as part of the path MTU.
    
    Point in case: IN=ppp0, OUT=eth0. MSS set to 1460 in spite of MTU of
    ppp0 being 1392.
    
    Signed-off-by: Jaco Kroon <jaco@uls.co.za>
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
index 60e3767..2c446b6 100644
--- a/net/netfilter/xt_TCPMSS.c
+++ b/net/netfilter/xt_TCPMSS.c
@@ -41,6 +41,7 @@ optlen(const u_int8_t *opt, unsigned int offset)
 static int
 tcpmss_mangle_packet(struct sk_buff *skb,
 		     const struct xt_tcpmss_info *info,
+		     unsigned int in_mtu,
 		     unsigned int tcphoff,
 		     unsigned int minlen)
 {
@@ -76,7 +77,13 @@ tcpmss_mangle_packet(struct sk_buff *skb,
 				       dst_mtu(skb->dst));
 			return -1;
 		}
-		newmss = dst_mtu(skb->dst) - minlen;
+		if (in_mtu <= minlen) {
+			if (net_ratelimit())
+				printk(KERN_ERR "xt_TCPMSS: unknown or "
+				       "invalid path-MTU (%u)\n", in_mtu);
+			return -1;
+		}
+		newmss = min(dst_mtu(skb->dst), in_mtu) - minlen;
 	} else
 		newmss = info->mss;
 
@@ -146,8 +153,8 @@ tcpmss_tg4(struct sk_buff *skb, const struct net_device *in,
 	__be16 newlen;
 	int ret;
 
-	ret = tcpmss_mangle_packet(skb, targinfo, iph->ihl * 4,
-				   sizeof(*iph) + sizeof(struct tcphdr));
+	ret = tcpmss_mangle_packet(skb, targinfo, (in == NULL) ? ~0U : in->mtu,
+	      iph->ihl * 4, sizeof(*iph) + sizeof(struct tcphdr));
 	if (ret < 0)
 		return NF_DROP;
 	if (ret > 0) {
@@ -174,8 +181,8 @@ tcpmss_tg6(struct sk_buff *skb, const struct net_device *in,
 	tcphoff = ipv6_skip_exthdr(skb, sizeof(*ipv6h), &nexthdr);
 	if (tcphoff < 0)
 		return NF_DROP;
-	ret = tcpmss_mangle_packet(skb, targinfo, tcphoff,
-				   sizeof(*ipv6h) + sizeof(struct tcphdr));
+	ret = tcpmss_mangle_packet(skb, targinfo, (in == NULL) ? ~0U : in->mtu,
+	      tcphoff, sizeof(*ipv6h) + sizeof(struct tcphdr));
 	if (ret < 0)
 		return NF_DROP;
 	if (ret > 0) {

