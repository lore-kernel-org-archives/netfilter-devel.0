Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5089CC433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 May 2022 12:30:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353733AbiELMa1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 12 May 2022 08:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353725AbiELMaY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 May 2022 08:30:24 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 224CC218
        for <netfilter-devel@vger.kernel.org>; Thu, 12 May 2022 05:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=tFYK48sppjreSkfyC0tHo6J5wLWmwBOtafYcwOegDg8=; b=WBhVDSOVOomh5c2tuk1kEGbi3P
        W+ELf2C10TvMF53in3nz4HLi+57p3vUK3BVFwoEafLpiu1vU/I5EXx92M7FvbSiRwxYwB5CNZyxSW
        BAh9X5vwzvfH5vDsOrULjeD9nM/NBVsrL27UQRadRw/TKjmmRZqTsGQ2EIwj0oqAxaHOc5bzQunOs
        iP798lvPcrTD78KMNKbIQKkYabjTSqOzVGMWCqLlzB3llZzsVRes2gzkO+08DdjSo18Lnr+WsTsiC
        a1nWol427RRPoC6p1CN3Hjh55ch7VNhqWmNQn6PfDK2/KvyMHjL0RddZUY3RdWM7OuTOdWlAihGFC
        puEyzq+g==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1np7xW-0000wP-Hr; Thu, 12 May 2022 14:30:22 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nf-next PATCH v2 1/2] netfilter: nf_tables: Introduce expression flags
Date:   Thu, 12 May 2022 14:30:02 +0200
Message-Id: <20220512123003.29903-2-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220512123003.29903-1-phil@nwl.cc>
References: <20220512123003.29903-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Allow dumping some info bits about expressions to user space.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/net/netfilter/nf_tables.h        | 1 +
 include/uapi/linux/netfilter/nf_tables.h | 1 +
 net/netfilter/nf_tables_api.c            | 4 ++++
 3 files changed, 6 insertions(+)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 20af9d3557b9d..78db54737de00 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -346,6 +346,7 @@ struct nft_set_estimate {
  */
 struct nft_expr {
 	const struct nft_expr_ops	*ops;
+	u32				flags;
 	unsigned char			data[]
 		__attribute__((aligned(__alignof__(u64))));
 };
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 466fd3f4447c2..36bf019322a44 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -518,6 +518,7 @@ enum nft_expr_attributes {
 	NFTA_EXPR_UNSPEC,
 	NFTA_EXPR_NAME,
 	NFTA_EXPR_DATA,
+	NFTA_EXPR_FLAGS,
 	__NFTA_EXPR_MAX
 };
 #define NFTA_EXPR_MAX		(__NFTA_EXPR_MAX - 1)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f3ad02a399f8a..fddc557983119 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2731,6 +2731,7 @@ static const struct nft_expr_type *nft_expr_type_get(struct net *net,
 static const struct nla_policy nft_expr_policy[NFTA_EXPR_MAX + 1] = {
 	[NFTA_EXPR_NAME]	= { .type = NLA_STRING,
 				    .len = NFT_MODULE_AUTOLOAD_LIMIT },
+	[NFTA_EXPR_FLAGS]	= { .type = NLA_U32 },
 	[NFTA_EXPR_DATA]	= { .type = NLA_NESTED },
 };
 
@@ -2740,6 +2741,9 @@ static int nf_tables_fill_expr_info(struct sk_buff *skb,
 	if (nla_put_string(skb, NFTA_EXPR_NAME, expr->ops->type->name))
 		goto nla_put_failure;
 
+	if (nla_put_u32(skb, NFTA_EXPR_FLAGS, expr->flags))
+		goto nla_put_failure;
+
 	if (expr->ops->dump) {
 		struct nlattr *data = nla_nest_start_noflag(skb,
 							    NFTA_EXPR_DATA);
-- 
2.34.1

