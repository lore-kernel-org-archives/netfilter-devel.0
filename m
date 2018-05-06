From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 36/51] netfilter: nf_tables: support timeouts larger than 23 days
Date: Mon,  7 May 2018 00:46:54 +0200
Message-ID: <20180506224709.29100-37-pablo@netfilter.org>
References: <20180506224709.29100-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180506224709.29100-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Marco De Benedetto says:
 I would like to use a timeout of 30 days for elements in a set but it
 seems there is a some kind of problem above 24d20h31m23s.

Fix this by using 'jiffies64' for timeout handling to get same behaviour
on 32 and 64bit systems.

nftables passes timeouts as u64 in milliseconds to the kernel,
but on kernel side we used a mixture of 'long' and jiffies conversions
rather than u64 and jiffies64.

Bugzilla: https://bugzilla.netfilter.org/show_bug.cgi?id=1237
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  4 ++--
 net/netfilter/nf_tables_api.c     | 50 +++++++++++++++++++++++++++++----------
 2 files changed, 39 insertions(+), 15 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index de77d36e36b3..435c9e3b9181 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -585,7 +585,7 @@ static inline u64 *nft_set_ext_timeout(const struct nft_set_ext *ext)
 	return nft_set_ext(ext, NFT_SET_EXT_TIMEOUT);
 }
 
-static inline unsigned long *nft_set_ext_expiration(const struct nft_set_ext *ext)
+static inline u64 *nft_set_ext_expiration(const struct nft_set_ext *ext)
 {
 	return nft_set_ext(ext, NFT_SET_EXT_EXPIRATION);
 }
@@ -603,7 +603,7 @@ static inline struct nft_expr *nft_set_ext_expr(const struct nft_set_ext *ext)
 static inline bool nft_set_elem_expired(const struct nft_set_ext *ext)
 {
 	return nft_set_ext_exists(ext, NFT_SET_EXT_EXPIRATION) &&
-	       time_is_before_eq_jiffies(*nft_set_ext_expiration(ext));
+	       time_is_before_eq_jiffies64(*nft_set_ext_expiration(ext));
 }
 
 static inline struct nft_set_ext *nft_set_elem_ext(const struct nft_set *set,
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 9ce35acf491d..d57aeea89a79 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2779,6 +2779,27 @@ static int nf_tables_set_alloc_name(struct nft_ctx *ctx, struct nft_set *set,
 	return 0;
 }
 
+static int nf_msecs_to_jiffies64(const struct nlattr *nla, u64 *result)
+{
+	u64 ms = be64_to_cpu(nla_get_be64(nla));
+	u64 max = (u64)(~((u64)0));
+
+	max = div_u64(max, NSEC_PER_MSEC);
+	if (ms >= max)
+		return -ERANGE;
+
+	ms *= NSEC_PER_MSEC;
+	*result = nsecs_to_jiffies64(ms);
+	return 0;
+}
+
+static u64 nf_jiffies64_to_msecs(u64 input)
+{
+	u64 ms = jiffies64_to_nsecs(input);
+
+	return cpu_to_be64(div_u64(ms, NSEC_PER_MSEC));
+}
+
 static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
 			      const struct nft_set *set, u16 event, u16 flags)
 {
@@ -2826,7 +2847,7 @@ static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
 
 	if (set->timeout &&
 	    nla_put_be64(skb, NFTA_SET_TIMEOUT,
-			 cpu_to_be64(jiffies_to_msecs(set->timeout)),
+			 nf_jiffies64_to_msecs(set->timeout),
 			 NFTA_SET_PAD))
 		goto nla_put_failure;
 	if (set->gc_int &&
@@ -3122,8 +3143,10 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 	if (nla[NFTA_SET_TIMEOUT] != NULL) {
 		if (!(flags & NFT_SET_TIMEOUT))
 			return -EINVAL;
-		timeout = msecs_to_jiffies(be64_to_cpu(nla_get_be64(
-						nla[NFTA_SET_TIMEOUT])));
+
+		err = nf_msecs_to_jiffies64(nla[NFTA_SET_TIMEOUT], &timeout);
+		if (err)
+			return err;
 	}
 	gc_int = 0;
 	if (nla[NFTA_SET_GC_INTERVAL] != NULL) {
@@ -3387,8 +3410,8 @@ const struct nft_set_ext_type nft_set_ext_types[] = {
 		.align	= __alignof__(u64),
 	},
 	[NFT_SET_EXT_EXPIRATION]	= {
-		.len	= sizeof(unsigned long),
-		.align	= __alignof__(unsigned long),
+		.len	= sizeof(u64),
+		.align	= __alignof__(u64),
 	},
 	[NFT_SET_EXT_USERDATA]		= {
 		.len	= sizeof(struct nft_userdata),
@@ -3481,22 +3504,21 @@ static int nf_tables_fill_setelem(struct sk_buff *skb,
 
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_TIMEOUT) &&
 	    nla_put_be64(skb, NFTA_SET_ELEM_TIMEOUT,
-			 cpu_to_be64(jiffies_to_msecs(
-						*nft_set_ext_timeout(ext))),
+			 nf_jiffies64_to_msecs(*nft_set_ext_timeout(ext)),
 			 NFTA_SET_ELEM_PAD))
 		goto nla_put_failure;
 
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_EXPIRATION)) {
-		unsigned long expires, now = jiffies;
+		u64 expires, now = get_jiffies_64();
 
 		expires = *nft_set_ext_expiration(ext);
-		if (time_before(now, expires))
+		if (time_before64(now, expires))
 			expires -= now;
 		else
 			expires = 0;
 
 		if (nla_put_be64(skb, NFTA_SET_ELEM_EXPIRATION,
-				 cpu_to_be64(jiffies_to_msecs(expires)),
+				 nf_jiffies64_to_msecs(expires),
 				 NFTA_SET_ELEM_PAD))
 			goto nla_put_failure;
 	}
@@ -3871,7 +3893,7 @@ void *nft_set_elem_init(const struct nft_set *set,
 		memcpy(nft_set_ext_data(ext), data, set->dlen);
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_EXPIRATION))
 		*nft_set_ext_expiration(ext) =
-			jiffies + timeout;
+			get_jiffies_64() + timeout;
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_TIMEOUT))
 		*nft_set_ext_timeout(ext) = timeout;
 
@@ -3958,8 +3980,10 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	if (nla[NFTA_SET_ELEM_TIMEOUT] != NULL) {
 		if (!(set->flags & NFT_SET_TIMEOUT))
 			return -EINVAL;
-		timeout = msecs_to_jiffies(be64_to_cpu(nla_get_be64(
-					nla[NFTA_SET_ELEM_TIMEOUT])));
+		err = nf_msecs_to_jiffies64(nla[NFTA_SET_ELEM_TIMEOUT],
+					    &timeout);
+		if (err)
+			return err;
 	} else if (set->flags & NFT_SET_TIMEOUT) {
 		timeout = set->timeout;
 	}
-- 
2.11.0
