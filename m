Return-Path: <SRS0=U5wk=2I=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4090C43603
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Dec 2019 11:06:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A60FA21D7D
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Dec 2019 11:06:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbfLRLGD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Dec 2019 06:06:03 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:36004 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726682AbfLRLGD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Dec 2019 06:06:03 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ihX9V-00078o-P7; Wed, 18 Dec 2019 12:06:01 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 8/9] netfilter: nft_meta: place rtclassid handling in a helper
Date:   Wed, 18 Dec 2019 12:05:20 +0100
Message-Id: <20191218110521.14048-9-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191218110521.14048-1-fw@strlen.de>
References: <20191218110521.14048-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

skb_dst is an inline helper with a WARN_ON(), so this is a bit more code
than it looks like.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_meta.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index ac6fc95387dc..fb1a571db924 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -273,6 +273,20 @@ static noinline u32 nft_prandom_u32(void)
 	return prandom_u32_state(state);
 }
 
+#ifdef CONFIG_IP_ROUTE_CLASSID
+static noinline bool
+nft_meta_get_eval_rtclassid(const struct sk_buff *skb, u32 *dest)
+{
+	const struct dst_entry *dst = skb_dst(skb);
+
+	if (!dst)
+		return false;
+
+	*dest = dst->tclassid;
+	return true;
+}
+#endif
+
 void nft_meta_get_eval(const struct nft_expr *expr,
 		       struct nft_regs *regs,
 		       const struct nft_pktinfo *pkt)
@@ -319,14 +333,10 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 			goto err;
 		break;
 #ifdef CONFIG_IP_ROUTE_CLASSID
-	case NFT_META_RTCLASSID: {
-		const struct dst_entry *dst = skb_dst(skb);
-
-		if (dst == NULL)
+	case NFT_META_RTCLASSID:
+		if (!nft_meta_get_eval_rtclassid(skb, dest))
 			goto err;
-		*dest = dst->tclassid;
 		break;
-	}
 #endif
 #ifdef CONFIG_NETWORK_SECMARK
 	case NFT_META_SECMARK:
-- 
2.24.1

