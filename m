From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 4/4] netfilter: nf_tables: revisit chain/object refcounting from elements
Date: Fri, 28 Apr 2017 15:47:27 +0200
Message-ID: <1493387247-8323-1-git-send-email-pablo@netfilter.org>
Cc: aschultz@tpip.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57176 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1423414AbdD1Nrp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Apr 2017 09:47:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6083820991C
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Apr 2017 15:47:38 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4F9821B52C4
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Apr 2017 15:47:38 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6E0F41B4079
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Apr 2017 15:47:35 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Andreas reports that the following incremental update using our commit
protocol doesn't work.

 # nft -f incremental-update.nft
 delete element ip filter client_to_any { 10.180.86.22 : goto CIn_1 }
 delete chain ip filter CIn_1
 ... Error: Could not process rule: Device or resource busy

The existing code is not well-integrated into the commit phase protocol,
since element deletions do not result in refcount decrement from the
preparation phase. This results in bogus EBUSY errors like the one
above.

Two new functions come with this patch:

* nft_set_elem_activate() function is used from the abort path, to
  restore the set element refcounting on objects that occurred from
  the preparation phase.

* nft_set_elem_deactivate() that is called from nft_del_setelem() to
  decrement set element refcounting on objects from the preparation
  phase in the commit protocol.

The nft_data_uninit() has been renamed to nft_data_release() since this
function does not uninitialize any data store in the data register,
instead just releases the references to objects. Moreover, a new
function nft_data_hold() has been introduced to be used from
nft_set_elem_activate().

Reported-by: Andreas Schultz <aschultz@tpip.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  2 +-
 net/netfilter/nf_tables_api.c     | 76 +++++++++++++++++++++++++++++++++++----
 net/netfilter/nft_dynset.c        |  2 +-
 net/netfilter/nft_immediate.c     |  5 +--
 4 files changed, 74 insertions(+), 11 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 1b0a2268da55..4bb15460c9d5 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -176,7 +176,7 @@ struct nft_data_desc {
 int nft_data_init(const struct nft_ctx *ctx,
 		  struct nft_data *data, unsigned int size,
 		  struct nft_data_desc *desc, const struct nlattr *nla);
-void nft_data_uninit(const struct nft_data *data, enum nft_data_types type);
+void nft_data_release(const struct nft_data *data, enum nft_data_types type);
 int nft_data_dump(struct sk_buff *skb, int attr, const struct nft_data *data,
 		  enum nft_data_types type, unsigned int len);
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f047e2d8e2c6..d6260a650b37 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3561,7 +3561,7 @@ void nft_set_elem_destroy(const struct nft_set *set, void *elem)
 	struct nft_set_ext *ext = nft_set_elem_ext(set, elem);
 
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_DATA))
-		nft_data_uninit(nft_set_ext_data(ext), set->dtype);
+		nft_data_release(nft_set_ext_data(ext), set->dtype);
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_EXPR))
 		nf_tables_expr_destroy(NULL, nft_set_ext_expr(ext));
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_OBJREF))
@@ -3570,6 +3570,18 @@ void nft_set_elem_destroy(const struct nft_set *set, void *elem)
 }
 EXPORT_SYMBOL_GPL(nft_set_elem_destroy);
 
+/* Only called from commit path, nft_data_release() already deals with the
+ * refcounting from the preparation phase.
+ */
+static void nf_tables_set_elem_destroy(const struct nft_set *set, void *elem)
+{
+	struct nft_set_ext *ext = nft_set_elem_ext(set, elem);
+
+	if (nft_set_ext_exists(ext, NFT_SET_EXT_EXPR))
+		nf_tables_expr_destroy(NULL, nft_set_ext_expr(ext));
+	kfree(elem);
+}
+
 static int nft_setelem_parse_flags(const struct nft_set *set,
 				   const struct nlattr *attr, u32 *flags)
 {
@@ -3773,7 +3785,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	kfree(elem.priv);
 err1:
 	if (nla[NFTA_SET_ELEM_DATA] != NULL)
-		nft_data_uninit(&data, d2.type);
+		nft_data_release(&data, d2.type);
 	return err;
 }
 
@@ -3817,6 +3829,53 @@ static int nf_tables_newsetelem(struct net *net, struct sock *nlsk,
 	return err;
 }
 
+/**
+ *	nft_data_hold - hold a nft_data item
+ *
+ *	@data: struct nft_data to release
+ *	@type: type of data
+ *
+ *	Hold a nft_data item. NFT_DATA_VALUE types can be silently discarded,
+ *	NFT_DATA_VERDICT bumps the reference to chains in case of NFT_JUMP and
+ *	NFT_GOTO verdicts. This function must be called on active data objects
+ *	from the second phase of the commit protocol.
+ */
+static void nft_data_hold(const struct nft_data *data, enum nft_data_types type)
+{
+	if (type == NFT_DATA_VERDICT) {
+		switch (data->verdict.code) {
+		case NFT_JUMP:
+		case NFT_GOTO:
+			data->verdict.chain->use++;
+			break;
+		}
+	}
+}
+
+static void nft_set_elem_activate(const struct net *net,
+				  const struct nft_set *set,
+				  struct nft_set_elem *elem)
+{
+	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
+
+	if (nft_set_ext_exists(ext, NFT_SET_EXT_DATA))
+		nft_data_hold(nft_set_ext_data(ext), set->dtype);
+	if (nft_set_ext_exists(ext, NFT_SET_EXT_OBJREF))
+		(*nft_set_ext_obj(ext))->use++;
+}
+
+static void nft_set_elem_deactivate(const struct net *net,
+				    const struct nft_set *set,
+				    struct nft_set_elem *elem)
+{
+	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
+
+	if (nft_set_ext_exists(ext, NFT_SET_EXT_DATA))
+		nft_data_release(nft_set_ext_data(ext), set->dtype);
+	if (nft_set_ext_exists(ext, NFT_SET_EXT_OBJREF))
+		(*nft_set_ext_obj(ext))->use--;
+}
+
 static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 			   const struct nlattr *attr)
 {
@@ -3881,6 +3940,8 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 	kfree(elem.priv);
 	elem.priv = priv;
 
+	nft_set_elem_deactivate(ctx->net, set, &elem);
+
 	nft_trans_elem(trans) = elem;
 	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
 	return 0;
@@ -4694,8 +4755,8 @@ static void nf_tables_commit_release(struct nft_trans *trans)
 		nft_set_destroy(nft_trans_set(trans));
 		break;
 	case NFT_MSG_DELSETELEM:
-		nft_set_elem_destroy(nft_trans_elem_set(trans),
-				     nft_trans_elem(trans).priv);
+		nf_tables_set_elem_destroy(nft_trans_elem_set(trans),
+					   nft_trans_elem(trans).priv);
 		break;
 	case NFT_MSG_DELOBJ:
 		nft_obj_destroy(nft_trans_obj(trans));
@@ -4930,6 +4991,7 @@ static int nf_tables_abort(struct net *net, struct sk_buff *skb)
 		case NFT_MSG_DELSETELEM:
 			te = (struct nft_trans_elem *)trans->data;
 
+			nft_set_elem_activate(net, te->set, &te->elem);
 			te->set->ops->activate(net, te->set, &te->elem);
 			te->set->ndeact--;
 
@@ -5414,7 +5476,7 @@ int nft_data_init(const struct nft_ctx *ctx,
 EXPORT_SYMBOL_GPL(nft_data_init);
 
 /**
- *	nft_data_uninit - release a nft_data item
+ *	nft_data_release - release a nft_data item
  *
  *	@data: struct nft_data to release
  *	@type: type of data
@@ -5422,7 +5484,7 @@ EXPORT_SYMBOL_GPL(nft_data_init);
  *	Release a nft_data item. NFT_DATA_VALUE types can be silently discarded,
  *	all others need to be released by calling this function.
  */
-void nft_data_uninit(const struct nft_data *data, enum nft_data_types type)
+void nft_data_release(const struct nft_data *data, enum nft_data_types type)
 {
 	if (type < NFT_DATA_VERDICT)
 		return;
@@ -5433,7 +5495,7 @@ void nft_data_uninit(const struct nft_data *data, enum nft_data_types type)
 		WARN_ON(1);
 	}
 }
-EXPORT_SYMBOL_GPL(nft_data_uninit);
+EXPORT_SYMBOL_GPL(nft_data_release);
 
 int nft_data_dump(struct sk_buff *skb, int attr, const struct nft_data *data,
 		  enum nft_data_types type, unsigned int len)
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 6e8ccd627f15..0df7d16d5360 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -33,7 +33,7 @@ static void nft_dynset_elem_destroy(const struct nft_set *set, void *elem)
 	struct nft_set_ext *ext = nft_set_elem_ext(set, elem);
 
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_DATA))
-		nft_data_uninit(nft_set_ext_data(ext), set->dtype);
+		nft_data_release(nft_set_ext_data(ext), set->dtype);
 	/* NFT_SET_EXT_EXPR refers to the template, do not release it here. */
 	kfree(elem);
 }
diff --git a/net/netfilter/nft_immediate.c b/net/netfilter/nft_immediate.c
index 728baf88295a..4717d7796927 100644
--- a/net/netfilter/nft_immediate.c
+++ b/net/netfilter/nft_immediate.c
@@ -65,7 +65,7 @@ static int nft_immediate_init(const struct nft_ctx *ctx,
 	return 0;
 
 err1:
-	nft_data_uninit(&priv->data, desc.type);
+	nft_data_release(&priv->data, desc.type);
 	return err;
 }
 
@@ -73,7 +73,8 @@ static void nft_immediate_destroy(const struct nft_ctx *ctx,
 				  const struct nft_expr *expr)
 {
 	const struct nft_immediate_expr *priv = nft_expr_priv(expr);
-	return nft_data_uninit(&priv->data, nft_dreg_to_type(priv->dreg));
+
+	return nft_data_release(&priv->data, nft_dreg_to_type(priv->dreg));
 }
 
 static int nft_immediate_dump(struct sk_buff *skb, const struct nft_expr *expr)
-- 
2.1.4

