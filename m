Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7DF7C07E9B
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Jul 2021 17:00:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AED7161003
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Jul 2021 17:00:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbhGTQTk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Jul 2021 12:19:40 -0400
Received: from mail.netfilter.org ([217.70.188.207]:51512 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbhGTQTj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Jul 2021 12:19:39 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 8C361608E0
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Jul 2021 18:59:52 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nft_nat: allow to specify layer 4 protocol NAT only
Date:   Tue, 20 Jul 2021 19:00:15 +0200
Message-Id: <20210720170015.43063-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nft_nat reports a bogus EAFNOSUPPORT if no layer 3 information is specified.

Fixes: d07db9884a5f ("netfilter: nf_tables: introduce nft_validate_register_load()")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_nat.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index 0840c635b752..be1595d6979d 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -201,7 +201,9 @@ static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		alen = sizeof_field(struct nf_nat_range, min_addr.ip6);
 		break;
 	default:
-		return -EAFNOSUPPORT;
+		if (tb[NFTA_NAT_REG_ADDR_MIN])
+			return -EAFNOSUPPORT;
+		break;
 	}
 	priv->family = family;
 
-- 
2.30.2

