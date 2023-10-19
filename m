Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87451CDB484
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Oct 2023 14:20:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346051AbjJSOUN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Oct 2023 10:20:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346049AbjJSOUL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Oct 2023 10:20:11 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8B357138
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Oct 2023 07:20:08 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,RFC 8/8] netfilter: nf_tables: set element timeout update support
Date:   Thu, 19 Oct 2023 16:19:58 +0200
Message-Id: <20231019141958.653727-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20231019141958.653727-1-pablo@netfilter.org>
References: <20231019141958.653727-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Store new timeout and expiration to be updated from .commit path.
Simply discard the timeout update if .abort path is exercised.

This patch requires ("netfilter: nf_tables: use timestamp to check for
set element timeout") to make sure an element does not expire while
transaction is ongoing.

Element transaction takes 128 bytes on x86_64 after this update.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 19 +++++++++-
 net/netfilter/nf_tables_api.c     | 62 ++++++++++++++++++++++++++-----
 2 files changed, 69 insertions(+), 12 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 0243ed6c36c5..36947c28e59d 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -801,8 +801,14 @@ static inline struct nft_set_elem_expr *nft_set_ext_expr(const struct nft_set_ex
 static inline bool __nft_set_elem_expired(const struct nft_set_ext *ext,
 					  u64 tstamp)
 {
-	return nft_set_ext_exists(ext, NFT_SET_EXT_EXPIRATION) &&
-	       time_after_eq64(tstamp, *nft_set_ext_expiration(ext));
+	u64 expiration;
+
+	if (!nft_set_ext_exists(ext, NFT_SET_EXT_EXPIRATION))
+		return false;
+
+	expiration = READ_ONCE(*nft_set_ext_expiration(ext));
+
+	return time_after_eq64(tstamp, expiration);
 }
 
 static inline bool nft_set_elem_expired(const struct nft_set_ext *ext)
@@ -1654,6 +1660,9 @@ struct nft_trans_table {
 struct nft_trans_elem {
 	struct nft_set			*set;
 	struct nft_elem_priv		*elem_priv;
+	u64				timeout;
+	u64				expiration;
+	bool				update;
 	bool				bound;
 };
 
@@ -1661,6 +1670,12 @@ struct nft_trans_elem {
 	(((struct nft_trans_elem *)trans->data)->set)
 #define nft_trans_elem_priv(trans)	\
 	(((struct nft_trans_elem *)trans->data)->elem_priv)
+#define nft_trans_elem_update(trans)	\
+	(((struct nft_trans_elem *)trans->data)->update)
+#define nft_trans_elem_timeout(trans)	\
+	(((struct nft_trans_elem *)trans->data)->timeout)
+#define nft_trans_elem_expiration(trans)	\
+	(((struct nft_trans_elem *)trans->data)->expiration)
 #define nft_trans_elem_set_bound(trans)	\
 	(((struct nft_trans_elem *)trans->data)->bound)
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 2a9cd3886612..bcfb1ffc1827 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5583,17 +5583,20 @@ static int nf_tables_fill_setelem(struct sk_buff *skb,
 		         htonl(*nft_set_ext_flags(ext))))
 		goto nla_put_failure;
 
-	if (nft_set_ext_exists(ext, NFT_SET_EXT_TIMEOUT) &&
-	    *nft_set_ext_timeout(ext) != READ_ONCE(set->timeout) &&
-	    nla_put_be64(skb, NFTA_SET_ELEM_TIMEOUT,
-			 nf_jiffies64_to_msecs(*nft_set_ext_timeout(ext)),
-			 NFTA_SET_ELEM_PAD))
-		goto nla_put_failure;
+	if (nft_set_ext_exists(ext, NFT_SET_EXT_TIMEOUT)) {
+		u64 timeout = READ_ONCE(*nft_set_ext_timeout(ext));
+
+		if (timeout != READ_ONCE(set->timeout) &&
+		    nla_put_be64(skb, NFTA_SET_ELEM_TIMEOUT,
+				 nf_jiffies64_to_msecs(timeout),
+				 NFTA_SET_ELEM_PAD))
+			goto nla_put_failure;
+	}
 
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_EXPIRATION)) {
 		u64 expires, now = get_jiffies_64();
 
-		expires = *nft_set_ext_expiration(ext);
+		expires = READ_ONCE(*nft_set_ext_expiration(ext));
 		if (time_before64(now, expires))
 			expires -= now;
 		else
@@ -6524,6 +6527,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	struct nft_data_desc desc;
 	enum nft_registers dreg;
 	struct nft_trans *trans;
+	bool update = false;
 	u64 expiration;
 	u64 timeout;
 	int err, i;
@@ -6833,8 +6837,28 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			     nft_set_ext_exists(ext2, NFT_SET_EXT_OBJREF) &&
 			     *nft_set_ext_obj(ext) != *nft_set_ext_obj(ext2)))
 				goto err_element_clash;
-			else if (!(nlmsg_flags & NLM_F_EXCL))
+			else if (!(nlmsg_flags & NLM_F_EXCL)) {
 				err = 0;
+				if (timeout) {
+					nft_trans_elem_timeout(trans) = timeout;
+					if (expiration == 0)
+						expiration = timeout;
+
+					update = true;
+				}
+				if (expiration) {
+					nft_trans_elem_expiration(trans) =
+						expiration;
+					update = true;
+				}
+
+				if (update) {
+					nft_trans_elem_priv(trans) = elem_priv;
+					nft_trans_elem_update(trans) = true;
+					nft_trans_commit_list_add_tail(ctx->net, trans);
+					goto err_elem_free;
+				}
+			}
 		} else if (err == -ENOTEMPTY) {
 			/* ENOTEMPTY reports overlapping between this element
 			 * and an existing one.
@@ -10035,7 +10059,24 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 		case NFT_MSG_NEWSETELEM:
 			te = (struct nft_trans_elem *)trans->data;
 
-			nft_setelem_activate(net, te->set, te->elem_priv);
+			if (te->update) {
+				const struct nft_set_ext *ext =
+					nft_set_elem_ext(te->set, te->elem_priv);
+
+				if (te->timeout &&
+				    nft_set_ext_exists(ext, NFT_SET_EXT_TIMEOUT)) {
+					WRITE_ONCE(*nft_set_ext_timeout(ext),
+						   te->timeout);
+				}
+				if (te->expiration &&
+				    nft_set_ext_exists(ext, NFT_SET_EXT_EXPIRATION)) {
+					WRITE_ONCE(*nft_set_ext_expiration(ext),
+						   get_jiffies_64() + te->expiration);
+				}
+			} else {
+				nft_setelem_activate(net, te->set, te->elem_priv);
+			}
+
 			nf_tables_setelem_notify(&trans->ctx, te->set,
 						 te->elem_priv,
 						 NFT_MSG_NEWSETELEM);
@@ -10316,7 +10357,8 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_NEWSETELEM:
-			if (nft_trans_elem_set_bound(trans)) {
+			if (nft_trans_elem_update(trans) ||
+			    nft_trans_elem_set_bound(trans)) {
 				nft_trans_destroy(trans);
 				break;
 			}
-- 
2.30.2

