Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F34E1BDAB7;
	Thu,  5 Sep 2024 23:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725578989; cv=none; b=JP0h2iuc/yAuSosMTUTmPEF1gaADd0gJBbVEuIG9QJUQKfqFVizUp3b4dtV2RD3MccVBAmrn9IaQ9duS0cJYpYg/7OEJoRZvN4BlAJMvyCKSWJzSG3LTAz9GwH+9MdiZ32mOrkOmaYYzp9sWpk6XRskkDLrT6rZbrXxHN6Fmi9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725578989; c=relaxed/simple;
	bh=qWnQ52ZOFcfUH30yhNr7GdOz1ULbAXa0u6gVutZJ6Zc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Pa5z/ChYmH1KXKIMi/yA9sdHhQeUhCypfVWPxBLuycVU8a6lj8dxpMo/4oR1mQWOIfc05FOU0hzAm0KNlswCISIOr0ZGXG/UwUn3CsSTqiFXKvrpe0EE5K9gUzLBEo3jUCyFDC+zx2bfYQfOQAvAlhT+s1AxYT+5Cegc/U24vlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net-next 16/16] netfilter: nf_tables: set element timeout update support
Date: Fri,  6 Sep 2024 01:29:20 +0200
Message-Id: <20240905232920.5481-17-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240905232920.5481-1-pablo@netfilter.org>
References: <20240905232920.5481-1-pablo@netfilter.org>
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

Use update_flags in the transaction to note whether the timeout,
expiration, or both need to be updated.

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
 include/net/netfilter/nf_tables.h | 16 ++++++++++-
 net/netfilter/nf_tables_api.c     | 47 ++++++++++++++++++++++++++++---
 net/netfilter/nft_dynset.c        |  2 +-
 3 files changed, 59 insertions(+), 6 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 7511918dce6f..49708e7e1339 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -833,7 +833,7 @@ static inline bool __nft_set_elem_expired(const struct nft_set_ext *ext,
 					  u64 tstamp)
 {
 	if (!nft_set_ext_exists(ext, NFT_SET_EXT_TIMEOUT) ||
-	    nft_set_ext_timeout(ext)->timeout == 0)
+	    READ_ONCE(nft_set_ext_timeout(ext)->timeout) == 0)
 		return false;
 
 	return time_after_eq64(tstamp, READ_ONCE(nft_set_ext_timeout(ext)->expiration));
@@ -1749,10 +1749,18 @@ struct nft_trans_table {
 #define nft_trans_table_update(trans)			\
 	nft_trans_container_table(trans)->update
 
+enum nft_trans_elem_flags {
+	NFT_TRANS_UPD_TIMEOUT		= (1 << 0),
+	NFT_TRANS_UPD_EXPIRATION	= (1 << 1),
+};
+
 struct nft_trans_elem {
 	struct nft_trans		nft_trans;
 	struct nft_set			*set;
 	struct nft_elem_priv		*elem_priv;
+	u64				timeout;
+	u64				expiration;
+	u8				update_flags;
 	bool				bound;
 };
 
@@ -1762,6 +1770,12 @@ struct nft_trans_elem {
 	nft_trans_container_elem(trans)->set
 #define nft_trans_elem_priv(trans)			\
 	nft_trans_container_elem(trans)->elem_priv
+#define nft_trans_elem_update_flags(trans)		\
+	nft_trans_container_elem(trans)->update_flags
+#define nft_trans_elem_timeout(trans)			\
+	nft_trans_container_elem(trans)->timeout
+#define nft_trans_elem_expiration(trans)		\
+	nft_trans_container_elem(trans)->expiration
 #define nft_trans_elem_set_bound(trans)			\
 	nft_trans_container_elem(trans)->bound
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ed85b10edb32..57259b5f3ef5 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5815,7 +5815,7 @@ static int nf_tables_fill_setelem(struct sk_buff *skb,
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
+	u8 update_flags;
 	u64 expiration;
 	u64 timeout;
 	int err, i;
@@ -7163,8 +7164,30 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			     nft_set_ext_exists(ext2, NFT_SET_EXT_OBJREF) &&
 			     *nft_set_ext_obj(ext) != *nft_set_ext_obj(ext2)))
 				goto err_element_clash;
-			else if (!(nlmsg_flags & NLM_F_EXCL))
+			else if (!(nlmsg_flags & NLM_F_EXCL)) {
 				err = 0;
+				if (nft_set_ext_exists(ext2, NFT_SET_EXT_TIMEOUT)) {
+					update_flags = 0;
+					if (timeout != nft_set_ext_timeout(ext2)->timeout) {
+						nft_trans_elem_timeout(trans) = timeout;
+						if (expiration == 0)
+							expiration = timeout;
+
+						update_flags |= NFT_TRANS_UPD_TIMEOUT;
+					}
+					if (expiration) {
+						nft_trans_elem_expiration(trans) = expiration;
+						update_flags |= NFT_TRANS_UPD_EXPIRATION;
+					}
+
+					if (update_flags) {
+						nft_trans_elem_priv(trans) = elem_priv;
+						nft_trans_elem_update_flags(trans) = update_flags;
+						nft_trans_commit_list_add_tail(ctx->net, trans);
+						goto err_elem_free;
+					}
+				}
+			}
 		} else if (err == -ENOTEMPTY) {
 			/* ENOTEMPTY reports overlapping between this element
 			 * and an existing one.
@@ -10489,7 +10512,22 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 		case NFT_MSG_NEWSETELEM:
 			te = nft_trans_container_elem(trans);
 
-			nft_setelem_activate(net, te->set, te->elem_priv);
+			if (te->update_flags) {
+				const struct nft_set_ext *ext =
+					nft_set_elem_ext(te->set, te->elem_priv);
+
+				if (te->update_flags & NFT_TRANS_UPD_TIMEOUT) {
+					WRITE_ONCE(nft_set_ext_timeout(ext)->timeout,
+						   te->timeout);
+				}
+				if (te->update_flags & NFT_TRANS_UPD_EXPIRATION) {
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
@@ -10789,7 +10827,8 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_NEWSETELEM:
-			if (nft_trans_elem_set_bound(trans)) {
+			if (nft_trans_elem_update_flags(trans) ||
+			    nft_trans_elem_set_bound(trans)) {
 				nft_trans_destroy(trans);
 				break;
 			}
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 6a10305de24b..88922e0e8e83 100644
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

