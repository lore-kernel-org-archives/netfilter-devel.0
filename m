Return-Path: <SRS0=sEEs=Z2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1BA0C43603
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Dec 2019 09:06:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBA6D2053B
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Dec 2019 09:06:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbfLDJGQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Dec 2019 04:06:16 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:58032 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725922AbfLDJGQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Dec 2019 04:06:16 -0500
Received: from localhost ([::1]:42890 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1icQbu-0005St-PR; Wed, 04 Dec 2019 10:06:14 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/2] Fix DEBUG build
Date:   Wed,  4 Dec 2019 10:06:05 +0100
Message-Id: <20191204090606.2088-1-phil@nwl.cc>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fixed commit missed to update this conditional call to
nft_rule_print_save().

Fixes: 1e8ef6a584754 ("nft: family_ops: Pass nft_handle to 'rule_to_cs' callback")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-shared.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 78e422781723f..426765641cff6 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -998,7 +998,7 @@ bool nft_ipv46_rule_find(struct nft_handle *h, struct nftnl_rule *r, void *data)
 
 	DEBUGP("comparing with... ");
 #ifdef DEBUG_DEL
-	nft_rule_print_save(r, NFT_RULE_APPEND, 0);
+	nft_rule_print_save(h, r, NFT_RULE_APPEND, 0);
 #endif
 	if (!h->ops->is_same(cs, &this))
 		goto out;
-- 
2.24.0

