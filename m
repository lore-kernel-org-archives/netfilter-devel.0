Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BBEE1C6A8;
	Mon, 22 Jul 2024 20:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721680629; cv=none; b=JSifB9KM4FXpXOQB2B6XYvrmOLP462UgN1wv5s+bmORneQvr9CubWx3wfviX6dL/7tu42gL5rpfwwZ3zccsj8zc+6TZA4EQD0kUfKTmU4hktIYwY0mRQ1GPUyojLpZ/l7RX6bUszUc4kq2HHwAXAJPw0II9aAVd7ar2mbulvqLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721680629; c=relaxed/simple;
	bh=6SsSuQc23hw4o6m6TjTj2wDt9FevKsg2fRTBnsLzIAo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=isaY03zWyWp1UF7Mjg75DTQmcls7OTGhrJvG1afp86IU64AIgRNSv2ZQ/BU9fKHsGPIVbd5soUmOWEON0KWVv9D1jtNiVODWt9dH4Lz85cTaeicAAlaY02Au3lOO4jG4PUrC3/xoIFuH28jfJY4PoYIZSFy2N9IrIk/8K+FWQKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [46.222.212.173] (port=7656 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sVzm7-00HEI5-Es; Mon, 22 Jul 2024 22:36:54 +0200
Date: Mon, 22 Jul 2024 22:36:49 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Kerin Millar <kfm@plushkava.net>
Cc: Slavko <linux@slavino.sk>, netfilter ML <netfilter@vger.kernel.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: Sets update
Message-ID: <Zp7C4VRGtXta6cdM@calendula>
References: <A1B9EF5A-1696-4A6D-B0D1-81DD32DC41C0@slavino.sk>
 <ba07a45c-7564-4b40-92de-ea698d16f49f@app.fastmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="9isL2rVfE/aIL8hq"
Content-Disposition: inline
In-Reply-To: <ba07a45c-7564-4b40-92de-ea698d16f49f@app.fastmail.com>
X-Spam-Score: -1.9 (-)


--9isL2rVfE/aIL8hq
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Sun, Jul 21, 2024 at 10:58:30AM +0100, Kerin Millar wrote:
> I doubt it. Perhaps we need a new "update element" command to act
> similarly to the set statement bearing the same name.

I have these two patches that have remained in my local tree. They
need a rebase, update tests and so on.

I can aim at merging this upstream in the next development cycle.

--9isL2rVfE/aIL8hq
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0001-netfilter-nf_tables-add-timeout-extension-to-element.patch"

From deb81f87834b117f60609177e1c8dd58bf09cd00 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Wed, 18 Oct 2023 22:49:03 +0200
Subject: [PATCH nf-next,RFC 1/2] netfilter: nf_tables: add timeout extension
 to elements to prepare for updates

Timeout extension is not allocated in case that the default set timeout
value is the same. However, with set element updates, this can be updated
too so, allocate it but do not include it in netlink messages so users
do not observe any change in the existing listings / events.

This updates c3e1b005ed1c ("netfilter: nf_tables: add set element
timeout support").

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Need rebase and extend tests.

 net/netfilter/nf_tables_api.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ec616bbe75de..b7ede2aba06d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5642,6 +5642,7 @@ static int nf_tables_fill_setelem(struct sk_buff *skb,
 		goto nla_put_failure;
 
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_TIMEOUT) &&
+	    *nft_set_ext_timeout(ext) != READ_ONCE(set->timeout) &&
 	    nla_put_be64(skb, NFTA_SET_ELEM_TIMEOUT,
 			 nf_jiffies64_to_msecs(*nft_set_ext_timeout(ext)),
 			 NFTA_SET_ELEM_PAD))
@@ -6752,11 +6753,9 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		if (err < 0)
 			goto err_parse_key_end;
 
-		if (timeout != READ_ONCE(set->timeout)) {
-			err = nft_set_ext_add(&tmpl, NFT_SET_EXT_TIMEOUT);
-			if (err < 0)
-				goto err_parse_key_end;
-		}
+		err = nft_set_ext_add(&tmpl, NFT_SET_EXT_TIMEOUT);
+		if (err < 0)
+			goto err_parse_key_end;
 	}
 
 	if (num_exprs) {
-- 
2.30.2


--9isL2rVfE/aIL8hq
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0002-netfilter-nf_tables-set-element-timeout-update-suppo.patch"

From 6f9de93f7a4e9cc004689cbffe836a5d80ce9c5f Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Wed, 18 Oct 2023 23:07:21 +0200
Subject: [PATCH nf-next,RFC 2/2] netfilter: nf_tables: set element timeout
 update support

Store new timeout and expiration to be updated from .commit path.
Simply discard the timeout update if .abort path is exercised.

This patch requires ("netfilter: nf_tables: use timestamp to check for
set element timeout") to make sure an element does not expire while
transaction is ongoing.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Need rebase and extend tests.

 include/net/netfilter/nf_tables.h | 19 +++++++++-
 net/netfilter/nf_tables_api.c     | 62 ++++++++++++++++++++++++++-----
 2 files changed, 69 insertions(+), 12 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index d791dbfd12f9..9e48b5ab5f39 100644
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
@@ -1657,6 +1663,9 @@ struct nft_trans_table {
 struct nft_trans_elem {
 	struct nft_set			*set;
 	struct nft_elem_priv		*elem_priv;
+	u64				timeout;
+	u64				expiration;
+	bool				update;
 	bool				bound;
 };
 
@@ -1664,6 +1673,12 @@ struct nft_trans_elem {
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
index b7ede2aba06d..74696ec4a491 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5641,17 +5641,20 @@ static int nf_tables_fill_setelem(struct sk_buff *skb,
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
@@ -6584,6 +6587,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	struct nft_data_desc desc;
 	enum nft_registers dreg;
 	struct nft_trans *trans;
+	bool update = false;
 	u64 expiration;
 	u64 timeout;
 	int err, i;
@@ -6893,8 +6897,28 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
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
@@ -10096,7 +10120,24 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
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
@@ -10377,7 +10418,8 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
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


--9isL2rVfE/aIL8hq--
