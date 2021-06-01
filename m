Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA87BC47097
	for <netfilter-devel@archiver.kernel.org>; Tue,  1 Jun 2021 22:06:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C86B3613BD
	for <netfilter-devel@archiver.kernel.org>; Tue,  1 Jun 2021 22:06:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234911AbhFAWI3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 1 Jun 2021 18:08:29 -0400
Received: from mail.netfilter.org ([217.70.188.207]:39546 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234947AbhFAWIV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Jun 2021 18:08:21 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 50371641CC;
        Wed,  2 Jun 2021 00:05:32 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 09/16] netfilter: x_tables: reduce xt_action_param by 8 byte
Date:   Wed,  2 Jun 2021 00:06:22 +0200
Message-Id: <20210601220629.18307-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210601220629.18307-1-pablo@netfilter.org>
References: <20210601220629.18307-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

The fragment offset in ipv4/ipv6 is a 16bit field, so use
u16 instead of unsigned int.

On 64bit: 40 bytes to 32 bytes. By extension this also reduces
nft_pktinfo (56 to 48 byte).

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/x_tables.h | 2 +-
 net/ipv6/netfilter/ip6_tables.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 07c6ad8f2a02..28d7027cd460 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -36,8 +36,8 @@ struct xt_action_param {
 		const void *matchinfo, *targinfo;
 	};
 	const struct nf_hook_state *state;
-	int fragoff;
 	unsigned int thoff;
+	u16 fragoff;
 	bool hotdrop;
 };
 
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index e810a23baf99..de2cf3943b91 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -51,7 +51,7 @@ ip6_packet_match(const struct sk_buff *skb,
 		 const char *outdev,
 		 const struct ip6t_ip6 *ip6info,
 		 unsigned int *protoff,
-		 int *fragoff, bool *hotdrop)
+		 u16 *fragoff, bool *hotdrop)
 {
 	unsigned long ret;
 	const struct ipv6hdr *ipv6 = ipv6_hdr(skb);
-- 
2.30.2

