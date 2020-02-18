Return-Path: <SRS0=aYEw=4G=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 526D0C34038
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Feb 2020 10:59:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 366EF206E2
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Feb 2020 10:59:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbgBRK7n (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Feb 2020 05:59:43 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:45184 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726411AbgBRK7m (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Feb 2020 05:59:42 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1j40bM-0002n8-JS; Tue, 18 Feb 2020 11:59:40 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2 2/2] netfilter: nf_tables: make all set structs const
Date:   Tue, 18 Feb 2020 11:59:27 +0100
Message-Id: <20200218105927.4685-3-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200218105927.4685-1-fw@strlen.de>
References: <20200218105927.4685-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

They do not need to be writeable anymore.

v2: remove left-over __read_mostly annotation in set_pipapo.c (Stefano)

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_tables.h      |  4 ----
 include/net/netfilter/nf_tables_core.h | 12 ++++++------
 net/netfilter/nf_tables_api.c          | 14 ++------------
 net/netfilter/nft_set_bitmap.c         |  3 +--
 net/netfilter/nft_set_hash.c           |  9 +++------
 net/netfilter/nft_set_pipapo.c         |  3 +--
 net/netfilter/nft_set_rbtree.c         |  3 +--
 7 files changed, 14 insertions(+), 34 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 9a5f41028736..d913cdb6a27b 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -385,14 +385,10 @@ struct nft_set_ops {
  *      struct nft_set_type - nf_tables set type
  *
  *      @ops: set ops for this type
- *      @list: used internally
- *      @owner: module reference
  *      @features: features supported by the implementation
  */
 struct nft_set_type {
 	const struct nft_set_ops	ops;
-	struct list_head		list;
-	struct module			*owner;
 	u32				features;
 };
 #define to_set_type(o) container_of(o, struct nft_set_type, ops)
diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index 29e7e1021267..3e30cc5d195b 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -69,12 +69,12 @@ extern const struct nft_expr_ops nft_payload_fast_ops;
 extern struct static_key_false nft_counters_enabled;
 extern struct static_key_false nft_trace_enabled;
 
-extern struct nft_set_type nft_set_rhash_type;
-extern struct nft_set_type nft_set_hash_type;
-extern struct nft_set_type nft_set_hash_fast_type;
-extern struct nft_set_type nft_set_rbtree_type;
-extern struct nft_set_type nft_set_bitmap_type;
-extern struct nft_set_type nft_set_pipapo_type;
+extern const struct nft_set_type nft_set_rhash_type;
+extern const struct nft_set_type nft_set_hash_type;
+extern const struct nft_set_type nft_set_hash_fast_type;
+extern const struct nft_set_type nft_set_rbtree_type;
+extern const struct nft_set_type nft_set_bitmap_type;
+extern const struct nft_set_type nft_set_pipapo_type;
 
 struct nft_expr;
 struct nft_regs;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 28add8f24191..0cd41e42df81 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3339,11 +3339,6 @@ nft_select_set_ops(const struct nft_ctx *ctx,
 			break;
 		}
 
-		if (!try_module_get(type->owner))
-			continue;
-		if (bops != NULL)
-			module_put(to_set_type(bops)->owner);
-
 		bops = ops;
 		best = est;
 	}
@@ -4042,10 +4037,8 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 		size = ops->privsize(nla, &desc);
 
 	set = kvzalloc(sizeof(*set) + size + udlen, GFP_KERNEL);
-	if (!set) {
-		err = -ENOMEM;
-		goto err1;
-	}
+	if (!set)
+		return -ENOMEM;
 
 	name = nla_strdup(nla[NFTA_SET_NAME], GFP_KERNEL);
 	if (!name) {
@@ -4104,8 +4097,6 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 	kfree(set->name);
 err2:
 	kvfree(set);
-err1:
-	module_put(to_set_type(ops)->owner);
 	return err;
 }
 
@@ -4115,7 +4106,6 @@ static void nft_set_destroy(struct nft_set *set)
 		return;
 
 	set->ops->destroy(set);
-	module_put(to_set_type(set->ops)->owner);
 	kfree(set->name);
 	kvfree(set);
 }
diff --git a/net/netfilter/nft_set_bitmap.c b/net/netfilter/nft_set_bitmap.c
index 87e8d9ba0c9b..1cb2e67e6e03 100644
--- a/net/netfilter/nft_set_bitmap.c
+++ b/net/netfilter/nft_set_bitmap.c
@@ -293,8 +293,7 @@ static bool nft_bitmap_estimate(const struct nft_set_desc *desc, u32 features,
 	return true;
 }
 
-struct nft_set_type nft_set_bitmap_type __read_mostly = {
-	.owner		= THIS_MODULE,
+const struct nft_set_type nft_set_bitmap_type = {
 	.ops		= {
 		.privsize	= nft_bitmap_privsize,
 		.elemsize	= offsetof(struct nft_bitmap_elem, ext),
diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index d350a7cd3af0..4d3f147e8d8d 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -662,8 +662,7 @@ static bool nft_hash_fast_estimate(const struct nft_set_desc *desc, u32 features
 	return true;
 }
 
-struct nft_set_type nft_set_rhash_type __read_mostly = {
-	.owner		= THIS_MODULE,
+const struct nft_set_type nft_set_rhash_type = {
 	.features	= NFT_SET_MAP | NFT_SET_OBJECT |
 			  NFT_SET_TIMEOUT | NFT_SET_EVAL,
 	.ops		= {
@@ -686,8 +685,7 @@ struct nft_set_type nft_set_rhash_type __read_mostly = {
 	},
 };
 
-struct nft_set_type nft_set_hash_type __read_mostly = {
-	.owner		= THIS_MODULE,
+const struct nft_set_type nft_set_hash_type = {
 	.features	= NFT_SET_MAP | NFT_SET_OBJECT,
 	.ops		= {
 		.privsize       = nft_hash_privsize,
@@ -706,8 +704,7 @@ struct nft_set_type nft_set_hash_type __read_mostly = {
 	},
 };
 
-struct nft_set_type nft_set_hash_fast_type __read_mostly = {
-	.owner		= THIS_MODULE,
+const struct nft_set_type nft_set_hash_fast_type = {
 	.features	= NFT_SET_MAP | NFT_SET_OBJECT,
 	.ops		= {
 		.privsize       = nft_hash_privsize,
diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index f0cb1e13af50..f7f75f618a04 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -2079,8 +2079,7 @@ static void nft_pipapo_gc_init(const struct nft_set *set)
 	priv->last_gc = jiffies;
 }
 
-struct nft_set_type nft_set_pipapo_type __read_mostly = {
-	.owner		= THIS_MODULE,
+const struct nft_set_type nft_set_pipapo_type = {
 	.features	= NFT_SET_INTERVAL | NFT_SET_MAP | NFT_SET_OBJECT |
 			  NFT_SET_TIMEOUT,
 	.ops		= {
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 5000b938ab1e..172ef8189f99 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -481,8 +481,7 @@ static bool nft_rbtree_estimate(const struct nft_set_desc *desc, u32 features,
 	return true;
 }
 
-struct nft_set_type nft_set_rbtree_type __read_mostly = {
-	.owner		= THIS_MODULE,
+const struct nft_set_type nft_set_rbtree_type = {
 	.features	= NFT_SET_INTERVAL | NFT_SET_MAP | NFT_SET_OBJECT | NFT_SET_TIMEOUT,
 	.ops		= {
 		.privsize	= nft_rbtree_privsize,
-- 
2.24.1

