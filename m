Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85C26C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Feb 2022 17:00:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352413AbiBDRAU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 4 Feb 2022 12:00:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233140AbiBDRAU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 4 Feb 2022 12:00:20 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 323FDC061714
        for <netfilter-devel@vger.kernel.org>; Fri,  4 Feb 2022 09:00:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=JCOu8CX295/h8YlMQANdu7omA0VvUoU2wMlhq0bDh/8=; b=LrZ4atQB+RAO2DpifITaSZcYyI
        ZHBPAX2SCq4yhSkJ20c00e+YjQG6y1fj+HbrHGbHSGCoc0iqE/nm3FoO0/V2rcFPLTFwC1R7CnTyD
        cCFharv/OaCcclnuJ6NDVr/ScvjQw93DtTICyMtmur4d3l17hpWpwCOc7+dMzlY5DVmIvPe+TNZ0x
        VK0QhBMGXvwBD/f1ZIyhah3LGme+9d+exjBgMwuR2BiYGkNngCexE/xOuby/TsuPN0z2WerzZddxu
        KNSwzsITCIPZyKXZoa6jznuvfOJTwDzhnK7fPj1f5F9Eklh9NUeoQN0ABQCog3VUHk7oShCbTFYWS
        acqLL2Ig==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nG1wY-0004A0-G6; Fri, 04 Feb 2022 18:00:18 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 4/4] nft: cache: Dump rules if debugging
Date:   Fri,  4 Feb 2022 18:00:01 +0100
Message-Id: <20220204170001.27198-4-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220204170001.27198-1-phil@nwl.cc>
References: <20220204170001.27198-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If verbose flag was given twice, dump rules while populating the cache.
This not only applies to list commands, but all requiring a rule cache -
e.g. insert with position.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-cache.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/iptables/nft-cache.c b/iptables/nft-cache.c
index 43ac291ec84b2..608e42a7aa01b 100644
--- a/iptables/nft-cache.c
+++ b/iptables/nft-cache.c
@@ -538,9 +538,15 @@ static int fetch_chain_cache(struct nft_handle *h,
 	return ret;
 }
 
+struct rule_list_cb_data {
+	struct nftnl_chain *chain;
+	int verbose;
+};
+
 static int nftnl_rule_list_cb(const struct nlmsghdr *nlh, void *data)
 {
-	struct nftnl_chain *c = data;
+	struct rule_list_cb_data *rld = data;
+	struct nftnl_chain *c = rld->chain;
 	struct nftnl_rule *r;
 
 	r = nftnl_rule_alloc();
@@ -552,6 +558,10 @@ static int nftnl_rule_list_cb(const struct nlmsghdr *nlh, void *data)
 		return MNL_CB_OK;
 	}
 
+	if (rld->verbose > 1) {
+		nftnl_rule_fprintf(stdout, r, 0, 0);
+		fprintf(stdout, "\n");
+	}
 	nftnl_chain_rule_add_tail(r, c);
 	return MNL_CB_OK;
 }
@@ -560,6 +570,10 @@ static int nft_rule_list_update(struct nft_chain *nc, void *data)
 {
 	struct nftnl_chain *c = nc->nftnl;
 	struct nft_handle *h = data;
+	struct rule_list_cb_data rld = {
+		.chain = c,
+		.verbose = h->verbose,
+	};
 	char buf[16536];
 	struct nlmsghdr *nlh;
 	struct nftnl_rule *rule;
@@ -581,7 +595,7 @@ static int nft_rule_list_update(struct nft_chain *nc, void *data)
 					NLM_F_DUMP, h->seq);
 	nftnl_rule_nlmsg_build_payload(nlh, rule);
 
-	ret = mnl_talk(h, nlh, nftnl_rule_list_cb, c);
+	ret = mnl_talk(h, nlh, nftnl_rule_list_cb, &rld);
 	if (ret < 0 && errno == EINTR)
 		assert(nft_restart(h) >= 0);
 
-- 
2.34.1

