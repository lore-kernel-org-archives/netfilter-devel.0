Return-Path: <SRS0=R8c+=TN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23E6FC04AA7
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 May 2019 17:12:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F374D20873
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 May 2019 17:12:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730862AbfEMRMX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 May 2019 13:12:23 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:46040 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730268AbfEMRMX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 May 2019 13:12:23 -0400
Received: from localhost ([::1]:59130 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hQEUw-0005UG-3B; Mon, 13 May 2019 19:12:22 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] xtables: Don't leak iter in error path of __nft_chain_zero_counters()
Date:   Mon, 13 May 2019 19:12:24 +0200
Message-Id: <20190513171224.18222-1-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If batch_rule_add() fails, this function leaked the rule iterator
object.

Fixes: 4c54c892443c2 ("xtables: Catch errors when zeroing rule rounters")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 6354b7e8e72fe..dab1db59ec971 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -3374,8 +3374,10 @@ static int __nft_chain_zero_counters(struct nftnl_chain *c, void *data)
 			 * rule based on its handle only.
 			 */
 			nftnl_rule_unset(r, NFTNL_RULE_POSITION);
-			if (!batch_rule_add(h, NFT_COMPAT_RULE_REPLACE, r))
+			if (!batch_rule_add(h, NFT_COMPAT_RULE_REPLACE, r)) {
+				nftnl_rule_iter_destroy(iter);
 				return -1;
+			}
 		}
 		r = nftnl_rule_iter_next(iter);
 	}
-- 
2.21.0

