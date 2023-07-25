Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0786CC04E69
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jul 2023 11:26:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234565AbjGYL04 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Jul 2023 07:26:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234575AbjGYL0y (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Jul 2023 07:26:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D32313D;
        Tue, 25 Jul 2023 04:26:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 702D66168E;
        Tue, 25 Jul 2023 11:26:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BDF0C433C7;
        Tue, 25 Jul 2023 11:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1690284411;
        bh=Xbti8q72A3/BNyfNG+BzxbimULA3PDI6eruabP8UoOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yroxO/vszjOQm+UJe3Ay4vv2ituRpcJmGhrMzoUa0BA8CKfZL9x4zRnElampoyOIz
         iE2TlJaYH6T+fU8CihqYgo0isI/hupDMGm5I8+NX8XTVP4ZWHFJeDBlZxK7+AJ1iK8
         155+RRKUyZBLs9u1RHRdXFYq+OkdpMZWomit4KCw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org, netfilter-devel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.10 317/509] netfilter: nf_tables: reject unbound anonymous set before commit phase
Date:   Tue, 25 Jul 2023 12:44:16 +0200
Message-ID: <20230725104608.229411172@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 938154b93be8cd611ddfd7bafc1849f3c4355201 ]

Add a new list to track set transaction and to check for unbound
anonymous sets before entering the commit phase.

Bail out at the end of the transaction handling if an anonymous set
remains unbound.

Fixes: 96518518cc41 ("netfilter: add nftables")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/netfilter/nf_tables.h |    3 +++
 net/netfilter/nf_tables_api.c     |   34 +++++++++++++++++++++++++++++++---
 2 files changed, 34 insertions(+), 3 deletions(-)

--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1426,6 +1426,7 @@ static inline void nft_set_elem_clear_bu
  *	struct nft_trans - nf_tables object update in transaction
  *
  *	@list: used internally
+ *	@binding_list: list of objects with possible bindings
  *	@msg_type: message type
  *	@put_net: ctx->net needs to be put
  *	@ctx: transaction context
@@ -1433,6 +1434,7 @@ static inline void nft_set_elem_clear_bu
  */
 struct nft_trans {
 	struct list_head		list;
+	struct list_head		binding_list;
 	int				msg_type;
 	bool				put_net;
 	struct nft_ctx			ctx;
@@ -1559,6 +1561,7 @@ __be64 nf_jiffies64_to_msecs(u64 input);
 struct nftables_pernet {
 	struct list_head	tables;
 	struct list_head	commit_list;
+	struct list_head	binding_list;
 	struct list_head	module_list;
 	struct list_head	notify_list;
 	struct mutex		commit_mutex;
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -155,6 +155,7 @@ static struct nft_trans *nft_trans_alloc
 		return NULL;
 
 	INIT_LIST_HEAD(&trans->list);
+	INIT_LIST_HEAD(&trans->binding_list);
 	trans->msg_type = msg_type;
 	trans->ctx	= *ctx;
 
@@ -167,9 +168,15 @@ static struct nft_trans *nft_trans_alloc
 	return nft_trans_alloc_gfp(ctx, msg_type, size, GFP_KERNEL);
 }
 
-static void nft_trans_destroy(struct nft_trans *trans)
+static void nft_trans_list_del(struct nft_trans *trans)
 {
 	list_del(&trans->list);
+	list_del(&trans->binding_list);
+}
+
+static void nft_trans_destroy(struct nft_trans *trans)
+{
+	nft_trans_list_del(trans);
 	kfree(trans);
 }
 
@@ -347,6 +354,14 @@ static void nft_trans_commit_list_add_ta
 	struct nftables_pernet *nft_net;
 
 	nft_net = net_generic(net, nf_tables_net_id);
+
+	switch (trans->msg_type) {
+	case NFT_MSG_NEWSET:
+		if (nft_set_is_anonymous(nft_trans_set(trans)))
+			list_add_tail(&trans->binding_list, &nft_net->binding_list);
+		break;
+	}
+
 	list_add_tail(&trans->list, &nft_net->commit_list);
 }
 
@@ -7717,7 +7732,7 @@ static void nf_tables_trans_destroy_work
 	synchronize_rcu();
 
 	list_for_each_entry_safe(trans, next, &head, list) {
-		list_del(&trans->list);
+		nft_trans_list_del(trans);
 		nft_commit_release(trans);
 	}
 }
@@ -8019,6 +8034,18 @@ static int nf_tables_commit(struct net *
 		return 0;
 	}
 
+	list_for_each_entry(trans, &nft_net->binding_list, binding_list) {
+		switch (trans->msg_type) {
+		case NFT_MSG_NEWSET:
+			if (nft_set_is_anonymous(nft_trans_set(trans)) &&
+			    !nft_trans_set_bound(trans)) {
+				pr_warn_once("nftables ruleset with unbound set\n");
+				return -EINVAL;
+			}
+			break;
+		}
+	}
+
 	/* 0. Validate ruleset, otherwise roll back for error reporting. */
 	if (nf_tables_validate(net) < 0)
 		return -EAGAIN;
@@ -8421,7 +8448,7 @@ static int __nf_tables_abort(struct net
 
 	list_for_each_entry_safe_reverse(trans, next,
 					 &nft_net->commit_list, list) {
-		list_del(&trans->list);
+		nft_trans_list_del(trans);
 		nf_tables_abort_release(trans);
 	}
 
@@ -9120,6 +9147,7 @@ static int __net_init nf_tables_init_net
 
 	INIT_LIST_HEAD(&nft_net->tables);
 	INIT_LIST_HEAD(&nft_net->commit_list);
+	INIT_LIST_HEAD(&nft_net->binding_list);
 	INIT_LIST_HEAD(&nft_net->module_list);
 	INIT_LIST_HEAD(&nft_net->notify_list);
 	mutex_init(&nft_net->commit_mutex);


