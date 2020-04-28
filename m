Return-Path: <SRS0=gJ4i=6M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 547CFC83006
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 12:11:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 280D3206D6
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 12:11:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbgD1MLu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Apr 2020 08:11:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726554AbgD1MLt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Apr 2020 08:11:49 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A81EC03C1A9
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 05:11:49 -0700 (PDT)
Received: from localhost ([::1]:38704 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1jTP5Y-0008AR-Ed; Tue, 28 Apr 2020 14:11:48 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 01/18] ebtables-restore: Drop custom table flush routine
Date:   Tue, 28 Apr 2020 14:09:56 +0200
Message-Id: <20200428121013.24507-2-phil@nwl.cc>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200428121013.24507-1-phil@nwl.cc>
References: <20200428121013.24507-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

At least since flushing xtables-restore doesn't fetch chains from kernel
anymore, problems with pending policy rule delete jobs can't happen
anymore.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c             | 21 ---------------------
 iptables/nft.h             |  1 -
 iptables/xtables-restore.c |  9 +--------
 3 files changed, 1 insertion(+), 30 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index cf3ab9fe239aa..468c703a1d09f 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -2985,27 +2985,6 @@ int nft_abort(struct nft_handle *h)
 	return nft_action(h, NFT_COMPAT_ABORT);
 }
 
-int nft_abort_policy_rule(struct nft_handle *h, const char *table)
-{
-	struct obj_update *n, *tmp;
-
-	list_for_each_entry_safe(n, tmp, &h->obj_list, head) {
-		if (n->type != NFT_COMPAT_RULE_APPEND &&
-		    n->type != NFT_COMPAT_RULE_DELETE)
-			continue;
-
-		if (strcmp(table,
-			   nftnl_rule_get_str(n->rule, NFTNL_RULE_TABLE)))
-			continue;
-
-		if (!nft_rule_is_policy_rule(n->rule))
-			continue;
-
-		batch_obj_del(h, n);
-	}
-	return 0;
-}
-
 int nft_compatible_revision(const char *name, uint8_t rev, int opt)
 {
 	struct mnl_socket *nl;
diff --git a/iptables/nft.h b/iptables/nft.h
index 2094b01455194..ebb4044d1a453 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -160,7 +160,6 @@ uint32_t nft_invflags2cmp(uint32_t invflags, uint32_t flag);
 int nft_commit(struct nft_handle *h);
 int nft_bridge_commit(struct nft_handle *h);
 int nft_abort(struct nft_handle *h);
-int nft_abort_policy_rule(struct nft_handle *h, const char *table);
 
 /*
  * revision compatibility.
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index c472ac9bf651b..fe7148c9fcb3f 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -484,17 +484,10 @@ int xtables_ip6_restore_main(int argc, char *argv[])
 				    argc, argv);
 }
 
-static int ebt_table_flush(struct nft_handle *h, const char *table)
-{
-	/* drop any pending policy rule add/removal jobs */
-	nft_abort_policy_rule(h, table);
-	return nft_table_flush(h, table);
-}
-
 static const struct nft_xt_restore_cb ebt_restore_cb = {
 	.commit		= nft_bridge_commit,
 	.table_new	= nft_table_new,
-	.table_flush	= ebt_table_flush,
+	.table_flush	= nft_table_flush,
 	.do_command	= do_commandeb,
 	.chain_set	= nft_chain_set,
 	.chain_restore  = nft_chain_restore,
-- 
2.25.1

