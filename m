Return-Path: <SRS0=4pKc=6U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D144FC28CBC
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 May 2020 17:34:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2433208DB
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 May 2020 17:34:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729460AbgEFReI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 May 2020 13:34:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728047AbgEFReI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 May 2020 13:34:08 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34A76C061A0F
        for <netfilter-devel@vger.kernel.org>; Wed,  6 May 2020 10:34:08 -0700 (PDT)
Received: from localhost ([::1]:58720 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1jWNvr-0002ka-1v; Wed, 06 May 2020 19:34:07 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 08/15] nft: Fix leaks in ebt_add_policy_rule()
Date:   Wed,  6 May 2020 19:33:24 +0200
Message-Id: <20200506173331.9347-9-phil@nwl.cc>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200506173331.9347-1-phil@nwl.cc>
References: <20200506173331.9347-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The function leaked memory allocated in temporary struct
iptables_command_state, clean it immediately after use.

In any of the udata-related error cases, allocated nftnl_rule would
leak, fix this by introducing a common error path to goto.

In regular code path, the allocated nftnl_rule would still leak:
batch_obj_del() does not free rules in NFT_COMPAT_RULE_APPEND jobs, as
they typically sit in cache as well. Policy rules in turn weren't added
to cache: They are created immediately before commit and never
referenced from other rules. Add them now so they are freed just like
regular rules.

Fixes: aff1162b3e4b7 ("ebtables-nft: Support user-defined chain policies")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index addde1b53f37e..c0b5e2fc524a7 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -2970,27 +2970,33 @@ static int ebt_add_policy_rule(struct nftnl_chain *c, void *data)
 
 	r = nft_rule_new(h, nftnl_chain_get_str(c, NFTNL_CHAIN_NAME),
 			 nftnl_chain_get_str(c, NFTNL_CHAIN_TABLE), &cs);
+	ebt_cs_clean(&cs);
+
 	if (!r)
 		return -1;
 
 	udata = nftnl_udata_buf_alloc(NFT_USERDATA_MAXLEN);
 	if (!udata)
-		return -1;
+		goto err_free_rule;
 
 	if (!nftnl_udata_put_u32(udata, UDATA_TYPE_EBTABLES_POLICY, 1))
-		return -1;
+		goto err_free_rule;
 
 	nftnl_rule_set_data(r, NFTNL_RULE_USERDATA,
 			    nftnl_udata_buf_data(udata),
 			    nftnl_udata_buf_len(udata));
 	nftnl_udata_buf_free(udata);
 
-	if (!batch_rule_add(h, NFT_COMPAT_RULE_APPEND, r)) {
-		nftnl_rule_free(r);
-		return -1;
-	}
+	if (!batch_rule_add(h, NFT_COMPAT_RULE_APPEND, r))
+		goto err_free_rule;
+
+	/* add the rule to chain so it is freed later */
+	nftnl_chain_rule_add_tail(r, c);
 
 	return 0;
+err_free_rule:
+	nftnl_rule_free(r);
+	return -1;
 }
 
 int ebt_set_user_chain_policy(struct nft_handle *h, const char *table,
-- 
2.25.1

