Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E85A1EE0212
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Sep 2023 21:58:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232893AbjIMV6V (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Sep 2023 17:58:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232888AbjIMV6V (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Sep 2023 17:58:21 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F3622173A;
        Wed, 13 Sep 2023 14:58:16 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 5/9] netfilter: nft_set_hash: try later when GC hits EAGAIN on iteration
Date:   Wed, 13 Sep 2023 23:57:56 +0200
Message-Id: <20230913215800.107269-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230913215800.107269-1-pablo@netfilter.org>
References: <20230913215800.107269-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Skip GC run if iterator rewinds to the beginning with EAGAIN, otherwise GC
might collect the same element more than once.

Fixes: f6c383b8c31a ("netfilter: nf_tables: adapt set backend to use GC transaction API")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_hash.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index eca20dc60138..2013de934cef 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -338,12 +338,9 @@ static void nft_rhash_gc(struct work_struct *work)
 
 	while ((he = rhashtable_walk_next(&hti))) {
 		if (IS_ERR(he)) {
-			if (PTR_ERR(he) != -EAGAIN) {
-				nft_trans_gc_destroy(gc);
-				gc = NULL;
-				goto try_later;
-			}
-			continue;
+			nft_trans_gc_destroy(gc);
+			gc = NULL;
+			goto try_later;
 		}
 
 		/* Ruleset has been updated, try later. */
-- 
2.30.2

