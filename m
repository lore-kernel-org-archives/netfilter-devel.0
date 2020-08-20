Return-Path: <SRS0=xTVu=B6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD467C433E3
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Aug 2020 16:18:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D8DC207BB
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Aug 2020 16:18:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729782AbgHTQS2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Aug 2020 12:18:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729812AbgHTQRt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Aug 2020 12:17:49 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84D6AC061387
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Aug 2020 09:17:44 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1k8nFy-0002mF-2J; Thu, 20 Aug 2020 18:17:38 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft v2] nftables: dump raw element info from libnftnl when netlink debugging is on
Date:   Thu, 20 Aug 2020 18:17:30 +0200
Message-Id: <20200820161730.1698-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Example: nft --debug=netlink list ruleset
inet firewall @knock_candidates_ipv4
        element 0100007f 00007b00  : 0 [end]
        element 0200007f 0000f1ff  : 0 [end]
        element 0100007f 00007a00  : 0 [end]
inet firewall @__set0
        element 00000100  : 0 [end]
        element 00000200  : 0 [end]
inet firewall knock-input 3
  [ meta load l4proto => reg 1 ]
  ...

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v2: send the correct patch :/

 src/netlink.c | 40 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 38 insertions(+), 2 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index 20b3cdf5e469..77e0d41e2f07 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1194,6 +1194,42 @@ static int list_setelem_cb(struct nftnl_set_elem *nlse, void *arg)
 	return netlink_delinearize_setelem(nlse, ctx->set, &ctx->nft->cache);
 }
 
+static int list_setelem_debug_cb(struct nftnl_set_elem *nlse, void *arg)
+{
+	int r;
+
+	r = list_setelem_cb(nlse, arg);
+	if (r == 0) {
+		struct netlink_ctx *ctx = arg;
+		FILE *fp = ctx->nft->output.output_fp;
+
+		fprintf(fp, "\t");
+		nftnl_set_elem_fprintf(fp, nlse, 0, 0);
+		fprintf(fp, "\n");
+	}
+
+	return r;
+}
+
+static int list_setelements(struct nftnl_set *s, struct netlink_ctx *ctx)
+{
+	FILE *fp = ctx->nft->output.output_fp;
+
+	if (fp && (ctx->nft->debug_mask & NFT_DEBUG_NETLINK)) {
+		const char *table, *name;
+		uint32_t family = nftnl_set_get_u32(s, NFTNL_SET_FAMILY);
+
+		table = nftnl_set_get_str(s, NFTNL_SET_TABLE);
+		name = nftnl_set_get_str(s, NFTNL_SET_NAME);
+
+		fprintf(fp, "%s %s @%s\n", family2str(family), table, name);
+
+		return nftnl_set_elem_foreach(s, list_setelem_debug_cb, ctx);
+	}
+
+	return nftnl_set_elem_foreach(s, list_setelem_cb, ctx);
+}
+
 int netlink_list_setelems(struct netlink_ctx *ctx, const struct handle *h,
 			  struct set *set)
 {
@@ -1221,7 +1257,7 @@ int netlink_list_setelems(struct netlink_ctx *ctx, const struct handle *h,
 
 	ctx->set = set;
 	set->init = set_expr_alloc(&internal_location, set);
-	nftnl_set_elem_foreach(nls, list_setelem_cb, ctx);
+	list_setelements(nls, ctx);
 
 	if (set->flags & NFT_SET_INTERVAL && set->desc.field_count > 1)
 		concat_range_aggregate(set->init);
@@ -1265,7 +1301,7 @@ int netlink_get_setelem(struct netlink_ctx *ctx, const struct handle *h,
 
 	ctx->set = set;
 	set->init = set_expr_alloc(loc, set);
-	nftnl_set_elem_foreach(nls_out, list_setelem_cb, ctx);
+	list_setelements(nls_out, ctx);
 
 	if (set->flags & NFT_SET_INTERVAL && set->desc.field_count > 1)
 		concat_range_aggregate(set->init);
-- 
2.26.2

