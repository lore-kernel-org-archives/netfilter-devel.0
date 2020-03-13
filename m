Return-Path: <SRS0=Dam8=46=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 510BAC10DCE
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Mar 2020 17:12:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2ED7820771
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Mar 2020 17:12:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgCMRMa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 13 Mar 2020 13:12:30 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:52440 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726414AbgCMRM3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 Mar 2020 13:12:29 -0400
Received: from localhost ([::1]:37298 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1jCnrH-0006dn-U7; Fri, 13 Mar 2020 18:12:27 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] nft: cache: Fix for unused variable warnings
Date:   Fri, 13 Mar 2020 18:12:19 +0100
Message-Id: <20200313171219.26857-1-phil@nwl.cc>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Loop index variable was left in place after removing the loops.

Fixes: 39ec645093baa ("nft: cache: Simplify chain list allocation")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-cache.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/iptables/nft-cache.c b/iptables/nft-cache.c
index 0dd131e1f70f5..e3c9655739187 100644
--- a/iptables/nft-cache.c
+++ b/iptables/nft-cache.c
@@ -331,7 +331,7 @@ static int fetch_chain_cache(struct nft_handle *h,
 	};
 	char buf[16536];
 	struct nlmsghdr *nlh;
-	int i, ret;
+	int ret;
 
 	if (t && chain) {
 		struct nftnl_chain *c = nftnl_chain_alloc();
@@ -516,8 +516,6 @@ void nft_build_cache(struct nft_handle *h, struct nftnl_chain *c)
 
 void nft_fake_cache(struct nft_handle *h)
 {
-	int i;
-
 	fetch_table_cache(h);
 	init_chain_cache(h);
 
-- 
2.25.1

