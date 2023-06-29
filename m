Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B06D4EB64DD
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Jun 2023 19:02:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233272AbjF2TCn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 29 Jun 2023 15:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232881AbjF2TBk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Jun 2023 15:01:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 105F935A0;
        Thu, 29 Jun 2023 12:01:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3B4361600;
        Thu, 29 Jun 2023 19:01:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B01BAC43397;
        Thu, 29 Jun 2023 19:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688065286;
        bh=RvZeJNIN0CCdX6Er9bt71dO4wHeuDY/e1uUj6g/moaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ejLRXSQx+zOS5dcP93ngY1HgFYF4QegpnCJrPxKT7pdfslIoCaYaYxdzjw98WS8HS
         hveNevZGUER9QoQLCUDMYkIAy9JHLu2MiqG1TwEP0y6CuqfeoM1b2+0WAXy3qfZ1yb
         8hDMmKByGSDsCDanBt1m63o+1JuhVXgcFD7f6FE6sEZkYrLwVKz4zb4qRw8yn0JX2b
         r+/iXhRllqOuXHVA4gffl8044jB6vjReVn938GHByKEzebvA5iH3vloQPeItTaQsp5
         Q2lnKwhQ3gq2PoRkZrAf6D7+W1GxVJRweVVTqbWeLvoLxH4oZqeQC5s6UlZ7DmJVKn
         +WVXlgPPvrUCg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>, kadlec@netfilter.org,
        fw@strlen.de, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.3 13/17] netfilter: nf_tables: disallow timeout for anonymous sets
Date:   Thu, 29 Jun 2023 15:00:42 -0400
Message-Id: <20230629190049.907558-13-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230629190049.907558-1-sashal@kernel.org>
References: <20230629190049.907558-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.3.9
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit e26d3009efda338f19016df4175f354a9bd0a4ab ]

Never used from userspace, disallow these parameters.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 8f63514656a17..26ab687ac9ab0 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4708,6 +4708,9 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 		if (!(flags & NFT_SET_TIMEOUT))
 			return -EINVAL;
 
+		if (flags & NFT_SET_ANONYMOUS)
+			return -EOPNOTSUPP;
+
 		err = nf_msecs_to_jiffies64(nla[NFTA_SET_TIMEOUT], &desc.timeout);
 		if (err)
 			return err;
@@ -4716,6 +4719,10 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 	if (nla[NFTA_SET_GC_INTERVAL] != NULL) {
 		if (!(flags & NFT_SET_TIMEOUT))
 			return -EINVAL;
+
+		if (flags & NFT_SET_ANONYMOUS)
+			return -EOPNOTSUPP;
+
 		desc.gc_int = ntohl(nla_get_be32(nla[NFTA_SET_GC_INTERVAL]));
 	}
 
-- 
2.39.2

