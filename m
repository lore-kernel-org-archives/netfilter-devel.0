From: Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH V3] audit: normalize NETFILTER_PKT
Date: Sun, 26 Feb 2017 15:49:39 -0500
Message-ID: <044a666e507a829f8c1d6dcc19ad78cd9f140ddd.1488142060.git.rgb@redhat.com>
Cc: Richard Guy Briggs <rgb@redhat.com>,
        Thomas Woerner <twoerner@redhat.com>,
        Thomas Graf <tgraf@infradead.org>,
        Eric Paris <eparis@redhat.com>, Paul Moore <pmoore@redhat.com>,
        Steve Grubb <sgrubb@redhat.com>
To: Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>, linux-audit@redhat.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54742 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751221AbdBZUuG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 26 Feb 2017 15:50:06 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eliminate flipping in and out of message fields, dropping fields in the process.

Sample raw message format IPv4 UDP:
type=NETFILTER_PKT msg=audit(1487874761.386:228):  mark=0xae8a2732 saddr=127.0.0.1 daddr=127.0.0.1 proto=17^]
Sample raw message format IPv6 ICMP6:
type=NETFILTER_PKT msg=audit(1487874761.381:227):  mark=0x223894b7 saddr=::1 daddr=::1 proto=58^]

Issue: https://github.com/linux-audit/audit-kernel/issues/11
Test case: https://github.com/linux-audit/audit-testsuite/issues/43

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 net/netfilter/xt_AUDIT.c |  122 ++++++++++-----------------------------------
 1 files changed, 27 insertions(+), 95 deletions(-)

diff --git a/net/netfilter/xt_AUDIT.c b/net/netfilter/xt_AUDIT.c
index 4973cbd..945fa29 100644
--- a/net/netfilter/xt_AUDIT.c
+++ b/net/netfilter/xt_AUDIT.c
@@ -31,146 +31,78 @@ MODULE_ALIAS("ip6t_AUDIT");
 MODULE_ALIAS("ebt_AUDIT");
 MODULE_ALIAS("arpt_AUDIT");
 
-static void audit_proto(struct audit_buffer *ab, struct sk_buff *skb,
-			unsigned int proto, unsigned int offset)
-{
-	switch (proto) {
-	case IPPROTO_TCP:
-	case IPPROTO_UDP:
-	case IPPROTO_UDPLITE: {
-		const __be16 *pptr;
-		__be16 _ports[2];
-
-		pptr = skb_header_pointer(skb, offset, sizeof(_ports), _ports);
-		if (pptr == NULL) {
-			audit_log_format(ab, " truncated=1");
-			return;
-		}
-
-		audit_log_format(ab, " sport=%hu dport=%hu",
-				 ntohs(pptr[0]), ntohs(pptr[1]));
-		}
-		break;
-
-	case IPPROTO_ICMP:
-	case IPPROTO_ICMPV6: {
-		const u8 *iptr;
-		u8 _ih[2];
-
-		iptr = skb_header_pointer(skb, offset, sizeof(_ih), &_ih);
-		if (iptr == NULL) {
-			audit_log_format(ab, " truncated=1");
-			return;
-		}
-
-		audit_log_format(ab, " icmptype=%hhu icmpcode=%hhu",
-				 iptr[0], iptr[1]);
-
-		}
-		break;
-	}
-}
-
-static void audit_ip4(struct audit_buffer *ab, struct sk_buff *skb)
+static bool audit_ip4(struct audit_buffer *ab, struct sk_buff *skb)
 {
 	struct iphdr _iph;
 	const struct iphdr *ih;
 
 	ih = skb_header_pointer(skb, 0, sizeof(_iph), &_iph);
-	if (!ih) {
-		audit_log_format(ab, " truncated=1");
-		return;
-	}
+	if (!ih)
+		return false;
 
-	audit_log_format(ab, " saddr=%pI4 daddr=%pI4 ipid=%hu proto=%hhu",
-		&ih->saddr, &ih->daddr, ntohs(ih->id), ih->protocol);
+	audit_log_format(ab, " saddr=%pI4 daddr=%pI4 proto=%hhu",
+			 &ih->saddr, &ih->daddr, ih->protocol);
 
-	if (ntohs(ih->frag_off) & IP_OFFSET) {
-		audit_log_format(ab, " frag=1");
-		return;
-	}
-
-	audit_proto(ab, skb, ih->protocol, ih->ihl * 4);
+	return true;
 }
 
-static void audit_ip6(struct audit_buffer *ab, struct sk_buff *skb)
+static bool audit_ip6(struct audit_buffer *ab, struct sk_buff *skb)
 {
 	struct ipv6hdr _ip6h;
 	const struct ipv6hdr *ih;
 	u8 nexthdr;
 	__be16 frag_off;
-	int offset;
 
 	ih = skb_header_pointer(skb, skb_network_offset(skb), sizeof(_ip6h), &_ip6h);
-	if (!ih) {
-		audit_log_format(ab, " truncated=1");
-		return;
-	}
+	if (!ih)
+		return false;
 
 	nexthdr = ih->nexthdr;
-	offset = ipv6_skip_exthdr(skb, skb_network_offset(skb) + sizeof(_ip6h),
-				  &nexthdr, &frag_off);
+	ipv6_skip_exthdr(skb, skb_network_offset(skb) + sizeof(_ip6h), &nexthdr, &frag_off);
 
 	audit_log_format(ab, " saddr=%pI6c daddr=%pI6c proto=%hhu",
 			 &ih->saddr, &ih->daddr, nexthdr);
 
-	if (offset)
-		audit_proto(ab, skb, nexthdr, offset);
+	return true;
 }
 
 static unsigned int
 audit_tg(struct sk_buff *skb, const struct xt_action_param *par)
 {
-	const struct xt_audit_info *info = par->targinfo;
 	struct audit_buffer *ab;
+	int fam = -1;
 
 	if (audit_enabled == 0)
 		goto errout;
-
 	ab = audit_log_start(NULL, GFP_ATOMIC, AUDIT_NETFILTER_PKT);
 	if (ab == NULL)
 		goto errout;
 
-	audit_log_format(ab, "action=%hhu hook=%u len=%u inif=%s outif=%s",
-			 info->type, par->hooknum, skb->len,
-			 par->in ? par->in->name : "?",
-			 par->out ? par->out->name : "?");
-
-	if (skb->mark)
-		audit_log_format(ab, " mark=%#x", skb->mark);
-
-	if (skb->dev && skb->dev->type == ARPHRD_ETHER) {
-		audit_log_format(ab, " smac=%pM dmac=%pM macproto=0x%04x",
-				 eth_hdr(skb)->h_source, eth_hdr(skb)->h_dest,
-				 ntohs(eth_hdr(skb)->h_proto));
+	audit_log_format(ab, "mark=%#x", skb->mark ?: -1);
 
-		if (par->family == NFPROTO_BRIDGE) {
+	switch (par->family) {
+		case NFPROTO_BRIDGE: {
 			switch (eth_hdr(skb)->h_proto) {
 			case htons(ETH_P_IP):
-				audit_ip4(ab, skb);
+				fam = audit_ip4(ab, skb) ? NFPROTO_IPV4 : -1;
 				break;
-
 			case htons(ETH_P_IPV6):
-				audit_ip6(ab, skb);
+				fam = audit_ip6(ab, skb) ? NFPROTO_IPV6 : -1;
 				break;
 			}
+			break;
 		}
+		case NFPROTO_IPV4:
+			fam = audit_ip4(ab, skb) ? NFPROTO_IPV4 : -1;
+			break;
+	
+		case NFPROTO_IPV6:
+			fam = audit_ip6(ab, skb) ? NFPROTO_IPV6 : -1;
+			break;
 	}
 
-	switch (par->family) {
-	case NFPROTO_IPV4:
-		audit_ip4(ab, skb);
-		break;
-
-	case NFPROTO_IPV6:
-		audit_ip6(ab, skb);
-		break;
-	}
-
-#ifdef CONFIG_NETWORK_SECMARK
-	if (skb->secmark)
-		audit_log_secctx(ab, skb->secmark);
-#endif
+	if (fam == -1)
+		audit_log_format(ab, " saddr=? daddr=? proto=-1");
 
 	audit_log_end(ab);
 
-- 
1.7.1

