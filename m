Return-Path: <SRS0=8p/T=ZF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74A84C43331
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Nov 2019 02:10:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4AB45206B6
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Nov 2019 02:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573611035;
	bh=Xly+WwSRVQd4TwyrC8/aeq8ryWsEK+3hHMKmq1lem7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=UCcSR6TSklpFzm8KvAr1j2QSMB2E3qM3bUCUCuRmVUDvHIG9STGA0ReTKlo6NSjks
	 9RE/MHYu+XJngSsMbtojBhUUTj5mICxnk4302wHhQfa2iz2KsZYbExSpRYyvLqFvca
	 8OKBFg4mgAbyweCcwcSe/XRtmdXmPoWiyLOyg+NQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729120AbfKMCK3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Nov 2019 21:10:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:53622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730233AbfKMB7O (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Nov 2019 20:59:14 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78050222CF;
        Wed, 13 Nov 2019 01:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610354;
        bh=Xly+WwSRVQd4TwyrC8/aeq8ryWsEK+3hHMKmq1lem7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BaMbxQUS+aWo/ETNqLXoUxieVBBQ9w97AafH120BPcI0ILccwHRMLvXqRZRcpbdY5
         KxuLcaHBAPSsvPCm9uu3rGbtCX6RxFU/tVONytOO4k6Vy4LJeLpxuk4zphHiAN8IRT
         RBRlrsD6VrJzQWF7G2H4+Pd2GyUxPD6lZMkgRuZw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 105/115] netfilter: nft_compat: do not dump private area
Date:   Tue, 12 Nov 2019 20:56:12 -0500
Message-Id: <20191113015622.11592-105-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015622.11592-1-sashal@kernel.org>
References: <20191113015622.11592-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit d701d8117200399d85e63a737d2e4e897932f3b6 ]

Zero pad private area, otherwise we expose private kernel pointer to
userspace. This patch also zeroes the tail area after the ->matchsize
and ->targetsize that results from XT_ALIGN().

Fixes: 0ca743a55991 ("netfilter: nf_tables: add compatibility layer for x_tables")
Reported-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_compat.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 7344ec7fff2a7..8281656808aee 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -291,6 +291,24 @@ nft_target_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr)
 		module_put(me);
 }
 
+static int nft_extension_dump_info(struct sk_buff *skb, int attr,
+				   const void *info,
+				   unsigned int size, unsigned int user_size)
+{
+	unsigned int info_size, aligned_size = XT_ALIGN(size);
+	struct nlattr *nla;
+
+	nla = nla_reserve(skb, attr, aligned_size);
+	if (!nla)
+		return -1;
+
+	info_size = user_size ? : size;
+	memcpy(nla_data(nla), info, info_size);
+	memset(nla_data(nla) + info_size, 0, aligned_size - info_size);
+
+	return 0;
+}
+
 static int nft_target_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
 	const struct xt_target *target = expr->ops->data;
@@ -298,7 +316,8 @@ static int nft_target_dump(struct sk_buff *skb, const struct nft_expr *expr)
 
 	if (nla_put_string(skb, NFTA_TARGET_NAME, target->name) ||
 	    nla_put_be32(skb, NFTA_TARGET_REV, htonl(target->revision)) ||
-	    nla_put(skb, NFTA_TARGET_INFO, XT_ALIGN(target->targetsize), info))
+	    nft_extension_dump_info(skb, NFTA_TARGET_INFO, info,
+				    target->targetsize, target->usersize))
 		goto nla_put_failure;
 
 	return 0;
@@ -534,7 +553,8 @@ static int __nft_match_dump(struct sk_buff *skb, const struct nft_expr *expr,
 
 	if (nla_put_string(skb, NFTA_MATCH_NAME, match->name) ||
 	    nla_put_be32(skb, NFTA_MATCH_REV, htonl(match->revision)) ||
-	    nla_put(skb, NFTA_MATCH_INFO, XT_ALIGN(match->matchsize), info))
+	    nft_extension_dump_info(skb, NFTA_MATCH_INFO, info,
+				    match->matchsize, match->usersize))
 		goto nla_put_failure;
 
 	return 0;
-- 
2.20.1

