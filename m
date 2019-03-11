Return-Path: <SRS0=8PdD=RO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84479C10F06
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Mar 2019 22:50:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55FA92087C
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Mar 2019 22:50:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbfCKWur (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 Mar 2019 18:50:47 -0400
Received: from mail.us.es ([193.147.175.20]:34594 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726456AbfCKWur (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Mar 2019 18:50:47 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 34887209923
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Mar 2019 23:50:44 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 25015D1901
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Mar 2019 23:50:44 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 189DFDA38C; Mon, 11 Mar 2019 23:50:44 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 015A0DA846;
        Mon, 11 Mar 2019 23:50:42 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 11 Mar 2019 23:50:42 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id CAFDA4265A2F;
        Mon, 11 Mar 2019 23:50:41 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 3/5] netfilter: nf_tables: bogus EBUSY when deleting set after flush
Date:   Mon, 11 Mar 2019 23:50:33 +0100
Message-Id: <20190311225035.21250-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190311225035.21250-1-pablo@netfilter.org>
References: <20190311225035.21250-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Set deletion after flush coming in the same batch results in EBUSY. Add
set use counter to track the number of references to this set from
rules. We cannot rely on the list of bindings for this since such list
is still populated from the preparation phase.

Reported-by: Václav Zindulka <vaclav.zindulka@tlapnet.cz>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  6 ++++++
 net/netfilter/nf_tables_api.c     | 28 +++++++++++++++++++++++++++-
 net/netfilter/nft_dynset.c        | 13 +++++++++----
 net/netfilter/nft_lookup.c        | 13 +++++++++----
 net/netfilter/nft_objref.c        | 13 +++++++++----
 5 files changed, 60 insertions(+), 13 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index ed0687b0e0f4..3e9ab643eedf 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -382,6 +382,7 @@ void nft_unregister_set(struct nft_set_type *type);
  * 	@dtype: data type (verdict or numeric type defined by userspace)
  * 	@objtype: object type (see NFT_OBJECT_* definitions)
  * 	@size: maximum set size
+ *	@use: number of rules references to this set
  * 	@nelems: number of elements
  * 	@ndeact: number of deactivated elements queued for removal
  *	@timeout: default timeout value in jiffies
@@ -407,6 +408,7 @@ struct nft_set {
 	u32				dtype;
 	u32				objtype;
 	u32				size;
+	u32				use;
 	atomic_t			nelems;
 	u32				ndeact;
 	u64				timeout;
@@ -467,6 +469,10 @@ struct nft_set_binding {
 	u32				flags;
 };
 
+enum nft_trans_phase;
+void nf_tables_deactivate_set(const struct nft_ctx *ctx, struct nft_set *set,
+			      struct nft_set_binding *binding,
+			      enum nft_trans_phase phase);
 int nf_tables_bind_set(const struct nft_ctx *ctx, struct nft_set *set,
 		       struct nft_set_binding *binding);
 void nf_tables_unbind_set(const struct nft_ctx *ctx, struct nft_set *set,
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 1333bf97dc26..ca09ef037ca5 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3672,6 +3672,9 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 
 static void nft_set_destroy(struct nft_set *set)
 {
+	if (WARN_ON(set->use > 0))
+		return;
+
 	set->ops->destroy(set);
 	module_put(to_set_type(set->ops)->owner);
 	kfree(set->name);
@@ -3712,7 +3715,7 @@ static int nf_tables_delset(struct net *net, struct sock *nlsk,
 		NL_SET_BAD_ATTR(extack, attr);
 		return PTR_ERR(set);
 	}
-	if (!list_empty(&set->bindings) ||
+	if (set->use ||
 	    (nlh->nlmsg_flags & NLM_F_NONREC && atomic_read(&set->nelems) > 0)) {
 		NL_SET_BAD_ATTR(extack, attr);
 		return -EBUSY;
@@ -3742,6 +3745,9 @@ int nf_tables_bind_set(const struct nft_ctx *ctx, struct nft_set *set,
 	struct nft_set_binding *i;
 	struct nft_set_iter iter;
 
+	if (set->use == UINT_MAX)
+		return -EOVERFLOW;
+
 	if (!list_empty(&set->bindings) && nft_set_is_anonymous(set))
 		return -EBUSY;
 
@@ -3769,6 +3775,7 @@ int nf_tables_bind_set(const struct nft_ctx *ctx, struct nft_set *set,
 	binding->chain = ctx->chain;
 	list_add_tail_rcu(&binding->list, &set->bindings);
 	nft_set_trans_bind(ctx, set);
+	set->use++;
 
 	return 0;
 }
@@ -3788,6 +3795,25 @@ void nf_tables_unbind_set(const struct nft_ctx *ctx, struct nft_set *set,
 }
 EXPORT_SYMBOL_GPL(nf_tables_unbind_set);
 
+void nf_tables_deactivate_set(const struct nft_ctx *ctx, struct nft_set *set,
+			      struct nft_set_binding *binding,
+			      enum nft_trans_phase phase)
+{
+	switch (phase) {
+	case NFT_TRANS_PREPARE:
+		set->use--;
+		return;
+	case NFT_TRANS_ABORT:
+	case NFT_TRANS_RELEASE:
+		set->use--;
+		/* fall through */
+	default:
+		nf_tables_unbind_set(ctx, set, binding,
+				     phase == NFT_TRANS_COMMIT);
+	}
+}
+EXPORT_SYMBOL_GPL(nf_tables_deactivate_set);
+
 void nf_tables_destroy_set(const struct nft_ctx *ctx, struct nft_set *set)
 {
 	if (list_empty(&set->bindings) && nft_set_is_anonymous(set))
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index a8a74a16f9c4..e461007558e8 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -240,11 +240,15 @@ static void nft_dynset_deactivate(const struct nft_ctx *ctx,
 {
 	struct nft_dynset *priv = nft_expr_priv(expr);
 
-	if (phase == NFT_TRANS_PREPARE)
-		return;
+	nf_tables_deactivate_set(ctx, priv->set, &priv->binding, phase);
+}
+
+static void nft_dynset_activate(const struct nft_ctx *ctx,
+				const struct nft_expr *expr)
+{
+	struct nft_dynset *priv = nft_expr_priv(expr);
 
-	nf_tables_unbind_set(ctx, priv->set, &priv->binding,
-			     phase == NFT_TRANS_COMMIT);
+	priv->set->use++;
 }
 
 static void nft_dynset_destroy(const struct nft_ctx *ctx,
@@ -292,6 +296,7 @@ static const struct nft_expr_ops nft_dynset_ops = {
 	.eval		= nft_dynset_eval,
 	.init		= nft_dynset_init,
 	.destroy	= nft_dynset_destroy,
+	.activate	= nft_dynset_activate,
 	.deactivate	= nft_dynset_deactivate,
 	.dump		= nft_dynset_dump,
 };
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index 14496da5141d..161c3451a747 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -127,11 +127,15 @@ static void nft_lookup_deactivate(const struct nft_ctx *ctx,
 {
 	struct nft_lookup *priv = nft_expr_priv(expr);
 
-	if (phase == NFT_TRANS_PREPARE)
-		return;
+	nf_tables_deactivate_set(ctx, priv->set, &priv->binding, phase);
+}
+
+static void nft_lookup_activate(const struct nft_ctx *ctx,
+				const struct nft_expr *expr)
+{
+	struct nft_lookup *priv = nft_expr_priv(expr);
 
-	nf_tables_unbind_set(ctx, priv->set, &priv->binding,
-			     phase == NFT_TRANS_COMMIT);
+	priv->set->use++;
 }
 
 static void nft_lookup_destroy(const struct nft_ctx *ctx,
@@ -222,6 +226,7 @@ static const struct nft_expr_ops nft_lookup_ops = {
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_lookup)),
 	.eval		= nft_lookup_eval,
 	.init		= nft_lookup_init,
+	.activate	= nft_lookup_activate,
 	.deactivate	= nft_lookup_deactivate,
 	.destroy	= nft_lookup_destroy,
 	.dump		= nft_lookup_dump,
diff --git a/net/netfilter/nft_objref.c b/net/netfilter/nft_objref.c
index 79ef074c18ca..457a9ceb46af 100644
--- a/net/netfilter/nft_objref.c
+++ b/net/netfilter/nft_objref.c
@@ -162,11 +162,15 @@ static void nft_objref_map_deactivate(const struct nft_ctx *ctx,
 {
 	struct nft_objref_map *priv = nft_expr_priv(expr);
 
-	if (phase == NFT_TRANS_PREPARE)
-		return;
+	nf_tables_deactivate_set(ctx, priv->set, &priv->binding, phase);
+}
+
+static void nft_objref_map_activate(const struct nft_ctx *ctx,
+				    const struct nft_expr *expr)
+{
+	struct nft_objref_map *priv = nft_expr_priv(expr);
 
-	nf_tables_unbind_set(ctx, priv->set, &priv->binding,
-			     phase == NFT_TRANS_COMMIT);
+	priv->set->use++;
 }
 
 static void nft_objref_map_destroy(const struct nft_ctx *ctx,
@@ -183,6 +187,7 @@ static const struct nft_expr_ops nft_objref_map_ops = {
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_objref_map)),
 	.eval		= nft_objref_map_eval,
 	.init		= nft_objref_map_init,
+	.activate	= nft_objref_map_activate,
 	.deactivate	= nft_objref_map_deactivate,
 	.destroy	= nft_objref_map_destroy,
 	.dump		= nft_objref_map_dump,
-- 
2.11.0

