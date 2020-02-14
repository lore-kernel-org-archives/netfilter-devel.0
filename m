Return-Path: <SRS0=aq0Q=4C=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A70FCC3B1A1
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Feb 2020 17:09:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 759CA20637
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Feb 2020 17:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581700147;
	bh=fLdj1bfTpZ/AoJbVRl8A14jHH7ap3xGhu/sgu2jrqhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=tMnVcNhsnQQNh0tSX7cjbigYmrT69WevhTPb+8sLBZpL4+pCqMi2xBhYsLzKz8u+A
	 PAV1g+fQl8PyXzsEpM8WkUju45a2lFGI2T6ARJhrYH5omdTGTzWSpMw6l8bBDrpumQ
	 ESFGtWsLi0ZYI+U5fpPSXIJtlPIPwrOcBY9CcNKM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403975AbgBNQN5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 14 Feb 2020 11:13:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:43120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403967AbgBNQN4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 14 Feb 2020 11:13:56 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF174246BD;
        Fri, 14 Feb 2020 16:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696835;
        bh=fLdj1bfTpZ/AoJbVRl8A14jHH7ap3xGhu/sgu2jrqhE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FRd5GrF3Cn0q5EXWDdVaEfSElCUIkYug0WbveMP/zsRo5s6mUkjvPe3nxOM5NnKGf
         siNxdjqhfXrKhXCUWHn74aZcgrmbbRavCSIQjzft51hPfqJVcKQ9qnp2hKXAkvPFHs
         t8w48fs4thnGkUS/QuFsetqYsO1jX10Jqx7wW24c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xin Long <lucien.xin@gmail.com>,
        Simon Horman <simon.horman@netronome.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 100/252] netfilter: nft_tunnel: add the missing ERSPAN_VERSION nla_policy
Date:   Fri, 14 Feb 2020 11:09:15 -0500
Message-Id: <20200214161147.15842-100-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161147.15842-1-sashal@kernel.org>
References: <20200214161147.15842-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 0705f95c332081036d85f26691e9d3cd7d901c31 ]

ERSPAN_VERSION is an attribute parsed in kernel side, nla_policy
type should be added for it, like other attributes.

Fixes: af308b94a2a4 ("netfilter: nf_tables: add tunnel support")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_tunnel.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index e5444f3ff43fc..5e66042ac3466 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -218,8 +218,9 @@ static int nft_tunnel_obj_vxlan_init(const struct nlattr *attr,
 }
 
 static const struct nla_policy nft_tunnel_opts_erspan_policy[NFTA_TUNNEL_KEY_ERSPAN_MAX + 1] = {
+	[NFTA_TUNNEL_KEY_ERSPAN_VERSION]	= { .type = NLA_U32 },
 	[NFTA_TUNNEL_KEY_ERSPAN_V1_INDEX]	= { .type = NLA_U32 },
-	[NFTA_TUNNEL_KEY_ERSPAN_V2_DIR]	= { .type = NLA_U8 },
+	[NFTA_TUNNEL_KEY_ERSPAN_V2_DIR]		= { .type = NLA_U8 },
 	[NFTA_TUNNEL_KEY_ERSPAN_V2_HWID]	= { .type = NLA_U8 },
 };
 
-- 
2.20.1

