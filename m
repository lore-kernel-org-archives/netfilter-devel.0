Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB2A0C4332F
	for <netfilter-devel@archiver.kernel.org>; Tue, 31 May 2022 22:03:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348298AbiEaWDN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 31 May 2022 18:03:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348297AbiEaWDK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 31 May 2022 18:03:10 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BEA139B189;
        Tue, 31 May 2022 15:03:08 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 4/5] netfilter: flowtable: fix missing FLOWI_FLAG_ANYSRC flag
Date:   Tue, 31 May 2022 23:58:38 +0200
Message-Id: <20220531215839.84765-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220531215839.84765-1-pablo@netfilter.org>
References: <20220531215839.84765-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@chinatelecom.cn>

The nf_flow_table gets route through ip_route_output_key. If the saddr
is not local one, then FLOWI_FLAG_ANYSRC flag should be set. Without
this flag, the route lookup for other_dst will fail.

Fixes: 3412e1641828 (netfilter: flowtable: nft_flow_route use more data for reverse route)
Signed-off-by: wenxu <wenxu@chinatelecom.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_flow_offload.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index a16cf47199b7..20e5f372dd76 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -237,6 +237,7 @@ static int nft_flow_route(const struct nft_pktinfo *pkt,
 		fl.u.ip4.flowi4_iif = this_dst->dev->ifindex;
 		fl.u.ip4.flowi4_tos = RT_TOS(ip_hdr(pkt->skb)->tos);
 		fl.u.ip4.flowi4_mark = pkt->skb->mark;
+		fl.u.ip4.flowi4_flags = FLOWI_FLAG_ANYSRC;
 		break;
 	case NFPROTO_IPV6:
 		fl.u.ip6.daddr = ct->tuplehash[dir].tuple.src.u3.in6;
@@ -245,6 +246,7 @@ static int nft_flow_route(const struct nft_pktinfo *pkt,
 		fl.u.ip6.flowi6_iif = this_dst->dev->ifindex;
 		fl.u.ip6.flowlabel = ip6_flowinfo(ipv6_hdr(pkt->skb));
 		fl.u.ip6.flowi6_mark = pkt->skb->mark;
+		fl.u.ip6.flowi6_flags = FLOWI_FLAG_ANYSRC;
 		break;
 	}
 
-- 
2.30.2

