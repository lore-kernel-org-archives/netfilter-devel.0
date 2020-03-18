Return-Path: <SRS0=WbMd=5D=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2B80C4332B
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Mar 2020 21:08:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B92E620777
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Mar 2020 21:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1584565707;
	bh=YISAl4STIRfh0lU8xT8j9z3QKHY1zJtpEpkCanQb0lw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=wCP3moj0v9GGtefaBKlADRrdZv51By+Beg6yqw6JV6hyGi5WW4ARzYpmHZQJTVVUi
	 i+eO/Kj1ZlkpPgva+kNVVcWo1vO4Q5YP8aePzUTjuzoWgbPgIapLSqrK2GQi/3Ng+I
	 98PBD0qVfyESWXSJd9lJIH6mijCV7mGRy/GXXKZU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728010AbgCRVIR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Mar 2020 17:08:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:53360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727525AbgCRUyD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Mar 2020 16:54:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0C71208D5;
        Wed, 18 Mar 2020 20:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584564842;
        bh=YISAl4STIRfh0lU8xT8j9z3QKHY1zJtpEpkCanQb0lw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K+OY45TA8tk10M7xh11yBzQk/zTpXKfDrUin5mxiV6K2wxWpTlFhQriFa+/6/KfSo
         2p9Jnttn9f1jRMt2RhG2o1Omh8MGIHcZIYlLOWXoN5+Np/25/J9NpK6M61adrvFWyd
         ZZXug15XjaC+fkw2+2wMFFc2oef1vWfTaSnpN6mY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 21/73] netfilter: nft_payload: add missing attribute validation for payload csum flags
Date:   Wed, 18 Mar 2020 16:52:45 -0400
Message-Id: <20200318205337.16279-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200318205337.16279-1-sashal@kernel.org>
References: <20200318205337.16279-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 9d6effb2f1523eb84516e44213c00f2fd9e6afff ]

Add missing attribute validation for NFTA_PAYLOAD_CSUM_FLAGS
to the netlink policy.

Fixes: 1814096980bb ("netfilter: nft_payload: layer 4 checksum adjustment for pseudoheader fields")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_payload.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 5cb2d8908d2a5..0e3bfbc26e790 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -121,6 +121,7 @@ static const struct nla_policy nft_payload_policy[NFTA_PAYLOAD_MAX + 1] = {
 	[NFTA_PAYLOAD_LEN]		= { .type = NLA_U32 },
 	[NFTA_PAYLOAD_CSUM_TYPE]	= { .type = NLA_U32 },
 	[NFTA_PAYLOAD_CSUM_OFFSET]	= { .type = NLA_U32 },
+	[NFTA_PAYLOAD_CSUM_FLAGS]	= { .type = NLA_U32 },
 };
 
 static int nft_payload_init(const struct nft_ctx *ctx,
-- 
2.20.1

