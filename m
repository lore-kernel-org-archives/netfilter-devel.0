Return-Path: <SRS0=hj4T=4T=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DA50C3F2CD
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Mar 2020 17:54:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76A092173E
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Mar 2020 17:54:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbgCBRyY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Mar 2020 12:54:24 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:53336 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727126AbgCBRyY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Mar 2020 12:54:24 -0500
Received: from localhost ([::1]:38194 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1j8pGp-0007JY-4A; Mon, 02 Mar 2020 18:54:23 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/4] nft: cache: Fix nft_release_cache() under stress
Date:   Mon,  2 Mar 2020 18:53:55 +0100
Message-Id: <20200302175358.27796-2-phil@nwl.cc>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200302175358.27796-1-phil@nwl.cc>
References: <20200302175358.27796-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

iptables-nft-restore calls nft_action(h, NFT_COMPAT_COMMIT) for each
COMMIT line in input. When restoring a dump containing multiple large
tables, chances are nft_rebuild_cache() has to run multiple times.

If the above happens, consecutive table contents are added to __cache[1]
which nft_rebuild_cache() then frees, so next commit attempt accesses
invalid memory.

Fix this by making nft_release_cache() (called after each successful
commit) return things into pre-rebuild state again, but keeping the
fresh cache copy.

Fixes: f6ad231d698c7 ("nft: keep original cache in case of ERESTART")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-cache.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/iptables/nft-cache.c b/iptables/nft-cache.c
index 7345a27e2894b..6f21f2283e0fb 100644
--- a/iptables/nft-cache.c
+++ b/iptables/nft-cache.c
@@ -647,8 +647,14 @@ void nft_rebuild_cache(struct nft_handle *h)
 
 void nft_release_cache(struct nft_handle *h)
 {
-	if (h->cache_index)
-		flush_cache(h, &h->__cache[0], NULL);
+	if (!h->cache_index)
+		return;
+
+	flush_cache(h, &h->__cache[0], NULL);
+	memcpy(&h->__cache[0], &h->__cache[1], sizeof(h->__cache[0]));
+	memset(&h->__cache[1], 0, sizeof(h->__cache[1]));
+	h->cache_index = 0;
+	h->cache = &h->__cache[0];
 }
 
 struct nftnl_table_list *nftnl_table_list_get(struct nft_handle *h)
-- 
2.25.1

