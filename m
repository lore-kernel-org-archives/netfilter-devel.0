Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3A67C433FE
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 May 2022 01:26:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbiEZB0F (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 May 2022 21:26:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbiEZB0E (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 May 2022 21:26:04 -0400
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.228])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7D2C76EC4F
        for <netfilter-devel@vger.kernel.org>; Wed, 25 May 2022 18:26:03 -0700 (PDT)
HMM_SOURCE_IP: 172.18.0.218:58134.1258804910
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-101.229.165.111 (unknown [172.18.0.218])
        by chinatelecom.cn (HERMES) with SMTP id 7EB45280138;
        Thu, 26 May 2022 09:26:01 +0800 (CST)
X-189-SAVE-TO-SEND: +wenxu@chinatelecom.cn
Received: from  ([172.18.0.218])
        by app0025 with ESMTP id 57db7dd086b844b8abe54ce583387c5b for pablo@netfilter.org;
        Thu, 26 May 2022 09:26:02 CST
X-Transaction-ID: 57db7dd086b844b8abe54ce583387c5b
X-Real-From: wenxu@chinatelecom.cn
X-Receive-IP: 172.18.0.218
X-MEDUSA-Status: 0
Sender: wenxu@chinatelecom.cn
From:   wenxu@chinatelecom.cn
To:     pablo@netfilter.org, sven.auhagen@voleatech.de
Cc:     netfilter-devel@vger.kernel.org, wenxu@chinatelecom.cn
Subject: [PATCH nf-next 2/2] netfilter: flowtable: fix nft_flow_route use saddr for nat case
Date:   Wed, 25 May 2022 21:25:46 -0400
Message-Id: <1653528346-5266-2-git-send-email-wenxu@chinatelecom.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1653528346-5266-1-git-send-email-wenxu@chinatelecom.cn>
References: <1653528346-5266-1-git-send-email-wenxu@chinatelecom.cn>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@chinatelecom.cn>

For snat and dnat case the saddr should get from reverse tuple.

Fixes: 3412e1641828 (netfilter: flowtable: nft_flow_route use more data for reverse route)
Signed-off-by: wenxu <wenxu@chinatelecom.cn>
---
 net/netfilter/nft_flow_offload.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 20e5f37..a25c88b 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -232,7 +232,7 @@ static int nft_flow_route(const struct nft_pktinfo *pkt,
 	switch (nft_pf(pkt)) {
 	case NFPROTO_IPV4:
 		fl.u.ip4.daddr = ct->tuplehash[dir].tuple.src.u3.ip;
-		fl.u.ip4.saddr = ct->tuplehash[dir].tuple.dst.u3.ip;
+		fl.u.ip4.saddr = ct->tuplehash[!dir].tuple.src.u3.ip;
 		fl.u.ip4.flowi4_oif = nft_in(pkt)->ifindex;
 		fl.u.ip4.flowi4_iif = this_dst->dev->ifindex;
 		fl.u.ip4.flowi4_tos = RT_TOS(ip_hdr(pkt->skb)->tos);
@@ -241,7 +241,7 @@ static int nft_flow_route(const struct nft_pktinfo *pkt,
 		break;
 	case NFPROTO_IPV6:
 		fl.u.ip6.daddr = ct->tuplehash[dir].tuple.src.u3.in6;
-		fl.u.ip6.saddr = ct->tuplehash[dir].tuple.dst.u3.in6;
+		fl.u.ip6.saddr = ct->tuplehash[!dir].tuple.src.u3.in6;
 		fl.u.ip6.flowi6_oif = nft_in(pkt)->ifindex;
 		fl.u.ip6.flowi6_iif = this_dst->dev->ifindex;
 		fl.u.ip6.flowlabel = ip6_flowinfo(ipv6_hdr(pkt->skb));
-- 
1.8.3.1

