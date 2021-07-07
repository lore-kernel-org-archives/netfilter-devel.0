Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB9D1C07E95
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Jul 2021 16:18:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2EAC61C99
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Jul 2021 16:18:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbhGGQVi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 7 Jul 2021 12:21:38 -0400
Received: from mail.netfilter.org ([217.70.188.207]:55114 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230178AbhGGQVd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Jul 2021 12:21:33 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 2F54861836;
        Wed,  7 Jul 2021 18:18:40 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 03/11] netfilter: nf_tables: Fix dereference of null pointer flow
Date:   Wed,  7 Jul 2021 18:18:36 +0200
Message-Id: <20210707161844.20827-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210707161844.20827-1-pablo@netfilter.org>
References: <20210707161844.20827-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

In the case where chain->flags & NFT_CHAIN_HW_OFFLOAD is false then
nft_flow_rule_create is not called and flow is NULL. The subsequent
error handling execution via label err_destroy_flow_rule will lead
to a null pointer dereference on flow when calling nft_flow_rule_destroy.
Since the error path to err_destroy_flow_rule has to cater for null
and non-null flows, only call nft_flow_rule_destroy if flow is non-null
to fix this issue.

Addresses-Coverity: ("Explicity null dereference")
Fixes: 3c5e44622011 ("netfilter: nf_tables: memleak in hw offload abort path")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 390d4466567f..de182d1f7c4e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3446,7 +3446,8 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
 	return 0;
 
 err_destroy_flow_rule:
-	nft_flow_rule_destroy(flow);
+	if (flow)
+		nft_flow_rule_destroy(flow);
 err_release_rule:
 	nf_tables_rule_release(&ctx, rule);
 err_release_expr:
-- 
2.20.1

