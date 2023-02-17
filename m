Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB717C05027
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Feb 2023 13:46:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbjBQNqt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Feb 2023 08:46:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjBQNqs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Feb 2023 08:46:48 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D11206B33E
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Feb 2023 05:46:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=asg5PNoStMWFetzstk1We8DcuzU8Y3UmsKqff026EzE=; b=kxSttLaheNQitb/pRMLrTiBd/3
        aD3B+yR9W/bfhtnUx0WpNecr5fTMSEsUdxvO9K0BU0cUbQSqqBaQH/W2K7LTCXlYkrBJSU8d4qz14
        VCSp9/gMbX/5nHONK+OQ/7VmFy5xg/6xNKkzXwC7XL7mxJrVTTXyT576N9ITW4+r7HlczM4YZUlbF
        f8Ok6uhgyScrhhBGX4bEw4IbbTAqEzljaQq9uy8aZpJK6cS8DnMgiU7mp62i0syXl5wjEjWxOlMq/
        MfNZgKBxunr0U1bsUq6So9n81xeb5J9xjwZIevDLkPFfEt4vl44V6/V6Xa1zQMTjvZz5Qy6jkNllo
        n+jRsd/g==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1pT148-0001uV-0I
        for netfilter-devel@vger.kernel.org; Fri, 17 Feb 2023 14:46:20 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/3] nft-shared: Use nft_create_match() in one more spot
Date:   Fri, 17 Feb 2023 14:45:59 +0100
Message-Id: <20230217134600.14433-2-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230217134600.14433-1-phil@nwl.cc>
References: <20230217134600.14433-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

By dropping the per-family 'cs->matches' selection (which is the default
anyway), code becomes identical to the function's body.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-shared.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index df3cc6ac994cf..52e745fea85c2 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -1202,16 +1202,13 @@ static void nft_parse_limit(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 	__u32 burst = nftnl_expr_get_u32(e, NFTNL_EXPR_LIMIT_BURST);
 	__u64 unit = nftnl_expr_get_u64(e, NFTNL_EXPR_LIMIT_UNIT);
 	__u64 rate = nftnl_expr_get_u64(e, NFTNL_EXPR_LIMIT_RATE);
-	struct xtables_rule_match **matches;
 	struct xtables_match *match;
 	struct xt_rateinfo *rinfo;
-	size_t size;
 
 	switch (ctx->h->family) {
 	case NFPROTO_IPV4:
 	case NFPROTO_IPV6:
 	case NFPROTO_BRIDGE:
-		matches = &ctx->cs->matches;
 		break;
 	default:
 		fprintf(stderr, "BUG: nft_parse_limit() unknown family %d\n",
@@ -1219,19 +1216,12 @@ static void nft_parse_limit(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 		exit(EXIT_FAILURE);
 	}
 
-	match = xtables_find_match("limit", XTF_TRY_LOAD, matches);
+	match = nft_create_match(ctx, ctx->cs, "limit", false);
 	if (match == NULL) {
 		ctx->errmsg = "limit match extension not found";
 		return;
 	}
 
-	size = XT_ALIGN(sizeof(struct xt_entry_match)) + match->size;
-	match->m = xtables_calloc(1, size);
-	match->m->u.match_size = size;
-	strcpy(match->m->u.user.name, match->name);
-	match->m->u.user.revision = match->revision;
-	xs_init_match(match);
-
 	rinfo = (void *)match->m->data;
 	rinfo->avg = XT_LIMIT_SCALE * unit / rate;
 	rinfo->burst = burst;
-- 
2.38.0

