Return-Path: <SRS0=aMTL=TF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80B13C004C9
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 May 2019 12:15:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 554FC2082F
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 May 2019 12:15:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727327AbfEEMP5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 May 2019 08:15:57 -0400
Received: from ja.ssi.bg ([178.16.129.10]:56756 "EHLO ja.ssi.bg"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726524AbfEEMP5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 May 2019 08:15:57 -0400
Received: from ja.home.ssi.bg (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id x45CFiQS016496;
        Sun, 5 May 2019 15:15:44 +0300
Received: (from root@localhost)
        by ja.home.ssi.bg (8.15.2/8.15.2/Submit) id x45CFiXE016495;
        Sun, 5 May 2019 15:15:44 +0300
From:   Julian Anastasov <ja@ssi.bg>
To:     Simon Horman <horms@verge.net.au>
Cc:     lvs-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Jacky Hu <hengqing.hu@gmail.com>,
        jacky.hu@walmart.com, jason.niesz@walmart.com
Subject: [PATCHv2 net-next 3/3] ipvs: strip udp tunnel headers from icmp errors
Date:   Sun,  5 May 2019 15:14:40 +0300
Message-Id: <20190505121440.16389-4-ja@ssi.bg>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190505121440.16389-1-ja@ssi.bg>
References: <20190505121440.16389-1-ja@ssi.bg>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Recognize UDP tunnels in received ICMP errors and
properly strip the tunnel headers. GUE is what we
have for now.

Signed-off-by: Julian Anastasov <ja@ssi.bg>
---
 net/netfilter/ipvs/ip_vs_core.c | 60 +++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 4447ee512b88..d1d7b2483fd7 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -39,6 +39,7 @@
 #include <net/tcp.h>
 #include <net/udp.h>
 #include <net/icmp.h>                   /* for icmp_send */
+#include <net/gue.h>
 #include <net/route.h>
 #include <net/ip6_checksum.h>
 #include <net/netns/generic.h>		/* net_generic() */
@@ -1579,6 +1580,41 @@ ip_vs_try_to_schedule(struct netns_ipvs *ipvs, int af, struct sk_buff *skb,
 	return 1;
 }
 
+/* Check the UDP tunnel and return its header length */
+static int ipvs_udp_decap(struct netns_ipvs *ipvs, struct sk_buff *skb,
+			  unsigned int offset, __u16 af,
+			  const union nf_inet_addr *daddr, __u8 *proto)
+{
+	struct udphdr _udph, *udph;
+	struct ip_vs_dest *dest;
+
+	udph = skb_header_pointer(skb, offset, sizeof(_udph), &_udph);
+	if (!udph)
+		goto unk;
+	offset += sizeof(struct udphdr);
+	dest = ip_vs_find_tunnel(ipvs, af, daddr, udph->dest);
+	if (!dest)
+		goto unk;
+	if (dest->tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GUE) {
+		struct guehdr _gueh, *gueh;
+
+		gueh = skb_header_pointer(skb, offset, sizeof(_gueh), &_gueh);
+		if (!gueh)
+			goto unk;
+		if (gueh->control != 0 || gueh->version != 0)
+			goto unk;
+		/* Later we can support also IPPROTO_IPV6 */
+		if (gueh->proto_ctype != IPPROTO_IPIP)
+			goto unk;
+		*proto = gueh->proto_ctype;
+		return sizeof(struct udphdr) + sizeof(struct guehdr) +
+		       (gueh->hlen << 2);
+	}
+
+unk:
+	return 0;
+}
+
 /*
  *	Handle ICMP messages in the outside-to-inside direction (incoming).
  *	Find any that might be relevant, check against existing connections,
@@ -1658,6 +1694,30 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
 		if (cih == NULL)
 			return NF_ACCEPT; /* The packet looks wrong, ignore */
 		ipip = true;
+	} else if (cih->protocol == IPPROTO_UDP &&	/* Can be UDP encap */
+		   /* Error for our tunnel must arrive at LOCAL_IN */
+		   (skb_rtable(skb)->rt_flags & RTCF_LOCAL)) {
+		__u8 iproto;
+		int ulen;
+
+		/* Non-first fragment has no UDP header */
+		if (unlikely(cih->frag_off & htons(IP_OFFSET)))
+			return NF_ACCEPT;
+		offset2 = offset + cih->ihl * 4;
+		ulen = ipvs_udp_decap(ipvs, skb, offset2, AF_INET, raddr,
+				      &iproto);
+		if (ulen > 0) {
+			/* Skip IP and UDP tunnel headers */
+			offset = offset2 + ulen;
+			/* Now we should be at the original IP header */
+			cih = skb_header_pointer(skb, offset, sizeof(_ciph),
+						 &_ciph);
+			if (cih && cih->version == 4 && cih->ihl >= 5 &&
+			    iproto == IPPROTO_IPIP)
+				ipip = true;
+			else
+				return NF_ACCEPT;
+		}
 	}
 
 	pd = ip_vs_proto_data_get(ipvs, cih->protocol);
-- 
2.17.1

