Return-Path: <SRS0=OoGW=RW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26F9AC4360F
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Mar 2019 14:40:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00C142173C
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Mar 2019 14:40:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbfCSOku (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 19 Mar 2019 10:40:50 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:44158 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726612AbfCSOku (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Mar 2019 10:40:50 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 2A5E5CC1D6BFA3BF465D;
        Tue, 19 Mar 2019 22:40:46 +0800 (CST)
Received: from localhost (10.177.31.96) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.408.0; Tue, 19 Mar 2019
 22:40:35 +0800
From:   Yue Haibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <pablo@netfilter.org>,
        <kadlec@blackhole.kfki.hu>, <fw@strlen.de>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <coreteam@netfilter.org>, <netfilter-devel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] netfilter: nft_redir: Make nft_redir_dump static
Date:   Tue, 19 Mar 2019 22:40:21 +0800
Message-ID: <20190319144021.21720-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

Fix sparse warning:

net/netfilter/nft_redir.c:85:5:
 warning: symbol 'nft_redir_dump' was not declared. Should it be static?

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/netfilter/nft_redir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_redir.c b/net/netfilter/nft_redir.c
index a340cd8..02f4b4a 100644
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
2.7.4


