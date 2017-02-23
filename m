From: Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH V2] audit: normalize NETFILTER_PKT
Date: Wed, 22 Feb 2017 21:50:54 -0500
Message-ID: <9504740e9333a0b7074abe0dddfc487aeeae6cff.1487813996.git.rgb@redhat.com>
Cc: Richard Guy Briggs <rgb@redhat.com>,
        Thomas Graf <tgraf@infradead.org>,
        Eric Paris <eparis@redhat.com>, Paul Moore <pmoore@redhat.com>,
        Steve Grubb <sgrubb@redhat.com>
To: Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>, linux-audit@redhat.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44976 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932388AbdBWCva (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Feb 2017 21:51:30 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Simplify and eliminate flipping in and out of message fields, relying on nfmark
the way we do for audit_key.

https://github.com/linux-audit/audit-kernel/issues/11

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 net/netfilter/xt_AUDIT.c |  128 +++++++++++++++-------------------------------
 1 files changed, 41 insertions(+), 87 deletions(-)

diff --git a/net/netfilter/xt_AUDIT.c b/net/netfilter/xt_AUDIT.c
index 4973cbd..05f7f25 100644
--- a/net/netfilter/xt_AUDIT.c
+++ b/net/netfilter/xt_AUDIT.c
@@ -31,146 +31,100 @@ MODULE_ALIAS("ip6t_AUDIT");
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
+struct nfpkt_par {
+	int ipv;
+	const void *saddr;
+	const void *daddr;
+	u8 proto;
+};
 
-static void audit_ip4(struct audit_buffer *ab, struct sk_buff *skb)
+static void audit_ip4(struct audit_buffer *ab, struct sk_buff *skb, struct nfpkt_par *apar)
 {
 	struct iphdr _iph;
 	const struct iphdr *ih;
 
+	apar->ipv = 4;
 	ih = skb_header_pointer(skb, 0, sizeof(_iph), &_iph);
-	if (!ih) {
-		audit_log_format(ab, " truncated=1");
+	if (!ih)
 		return;
-	}
-
-	audit_log_format(ab, " saddr=%pI4 daddr=%pI4 ipid=%hu proto=%hhu",
-		&ih->saddr, &ih->daddr, ntohs(ih->id), ih->protocol);
-
-	if (ntohs(ih->frag_off) & IP_OFFSET) {
-		audit_log_format(ab, " frag=1");
-		return;
-	}
 
-	audit_proto(ab, skb, ih->protocol, ih->ihl * 4);
+	apar->saddr = &ih->saddr;
+	apar->daddr = &ih->daddr;
+	apar->proto = ih->protocol;
 }
 
-static void audit_ip6(struct audit_buffer *ab, struct sk_buff *skb)
+static void audit_ip6(struct audit_buffer *ab, struct sk_buff *skb, struct nfpkt_par *apar)
 {
 	struct ipv6hdr _ip6h;
 	const struct ipv6hdr *ih;
 	u8 nexthdr;
 	__be16 frag_off;
-	int offset;
 
+	apar->ipv = 6;
 	ih = skb_header_pointer(skb, skb_network_offset(skb), sizeof(_ip6h), &_ip6h);
-	if (!ih) {
-		audit_log_format(ab, " truncated=1");
+	if (!ih)
 		return;
-	}
 
 	nexthdr = ih->nexthdr;
-	offset = ipv6_skip_exthdr(skb, skb_network_offset(skb) + sizeof(_ip6h),
-				  &nexthdr, &frag_off);
+	ipv6_skip_exthdr(skb, skb_network_offset(skb) + sizeof(_ip6h), &nexthdr, &frag_off);
 
-	audit_log_format(ab, " saddr=%pI6c daddr=%pI6c proto=%hhu",
-			 &ih->saddr, &ih->daddr, nexthdr);
-
-	if (offset)
-		audit_proto(ab, skb, nexthdr, offset);
+	apar->saddr = &ih->saddr;
+	apar->daddr = &ih->daddr;
+	apar->proto = nexthdr;
 }
 
 static unsigned int
 audit_tg(struct sk_buff *skb, const struct xt_action_param *par)
 {
-	const struct xt_audit_info *info = par->targinfo;
 	struct audit_buffer *ab;
+	struct nfpkt_par apar = {
+		-1, NULL, NULL, -1,
+	};
 
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
+	audit_log_format(ab, " mark=%#x", skb->mark ?: -1);
 
 	if (skb->dev && skb->dev->type == ARPHRD_ETHER) {
-		audit_log_format(ab, " smac=%pM dmac=%pM macproto=0x%04x",
-				 eth_hdr(skb)->h_source, eth_hdr(skb)->h_dest,
-				 ntohs(eth_hdr(skb)->h_proto));
-
 		if (par->family == NFPROTO_BRIDGE) {
 			switch (eth_hdr(skb)->h_proto) {
 			case htons(ETH_P_IP):
-				audit_ip4(ab, skb);
+				audit_ip4(ab, skb, &apar);
 				break;
 
 			case htons(ETH_P_IPV6):
-				audit_ip6(ab, skb);
+				audit_ip6(ab, skb, &apar);
 				break;
 			}
 		}
 	}
-
+	if (apar.ipv == -1)
 	switch (par->family) {
 	case NFPROTO_IPV4:
-		audit_ip4(ab, skb);
+		audit_ip4(ab, skb, &apar);
 		break;
 
 	case NFPROTO_IPV6:
-		audit_ip6(ab, skb);
+		audit_ip6(ab, skb, &apar);
 		break;
 	}
 
-#ifdef CONFIG_NETWORK_SECMARK
-	if (skb->secmark)
-		audit_log_secctx(ab, skb->secmark);
-#endif
+	switch (apar.ipv) {
+	case 4:
+		audit_log_format(ab, " saddr=%pI4 daddr=%pI4 proto=%hhu",
+			 apar.saddr, apar.daddr, apar.proto);
+		break;
+	case 6:
+		audit_log_format(ab, " saddr=%pI6c daddr=%pI6c proto=%hhu",
+			 apar.saddr, apar.daddr, apar.proto);
+		break;
+	default:
+		audit_log_format(ab, " saddr=? daddr=? proto=-1");
+	}
 
 	audit_log_end(ab);
 
-- 
1.7.1

