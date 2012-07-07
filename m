From: Josh Hunt <johunt@akamai.com>
Subject: [PATCH 2/3] xtables: tarpit: Add IPv6 support
Date: Sat,  7 Jul 2012 14:21:00 -0700
Message-ID: <1341696061-21863-3-git-send-email-johunt@akamai.com>
References: <1341696061-21863-1-git-send-email-johunt@akamai.com>
Cc: Josh Hunt <johunt@akamai.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from prod-mail-xrelay05.akamai.com ([96.6.114.97]:56573 "EHLO
	prod-mail-xrelay05.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751675Ab2GGVVD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 7 Jul 2012 17:21:03 -0400
Received: from prod-mail-xrelay05.akamai.com (localhost.localdomain [127.0.0.1])
	by postfix.imss70 (Postfix) with ESMTP id AB7191C4917
	for <netfilter-devel@vger.kernel.org>; Sat,  7 Jul 2012 21:21:01 +0000 (GMT)
Received: from prod-mail-relay03.akamai.com (prod-mail-relay03.akamai.com [172.27.8.26])
	by prod-mail-xrelay05.akamai.com (Postfix) with ESMTP id 99B811C48D8
	for <netfilter-devel@vger.kernel.org>; Sat,  7 Jul 2012 21:21:01 +0000 (GMT)
In-Reply-To: <1341696061-21863-1-git-send-email-johunt@akamai.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Adds support for an IPv6 tarpit target attempting to mimic the v4 implementation.

Signed-off-by: Josh Hunt <johunt@akamai.com>
---
 extensions/xt_TARPIT.c |  215 ++++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 200 insertions(+), 15 deletions(-)

diff --git a/extensions/xt_TARPIT.c b/extensions/xt_TARPIT.c
index 9a09e75..a84b9c8 100644
--- a/extensions/xt_TARPIT.c
+++ b/extensions/xt_TARPIT.c
@@ -51,7 +51,15 @@
 #include "compat_xtables.h"
 #include "xt_TARPIT.h"
 
-static void tarpit_generic(struct tcphdr *oth, struct tcphdr *tcph, uint16_t payload, unsigned int mode) {
+#include <net/ipv6.h>
+#include <linux/netfilter_ipv6.h>
+#include <net/ip6_route.h>
+#include <net/ip6_checksum.h>
+#include <net/addrconf.h>
+
+
+static void tarpit_generic(struct tcphdr *oth, struct tcphdr *tcph,
+	uint16_t payload, unsigned int mode) {
 
 	if (mode == XTTARPIT_TARPIT) {
 		/* No replies for RST, FIN or !SYN,!ACK */
@@ -133,7 +141,7 @@ static void tarpit_generic(struct tcphdr *oth, struct tcphdr *tcph, uint16_t pay
 	}
 }
 
-static void tarpit_tcp(struct sk_buff *oldskb, unsigned int hook,
+static void tarpit_tcp4(struct sk_buff *oldskb, unsigned int hook,
     unsigned int mode)
 {
 	struct tcphdr _otcph, *oth, *tcph;
@@ -262,8 +270,130 @@ static void tarpit_tcp(struct sk_buff *oldskb, unsigned int hook,
 	kfree_skb(nskb);
 }
 
+static void tarpit_tcp6(struct sk_buff *oldskb, unsigned int hook,
+    unsigned int mode)
+{
+        struct sk_buff *nskb;
+        struct tcphdr *tcph, oth;
+        unsigned int otcplen;
+        int tcphoff;
+        const struct ipv6hdr *oip6h = ipv6_hdr(oldskb);
+        struct ipv6hdr *ip6h;
+#define DEFAULT_TOS_VALUE       0x0U
+        const __u8 tclass = DEFAULT_TOS_VALUE;
+        u8 proto;
+        uint16_t payload;
+
+        proto = oip6h->nexthdr;
+        tcphoff = ipv6_skip_exthdr(oldskb, ((u8*)(oip6h+1) - oldskb->data), &proto);
+
+        if ((tcphoff < 0) || (tcphoff > oldskb->len)) {
+                pr_debug("Cannot get TCP header.\n");
+                return;
+        }
+
+        otcplen = oldskb->len - tcphoff;
+
+        /* IP header checks: fragment, too short. */
+        if (proto != IPPROTO_TCP || otcplen < sizeof(struct tcphdr)) {
+                pr_debug("proto(%d) != IPPROTO_TCP, "
+                         "or too short. otcplen = %d\n",
+                         proto, otcplen);
+                return;
+        }
+
+        if (skb_copy_bits(oldskb, tcphoff, &oth, sizeof(struct tcphdr)))
+                BUG();
+
+        /* Check checksum. */
+        if (csum_ipv6_magic(&oip6h->saddr, &oip6h->daddr, otcplen, IPPROTO_TCP,
+                            skb_checksum(oldskb, tcphoff, otcplen, 0))) {
+                pr_debug("TCP checksum is invalid\n");
+                return;
+        }
+
+        nskb = skb_copy_expand(oldskb, LL_MAX_HEADER,
+                               skb_tailroom(oldskb), GFP_ATOMIC);
+        if (!nskb) {
+                if (net_ratelimit())
+                        pr_debug("cannot alloc skb\n");
+                return;
+        }
+
+        /* This packet will not be the same as the other: clear nf fields */
+        nf_reset(nskb);
+        skb_nfmark(nskb) = 0;
+        skb_init_secmark(nskb);
+
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 18)
+        skb_shinfo(nskb)->gso_size = 0;
+        skb_shinfo(nskb)->gso_segs = 0;
+        skb_shinfo(nskb)->gso_type = 0;
+#endif
+
+        skb_put(nskb, sizeof(struct ipv6hdr));
+        ip6h = ipv6_hdr(nskb);
+        *(__be32 *)ip6h =  htonl(0x60000000 | (tclass << 20));
+        ip6h->nexthdr = IPPROTO_TCP;
+        ipv6_addr_copy(&ip6h->saddr, &oip6h->daddr);
+        ipv6_addr_copy(&ip6h->daddr, &oip6h->saddr);
+
+        /* Adjust IP TTL */
+        if (mode == XTTARPIT_HONEYPOT)
+                ip6h->hop_limit = 128;
+        else
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 26)
+                ip6h->hop_limit = ip6_dst_hoplimit(skb_dst(nskb));
+#else
+                ip6h->hop_limit = dst_metric(dst, RTAX_HOPLIMIT);
+                if (ip6h->hop_limit < 0)
+                        ip6h->hop_limit = ipv6_get_hoplimit((skb_dst(nskb))->dev).
+#endif
+
+        tcph = (struct tcphdr *)(skb_network_header(nskb) + sizeof(struct ipv6hdr));
+
+        /* Truncate to length (no data) */
+        skb_trim(nskb, sizeof(struct ipv6hdr) + sizeof(struct tcphdr));
+        tcph->doff = sizeof(struct tcphdr)/4;
+        tcph->source = oth.dest;
+        tcph->dest = oth.source;
+
+        tcph->urg_ptr = 0;
+        /* Reset flags */
+        ((u_int8_t *)tcph)[13] = 0;
+
+        payload = nskb->len - sizeof(struct ipv6hdr) - sizeof(struct tcphdr);
+
+	tarpit_generic(&oth, tcph, payload, mode);
+
+        ip6h->payload_len = htons(sizeof(struct tcphdr));
+        tcph->check = 0;
+
+        /* Adjust TCP checksum */
+        tcph->check = csum_ipv6_magic(&ipv6_hdr(nskb)->saddr,
+                                      &ipv6_hdr(nskb)->daddr,
+                                      sizeof(struct tcphdr), IPPROTO_TCP,
+                                      csum_partial(tcph,
+                                                   sizeof(struct tcphdr), 0));
+
+        if (ip6_route_me_harder(nskb))
+                goto free_nskb;
+
+        nskb->ip_summed = CHECKSUM_NONE;
+
+        nf_ct_attach(nskb, oldskb);
+
+        NF_HOOK(NFPROTO_IPV6, NF_INET_LOCAL_OUT, nskb, NULL,
+                skb_dst(nskb)->dev, dst_output);
+        return;
+
+free_nskb:
+        kfree_skb(nskb);
+
+}
+
 static unsigned int
-tarpit_tg(struct sk_buff **pskb, const struct xt_action_param *par)
+tarpit_tg4(struct sk_buff **pskb, const struct xt_action_param *par)
 {
 	const struct sk_buff *skb = *pskb;
 	const struct iphdr *iph = ip_hdr(skb);
@@ -294,29 +424,83 @@ tarpit_tg(struct sk_buff **pskb, const struct xt_action_param *par)
 	if (iph->frag_off & htons(IP_OFFSET))
 		return NF_DROP;
 
-	tarpit_tcp(*pskb, par->hooknum, info->variant);
+	tarpit_tcp4(*pskb, par->hooknum, info->variant);
 	return NF_DROP;
 }
 
-static struct xt_target tarpit_tg_reg __read_mostly = {
-	.name       = "TARPIT",
-	.revision   = 0,
-	.family     = NFPROTO_IPV4,
-	.hooks      = (1 << NF_INET_LOCAL_IN) | (1 << NF_INET_FORWARD),
-	.proto      = IPPROTO_TCP,
-	.target     = tarpit_tg,
-	.targetsize = sizeof(struct xt_tarpit_tginfo),
-	.me         = THIS_MODULE,
+static unsigned int
+tarpit_tg6(struct sk_buff **pskb, const struct xt_action_param *par)
+{
+        const struct sk_buff *skb = *pskb;
+        const struct ipv6hdr *iph = ipv6_hdr(skb);
+        const struct rt6_info *rt = (struct rt6_info *)skb_dst(skb);
+        const struct xt_tarpit_tginfo *info = par->targinfo;
+	u8	proto;
+
+        /* Do we have an input route cache entry? (Not in PREROUTING.) */
+        if (rt == NULL) {
+                pr_debug("Dropping no input route cache entry\n");
+                return NF_DROP;
+        }
+
+        /* No replies to physical multicast/broadcast */
+        /* skb != PACKET_OTHERHOST handled by ip_rcv() */
+        if (skb->pkt_type != PACKET_HOST) {
+                pr_debug("type != PACKET_HOST");
+                return NF_DROP;
+        }
+
+        /*
+         * Our naive response construction does not deal with IP
+         * options, and probably should not try.
+         */
+	proto = iph->nexthdr;
+	if (ipv6_skip_exthdr(skb, skb_network_header_len(skb), &proto) != sizeof(struct ipv6hdr))
+		return NF_DROP;
+
+        if ((!(ipv6_addr_type(&iph->saddr) & IPV6_ADDR_UNICAST)) ||
+            (!(ipv6_addr_type(&iph->daddr) & IPV6_ADDR_UNICAST))) {
+                pr_debug("addr is not unicast.\n");
+                return;
+        }
+
+        tarpit_tcp6(*pskb, par->hooknum, info->variant);
+        return NF_DROP;
+}
+
+
+static struct xt_target tarpit_tg_reg[] __read_mostly = {
+	{
+		.name       = "TARPIT",
+		.revision   = 0,
+		.family     = NFPROTO_IPV4,
+		.hooks      = (1 << NF_INET_LOCAL_IN) | (1 << NF_INET_FORWARD),
+		.proto      = IPPROTO_TCP,
+		.target     = tarpit_tg4,
+		.targetsize = sizeof(struct xt_tarpit_tginfo),
+		.me         = THIS_MODULE,
+	},
+	{
+                .name       = "TARPIT",
+                .revision   = 0,
+                .family     = NFPROTO_IPV6,
+                .hooks      = (1 << NF_INET_LOCAL_IN) | (1 << NF_INET_FORWARD),
+                .proto      = IPPROTO_TCP,
+                .target     = tarpit_tg6,
+                .targetsize = sizeof(struct xt_tarpit_tginfo),
+                .me         = THIS_MODULE,
+        },
+
 };
 
 static int __init tarpit_tg_init(void)
 {
-	return xt_register_target(&tarpit_tg_reg);
+	return xt_register_targets(tarpit_tg_reg, ARRAY_SIZE(tarpit_tg_reg));
 }
 
 static void __exit tarpit_tg_exit(void)
 {
-	xt_unregister_target(&tarpit_tg_reg);
+	xt_unregister_targets(tarpit_tg_reg, ARRAY_SIZE(tarpit_tg_reg));
 }
 
 module_init(tarpit_tg_init);
@@ -325,3 +509,4 @@ MODULE_DESCRIPTION("Xtables: \"TARPIT\", capture and hold TCP connections");
 MODULE_AUTHOR("Jan Engelhardt <jengelh@medozas.de>");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_TARPIT");
+MODULE_ALIAS("ip6t_TARPIT");
-- 
1.7.0.4

