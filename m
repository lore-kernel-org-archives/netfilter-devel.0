Return-Path: <SRS0=4pKc=6U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 528A7C28CBC
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 May 2020 17:35:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 315CB208DB
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 May 2020 17:35:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728921AbgEFRfC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 May 2020 13:35:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728047AbgEFRfB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 May 2020 13:35:01 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4DE5C061A0F
        for <netfilter-devel@vger.kernel.org>; Wed,  6 May 2020 10:35:01 -0700 (PDT)
Received: from localhost ([::1]:58786 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1jWNwi-0002ov-IO; Wed, 06 May 2020 19:35:00 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 06/15] nft: cache: Re-establish cache consistency check
Date:   Wed,  6 May 2020 19:33:22 +0200
Message-Id: <20200506173331.9347-7-phil@nwl.cc>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200506173331.9347-1-phil@nwl.cc>
References: <20200506173331.9347-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Restore code ensuring __nft_build_cache() returns a consistent cache in
which all ruleset elements belong to the same generation.

This check was removed by commit 200bc39965149 ("nft: cache: Fix
iptables-save segfault under stress") as it could lead to segfaults if a
partial cache fetch was done while cache's chain list was traversed.
With the new cache fetch logic, __nft_build_cache() is never called
while holding references to cache entries.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-cache.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/iptables/nft-cache.c b/iptables/nft-cache.c
index 84ea97d3e54a6..638b18bc7e382 100644
--- a/iptables/nft-cache.c
+++ b/iptables/nft-cache.c
@@ -484,12 +484,16 @@ static int fetch_rule_cache(struct nft_handle *h,
 	return 0;
 }
 
+static int flush_cache(struct nft_handle *h, struct nft_cache *c,
+		       const char *tablename);
+
 static void
 __nft_build_cache(struct nft_handle *h)
 {
 	struct nft_cache_req *req = &h->cache_req;
 	const struct builtin_table *t = NULL;
 	struct list_head *chains = NULL;
+	uint32_t genid_check;
 
 	if (h->cache_init)
 		return;
@@ -501,6 +505,7 @@ __nft_build_cache(struct nft_handle *h)
 	}
 
 	h->cache_init = true;
+retry:
 	mnl_genid_get(h, &h->nft_genid);
 
 	if (req->level >= NFT_CL_TABLES)
@@ -513,6 +518,12 @@ __nft_build_cache(struct nft_handle *h)
 		fetch_set_cache(h, t, NULL);
 	if (req->level >= NFT_CL_RULES)
 		fetch_rule_cache(h, t);
+
+	mnl_genid_get(h, &genid_check);
+	if (h->nft_genid != genid_check) {
+		flush_cache(h, h->cache, NULL);
+		goto retry;
+	}
 }
 
 static void __nft_flush_cache(struct nft_handle *h)
-- 
2.25.1

