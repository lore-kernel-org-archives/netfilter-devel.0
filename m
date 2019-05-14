Return-Path: <SRS0=MMpb=TO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01342C04AB4
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 May 2019 08:51:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C18972085A
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 May 2019 08:51:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbfENIvd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 14 May 2019 04:51:33 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:47694 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725916AbfENIvd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 May 2019 04:51:33 -0400
Received: from localhost ([::1]:60784 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hQT9n-0005Ui-JR; Tue, 14 May 2019 10:51:31 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] xtables: Fix typo in nft_rebuild_cache()
Date:   Tue, 14 May 2019 10:51:33 +0200
Message-Id: <20190514085133.32674-1-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Conditional cache flush logic was inverted.

Fixes: 862818ac3a0de ("xtables: add and use nft_build_cache")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 6354b7e8e72fe..83e0d9a69b37c 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1541,7 +1541,7 @@ void nft_build_cache(struct nft_handle *h)
 
 void nft_rebuild_cache(struct nft_handle *h)
 {
-	if (!h->have_cache)
+	if (h->have_cache)
 		flush_chain_cache(h, NULL);
 
 	__nft_build_cache(h);
-- 
2.21.0

