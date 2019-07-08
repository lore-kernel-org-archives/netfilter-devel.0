Return-Path: <SRS0=pcH3=VF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0471FC606AB
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Jul 2019 10:32:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D978A20656
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Jul 2019 10:32:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730143AbfGHKc4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Jul 2019 06:32:56 -0400
Received: from mail.us.es ([193.147.175.20]:34312 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730135AbfGHKcz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Jul 2019 06:32:55 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 84E0CBAE85
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Jul 2019 12:32:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 75370114D8C
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Jul 2019 12:32:53 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6ACCADA708; Mon,  8 Jul 2019 12:32:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6D1E16D2AC;
        Mon,  8 Jul 2019 12:32:51 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 08 Jul 2019 12:32:51 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 391984265A2F;
        Mon,  8 Jul 2019 12:32:51 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 15/15] netfilter: nf_tables: force module load in case select_ops() returns -EAGAIN
Date:   Mon,  8 Jul 2019 12:32:37 +0200
Message-Id: <20190708103237.28061-16-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190708103237.28061-1-pablo@netfilter.org>
References: <20190708103237.28061-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nft_meta needs to pull in the nft_meta_bridge module in case that this
is a bridge family rule from the select_ops() path.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 6 ++++++
 net/netfilter/nft_meta.c      | 4 ++++
 2 files changed, 10 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 5e97bf64975a..d22d00ca78c1 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2144,6 +2144,12 @@ static int nf_tables_expr_parse(const struct nft_ctx *ctx,
 				       (const struct nlattr * const *)info->tb);
 		if (IS_ERR(ops)) {
 			err = PTR_ERR(ops);
+#ifdef CONFIG_MODULES
+			if (err == -EAGAIN)
+				nft_expr_type_request_module(ctx->net,
+							     ctx->family,
+							     tb[NFTA_EXPR_NAME]);
+#endif
 			goto err1;
 		}
 	} else
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 18a848b01759..417f8d32e9a3 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -519,6 +519,10 @@ nft_meta_select_ops(const struct nft_ctx *ctx,
 	if (tb[NFTA_META_DREG] && tb[NFTA_META_SREG])
 		return ERR_PTR(-EINVAL);
 
+#ifdef CONFIG_NF_TABLES_BRIDGE
+	if (ctx->family == NFPROTO_BRIDGE)
+		return ERR_PTR(-EAGAIN);
+#endif
 	if (tb[NFTA_META_DREG])
 		return &nft_meta_get_ops;
 
-- 
2.11.0

