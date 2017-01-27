From: Richard Guy Briggs <rgb@redhat.com>
Subject: [RFC PATCH] audit: normalize NETFILTER_PKT
Date: Fri, 27 Jan 2017 08:11:06 -0500
Message-ID: <e3af1eaaf566af375dbc79abd4535e86f2fc8a6d.1485522479.git.rgb@redhat.com>
Cc: Richard Guy Briggs <rgb@redhat.com>,
        Thomas Graf <tgraf@infradead.org>,
        Eric Paris <eparis@redhat.com>, Paul Moore <pmoore@redhat.com>,
        Steve Grubb <sgrubb@redhat.com>
To: Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>, linux-audit@redhat.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35412 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754832AbdA0NLp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 27 Jan 2017 08:11:45 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eliminate flipping in and out of message fields.

https://github.com/linux-audit/audit-kernel/issues/11

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 net/netfilter/xt_AUDIT.c |   92 +++++++++++++++++++++++++++++++++-------------
 1 files changed, 66 insertions(+), 26 deletions(-)

diff --git a/net/netfilter/xt_AUDIT.c b/net/netfilter/xt_AUDIT.c
index 4973cbd..8089ec2 100644
--- a/net/netfilter/xt_AUDIT.c
+++ b/net/netfilter/xt_AUDIT.c
@@ -31,24 +31,41 @@ MODULE_ALIAS("ip6t_AUDIT");
 MODULE_ALIAS("ebt_AUDIT");
 MODULE_ALIAS("arpt_AUDIT");
 
+struct nfpkt_par {
+	int ipv;
+	int iptrunc;
+	const void *saddr;
+	const void *daddr;
+	u16 ipid;
+	u8 proto;
+	u8 frag;
+	int ptrunc;
+	u16 sport;
+	u16 dport;
+	u8 icmpt;
+	u8 icmpc;
+};
+
 static void audit_proto(struct audit_buffer *ab, struct sk_buff *skb,
-			unsigned int proto, unsigned int offset)
+			unsigned int proto, unsigned int offset, struct nfpkt_par *apar)
 {
 	switch (proto) {
 	case IPPROTO_TCP:
 	case IPPROTO_UDP:
-	case IPPROTO_UDPLITE: {
+	case IPPROTO_UDPLITE:
+	case IPPROTO_DCCP:
+	case IPPROTO_SCTP: {
 		const __be16 *pptr;
 		__be16 _ports[2];
 
 		pptr = skb_header_pointer(skb, offset, sizeof(_ports), _ports);
 		if (pptr == NULL) {
-			audit_log_format(ab, " truncated=1");
+			apar->ptrunc = 1;
 			return;
 		}
+		apar->sport = ntohs(pptr[0]);
+		apar->dport = ntohs(pptr[1]);
 
-		audit_log_format(ab, " sport=%hu dport=%hu",
-				 ntohs(pptr[0]), ntohs(pptr[1]));
 		}
 		break;
 
@@ -59,41 +76,43 @@ static void audit_proto(struct audit_buffer *ab, struct sk_buff *skb,
 
 		iptr = skb_header_pointer(skb, offset, sizeof(_ih), &_ih);
 		if (iptr == NULL) {
-			audit_log_format(ab, " truncated=1");
+			apar->ptrunc = 1;
 			return;
 		}
-
-		audit_log_format(ab, " icmptype=%hhu icmpcode=%hhu",
-				 iptr[0], iptr[1]);
+		apar->icmpt = iptr[0];
+		apar->icmpc = iptr[1];
 
 		}
 		break;
 	}
 }
 
-static void audit_ip4(struct audit_buffer *ab, struct sk_buff *skb)
+static void audit_ip4(struct audit_buffer *ab, struct sk_buff *skb, struct nfpkt_par *apar)
 {
 	struct iphdr _iph;
 	const struct iphdr *ih;
 
+	apar->ipv = 4;
 	ih = skb_header_pointer(skb, 0, sizeof(_iph), &_iph);
 	if (!ih) {
-		audit_log_format(ab, " truncated=1");
+		apar->iptrunc = 1;
 		return;
 	}
 
-	audit_log_format(ab, " saddr=%pI4 daddr=%pI4 ipid=%hu proto=%hhu",
-		&ih->saddr, &ih->daddr, ntohs(ih->id), ih->protocol);
+	apar->saddr = &ih->saddr;
+	apar->daddr = &ih->daddr;
+	apar->ipid = ntohs(ih->id);
+	apar->proto = ih->protocol;
 
 	if (ntohs(ih->frag_off) & IP_OFFSET) {
-		audit_log_format(ab, " frag=1");
+		apar->frag = 1;
 		return;
 	}
 
-	audit_proto(ab, skb, ih->protocol, ih->ihl * 4);
+	audit_proto(ab, skb, ih->protocol, ih->ihl * 4, apar);
 }
 
-static void audit_ip6(struct audit_buffer *ab, struct sk_buff *skb)
+static void audit_ip6(struct audit_buffer *ab, struct sk_buff *skb, struct nfpkt_par *apar)
 {
 	struct ipv6hdr _ip6h;
 	const struct ipv6hdr *ih;
@@ -101,9 +120,10 @@ static void audit_ip6(struct audit_buffer *ab, struct sk_buff *skb)
 	__be16 frag_off;
 	int offset;
 
+	apar->ipv = 6;
 	ih = skb_header_pointer(skb, skb_network_offset(skb), sizeof(_ip6h), &_ip6h);
 	if (!ih) {
-		audit_log_format(ab, " truncated=1");
+		apar->iptrunc = 1;
 		return;
 	}
 
@@ -111,11 +131,12 @@ static void audit_ip6(struct audit_buffer *ab, struct sk_buff *skb)
 	offset = ipv6_skip_exthdr(skb, skb_network_offset(skb) + sizeof(_ip6h),
 				  &nexthdr, &frag_off);
 
-	audit_log_format(ab, " saddr=%pI6c daddr=%pI6c proto=%hhu",
-			 &ih->saddr, &ih->daddr, nexthdr);
+	apar->saddr = &ih->saddr;
+	apar->daddr = &ih->daddr;
+	apar->proto = nexthdr;
 
 	if (offset)
-		audit_proto(ab, skb, nexthdr, offset);
+		audit_proto(ab, skb, nexthdr, offset, apar);
 }
 
 static unsigned int
@@ -123,6 +144,9 @@ audit_tg(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct xt_audit_info *info = par->targinfo;
 	struct audit_buffer *ab;
+	struct nfpkt_par apar = {
+		-1, -1, NULL, NULL, -1, -1, -1, -1, -1, -1, -1, -1
+	};
 
 	if (audit_enabled == 0)
 		goto errout;
@@ -136,8 +160,7 @@ audit_tg(struct sk_buff *skb, const struct xt_action_param *par)
 			 par->in ? par->in->name : "?",
 			 par->out ? par->out->name : "?");
 
-	if (skb->mark)
-		audit_log_format(ab, " mark=%#x", skb->mark);
+	audit_log_format(ab, " mark=%#x", skb->mark ?: -1);
 
 	if (skb->dev && skb->dev->type == ARPHRD_ETHER) {
 		audit_log_format(ab, " smac=%pM dmac=%pM macproto=0x%04x",
@@ -147,25 +170,42 @@ audit_tg(struct sk_buff *skb, const struct xt_action_param *par)
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
+	} else {
+		audit_log_format(ab, " smac=? dmac=? macproto=0xffff");
 	}
 
 	switch (par->family) {
 	case NFPROTO_IPV4:
-		audit_ip4(ab, skb);
+		audit_ip4(ab, skb, &apar);
 		break;
 
 	case NFPROTO_IPV6:
-		audit_ip6(ab, skb);
+		audit_ip6(ab, skb, &apar);
+		break;
+	}
+
+	switch (apar.ipv) {
+	case 4:
+		audit_log_format(ab, " trunc=%d saddr=%pI4 daddr=%pI4 ipid=%hu proto=%hhu frag=%d",
+			 apar.iptrunc, apar.saddr, apar.daddr, apar.ipid, apar.proto, apar.frag);
+		break;
+	case 6:
+		audit_log_format(ab, " trunc=%d saddr=%pI6c daddr=%pI6c ipid=-1 proto=%hhu frag=-1",
+			 apar.iptrunc, apar.saddr, apar.daddr, apar.proto);
 		break;
+	default:
+		audit_log_format(ab, " trunc=-1 saddr=? daddr=? ipid=-1 proto=-1 frag=-1");
 	}
+	audit_log_format(ab, " trunc=%d sport=%hu dport=%hu icmptype=%hhu icmpcode=%hhu",
+		apar.ptrunc, apar.sport, apar.dport, apar.icmpt, apar.icmpc);
 
 #ifdef CONFIG_NETWORK_SECMARK
 	if (skb->secmark)
-- 
1.7.1

