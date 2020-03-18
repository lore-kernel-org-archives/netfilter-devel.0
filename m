Return-Path: <SRS0=WbMd=5D=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08A0EC4332B
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Mar 2020 21:03:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BEE0020409
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Mar 2020 21:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1584565430;
	bh=aT7inr3kbkcrO/yezXU9W+OrYI6fOi2oIoeNDjMUW10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=OY6Xb70ap53kYipsZM21AfgS8xDd/itVbGzlb4a4OZkG0B5KqgTFjU6d/Mr8GLxdy
	 4DZwNBGfoMm/v3JJE0hU/ZoFlF7GhfpZWYx4V7agPz8XbjvsztdkLiVHL2TwG/O3t0
	 ADMaGxfDupHmmQiezP9S5mmK9nzB5TatyCJgu6/w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728855AbgCRVDm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Mar 2020 17:03:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:55928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728336AbgCRUzb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Mar 2020 16:55:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5E9A20B1F;
        Wed, 18 Mar 2020 20:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584564930;
        bh=aT7inr3kbkcrO/yezXU9W+OrYI6fOi2oIoeNDjMUW10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bh49jOOtMk4hO9SpuQE8IEZSFTHkwfe45PZnPIf6oYGHpANM4hhpHG9YyJR73FmVM
         VlA05W6TngrvwEP1MZg923l1v+pg+8YoLxYIVqv8MopvfcmcLE4ahSyPbbIsAkv77v
         J2pJ2naqanqPvA1i+weBZPwLJNLeUisAU7pztkJM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 17/37] netfilter: nft_tunnel: add missing attribute validation for tunnels
Date:   Wed, 18 Mar 2020 16:54:49 -0400
Message-Id: <20200318205509.17053-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200318205509.17053-1-sashal@kernel.org>
References: <20200318205509.17053-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 88a637719a1570705c02cacb3297af164b1714e7 ]

Add missing attribute validation for tunnel source and
destination ports to the netlink policy.

Fixes: af308b94a2a4 ("netfilter: nf_tables: add tunnel support")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_tunnel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index 1c6d15ea76d4a..8ae948fd9dcfc 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -308,6 +308,8 @@ static const struct nla_policy nft_tunnel_key_policy[NFTA_TUNNEL_KEY_MAX + 1] =
 	[NFTA_TUNNEL_KEY_FLAGS]	= { .type = NLA_U32, },
 	[NFTA_TUNNEL_KEY_TOS]	= { .type = NLA_U8, },
 	[NFTA_TUNNEL_KEY_TTL]	= { .type = NLA_U8, },
+	[NFTA_TUNNEL_KEY_SPORT]	= { .type = NLA_U16, },
+	[NFTA_TUNNEL_KEY_DPORT]	= { .type = NLA_U16, },
 	[NFTA_TUNNEL_KEY_OPTS]	= { .type = NLA_NESTED, },
 };
 
-- 
2.20.1

