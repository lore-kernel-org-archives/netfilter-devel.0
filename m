Return-Path: <SRS0=oAJK=BK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D696AC433DF
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 Jul 2020 16:31:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB76B2074B
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 Jul 2020 16:31:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728898AbgGaQb0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 31 Jul 2020 12:31:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726502AbgGaQb0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 31 Jul 2020 12:31:26 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C801C061574
        for <netfilter-devel@vger.kernel.org>; Fri, 31 Jul 2020 09:31:26 -0700 (PDT)
Received: from localhost ([::1]:33148 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1k1XwJ-0006TC-4x; Fri, 31 Jul 2020 18:31:23 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] nft: Fix for ruleset flush while restoring
Date:   Fri, 31 Jul 2020 18:31:25 +0200
Message-Id: <20200731163125.7309-1-phil@nwl.cc>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If ruleset is flushed while an instance of iptables-nft-restore is
running and has seen a COMMIT line once, it doesn't notice the
disappeared table while handling the next COMMIT. This is due to table
existence being tracked via 'initialized' boolean which is only reset
by nft_table_flush().

To fix this, drop the dedicated 'initialized' boolean and switch users
to the recently introduced 'exists' one.

As a side-effect, this causes base chain existence being checked for
each command calling nft_xt_builtin_init() as the old 'initialized' bit
was used to track if that function has been called before or not.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c                                | 15 ++----------
 iptables/nft.h                                |  1 -
 .../nft-only/0007-mid-restore-flush_0         | 23 +++++++++++++++++++
 3 files changed, 25 insertions(+), 14 deletions(-)
 create mode 100755 iptables/tests/shell/testcases/nft-only/0007-mid-restore-flush_0

diff --git a/iptables/nft.c b/iptables/nft.c
index 76fd7edd11177..78dd17739d8f3 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -644,19 +644,13 @@ const struct builtin_table xtables_bridge[NFT_TABLE_MAX] = {
 	},
 };
 
-static bool nft_table_initialized(const struct nft_handle *h,
-				  enum nft_table_type type)
-{
-	return h->cache->table[type].initialized;
-}
-
 static int nft_table_builtin_add(struct nft_handle *h,
 				 const struct builtin_table *_t)
 {
 	struct nftnl_table *t;
 	int ret;
 
-	if (nft_table_initialized(h, _t->type))
+	if (h->cache->table[_t->type].exists)
 		return 0;
 
 	t = nftnl_table_alloc();
@@ -775,9 +769,6 @@ static int nft_xt_builtin_init(struct nft_handle *h, const char *table)
 	if (t == NULL)
 		return -1;
 
-	if (nft_table_initialized(h, t->type))
-		return 0;
-
 	if (nft_table_builtin_add(h, t) < 0)
 		return -1;
 
@@ -786,8 +777,6 @@ static int nft_xt_builtin_init(struct nft_handle *h, const char *table)
 
 	nft_chain_builtin_init(h, t);
 
-	h->cache->table[t->type].initialized = true;
-
 	return 0;
 }
 
@@ -1989,7 +1978,7 @@ static int __nft_table_flush(struct nft_handle *h, const char *table, bool exist
 
 	_t = nft_table_builtin_find(h, table);
 	assert(_t);
-	h->cache->table[_t->type].initialized = false;
+	h->cache->table[_t->type].exists = false;
 
 	flush_chain_cache(h, table);
 
diff --git a/iptables/nft.h b/iptables/nft.h
index f38f5812be771..128e09beb805e 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -41,7 +41,6 @@ struct nft_cache {
 	struct {
 		struct nftnl_chain_list *chains;
 		struct nftnl_set_list	*sets;
-		bool			initialized;
 		bool			exists;
 	} table[NFT_TABLE_MAX];
 };
diff --git a/iptables/tests/shell/testcases/nft-only/0007-mid-restore-flush_0 b/iptables/tests/shell/testcases/nft-only/0007-mid-restore-flush_0
new file mode 100755
index 0000000000000..43880ffbc5851
--- /dev/null
+++ b/iptables/tests/shell/testcases/nft-only/0007-mid-restore-flush_0
@@ -0,0 +1,23 @@
+#!/bin/bash
+
+[[ $XT_MULTI == *xtables-nft-multi ]] || { echo "skip $XT_MULTI"; exit 0; }
+nft -v >/dev/null || { echo "skip $XT_MULTI (no nft)"; exit 0; }
+
+coproc $XT_MULTI iptables-restore --noflush
+
+cat >&"${COPROC[1]}" <<EOF
+*filter
+:foo [0:0]
+COMMIT
+*filter
+:foo [0:0]
+EOF
+
+$XT_MULTI iptables-save | grep -q ':foo'
+nft flush ruleset
+
+echo "COMMIT" >&"${COPROC[1]}"
+sleep 1
+
+[[ -n $COPROC_PID ]] && kill $COPROC_PID
+wait
-- 
2.27.0

