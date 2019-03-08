Return-Path: <SRS0=0Xdd=RL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6A80C43381
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Mar 2019 14:21:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5F1A2087C
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Mar 2019 14:21:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726815AbfCHOVV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 09:21:21 -0500
Received: from mail.us.es ([193.147.175.20]:54758 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726299AbfCHOVU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 09:21:20 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B88D15E538C
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Mar 2019 15:21:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A8C3EDA84C
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Mar 2019 15:21:18 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9E129DA867; Fri,  8 Mar 2019 15:21:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7BF57DA84C;
        Fri,  8 Mar 2019 15:21:16 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 08 Mar 2019 15:21:16 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 51DA44265A2F;
        Fri,  8 Mar 2019 15:21:16 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, vaclav.zindulka@tlapnet.cz
Subject: [PATCH nf,v2] netfilter: nf_tables: bogus EBUSY when deleting set after flush
Date:   Fri,  8 Mar 2019 15:21:12 +0100
Message-Id: <20190308142112.19551-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
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
v2: object maps also need an update.

 include/net/netfilter/nf_tables.h |  2 ++
 net/netfilter/nf_tables_api.c     |  2 +-
 net/netfilter/nft_lookup.c        | 17 ++++++++++++++++-
 net/netfilter/nft_objref.c        | 17 ++++++++++++++++-
 4 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 3d58acf94dd2..d594ad758219 100644
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
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index e1724f9d8b9d..282373d7c083 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3654,7 +3654,7 @@ static int nf_tables_delset(struct net *net, struct sock *nlsk,
 		NL_SET_BAD_ATTR(extack, attr);
 		return PTR_ERR(set);
 	}
-	if (!list_empty(&set->bindings) ||
+	if (set->use ||
 	    (nlh->nlmsg_flags & NLM_F_NONREC && atomic_read(&set->nelems) > 0)) {
 		NL_SET_BAD_ATTR(extack, attr);
 		return -EBUSY;
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index 14496da5141d..ac65f1a4e076 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -111,12 +111,16 @@ static int nft_lookup_init(const struct nft_ctx *ctx,
 	} else if (set->flags & NFT_SET_MAP)
 		return -EINVAL;
 
+	if (set->use == UINT_MAX)
+		return -EOVERFLOW;
+
 	priv->binding.flags = set->flags & NFT_SET_MAP;
 
 	err = nf_tables_bind_set(ctx, set, &priv->binding);
 	if (err < 0)
 		return err;
 
+	set->use++;
 	priv->set = set;
 	return 0;
 }
@@ -127,13 +131,23 @@ static void nft_lookup_deactivate(const struct nft_ctx *ctx,
 {
 	struct nft_lookup *priv = nft_expr_priv(expr);
 
-	if (phase == NFT_TRANS_PREPARE)
+	if (phase == NFT_TRANS_PREPARE) {
+		priv->set->use--;
 		return;
+	}
 
 	nf_tables_unbind_set(ctx, priv->set, &priv->binding,
 			     phase == NFT_TRANS_COMMIT);
 }
 
+static void nft_lookup_activate(const struct nft_ctx *ctx,
+				const struct nft_expr *expr)
+{
+	struct nft_lookup *priv = nft_expr_priv(expr);
+
+	priv->set->use++;
+}
+
 static void nft_lookup_destroy(const struct nft_ctx *ctx,
 			       const struct nft_expr *expr)
 {
@@ -222,6 +236,7 @@ static const struct nft_expr_ops nft_lookup_ops = {
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_lookup)),
 	.eval		= nft_lookup_eval,
 	.init		= nft_lookup_init,
+	.activate	= nft_lookup_activate,
 	.deactivate	= nft_lookup_deactivate,
 	.destroy	= nft_lookup_destroy,
 	.dump		= nft_lookup_dump,
diff --git a/net/netfilter/nft_objref.c b/net/netfilter/nft_objref.c
index ae178e914486..ee22698f2711 100644
--- a/net/netfilter/nft_objref.c
+++ b/net/netfilter/nft_objref.c
@@ -131,12 +131,16 @@ static int nft_objref_map_init(const struct nft_ctx *ctx,
 	if (err < 0)
 		return err;
 
+	if (set->use == UINT_MAX)
+		return -EOVERFLOW;
+
 	priv->binding.flags = set->flags & NFT_SET_OBJECT;
 
 	err = nf_tables_bind_set(ctx, set, &priv->binding);
 	if (err < 0)
 		return err;
 
+	set->use++;
 	priv->set = set;
 	return 0;
 }
@@ -161,13 +165,23 @@ static void nft_objref_map_deactivate(const struct nft_ctx *ctx,
 {
 	struct nft_objref_map *priv = nft_expr_priv(expr);
 
-	if (phase == NFT_TRANS_PREPARE)
+	if (phase == NFT_TRANS_PREPARE) {
+		priv->set->use--;
 		return;
+	}
 
 	nf_tables_unbind_set(ctx, priv->set, &priv->binding,
 			     phase == NFT_TRANS_COMMIT);
 }
 
+static void nft_objref_map_activate(const struct nft_ctx *ctx,
+				    const struct nft_expr *expr)
+{
+	struct nft_objref_map *priv = nft_expr_priv(expr);
+
+	priv->set->use++;
+}
+
 static void nft_objref_map_destroy(const struct nft_ctx *ctx,
 				   const struct nft_expr *expr)
 {
@@ -182,6 +196,7 @@ static const struct nft_expr_ops nft_objref_map_ops = {
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_objref_map)),
 	.eval		= nft_objref_map_eval,
 	.init		= nft_objref_map_init,
+	.activate	= nft_objref_map_activate,
 	.deactivate	= nft_objref_map_deactivate,
 	.destroy	= nft_objref_map_destroy,
 	.dump		= nft_objref_map_dump,
-- 
2.11.0

