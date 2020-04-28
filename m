Return-Path: <SRS0=gJ4i=6M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ECA9C83006
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 12:11:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C5F3206D6
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 12:11:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbgD1MLz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Apr 2020 08:11:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726554AbgD1MLz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Apr 2020 08:11:55 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7DA9C03C1A9
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 05:11:54 -0700 (PDT)
Received: from localhost ([::1]:38710 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1jTP5d-0008An-Nz; Tue, 28 Apr 2020 14:11:53 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 04/18] nft: cache: Fetch sets per table
Date:   Tue, 28 Apr 2020 14:09:59 +0200
Message-Id: <20200428121013.24507-5-phil@nwl.cc>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200428121013.24507-1-phil@nwl.cc>
References: <20200428121013.24507-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Kernel accepts a table name when dumping sets, so make use of that in
case a table was passed to fetch_set_cache() but no set name.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-cache.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/iptables/nft-cache.c b/iptables/nft-cache.c
index e042bd83bebf5..51b371c51c3f4 100644
--- a/iptables/nft-cache.c
+++ b/iptables/nft-cache.c
@@ -254,25 +254,31 @@ static int fetch_set_cache(struct nft_handle *h,
 		.h = h,
 		.t = t,
 	};
+	uint16_t flags = NLM_F_DUMP;
+	struct nftnl_set *s = NULL;
 	struct nlmsghdr *nlh;
 	char buf[16536];
 	int i, ret;
 
-	if (t && set) {
-		struct nftnl_set *s = nftnl_set_alloc();
-
+	if (t) {
+		s = nftnl_set_alloc();
 		if (!s)
 			return -1;
 
-		nlh = nftnl_set_nlmsg_build_hdr(buf, NFT_MSG_GETSET, h->family,
-						NLM_F_ACK, h->seq);
 		nftnl_set_set_str(s, NFTNL_SET_TABLE, t->name);
-		nftnl_set_set_str(s, NFTNL_SET_NAME, set);
+
+		if (set) {
+			nftnl_set_set_str(s, NFTNL_SET_NAME, set);
+			flags = NLM_F_ACK;
+		}
+	}
+
+	nlh = nftnl_set_nlmsg_build_hdr(buf, NFT_MSG_GETSET,
+					h->family, flags, h->seq);
+
+	if (s) {
 		nftnl_set_nlmsg_build_payload(nlh, s);
 		nftnl_set_free(s);
-	} else {
-		nlh = nftnl_set_nlmsg_build_hdr(buf, NFT_MSG_GETSET, h->family,
-						NLM_F_DUMP, h->seq);
 	}
 
 	ret = mnl_talk(h, nlh, nftnl_set_list_cb, &d);
@@ -282,8 +288,6 @@ static int fetch_set_cache(struct nft_handle *h,
 	}
 
 	if (t && set) {
-		struct nftnl_set *s;
-
 		s = nftnl_set_list_lookup_byname(h->cache->table[t->type].sets,
 						 set);
 		set_fetch_elem_cb(s, h);
-- 
2.25.1

