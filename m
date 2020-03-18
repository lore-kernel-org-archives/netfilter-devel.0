Return-Path: <SRS0=WbMd=5D=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0086C2BB1D
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Mar 2020 00:40:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8012A20663
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Mar 2020 00:40:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727448AbgCRAkw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Mar 2020 20:40:52 -0400
Received: from correo.us.es ([193.147.175.20]:45690 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727326AbgCRAkX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Mar 2020 20:40:23 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8F20A27F8B6
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Mar 2020 01:39:52 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 81E3ADA3A3
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Mar 2020 01:39:52 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7773EDA3A0; Wed, 18 Mar 2020 01:39:52 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B9458DA39F;
        Wed, 18 Mar 2020 01:39:50 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 18 Mar 2020 01:39:50 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 928BD426CCB9;
        Wed, 18 Mar 2020 01:39:50 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 22/29] netfilter: nf_tables: statify nft_expr_init()
Date:   Wed, 18 Mar 2020 01:39:49 +0100
Message-Id: <20200318003956.73573-23-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200318003956.73573-1-pablo@netfilter.org>
References: <20200318003956.73573-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Not exposed anymore to modules, statify this function.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 2 --
 net/netfilter/nf_tables_api.c     | 4 ++--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 52b872a9a2cd..025ec148ea4f 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -846,8 +846,6 @@ static inline void *nft_expr_priv(const struct nft_expr *expr)
 	return (void *)expr->data;
 }
 
-struct nft_expr *nft_expr_init(const struct nft_ctx *ctx,
-			       const struct nlattr *nla);
 void nft_expr_destroy(const struct nft_ctx *ctx, struct nft_expr *expr);
 int nft_expr_dump(struct sk_buff *skb, unsigned int attr,
 		  const struct nft_expr *expr);
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 1605a728eb2c..bc7a33f0cd06 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2523,8 +2523,8 @@ static void nf_tables_expr_destroy(const struct nft_ctx *ctx,
 	module_put(type->owner);
 }
 
-struct nft_expr *nft_expr_init(const struct nft_ctx *ctx,
-			       const struct nlattr *nla)
+static struct nft_expr *nft_expr_init(const struct nft_ctx *ctx,
+				      const struct nlattr *nla)
 {
 	struct nft_expr_info info;
 	struct nft_expr *expr;
-- 
2.11.0

