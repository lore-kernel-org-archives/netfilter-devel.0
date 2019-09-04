Return-Path: <SRS0=dC0K=W7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B206C41514
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Sep 2019 16:11:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F02B922CED
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Sep 2019 16:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1567613491;
	bh=au813PDI6FI9tO98w4fyc/QYGAA9QqrIDbR/WbIjSdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=TMM7GGPnohazOt4n3JGm/psNmzmnLUT6fINvA72UNe1KKwgUOsAfYHVgm041isLHB
	 Y2jX3U5qWQxMWbdcGrEMZPcYehvoG7tlXVvvDwknDgrHvtgUe93hck/EaYeNi2Zr9l
	 72MuE+3XYVx7dxyIQ5lmmxWrf6LAdZK1cwmATKI0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732722AbfIDQAa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Sep 2019 12:00:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:35372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732712AbfIDQAa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Sep 2019 12:00:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA1582339E;
        Wed,  4 Sep 2019 16:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612829;
        bh=au813PDI6FI9tO98w4fyc/QYGAA9QqrIDbR/WbIjSdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2IAVE3QjME5GQyNqUs+aRlXYj5lYZvrmfXHDwWTqWwiCJtfBWFH6tYEKuhytiXrUV
         6r6XvJ7Oy9ZXNCcbBfWFaZxmUefyK4xXJ/FfE/5UGoxiSucyw6nKziaBLvmxrA18TX
         WgImdtzSu0IPHoIUs+jwIxu6C4ozyAcQLgnOD/CQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 17/52] netfilter: nft_flow_offload: missing netlink attribute policy
Date:   Wed,  4 Sep 2019 11:59:29 -0400
Message-Id: <20190904160004.3671-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904160004.3671-1-sashal@kernel.org>
References: <20190904160004.3671-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 14c415862c0630e01712a4eeaf6159a2b1b6d2a4 ]

The netlink attribute policy for NFTA_FLOW_TABLE_NAME is missing.

Fixes: a3c90f7a2323 ("netfilter: nf_tables: flow offload expression")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_flow_offload.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 6e0c26025ab13..5a838f12052fb 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -146,6 +146,11 @@ static int nft_flow_offload_validate(const struct nft_ctx *ctx,
 	return nft_chain_validate_hooks(ctx->chain, hook_mask);
 }
 
+static const struct nla_policy nft_flow_offload_policy[NFTA_FLOW_MAX + 1] = {
+	[NFTA_FLOW_TABLE_NAME]	= { .type = NLA_STRING,
+				    .len = NFT_NAME_MAXLEN - 1 },
+};
+
 static int nft_flow_offload_init(const struct nft_ctx *ctx,
 				 const struct nft_expr *expr,
 				 const struct nlattr * const tb[])
@@ -204,6 +209,7 @@ static const struct nft_expr_ops nft_flow_offload_ops = {
 static struct nft_expr_type nft_flow_offload_type __read_mostly = {
 	.name		= "flow_offload",
 	.ops		= &nft_flow_offload_ops,
+	.policy		= nft_flow_offload_policy,
 	.maxattr	= NFTA_FLOW_MAX,
 	.owner		= THIS_MODULE,
 };
-- 
2.20.1

