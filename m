Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13D96C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Sep 2021 16:06:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF66760560
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Sep 2021 16:06:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236321AbhIVQIS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Sep 2021 12:08:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232357AbhIVQIR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Sep 2021 12:08:17 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A27BCC061574
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Sep 2021 09:06:47 -0700 (PDT)
Received: from localhost ([::1]:59552 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mT4li-0006PS-2D; Wed, 22 Sep 2021 18:06:46 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 4/4] nft: Delete builtin chains compatibly
Date:   Wed, 22 Sep 2021 18:06:32 +0200
Message-Id: <20210922160632.15635-5-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210922160632.15635-1-phil@nwl.cc>
References: <20210922160632.15635-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Attempting to delete all chains if --delete-chain is called without
argument has unwanted side-effects especially legacy iptables users are
not aware of and won't expect:

* Non-default policies are ignored, a previously dropping firewall may
  start accepting traffic.

* The kernel refuses to remove non-empty chains, causing program abort
  even if no user-defined chain exists.

Fix this by requiring a rule cache in that situation and make builtin
chain deletion depend on its policy and number of rules. Since this may
change concurrently, check again when having to refresh the transaction.

Also, hide builtin chains from verbose output - their creation is
implicit, so treat their removal as implicit, too.

When deleting a specific chain, do not allow to skip the job though.
Otherwise deleting a builtin chain which is still in use will succeed
although not executed.

Fixes: 61e85e3192dea ("iptables-nft: allow removal of empty builtin chains")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-cmd.c                            |  2 +-
 iptables/nft.c                                | 39 +++++++++++++++----
 .../shell/testcases/chain/0005base-delete_0   | 34 ++++++++++++++++
 3 files changed, 66 insertions(+), 9 deletions(-)
 create mode 100755 iptables/tests/shell/testcases/chain/0005base-delete_0

diff --git a/iptables/nft-cmd.c b/iptables/nft-cmd.c
index 2d874bd41e8f6..fcd01bd02831c 100644
--- a/iptables/nft-cmd.c
+++ b/iptables/nft-cmd.c
@@ -220,7 +220,7 @@ int nft_cmd_chain_del(struct nft_handle *h, const char *chain,
 	/* This triggers nft_bridge_chain_postprocess() when fetching the
 	 * rule cache.
 	 */
-	if (h->family == NFPROTO_BRIDGE)
+	if (h->family == NFPROTO_BRIDGE || !chain)
 		nft_cache_level_set(h, NFT_CL_RULES, cmd);
 	else
 		nft_cache_level_set(h, NFT_CL_CHAINS, cmd);
diff --git a/iptables/nft.c b/iptables/nft.c
index 381061473047f..dc1f5160eb983 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1838,26 +1838,46 @@ int nft_chain_restore(struct nft_handle *h, const char *chain, const char *table
 
 struct chain_del_data {
 	struct nft_handle	*handle;
+	const char		*chain;
 	bool			verbose;
 };
 
+static bool nft_may_delete_chain(struct nftnl_chain *c)
+{
+	if (nftnl_chain_is_set(c, NFTNL_CHAIN_POLICY) &&
+	    nftnl_chain_get_u32(c, NFTNL_CHAIN_POLICY) != NF_ACCEPT)
+		return false;
+
+	return nftnl_rule_lookup_byindex(c, 0) == NULL;
+}
+
 static int __nft_chain_del(struct nft_chain *nc, void *data)
 {
 	struct chain_del_data *d = data;
 	struct nftnl_chain *c = nc->nftnl;
 	struct nft_handle *h = d->handle;
+	bool builtin = nft_chain_builtin(c);
+	struct obj_update *obj;
+	int ret = 0;
 
-	if (d->verbose)
+	if (d->verbose && !builtin)
 		fprintf(stdout, "Deleting chain `%s'\n",
 			nftnl_chain_get_str(c, NFTNL_CHAIN_NAME));
 
 
 	/* XXX This triggers a fast lookup from the kernel. */
 	nftnl_chain_unset(c, NFTNL_CHAIN_HANDLE);
-	if (!batch_chain_add(h, NFT_COMPAT_CHAIN_DEL, c))
+	obj = batch_chain_add(h, NFT_COMPAT_CHAIN_DEL, c);
+	if (!obj)
 		return -1;
 
-	if (nft_chain_builtin(c)) {
+	if (builtin) {
+		obj->skip = !nft_may_delete_chain(c);
+		if (obj->skip && d->chain) {
+			/* complain if explicitly requested */
+			errno = EBUSY;
+			ret = -1;
+		}
 		*nc->base_slot = NULL;
 	}
 
@@ -1866,14 +1886,15 @@ static int __nft_chain_del(struct nft_chain *nc, void *data)
 
 	nft_chain_list_del(nc);
 	nft_chain_free(nc);
-	return 0;
+	return ret;
 }
 
 int nft_chain_del(struct nft_handle *h, const char *chain,
-		       const char *table, bool verbose)
+		  const char *table, bool verbose)
 {
 	struct chain_del_data d = {
 		.handle = h,
+		.chain = chain,
 		.verbose = verbose,
 	};
 	struct nft_chain *c;
@@ -1889,8 +1910,6 @@ int nft_chain_del(struct nft_handle *h, const char *chain,
 		}
 
 		ret = __nft_chain_del(c, &d);
-		if (ret == -2)
-			errno = EINVAL;
 		goto out;
 	}
 
@@ -2744,10 +2763,14 @@ static void nft_refresh_transaction(struct nft_handle *h)
 
 			n->skip = !nft_chain_find(h, tablename, chainname);
 			break;
+		case NFT_COMPAT_CHAIN_DEL:
+			if (!nftnl_chain_get(n->chain, NFTNL_CHAIN_HOOKNUM))
+				break;
+			n->skip = !nft_may_delete_chain(n->chain);
+			break;
 		case NFT_COMPAT_TABLE_ADD:
 		case NFT_COMPAT_CHAIN_ADD:
 		case NFT_COMPAT_CHAIN_ZERO:
-		case NFT_COMPAT_CHAIN_DEL:
 		case NFT_COMPAT_CHAIN_USER_FLUSH:
 		case NFT_COMPAT_CHAIN_UPDATE:
 		case NFT_COMPAT_CHAIN_RENAME:
diff --git a/iptables/tests/shell/testcases/chain/0005base-delete_0 b/iptables/tests/shell/testcases/chain/0005base-delete_0
new file mode 100755
index 0000000000000..033a28191d115
--- /dev/null
+++ b/iptables/tests/shell/testcases/chain/0005base-delete_0
@@ -0,0 +1,34 @@
+#!/bin/bash -x
+
+$XT_MULTI iptables -N foo || exit 1
+$XT_MULTI iptables -P FORWARD DROP || exit 1
+$XT_MULTI iptables -X || exit 1
+$XT_MULTI iptables -X foo && exit 1
+
+# indefinite -X fails if a non-empty user-defined chain exists
+$XT_MULTI iptables -N foo
+$XT_MULTI iptables -N bar
+$XT_MULTI iptables -A bar -j ACCEPT
+$XT_MULTI iptables -X && exit 1
+$XT_MULTI iptables -D bar -j ACCEPT
+$XT_MULTI iptables -X || exit 1
+
+# make sure OUTPUT chain is created by iptables-nft
+$XT_MULTI iptables -A OUTPUT -j ACCEPT || exit 1
+$XT_MULTI iptables -D OUTPUT -j ACCEPT || exit 1
+
+case $XT_MULTI in
+*xtables-nft-multi)
+	# must not delete chain FORWARD, its policy is not ACCEPT
+	$XT_MULTI iptables -X FORWARD && exit 1
+	nft list chain ip filter FORWARD || exit 1
+	# this should evict chain OUTPUT
+	$XT_MULTI iptables -X OUTPUT || exit 1
+	nft list chain ip filter OUTPUT && exit 1
+	;;
+*)
+	$XT_MULTI iptables -X FORWARD && exit 1
+	$XT_MULTI iptables -X OUTPUT && exit 1
+	;;
+esac
+exit 0
-- 
2.33.0

