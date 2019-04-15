Return-Path: <SRS0=sICu=SR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48FF3C10F0E
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 17:00:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 179072075B
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 17:00:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727832AbfDORAl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Apr 2019 13:00:41 -0400
Received: from mail.us.es ([193.147.175.20]:50448 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726740AbfDORAj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Apr 2019 13:00:39 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BFCD21C4436
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Apr 2019 19:00:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AAC9CDA70E
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Apr 2019 19:00:37 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A9D64DA70B; Mon, 15 Apr 2019 19:00:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5B11ADA708;
        Mon, 15 Apr 2019 19:00:35 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 15 Apr 2019 19:00:35 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 2A5D34265A31;
        Mon, 15 Apr 2019 19:00:35 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 03/22] netfilter: nft_redir: Make nft_redir_dump static
Date:   Mon, 15 Apr 2019 19:00:09 +0200
Message-Id: <20190415170028.3470-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190415170028.3470-1-pablo@netfilter.org>
References: <20190415170028.3470-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

Fix sparse warning:

net/netfilter/nft_redir.c:85:5:
 warning: symbol 'nft_redir_dump' was not declared. Should it be static?

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_redir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_redir.c b/net/netfilter/nft_redir.c
index a340cd8a751b..02f4b4a6f887 100644
--- a/net/netfilter/nft_redir.c
+++ b/net/netfilter/nft_redir.c
@@ -82,7 +82,7 @@ static int nft_redir_init(const struct nft_ctx *ctx,
 	return nf_ct_netns_get(ctx->net, ctx->family);
 }
 
-int nft_redir_dump(struct sk_buff *skb, const struct nft_expr *expr)
+static int nft_redir_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
 	const struct nft_redir *priv = nft_expr_priv(expr);
 
-- 
2.11.0

