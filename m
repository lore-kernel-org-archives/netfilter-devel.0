Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 545F44A3E
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Sep 2024 13:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725371803; cv=none; b=o/xkokEWKWGdBOKkTd115UxXlkowNLXr5v+AL8adx/GYi3kSWmXFUzH/+aYPkyXtjYS790WisMBr0zIYYbnEJqKuJTVqjcrOMC20/aukhLurrbzRbQVmoEuOGakyqRSzivHS0g2CqZFoClkeyHoD8m6CRacUeuSvwQtJVyumGTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725371803; c=relaxed/simple;
	bh=+LDj2CEunAbW9oXwiSUryPBBAphZw9JpdPOM60R6QE0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oVG9aKz5OcUKFlzVKCJ5dlr3bK2lbZ6YXokJhLntjP/84s93FOs/Ky5bOTx3RM+b01OQ9I/8KSejSIjBAYnuQeHEbqglna6X1RdVgJj7xCR+XodWWfAUdK+XrXnUMzsD8jeNl0mPyV7LPWFi94q4XpmMUyob9culuG5u6AHFD8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	phil@nwl.cc
Subject: [PATCH nf-next,v3 9/9] netfilter: nf_tables: set element timeout update support
Date: Tue,  3 Sep 2024 15:56:35 +0200
Message-Id: <20240903135635.2086-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240903135635.2086-1-pablo@netfilter.org>
References: <20240903135635.2086-1-pablo@netfilter.org>
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
v3: use .update_flags in transaction to fix expiration updates only.

 include/net/netfilter/nf_tables.h | 16 ++++++++++-
 net/netfilter/nf_tables_api.c     | 47 ++++++++++++++++++++++++++++---
 net/netfilter/nft_dynset.c        |  2 +-
 3 files changed, 59 insertions(+), 6 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index ef421c6bb715..e7c4112302aa 100644
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
@@ -1745,10 +1745,18 @@ struct nft_trans_table {
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
 
@@ -1758,6 +1766,12 @@ struct nft_trans_elem {
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
index 36c0a107e237..82554391464f 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5809,7 +5809,7 @@ static int nf_tables_fill_setelem(struct sk_buff *skb,
 		goto nla_put_failure;
 
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_TIMEOUT)) {
-		u64 timeout = nft_set_ext_timeout(ext)->timeout;
+		u64 timeout = READ_ONCE(nft_set_ext_timeout(ext)->timeout);
 		u64 set_timeout = READ_ONCE(set->timeout);
 		__be64 msecs = 0;
 
@@ -6846,6 +6846,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	struct nft_data_desc desc;
 	enum nft_registers dreg;
 	struct nft_trans *trans;
+	u8 update_flags;
 	u64 expiration;
 	u64 timeout;
 	int err, i;
@@ -7157,8 +7158,30 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
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
@@ -10482,7 +10505,22 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
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
@@ -10781,7 +10819,8 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
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

