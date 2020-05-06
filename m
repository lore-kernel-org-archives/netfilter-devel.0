Return-Path: <SRS0=4pKc=6U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FE99C28CBC
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 May 2020 17:34:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02819208DB
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 May 2020 17:34:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728566AbgEFRek (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 May 2020 13:34:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728047AbgEFRek (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 May 2020 13:34:40 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 868F7C061A0F
        for <netfilter-devel@vger.kernel.org>; Wed,  6 May 2020 10:34:40 -0700 (PDT)
Received: from localhost ([::1]:58756 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1jWNwN-0002mr-CC; Wed, 06 May 2020 19:34:39 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 14/15] nft: Fix leak when replacing a rule
Date:   Wed,  6 May 2020 19:33:30 +0200
Message-Id: <20200506173331.9347-15-phil@nwl.cc>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200506173331.9347-1-phil@nwl.cc>
References: <20200506173331.9347-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If nft_rule_append() is called with a reference rule, it is supposed to
insert the new rule at the reference position and then remove the
reference from cache. Instead, it removed the new rule from cache again
right after inserting it. Also, it missed to free the removed rule.

Fixes: 5ca9acf51adf9 ("xtables: Fix position of replaced rules in cache")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 01268f7859e9b..3c0daa8d42529 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1429,7 +1429,8 @@ nft_rule_append(struct nft_handle *h, const char *chain, const char *table,
 
 	if (ref) {
 		nftnl_chain_rule_insert_at(r, ref);
-		nftnl_chain_rule_del(r);
+		nftnl_chain_rule_del(ref);
+		nftnl_rule_free(ref);
 	} else {
 		c = nft_chain_find(h, table, chain);
 		if (!c) {
-- 
2.25.1

