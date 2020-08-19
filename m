Return-Path: <SRS0=iLnO=B5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97B41C433E1
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Aug 2020 10:37:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7843A2072D
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Aug 2020 10:37:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbgHSKhh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 Aug 2020 06:37:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727846AbgHSKhf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Aug 2020 06:37:35 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BAB6C061757
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Aug 2020 03:37:35 -0700 (PDT)
Received: from localhost ([::1]:38140 helo=minime)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1k8LTJ-0000FA-LL; Wed, 19 Aug 2020 12:37:33 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 4/4] nft: Use nft_chain_find() in nft_chain_builtin_init()
Date:   Wed, 19 Aug 2020 12:37:12 +0200
Message-Id: <20200819103712.12974-5-phil@nwl.cc>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200819103712.12974-1-phil@nwl.cc>
References: <20200819103712.12974-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The replaced code is basically identical to nft_chain_find()'s body.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index dd66b98e5004c..27bb98d184c7c 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -736,22 +736,17 @@ nft_chain_builtin_find(const struct builtin_table *t, const char *chain)
 	return found ? &t->chains[i] : NULL;
 }
 
+static struct nftnl_chain *
+nft_chain_find(struct nft_handle *h, const char *table, const char *chain);
+
 static void nft_chain_builtin_init(struct nft_handle *h,
 				   const struct builtin_table *table)
 {
-	struct nftnl_chain_list *list;
-	struct nftnl_chain *c;
 	int i;
 
 	/* Initialize built-in chains if they don't exist yet */
 	for (i=0; i < NF_INET_NUMHOOKS && table->chains[i].name != NULL; i++) {
-		list = nft_chain_list_get(h, table->name,
-					  table->chains[i].name);
-		if (!list)
-			continue;
-
-		c = nftnl_chain_list_lookup_byname(list, table->chains[i].name);
-		if (c != NULL)
+		if (nft_chain_find(h, table->name, table->chains[i].name))
 			continue;
 
 		nft_chain_builtin_add(h, table, &table->chains[i]);
@@ -1388,9 +1383,6 @@ err:
 	return NULL;
 }
 
-static struct nftnl_chain *
-nft_chain_find(struct nft_handle *h, const char *table, const char *chain);
-
 int
 nft_rule_append(struct nft_handle *h, const char *chain, const char *table,
 		struct nftnl_rule *r, struct nftnl_rule *ref, bool verbose)
-- 
2.27.0

