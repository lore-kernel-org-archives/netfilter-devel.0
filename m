Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B50B17C9A4
	for <netfilter-devel@vger.kernel.org>; Mon,  2 Sep 2024 23:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725319063; cv=none; b=Cq/H8zPK12A832GSNghWcuJTpwuFMtkQvITS60bHdA5ySKial+/za96opd68w5xnD7w8eeSEWVF8dqGONUNVmI9mV0HdnKod4TeMvnbEbDCT+v3/YcnHLxIGAzXEpuNfH7lvgy1oPY/BNbSepSH+wVgPBKDqFl2p6QDu2/O52g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725319063; c=relaxed/simple;
	bh=SdXgJuiFOwXUKR22DWWCWfsh3JTjxcA/2wylPZcHQN8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=A6QNp77VGfxgWIxZjorSL/PL7pRWyEY9Ix+KejZ2AuN/tSyvoNUtB/6zc605Ui2EcNpTQTglSS23WvEPVWWEMnwPHhqhG0AkjFA+7DE4eklXZyY+hWpYU/MDAgJIJat5zQF5yXdNPgSJDoa+x0FqN3AX+0vBEN/ZWNnhRWrG8dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: phil@nwl.cc,
	fw@strlen.de
Subject: [PATCH nf-next,v2 9/9] netfilter: nf_tables: set element timeout update support
Date: Tue,  3 Sep 2024 01:17:26 +0200
Message-Id: <20240902231726.171964-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240902231726.171964-1-pablo@netfilter.org>
References: <20240902231726.171964-1-pablo@netfilter.org>
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
 include/net/netfilter/nf_tables.h | 11 +++++++-
 net/netfilter/nf_tables_api.c     | 46 ++++++++++++++++++++++++++++---
 net/netfilter/nft_dynset.c        |  2 +-
 3 files changed, 53 insertions(+), 6 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index ef421c6bb715..dad7cae1af6b 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -829,7 +829,7 @@ static inline bool __nft_set_elem_expired(const struct nft_set_ext *ext,
 					  u64 tstamp)
 {
 	if (!nft_set_ext_exists(ext, NFT_SET_EXT_TIMEOUT) ||
-	    nft_set_ext_timeout(ext)->timeout == 0)
+	    READ_ONCE(nft_set_ext_timeout(ext)->timeout) == 0)
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
index 4bba454eee4c..0e784466b3a6 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5813,7 +5813,7 @@ static int nf_tables_fill_setelem(struct sk_buff *skb,
 		goto nla_put_failure;
 
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_TIMEOUT)) {
-		u64 timeout = nft_set_ext_timeout(ext)->timeout;
+		u64 timeout = READ_ONCE(nft_set_ext_timeout(ext)->timeout);
 		u64 set_timeout = READ_ONCE(set->timeout);
 		__be64 msecs = 0;
 
@@ -6852,6 +6852,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	struct nft_data_desc desc;
 	enum nft_registers dreg;
 	struct nft_trans *trans;
+	bool update = false;
 	u64 expiration;
 	u64 timeout;
 	int err, i;
@@ -7167,8 +7168,29 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			     nft_set_ext_exists(ext2, NFT_SET_EXT_OBJREF) &&
 			     *nft_set_ext_obj(ext) != *nft_set_ext_obj(ext2)))
 				goto err_element_clash;
-			else if (!(nlmsg_flags & NLM_F_EXCL))
+			else if (!(nlmsg_flags & NLM_F_EXCL)) {
 				err = 0;
+				if (nft_set_ext_exists(ext2, NFT_SET_EXT_TIMEOUT)) {
+					if (timeout != nft_set_ext_timeout(ext2)->timeout) {
+						nft_trans_elem_timeout(trans) = timeout;
+						if (expiration == 0)
+							expiration = timeout;
+
+						update = true;
+					}
+					if (expiration) {
+						nft_trans_elem_expiration(trans) = expiration;
+						update = true;
+					}
+
+					if (update) {
+						nft_trans_elem_priv(trans) = elem_priv;
+						nft_trans_elem_update(trans) = true;
+						nft_trans_commit_list_add_tail(ctx->net, trans);
+						goto err_elem_free;
+					}
+				}
+			}
 		} else if (err == -ENOTEMPTY) {
 			/* ENOTEMPTY reports overlapping between this element
 			 * and an existing one.
@@ -10492,7 +10514,22 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 		case NFT_MSG_NEWSETELEM:
 			te = nft_trans_container_elem(trans);
 
-			nft_setelem_activate(net, te->set, te->elem_priv);
+			if (te->update) {
+				const struct nft_set_ext *ext =
+					nft_set_elem_ext(te->set, te->elem_priv);
+
+				if (nft_set_ext_timeout(ext)->timeout != te->timeout) {
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
@@ -10791,7 +10828,8 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
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
index e250183df713..06fb08ddc804 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -95,7 +95,7 @@ void nft_dynset_eval(const struct nft_expr *expr,
 			     expr, regs, &ext)) {
 		if (priv->op == NFT_DYNSET_OP_UPDATE &&
 		    nft_set_ext_exists(ext, NFT_SET_EXT_TIMEOUT) &&
-		    nft_set_ext_timeout(ext)->timeout != 0) {
+		    READ_ONCE(nft_set_ext_timeout(ext)->timeout) != 0) {
 			timeout = priv->timeout ? : READ_ONCE(set->timeout);
 			WRITE_ONCE(nft_set_ext_timeout(ext)->expiration, get_jiffies_64() + timeout);
 		}
-- 
2.30.2

