Return-Path: <SRS0=aW9c=VA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F3D7C0650E
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jul 2019 18:39:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 111182189E
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jul 2019 18:39:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbfGCSjk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Jul 2019 14:39:40 -0400
Received: from ja.ssi.bg ([178.16.129.10]:43466 "EHLO ja.ssi.bg"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726430AbfGCSjk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Jul 2019 14:39:40 -0400
Received: from ja.home.ssi.bg (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id x63IcbL4004594;
        Wed, 3 Jul 2019 21:38:37 +0300
Received: (from root@localhost)
        by ja.home.ssi.bg (8.15.2/8.15.2/Submit) id x63IcaMv004593;
        Wed, 3 Jul 2019 21:38:36 +0300
From:   Julian Anastasov <ja@ssi.bg>
To:     Simon Horman <horms@verge.net.au>
Cc:     lvs-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org,
        Vadim Fedorenko <vfedorenko@yandex-team.ru>
Subject: [PATCHv2 net-next] ipvs: strip gre tunnel headers from icmp errors
Date:   Wed,  3 Jul 2019 21:38:09 +0300
Message-Id: <20190703183809.4554-1-ja@ssi.bg>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Recognize GRE tunnels in received ICMP errors and
properly strip the tunnel headers.

Signed-off-by: Julian Anastasov <ja@ssi.bg>
---
 net/netfilter/ipvs/ip_vs_core.c | 46 ++++++++++++++++++++++++++++++---
 1 file changed, 42 insertions(+), 4 deletions(-)

 Here is v2 in case it is needed, with net/gre.h included

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index e8651fd621ef..dd4727a5d6ec 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -35,6 +35,7 @@
 #include <net/udp.h>
 #include <net/icmp.h>                   /* for icmp_send */
 #include <net/gue.h>
+#include <net/gre.h>
 #include <net/route.h>
 #include <net/ip6_checksum.h>
 #include <net/netns/generic.h>		/* net_generic() */
@@ -1610,6 +1611,38 @@ static int ipvs_udp_decap(struct netns_ipvs *ipvs, struct sk_buff *skb,
 	return 0;
 }
 
+/* Check the GRE tunnel and return its header length */
+static int ipvs_gre_decap(struct netns_ipvs *ipvs, struct sk_buff *skb,
+			  unsigned int offset, __u16 af,
+			  const union nf_inet_addr *daddr, __u8 *proto)
+{
+	struct gre_base_hdr _greh, *greh;
+	struct ip_vs_dest *dest;
+
+	greh = skb_header_pointer(skb, offset, sizeof(_greh), &_greh);
+	if (!greh)
+		goto unk;
+	dest = ip_vs_find_tunnel(ipvs, af, daddr, 0);
+	if (!dest)
+		goto unk;
+	if (dest->tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GRE) {
+		__be16 type;
+
+		/* Only support version 0 and C (csum) */
+		if ((greh->flags & ~GRE_CSUM) != 0)
+			goto unk;
+		type = greh->protocol;
+		/* Later we can support also IPPROTO_IPV6 */
+		if (type != htons(ETH_P_IP))
+			goto unk;
+		*proto = IPPROTO_IPIP;
+		return gre_calc_hlen(gre_flags_to_tnl_flags(greh->flags));
+	}
+
+unk:
+	return 0;
+}
+
 /*
  *	Handle ICMP messages in the outside-to-inside direction (incoming).
  *	Find any that might be relevant, check against existing connections,
@@ -1689,7 +1722,8 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
 		if (cih == NULL)
 			return NF_ACCEPT; /* The packet looks wrong, ignore */
 		ipip = true;
-	} else if (cih->protocol == IPPROTO_UDP &&	/* Can be UDP encap */
+	} else if ((cih->protocol == IPPROTO_UDP ||	/* Can be UDP encap */
+		    cih->protocol == IPPROTO_GRE) &&	/* Can be GRE encap */
 		   /* Error for our tunnel must arrive at LOCAL_IN */
 		   (skb_rtable(skb)->rt_flags & RTCF_LOCAL)) {
 		__u8 iproto;
@@ -1699,10 +1733,14 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
 		if (unlikely(cih->frag_off & htons(IP_OFFSET)))
 			return NF_ACCEPT;
 		offset2 = offset + cih->ihl * 4;
-		ulen = ipvs_udp_decap(ipvs, skb, offset2, AF_INET, raddr,
-				      &iproto);
+		if (cih->protocol == IPPROTO_UDP)
+			ulen = ipvs_udp_decap(ipvs, skb, offset2, AF_INET,
+					      raddr, &iproto);
+		else
+			ulen = ipvs_gre_decap(ipvs, skb, offset2, AF_INET,
+					      raddr, &iproto);
 		if (ulen > 0) {
-			/* Skip IP and UDP tunnel headers */
+			/* Skip IP and UDP/GRE tunnel headers */
 			offset = offset2 + ulen;
 			/* Now we should be at the original IP header */
 			cih = skb_header_pointer(skb, offset, sizeof(_ciph),
-- 
2.21.0

