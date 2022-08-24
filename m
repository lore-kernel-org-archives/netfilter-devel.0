Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFFE9C64992
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Aug 2022 22:04:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240864AbiHXWEF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Aug 2022 18:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240825AbiHXWD7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Aug 2022 18:03:59 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1D7E27694A;
        Wed, 24 Aug 2022 15:03:58 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 11/14] netfilter: nf_tables: disallow binding to already bound chain
Date:   Thu, 25 Aug 2022 00:03:27 +0200
Message-Id: <20220824220330.64283-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220824220330.64283-1-pablo@netfilter.org>
References: <20220824220330.64283-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Update nft_data_init() to report EINVAL if chain is already bound.

Fixes: d0e2c7de92c7 ("netfilter: nf_tables: add NFT_CHAIN_BINDING")
Reported-by: Gwangun Jung <exsociety@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 72c066a33416..2ee50e23c9b7 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9711,6 +9711,8 @@ static int nft_verdict_init(const struct nft_ctx *ctx, struct nft_data *data,
 			return PTR_ERR(chain);
 		if (nft_is_base_chain(chain))
 			return -EOPNOTSUPP;
+		if (nft_chain_is_bound(chain))
+			return -EINVAL;
 		if (desc->flags & NFT_DATA_DESC_SETELEM &&
 		    chain->flags & NFT_CHAIN_BINDING)
 			return -EINVAL;
-- 
2.30.2

