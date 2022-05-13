Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAC6AC4332F
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 May 2022 21:44:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384753AbiEMVoC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 13 May 2022 17:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384745AbiEMVnx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 May 2022 17:43:53 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9B1792ED6F;
        Fri, 13 May 2022 14:43:52 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com
Subject: [PATCH net-next 16/17] netfilter: flowtable: nft_flow_route use more data for reverse route
Date:   Fri, 13 May 2022 23:43:28 +0200
Message-Id: <20220513214329.1136459-17-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220513214329.1136459-1-pablo@netfilter.org>
References: <20220513214329.1136459-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Sven Auhagen <Sven.Auhagen@voleatech.de>

When creating a flow table entry, the reverse route is looked
up based on the current packet.
There can be scenarios where the user creates a custom ip rule
to route the traffic differently.
In order to support those scenarios, the lookup needs to add
more information based on the current packet.
The patch adds multiple new information to the route lookup.

Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_flow_offload.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 900d48c810a1..50991ab1e2d2 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -227,11 +227,19 @@ static int nft_flow_route(const struct nft_pktinfo *pkt,
 	switch (nft_pf(pkt)) {
 	case NFPROTO_IPV4:
 		fl.u.ip4.daddr = ct->tuplehash[dir].tuple.src.u3.ip;
+		fl.u.ip4.saddr = ct->tuplehash[dir].tuple.dst.u3.ip;
 		fl.u.ip4.flowi4_oif = nft_in(pkt)->ifindex;
+		fl.u.ip4.flowi4_iif = this_dst->dev->ifindex;
+		fl.u.ip4.flowi4_tos = RT_TOS(ip_hdr(pkt->skb)->tos);
+		fl.u.ip4.flowi4_mark = pkt->skb->mark;
 		break;
 	case NFPROTO_IPV6:
 		fl.u.ip6.daddr = ct->tuplehash[dir].tuple.src.u3.in6;
+		fl.u.ip6.saddr = ct->tuplehash[dir].tuple.dst.u3.in6;
 		fl.u.ip6.flowi6_oif = nft_in(pkt)->ifindex;
+		fl.u.ip6.flowi6_iif = this_dst->dev->ifindex;
+		fl.u.ip6.flowlabel = ip6_flowinfo(ipv6_hdr(pkt->skb));
+		fl.u.ip6.flowi6_mark = pkt->skb->mark;
 		break;
 	}
 
-- 
2.30.2

