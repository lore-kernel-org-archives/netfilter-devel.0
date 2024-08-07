Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1136C74429
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Aug 2024 14:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723040654; cv=none; b=AL+NL8DGSIqAQKQAaSsy8Gy6GT+X6VRdf2rSEcv2qEnAp4/iZJSjyxfgnkybdP52rABbYYZOA9kS2QFjbyp11BPxqbTwUst+SerVHkitN2/TA/IfIoLaLmjb7bDnvqrMPYc5bz9naKHq/nIxHizFHwjKOnrq+rS9EcqmuCQyabg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723040654; c=relaxed/simple;
	bh=OMrphLd510vQ8LdLBvY3NUzsKCpK2wIer1sNRP4NTuM=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LankaREJkgKy1emTyAEz4pewBFz/42Ll+YrUOUXKC+/SRkQ5qsRKubUb/zNetLd/K9Y4IYI7jgEz0qSx8ZixyG7flPneyILp+Ra3EhEV8F9GnLJZBRYgFeGadyQclTB+Hv5+cbSrzQYhHsyB2P4ZH/AkvMFHkSwsYJB/jXa3q8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 8/8] netfilter: nf_tables: set element timeout update support
Date: Wed,  7 Aug 2024 16:23:57 +0200
Message-Id: <20240807142357.90493-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240807142357.90493-1-pablo@netfilter.org>
References: <20240807142357.90493-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Store new timeout and expiration in transaction object, use them to
update elements from .commit path. Otherwise, discard update if .abort
path is exercised.

Annotate access to timeout extension now that it can be updated while
lockless read access is possible.

Reject timeout updates on elements with no timeout extension.

Element transaction remains in the 96 bytes kmalloc slab on x86_64 after
this update.

This patch requires ("netfilter: nf_tables: use timestamp to check for
set element timeout") to make sure an element does not expire while
transaction is ongoing.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 11 ++++++-
 net/netfilter/nf_tables_api.c     | 48 ++++++++++++++++++++++++++++---
 net/netfilter/nft_dynset.c        |  2 +-
 3 files changed, 55 insertions(+), 6 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 1c218794c936..e6e07faed1f7 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -829,7 +829,7 @@ static inline bool __nft_set_elem_expired(const struct nft_set_ext *ext,
 					  u64 tstamp)
 {
 	if (!nft_set_ext_exists(ext, NFT_SET_EXT_TIMEOUT) ||
-	    nft_set_ext_timeout(ext)->timeout == NFT_NEVER_EXPIRES)
+	    READ_ONCE(nft_set_ext_timeout(ext)->timeout) == NFT_NEVER_EXPIRES)
 		return false;
 
 	return time_after_eq64(tstamp, READ_ONCE(nft_set_ext_timeout(ext)->expiration));
@@ -1749,6 +1749,9 @@ struct nft_trans_elem {
 	struct nft_trans		nft_trans;
 	struct nft_set			*set;
 	struct nft_elem_priv		*elem_priv;
+	u64				timeout;
+	u64				expiration;
+	bool				update;
 	bool				bound;
 };
 
@@ -1758,6 +1761,12 @@ struct nft_trans_elem {
 	nft_trans_container_elem(trans)->set
 #define nft_trans_elem_priv(trans)			\
 	nft_trans_container_elem(trans)->elem_priv
+#define nft_trans_elem_update(trans)			\
+	nft_trans_container_elem(trans)->update
+#define nft_trans_elem_timeout(trans)			\
+	nft_trans_container_elem(trans)->timeout
+#define nft_trans_elem_expiration(trans)		\
+	nft_trans_container_elem(trans)->expiration
 #define nft_trans_elem_set_bound(trans)			\
 	nft_trans_container_elem(trans)->bound
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 7fb9a2cc88ca..53cb6c1fdf12 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5819,7 +5819,7 @@ static int nf_tables_fill_setelem(struct sk_buff *skb,
 		goto nla_put_failure;
 
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_TIMEOUT)) {
-		u64 timeout = nft_set_ext_timeout(ext)->timeout, msecs = 0;
+		u64 timeout = READ_ONCE(nft_set_ext_timeout(ext)->timeout), msecs = 0;
 		u64 set_timeout = READ_ONCE(set->timeout);
 
 		if (set_timeout > 0) {
@@ -6864,6 +6864,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	struct nft_data_desc desc;
 	enum nft_registers dreg;
 	struct nft_trans *trans;
+	bool update = false;
 	u64 expiration;
 	u64 timeout;
 	int err, i;
@@ -7175,8 +7176,31 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
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
+					nft_trans_elem_expiration(trans) = expiration;
+					update = true;
+				}
+
+				if (update) {
+					if (WARN_ON_ONCE(!nft_set_ext_exists(ext2, NFT_SET_EXT_TIMEOUT))) {
+						err = -EINVAL;
+						goto err_element_clash;
+					}
+					nft_trans_elem_priv(trans) = elem_priv;
+					nft_trans_elem_update(trans) = true;
+					nft_trans_commit_list_add_tail(ctx->net, trans);
+					goto err_elem_free;
+				}
+			}
 		} else if (err == -ENOTEMPTY) {
 			/* ENOTEMPTY reports overlapping between this element
 			 * and an existing one.
@@ -10443,7 +10467,22 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 		case NFT_MSG_NEWSETELEM:
 			te = nft_trans_container_elem(trans);
 
-			nft_setelem_activate(net, te->set, te->elem_priv);
+			if (te->update) {
+				const struct nft_set_ext *ext =
+					nft_set_elem_ext(te->set, te->elem_priv);
+
+				if (te->timeout) {
+					WRITE_ONCE(nft_set_ext_timeout(ext)->timeout,
+						   te->timeout);
+				}
+				if (te->expiration) {
+					WRITE_ONCE(nft_set_ext_timeout(ext)->expiration,
+						   get_jiffies_64() + te->expiration);
+				}
+			} else {
+				nft_setelem_activate(net, te->set, te->elem_priv);
+			}
+
 			nf_tables_setelem_notify(&ctx, te->set,
 						 te->elem_priv,
 						 NFT_MSG_NEWSETELEM);
@@ -10742,7 +10781,8 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_NEWSETELEM:
-			if (nft_trans_elem_set_bound(trans)) {
+			if (nft_trans_elem_update(trans) ||
+			    nft_trans_elem_set_bound(trans)) {
 				nft_trans_destroy(trans);
 				break;
 			}
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 39e773b1c612..6787c07a1b8f 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -95,7 +95,7 @@ void nft_dynset_eval(const struct nft_expr *expr,
 			     expr, regs, &ext)) {
 		if (priv->op == NFT_DYNSET_OP_UPDATE &&
 		    nft_set_ext_exists(ext, NFT_SET_EXT_TIMEOUT) &&
-		    nft_set_ext_timeout(ext)->timeout != NFT_NEVER_EXPIRES) {
+		    READ_ONCE(nft_set_ext_timeout(ext)->timeout) != NFT_NEVER_EXPIRES) {
 			timeout = priv->timeout ? : READ_ONCE(set->timeout);
 			WRITE_ONCE(nft_set_ext_timeout(ext)->expiration, get_jiffies_64() + timeout);
 		}
-- 
2.30.2

