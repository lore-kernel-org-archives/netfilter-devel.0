Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDD95C47096
	for <netfilter-devel@archiver.kernel.org>; Tue,  1 Jun 2021 22:06:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A926761396
	for <netfilter-devel@archiver.kernel.org>; Tue,  1 Jun 2021 22:06:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234995AbhFAWI0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 1 Jun 2021 18:08:26 -0400
Received: from mail.netfilter.org ([217.70.188.207]:39572 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234955AbhFAWIW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Jun 2021 18:08:22 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 019C8641CD;
        Wed,  2 Jun 2021 00:05:32 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 11/16] netfilter: nf_tables: add and use nft_sk helper
Date:   Wed,  2 Jun 2021 00:06:24 +0200
Message-Id: <20210601220629.18307-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210601220629.18307-1-pablo@netfilter.org>
References: <20210601220629.18307-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

This allows to change storage placement later on without changing readers.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h    | 5 +++++
 net/ipv4/netfilter/nft_reject_ipv4.c | 2 +-
 net/ipv6/netfilter/nft_reject_ipv6.c | 2 +-
 net/netfilter/nft_reject_inet.c      | 4 ++--
 4 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 27eeb613bb4e..af1228f58e5a 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -29,6 +29,11 @@ struct nft_pktinfo {
 	struct xt_action_param		xt;
 };
 
+static inline struct sock *nft_sk(const struct nft_pktinfo *pkt)
+{
+	return pkt->xt.state->sk;
+}
+
 static inline struct net *nft_net(const struct nft_pktinfo *pkt)
 {
 	return pkt->xt.state->net;
diff --git a/net/ipv4/netfilter/nft_reject_ipv4.c b/net/ipv4/netfilter/nft_reject_ipv4.c
index ff437e4ed6db..55fc23a8f7a7 100644
--- a/net/ipv4/netfilter/nft_reject_ipv4.c
+++ b/net/ipv4/netfilter/nft_reject_ipv4.c
@@ -27,7 +27,7 @@ static void nft_reject_ipv4_eval(const struct nft_expr *expr,
 		nf_send_unreach(pkt->skb, priv->icmp_code, nft_hook(pkt));
 		break;
 	case NFT_REJECT_TCP_RST:
-		nf_send_reset(nft_net(pkt), pkt->xt.state->sk, pkt->skb,
+		nf_send_reset(nft_net(pkt), nft_sk(pkt), pkt->skb,
 			      nft_hook(pkt));
 		break;
 	default:
diff --git a/net/ipv6/netfilter/nft_reject_ipv6.c b/net/ipv6/netfilter/nft_reject_ipv6.c
index 7969d1f3018d..ed69c768797e 100644
--- a/net/ipv6/netfilter/nft_reject_ipv6.c
+++ b/net/ipv6/netfilter/nft_reject_ipv6.c
@@ -28,7 +28,7 @@ static void nft_reject_ipv6_eval(const struct nft_expr *expr,
 				 nft_hook(pkt));
 		break;
 	case NFT_REJECT_TCP_RST:
-		nf_send_reset6(nft_net(pkt), pkt->xt.state->sk, pkt->skb,
+		nf_send_reset6(nft_net(pkt), nft_sk(pkt), pkt->skb,
 			       nft_hook(pkt));
 		break;
 	default:
diff --git a/net/netfilter/nft_reject_inet.c b/net/netfilter/nft_reject_inet.c
index 95090186ee90..554caf967baa 100644
--- a/net/netfilter/nft_reject_inet.c
+++ b/net/netfilter/nft_reject_inet.c
@@ -28,7 +28,7 @@ static void nft_reject_inet_eval(const struct nft_expr *expr,
 					nft_hook(pkt));
 			break;
 		case NFT_REJECT_TCP_RST:
-			nf_send_reset(nft_net(pkt), pkt->xt.state->sk,
+			nf_send_reset(nft_net(pkt), nft_sk(pkt),
 				      pkt->skb, nft_hook(pkt));
 			break;
 		case NFT_REJECT_ICMPX_UNREACH:
@@ -45,7 +45,7 @@ static void nft_reject_inet_eval(const struct nft_expr *expr,
 					 priv->icmp_code, nft_hook(pkt));
 			break;
 		case NFT_REJECT_TCP_RST:
-			nf_send_reset6(nft_net(pkt), pkt->xt.state->sk,
+			nf_send_reset6(nft_net(pkt), nft_sk(pkt),
 				       pkt->skb, nft_hook(pkt));
 			break;
 		case NFT_REJECT_ICMPX_UNREACH:
-- 
2.30.2

