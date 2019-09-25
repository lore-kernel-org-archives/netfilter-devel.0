Return-Path: <SRS0=+tY6=XU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AF51C4360D
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Sep 2019 21:27:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A86420673
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Sep 2019 21:27:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726372AbfIYV11 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:27:27 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:45866 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbfIYV11 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Sep 2019 17:27:27 -0400
Received: from localhost ([::1]:58956 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iDEon-0005GS-A9; Wed, 25 Sep 2019 23:27:25 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 10/24] nft: Support fetch_chain_cache() per chain
Date:   Wed, 25 Sep 2019 23:25:51 +0200
Message-Id: <20190925212605.1005-11-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190925212605.1005-1-phil@nwl.cc>
References: <20190925212605.1005-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Accept a specific chain's name to fetch from kernel. If given, prepare a
non-dump request with chain's table and name in payload. Kernel will
return only that chain (if it exists).

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 6ed05e77008c4..f116b940b41fd 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1436,7 +1436,7 @@ static int fetch_table_cache(struct nft_handle *h)
 }
 
 static int fetch_chain_cache(struct nft_handle *h,
-			     const struct builtin_table *t)
+			     const struct builtin_table *t, const char *chain)
 {
 	struct nftnl_chain_list_cb_data d = {
 		.h = h,
@@ -1461,12 +1461,24 @@ static int fetch_chain_cache(struct nft_handle *h,
 		}
 	} else if (!h->cache->table[t->type].chains) {
 		h->cache->table[t->type].chains = nftnl_chain_list_alloc();
-	} else {
-		return 0;
 	}
 
-	nlh = nftnl_chain_nlmsg_build_hdr(buf, NFT_MSG_GETCHAIN, h->family,
-					NLM_F_DUMP, h->seq);
+	if (t && chain) {
+		struct nftnl_chain *c = nftnl_chain_alloc();
+
+		if (!c)
+			return -1;
+
+		nlh = nftnl_chain_nlmsg_build_hdr(buf, NFT_MSG_GETCHAIN, h->family,
+						  NLM_F_ACK, h->seq);
+		nftnl_chain_set_str(c, NFTNL_CHAIN_TABLE, t->name);
+		nftnl_chain_set_str(c, NFTNL_CHAIN_NAME, chain);
+		nftnl_chain_nlmsg_build_payload(nlh, c);
+		nftnl_chain_free(c);
+	} else {
+		nlh = nftnl_chain_nlmsg_build_hdr(buf, NFT_MSG_GETCHAIN, h->family,
+						NLM_F_DUMP, h->seq);
+	}
 
 	ret = mnl_talk(h, nlh, nftnl_chain_list_cb, &d);
 	if (ret < 0 && errno == EINTR)
@@ -1639,7 +1651,7 @@ static void __nft_build_cache(struct nft_handle *h)
 
 retry:
 	mnl_genid_get(h, &genid_start);
-	fetch_chain_cache(h, NULL);
+	fetch_chain_cache(h, NULL, NULL);
 	fetch_rule_cache(h, NULL);
 	h->have_cache = true;
 	mnl_genid_get(h, &genid_stop);
@@ -1709,7 +1721,7 @@ struct nftnl_chain_list *nft_chain_list_get(struct nft_handle *h,
 		return NULL;
 
 	if (!h->have_cache && !h->cache->table[t->type].chains)
-		fetch_chain_cache(h, t);
+		fetch_chain_cache(h, t, NULL);
 
 	return h->cache->table[t->type].chains;
 }
-- 
2.23.0

