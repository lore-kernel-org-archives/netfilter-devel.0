Return-Path: <SRS0=xTVu=B6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57034C433DF
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Aug 2020 16:01:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20729206B5
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Aug 2020 16:01:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728600AbgHTQBh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Aug 2020 12:01:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729256AbgHTQAz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Aug 2020 12:00:55 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ADCBC061385
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Aug 2020 09:00:51 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1k8mzh-0002Ux-AJ; Thu, 20 Aug 2020 18:00:49 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] nftables: dump raw element info from libnftnl when netlink debugging is on
Date:   Thu, 20 Aug 2020 18:00:44 +0200
Message-Id: <20200820160044.32560-1-fw@strlen.de>
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
 src/netlink.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/src/netlink.c b/src/netlink.c
index 20b3cdf5e469..d7fee0f5d5b5 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1086,6 +1086,17 @@ static void set_elem_parse_udata(struct nftnl_set_elem *nlse,
 			nftnl_udata_get_u32(ud[NFTNL_UDATA_SET_ELEM_FLAGS]);
 }
 
+static void netlink_dump_set_elem(struct nftnl_set_elem *nlse, struct netlink_ctx *ctx)
+{
+	FILE *fp = ctx->nft->output.output_fp;
+
+	if (!(ctx->nft->debug_mask & NFT_DEBUG_NETLINK) || !fp)
+		return;
+
+	nftnl_set_elem_fprintf(fp, nlse, 0, 0);
+	fprintf(fp, "\n");
+}
+
 int netlink_delinearize_setelem(struct nftnl_set_elem *nlse,
 				struct set *set, struct nft_cache *cache)
 {
@@ -1191,7 +1202,14 @@ out:
 static int list_setelem_cb(struct nftnl_set_elem *nlse, void *arg)
 {
 	struct netlink_ctx *ctx = arg;
-	return netlink_delinearize_setelem(nlse, ctx->set, &ctx->nft->cache);
+	int r;
+
+	r = netlink_delinearize_setelem(nlse, ctx->set, &ctx->nft->cache);
+
+	if (r == 0)
+		netlink_dump_set_elem(nlse, ctx);
+
+	return r;
 }
 
 int netlink_list_setelems(struct netlink_ctx *ctx, const struct handle *h,
-- 
2.26.2

