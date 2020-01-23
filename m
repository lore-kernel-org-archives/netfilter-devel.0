Return-Path: <SRS0=Vl9M=3M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADADDC2D0DB
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jan 2020 14:30:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A1AC2077C
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jan 2020 14:30:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728767AbgAWOa2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Jan 2020 09:30:28 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:39860 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727022AbgAWOa2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Jan 2020 09:30:28 -0500
Received: from localhost ([::1]:52948 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iudV3-0000lz-Te; Thu, 23 Jan 2020 15:30:25 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: [nft PATCH 2/4] segtree: Drop dead code in ei_insert()
Date:   Thu, 23 Jan 2020 15:30:47 +0100
Message-Id: <20200123143049.13888-3-phil@nwl.cc>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200123143049.13888-1-phil@nwl.cc>
References: <20200123143049.13888-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Caller sorts new items to be added, therefore when checking for overlaps
the current range can only overlap on lower end. Drop the check for
upper end overlap.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/segtree.c | 20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/src/segtree.c b/src/segtree.c
index aa1f1c38d789c..47e326533ac39 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -228,26 +228,6 @@ static int ei_insert(struct list_head *msgs, struct seg_tree *tree,
 				ei_destroy(lei);
 			}
 		}
-		if (rei != NULL) {
-			if (!merge)
-				goto err;
-			/*
-			 * Right endpoint is within rei, adjust it so we have:
-			 *
-			 * [new_left, new_right](new_right, rei_right]
-			 */
-			if (segtree_debug(tree->debug_mask)) {
-				pr_gmp_debug("adjust right [%Zx %Zx]\n",
-					     rei->left, rei->right);
-			}
-
-			mpz_add_ui(rei->left, new->right, 1);
-			mpz_sub(rei->size, rei->right, rei->left);
-			if (mpz_sgn(rei->size) < 0) {
-				ei_remove(tree, rei);
-				ei_destroy(rei);
-			}
-		}
 	}
 
 	__ei_insert(tree, new);
-- 
2.24.1

