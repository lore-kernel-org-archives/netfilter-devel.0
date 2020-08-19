Return-Path: <SRS0=iLnO=B5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92BB9C433E1
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Aug 2020 10:37:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FD392072D
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Aug 2020 10:37:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727849AbgHSKhl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 Aug 2020 06:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727845AbgHSKhk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Aug 2020 06:37:40 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4833C061757
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Aug 2020 03:37:40 -0700 (PDT)
Received: from localhost ([::1]:38146 helo=minime)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1k8LTP-0000Fm-1f; Wed, 19 Aug 2020 12:37:39 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 3/4] nft: Fold nftnl_rule_list_chain_save() into caller
Date:   Wed, 19 Aug 2020 12:37:11 +0200
Message-Id: <20200819103712.12974-4-phil@nwl.cc>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200819103712.12974-1-phil@nwl.cc>
References: <20200819103712.12974-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Existence of this function was mostly code-duplication: Caller already
branches depending on whether 'chain' is NULL or not and even does the
chain list lookup.

While being at it, simplify __nftnl_rule_list_chain_save function name a
bit now that the non-prefixed name is gone.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c | 31 +++++++------------------------
 1 file changed, 7 insertions(+), 24 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 8d53d43770f81..dd66b98e5004c 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -2423,7 +2423,7 @@ list_save(struct nft_handle *h, struct nftnl_rule *r,
 	nft_rule_print_save(h, r, NFT_RULE_APPEND, format);
 }
 
-static int __nftnl_rule_list_chain_save(struct nftnl_chain *c, void *data)
+static int nft_rule_list_chain_save(struct nftnl_chain *c, void *data)
 {
 	const char *chain_name = nftnl_chain_get_str(c, NFTNL_CHAIN_NAME);
 	uint32_t policy = nftnl_chain_get_u32(c, NFTNL_CHAIN_POLICY);
@@ -2445,25 +2445,6 @@ static int __nftnl_rule_list_chain_save(struct nftnl_chain *c, void *data)
 	return 0;
 }
 
-static int
-nftnl_rule_list_chain_save(struct nft_handle *h, const char *chain,
-			   struct nftnl_chain_list *list, int counters)
-{
-	struct nftnl_chain *c;
-
-	if (chain) {
-		c = nftnl_chain_list_lookup_byname(list, chain);
-		if (!c)
-			return 0;
-
-		__nftnl_rule_list_chain_save(c, &counters);
-		return 1;
-	}
-
-	nftnl_chain_list_foreach(list, __nftnl_rule_list_chain_save, &counters);
-	return 1;
-}
-
 int nft_rule_list_save(struct nft_handle *h, const char *chain,
 		       const char *table, int rulenum, int counters)
 {
@@ -2484,10 +2465,6 @@ int nft_rule_list_save(struct nft_handle *h, const char *chain,
 	if (!list)
 		return 0;
 
-	/* Dump policies and custom chains first */
-	if (!rulenum)
-		nftnl_rule_list_chain_save(h, chain, list, counters);
-
 	if (counters < 0)
 		d.format = FMT_C_COUNTS;
 	else if (counters == 0)
@@ -2498,9 +2475,15 @@ int nft_rule_list_save(struct nft_handle *h, const char *chain,
 		if (!c)
 			return 0;
 
+		if (!rulenum)
+			nft_rule_list_chain_save(c, &counters);
+
 		return nft_rule_list_cb(c, &d);
 	}
 
+	/* Dump policies and custom chains first */
+	nftnl_chain_list_foreach(list, nft_rule_list_chain_save, &counters);
+
 	/* Now dump out rules in this table */
 	ret = nftnl_chain_list_foreach(list, nft_rule_list_cb, &d);
 	return ret == 0 ? 1 : 0;
-- 
2.27.0

