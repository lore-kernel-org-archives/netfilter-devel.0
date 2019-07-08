Return-Path: <SRS0=pcH3=VF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35C7FC606AA
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Jul 2019 10:32:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1927620656
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Jul 2019 10:32:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730098AbfGHKcw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Jul 2019 06:32:52 -0400
Received: from mail.us.es ([193.147.175.20]:34310 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725869AbfGHKcv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Jul 2019 06:32:51 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 96C44BAE8D
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Jul 2019 12:32:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8881AA7BD6
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Jul 2019 12:32:48 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7DF701021B2; Mon,  8 Jul 2019 12:32:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 71822DA7B6;
        Mon,  8 Jul 2019 12:32:46 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 08 Jul 2019 12:32:46 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 408994265A2F;
        Mon,  8 Jul 2019 12:32:46 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 06/15] ipvs: strip gre tunnel headers from icmp errors
Date:   Mon,  8 Jul 2019 12:32:28 +0200
Message-Id: <20190708103237.28061-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190708103237.28061-1-pablo@netfilter.org>
References: <20190708103237.28061-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Julian Anastasov <ja@ssi.bg>

Recognize GRE tunnels in received ICMP errors and
properly strip the tunnel headers.

Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_core.c | 46 +++++++++++++++++++++++++++++++++++++----
 1 file changed, 42 insertions(+), 4 deletions(-)

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
2.11.0

