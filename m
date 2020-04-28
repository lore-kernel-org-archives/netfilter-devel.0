Return-Path: <SRS0=gJ4i=6M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38B40C83000
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 12:10:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14F6D206D7
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 12:10:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgD1MKZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Apr 2020 08:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726554AbgD1MKZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Apr 2020 08:10:25 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73E11C03C1A9
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 05:10:25 -0700 (PDT)
Received: from localhost ([::1]:38608 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1jTP4A-00083y-4k; Tue, 28 Apr 2020 14:10:22 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 15/18] nft-cache: Introduce __fetch_chain_cache()
Date:   Tue, 28 Apr 2020 14:10:10 +0200
Message-Id: <20200428121013.24507-16-phil@nwl.cc>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200428121013.24507-1-phil@nwl.cc>
References: <20200428121013.24507-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Extract the inner part of fetch_chain_cache() into a dedicated function,
preparing for individual chain caching.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-cache.c | 50 ++++++++++++++++++++++++++------------------
 1 file changed, 30 insertions(+), 20 deletions(-)

diff --git a/iptables/nft-cache.c b/iptables/nft-cache.c
index 5cbe7b80d084d..904c9a8217dac 100644
--- a/iptables/nft-cache.c
+++ b/iptables/nft-cache.c
@@ -318,9 +318,9 @@ static int fetch_set_cache(struct nft_handle *h,
 	return ret;
 }
 
-static int fetch_chain_cache(struct nft_handle *h,
-			     const struct builtin_table *t,
-			     const char *chain)
+static int __fetch_chain_cache(struct nft_handle *h,
+			       const struct builtin_table *t,
+			       const struct nftnl_chain *c)
 {
 	struct nftnl_chain_list_cb_data d = {
 		.h = h,
@@ -330,24 +330,10 @@ static int fetch_chain_cache(struct nft_handle *h,
 	struct nlmsghdr *nlh;
 	int ret;
 
-	if (t && chain) {
-		struct nftnl_chain *c = nftnl_chain_alloc();
-
-		if (!c)
-			return -1;
-
-		nlh = nftnl_chain_nlmsg_build_hdr(buf, NFT_MSG_GETCHAIN,
-						  h->family, NLM_F_ACK,
-						  h->seq);
-		nftnl_chain_set_str(c, NFTNL_CHAIN_TABLE, t->name);
-		nftnl_chain_set_str(c, NFTNL_CHAIN_NAME, chain);
+	nlh = nftnl_chain_nlmsg_build_hdr(buf, NFT_MSG_GETCHAIN, h->family,
+					  c ? NLM_F_ACK : NLM_F_DUMP, h->seq);
+	if (c)
 		nftnl_chain_nlmsg_build_payload(nlh, c);
-		nftnl_chain_free(c);
-	} else {
-		nlh = nftnl_chain_nlmsg_build_hdr(buf, NFT_MSG_GETCHAIN,
-						  h->family, NLM_F_DUMP,
-						  h->seq);
-	}
 
 	ret = mnl_talk(h, nlh, nftnl_chain_list_cb, &d);
 	if (ret < 0 && errno == EINTR)
@@ -356,6 +342,30 @@ static int fetch_chain_cache(struct nft_handle *h,
 	return ret;
 }
 
+static int fetch_chain_cache(struct nft_handle *h,
+			     const struct builtin_table *t,
+			     const char *chain)
+{
+	struct nftnl_chain *c;
+	int ret;
+
+	if (!chain)
+		return __fetch_chain_cache(h, t, NULL);
+
+	assert(t);
+
+	c = nftnl_chain_alloc();
+	if (!c)
+		return -1;
+
+	nftnl_chain_set_str(c, NFTNL_CHAIN_TABLE, t->name);
+	nftnl_chain_set_str(c, NFTNL_CHAIN_NAME, chain);
+	ret = __fetch_chain_cache(h, t, c);
+
+	nftnl_chain_free(c);
+	return ret;
+}
+
 static int nftnl_rule_list_cb(const struct nlmsghdr *nlh, void *data)
 {
 	struct nftnl_chain *c = data;
-- 
2.25.1

