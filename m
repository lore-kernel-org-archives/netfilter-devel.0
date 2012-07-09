From: Josh Hunt <johunt@akamai.com>
Subject: [PATCH] TARPIT: Fix build problem with newer kernels
Date: Mon,  9 Jul 2012 07:00:02 -0700
Message-ID: <1341842402-25128-1-git-send-email-johunt@akamai.com>
Cc: Josh Hunt <johunt@akamai.com>
To: jengelh@inai.de, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from prod-mail-xrelay05.akamai.com ([96.6.114.97]:40747 "EHLO
	prod-mail-xrelay05.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753527Ab2GIOAD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:00:03 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Adds fragment offset arg to ipv6_skip_exthdr() and also removes usage
of ipv6_addr_copy() in favor or direct assignment.

Signed-off-by: Josh Hunt <johunt@akamai.com>
---
 extensions/xt_TARPIT.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/extensions/xt_TARPIT.c b/extensions/xt_TARPIT.c
index cdd0f5a..ac69364 100644
--- a/extensions/xt_TARPIT.c
+++ b/extensions/xt_TARPIT.c
@@ -310,10 +310,11 @@ static void tarpit_tcp6(struct sk_buff *oldskb, unsigned int hook,
 	const uint8_t tclass = 0;
 	uint8_t proto;
 	uint16_t payload;
+	__be16 frag_off;
 
 	proto   = oip6h->nexthdr;
 	tcphoff = ipv6_skip_exthdr(oldskb,
-	          (uint8_t *)(oip6h + 1) - oldskb->data, &proto);
+	          (uint8_t *)(oip6h + 1) - oldskb->data, &proto, &frag_off);
 
 	if (tcphoff < 0 || tcphoff > oldskb->len) {
 		pr_debug("Cannot get TCP header.\n");
@@ -365,8 +366,8 @@ static void tarpit_tcp6(struct sk_buff *oldskb, unsigned int hook,
 	ip6h = ipv6_hdr(nskb);
 	*(__be32 *)ip6h =  htonl(0x60000000 | (tclass << 20));
 	ip6h->nexthdr = IPPROTO_TCP;
-	ipv6_addr_copy(&ip6h->saddr, &oip6h->daddr);
-	ipv6_addr_copy(&ip6h->daddr, &oip6h->saddr);
+	ip6h->saddr = oip6h->daddr;
+	ip6h->daddr = oip6h->saddr;
 
 	/* Adjust IP TTL */
 	if (mode == XTTARPIT_HONEYPOT)
@@ -464,6 +465,7 @@ tarpit_tg6(struct sk_buff **pskb, const struct xt_action_param *par)
 	const struct rt6_info *rt = (struct rt6_info *)skb_dst(skb);
 	const struct xt_tarpit_tginfo *info = par->targinfo;
 	uint8_t proto;
+	__be16 frag_off;
 
 	/* Do we have an input route cache entry? (Not in PREROUTING.) */
 	if (rt == NULL) {
@@ -483,8 +485,8 @@ tarpit_tg6(struct sk_buff **pskb, const struct xt_action_param *par)
 	 * options, and probably should not try.
 	 */
 	proto = iph->nexthdr;
-	if (ipv6_skip_exthdr(skb, skb_network_header_len(skb), &proto) !=
-	    sizeof(struct ipv6hdr))
+	if (ipv6_skip_exthdr(skb, skb_network_header_len(skb), &proto,
+	    &frag_off) != sizeof(struct ipv6hdr))
 		return NF_DROP;
 
 	if ((!(ipv6_addr_type(&iph->saddr) & IPV6_ADDR_UNICAST)) ||
-- 
1.7.0.4

