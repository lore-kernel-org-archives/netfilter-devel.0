Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFADDC4708D
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 May 2021 10:30:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4D1F6139A
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 May 2021 10:30:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236381AbhE1Kb4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 28 May 2021 06:31:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236200AbhE1Kbz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 May 2021 06:31:55 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAE4EC061574
        for <netfilter-devel@vger.kernel.org>; Fri, 28 May 2021 03:30:20 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lmZkx-00007E-9V; Fri, 28 May 2021 12:30:19 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 1/6] netfilter: x_tables: reduce xt_action_param by 8 byte
Date:   Fri, 28 May 2021 12:30:03 +0200
Message-Id: <20210528103008.17425-2-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210528103008.17425-1-fw@strlen.de>
References: <20210528103008.17425-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The fragment offset in ipv4/ipv6 is a 16bit field, so use
u16 instead of unsigned int.

On 64bit: 40 bytes to 32 bytes. By extension this also reduces
nft_pktinfo (56 to 48 byte).

Signed-off-by: Florian Westphal <fw@strlen.de>
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
2.26.3

