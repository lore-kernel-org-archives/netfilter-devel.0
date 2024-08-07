Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1132F2A1BF
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Aug 2024 14:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723040654; cv=none; b=ZOas7RetvpoWRzC/9S/aFwJSNOMAS8b9V+OpOHLCDcGzRwHvbNRLh6kIA6LcgKekx+ITZd2uNvyAFWZqyAAAqQUPTWcC2RiR+PnGKsY3uKSOne6oU16tTuR/RM80oJCX1u10TsScJRiCGtlNfVhnmijoEFRAsrqYZnI4lVlPQ4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723040654; c=relaxed/simple;
	bh=zKWsRHmgJzOLcCBGQo1CasvRKzaQagGqTMItfUWq7YE=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EMvJEGXf5u95uiYe0p6AmN3M8Jz6J+RuvsMwuiSXQ1kd25tHzjJJDUA4g5iiYDFeHf6nUzKCmgZRL4sWtZQ/5Ks9Uoy2jjpqGkocQSl29QB7851pXRtuPpPduwWoRj8zyOULPxAfTNBs3KI4cUWMiwtZ1+Fu29l2I7xHeu4GFYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 7/8] netfilter: nf_tables: add never expires marker to elements
Date: Wed,  7 Aug 2024 16:23:56 +0200
Message-Id: <20240807142357.90493-8-pablo@netfilter.org>
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

This patch adds a timeout marker for those elements that never expire
when the element are created, so timeout updates are possible.

Note that maximum supported timeout in milliseconds which is conveyed
within a netlink attribute is 0x10c6f7a0b5ec which translates to
0xffffffffffe85300 jiffies64, higher milliseconds values result in an
ERANGE error. Use U64_MAX as an internal marker to be stored in the set
element timeout field for permanent elements.

If userspace provides no timeout for an element, then the default set
timeout applies. However, if no default set timeout is specified and
timeout flag is set on, then such new element gets the never expires
marker.

Note that, in older kernels, it is already possible to define elements
that never expire by declaring a set with the set timeout flag set on
and no global set timeout, in this case, new element with no explicit
timeout never expire do not allocate the timeout extension, hence, they
never expire. This approach makes it complicated to accomodate element
timeout update, because element extensions do not support reallocations.
Therefore, allocate the timeout extension and use the new marker for
this case, but do not expose it to userspace to retain backward
compatibility in the set listing.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h        |  9 ++--
 include/uapi/linux/netfilter/nf_tables.h |  3 ++
 net/netfilter/nf_tables_api.c            | 65 ++++++++++++++++--------
 net/netfilter/nft_dynset.c               |  6 ++-
 net/netfilter/nft_last.c                 |  3 +-
 5 files changed, 60 insertions(+), 26 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index a950a1f932bf..1c218794c936 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -828,8 +828,11 @@ static inline struct nft_set_elem_expr *nft_set_ext_expr(const struct nft_set_ex
 static inline bool __nft_set_elem_expired(const struct nft_set_ext *ext,
 					  u64 tstamp)
 {
-	return nft_set_ext_exists(ext, NFT_SET_EXT_TIMEOUT) &&
-	       time_after_eq64(tstamp, READ_ONCE(nft_set_ext_timeout(ext)->expiration));
+	if (!nft_set_ext_exists(ext, NFT_SET_EXT_TIMEOUT) ||
+	    nft_set_ext_timeout(ext)->timeout == NFT_NEVER_EXPIRES)
+		return false;
+
+	return time_after_eq64(tstamp, READ_ONCE(nft_set_ext_timeout(ext)->expiration));
 }
 
 static inline bool nft_set_elem_expired(const struct nft_set_ext *ext)
@@ -1861,7 +1864,7 @@ void nft_chain_route_fini(void);
 
 void nf_tables_trans_destroy_flush_work(void);
 
-int nf_msecs_to_jiffies64(const struct nlattr *nla, u64 *result);
+int nf_msecs_to_jiffies64(const struct nlattr *nla, u64 *result, bool never_expires);
 __be64 nf_jiffies64_to_msecs(u64 input);
 
 #ifdef CONFIG_MODULES
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 639894ed1b97..19ef0acea98b 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -430,6 +430,9 @@ enum nft_set_elem_flags {
 	NFT_SET_ELEM_CATCHALL		= 0x2,
 };
 
+/* Marker value for elements that never expire. */
+#define NFT_NEVER_EXPIRES	U64_MAX
+
 /**
  * enum nft_set_elem_attributes - nf_tables set element netlink attributes
  *
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ec9b85dac3a5..7fb9a2cc88ca 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4577,11 +4577,17 @@ static int nf_tables_set_alloc_name(struct nft_ctx *ctx, struct nft_set *set,
 	return 0;
 }
 
-int nf_msecs_to_jiffies64(const struct nlattr *nla, u64 *result)
+int nf_msecs_to_jiffies64(const struct nlattr *nla, u64 *result,
+			  bool never_expires)
 {
 	u64 ms = be64_to_cpu(nla_get_be64(nla));
 	u64 max = (u64)(~((u64)0));
 
+	if (never_expires && ms == NFT_NEVER_EXPIRES) {
+		*result = NFT_NEVER_EXPIRES;
+		return 0;
+	}
+
 	max = div_u64(max, NSEC_PER_MSEC);
 	if (ms >= max)
 		return -ERANGE;
@@ -5169,7 +5175,8 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 		if (flags & NFT_SET_ANONYMOUS)
 			return -EOPNOTSUPP;
 
-		err = nf_msecs_to_jiffies64(nla[NFTA_SET_TIMEOUT], &desc.timeout);
+		err = nf_msecs_to_jiffies64(nla[NFTA_SET_TIMEOUT],
+					    &desc.timeout, false);
 		if (err)
 			return err;
 	}
@@ -5812,24 +5819,36 @@ static int nf_tables_fill_setelem(struct sk_buff *skb,
 		goto nla_put_failure;
 
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_TIMEOUT)) {
-		u64 expires, now = get_jiffies_64();
-
-		if (nft_set_ext_timeout(ext)->timeout != READ_ONCE(set->timeout) &&
-		    nla_put_be64(skb, NFTA_SET_ELEM_TIMEOUT,
-				 nf_jiffies64_to_msecs(nft_set_ext_timeout(ext)->timeout),
+		u64 timeout = nft_set_ext_timeout(ext)->timeout, msecs = 0;
+		u64 set_timeout = READ_ONCE(set->timeout);
+
+		if (set_timeout > 0) {
+			if (timeout == NFT_NEVER_EXPIRES)
+				msecs = NFT_NEVER_EXPIRES;
+			else if (timeout != set_timeout)
+				msecs = nf_jiffies64_to_msecs(timeout);
+		} else if (timeout && timeout != NFT_NEVER_EXPIRES)
+			msecs = nf_jiffies64_to_msecs(timeout);
+
+		if (msecs &&
+		    nla_put_be64(skb, NFTA_SET_ELEM_TIMEOUT, msecs,
 				 NFTA_SET_ELEM_PAD))
 			goto nla_put_failure;
 
-		expires = READ_ONCE(nft_set_ext_timeout(ext)->expiration);
-		if (time_before64(now, expires))
-			expires -= now;
-		else
-			expires = 0;
+		if (timeout != NFT_NEVER_EXPIRES) {
+			u64 expires, now = get_jiffies_64();
 
-		if (nla_put_be64(skb, NFTA_SET_ELEM_EXPIRATION,
-				 nf_jiffies64_to_msecs(expires),
-				 NFTA_SET_ELEM_PAD))
-			goto nla_put_failure;
+			expires = READ_ONCE(nft_set_ext_timeout(ext)->expiration);
+			if (time_before64(now, expires))
+				expires -= now;
+			else
+				expires = 0;
+
+			if (nla_put_be64(skb, NFTA_SET_ELEM_EXPIRATION,
+					 nf_jiffies64_to_msecs(expires),
+					 NFTA_SET_ELEM_PAD))
+				goto nla_put_failure;
+		}
 	}
 
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_USERDATA)) {
@@ -6498,7 +6517,10 @@ struct nft_elem_priv *nft_set_elem_init(const struct nft_set *set,
 		if (expiration == 0)
 			expiration = timeout;
 
-		nft_set_ext_timeout(ext)->expiration = get_jiffies_64() + expiration;
+		if (timeout != NFT_NEVER_EXPIRES)
+			expiration += get_jiffies_64();
+
+		nft_set_ext_timeout(ext)->expiration = expiration;
 	}
 
 	return elem;
@@ -6904,24 +6926,27 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	if (nla[NFTA_SET_ELEM_TIMEOUT] != NULL) {
 		if (!(set->flags & NFT_SET_TIMEOUT))
 			return -EINVAL;
+
 		err = nf_msecs_to_jiffies64(nla[NFTA_SET_ELEM_TIMEOUT],
-					    &timeout);
+					    &timeout, true);
 		if (err)
 			return err;
 	} else if (set->flags & NFT_SET_TIMEOUT &&
 		   !(flags & NFT_SET_ELEM_INTERVAL_END)) {
 		timeout = set->timeout;
+		if (timeout == 0)
+			timeout = NFT_NEVER_EXPIRES;
 	}
 
 	expiration = 0;
 	if (nla[NFTA_SET_ELEM_EXPIRATION] != NULL) {
 		if (!(set->flags & NFT_SET_TIMEOUT))
 			return -EINVAL;
-		if (timeout == 0)
+		if (timeout == 0 || timeout == NFT_NEVER_EXPIRES)
 			return -EOPNOTSUPP;
 
 		err = nf_msecs_to_jiffies64(nla[NFTA_SET_ELEM_EXPIRATION],
-					    &expiration);
+					    &expiration, false);
 		if (err)
 			return err;
 	}
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 88ea2454c6df..39e773b1c612 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -94,7 +94,8 @@ void nft_dynset_eval(const struct nft_expr *expr,
 	if (set->ops->update(set, &regs->data[priv->sreg_key], nft_dynset_new,
 			     expr, regs, &ext)) {
 		if (priv->op == NFT_DYNSET_OP_UPDATE &&
-		    nft_set_ext_exists(ext, NFT_SET_EXT_TIMEOUT)) {
+		    nft_set_ext_exists(ext, NFT_SET_EXT_TIMEOUT) &&
+		    nft_set_ext_timeout(ext)->timeout != NFT_NEVER_EXPIRES) {
 			timeout = priv->timeout ? : READ_ONCE(set->timeout);
 			WRITE_ONCE(nft_set_ext_timeout(ext)->expiration, get_jiffies_64() + timeout);
 		}
@@ -210,7 +211,8 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 		if (!(set->flags & NFT_SET_TIMEOUT))
 			return -EOPNOTSUPP;
 
-		err = nf_msecs_to_jiffies64(tb[NFTA_DYNSET_TIMEOUT], &timeout);
+		err = nf_msecs_to_jiffies64(tb[NFTA_DYNSET_TIMEOUT], &timeout,
+					    false);
 		if (err)
 			return err;
 	}
diff --git a/net/netfilter/nft_last.c b/net/netfilter/nft_last.c
index de1b6066bfa8..9a0faba16d2d 100644
--- a/net/netfilter/nft_last.c
+++ b/net/netfilter/nft_last.c
@@ -38,7 +38,8 @@ static int nft_last_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		last->set = ntohl(nla_get_be32(tb[NFTA_LAST_SET]));
 
 	if (last->set && tb[NFTA_LAST_MSECS]) {
-		err = nf_msecs_to_jiffies64(tb[NFTA_LAST_MSECS], &last_jiffies);
+		err = nf_msecs_to_jiffies64(tb[NFTA_LAST_MSECS], &last_jiffies,
+					    false);
 		if (err < 0)
 			goto err;
 
-- 
2.30.2

