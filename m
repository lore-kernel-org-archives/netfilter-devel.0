Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B7101B5839;
	Thu,  5 Sep 2024 23:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725578987; cv=none; b=UG8d5CzV5gJVpHkJwcLcLaNSw/4EFG7lFt4PaOn+P/TC1WdlRtKw6XF55t4ZS0tnU3pYArva6q1F8qHkBeCED9zFws8EvHtyrKbFIWLksZxtoQJZmRfsKqdQ0ZF/llgvGNbyX0UNaM3IQroCo9Mamqqv7Rc2trVr6UC8/aGD2Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725578987; c=relaxed/simple;
	bh=6pHb64XzbpmgxwVSfU15wHfHUw0nf8TKqhuhEraXdNA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ErVNflq0bxjj1mqXuKphgYpux+hE5u1nD1MBKVdLv2bzg4n+tI8xG7LqhPcP8tMeI/tcZcoVT+u5yl7+AznAXAlywZyqHWff+owTSBlo79ziCZ5rAPih4mYy0lAtSRgom63an9YcKvLdICtksaYOAcerf7aqr0fuQJxHXsjFo6Y=
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
Subject: [PATCH net-next 15/16] netfilter: nf_tables: zero timeout means element never times out
Date: Fri,  6 Sep 2024 01:29:19 +0200
Message-Id: <20240905232920.5481-16-pablo@netfilter.org>
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

This patch uses zero as timeout marker for those elements that never expire
when the element is created.

If userspace provides no timeout for an element, then the default set
timeout applies. However, if no default set timeout is specified and
timeout flag is set on, then timeout extension is allocated and timeout
is set to zero to allow for future updates.

Use of zero a never timeout marker has been suggested by Phil Sutter.

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
 include/net/netfilter/nf_tables.h        |  7 +++--
 include/uapi/linux/netfilter/nf_tables.h |  2 +-
 net/netfilter/nf_tables_api.c            | 39 ++++++++++++++----------
 net/netfilter/nft_dynset.c               |  3 +-
 4 files changed, 31 insertions(+), 20 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 1e9b5e1659a1..7511918dce6f 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -832,8 +832,11 @@ static inline struct nft_set_elem_expr *nft_set_ext_expr(const struct nft_set_ex
 static inline bool __nft_set_elem_expired(const struct nft_set_ext *ext,
 					  u64 tstamp)
 {
-	return nft_set_ext_exists(ext, NFT_SET_EXT_TIMEOUT) &&
-	       time_after_eq64(tstamp, READ_ONCE(nft_set_ext_timeout(ext)->expiration));
+	if (!nft_set_ext_exists(ext, NFT_SET_EXT_TIMEOUT) ||
+	    nft_set_ext_timeout(ext)->timeout == 0)
+		return false;
+
+	return time_after_eq64(tstamp, READ_ONCE(nft_set_ext_timeout(ext)->expiration));
 }
 
 static inline bool nft_set_elem_expired(const struct nft_set_ext *ext)
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 639894ed1b97..d6476ca5d7a6 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -436,7 +436,7 @@ enum nft_set_elem_flags {
  * @NFTA_SET_ELEM_KEY: key value (NLA_NESTED: nft_data)
  * @NFTA_SET_ELEM_DATA: data value of mapping (NLA_NESTED: nft_data_attributes)
  * @NFTA_SET_ELEM_FLAGS: bitmask of nft_set_elem_flags (NLA_U32)
- * @NFTA_SET_ELEM_TIMEOUT: timeout value (NLA_U64)
+ * @NFTA_SET_ELEM_TIMEOUT: timeout value, zero means never times out (NLA_U64)
  * @NFTA_SET_ELEM_EXPIRATION: expiration time (NLA_U64)
  * @NFTA_SET_ELEM_USERDATA: user data (NLA_BINARY)
  * @NFTA_SET_ELEM_EXPR: expression (NLA_NESTED: nft_expr_attributes)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c295d6e6c1fb..ed85b10edb32 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5815,24 +5815,31 @@ static int nf_tables_fill_setelem(struct sk_buff *skb,
 		goto nla_put_failure;
 
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_TIMEOUT)) {
-		u64 expires, now = get_jiffies_64();
+		u64 timeout = nft_set_ext_timeout(ext)->timeout;
+		u64 set_timeout = READ_ONCE(set->timeout);
+		__be64 msecs = 0;
+
+		if (set_timeout != timeout) {
+			msecs = nf_jiffies64_to_msecs(timeout);
+			if (nla_put_be64(skb, NFTA_SET_ELEM_TIMEOUT, msecs,
+					 NFTA_SET_ELEM_PAD))
+				goto nla_put_failure;
+		}
 
-		if (nft_set_ext_timeout(ext)->timeout != READ_ONCE(set->timeout) &&
-		    nla_put_be64(skb, NFTA_SET_ELEM_TIMEOUT,
-				 nf_jiffies64_to_msecs(nft_set_ext_timeout(ext)->timeout),
-				 NFTA_SET_ELEM_PAD))
-			goto nla_put_failure;
+		if (timeout > 0) {
+			u64 expires, now = get_jiffies_64();
 
-		expires = READ_ONCE(nft_set_ext_timeout(ext)->expiration);
-		if (time_before64(now, expires))
-			expires -= now;
-		else
-			expires = 0;
+			expires = READ_ONCE(nft_set_ext_timeout(ext)->expiration);
+			if (time_before64(now, expires))
+				expires -= now;
+			else
+				expires = 0;
 
-		if (nla_put_be64(skb, NFTA_SET_ELEM_EXPIRATION,
-				 nf_jiffies64_to_msecs(expires),
-				 NFTA_SET_ELEM_PAD))
-			goto nla_put_failure;
+			if (nla_put_be64(skb, NFTA_SET_ELEM_EXPIRATION,
+					 nf_jiffies64_to_msecs(expires),
+					 NFTA_SET_ELEM_PAD))
+				goto nla_put_failure;
+		}
 	}
 
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_USERDATA)) {
@@ -7015,7 +7022,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			goto err_parse_key_end;
 	}
 
-	if (timeout > 0) {
+	if (set->flags & NFT_SET_TIMEOUT) {
 		err = nft_set_ext_add(&tmpl, NFT_SET_EXT_TIMEOUT);
 		if (err < 0)
 			goto err_parse_key_end;
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index ed8d692bebe3..6a10305de24b 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -94,7 +94,8 @@ void nft_dynset_eval(const struct nft_expr *expr,
 	if (set->ops->update(set, &regs->data[priv->sreg_key], nft_dynset_new,
 			     expr, regs, &ext)) {
 		if (priv->op == NFT_DYNSET_OP_UPDATE &&
-		    nft_set_ext_exists(ext, NFT_SET_EXT_TIMEOUT)) {
+		    nft_set_ext_exists(ext, NFT_SET_EXT_TIMEOUT) &&
+		    nft_set_ext_timeout(ext)->timeout != 0) {
 			timeout = priv->timeout ? : READ_ONCE(set->timeout);
 			WRITE_ONCE(nft_set_ext_timeout(ext)->expiration, get_jiffies_64() + timeout);
 		}
-- 
2.30.2

