Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="pKKwPoqy"
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D32B910D
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Dec 2023 11:02:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=plKE3lbpi+bupUTFA1LQvHqZt0UNiZhFDZY0aoOOYz4=; b=pKKwPoqyom+T7xJBpwbnDmXL1c
	NrVu8NpNIF+w3EdLzChjoRnYjgiiVgyX2DRf6lSe0fWpuzKl+c9BOi2CBdGA2mSsr6h9UaZ+qUbYK
	eIYZyF6WoO6wl/0Ss27CLyzvX67qMehFQ5Rk9VEfb6F5SpJ7RY+XXAp9+BVq/xUXwTvHfH0Scbjv+
	pRSJ/QVzYdDWbNlw42pthkZYb5uCLd89Npqhio07xesSmAnmTFXGlg+uvp+Zu/C4k7s+Mh8TiNmF/
	+rk1mV24TB6zaXk6PVl7J3i5ZluzXgh0oJutuWfWlldwVKMzOK8AHB2QONBjYP2yj4XFgwqIYMekN
	j1NV5rZg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rDUV1-0006PC-LM; Wed, 13 Dec 2023 20:02:27 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: [libnftnl RFC 1/2] expr: Repurpose struct expr_ops::max_attr field
Date: Wed, 13 Dec 2023 20:02:21 +0100
Message-ID: <20231213190222.3681-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instead of holding the maximum kernel space (NFTA_*) attribute value,
use it to hold the maximum expression attribute (NFTNL_EXPR_*) value
instead. This will be used for index boundary checks in an attribute
policy array later.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/expr_ops.h      |  2 +-
 include/libnftnl/expr.h | 39 +++++++++++++++++++++++++++++++++++++++
 src/expr/bitwise.c      |  2 +-
 src/expr/byteorder.c    |  2 +-
 src/expr/cmp.c          |  2 +-
 src/expr/connlimit.c    |  2 +-
 src/expr/counter.c      |  2 +-
 src/expr/ct.c           |  2 +-
 src/expr/dup.c          |  2 +-
 src/expr/dynset.c       |  2 +-
 src/expr/exthdr.c       |  2 +-
 src/expr/fib.c          |  2 +-
 src/expr/flow_offload.c |  2 +-
 src/expr/fwd.c          |  2 +-
 src/expr/hash.c         |  2 +-
 src/expr/immediate.c    |  2 +-
 src/expr/inner.c        |  2 +-
 src/expr/last.c         |  2 +-
 src/expr/limit.c        |  2 +-
 src/expr/log.c          |  2 +-
 src/expr/lookup.c       |  2 +-
 src/expr/masq.c         |  2 +-
 src/expr/match.c        |  2 +-
 src/expr/meta.c         |  2 +-
 src/expr/nat.c          |  2 +-
 src/expr/numgen.c       |  2 +-
 src/expr/objref.c       |  2 +-
 src/expr/osf.c          |  2 +-
 src/expr/payload.c      |  2 +-
 src/expr/queue.c        |  2 +-
 src/expr/quota.c        |  2 +-
 src/expr/range.c        |  2 +-
 src/expr/redir.c        |  2 +-
 src/expr/reject.c       |  2 +-
 src/expr/rt.c           |  2 +-
 src/expr/socket.c       |  2 +-
 src/expr/synproxy.c     |  2 +-
 src/expr/target.c       |  2 +-
 src/expr/tproxy.c       |  2 +-
 src/expr/tunnel.c       |  2 +-
 src/expr/xfrm.c         |  2 +-
 41 files changed, 79 insertions(+), 40 deletions(-)

diff --git a/include/expr_ops.h b/include/expr_ops.h
index a7d747a2568a0..51b221483552c 100644
--- a/include/expr_ops.h
+++ b/include/expr_ops.h
@@ -11,7 +11,7 @@ struct nftnl_expr;
 struct expr_ops {
 	const char *name;
 	uint32_t alloc_len;
-	int	max_attr;
+	int	nftnl_max_attr;
 	void	(*init)(const struct nftnl_expr *e);
 	void	(*free)(const struct nftnl_expr *e);
 	int	(*set)(struct nftnl_expr *e, uint16_t type, const void *data, uint32_t data_len);
diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index 9873228dd794a..fba1210622440 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -56,6 +56,7 @@ enum {
 	NFTNL_EXPR_PAYLOAD_CSUM_TYPE,
 	NFTNL_EXPR_PAYLOAD_CSUM_OFFSET,
 	NFTNL_EXPR_PAYLOAD_FLAGS,
+	__NFTNL_EXPR_PAYLOAD_MAX
 };
 
 enum {
@@ -65,34 +66,40 @@ enum {
 	NFTNL_EXPR_NG_OFFSET,
 	NFTNL_EXPR_NG_SET_NAME,		/* deprecated */
 	NFTNL_EXPR_NG_SET_ID,		/* deprecated */
+	__NFTNL_EXPR_NG_MAX
 };
 
 enum {
 	NFTNL_EXPR_META_KEY	= NFTNL_EXPR_BASE,
 	NFTNL_EXPR_META_DREG,
 	NFTNL_EXPR_META_SREG,
+	__NFTNL_EXPR_META_MAX
 };
 
 enum {
 	NFTNL_EXPR_RT_KEY	= NFTNL_EXPR_BASE,
 	NFTNL_EXPR_RT_DREG,
+	__NFTNL_EXPR_RT_MAX
 };
 
 enum {
 	NFTNL_EXPR_SOCKET_KEY	= NFTNL_EXPR_BASE,
 	NFTNL_EXPR_SOCKET_DREG,
 	NFTNL_EXPR_SOCKET_LEVEL,
+	__NFTNL_EXPR_SOCKET_MAX
 };
 
 enum {
 	NFTNL_EXPR_TUNNEL_KEY	= NFTNL_EXPR_BASE,
 	NFTNL_EXPR_TUNNEL_DREG,
+	__NFTNL_EXPR_TUNNEL_MAX
 };
 
 enum {
 	NFTNL_EXPR_CMP_SREG	= NFTNL_EXPR_BASE,
 	NFTNL_EXPR_CMP_OP,
 	NFTNL_EXPR_CMP_DATA,
+	__NFTNL_EXPR_CMP_MAX
 };
 
 enum {
@@ -100,6 +107,7 @@ enum {
 	NFTNL_EXPR_RANGE_OP,
 	NFTNL_EXPR_RANGE_FROM_DATA,
 	NFTNL_EXPR_RANGE_TO_DATA,
+	__NFTNL_EXPR_RANGE_MAX
 };
 
 enum {
@@ -108,16 +116,19 @@ enum {
 	NFTNL_EXPR_IMM_VERDICT,
 	NFTNL_EXPR_IMM_CHAIN,
 	NFTNL_EXPR_IMM_CHAIN_ID,
+	__NFTNL_EXPR_IMM_MAX
 };
 
 enum {
 	NFTNL_EXPR_CTR_PACKETS	= NFTNL_EXPR_BASE,
 	NFTNL_EXPR_CTR_BYTES,
+	__NFTNL_EXPR_CTR_MAX
 };
 
 enum {
 	NFTNL_EXPR_CONNLIMIT_COUNT = NFTNL_EXPR_BASE,
 	NFTNL_EXPR_CONNLIMIT_FLAGS,
+	__NFTNL_EXPR_CONNLIMIT_MAX
 };
 
 enum {
@@ -128,18 +139,21 @@ enum {
 	NFTNL_EXPR_BITWISE_XOR,
 	NFTNL_EXPR_BITWISE_OP,
 	NFTNL_EXPR_BITWISE_DATA,
+	__NFTNL_EXPR_BITWISE_MAX
 };
 
 enum {
 	NFTNL_EXPR_TG_NAME	= NFTNL_EXPR_BASE,
 	NFTNL_EXPR_TG_REV,
 	NFTNL_EXPR_TG_INFO,
+	__NFTNL_EXPR_TG_MAX
 };
 
 enum {
 	NFTNL_EXPR_MT_NAME	= NFTNL_EXPR_BASE,
 	NFTNL_EXPR_MT_REV,
 	NFTNL_EXPR_MT_INFO,
+	__NFTNL_EXPR_MT_MAX
 };
 
 enum {
@@ -150,12 +164,14 @@ enum {
 	NFTNL_EXPR_NAT_REG_PROTO_MIN,
 	NFTNL_EXPR_NAT_REG_PROTO_MAX,
 	NFTNL_EXPR_NAT_FLAGS,
+	__NFTNL_EXPR_NAT_MAX
 };
 
 enum {
 	NFTNL_EXPR_TPROXY_FAMILY	= NFTNL_EXPR_BASE,
 	NFTNL_EXPR_TPROXY_REG_ADDR,
 	NFTNL_EXPR_TPROXY_REG_PORT,
+	__NFTNL_EXPR_TPROXY_MAX
 };
 
 enum {
@@ -164,6 +180,7 @@ enum {
 	NFTNL_EXPR_LOOKUP_SET,
 	NFTNL_EXPR_LOOKUP_SET_ID,
 	NFTNL_EXPR_LOOKUP_FLAGS,
+	__NFTNL_EXPR_LOOKUP_MAX
 };
 
 enum {
@@ -176,6 +193,7 @@ enum {
 	NFTNL_EXPR_DYNSET_EXPR,
 	NFTNL_EXPR_DYNSET_EXPRESSIONS,
 	NFTNL_EXPR_DYNSET_FLAGS,
+	__NFTNL_EXPR_DYNSET_MAX
 };
 
 enum {
@@ -185,6 +203,7 @@ enum {
 	NFTNL_EXPR_LOG_QTHRESHOLD,
 	NFTNL_EXPR_LOG_LEVEL,
 	NFTNL_EXPR_LOG_FLAGS,
+	__NFTNL_EXPR_LOG_MAX
 };
 
 enum {
@@ -195,6 +214,7 @@ enum {
 	NFTNL_EXPR_EXTHDR_FLAGS,
 	NFTNL_EXPR_EXTHDR_OP,
 	NFTNL_EXPR_EXTHDR_SREG,
+	__NFTNL_EXPR_EXTHDR_MAX
 };
 
 enum {
@@ -202,6 +222,7 @@ enum {
 	NFTNL_EXPR_CT_KEY,
 	NFTNL_EXPR_CT_DIR,
 	NFTNL_EXPR_CT_SREG,
+	__NFTNL_EXPR_CT_MAX
 };
 
 enum {
@@ -210,6 +231,7 @@ enum {
 	NFTNL_EXPR_BYTEORDER_OP,
 	NFTNL_EXPR_BYTEORDER_LEN,
 	NFTNL_EXPR_BYTEORDER_SIZE,
+	__NFTNL_EXPR_BYTEORDER_MAX
 };
 
 enum {
@@ -218,11 +240,13 @@ enum {
 	NFTNL_EXPR_LIMIT_BURST,
 	NFTNL_EXPR_LIMIT_TYPE,
 	NFTNL_EXPR_LIMIT_FLAGS,
+	__NFTNL_EXPR_LIMIT_MAX
 };
 
 enum {
 	NFTNL_EXPR_REJECT_TYPE	= NFTNL_EXPR_BASE,
 	NFTNL_EXPR_REJECT_CODE,
+	__NFTNL_EXPR_REJECT_MAX
 };
 
 enum {
@@ -230,39 +254,46 @@ enum {
 	NFTNL_EXPR_QUEUE_TOTAL,
 	NFTNL_EXPR_QUEUE_FLAGS,
 	NFTNL_EXPR_QUEUE_SREG_QNUM,
+	__NFTNL_EXPR_QUEUE_MAX
 };
 
 enum {
 	NFTNL_EXPR_QUOTA_BYTES	= NFTNL_EXPR_BASE,
 	NFTNL_EXPR_QUOTA_FLAGS,
 	NFTNL_EXPR_QUOTA_CONSUMED,
+	__NFTNL_EXPR_QUOTA_MAX
 };
 
 enum {
 	NFTNL_EXPR_MASQ_FLAGS		= NFTNL_EXPR_BASE,
 	NFTNL_EXPR_MASQ_REG_PROTO_MIN,
 	NFTNL_EXPR_MASQ_REG_PROTO_MAX,
+	__NFTNL_EXPR_MASQ_MAX
 };
 
 enum {
 	NFTNL_EXPR_REDIR_REG_PROTO_MIN	= NFTNL_EXPR_BASE,
 	NFTNL_EXPR_REDIR_REG_PROTO_MAX,
 	NFTNL_EXPR_REDIR_FLAGS,
+	__NFTNL_EXPR_REDIR_MAX
 };
 
 enum {
 	NFTNL_EXPR_DUP_SREG_ADDR = NFTNL_EXPR_BASE,
 	NFTNL_EXPR_DUP_SREG_DEV,
+	__NFTNL_EXPR_DUP_MAX
 };
 
 enum {
 	NFTNL_EXPR_FLOW_TABLE_NAME = NFTNL_EXPR_BASE,
+	__NFTNL_EXPR_FLOW_MAX
 };
 
 enum {
 	NFTNL_EXPR_FWD_SREG_DEV = NFTNL_EXPR_BASE,
 	NFTNL_EXPR_FWD_SREG_ADDR,
 	NFTNL_EXPR_FWD_NFPROTO,
+	__NFTNL_EXPR_FWD_MAX
 };
 
 enum {
@@ -275,12 +306,14 @@ enum {
 	NFTNL_EXPR_HASH_TYPE,
 	NFTNL_EXPR_HASH_SET_NAME,	/* deprecated */
 	NFTNL_EXPR_HASH_SET_ID,		/* deprecated */
+	__NFTNL_EXPR_HASH_MAX
 };
 
 enum {
 	NFTNL_EXPR_FIB_DREG	= NFTNL_EXPR_BASE,
 	NFTNL_EXPR_FIB_RESULT,
 	NFTNL_EXPR_FIB_FLAGS,
+	__NFTNL_EXPR_FIB_MAX
 };
 
 enum {
@@ -289,12 +322,14 @@ enum {
 	NFTNL_EXPR_OBJREF_SET_SREG,
 	NFTNL_EXPR_OBJREF_SET_NAME,
 	NFTNL_EXPR_OBJREF_SET_ID,
+	__NFTNL_EXPR_OBJREF_MAX
 };
 
 enum {
 	NFTNL_EXPR_OSF_DREG	= NFTNL_EXPR_BASE,
 	NFTNL_EXPR_OSF_TTL,
 	NFTNL_EXPR_OSF_FLAGS,
+	__NFTNL_EXPR_OSF_MAX
 };
 
 enum {
@@ -303,17 +338,20 @@ enum {
 	NFTNL_EXPR_XFRM_KEY,
 	NFTNL_EXPR_XFRM_DIR,
 	NFTNL_EXPR_XFRM_SPNUM,
+	__NFTNL_EXPR_XFRM_MAX
 };
 
 enum {
 	NFTNL_EXPR_SYNPROXY_MSS	= NFTNL_EXPR_BASE,
 	NFTNL_EXPR_SYNPROXY_WSCALE,
 	NFTNL_EXPR_SYNPROXY_FLAGS,
+	__NFTNL_EXPR_SYNPROXY_MAX
 };
 
 enum {
 	NFTNL_EXPR_LAST_MSECS = NFTNL_EXPR_BASE,
 	NFTNL_EXPR_LAST_SET,
+	__NFTNL_EXPR_LAST_MAX
 };
 
 enum {
@@ -321,6 +359,7 @@ enum {
 	NFTNL_EXPR_INNER_FLAGS,
 	NFTNL_EXPR_INNER_HDRSIZE,
 	NFTNL_EXPR_INNER_EXPR,
+	__NFTNL_EXPR_INNER_MAX
 };
 
 #ifdef __cplusplus
diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index 2d272335e3772..d11272fbd37b0 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -277,7 +277,7 @@ nftnl_expr_bitwise_snprintf(char *buf, size_t size,
 struct expr_ops expr_ops_bitwise = {
 	.name		= "bitwise",
 	.alloc_len	= sizeof(struct nftnl_expr_bitwise),
-	.max_attr	= NFTA_BITWISE_MAX,
+	.nftnl_max_attr	= __NFTNL_EXPR_BITWISE_MAX - 1,
 	.set		= nftnl_expr_bitwise_set,
 	.get		= nftnl_expr_bitwise_get,
 	.parse		= nftnl_expr_bitwise_parse,
diff --git a/src/expr/byteorder.c b/src/expr/byteorder.c
index 89ed0a8232af1..f05ae59b688eb 100644
--- a/src/expr/byteorder.c
+++ b/src/expr/byteorder.c
@@ -215,7 +215,7 @@ nftnl_expr_byteorder_snprintf(char *buf, size_t remain,
 struct expr_ops expr_ops_byteorder = {
 	.name		= "byteorder",
 	.alloc_len	= sizeof(struct nftnl_expr_byteorder),
-	.max_attr	= NFTA_BYTEORDER_MAX,
+	.nftnl_max_attr	= __NFTNL_EXPR_BYTEORDER_MAX - 1,
 	.set		= nftnl_expr_byteorder_set,
 	.get		= nftnl_expr_byteorder_get,
 	.parse		= nftnl_expr_byteorder_parse,
diff --git a/src/expr/cmp.c b/src/expr/cmp.c
index f9d15bba3b0fa..1393735b2be4d 100644
--- a/src/expr/cmp.c
+++ b/src/expr/cmp.c
@@ -197,7 +197,7 @@ nftnl_expr_cmp_snprintf(char *buf, size_t remain,
 struct expr_ops expr_ops_cmp = {
 	.name		= "cmp",
 	.alloc_len	= sizeof(struct nftnl_expr_cmp),
-	.max_attr	= NFTA_CMP_MAX,
+	.nftnl_max_attr	= __NFTNL_EXPR_CMP_MAX - 1,
 	.set		= nftnl_expr_cmp_set,
 	.get		= nftnl_expr_cmp_get,
 	.parse		= nftnl_expr_cmp_parse,
diff --git a/src/expr/connlimit.c b/src/expr/connlimit.c
index 549417bf31e6b..3b6c36c490636 100644
--- a/src/expr/connlimit.c
+++ b/src/expr/connlimit.c
@@ -130,7 +130,7 @@ static int nftnl_expr_connlimit_snprintf(char *buf, size_t len,
 struct expr_ops expr_ops_connlimit = {
 	.name		= "connlimit",
 	.alloc_len	= sizeof(struct nftnl_expr_connlimit),
-	.max_attr	= NFTA_CONNLIMIT_MAX,
+	.nftnl_max_attr	= __NFTNL_EXPR_CONNLIMIT_MAX - 1,
 	.set		= nftnl_expr_connlimit_set,
 	.get		= nftnl_expr_connlimit_get,
 	.parse		= nftnl_expr_connlimit_parse,
diff --git a/src/expr/counter.c b/src/expr/counter.c
index d139a5f758a0b..0595d505eb2fc 100644
--- a/src/expr/counter.c
+++ b/src/expr/counter.c
@@ -128,7 +128,7 @@ static int nftnl_expr_counter_snprintf(char *buf, size_t len,
 struct expr_ops expr_ops_counter = {
 	.name		= "counter",
 	.alloc_len	= sizeof(struct nftnl_expr_counter),
-	.max_attr	= NFTA_COUNTER_MAX,
+	.nftnl_max_attr	= __NFTNL_EXPR_CTR_MAX - 1,
 	.set		= nftnl_expr_counter_set,
 	.get		= nftnl_expr_counter_get,
 	.parse		= nftnl_expr_counter_parse,
diff --git a/src/expr/ct.c b/src/expr/ct.c
index f4a2aeaf31acc..36b61fdeaaf26 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -253,7 +253,7 @@ nftnl_expr_ct_snprintf(char *buf, size_t remain,
 struct expr_ops expr_ops_ct = {
 	.name		= "ct",
 	.alloc_len	= sizeof(struct nftnl_expr_ct),
-	.max_attr	= NFTA_CT_MAX,
+	.nftnl_max_attr	= __NFTNL_EXPR_CT_MAX - 1,
 	.set		= nftnl_expr_ct_set,
 	.get		= nftnl_expr_ct_get,
 	.parse		= nftnl_expr_ct_parse,
diff --git a/src/expr/dup.c b/src/expr/dup.c
index a239ff35640a6..33731cc29b165 100644
--- a/src/expr/dup.c
+++ b/src/expr/dup.c
@@ -133,7 +133,7 @@ static int nftnl_expr_dup_snprintf(char *buf, size_t remain,
 struct expr_ops expr_ops_dup = {
 	.name		= "dup",
 	.alloc_len	= sizeof(struct nftnl_expr_dup),
-	.max_attr	= NFTA_DUP_MAX,
+	.nftnl_max_attr	= __NFTNL_EXPR_DUP_MAX - 1,
 	.set		= nftnl_expr_dup_set,
 	.get		= nftnl_expr_dup_get,
 	.parse		= nftnl_expr_dup_parse,
diff --git a/src/expr/dynset.c b/src/expr/dynset.c
index 5bcf1c6f8b060..ee6ce1ec71563 100644
--- a/src/expr/dynset.c
+++ b/src/expr/dynset.c
@@ -366,7 +366,7 @@ static void nftnl_expr_dynset_free(const struct nftnl_expr *e)
 struct expr_ops expr_ops_dynset = {
 	.name		= "dynset",
 	.alloc_len	= sizeof(struct nftnl_expr_dynset),
-	.max_attr	= NFTA_DYNSET_MAX,
+	.nftnl_max_attr	= __NFTNL_EXPR_DYNSET_MAX - 1,
 	.init		= nftnl_expr_dynset_init,
 	.free		= nftnl_expr_dynset_free,
 	.set		= nftnl_expr_dynset_set,
diff --git a/src/expr/exthdr.c b/src/expr/exthdr.c
index 739c7ff2179f9..a1227a6cb4509 100644
--- a/src/expr/exthdr.c
+++ b/src/expr/exthdr.c
@@ -262,7 +262,7 @@ nftnl_expr_exthdr_snprintf(char *buf, size_t len,
 struct expr_ops expr_ops_exthdr = {
 	.name		= "exthdr",
 	.alloc_len	= sizeof(struct nftnl_expr_exthdr),
-	.max_attr	= NFTA_EXTHDR_MAX,
+	.nftnl_max_attr	= __NFTNL_EXPR_EXTHDR_MAX - 1,
 	.set		= nftnl_expr_exthdr_set,
 	.get		= nftnl_expr_exthdr_get,
 	.parse		= nftnl_expr_exthdr_parse,
diff --git a/src/expr/fib.c b/src/expr/fib.c
index 957f929ea912e..36637bd74f056 100644
--- a/src/expr/fib.c
+++ b/src/expr/fib.c
@@ -193,7 +193,7 @@ nftnl_expr_fib_snprintf(char *buf, size_t remain,
 struct expr_ops expr_ops_fib = {
 	.name		= "fib",
 	.alloc_len	= sizeof(struct nftnl_expr_fib),
-	.max_attr	= NFTA_FIB_MAX,
+	.nftnl_max_attr	= __NFTNL_EXPR_FIB_MAX - 1,
 	.set		= nftnl_expr_fib_set,
 	.get		= nftnl_expr_fib_get,
 	.parse		= nftnl_expr_fib_parse,
diff --git a/src/expr/flow_offload.c b/src/expr/flow_offload.c
index 4fc0563bfb537..f60471240cc40 100644
--- a/src/expr/flow_offload.c
+++ b/src/expr/flow_offload.c
@@ -114,7 +114,7 @@ static void nftnl_expr_flow_free(const struct nftnl_expr *e)
 struct expr_ops expr_ops_flow = {
 	.name		= "flow_offload",
 	.alloc_len	= sizeof(struct nftnl_expr_flow),
-	.max_attr	= NFTA_FLOW_MAX,
+	.nftnl_max_attr	= __NFTNL_EXPR_FLOW_MAX - 1,
 	.free		= nftnl_expr_flow_free,
 	.set		= nftnl_expr_flow_set,
 	.get		= nftnl_expr_flow_get,
diff --git a/src/expr/fwd.c b/src/expr/fwd.c
index 51f661258900f..3aaf328313cd9 100644
--- a/src/expr/fwd.c
+++ b/src/expr/fwd.c
@@ -153,7 +153,7 @@ static int nftnl_expr_fwd_snprintf(char *buf, size_t remain,
 struct expr_ops expr_ops_fwd = {
 	.name		= "fwd",
 	.alloc_len	= sizeof(struct nftnl_expr_fwd),
-	.max_attr	= NFTA_FWD_MAX,
+	.nftnl_max_attr	= __NFTNL_EXPR_FWD_MAX - 1,
 	.set		= nftnl_expr_fwd_set,
 	.get		= nftnl_expr_fwd_get,
 	.parse		= nftnl_expr_fwd_parse,
diff --git a/src/expr/hash.c b/src/expr/hash.c
index 6e2dd197fa708..1fc72ec331a3d 100644
--- a/src/expr/hash.c
+++ b/src/expr/hash.c
@@ -221,7 +221,7 @@ nftnl_expr_hash_snprintf(char *buf, size_t remain,
 struct expr_ops expr_ops_hash = {
 	.name		= "hash",
 	.alloc_len	= sizeof(struct nftnl_expr_hash),
-	.max_attr	= NFTA_HASH_MAX,
+	.nftnl_max_attr	= __NFTNL_EXPR_HASH_MAX - 1,
 	.set		= nftnl_expr_hash_set,
 	.get		= nftnl_expr_hash_get,
 	.parse		= nftnl_expr_hash_parse,
diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index 5d477a8b42176..2ffa0c5e9ebc3 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -223,7 +223,7 @@ static void nftnl_expr_immediate_free(const struct nftnl_expr *e)
 struct expr_ops expr_ops_immediate = {
 	.name		= "immediate",
 	.alloc_len	= sizeof(struct nftnl_expr_immediate),
-	.max_attr	= NFTA_IMMEDIATE_MAX,
+	.nftnl_max_attr	= __NFTNL_EXPR_IMM_MAX - 1,
 	.free		= nftnl_expr_immediate_free,
 	.set		= nftnl_expr_immediate_set,
 	.get		= nftnl_expr_immediate_get,
diff --git a/src/expr/inner.c b/src/expr/inner.c
index 7daae4f36adb0..cb6f607138ce3 100644
--- a/src/expr/inner.c
+++ b/src/expr/inner.c
@@ -204,7 +204,7 @@ nftnl_expr_inner_snprintf(char *buf, size_t remain, uint32_t flags,
 struct expr_ops expr_ops_inner = {
 	.name		= "inner",
 	.alloc_len	= sizeof(struct nftnl_expr_inner),
-	.max_attr	= NFTA_INNER_MAX,
+	.nftnl_max_attr	= __NFTNL_EXPR_INNER_MAX - 1,
 	.free		= nftnl_expr_inner_free,
 	.set		= nftnl_expr_inner_set,
 	.get		= nftnl_expr_inner_get,
diff --git a/src/expr/last.c b/src/expr/last.c
index 641b713fca66f..273aaa1e14a85 100644
--- a/src/expr/last.c
+++ b/src/expr/last.c
@@ -129,7 +129,7 @@ static int nftnl_expr_last_snprintf(char *buf, size_t len,
 struct expr_ops expr_ops_last = {
 	.name		= "last",
 	.alloc_len	= sizeof(struct nftnl_expr_last),
-	.max_attr	= NFTA_LAST_MAX,
+	.nftnl_max_attr	= __NFTNL_EXPR_LAST_MAX - 1,
 	.set		= nftnl_expr_last_set,
 	.get		= nftnl_expr_last_get,
 	.parse		= nftnl_expr_last_parse,
diff --git a/src/expr/limit.c b/src/expr/limit.c
index 1870e0e473a90..a1f9eac390d91 100644
--- a/src/expr/limit.c
+++ b/src/expr/limit.c
@@ -197,7 +197,7 @@ nftnl_expr_limit_snprintf(char *buf, size_t len,
 struct expr_ops expr_ops_limit = {
 	.name		= "limit",
 	.alloc_len	= sizeof(struct nftnl_expr_limit),
-	.max_attr	= NFTA_LIMIT_MAX,
+	.nftnl_max_attr	= __NFTNL_EXPR_LIMIT_MAX - 1,
 	.set		= nftnl_expr_limit_set,
 	.get		= nftnl_expr_limit_get,
 	.parse		= nftnl_expr_limit_parse,
diff --git a/src/expr/log.c b/src/expr/log.c
index 180d83973d706..6df030d83fcd2 100644
--- a/src/expr/log.c
+++ b/src/expr/log.c
@@ -247,7 +247,7 @@ static void nftnl_expr_log_free(const struct nftnl_expr *e)
 struct expr_ops expr_ops_log = {
 	.name		= "log",
 	.alloc_len	= sizeof(struct nftnl_expr_log),
-	.max_attr	= NFTA_LOG_MAX,
+	.nftnl_max_attr	= __NFTNL_EXPR_LOG_MAX - 1,
 	.free		= nftnl_expr_log_free,
 	.set		= nftnl_expr_log_set,
 	.get		= nftnl_expr_log_get,
diff --git a/src/expr/lookup.c b/src/expr/lookup.c
index a06c3385411ac..8b230818c1bed 100644
--- a/src/expr/lookup.c
+++ b/src/expr/lookup.c
@@ -200,7 +200,7 @@ static void nftnl_expr_lookup_free(const struct nftnl_expr *e)
 struct expr_ops expr_ops_lookup = {
 	.name		= "lookup",
 	.alloc_len	= sizeof(struct nftnl_expr_lookup),
-	.max_attr	= NFTA_LOOKUP_MAX,
+	.nftnl_max_attr	= __NFTNL_EXPR_LOOKUP_MAX - 1,
 	.free		= nftnl_expr_lookup_free,
 	.set		= nftnl_expr_lookup_set,
 	.get		= nftnl_expr_lookup_get,
diff --git a/src/expr/masq.c b/src/expr/masq.c
index e6e528d9acca8..a103cc33e23f7 100644
--- a/src/expr/masq.c
+++ b/src/expr/masq.c
@@ -158,7 +158,7 @@ static int nftnl_expr_masq_snprintf(char *buf, size_t remain,
 struct expr_ops expr_ops_masq = {
 	.name		= "masq",
 	.alloc_len	= sizeof(struct nftnl_expr_masq),
-	.max_attr	= NFTA_MASQ_MAX,
+	.nftnl_max_attr	= __NFTNL_EXPR_MASQ_MAX - 1,
 	.set		= nftnl_expr_masq_set,
 	.get		= nftnl_expr_masq_get,
 	.parse		= nftnl_expr_masq_parse,
diff --git a/src/expr/match.c b/src/expr/match.c
index f472add1cbc8e..eed85db4d40d1 100644
--- a/src/expr/match.c
+++ b/src/expr/match.c
@@ -183,7 +183,7 @@ static void nftnl_expr_match_free(const struct nftnl_expr *e)
 struct expr_ops expr_ops_match = {
 	.name		= "match",
 	.alloc_len	= sizeof(struct nftnl_expr_match),
-	.max_attr	= NFTA_MATCH_MAX,
+	.nftnl_max_attr	= __NFTNL_EXPR_MT_MAX - 1,
 	.free		= nftnl_expr_match_free,
 	.set		= nftnl_expr_match_set,
 	.get		= nftnl_expr_match_get,
diff --git a/src/expr/meta.c b/src/expr/meta.c
index 183f4412da218..f86fdffd3f14e 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -212,7 +212,7 @@ nftnl_expr_meta_snprintf(char *buf, size_t len,
 struct expr_ops expr_ops_meta = {
 	.name		= "meta",
 	.alloc_len	= sizeof(struct nftnl_expr_meta),
-	.max_attr	= NFTA_META_MAX,
+	.nftnl_max_attr	= __NFTNL_EXPR_META_MAX - 1,
 	.set		= nftnl_expr_meta_set,
 	.get		= nftnl_expr_meta_get,
 	.parse		= nftnl_expr_meta_parse,
diff --git a/src/expr/nat.c b/src/expr/nat.c
index ca727be0cda63..1d10bc1c5442d 100644
--- a/src/expr/nat.c
+++ b/src/expr/nat.c
@@ -269,7 +269,7 @@ nftnl_expr_nat_snprintf(char *buf, size_t remain,
 struct expr_ops expr_ops_nat = {
 	.name		= "nat",
 	.alloc_len	= sizeof(struct nftnl_expr_nat),
-	.max_attr	= NFTA_NAT_MAX,
+	.nftnl_max_attr	= __NFTNL_EXPR_NAT_MAX - 1,
 	.set		= nftnl_expr_nat_set,
 	.get		= nftnl_expr_nat_get,
 	.parse		= nftnl_expr_nat_parse,
diff --git a/src/expr/numgen.c b/src/expr/numgen.c
index d4020a6978e0c..3e83e05f2e3e0 100644
--- a/src/expr/numgen.c
+++ b/src/expr/numgen.c
@@ -175,7 +175,7 @@ nftnl_expr_ng_snprintf(char *buf, size_t remain,
 struct expr_ops expr_ops_ng = {
 	.name		= "numgen",
 	.alloc_len	= sizeof(struct nftnl_expr_ng),
-	.max_attr	= NFTA_NG_MAX,
+	.nftnl_max_attr	= __NFTNL_EXPR_NG_MAX - 1,
 	.set		= nftnl_expr_ng_set,
 	.get		= nftnl_expr_ng_get,
 	.parse		= nftnl_expr_ng_parse,
diff --git a/src/expr/objref.c b/src/expr/objref.c
index ad0688f46ec62..e96bd6977e93a 100644
--- a/src/expr/objref.c
+++ b/src/expr/objref.c
@@ -199,7 +199,7 @@ static void nftnl_expr_objref_free(const struct nftnl_expr *e)
 struct expr_ops expr_ops_objref = {
 	.name		= "objref",
 	.alloc_len	= sizeof(struct nftnl_expr_objref),
-	.max_attr	= NFTA_OBJREF_MAX,
+	.nftnl_max_attr	= __NFTNL_EXPR_OBJREF_MAX - 1,
 	.free		= nftnl_expr_objref_free,
 	.set		= nftnl_expr_objref_set,
 	.get		= nftnl_expr_objref_get,
diff --git a/src/expr/osf.c b/src/expr/osf.c
index f15a722233830..3838af72debeb 100644
--- a/src/expr/osf.c
+++ b/src/expr/osf.c
@@ -142,7 +142,7 @@ nftnl_expr_osf_snprintf(char *buf, size_t len,
 struct expr_ops expr_ops_osf = {
 	.name		= "osf",
 	.alloc_len	= sizeof(struct nftnl_expr_osf),
-	.max_attr	= NFTA_OSF_MAX,
+	.nftnl_max_attr	= __NFTNL_EXPR_OSF_MAX - 1,
 	.set		= nftnl_expr_osf_set,
 	.get		= nftnl_expr_osf_get,
 	.parse		= nftnl_expr_osf_parse,
diff --git a/src/expr/payload.c b/src/expr/payload.c
index c633e33bedd3e..f603662ac8da7 100644
--- a/src/expr/payload.c
+++ b/src/expr/payload.c
@@ -241,7 +241,7 @@ nftnl_expr_payload_snprintf(char *buf, size_t len,
 struct expr_ops expr_ops_payload = {
 	.name		= "payload",
 	.alloc_len	= sizeof(struct nftnl_expr_payload),
-	.max_attr	= NFTA_PAYLOAD_MAX,
+	.nftnl_max_attr	= __NFTNL_EXPR_PAYLOAD_MAX - 1,
 	.set		= nftnl_expr_payload_set,
 	.get		= nftnl_expr_payload_get,
 	.parse		= nftnl_expr_payload_parse,
diff --git a/src/expr/queue.c b/src/expr/queue.c
index de287f245d9a9..fba65d1003b31 100644
--- a/src/expr/queue.c
+++ b/src/expr/queue.c
@@ -188,7 +188,7 @@ nftnl_expr_queue_snprintf(char *buf, size_t remain,
 struct expr_ops expr_ops_queue = {
 	.name		= "queue",
 	.alloc_len	= sizeof(struct nftnl_expr_queue),
-	.max_attr	= NFTA_QUEUE_MAX,
+	.nftnl_max_attr	= __NFTNL_EXPR_QUEUE_MAX - 1,
 	.set		= nftnl_expr_queue_set,
 	.get		= nftnl_expr_queue_get,
 	.parse		= nftnl_expr_queue_parse,
diff --git a/src/expr/quota.c b/src/expr/quota.c
index 835729ceac17b..d3923f3197900 100644
--- a/src/expr/quota.c
+++ b/src/expr/quota.c
@@ -142,7 +142,7 @@ static int nftnl_expr_quota_snprintf(char *buf, size_t len,
 struct expr_ops expr_ops_quota = {
 	.name		= "quota",
 	.alloc_len	= sizeof(struct nftnl_expr_quota),
-	.max_attr	= NFTA_QUOTA_MAX,
+	.nftnl_max_attr	= __NFTNL_EXPR_QUOTA_MAX - 1,
 	.set		= nftnl_expr_quota_set,
 	.get		= nftnl_expr_quota_get,
 	.parse		= nftnl_expr_quota_parse,
diff --git a/src/expr/range.c b/src/expr/range.c
index 473add86e4b45..f3ac5cbc44dca 100644
--- a/src/expr/range.c
+++ b/src/expr/range.c
@@ -208,7 +208,7 @@ static int nftnl_expr_range_snprintf(char *buf, size_t remain,
 struct expr_ops expr_ops_range = {
 	.name		= "range",
 	.alloc_len	= sizeof(struct nftnl_expr_range),
-	.max_attr	= NFTA_RANGE_MAX,
+	.nftnl_max_attr	= __NFTNL_EXPR_RANGE_MAX - 1,
 	.set		= nftnl_expr_range_set,
 	.get		= nftnl_expr_range_get,
 	.parse		= nftnl_expr_range_parse,
diff --git a/src/expr/redir.c b/src/expr/redir.c
index 87c2accb923fa..eca8bfe1abd4c 100644
--- a/src/expr/redir.c
+++ b/src/expr/redir.c
@@ -162,7 +162,7 @@ nftnl_expr_redir_snprintf(char *buf, size_t remain,
 struct expr_ops expr_ops_redir = {
 	.name		= "redir",
 	.alloc_len	= sizeof(struct nftnl_expr_redir),
-	.max_attr	= NFTA_REDIR_MAX,
+	.nftnl_max_attr	= __NFTNL_EXPR_REDIR_MAX - 1,
 	.set		= nftnl_expr_redir_set,
 	.get		= nftnl_expr_redir_get,
 	.parse		= nftnl_expr_redir_parse,
diff --git a/src/expr/reject.c b/src/expr/reject.c
index c7c944124ca39..6b923adf5e569 100644
--- a/src/expr/reject.c
+++ b/src/expr/reject.c
@@ -129,7 +129,7 @@ nftnl_expr_reject_snprintf(char *buf, size_t len,
 struct expr_ops expr_ops_reject = {
 	.name		= "reject",
 	.alloc_len	= sizeof(struct nftnl_expr_reject),
-	.max_attr	= NFTA_REJECT_MAX,
+	.nftnl_max_attr	= __NFTNL_EXPR_REJECT_MAX - 1,
 	.set		= nftnl_expr_reject_set,
 	.get		= nftnl_expr_reject_get,
 	.parse		= nftnl_expr_reject_parse,
diff --git a/src/expr/rt.c b/src/expr/rt.c
index 695a6589b5c84..aaec43025011b 100644
--- a/src/expr/rt.c
+++ b/src/expr/rt.c
@@ -157,7 +157,7 @@ nftnl_expr_rt_snprintf(char *buf, size_t len,
 struct expr_ops expr_ops_rt = {
 	.name		= "rt",
 	.alloc_len	= sizeof(struct nftnl_expr_rt),
-	.max_attr	= NFTA_RT_MAX,
+	.nftnl_max_attr	= __NFTNL_EXPR_RT_MAX - 1,
 	.set		= nftnl_expr_rt_set,
 	.get		= nftnl_expr_rt_get,
 	.parse		= nftnl_expr_rt_parse,
diff --git a/src/expr/socket.c b/src/expr/socket.c
index 83045c075fb5b..ef299c456cdd1 100644
--- a/src/expr/socket.c
+++ b/src/expr/socket.c
@@ -160,7 +160,7 @@ nftnl_expr_socket_snprintf(char *buf, size_t len,
 struct expr_ops expr_ops_socket = {
 	.name		= "socket",
 	.alloc_len	= sizeof(struct nftnl_expr_socket),
-	.max_attr	= NFTA_SOCKET_MAX,
+	.nftnl_max_attr	= __NFTNL_EXPR_SOCKET_MAX - 1,
 	.set		= nftnl_expr_socket_set,
 	.get		= nftnl_expr_socket_get,
 	.parse		= nftnl_expr_socket_parse,
diff --git a/src/expr/synproxy.c b/src/expr/synproxy.c
index 47fcaefb23b1b..dc25962c00d81 100644
--- a/src/expr/synproxy.c
+++ b/src/expr/synproxy.c
@@ -147,7 +147,7 @@ nftnl_expr_synproxy_snprintf(char *buf, size_t len,
 struct expr_ops expr_ops_synproxy = {
 	.name		= "synproxy",
 	.alloc_len	= sizeof(struct nftnl_expr_synproxy),
-	.max_attr	= NFTA_SYNPROXY_MAX,
+	.nftnl_max_attr	= __NFTNL_EXPR_SYNPROXY_MAX - 1,
 	.set		= nftnl_expr_synproxy_set,
 	.get		= nftnl_expr_synproxy_get,
 	.parse		= nftnl_expr_synproxy_parse,
diff --git a/src/expr/target.c b/src/expr/target.c
index 2a3fe8ae1020d..ebc48bafb06cc 100644
--- a/src/expr/target.c
+++ b/src/expr/target.c
@@ -183,7 +183,7 @@ static void nftnl_expr_target_free(const struct nftnl_expr *e)
 struct expr_ops expr_ops_target = {
 	.name		= "target",
 	.alloc_len	= sizeof(struct nftnl_expr_target),
-	.max_attr	= NFTA_TARGET_MAX,
+	.nftnl_max_attr	= __NFTNL_EXPR_TG_MAX - 1,
 	.free		= nftnl_expr_target_free,
 	.set		= nftnl_expr_target_set,
 	.get		= nftnl_expr_target_get,
diff --git a/src/expr/tproxy.c b/src/expr/tproxy.c
index bd5ffbf1d93ee..ac5419b1f3405 100644
--- a/src/expr/tproxy.c
+++ b/src/expr/tproxy.c
@@ -165,7 +165,7 @@ nftnl_expr_tproxy_snprintf(char *buf, size_t remain,
 struct expr_ops expr_ops_tproxy = {
 	.name		= "tproxy",
 	.alloc_len	= sizeof(struct nftnl_expr_tproxy),
-	.max_attr	= NFTA_TPROXY_MAX,
+	.nftnl_max_attr	= __NFTNL_EXPR_TPROXY_MAX - 1,
 	.set		= nftnl_expr_tproxy_set,
 	.get		= nftnl_expr_tproxy_get,
 	.parse		= nftnl_expr_tproxy_parse,
diff --git a/src/expr/tunnel.c b/src/expr/tunnel.c
index a00f620fa471a..e381994707fe9 100644
--- a/src/expr/tunnel.c
+++ b/src/expr/tunnel.c
@@ -140,7 +140,7 @@ nftnl_expr_tunnel_snprintf(char *buf, size_t len,
 struct expr_ops expr_ops_tunnel = {
 	.name		= "tunnel",
 	.alloc_len	= sizeof(struct nftnl_expr_tunnel),
-	.max_attr	= NFTA_TUNNEL_MAX,
+	.nftnl_max_attr	= __NFTNL_EXPR_TUNNEL_MAX - 1,
 	.set		= nftnl_expr_tunnel_set,
 	.get		= nftnl_expr_tunnel_get,
 	.parse		= nftnl_expr_tunnel_parse,
diff --git a/src/expr/xfrm.c b/src/expr/xfrm.c
index 2db00d50a158a..3f4cb0a91762e 100644
--- a/src/expr/xfrm.c
+++ b/src/expr/xfrm.c
@@ -191,7 +191,7 @@ nftnl_expr_xfrm_snprintf(char *buf, size_t remain,
 struct expr_ops expr_ops_xfrm = {
 	.name		= "xfrm",
 	.alloc_len	= sizeof(struct nftnl_expr_xfrm),
-	.max_attr	= NFTA_XFRM_MAX,
+	.nftnl_max_attr	= __NFTNL_EXPR_XFRM_MAX - 1,
 	.set		= nftnl_expr_xfrm_set,
 	.get		= nftnl_expr_xfrm_get,
 	.parse		= nftnl_expr_xfrm_parse,
-- 
2.43.0

