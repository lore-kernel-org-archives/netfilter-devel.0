Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2059C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Nov 2023 15:01:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234508AbjKIPBZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Nov 2023 10:01:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234463AbjKIPBY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Nov 2023 10:01:24 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 923583588
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Nov 2023 07:01:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=eBwCR1Z0iucfi19sRqY+ro7vz7AG9I8wAR7zEHsTQmg=; b=ioy+IRyVZ76FLG9YI4CX4DXUto
        DBw427WboV4KUeHYtvfof4Ccc4oiU3FSAAe+8auSDjT1KZPsk267Mm7df/TsBKknwfJ9YOy3O/6dk
        ABpdRYKsXqTD5Up98VIZxopB7UPBCFKMlIuVxWMTnkASSKY41ofzn34+/F2sX6/b4vt8RUY/8gKcf
        yJ49HS2wQbiUSDHtNgSVOTYD7atici+BzG1LeYOKRvjVDVGT0Bh5uVXjFhbysifPWwIVDahYE+p4a
        jPgVC5FL3iqDdpH5+U+wy5pYVGw84MD2ItN+K5zqLbJ2+smmUXfaI3s/qzKdGtjOPQeJ1WoALu8TP
        aw/tCYuQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1r16X2-0005xA-HM; Thu, 09 Nov 2023 16:01:20 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: [nf-next PATCH v4 1/3] netfilter: nf_tables: Pass const set to nft_get_set_elem
Date:   Thu,  9 Nov 2023 16:01:14 +0100
Message-ID: <20231109150117.17616-2-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231109150117.17616-1-phil@nwl.cc>
References: <20231109150117.17616-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The function is not supposed to alter the set, passing the pointer as
const is fine and merely requires to adjust signatures of two called
functions as well.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_tables_api.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 245a2c5be082..d63b11073297 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5909,7 +5909,7 @@ static int nft_setelem_parse_flags(const struct nft_set *set,
 	return 0;
 }
 
-static int nft_setelem_parse_key(struct nft_ctx *ctx, struct nft_set *set,
+static int nft_setelem_parse_key(struct nft_ctx *ctx, const struct nft_set *set,
 				 struct nft_data *key, struct nlattr *attr)
 {
 	struct nft_data_desc desc = {
@@ -5962,7 +5962,7 @@ static void *nft_setelem_catchall_get(const struct net *net,
 	return priv;
 }
 
-static int nft_setelem_get(struct nft_ctx *ctx, struct nft_set *set,
+static int nft_setelem_get(struct nft_ctx *ctx, const struct nft_set *set,
 			   struct nft_set_elem *elem, u32 flags)
 {
 	void *priv;
@@ -5981,7 +5981,7 @@ static int nft_setelem_get(struct nft_ctx *ctx, struct nft_set *set,
 	return 0;
 }
 
-static int nft_get_set_elem(struct nft_ctx *ctx, struct nft_set *set,
+static int nft_get_set_elem(struct nft_ctx *ctx, const struct nft_set *set,
 			    const struct nlattr *attr, bool reset)
 {
 	struct nlattr *nla[NFTA_SET_ELEM_MAX + 1];
-- 
2.41.0

