Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F9DC17B50F
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Mar 2026 08:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773648914; cv=none; b=o0xt7xCt4nC7OPuUYlLOXIQZbLGZ8jfEJNSL+aotuwCwFuse6lARiET0TwDxzxNTsX3qVFjpmbxYxrg0IYVSLkfBShU9tvkjhNQ1w5+XaMx7low9HnqYNZh8TpHWIbq2IHBMjWQj7HtgdfDL3PwuTZ1f+RW7MY0WLx0b7uInnsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773648914; c=relaxed/simple;
	bh=khZaoPBpUk8HINNvjyHohPwjDm/O3EYyBT2ohn3DPnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KYhVGokmAXq1UITtrscUvKfIj7MQAHSWfk5/mkEOXrmbYihbelaAQmU/x2U8hIgk5NugAF0y8zIC8jmfkdiUN+rMFWWPgKeHZ0irco/KRsh0d7X66DkGLj4bcBeO0CyWkob9kfVoYNnKPM8XOwD/S2pF9NhnoebelfaOjCTIYaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 256706080C; Mon, 16 Mar 2026 09:15:11 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 2/2] netfilter: nf_tables: add netlink policy based cap on registers
Date: Mon, 16 Mar 2026 09:14:51 +0100
Message-ID: <20260316081458.43497-2-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260316081458.43497-1-fw@strlen.de>
References: <20260316081458.43497-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Should have no effect in practice; all of these use the
nft_parse_register_load/store apis which is mandatory anyway due
to the need to further validate the register load/store, e.g.
that the size argument doesn't result in out-of-bounds load/store.

OTOH this is a simple method to reject obviously wrong input
at earlier stage.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/uapi/linux/netfilter/nf_tables.h | 4 ++++
 net/netfilter/nft_bitwise.c              | 6 +++---
 net/netfilter/nft_byteorder.c            | 4 ++--
 net/netfilter/nft_cmp.c                  | 2 +-
 net/netfilter/nft_ct.c                   | 4 ++--
 net/netfilter/nft_exthdr.c               | 4 ++--
 net/netfilter/nft_fib.c                  | 2 +-
 net/netfilter/nft_hash.c                 | 4 ++--
 net/netfilter/nft_immediate.c            | 2 +-
 net/netfilter/nft_lookup.c               | 4 ++--
 net/netfilter/nft_meta.c                 | 4 ++--
 net/netfilter/nft_numgen.c               | 2 +-
 net/netfilter/nft_objref.c               | 2 +-
 net/netfilter/nft_osf.c                  | 2 +-
 net/netfilter/nft_payload.c              | 4 ++--
 net/netfilter/nft_range.c                | 2 +-
 net/netfilter/nft_rt.c                   | 2 +-
 net/netfilter/nft_socket.c               | 2 +-
 net/netfilter/nft_tunnel.c               | 2 +-
 net/netfilter/nft_xfrm.c                 | 2 +-
 20 files changed, 32 insertions(+), 28 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index dca9e72b0558..0b708153469c 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -46,6 +46,10 @@ enum nft_registers {
 };
 #define NFT_REG_MAX	(__NFT_REG_MAX - 1)
 
+#ifdef __KERNEL__
+#define NFT_REG32_MAX	NFT_REG32_15
+#endif
+
 #define NFT_REG_SIZE	16
 #define NFT_REG32_SIZE	4
 #define NFT_REG32_COUNT	(NFT_REG32_15 - NFT_REG32_00 + 1)
diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index a4ff781f334d..13808e9cd999 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -125,9 +125,9 @@ void nft_bitwise_eval(const struct nft_expr *expr,
 }
 
 static const struct nla_policy nft_bitwise_policy[NFTA_BITWISE_MAX + 1] = {
-	[NFTA_BITWISE_SREG]	= { .type = NLA_U32 },
-	[NFTA_BITWISE_SREG2]	= { .type = NLA_U32 },
-	[NFTA_BITWISE_DREG]	= { .type = NLA_U32 },
+	[NFTA_BITWISE_SREG]	= NLA_POLICY_MAX(NLA_BE32, NFT_REG32_MAX),
+	[NFTA_BITWISE_SREG2]	= NLA_POLICY_MAX(NLA_BE32, NFT_REG32_MAX),
+	[NFTA_BITWISE_DREG]	= NLA_POLICY_MAX(NLA_BE32, NFT_REG32_MAX),
 	[NFTA_BITWISE_LEN]	= { .type = NLA_U32 },
 	[NFTA_BITWISE_MASK]	= { .type = NLA_NESTED },
 	[NFTA_BITWISE_XOR]	= { .type = NLA_NESTED },
diff --git a/net/netfilter/nft_byteorder.c b/net/netfilter/nft_byteorder.c
index 744878773dac..e00dddfa2fc0 100644
--- a/net/netfilter/nft_byteorder.c
+++ b/net/netfilter/nft_byteorder.c
@@ -87,8 +87,8 @@ void nft_byteorder_eval(const struct nft_expr *expr,
 }
 
 static const struct nla_policy nft_byteorder_policy[NFTA_BYTEORDER_MAX + 1] = {
-	[NFTA_BYTEORDER_SREG]	= { .type = NLA_U32 },
-	[NFTA_BYTEORDER_DREG]	= { .type = NLA_U32 },
+	[NFTA_BYTEORDER_SREG]	= NLA_POLICY_MAX(NLA_BE32, NFT_REG32_MAX),
+	[NFTA_BYTEORDER_DREG]	= NLA_POLICY_MAX(NLA_BE32, NFT_REG32_MAX),
 	[NFTA_BYTEORDER_OP]	= NLA_POLICY_MAX(NLA_BE32, 255),
 	[NFTA_BYTEORDER_LEN]	= NLA_POLICY_MAX(NLA_BE32, 255),
 	[NFTA_BYTEORDER_SIZE]	= NLA_POLICY_MAX(NLA_BE32, 255),
diff --git a/net/netfilter/nft_cmp.c b/net/netfilter/nft_cmp.c
index b61dc9c3383e..e085c2a00b70 100644
--- a/net/netfilter/nft_cmp.c
+++ b/net/netfilter/nft_cmp.c
@@ -64,7 +64,7 @@ void nft_cmp_eval(const struct nft_expr *expr,
 }
 
 static const struct nla_policy nft_cmp_policy[NFTA_CMP_MAX + 1] = {
-	[NFTA_CMP_SREG]		= { .type = NLA_U32 },
+	[NFTA_CMP_SREG]		= NLA_POLICY_MAX(NLA_BE32, NFT_REG32_MAX),
 	[NFTA_CMP_OP]		= { .type = NLA_U32 },
 	[NFTA_CMP_DATA]		= { .type = NLA_NESTED },
 };
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index a8096520468d..b8a9623b7c09 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -335,10 +335,10 @@ static void nft_ct_set_eval(const struct nft_expr *expr,
 }
 
 static const struct nla_policy nft_ct_policy[NFTA_CT_MAX + 1] = {
-	[NFTA_CT_DREG]		= { .type = NLA_U32 },
+	[NFTA_CT_DREG]		= NLA_POLICY_MAX(NLA_BE32, NFT_REG32_MAX),
 	[NFTA_CT_KEY]		= NLA_POLICY_MAX(NLA_BE32, 255),
 	[NFTA_CT_DIRECTION]	= NLA_POLICY_MAX(NLA_U8, IP_CT_DIR_REPLY),
-	[NFTA_CT_SREG]		= { .type = NLA_U32 },
+	[NFTA_CT_SREG]		= NLA_POLICY_MAX(NLA_BE32, NFT_REG32_MAX),
 };
 
 #ifdef CONFIG_NF_CONNTRACK_ZONES
diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index 45d3b027a02d..e140feea5f8e 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -486,13 +486,13 @@ static void nft_exthdr_dccp_eval(const struct nft_expr *expr,
 #endif
 
 static const struct nla_policy nft_exthdr_policy[NFTA_EXTHDR_MAX + 1] = {
-	[NFTA_EXTHDR_DREG]		= { .type = NLA_U32 },
+	[NFTA_EXTHDR_DREG]		= NLA_POLICY_MAX(NLA_BE32, NFT_REG32_MAX),
 	[NFTA_EXTHDR_TYPE]		= { .type = NLA_U8 },
 	[NFTA_EXTHDR_OFFSET]		= { .type = NLA_U32 },
 	[NFTA_EXTHDR_LEN]		= NLA_POLICY_MAX(NLA_BE32, 255),
 	[NFTA_EXTHDR_FLAGS]		= NLA_POLICY_MASK(NLA_BE32, NFT_EXTHDR_F_PRESENT),
 	[NFTA_EXTHDR_OP]		= NLA_POLICY_MAX(NLA_BE32, 255),
-	[NFTA_EXTHDR_SREG]		= { .type = NLA_U32 },
+	[NFTA_EXTHDR_SREG]		= NLA_POLICY_MAX(NLA_BE32, NFT_REG32_MAX),
 };
 
 static int nft_exthdr_init(const struct nft_ctx *ctx,
diff --git a/net/netfilter/nft_fib.c b/net/netfilter/nft_fib.c
index f7dc0e54375f..327a5f33659c 100644
--- a/net/netfilter/nft_fib.c
+++ b/net/netfilter/nft_fib.c
@@ -19,7 +19,7 @@
 			NFTA_FIB_F_PRESENT)
 
 const struct nla_policy nft_fib_policy[NFTA_FIB_MAX + 1] = {
-	[NFTA_FIB_DREG]		= { .type = NLA_U32 },
+	[NFTA_FIB_DREG]		= NLA_POLICY_MAX(NLA_BE32, NFT_REG32_MAX),
 	[NFTA_FIB_RESULT]	= { .type = NLA_U32 },
 	[NFTA_FIB_FLAGS]	=
 		NLA_POLICY_MASK(NLA_BE32, NFTA_FIB_F_ALL),
diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
index 1cf41e0a0e0c..3bacc9b53789 100644
--- a/net/netfilter/nft_hash.c
+++ b/net/netfilter/nft_hash.c
@@ -58,8 +58,8 @@ static void nft_symhash_eval(const struct nft_expr *expr,
 }
 
 static const struct nla_policy nft_hash_policy[NFTA_HASH_MAX + 1] = {
-	[NFTA_HASH_SREG]	= { .type = NLA_U32 },
-	[NFTA_HASH_DREG]	= { .type = NLA_U32 },
+	[NFTA_HASH_SREG]	= NLA_POLICY_MAX(NLA_BE32, NFT_REG32_MAX),
+	[NFTA_HASH_DREG]	= NLA_POLICY_MAX(NLA_BE32, NFT_REG32_MAX),
 	[NFTA_HASH_LEN]		= NLA_POLICY_MAX(NLA_BE32, 255),
 	[NFTA_HASH_MODULUS]	= { .type = NLA_U32 },
 	[NFTA_HASH_SEED]	= { .type = NLA_U32 },
diff --git a/net/netfilter/nft_immediate.c b/net/netfilter/nft_immediate.c
index 37c29947b380..1b733c7b1b0e 100644
--- a/net/netfilter/nft_immediate.c
+++ b/net/netfilter/nft_immediate.c
@@ -25,7 +25,7 @@ void nft_immediate_eval(const struct nft_expr *expr,
 }
 
 static const struct nla_policy nft_immediate_policy[NFTA_IMMEDIATE_MAX + 1] = {
-	[NFTA_IMMEDIATE_DREG]	= { .type = NLA_U32 },
+	[NFTA_IMMEDIATE_DREG]	= NLA_POLICY_MAX(NLA_BE32, NFT_REG32_MAX),
 	[NFTA_IMMEDIATE_DATA]	= { .type = NLA_NESTED },
 };
 
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index e4e619027542..9fafe5afc490 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -125,8 +125,8 @@ static const struct nla_policy nft_lookup_policy[NFTA_LOOKUP_MAX + 1] = {
 	[NFTA_LOOKUP_SET]	= { .type = NLA_STRING,
 				    .len = NFT_SET_MAXNAMELEN - 1 },
 	[NFTA_LOOKUP_SET_ID]	= { .type = NLA_U32 },
-	[NFTA_LOOKUP_SREG]	= { .type = NLA_U32 },
-	[NFTA_LOOKUP_DREG]	= { .type = NLA_U32 },
+	[NFTA_LOOKUP_SREG]	= NLA_POLICY_MAX(NLA_BE32, NFT_REG32_MAX),
+	[NFTA_LOOKUP_DREG]	= NLA_POLICY_MAX(NLA_BE32, NFT_REG32_MAX),
 	[NFTA_LOOKUP_FLAGS]	=
 		NLA_POLICY_MASK(NLA_BE32, NFT_LOOKUP_F_INV),
 };
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index d0df6cf374d1..7478063339d4 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -460,9 +460,9 @@ void nft_meta_set_eval(const struct nft_expr *expr,
 EXPORT_SYMBOL_GPL(nft_meta_set_eval);
 
 const struct nla_policy nft_meta_policy[NFTA_META_MAX + 1] = {
-	[NFTA_META_DREG]	= { .type = NLA_U32 },
+	[NFTA_META_DREG]	= NLA_POLICY_MAX(NLA_BE32, NFT_REG32_MAX),
 	[NFTA_META_KEY]		= NLA_POLICY_MAX(NLA_BE32, 255),
-	[NFTA_META_SREG]	= { .type = NLA_U32 },
+	[NFTA_META_SREG]	= NLA_POLICY_MAX(NLA_BE32, NFT_REG32_MAX),
 };
 EXPORT_SYMBOL_GPL(nft_meta_policy);
 
diff --git a/net/netfilter/nft_numgen.c b/net/netfilter/nft_numgen.c
index 4d69b3399195..b0c802370159 100644
--- a/net/netfilter/nft_numgen.c
+++ b/net/netfilter/nft_numgen.c
@@ -43,7 +43,7 @@ static void nft_ng_inc_eval(const struct nft_expr *expr,
 }
 
 static const struct nla_policy nft_ng_policy[NFTA_NG_MAX + 1] = {
-	[NFTA_NG_DREG]		= { .type = NLA_U32 },
+	[NFTA_NG_DREG]		= NLA_POLICY_MAX(NLA_BE32, NFT_REG32_MAX),
 	[NFTA_NG_MODULUS]	= { .type = NLA_U32 },
 	[NFTA_NG_TYPE]		= { .type = NLA_U32 },
 	[NFTA_NG_OFFSET]	= { .type = NLA_U32 },
diff --git a/net/netfilter/nft_objref.c b/net/netfilter/nft_objref.c
index 633cce69568f..249ded517446 100644
--- a/net/netfilter/nft_objref.c
+++ b/net/netfilter/nft_objref.c
@@ -265,7 +265,7 @@ static const struct nla_policy nft_objref_policy[NFTA_OBJREF_MAX + 1] = {
 	[NFTA_OBJREF_IMM_NAME]	= { .type = NLA_STRING,
 				    .len = NFT_OBJ_MAXNAMELEN - 1 },
 	[NFTA_OBJREF_IMM_TYPE]	= { .type = NLA_U32 },
-	[NFTA_OBJREF_SET_SREG]	= { .type = NLA_U32 },
+	[NFTA_OBJREF_SET_SREG]	= NLA_POLICY_MAX(NLA_BE32, NFT_REG32_MAX),
 	[NFTA_OBJREF_SET_NAME]	= { .type = NLA_STRING,
 				    .len = NFT_SET_MAXNAMELEN - 1 },
 	[NFTA_OBJREF_SET_ID]	= { .type = NLA_U32 },
diff --git a/net/netfilter/nft_osf.c b/net/netfilter/nft_osf.c
index b2f44bc6bd3f..18003433476c 100644
--- a/net/netfilter/nft_osf.c
+++ b/net/netfilter/nft_osf.c
@@ -12,7 +12,7 @@ struct nft_osf {
 };
 
 static const struct nla_policy nft_osf_policy[NFTA_OSF_MAX + 1] = {
-	[NFTA_OSF_DREG]		= { .type = NLA_U32 },
+	[NFTA_OSF_DREG]		= NLA_POLICY_MAX(NLA_BE32, NFT_REG32_MAX),
 	[NFTA_OSF_TTL]		= { .type = NLA_U8 },
 	[NFTA_OSF_FLAGS]	= NLA_POLICY_MASK(NLA_BE32, NFT_OSF_F_VERSION),
 };
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 91b62083d942..3fa3c6c835be 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -209,8 +209,8 @@ void nft_payload_eval(const struct nft_expr *expr,
 }
 
 static const struct nla_policy nft_payload_policy[NFTA_PAYLOAD_MAX + 1] = {
-	[NFTA_PAYLOAD_SREG]		= { .type = NLA_U32 },
-	[NFTA_PAYLOAD_DREG]		= { .type = NLA_U32 },
+	[NFTA_PAYLOAD_SREG]		= NLA_POLICY_MAX(NLA_BE32, NFT_REG32_MAX),
+	[NFTA_PAYLOAD_DREG]		= NLA_POLICY_MAX(NLA_BE32, NFT_REG32_MAX),
 	[NFTA_PAYLOAD_BASE]		= { .type = NLA_U32 },
 	[NFTA_PAYLOAD_OFFSET]		= { .type = NLA_BE32 },
 	[NFTA_PAYLOAD_LEN]		= NLA_POLICY_MAX(NLA_BE32, 255),
diff --git a/net/netfilter/nft_range.c b/net/netfilter/nft_range.c
index cbb02644b836..f8a1641afccf 100644
--- a/net/netfilter/nft_range.c
+++ b/net/netfilter/nft_range.c
@@ -41,7 +41,7 @@ void nft_range_eval(const struct nft_expr *expr,
 }
 
 static const struct nla_policy nft_range_policy[NFTA_RANGE_MAX + 1] = {
-	[NFTA_RANGE_SREG]		= { .type = NLA_U32 },
+	[NFTA_RANGE_SREG]		= NLA_POLICY_MAX(NLA_BE32, NFT_REG32_MAX),
 	[NFTA_RANGE_OP]			= NLA_POLICY_MAX(NLA_BE32, 255),
 	[NFTA_RANGE_FROM_DATA]		= { .type = NLA_NESTED },
 	[NFTA_RANGE_TO_DATA]		= { .type = NLA_NESTED },
diff --git a/net/netfilter/nft_rt.c b/net/netfilter/nft_rt.c
index ad527f3596c0..e23cd4759851 100644
--- a/net/netfilter/nft_rt.c
+++ b/net/netfilter/nft_rt.c
@@ -103,7 +103,7 @@ void nft_rt_get_eval(const struct nft_expr *expr,
 }
 
 static const struct nla_policy nft_rt_policy[NFTA_RT_MAX + 1] = {
-	[NFTA_RT_DREG]		= { .type = NLA_U32 },
+	[NFTA_RT_DREG]		= NLA_POLICY_MAX(NLA_BE32, NFT_REG32_MAX),
 	[NFTA_RT_KEY]		= NLA_POLICY_MAX(NLA_BE32, 255),
 };
 
diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
index c55a1310226a..a146a45d7531 100644
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -163,7 +163,7 @@ static void nft_socket_eval(const struct nft_expr *expr,
 
 static const struct nla_policy nft_socket_policy[NFTA_SOCKET_MAX + 1] = {
 	[NFTA_SOCKET_KEY]		= NLA_POLICY_MAX(NLA_BE32, 255),
-	[NFTA_SOCKET_DREG]		= { .type = NLA_U32 },
+	[NFTA_SOCKET_DREG]		= NLA_POLICY_MAX(NLA_BE32, NFT_REG32_MAX),
 	[NFTA_SOCKET_LEVEL]		= NLA_POLICY_MAX(NLA_BE32, 255),
 };
 
diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index 65d06300f48a..0b987bc2132a 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -67,7 +67,7 @@ static void nft_tunnel_get_eval(const struct nft_expr *expr,
 
 static const struct nla_policy nft_tunnel_policy[NFTA_TUNNEL_MAX + 1] = {
 	[NFTA_TUNNEL_KEY]	= NLA_POLICY_MAX(NLA_BE32, 255),
-	[NFTA_TUNNEL_DREG]	= { .type = NLA_U32 },
+	[NFTA_TUNNEL_DREG]	= NLA_POLICY_MAX(NLA_BE32, NFT_REG32_MAX),
 	[NFTA_TUNNEL_MODE]	= NLA_POLICY_MAX(NLA_BE32, NFT_TUNNEL_MODE_MAX),
 };
 
diff --git a/net/netfilter/nft_xfrm.c b/net/netfilter/nft_xfrm.c
index 6858cd2d16a4..65a75d88e5f0 100644
--- a/net/netfilter/nft_xfrm.c
+++ b/net/netfilter/nft_xfrm.c
@@ -19,7 +19,7 @@ static const struct nla_policy nft_xfrm_policy[NFTA_XFRM_MAX + 1] = {
 	[NFTA_XFRM_KEY]		= NLA_POLICY_MAX(NLA_BE32, 255),
 	[NFTA_XFRM_DIR]		= NLA_POLICY_MAX(NLA_U8, XFRM_POLICY_OUT),
 	[NFTA_XFRM_SPNUM]	= NLA_POLICY_MAX(NLA_BE32, XFRM_MAX_DEPTH - 1),
-	[NFTA_XFRM_DREG]	= { .type = NLA_U32 },
+	[NFTA_XFRM_DREG]	= NLA_POLICY_MAX(NLA_BE32, NFT_REG32_MAX),
 };
 
 struct nft_xfrm {
-- 
2.53.0

