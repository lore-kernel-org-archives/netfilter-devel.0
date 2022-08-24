Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DC6BC3F6B0
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Aug 2022 22:04:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240846AbiHXWEC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Aug 2022 18:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240828AbiHXWDy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Aug 2022 18:03:54 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8EAC176957;
        Wed, 24 Aug 2022 15:03:53 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 08/14] netfilter: nf_tables: do not leave chain stats enabled on error
Date:   Thu, 25 Aug 2022 00:03:24 +0200
Message-Id: <20220824220330.64283-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220824220330.64283-1-pablo@netfilter.org>
References: <20220824220330.64283-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Error might occur later in the nf_tables_addchain() codepath, enable
static key only after transaction has been created.

Fixes: 9f08ea848117 ("netfilter: nf_tables: keep chain counters away from hot path")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0951f31caabe..72c066a33416 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2195,9 +2195,9 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 			      struct netlink_ext_ack *extack)
 {
 	const struct nlattr * const *nla = ctx->nla;
+	struct nft_stats __percpu *stats = NULL;
 	struct nft_table *table = ctx->table;
 	struct nft_base_chain *basechain;
-	struct nft_stats __percpu *stats;
 	struct net *net = ctx->net;
 	char name[NFT_NAME_MAXLEN];
 	struct nft_rule_blob *blob;
@@ -2235,7 +2235,6 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 				return PTR_ERR(stats);
 			}
 			rcu_assign_pointer(basechain->stats, stats);
-			static_branch_inc(&nft_counters_enabled);
 		}
 
 		err = nft_basechain_init(basechain, family, &hook, flags);
@@ -2318,6 +2317,9 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 		goto err_unregister_hook;
 	}
 
+	if (stats)
+		static_branch_inc(&nft_counters_enabled);
+
 	table->use++;
 
 	return 0;
-- 
2.30.2

