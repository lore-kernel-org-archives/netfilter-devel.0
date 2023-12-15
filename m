Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A4C4B14D
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Dec 2023 21:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="k3rZRhxn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=75no8moss2lYpK0KUWiWEvlDit5UjlCLP9JBg40H36k=; b=k3rZRhxn7Ph0OzH8TYhu8iqik6
	cpKbuST6aN1sAVVJO5RQIpBurrKbpfrPSms50VS26uRRN3+BMjttcJujVnENM0G/MTOvds+mkJ+A1
	LTUxr73TyMzjm3zcTPijUlyVdAIF363gibVcsQYrhLJ3MgNd8MC1uApUhne6zLhLtmcik4JMAuaxo
	06u3QbYBIv+CFC4ItgrORCMenAGuomPCbAX+An4LdlALSFG+fAFOO9r3qc2OgbAZ/b6CUDQkCA4AM
	7Fjr8KTyV+0o7HD+uK7EiGiUpNLigwL0wCmkhsiJVehErsSWLX8sX05OSM+a75Wly/oR7wgFywV1C
	zSu/DD/w==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rEG82-0001ZV-FD; Fri, 15 Dec 2023 22:53:54 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>
Subject: [libnftnl PATCH 5/6] expr: Introduce struct expr_ops::attr_policy
Date: Fri, 15 Dec 2023 22:53:49 +0100
Message-ID: <20231215215350.17691-6-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231215215350.17691-1-phil@nwl.cc>
References: <20231215215350.17691-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Similar to kernel's nla_policy, enable expressions to inform about
restrictions on attribute use. This allows the generic expression code
to perform sanity checks before dispatching to expression ops.

For now, this holds only the maximum data len which may be passed to
nftnl_expr_set().

While one may debate whether accepting e.g. uint32_t for sreg/dreg
attributes is correct, it is necessary to not break nftables.

Note that this introduces artificial restrictions on name lengths which
were caught by the kernel (if nftables didn't).

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/expr_ops.h      |  5 +++++
 src/expr/bitwise.c      | 11 +++++++++++
 src/expr/byteorder.c    |  9 +++++++++
 src/expr/cmp.c          |  7 +++++++
 src/expr/connlimit.c    |  6 ++++++
 src/expr/counter.c      |  6 ++++++
 src/expr/ct.c           |  8 ++++++++
 src/expr/dup.c          |  6 ++++++
 src/expr/dynset.c       | 13 +++++++++++++
 src/expr/exthdr.c       | 11 +++++++++++
 src/expr/fib.c          |  7 +++++++
 src/expr/flow_offload.c |  5 +++++
 src/expr/fwd.c          |  7 +++++++
 src/expr/hash.c         | 11 +++++++++++
 src/expr/immediate.c    |  9 +++++++++
 src/expr/inner.c        |  8 ++++++++
 src/expr/last.c         |  6 ++++++
 src/expr/limit.c        |  9 +++++++++
 src/expr/log.c          | 10 ++++++++++
 src/expr/lookup.c       |  9 +++++++++
 src/expr/masq.c         |  7 +++++++
 src/expr/match.c        |  7 +++++++
 src/expr/meta.c         |  7 +++++++
 src/expr/nat.c          | 11 +++++++++++
 src/expr/numgen.c       |  8 ++++++++
 src/expr/objref.c       |  9 +++++++++
 src/expr/osf.c          |  7 +++++++
 src/expr/payload.c      | 12 ++++++++++++
 src/expr/queue.c        |  8 ++++++++
 src/expr/quota.c        |  7 +++++++
 src/expr/range.c        |  8 ++++++++
 src/expr/redir.c        |  7 +++++++
 src/expr/reject.c       |  6 ++++++
 src/expr/rt.c           |  6 ++++++
 src/expr/socket.c       |  7 +++++++
 src/expr/synproxy.c     |  7 +++++++
 src/expr/target.c       |  7 +++++++
 src/expr/tproxy.c       |  7 +++++++
 src/expr/tunnel.c       |  6 ++++++
 src/expr/xfrm.c         |  9 +++++++++
 40 files changed, 316 insertions(+)

diff --git a/include/expr_ops.h b/include/expr_ops.h
index 51b221483552c..6cfb3b5832083 100644
--- a/include/expr_ops.h
+++ b/include/expr_ops.h
@@ -8,10 +8,15 @@ struct nlattr;
 struct nlmsghdr;
 struct nftnl_expr;
 
+struct attr_policy {
+	uint32_t maxlen;
+};
+
 struct expr_ops {
 	const char *name;
 	uint32_t alloc_len;
 	int	nftnl_max_attr;
+	struct attr_policy *attr_policy;
 	void	(*init)(const struct nftnl_expr *e);
 	void	(*free)(const struct nftnl_expr *e);
 	int	(*set)(struct nftnl_expr *e, uint16_t type, const void *data, uint32_t data_len);
diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index e219d49a5f440..dab1690707ec6 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -266,10 +266,21 @@ nftnl_expr_bitwise_snprintf(char *buf, size_t size,
 	return err;
 }
 
+static struct attr_policy bitwise_attr_policy[__NFTNL_EXPR_BITWISE_MAX] = {
+	[NFTNL_EXPR_BITWISE_SREG] = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_BITWISE_DREG] = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_BITWISE_LEN]  = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_BITWISE_MASK] = { .maxlen = NFT_DATA_VALUE_MAXLEN },
+	[NFTNL_EXPR_BITWISE_XOR]  = { .maxlen = NFT_DATA_VALUE_MAXLEN },
+	[NFTNL_EXPR_BITWISE_OP]   = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_BITWISE_DATA] = { .maxlen = NFT_DATA_VALUE_MAXLEN },
+};
+
 struct expr_ops expr_ops_bitwise = {
 	.name		= "bitwise",
 	.alloc_len	= sizeof(struct nftnl_expr_bitwise),
 	.nftnl_max_attr	= __NFTNL_EXPR_BITWISE_MAX - 1,
+	.attr_policy	= bitwise_attr_policy,
 	.set		= nftnl_expr_bitwise_set,
 	.get		= nftnl_expr_bitwise_get,
 	.parse		= nftnl_expr_bitwise_parse,
diff --git a/src/expr/byteorder.c b/src/expr/byteorder.c
index 8c7661fcc45ce..d4e85a8dacfc0 100644
--- a/src/expr/byteorder.c
+++ b/src/expr/byteorder.c
@@ -210,10 +210,19 @@ nftnl_expr_byteorder_snprintf(char *buf, size_t remain,
 	return offset;
 }
 
+static struct attr_policy byteorder_attr_policy[__NFTNL_EXPR_BYTEORDER_MAX] = {
+	[NFTNL_EXPR_BYTEORDER_DREG] = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_BYTEORDER_SREG] = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_BYTEORDER_OP]   = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_BYTEORDER_LEN]  = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_BYTEORDER_SIZE] = { .maxlen = sizeof(uint32_t) },
+};
+
 struct expr_ops expr_ops_byteorder = {
 	.name		= "byteorder",
 	.alloc_len	= sizeof(struct nftnl_expr_byteorder),
 	.nftnl_max_attr	= __NFTNL_EXPR_BYTEORDER_MAX - 1,
+	.attr_policy	= byteorder_attr_policy,
 	.set		= nftnl_expr_byteorder_set,
 	.get		= nftnl_expr_byteorder_get,
 	.parse		= nftnl_expr_byteorder_parse,
diff --git a/src/expr/cmp.c b/src/expr/cmp.c
index fe6f5997a0f3a..2937d7e63a18e 100644
--- a/src/expr/cmp.c
+++ b/src/expr/cmp.c
@@ -190,10 +190,17 @@ nftnl_expr_cmp_snprintf(char *buf, size_t remain,
 	return offset;
 }
 
+static struct attr_policy cmp_attr_policy[__NFTNL_EXPR_CMP_MAX] = {
+	[NFTNL_EXPR_CMP_SREG] = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_CMP_OP]   = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_CMP_DATA] = { .maxlen = NFT_DATA_VALUE_MAXLEN }
+};
+
 struct expr_ops expr_ops_cmp = {
 	.name		= "cmp",
 	.alloc_len	= sizeof(struct nftnl_expr_cmp),
 	.nftnl_max_attr	= __NFTNL_EXPR_CMP_MAX - 1,
+	.attr_policy	= cmp_attr_policy,
 	.set		= nftnl_expr_cmp_set,
 	.get		= nftnl_expr_cmp_get,
 	.parse		= nftnl_expr_cmp_parse,
diff --git a/src/expr/connlimit.c b/src/expr/connlimit.c
index 90613f2241ded..1c78c7113f0e9 100644
--- a/src/expr/connlimit.c
+++ b/src/expr/connlimit.c
@@ -125,10 +125,16 @@ static int nftnl_expr_connlimit_snprintf(char *buf, size_t len,
 			connlimit->count, connlimit->flags);
 }
 
+static struct attr_policy connlimit_attr_policy[__NFTNL_EXPR_CONNLIMIT_MAX] = {
+	[NFTNL_EXPR_CONNLIMIT_COUNT] = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_CONNLIMIT_FLAGS] = { .maxlen = sizeof(uint32_t) },
+};
+
 struct expr_ops expr_ops_connlimit = {
 	.name		= "connlimit",
 	.alloc_len	= sizeof(struct nftnl_expr_connlimit),
 	.nftnl_max_attr	= __NFTNL_EXPR_CONNLIMIT_MAX - 1,
+	.attr_policy	= connlimit_attr_policy,
 	.set		= nftnl_expr_connlimit_set,
 	.get		= nftnl_expr_connlimit_get,
 	.parse		= nftnl_expr_connlimit_parse,
diff --git a/src/expr/counter.c b/src/expr/counter.c
index a003e24c6a68d..2c6f2a7a820ac 100644
--- a/src/expr/counter.c
+++ b/src/expr/counter.c
@@ -123,10 +123,16 @@ static int nftnl_expr_counter_snprintf(char *buf, size_t len,
 			ctr->pkts, ctr->bytes);
 }
 
+static struct attr_policy counter_attr_policy[__NFTNL_EXPR_CTR_MAX] = {
+	[NFTNL_EXPR_CTR_PACKETS] = { .maxlen = sizeof(uint64_t) },
+	[NFTNL_EXPR_CTR_BYTES]   = { .maxlen = sizeof(uint64_t) },
+};
+
 struct expr_ops expr_ops_counter = {
 	.name		= "counter",
 	.alloc_len	= sizeof(struct nftnl_expr_counter),
 	.nftnl_max_attr	= __NFTNL_EXPR_CTR_MAX - 1,
+	.attr_policy	= counter_attr_policy,
 	.set		= nftnl_expr_counter_set,
 	.get		= nftnl_expr_counter_get,
 	.parse		= nftnl_expr_counter_parse,
diff --git a/src/expr/ct.c b/src/expr/ct.c
index 197454e547784..f7dd40d54799a 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -248,10 +248,18 @@ nftnl_expr_ct_snprintf(char *buf, size_t remain,
 	return offset;
 }
 
+static struct attr_policy ct_attr_policy[__NFTNL_EXPR_CT_MAX] = {
+	[NFTNL_EXPR_CT_DREG] = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_CT_KEY]  = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_CT_DIR]  = { .maxlen = sizeof(uint8_t) },
+	[NFTNL_EXPR_CT_SREG] = { .maxlen = sizeof(uint32_t) },
+};
+
 struct expr_ops expr_ops_ct = {
 	.name		= "ct",
 	.alloc_len	= sizeof(struct nftnl_expr_ct),
 	.nftnl_max_attr	= __NFTNL_EXPR_CT_MAX - 1,
+	.attr_policy	= ct_attr_policy,
 	.set		= nftnl_expr_ct_set,
 	.get		= nftnl_expr_ct_get,
 	.parse		= nftnl_expr_ct_parse,
diff --git a/src/expr/dup.c b/src/expr/dup.c
index 20100abf8b3c3..6a5e4cae93b1c 100644
--- a/src/expr/dup.c
+++ b/src/expr/dup.c
@@ -128,10 +128,16 @@ static int nftnl_expr_dup_snprintf(char *buf, size_t remain,
 	return offset;
 }
 
+static struct attr_policy dup_attr_policy[__NFTNL_EXPR_DUP_MAX] = {
+	[NFTNL_EXPR_DUP_SREG_ADDR] = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_DUP_SREG_DEV]  = { .maxlen = sizeof(uint32_t) },
+};
+
 struct expr_ops expr_ops_dup = {
 	.name		= "dup",
 	.alloc_len	= sizeof(struct nftnl_expr_dup),
 	.nftnl_max_attr	= __NFTNL_EXPR_DUP_MAX - 1,
+	.attr_policy	= dup_attr_policy,
 	.set		= nftnl_expr_dup_set,
 	.get		= nftnl_expr_dup_get,
 	.parse		= nftnl_expr_dup_parse,
diff --git a/src/expr/dynset.c b/src/expr/dynset.c
index ee6ce1ec71563..c1f79b5741cd4 100644
--- a/src/expr/dynset.c
+++ b/src/expr/dynset.c
@@ -363,10 +363,23 @@ static void nftnl_expr_dynset_free(const struct nftnl_expr *e)
 		nftnl_expr_free(expr);
 }
 
+static struct attr_policy dynset_attr_policy[__NFTNL_EXPR_DYNSET_MAX] = {
+	[NFTNL_EXPR_DYNSET_SREG_KEY]    = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_DYNSET_SREG_DATA]   = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_DYNSET_OP]          = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_DYNSET_TIMEOUT]     = { .maxlen = sizeof(uint64_t) },
+	[NFTNL_EXPR_DYNSET_SET_NAME]    = { .maxlen = NFT_SET_MAXNAMELEN },
+	[NFTNL_EXPR_DYNSET_SET_ID]      = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_DYNSET_EXPR]        = { .maxlen = 0 },
+	[NFTNL_EXPR_DYNSET_EXPRESSIONS] = { .maxlen = 0 },
+	[NFTNL_EXPR_DYNSET_FLAGS]       = { .maxlen = sizeof(uint32_t) },
+};
+
 struct expr_ops expr_ops_dynset = {
 	.name		= "dynset",
 	.alloc_len	= sizeof(struct nftnl_expr_dynset),
 	.nftnl_max_attr	= __NFTNL_EXPR_DYNSET_MAX - 1,
+	.attr_policy	= dynset_attr_policy,
 	.init		= nftnl_expr_dynset_init,
 	.free		= nftnl_expr_dynset_free,
 	.set		= nftnl_expr_dynset_set,
diff --git a/src/expr/exthdr.c b/src/expr/exthdr.c
index 77ff7dba37d83..93b75216031b6 100644
--- a/src/expr/exthdr.c
+++ b/src/expr/exthdr.c
@@ -257,10 +257,21 @@ nftnl_expr_exthdr_snprintf(char *buf, size_t len,
 
 }
 
+static struct attr_policy exthdr_attr_policy[__NFTNL_EXPR_EXTHDR_MAX] = {
+	[NFTNL_EXPR_EXTHDR_DREG]   = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_EXTHDR_TYPE]   = { .maxlen = sizeof(uint8_t) },
+	[NFTNL_EXPR_EXTHDR_OFFSET] = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_EXTHDR_LEN]    = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_EXTHDR_FLAGS]  = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_EXTHDR_OP]     = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_EXTHDR_SREG]   = { .maxlen = sizeof(uint32_t) },
+};
+
 struct expr_ops expr_ops_exthdr = {
 	.name		= "exthdr",
 	.alloc_len	= sizeof(struct nftnl_expr_exthdr),
 	.nftnl_max_attr	= __NFTNL_EXPR_EXTHDR_MAX - 1,
+	.attr_policy	= exthdr_attr_policy,
 	.set		= nftnl_expr_exthdr_set,
 	.get		= nftnl_expr_exthdr_get,
 	.parse		= nftnl_expr_exthdr_parse,
diff --git a/src/expr/fib.c b/src/expr/fib.c
index 5d2303f9ebe83..5f7bef43be89a 100644
--- a/src/expr/fib.c
+++ b/src/expr/fib.c
@@ -188,10 +188,17 @@ nftnl_expr_fib_snprintf(char *buf, size_t remain,
 	return offset;
 }
 
+static struct attr_policy fib_attr_policy[__NFTNL_EXPR_FIB_MAX] = {
+	[NFTNL_EXPR_FIB_DREG]   = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_FIB_RESULT] = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_FIB_FLAGS]  = { .maxlen = sizeof(uint32_t) },
+};
+
 struct expr_ops expr_ops_fib = {
 	.name		= "fib",
 	.alloc_len	= sizeof(struct nftnl_expr_fib),
 	.nftnl_max_attr	= __NFTNL_EXPR_FIB_MAX - 1,
+	.attr_policy	= fib_attr_policy,
 	.set		= nftnl_expr_fib_set,
 	.get		= nftnl_expr_fib_get,
 	.parse		= nftnl_expr_fib_parse,
diff --git a/src/expr/flow_offload.c b/src/expr/flow_offload.c
index 9ab068d29adaa..5f209a63fa960 100644
--- a/src/expr/flow_offload.c
+++ b/src/expr/flow_offload.c
@@ -109,10 +109,15 @@ static void nftnl_expr_flow_free(const struct nftnl_expr *e)
 	xfree(flow->table_name);
 }
 
+static struct attr_policy flow_offload_attr_policy[__NFTNL_EXPR_FLOW_MAX] = {
+	[NFTNL_EXPR_FLOW_TABLE_NAME] = { .maxlen = NFT_NAME_MAXLEN },
+};
+
 struct expr_ops expr_ops_flow = {
 	.name		= "flow_offload",
 	.alloc_len	= sizeof(struct nftnl_expr_flow),
 	.nftnl_max_attr	= __NFTNL_EXPR_FLOW_MAX - 1,
+	.attr_policy	= flow_offload_attr_policy,
 	.free		= nftnl_expr_flow_free,
 	.set		= nftnl_expr_flow_set,
 	.get		= nftnl_expr_flow_get,
diff --git a/src/expr/fwd.c b/src/expr/fwd.c
index bd1b1d81eb2ad..566d6f495f1e3 100644
--- a/src/expr/fwd.c
+++ b/src/expr/fwd.c
@@ -148,10 +148,17 @@ static int nftnl_expr_fwd_snprintf(char *buf, size_t remain,
 	return offset;
 }
 
+static struct attr_policy fwd_attr_policy[__NFTNL_EXPR_FWD_MAX] = {
+	[NFTNL_EXPR_FWD_SREG_DEV]  = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_FWD_SREG_ADDR] = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_FWD_NFPROTO]   = { .maxlen = sizeof(uint32_t) },
+};
+
 struct expr_ops expr_ops_fwd = {
 	.name		= "fwd",
 	.alloc_len	= sizeof(struct nftnl_expr_fwd),
 	.nftnl_max_attr	= __NFTNL_EXPR_FWD_MAX - 1,
+	.attr_policy	= fwd_attr_policy,
 	.set		= nftnl_expr_fwd_set,
 	.get		= nftnl_expr_fwd_get,
 	.parse		= nftnl_expr_fwd_parse,
diff --git a/src/expr/hash.c b/src/expr/hash.c
index 1fc72ec331a3d..4cd9006c9b29b 100644
--- a/src/expr/hash.c
+++ b/src/expr/hash.c
@@ -218,10 +218,21 @@ nftnl_expr_hash_snprintf(char *buf, size_t remain,
 	return offset;
 }
 
+static struct attr_policy hash_attr_policy[__NFTNL_EXPR_HASH_MAX] = {
+	[NFTNL_EXPR_HASH_SREG]    = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_HASH_DREG]    = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_HASH_LEN]     = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_HASH_MODULUS] = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_HASH_SEED]    = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_HASH_OFFSET]  = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_HASH_TYPE]    = { .maxlen = sizeof(uint32_t) },
+};
+
 struct expr_ops expr_ops_hash = {
 	.name		= "hash",
 	.alloc_len	= sizeof(struct nftnl_expr_hash),
 	.nftnl_max_attr	= __NFTNL_EXPR_HASH_MAX - 1,
+	.attr_policy	= hash_attr_policy,
 	.set		= nftnl_expr_hash_set,
 	.get		= nftnl_expr_hash_get,
 	.parse		= nftnl_expr_hash_parse,
diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index 6ab84171b159d..8645ab3e7827e 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -216,10 +216,19 @@ static void nftnl_expr_immediate_free(const struct nftnl_expr *e)
 		nftnl_free_verdict(&imm->data);
 }
 
+static struct attr_policy immediate_attr_policy[__NFTNL_EXPR_IMM_MAX] = {
+	[NFTNL_EXPR_IMM_DREG]     = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_IMM_DATA]     = { .maxlen = NFT_DATA_VALUE_MAXLEN },
+	[NFTNL_EXPR_IMM_VERDICT]  = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_IMM_CHAIN]    = { .maxlen = NFT_CHAIN_MAXNAMELEN },
+	[NFTNL_EXPR_IMM_CHAIN_ID] = { .maxlen = sizeof(uint32_t) },
+};
+
 struct expr_ops expr_ops_immediate = {
 	.name		= "immediate",
 	.alloc_len	= sizeof(struct nftnl_expr_immediate),
 	.nftnl_max_attr	= __NFTNL_EXPR_IMM_MAX - 1,
+	.attr_policy	= immediate_attr_policy,
 	.free		= nftnl_expr_immediate_free,
 	.set		= nftnl_expr_immediate_set,
 	.get		= nftnl_expr_immediate_get,
diff --git a/src/expr/inner.c b/src/expr/inner.c
index 515f68d7b9d72..45ef4fb6208d8 100644
--- a/src/expr/inner.c
+++ b/src/expr/inner.c
@@ -199,10 +199,18 @@ nftnl_expr_inner_snprintf(char *buf, size_t remain, uint32_t flags,
 	return offset;
 }
 
+static struct attr_policy inner_attr_policy[__NFTNL_EXPR_INNER_MAX] = {
+	[NFTNL_EXPR_INNER_TYPE]    = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_INNER_FLAGS]   = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_INNER_HDRSIZE] = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_INNER_EXPR]    = { .maxlen = 0 },
+};
+
 struct expr_ops expr_ops_inner = {
 	.name		= "inner",
 	.alloc_len	= sizeof(struct nftnl_expr_inner),
 	.nftnl_max_attr	= __NFTNL_EXPR_INNER_MAX - 1,
+	.attr_policy	= inner_attr_policy,
 	.free		= nftnl_expr_inner_free,
 	.set		= nftnl_expr_inner_set,
 	.get		= nftnl_expr_inner_get,
diff --git a/src/expr/last.c b/src/expr/last.c
index 8aa772c615345..074f463811459 100644
--- a/src/expr/last.c
+++ b/src/expr/last.c
@@ -124,10 +124,16 @@ static int nftnl_expr_last_snprintf(char *buf, size_t len,
 	return snprintf(buf, len, "%"PRIu64" ", last->msecs);
 }
 
+static struct attr_policy last_attr_policy[__NFTNL_EXPR_LAST_MAX] = {
+	[NFTNL_EXPR_LAST_MSECS] = { .maxlen = sizeof(uint64_t) },
+	[NFTNL_EXPR_LAST_SET]   = { .maxlen = sizeof(uint32_t) },
+};
+
 struct expr_ops expr_ops_last = {
 	.name		= "last",
 	.alloc_len	= sizeof(struct nftnl_expr_last),
 	.nftnl_max_attr	= __NFTNL_EXPR_LAST_MAX - 1,
+	.attr_policy	= last_attr_policy,
 	.set		= nftnl_expr_last_set,
 	.get		= nftnl_expr_last_get,
 	.parse		= nftnl_expr_last_parse,
diff --git a/src/expr/limit.c b/src/expr/limit.c
index 355d46acca4e5..935d449d046df 100644
--- a/src/expr/limit.c
+++ b/src/expr/limit.c
@@ -192,10 +192,19 @@ nftnl_expr_limit_snprintf(char *buf, size_t len,
 			limit_to_type(limit->type), limit->flags);
 }
 
+static struct attr_policy limit_attr_policy[__NFTNL_EXPR_LIMIT_MAX] = {
+	[NFTNL_EXPR_LIMIT_RATE]  = { .maxlen = sizeof(uint64_t) },
+	[NFTNL_EXPR_LIMIT_UNIT]  = { .maxlen = sizeof(uint64_t) },
+	[NFTNL_EXPR_LIMIT_BURST] = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_LIMIT_TYPE]  = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_LIMIT_FLAGS] = { .maxlen = sizeof(uint32_t) },
+};
+
 struct expr_ops expr_ops_limit = {
 	.name		= "limit",
 	.alloc_len	= sizeof(struct nftnl_expr_limit),
 	.nftnl_max_attr	= __NFTNL_EXPR_LIMIT_MAX - 1,
+	.attr_policy	= limit_attr_policy,
 	.set		= nftnl_expr_limit_set,
 	.get		= nftnl_expr_limit_get,
 	.parse		= nftnl_expr_limit_parse,
diff --git a/src/expr/log.c b/src/expr/log.c
index 868da61d95795..d6d6910ca9201 100644
--- a/src/expr/log.c
+++ b/src/expr/log.c
@@ -242,10 +242,20 @@ static void nftnl_expr_log_free(const struct nftnl_expr *e)
 	xfree(log->prefix);
 }
 
+static struct attr_policy log_attr_policy[__NFTNL_EXPR_LOG_MAX] = {
+	[NFTNL_EXPR_LOG_PREFIX]     = { .maxlen = NF_LOG_PREFIXLEN },
+	[NFTNL_EXPR_LOG_GROUP]      = { .maxlen = sizeof(uint16_t) },
+	[NFTNL_EXPR_LOG_SNAPLEN]    = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_LOG_QTHRESHOLD] = { .maxlen = sizeof(uint16_t) },
+	[NFTNL_EXPR_LOG_LEVEL]      = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_LOG_FLAGS]      = { .maxlen = sizeof(uint32_t) },
+};
+
 struct expr_ops expr_ops_log = {
 	.name		= "log",
 	.alloc_len	= sizeof(struct nftnl_expr_log),
 	.nftnl_max_attr	= __NFTNL_EXPR_LOG_MAX - 1,
+	.attr_policy	= log_attr_policy,
 	.free		= nftnl_expr_log_free,
 	.set		= nftnl_expr_log_set,
 	.get		= nftnl_expr_log_get,
diff --git a/src/expr/lookup.c b/src/expr/lookup.c
index ca58a38855734..be045286eb13e 100644
--- a/src/expr/lookup.c
+++ b/src/expr/lookup.c
@@ -195,10 +195,19 @@ static void nftnl_expr_lookup_free(const struct nftnl_expr *e)
 	xfree(lookup->set_name);
 }
 
+static struct attr_policy lookup_attr_policy[__NFTNL_EXPR_LOOKUP_MAX] = {
+	[NFTNL_EXPR_LOOKUP_SREG]   = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_LOOKUP_DREG]   = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_LOOKUP_SET]    = { .maxlen = NFT_SET_MAXNAMELEN },
+	[NFTNL_EXPR_LOOKUP_SET_ID] = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_LOOKUP_FLAGS]  = { .maxlen = sizeof(uint32_t) },
+};
+
 struct expr_ops expr_ops_lookup = {
 	.name		= "lookup",
 	.alloc_len	= sizeof(struct nftnl_expr_lookup),
 	.nftnl_max_attr	= __NFTNL_EXPR_LOOKUP_MAX - 1,
+	.attr_policy	= lookup_attr_policy,
 	.free		= nftnl_expr_lookup_free,
 	.set		= nftnl_expr_lookup_set,
 	.get		= nftnl_expr_lookup_get,
diff --git a/src/expr/masq.c b/src/expr/masq.c
index fa2f4afe2c600..4be5a9c18ed11 100644
--- a/src/expr/masq.c
+++ b/src/expr/masq.c
@@ -153,10 +153,17 @@ static int nftnl_expr_masq_snprintf(char *buf, size_t remain,
 	return offset;
 }
 
+static struct attr_policy masq_attr_policy[__NFTNL_EXPR_MASQ_MAX] = {
+	[NFTNL_EXPR_MASQ_FLAGS]         = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_MASQ_REG_PROTO_MIN] = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_MASQ_REG_PROTO_MAX] = { .maxlen = sizeof(uint32_t) },
+};
+
 struct expr_ops expr_ops_masq = {
 	.name		= "masq",
 	.alloc_len	= sizeof(struct nftnl_expr_masq),
 	.nftnl_max_attr	= __NFTNL_EXPR_MASQ_MAX - 1,
+	.attr_policy	= masq_attr_policy,
 	.set		= nftnl_expr_masq_set,
 	.get		= nftnl_expr_masq_get,
 	.parse		= nftnl_expr_masq_parse,
diff --git a/src/expr/match.c b/src/expr/match.c
index 16e73673df325..68288dc4349e9 100644
--- a/src/expr/match.c
+++ b/src/expr/match.c
@@ -178,10 +178,17 @@ static void nftnl_expr_match_free(const struct nftnl_expr *e)
 	xfree(match->data);
 }
 
+static struct attr_policy match_attr_policy[__NFTNL_EXPR_MT_MAX] = {
+	[NFTNL_EXPR_MT_NAME] = { .maxlen = XT_EXTENSION_MAXNAMELEN },
+	[NFTNL_EXPR_MT_REV]  = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_MT_INFO] = { .maxlen = 0 },
+};
+
 struct expr_ops expr_ops_match = {
 	.name		= "match",
 	.alloc_len	= sizeof(struct nftnl_expr_match),
 	.nftnl_max_attr	= __NFTNL_EXPR_MT_MAX - 1,
+	.attr_policy	= match_attr_policy,
 	.free		= nftnl_expr_match_free,
 	.set		= nftnl_expr_match_set,
 	.get		= nftnl_expr_match_get,
diff --git a/src/expr/meta.c b/src/expr/meta.c
index 1db2c19e21342..cd49c341a3d6f 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -207,10 +207,17 @@ nftnl_expr_meta_snprintf(char *buf, size_t len,
 	return 0;
 }
 
+static struct attr_policy meta_attr_policy[__NFTNL_EXPR_META_MAX] = {
+	[NFTNL_EXPR_META_KEY]  = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_META_DREG] = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_META_SREG] = { .maxlen = sizeof(uint32_t) },
+};
+
 struct expr_ops expr_ops_meta = {
 	.name		= "meta",
 	.alloc_len	= sizeof(struct nftnl_expr_meta),
 	.nftnl_max_attr	= __NFTNL_EXPR_META_MAX - 1,
+	.attr_policy	= meta_attr_policy,
 	.set		= nftnl_expr_meta_set,
 	.get		= nftnl_expr_meta_get,
 	.parse		= nftnl_expr_meta_parse,
diff --git a/src/expr/nat.c b/src/expr/nat.c
index 724894a2097d4..f3f8644ffdd52 100644
--- a/src/expr/nat.c
+++ b/src/expr/nat.c
@@ -264,10 +264,21 @@ nftnl_expr_nat_snprintf(char *buf, size_t remain,
 	return offset;
 }
 
+static struct attr_policy nat_attr_policy[__NFTNL_EXPR_NAT_MAX] = {
+	[NFTNL_EXPR_NAT_TYPE]          = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_NAT_FAMILY]        = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_NAT_REG_ADDR_MIN]  = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_NAT_REG_ADDR_MAX]  = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_NAT_REG_PROTO_MIN] = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_NAT_REG_PROTO_MAX] = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_NAT_FLAGS]         = { .maxlen = sizeof(uint32_t) },
+};
+
 struct expr_ops expr_ops_nat = {
 	.name		= "nat",
 	.alloc_len	= sizeof(struct nftnl_expr_nat),
 	.nftnl_max_attr	= __NFTNL_EXPR_NAT_MAX - 1,
+	.attr_policy	= nat_attr_policy,
 	.set		= nftnl_expr_nat_set,
 	.get		= nftnl_expr_nat_get,
 	.parse		= nftnl_expr_nat_parse,
diff --git a/src/expr/numgen.c b/src/expr/numgen.c
index 3e83e05f2e3e0..c5e8772d22957 100644
--- a/src/expr/numgen.c
+++ b/src/expr/numgen.c
@@ -172,10 +172,18 @@ nftnl_expr_ng_snprintf(char *buf, size_t remain,
 	return offset;
 }
 
+static struct attr_policy numgen_attr_policy[__NFTNL_EXPR_NG_MAX] = {
+	[NFTNL_EXPR_NG_DREG]    = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_NG_MODULUS] = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_NG_TYPE]    = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_NG_OFFSET]  = { .maxlen = sizeof(uint32_t) },
+};
+
 struct expr_ops expr_ops_ng = {
 	.name		= "numgen",
 	.alloc_len	= sizeof(struct nftnl_expr_ng),
 	.nftnl_max_attr	= __NFTNL_EXPR_NG_MAX - 1,
+	.attr_policy	= numgen_attr_policy,
 	.set		= nftnl_expr_ng_set,
 	.get		= nftnl_expr_ng_get,
 	.parse		= nftnl_expr_ng_parse,
diff --git a/src/expr/objref.c b/src/expr/objref.c
index 28cd2cc025b40..59e1dddcb5f6d 100644
--- a/src/expr/objref.c
+++ b/src/expr/objref.c
@@ -194,10 +194,19 @@ static void nftnl_expr_objref_free(const struct nftnl_expr *e)
 	xfree(objref->set.name);
 }
 
+static struct attr_policy objref_attr_policy[__NFTNL_EXPR_OBJREF_MAX] = {
+	[NFTNL_EXPR_OBJREF_IMM_TYPE] = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_OBJREF_IMM_NAME] = { .maxlen = NFT_NAME_MAXLEN },
+	[NFTNL_EXPR_OBJREF_SET_SREG] = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_OBJREF_SET_NAME] = { .maxlen = NFT_NAME_MAXLEN },
+	[NFTNL_EXPR_OBJREF_SET_ID]   = { .maxlen = sizeof(uint32_t) },
+};
+
 struct expr_ops expr_ops_objref = {
 	.name		= "objref",
 	.alloc_len	= sizeof(struct nftnl_expr_objref),
 	.nftnl_max_attr	= __NFTNL_EXPR_OBJREF_MAX - 1,
+	.attr_policy	= objref_attr_policy,
 	.free		= nftnl_expr_objref_free,
 	.set		= nftnl_expr_objref_set,
 	.get		= nftnl_expr_objref_get,
diff --git a/src/expr/osf.c b/src/expr/osf.c
index 3838af72debeb..1e4ceb02e3a04 100644
--- a/src/expr/osf.c
+++ b/src/expr/osf.c
@@ -139,10 +139,17 @@ nftnl_expr_osf_snprintf(char *buf, size_t len,
 	return offset;
 }
 
+static struct attr_policy osf_attr_policy[__NFTNL_EXPR_OSF_MAX] = {
+	[NFTNL_EXPR_OSF_DREG]  = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_OSF_TTL]   = { .maxlen = sizeof(uint8_t) },
+	[NFTNL_EXPR_OSF_FLAGS] = { .maxlen = sizeof(uint32_t) },
+};
+
 struct expr_ops expr_ops_osf = {
 	.name		= "osf",
 	.alloc_len	= sizeof(struct nftnl_expr_osf),
 	.nftnl_max_attr	= __NFTNL_EXPR_OSF_MAX - 1,
+	.attr_policy	= osf_attr_policy,
 	.set		= nftnl_expr_osf_set,
 	.get		= nftnl_expr_osf_get,
 	.parse		= nftnl_expr_osf_parse,
diff --git a/src/expr/payload.c b/src/expr/payload.c
index 73cb188736839..76d38f7ede112 100644
--- a/src/expr/payload.c
+++ b/src/expr/payload.c
@@ -236,10 +236,22 @@ nftnl_expr_payload_snprintf(char *buf, size_t len,
 				payload->offset, payload->dreg);
 }
 
+static struct attr_policy payload_attr_policy[__NFTNL_EXPR_PAYLOAD_MAX] = {
+	[NFTNL_EXPR_PAYLOAD_DREG]        = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_PAYLOAD_BASE]        = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_PAYLOAD_OFFSET]      = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_PAYLOAD_LEN]         = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_PAYLOAD_SREG]        = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_PAYLOAD_CSUM_TYPE]   = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_PAYLOAD_CSUM_OFFSET] = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_PAYLOAD_FLAGS]       = { .maxlen = sizeof(uint32_t) },
+};
+
 struct expr_ops expr_ops_payload = {
 	.name		= "payload",
 	.alloc_len	= sizeof(struct nftnl_expr_payload),
 	.nftnl_max_attr	= __NFTNL_EXPR_PAYLOAD_MAX - 1,
+	.attr_policy	= payload_attr_policy,
 	.set		= nftnl_expr_payload_set,
 	.get		= nftnl_expr_payload_get,
 	.parse		= nftnl_expr_payload_parse,
diff --git a/src/expr/queue.c b/src/expr/queue.c
index 3343dd47665e4..54792ef009474 100644
--- a/src/expr/queue.c
+++ b/src/expr/queue.c
@@ -183,10 +183,18 @@ nftnl_expr_queue_snprintf(char *buf, size_t remain,
 	return offset;
 }
 
+static struct attr_policy queue_attr_policy[__NFTNL_EXPR_QUEUE_MAX] = {
+	[NFTNL_EXPR_QUEUE_NUM]       = { .maxlen = sizeof(uint16_t) },
+	[NFTNL_EXPR_QUEUE_TOTAL]     = { .maxlen = sizeof(uint16_t) },
+	[NFTNL_EXPR_QUEUE_FLAGS]     = { .maxlen = sizeof(uint16_t) },
+	[NFTNL_EXPR_QUEUE_SREG_QNUM] = { .maxlen = sizeof(uint32_t) },
+};
+
 struct expr_ops expr_ops_queue = {
 	.name		= "queue",
 	.alloc_len	= sizeof(struct nftnl_expr_queue),
 	.nftnl_max_attr	= __NFTNL_EXPR_QUEUE_MAX - 1,
+	.attr_policy	= queue_attr_policy,
 	.set		= nftnl_expr_queue_set,
 	.get		= nftnl_expr_queue_get,
 	.parse		= nftnl_expr_queue_parse,
diff --git a/src/expr/quota.c b/src/expr/quota.c
index 2a3a05a82d6a2..60631febcd220 100644
--- a/src/expr/quota.c
+++ b/src/expr/quota.c
@@ -137,10 +137,17 @@ static int nftnl_expr_quota_snprintf(char *buf, size_t len,
 			quota->bytes, quota->consumed, quota->flags);
 }
 
+static struct attr_policy quota_attr_policy[__NFTNL_EXPR_QUOTA_MAX] = {
+	[NFTNL_EXPR_QUOTA_BYTES]    = { .maxlen = sizeof(uint64_t) },
+	[NFTNL_EXPR_QUOTA_FLAGS]    = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_QUOTA_CONSUMED] = { .maxlen = sizeof(uint64_t) },
+};
+
 struct expr_ops expr_ops_quota = {
 	.name		= "quota",
 	.alloc_len	= sizeof(struct nftnl_expr_quota),
 	.nftnl_max_attr	= __NFTNL_EXPR_QUOTA_MAX - 1,
+	.attr_policy	= quota_attr_policy,
 	.set		= nftnl_expr_quota_set,
 	.get		= nftnl_expr_quota_get,
 	.parse		= nftnl_expr_quota_parse,
diff --git a/src/expr/range.c b/src/expr/range.c
index d0c52b9a71938..6310b79d0a02b 100644
--- a/src/expr/range.c
+++ b/src/expr/range.c
@@ -199,10 +199,18 @@ static int nftnl_expr_range_snprintf(char *buf, size_t remain,
 	return offset;
 }
 
+static struct attr_policy range_attr_policy[__NFTNL_EXPR_RANGE_MAX] = {
+	[NFTNL_EXPR_RANGE_SREG]      = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_RANGE_OP]        = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_RANGE_FROM_DATA] = { .maxlen = NFT_DATA_VALUE_MAXLEN },
+	[NFTNL_EXPR_RANGE_TO_DATA]   = { .maxlen = NFT_DATA_VALUE_MAXLEN },
+};
+
 struct expr_ops expr_ops_range = {
 	.name		= "range",
 	.alloc_len	= sizeof(struct nftnl_expr_range),
 	.nftnl_max_attr	= __NFTNL_EXPR_RANGE_MAX - 1,
+	.attr_policy	= range_attr_policy,
 	.set		= nftnl_expr_range_set,
 	.get		= nftnl_expr_range_get,
 	.parse		= nftnl_expr_range_parse,
diff --git a/src/expr/redir.c b/src/expr/redir.c
index a5a5e7d5677f9..69095bde094c1 100644
--- a/src/expr/redir.c
+++ b/src/expr/redir.c
@@ -157,10 +157,17 @@ nftnl_expr_redir_snprintf(char *buf, size_t remain,
 	return offset;
 }
 
+static struct attr_policy redir_attr_policy[__NFTNL_EXPR_REDIR_MAX] = {
+	[NFTNL_EXPR_REDIR_REG_PROTO_MIN] = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_REDIR_REG_PROTO_MAX] = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_REDIR_FLAGS]         = { .maxlen = sizeof(uint32_t) },
+};
+
 struct expr_ops expr_ops_redir = {
 	.name		= "redir",
 	.alloc_len	= sizeof(struct nftnl_expr_redir),
 	.nftnl_max_attr	= __NFTNL_EXPR_REDIR_MAX - 1,
+	.attr_policy	= redir_attr_policy,
 	.set		= nftnl_expr_redir_set,
 	.get		= nftnl_expr_redir_get,
 	.parse		= nftnl_expr_redir_parse,
diff --git a/src/expr/reject.c b/src/expr/reject.c
index 8a0653d0f674c..f97011a704663 100644
--- a/src/expr/reject.c
+++ b/src/expr/reject.c
@@ -124,10 +124,16 @@ nftnl_expr_reject_snprintf(char *buf, size_t len,
 			reject->type, reject->icmp_code);
 }
 
+static struct attr_policy reject_attr_policy[__NFTNL_EXPR_REJECT_MAX] = {
+	[NFTNL_EXPR_REJECT_TYPE] = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_REJECT_CODE] = { .maxlen = sizeof(uint8_t) },
+};
+
 struct expr_ops expr_ops_reject = {
 	.name		= "reject",
 	.alloc_len	= sizeof(struct nftnl_expr_reject),
 	.nftnl_max_attr	= __NFTNL_EXPR_REJECT_MAX - 1,
+	.attr_policy	= reject_attr_policy,
 	.set		= nftnl_expr_reject_set,
 	.get		= nftnl_expr_reject_get,
 	.parse		= nftnl_expr_reject_parse,
diff --git a/src/expr/rt.c b/src/expr/rt.c
index de2bd2f1f90a5..0ab255609632f 100644
--- a/src/expr/rt.c
+++ b/src/expr/rt.c
@@ -152,10 +152,16 @@ nftnl_expr_rt_snprintf(char *buf, size_t len,
 	return 0;
 }
 
+static struct attr_policy rt_attr_policy[__NFTNL_EXPR_RT_MAX] = {
+	[NFTNL_EXPR_RT_KEY]  = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_RT_DREG] = { .maxlen = sizeof(uint32_t) },
+};
+
 struct expr_ops expr_ops_rt = {
 	.name		= "rt",
 	.alloc_len	= sizeof(struct nftnl_expr_rt),
 	.nftnl_max_attr	= __NFTNL_EXPR_RT_MAX - 1,
+	.attr_policy	= rt_attr_policy,
 	.set		= nftnl_expr_rt_set,
 	.get		= nftnl_expr_rt_get,
 	.parse		= nftnl_expr_rt_parse,
diff --git a/src/expr/socket.c b/src/expr/socket.c
index 9b6c3ea3ebb50..d0d8e236c688a 100644
--- a/src/expr/socket.c
+++ b/src/expr/socket.c
@@ -155,10 +155,17 @@ nftnl_expr_socket_snprintf(char *buf, size_t len,
 	return 0;
 }
 
+static struct attr_policy socket_attr_policy[__NFTNL_EXPR_SOCKET_MAX] = {
+	[NFTNL_EXPR_SOCKET_KEY]   = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_SOCKET_DREG]  = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_SOCKET_LEVEL] = { .maxlen = sizeof(uint32_t) },
+};
+
 struct expr_ops expr_ops_socket = {
 	.name		= "socket",
 	.alloc_len	= sizeof(struct nftnl_expr_socket),
 	.nftnl_max_attr	= __NFTNL_EXPR_SOCKET_MAX - 1,
+	.attr_policy	= socket_attr_policy,
 	.set		= nftnl_expr_socket_set,
 	.get		= nftnl_expr_socket_get,
 	.parse		= nftnl_expr_socket_parse,
diff --git a/src/expr/synproxy.c b/src/expr/synproxy.c
index dc25962c00d81..898d292f7116d 100644
--- a/src/expr/synproxy.c
+++ b/src/expr/synproxy.c
@@ -144,10 +144,17 @@ nftnl_expr_synproxy_snprintf(char *buf, size_t len,
 	return offset;
 }
 
+static struct attr_policy synproxy_attr_policy[__NFTNL_EXPR_SYNPROXY_MAX] = {
+	[NFTNL_EXPR_SYNPROXY_MSS]    = { .maxlen = sizeof(uint16_t) },
+	[NFTNL_EXPR_SYNPROXY_WSCALE] = { .maxlen = sizeof(uint8_t) },
+	[NFTNL_EXPR_SYNPROXY_FLAGS]  = { .maxlen = sizeof(uint32_t) },
+};
+
 struct expr_ops expr_ops_synproxy = {
 	.name		= "synproxy",
 	.alloc_len	= sizeof(struct nftnl_expr_synproxy),
 	.nftnl_max_attr	= __NFTNL_EXPR_SYNPROXY_MAX - 1,
+	.attr_policy	= synproxy_attr_policy,
 	.set		= nftnl_expr_synproxy_set,
 	.get		= nftnl_expr_synproxy_get,
 	.parse		= nftnl_expr_synproxy_parse,
diff --git a/src/expr/target.c b/src/expr/target.c
index cc0566c1d4b8f..9bfd25bdd5654 100644
--- a/src/expr/target.c
+++ b/src/expr/target.c
@@ -178,10 +178,17 @@ static void nftnl_expr_target_free(const struct nftnl_expr *e)
 	xfree(target->data);
 }
 
+static struct attr_policy target_attr_policy[__NFTNL_EXPR_TG_MAX] = {
+	[NFTNL_EXPR_TG_NAME] = { .maxlen = XT_EXTENSION_MAXNAMELEN },
+	[NFTNL_EXPR_TG_REV]  = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_TG_INFO] = { .maxlen = 0 },
+};
+
 struct expr_ops expr_ops_target = {
 	.name		= "target",
 	.alloc_len	= sizeof(struct nftnl_expr_target),
 	.nftnl_max_attr	= __NFTNL_EXPR_TG_MAX - 1,
+	.attr_policy	= target_attr_policy,
 	.free		= nftnl_expr_target_free,
 	.set		= nftnl_expr_target_set,
 	.get		= nftnl_expr_target_get,
diff --git a/src/expr/tproxy.c b/src/expr/tproxy.c
index c6ed888161918..49483921df139 100644
--- a/src/expr/tproxy.c
+++ b/src/expr/tproxy.c
@@ -160,10 +160,17 @@ nftnl_expr_tproxy_snprintf(char *buf, size_t remain,
 	return offset;
 }
 
+static struct attr_policy tproxy_attr_policy[__NFTNL_EXPR_TPROXY_MAX] = {
+	[NFTNL_EXPR_TPROXY_FAMILY]   = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_TPROXY_REG_ADDR] = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_TPROXY_REG_PORT] = { .maxlen = sizeof(uint32_t) },
+};
+
 struct expr_ops expr_ops_tproxy = {
 	.name		= "tproxy",
 	.alloc_len	= sizeof(struct nftnl_expr_tproxy),
 	.nftnl_max_attr	= __NFTNL_EXPR_TPROXY_MAX - 1,
+	.attr_policy	= tproxy_attr_policy,
 	.set		= nftnl_expr_tproxy_set,
 	.get		= nftnl_expr_tproxy_get,
 	.parse		= nftnl_expr_tproxy_parse,
diff --git a/src/expr/tunnel.c b/src/expr/tunnel.c
index e59744b070f50..8089d0b585435 100644
--- a/src/expr/tunnel.c
+++ b/src/expr/tunnel.c
@@ -135,10 +135,16 @@ nftnl_expr_tunnel_snprintf(char *buf, size_t len,
 	return 0;
 }
 
+static struct attr_policy tunnel_attr_policy[__NFTNL_EXPR_TUNNEL_MAX] = {
+	[NFTNL_EXPR_TUNNEL_KEY]  = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_TUNNEL_DREG] = { .maxlen = sizeof(uint32_t) },
+};
+
 struct expr_ops expr_ops_tunnel = {
 	.name		= "tunnel",
 	.alloc_len	= sizeof(struct nftnl_expr_tunnel),
 	.nftnl_max_attr	= __NFTNL_EXPR_TUNNEL_MAX - 1,
+	.attr_policy	= tunnel_attr_policy,
 	.set		= nftnl_expr_tunnel_set,
 	.get		= nftnl_expr_tunnel_get,
 	.parse		= nftnl_expr_tunnel_parse,
diff --git a/src/expr/xfrm.c b/src/expr/xfrm.c
index 3f4cb0a91762e..dc867a24f78b4 100644
--- a/src/expr/xfrm.c
+++ b/src/expr/xfrm.c
@@ -188,10 +188,19 @@ nftnl_expr_xfrm_snprintf(char *buf, size_t remain,
 	return offset;
 }
 
+static struct attr_policy xfrm_attr_policy[__NFTNL_EXPR_XFRM_MAX] = {
+	[NFTNL_EXPR_XFRM_DREG]  = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_XFRM_SREG]  = { .maxlen = 0 },
+	[NFTNL_EXPR_XFRM_KEY]   = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_XFRM_DIR]   = { .maxlen = sizeof(uint8_t) },
+	[NFTNL_EXPR_XFRM_SPNUM] = { .maxlen = sizeof(uint32_t) },
+};
+
 struct expr_ops expr_ops_xfrm = {
 	.name		= "xfrm",
 	.alloc_len	= sizeof(struct nftnl_expr_xfrm),
 	.nftnl_max_attr	= __NFTNL_EXPR_XFRM_MAX - 1,
+	.attr_policy	= xfrm_attr_policy,
 	.set		= nftnl_expr_xfrm_set,
 	.get		= nftnl_expr_xfrm_get,
 	.parse		= nftnl_expr_xfrm_parse,
-- 
2.43.0

