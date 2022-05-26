Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A028C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 May 2022 01:26:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232124AbiEZB0D (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 May 2022 21:26:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbiEZB0C (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 May 2022 21:26:02 -0400
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.228])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 048C96EC4F
        for <netfilter-devel@vger.kernel.org>; Wed, 25 May 2022 18:26:01 -0700 (PDT)
HMM_SOURCE_IP: 172.18.0.218:58134.1258804910
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-101.229.165.111 (unknown [172.18.0.218])
        by chinatelecom.cn (HERMES) with SMTP id 8635D28012E;
        Thu, 26 May 2022 09:25:58 +0800 (CST)
X-189-SAVE-TO-SEND: +wenxu@chinatelecom.cn
Received: from  ([172.18.0.218])
        by app0025 with ESMTP id a35c366cd14944749a77384eca4a7d54 for pablo@netfilter.org;
        Thu, 26 May 2022 09:25:59 CST
X-Transaction-ID: a35c366cd14944749a77384eca4a7d54
X-Real-From: wenxu@chinatelecom.cn
X-Receive-IP: 172.18.0.218
X-MEDUSA-Status: 0
Sender: wenxu@chinatelecom.cn
From:   wenxu@chinatelecom.cn
To:     pablo@netfilter.org, sven.auhagen@voleatech.de
Cc:     netfilter-devel@vger.kernel.org, wenxu@chinatelecom.cn
Subject: [PATCH nf-next 1/2] netfilter: flowtable: fix nft_flow_route miss FLOWI_FLAG_ANYSRC flag
Date:   Wed, 25 May 2022 21:25:45 -0400
Message-Id: <1653528346-5266-1-git-send-email-wenxu@chinatelecom.cn>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@chinatelecom.cn>

The nf_flow_tabel get route through ip_route_output_key.
When the saddr is not local one, the FLOWI_FLAG_ANYSRC
flag should be setten. Without this flag, the route lookup
for other_dst will failed.

Fixes: 3412e1641828 (netfilter: flowtable: nft_flow_route use more data for reverse route)
Signed-off-by: wenxu <wenxu@chinatelecom.cn>
---
 net/netfilter/nft_flow_offload.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index a16cf47..20e5f37 100644
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
1.8.3.1

