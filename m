Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0996E3B7B91;
	Tue,  7 Apr 2026 14:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775571374; cv=none; b=dgd8v4lYw9zTM9YTVunqEGLTRjGpAcuMOkn6IfU30SKRych2HFLseZw/3xGB9cgIPWa/qE+1wizxQKLFyKGJZWIud8Z1B2AbWFHOF1yWc5XylzQsrJTGrIipL2hTZ18Lu2wiDX61ez789IjlBEYSm4GwNb2no75v14kusLTMKtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775571374; c=relaxed/simple;
	bh=xR5UabVg3aTHgEHtVSzbZ+VtMa7BYMT3zME/9UPXWx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dGwxD5OefHVT0lgGCBP+NCSNisKxX84P/ezDwcwIp3ojBfm9vRgO0BNhQ2Jmy1noY/TBW+cPPn1RzY3I6Cpw0MyFpWWmsfslOrrWWUVVqc+4zldqSp9dW+0IZADE9x88O7RETBLQpTOZM01syuiAdxyQTOP/SNJigh46N1xbxCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 1F43060660; Tue, 07 Apr 2026 16:16:11 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 06/13] netfilter: add more netlink-based policy range checks
Date: Tue,  7 Apr 2026 16:15:33 +0200
Message-ID: <20260407141540.11549-7-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260407141540.11549-1-fw@strlen.de>
References: <20260407141540.11549-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These spots either already check the attribute range manually
before use or the consuming functions tolerate unexpected values.

Nevertheless, add more range checks via netlink policy so we gain
more users and avoid possible re-use in other places that might
not have the required manual checks.  This also improves error
reporting: netlink core can generate extack errors.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/ipset/ip_set_core.c  |  2 +-
 net/netfilter/nf_tables_api.c      | 20 +++++++++++++++-----
 net/netfilter/nfnetlink_acct.c     |  2 +-
 net/netfilter/nfnetlink_cthelper.c |  2 +-
 net/netfilter/nfnetlink_hook.c     |  2 +-
 net/netfilter/nfnetlink_log.c      |  4 +++-
 net/netfilter/nfnetlink_osf.c      |  2 +-
 net/netfilter/nfnetlink_queue.c    |  2 +-
 net/netfilter/nft_compat.c         |  2 +-
 net/netfilter/nft_connlimit.c      |  2 +-
 net/netfilter/nft_ct.c             |  2 +-
 net/netfilter/nft_dynset.c         |  3 ++-
 net/netfilter/nft_exthdr.c         |  2 +-
 net/netfilter/nft_inner.c          |  2 +-
 net/netfilter/nft_limit.c          |  2 +-
 net/netfilter/nft_log.c            |  2 +-
 net/netfilter/nft_osf.c            |  2 +-
 net/netfilter/nft_payload.c        |  2 +-
 net/netfilter/nft_queue.c          |  2 +-
 net/netfilter/nft_quota.c          |  2 +-
 net/netfilter/nft_synproxy.c       |  4 ++--
 net/netfilter/nft_tunnel.c         |  4 ++--
 net/netfilter/nft_xfrm.c           |  4 ++--
 23 files changed, 43 insertions(+), 30 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index d0c9fe59c67d..c5a26236a0bb 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -985,7 +985,7 @@ static const struct nla_policy ip_set_create_policy[IPSET_ATTR_CMD_MAX + 1] = {
 				    .len = IPSET_MAXNAMELEN - 1 },
 	[IPSET_ATTR_TYPENAME]	= { .type = NLA_NUL_STRING,
 				    .len = IPSET_MAXNAMELEN - 1},
-	[IPSET_ATTR_REVISION]	= { .type = NLA_U8 },
+	[IPSET_ATTR_REVISION]	= NLA_POLICY_MAX(NLA_U8, IPSET_REVISION_MAX),
 	[IPSET_ATTR_FAMILY]	= { .type = NLA_U8 },
 	[IPSET_ATTR_DATA]	= { .type = NLA_NESTED },
 };
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 8ed8d5384b97..8537b94653d3 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1112,7 +1112,7 @@ static __be16 nft_base_seq_be16(const struct net *net)
 static const struct nla_policy nft_table_policy[NFTA_TABLE_MAX + 1] = {
 	[NFTA_TABLE_NAME]	= { .type = NLA_STRING,
 				    .len = NFT_TABLE_MAXNAMELEN - 1 },
-	[NFTA_TABLE_FLAGS]	= { .type = NLA_U32 },
+	[NFTA_TABLE_FLAGS]	= NLA_POLICY_MASK(NLA_BE32, NFT_TABLE_F_MASK),
 	[NFTA_TABLE_HANDLE]	= { .type = NLA_U64 },
 	[NFTA_TABLE_USERDATA]	= { .type = NLA_BINARY,
 				    .len = NFT_USERDATA_MAXLEN }
@@ -1878,7 +1878,7 @@ static const struct nla_policy nft_chain_policy[NFTA_CHAIN_MAX + 1] = {
 	[NFTA_CHAIN_TYPE]	= { .type = NLA_STRING,
 				    .len = NFT_MODULE_AUTOLOAD_LIMIT },
 	[NFTA_CHAIN_COUNTERS]	= { .type = NLA_NESTED },
-	[NFTA_CHAIN_FLAGS]	= { .type = NLA_U32 },
+	[NFTA_CHAIN_FLAGS]	= NLA_POLICY_MASK(NLA_BE32, NFT_CHAIN_FLAGS),
 	[NFTA_CHAIN_ID]		= { .type = NLA_U32 },
 	[NFTA_CHAIN_USERDATA]	= { .type = NLA_BINARY,
 				    .len = NFT_USERDATA_MAXLEN },
@@ -4597,7 +4597,16 @@ static const struct nla_policy nft_set_policy[NFTA_SET_MAX + 1] = {
 					    .len = NFT_TABLE_MAXNAMELEN - 1 },
 	[NFTA_SET_NAME]			= { .type = NLA_STRING,
 					    .len = NFT_SET_MAXNAMELEN - 1 },
-	[NFTA_SET_FLAGS]		= { .type = NLA_U32 },
+	[NFTA_SET_FLAGS]		= NLA_POLICY_MASK(NLA_BE32,
+							  NFT_SET_ANONYMOUS |
+							  NFT_SET_CONSTANT |
+							  NFT_SET_INTERVAL |
+							  NFT_SET_MAP |
+							  NFT_SET_TIMEOUT |
+							  NFT_SET_EVAL |
+							  NFT_SET_OBJECT |
+							  NFT_SET_CONCAT |
+							  NFT_SET_EXPR),
 	[NFTA_SET_KEY_TYPE]		= { .type = NLA_U32 },
 	[NFTA_SET_KEY_LEN]		= { .type = NLA_U32 },
 	[NFTA_SET_DATA_TYPE]		= { .type = NLA_U32 },
@@ -5929,7 +5938,8 @@ const struct nft_set_ext_type nft_set_ext_types[] = {
 static const struct nla_policy nft_set_elem_policy[NFTA_SET_ELEM_MAX + 1] = {
 	[NFTA_SET_ELEM_KEY]		= { .type = NLA_NESTED },
 	[NFTA_SET_ELEM_DATA]		= { .type = NLA_NESTED },
-	[NFTA_SET_ELEM_FLAGS]		= { .type = NLA_U32 },
+	[NFTA_SET_ELEM_FLAGS]		= NLA_POLICY_MASK(NLA_BE32, NFT_SET_ELEM_INTERVAL_END |
+								    NFT_SET_ELEM_CATCHALL),
 	[NFTA_SET_ELEM_TIMEOUT]		= { .type = NLA_U64 },
 	[NFTA_SET_ELEM_EXPIRATION]	= { .type = NLA_U64 },
 	[NFTA_SET_ELEM_USERDATA]	= { .type = NLA_BINARY,
@@ -8649,7 +8659,7 @@ static const struct nla_policy nft_flowtable_policy[NFTA_FLOWTABLE_MAX + 1] = {
 					    .len = NFT_NAME_MAXLEN - 1 },
 	[NFTA_FLOWTABLE_HOOK]		= { .type = NLA_NESTED },
 	[NFTA_FLOWTABLE_HANDLE]		= { .type = NLA_U64 },
-	[NFTA_FLOWTABLE_FLAGS]		= { .type = NLA_U32 },
+	[NFTA_FLOWTABLE_FLAGS]		= NLA_POLICY_MASK(NLA_BE32, NFT_FLOWTABLE_MASK),
 };
 
 struct nft_flowtable *nft_flowtable_lookup(const struct net *net,
diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
index 2bfaa773d82f..8ff1e0ad5cb0 100644
--- a/net/netfilter/nfnetlink_acct.c
+++ b/net/netfilter/nfnetlink_acct.c
@@ -373,7 +373,7 @@ static const struct nla_policy nfnl_acct_policy[NFACCT_MAX+1] = {
 	[NFACCT_NAME] = { .type = NLA_NUL_STRING, .len = NFACCT_NAME_MAX-1 },
 	[NFACCT_BYTES] = { .type = NLA_U64 },
 	[NFACCT_PKTS] = { .type = NLA_U64 },
-	[NFACCT_FLAGS] = { .type = NLA_U32 },
+	[NFACCT_FLAGS] = NLA_POLICY_MASK(NLA_BE32, NFACCT_F_QUOTA),
 	[NFACCT_QUOTA] = { .type = NLA_U64 },
 	[NFACCT_FILTER] = {.type = NLA_NESTED },
 };
diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index d545fa459455..0d16ad82d70c 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -165,7 +165,7 @@ nfnl_cthelper_expect_policy(struct nf_conntrack_expect_policy *expect_policy,
 
 static const struct nla_policy
 nfnl_cthelper_expect_policy_set[NFCTH_POLICY_SET_MAX+1] = {
-	[NFCTH_POLICY_SET_NUM] = { .type = NLA_U32, },
+	[NFCTH_POLICY_SET_NUM] = NLA_POLICY_MAX(NLA_BE32, NF_CT_MAX_EXPECT_CLASSES),
 };
 
 static int
diff --git a/net/netfilter/nfnetlink_hook.c b/net/netfilter/nfnetlink_hook.c
index 531706982859..5623c18fcd12 100644
--- a/net/netfilter/nfnetlink_hook.c
+++ b/net/netfilter/nfnetlink_hook.c
@@ -24,7 +24,7 @@
 #include <net/sock.h>
 
 static const struct nla_policy nfnl_hook_nla_policy[NFNLA_HOOK_MAX + 1] = {
-	[NFNLA_HOOK_HOOKNUM]	= { .type = NLA_U32 },
+	[NFNLA_HOOK_HOOKNUM]	= NLA_POLICY_MAX(NLA_BE32, 255),
 	[NFNLA_HOOK_PRIORITY]	= { .type = NLA_U32 },
 	[NFNLA_HOOK_DEV]	= { .type = NLA_STRING,
 				    .len = IFNAMSIZ - 1 },
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 91aa210b3e53..9497ebeedd55 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -879,7 +879,9 @@ static const struct nla_policy nfula_cfg_policy[NFULA_CFG_MAX+1] = {
 	[NFULA_CFG_TIMEOUT]	= { .type = NLA_U32 },
 	[NFULA_CFG_QTHRESH]	= { .type = NLA_U32 },
 	[NFULA_CFG_NLBUFSIZ]	= { .type = NLA_U32 },
-	[NFULA_CFG_FLAGS]	= { .type = NLA_U16 },
+	[NFULA_CFG_FLAGS]	= NLA_POLICY_MASK(NLA_BE16, NFULNL_CFG_F_SEQ |
+						  NFULNL_CFG_F_SEQ_GLOBAL |
+						  NFULNL_CFG_F_CONNTRACK),
 };
 
 static int nfulnl_recv_config(struct sk_buff *skb, const struct nfnl_info *info,
diff --git a/net/netfilter/nfnetlink_osf.c b/net/netfilter/nfnetlink_osf.c
index 45d9ad231a92..d64ce21c7b55 100644
--- a/net/netfilter/nfnetlink_osf.c
+++ b/net/netfilter/nfnetlink_osf.c
@@ -293,7 +293,7 @@ bool nf_osf_find(const struct sk_buff *skb,
 EXPORT_SYMBOL_GPL(nf_osf_find);
 
 static const struct nla_policy nfnl_osf_policy[OSF_ATTR_MAX + 1] = {
-	[OSF_ATTR_FINGER]	= { .len = sizeof(struct nf_osf_user_finger) },
+	[OSF_ATTR_FINGER]	= NLA_POLICY_EXACT_LEN(sizeof(struct nf_osf_user_finger)),
 };
 
 static int nfnl_osf_add_callback(struct sk_buff *skb,
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 2aa2380d976a..ac0c19233681 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1599,7 +1599,7 @@ static const struct nla_policy nfqa_cfg_policy[NFQA_CFG_MAX+1] = {
 	[NFQA_CFG_PARAMS]	= { .len = sizeof(struct nfqnl_msg_config_params) },
 	[NFQA_CFG_QUEUE_MAXLEN]	= { .type = NLA_U32 },
 	[NFQA_CFG_MASK]		= { .type = NLA_U32 },
-	[NFQA_CFG_FLAGS]	= { .type = NLA_U32 },
+	[NFQA_CFG_FLAGS]	= NLA_POLICY_MASK(NLA_BE32, NFQA_CFG_F_MAX - 1),
 };
 
 static const struct nf_queue_handler nfqh = {
diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 53a614a0e3cd..decc725a33c2 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -195,7 +195,7 @@ static void target_compat_from_user(struct xt_target *t, void *in, void *out)
 
 static const struct nla_policy nft_rule_compat_policy[NFTA_RULE_COMPAT_MAX + 1] = {
 	[NFTA_RULE_COMPAT_PROTO]	= { .type = NLA_U32 },
-	[NFTA_RULE_COMPAT_FLAGS]	= { .type = NLA_U32 },
+	[NFTA_RULE_COMPAT_FLAGS]	= NLA_POLICY_MASK(NLA_BE32, NFT_RULE_COMPAT_F_MASK),
 };
 
 static int nft_parse_compat(const struct nlattr *attr, u16 *proto, bool *inv)
diff --git a/net/netfilter/nft_connlimit.c b/net/netfilter/nft_connlimit.c
index 09ac4f77e389..46b31d78abc6 100644
--- a/net/netfilter/nft_connlimit.c
+++ b/net/netfilter/nft_connlimit.c
@@ -159,7 +159,7 @@ static int nft_connlimit_obj_dump(struct sk_buff *skb,
 
 static const struct nla_policy nft_connlimit_policy[NFTA_CONNLIMIT_MAX + 1] = {
 	[NFTA_CONNLIMIT_COUNT]	= { .type = NLA_U32 },
-	[NFTA_CONNLIMIT_FLAGS]	= { .type = NLA_U32 },
+	[NFTA_CONNLIMIT_FLAGS]	= NLA_POLICY_MASK(NLA_BE32, NFT_CONNLIMIT_F_INV),
 };
 
 static struct nft_object_type nft_connlimit_obj_type;
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index a8fcb4b6ea1a..00dabd985883 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -338,7 +338,7 @@ static void nft_ct_set_eval(const struct nft_expr *expr,
 static const struct nla_policy nft_ct_policy[NFTA_CT_MAX + 1] = {
 	[NFTA_CT_DREG]		= { .type = NLA_U32 },
 	[NFTA_CT_KEY]		= NLA_POLICY_MAX(NLA_BE32, 255),
-	[NFTA_CT_DIRECTION]	= { .type = NLA_U8 },
+	[NFTA_CT_DIRECTION]	= NLA_POLICY_MAX(NLA_U8, IP_CT_DIR_REPLY),
 	[NFTA_CT_SREG]		= { .type = NLA_U32 },
 };
 
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 57bf94ae8724..ee9d3e7b1ecf 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -163,7 +163,8 @@ static const struct nla_policy nft_dynset_policy[NFTA_DYNSET_MAX + 1] = {
 	[NFTA_DYNSET_SREG_DATA]	= { .type = NLA_U32 },
 	[NFTA_DYNSET_TIMEOUT]	= { .type = NLA_U64 },
 	[NFTA_DYNSET_EXPR]	= { .type = NLA_NESTED },
-	[NFTA_DYNSET_FLAGS]	= { .type = NLA_U32 },
+	[NFTA_DYNSET_FLAGS]	= NLA_POLICY_MASK(NLA_BE32, NFT_DYNSET_F_INV |
+						  NFT_DYNSET_F_EXPR),
 	[NFTA_DYNSET_EXPRESSIONS] = { .type = NLA_NESTED },
 };
 
diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index 14d4ad7f518c..b997307d94f9 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -490,7 +490,7 @@ static const struct nla_policy nft_exthdr_policy[NFTA_EXTHDR_MAX + 1] = {
 	[NFTA_EXTHDR_TYPE]		= { .type = NLA_U8 },
 	[NFTA_EXTHDR_OFFSET]		= { .type = NLA_U32 },
 	[NFTA_EXTHDR_LEN]		= NLA_POLICY_MAX(NLA_BE32, 255),
-	[NFTA_EXTHDR_FLAGS]		= { .type = NLA_U32 },
+	[NFTA_EXTHDR_FLAGS]		= NLA_POLICY_MASK(NLA_BE32, NFT_EXTHDR_F_PRESENT),
 	[NFTA_EXTHDR_OP]		= NLA_POLICY_MAX(NLA_BE32, 255),
 	[NFTA_EXTHDR_SREG]		= { .type = NLA_U32 },
 };
diff --git a/net/netfilter/nft_inner.c b/net/netfilter/nft_inner.c
index c4569d4b9228..03ffb1159fc1 100644
--- a/net/netfilter/nft_inner.c
+++ b/net/netfilter/nft_inner.c
@@ -321,7 +321,7 @@ static void nft_inner_eval(const struct nft_expr *expr, struct nft_regs *regs,
 
 static const struct nla_policy nft_inner_policy[NFTA_INNER_MAX + 1] = {
 	[NFTA_INNER_NUM]	= { .type = NLA_U32 },
-	[NFTA_INNER_FLAGS]	= { .type = NLA_U32 },
+	[NFTA_INNER_FLAGS]	= NLA_POLICY_MASK(NLA_BE32, NFT_INNER_MASK),
 	[NFTA_INNER_HDRSIZE]	= { .type = NLA_U32 },
 	[NFTA_INNER_TYPE]	= { .type = NLA_U32 },
 	[NFTA_INNER_EXPR]	= { .type = NLA_NESTED },
diff --git a/net/netfilter/nft_limit.c b/net/netfilter/nft_limit.c
index f6830621c471..167d99b1447f 100644
--- a/net/netfilter/nft_limit.c
+++ b/net/netfilter/nft_limit.c
@@ -189,7 +189,7 @@ static const struct nla_policy nft_limit_policy[NFTA_LIMIT_MAX + 1] = {
 	[NFTA_LIMIT_UNIT]	= { .type = NLA_U64 },
 	[NFTA_LIMIT_BURST]	= { .type = NLA_U32 },
 	[NFTA_LIMIT_TYPE]	= { .type = NLA_U32 },
-	[NFTA_LIMIT_FLAGS]	= { .type = NLA_U32 },
+	[NFTA_LIMIT_FLAGS]	= NLA_POLICY_MASK(NLA_BE32, NFT_LIMIT_F_INV),
 };
 
 static int nft_limit_pkts_init(const struct nft_ctx *ctx,
diff --git a/net/netfilter/nft_log.c b/net/netfilter/nft_log.c
index da0c0d1c9cea..0d868eea6257 100644
--- a/net/netfilter/nft_log.c
+++ b/net/netfilter/nft_log.c
@@ -69,7 +69,7 @@ static const struct nla_policy nft_log_policy[NFTA_LOG_MAX + 1] = {
 	[NFTA_LOG_SNAPLEN]	= { .type = NLA_U32 },
 	[NFTA_LOG_QTHRESHOLD]	= { .type = NLA_U16 },
 	[NFTA_LOG_LEVEL]	= { .type = NLA_U32 },
-	[NFTA_LOG_FLAGS]	= { .type = NLA_U32 },
+	[NFTA_LOG_FLAGS]	= NLA_POLICY_MASK(NLA_BE32, NF_LOG_MASK),
 };
 
 static int nft_log_modprobe(struct net *net, enum nf_log_type t)
diff --git a/net/netfilter/nft_osf.c b/net/netfilter/nft_osf.c
index 39ccd67ed265..b2f44bc6bd3f 100644
--- a/net/netfilter/nft_osf.c
+++ b/net/netfilter/nft_osf.c
@@ -14,7 +14,7 @@ struct nft_osf {
 static const struct nla_policy nft_osf_policy[NFTA_OSF_MAX + 1] = {
 	[NFTA_OSF_DREG]		= { .type = NLA_U32 },
 	[NFTA_OSF_TTL]		= { .type = NLA_U8 },
-	[NFTA_OSF_FLAGS]	= { .type = NLA_U32 },
+	[NFTA_OSF_FLAGS]	= NLA_POLICY_MASK(NLA_BE32, NFT_OSF_F_VERSION),
 };
 
 static void nft_osf_eval(const struct nft_expr *expr, struct nft_regs *regs,
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 973d56af03ff..91b62083d942 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -216,7 +216,7 @@ static const struct nla_policy nft_payload_policy[NFTA_PAYLOAD_MAX + 1] = {
 	[NFTA_PAYLOAD_LEN]		= NLA_POLICY_MAX(NLA_BE32, 255),
 	[NFTA_PAYLOAD_CSUM_TYPE]	= { .type = NLA_U32 },
 	[NFTA_PAYLOAD_CSUM_OFFSET]	= NLA_POLICY_MAX(NLA_BE32, 255),
-	[NFTA_PAYLOAD_CSUM_FLAGS]	= { .type = NLA_U32 },
+	[NFTA_PAYLOAD_CSUM_FLAGS]	= NLA_POLICY_MASK(NLA_BE32, NFT_PAYLOAD_L4CSUM_PSEUDOHDR),
 };
 
 static int nft_payload_init(const struct nft_ctx *ctx,
diff --git a/net/netfilter/nft_queue.c b/net/netfilter/nft_queue.c
index 8eb13a02942e..b83d209db886 100644
--- a/net/netfilter/nft_queue.c
+++ b/net/netfilter/nft_queue.c
@@ -95,7 +95,7 @@ static int nft_queue_validate(const struct nft_ctx *ctx,
 static const struct nla_policy nft_queue_policy[NFTA_QUEUE_MAX + 1] = {
 	[NFTA_QUEUE_NUM]	= { .type = NLA_U16 },
 	[NFTA_QUEUE_TOTAL]	= { .type = NLA_U16 },
-	[NFTA_QUEUE_FLAGS]	= { .type = NLA_U16 },
+	[NFTA_QUEUE_FLAGS]	= NLA_POLICY_MASK(NLA_BE16, NFT_QUEUE_FLAG_MASK),
 	[NFTA_QUEUE_SREG_QNUM]	= { .type = NLA_U32 },
 };
 
diff --git a/net/netfilter/nft_quota.c b/net/netfilter/nft_quota.c
index 3be788e5223c..6ed7c4409706 100644
--- a/net/netfilter/nft_quota.c
+++ b/net/netfilter/nft_quota.c
@@ -46,7 +46,7 @@ static inline void nft_quota_do_eval(struct nft_quota *priv,
 
 static const struct nla_policy nft_quota_policy[NFTA_QUOTA_MAX + 1] = {
 	[NFTA_QUOTA_BYTES]	= { .type = NLA_U64 },
-	[NFTA_QUOTA_FLAGS]	= { .type = NLA_U32 },
+	[NFTA_QUOTA_FLAGS]	= NLA_POLICY_MASK(NLA_BE32, NFT_QUOTA_F_INV),
 	[NFTA_QUOTA_CONSUMED]	= { .type = NLA_U64 },
 };
 
diff --git a/net/netfilter/nft_synproxy.c b/net/netfilter/nft_synproxy.c
index 8e452a874969..7641f249614c 100644
--- a/net/netfilter/nft_synproxy.c
+++ b/net/netfilter/nft_synproxy.c
@@ -17,8 +17,8 @@ struct nft_synproxy {
 
 static const struct nla_policy nft_synproxy_policy[NFTA_SYNPROXY_MAX + 1] = {
 	[NFTA_SYNPROXY_MSS]		= { .type = NLA_U16 },
-	[NFTA_SYNPROXY_WSCALE]		= { .type = NLA_U8 },
-	[NFTA_SYNPROXY_FLAGS]		= { .type = NLA_U32 },
+	[NFTA_SYNPROXY_WSCALE]		= NLA_POLICY_MAX(NLA_U8, TCP_MAX_WSCALE),
+	[NFTA_SYNPROXY_FLAGS]		= NLA_POLICY_MASK(NLA_BE32, NF_SYNPROXY_OPT_MASK),
 };
 
 static void nft_synproxy_tcp_options(struct synproxy_options *opts,
diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index f5cadba91417..65d06300f48a 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -68,7 +68,7 @@ static void nft_tunnel_get_eval(const struct nft_expr *expr,
 static const struct nla_policy nft_tunnel_policy[NFTA_TUNNEL_MAX + 1] = {
 	[NFTA_TUNNEL_KEY]	= NLA_POLICY_MAX(NLA_BE32, 255),
 	[NFTA_TUNNEL_DREG]	= { .type = NLA_U32 },
-	[NFTA_TUNNEL_MODE]	= NLA_POLICY_MAX(NLA_BE32, 255),
+	[NFTA_TUNNEL_MODE]	= NLA_POLICY_MAX(NLA_BE32, NFT_TUNNEL_MODE_MAX),
 };
 
 static int nft_tunnel_get_init(const struct nft_ctx *ctx,
@@ -408,7 +408,7 @@ static const struct nla_policy nft_tunnel_key_policy[NFTA_TUNNEL_KEY_MAX + 1] =
 	[NFTA_TUNNEL_KEY_IP]	= { .type = NLA_NESTED, },
 	[NFTA_TUNNEL_KEY_IP6]	= { .type = NLA_NESTED, },
 	[NFTA_TUNNEL_KEY_ID]	= { .type = NLA_U32, },
-	[NFTA_TUNNEL_KEY_FLAGS]	= { .type = NLA_U32, },
+	[NFTA_TUNNEL_KEY_FLAGS]	= NLA_POLICY_MASK(NLA_BE32, NFT_TUNNEL_F_MASK),
 	[NFTA_TUNNEL_KEY_TOS]	= { .type = NLA_U8, },
 	[NFTA_TUNNEL_KEY_TTL]	= { .type = NLA_U8, },
 	[NFTA_TUNNEL_KEY_SPORT]	= { .type = NLA_U16, },
diff --git a/net/netfilter/nft_xfrm.c b/net/netfilter/nft_xfrm.c
index 7ffe6a2690d1..6858cd2d16a4 100644
--- a/net/netfilter/nft_xfrm.c
+++ b/net/netfilter/nft_xfrm.c
@@ -17,8 +17,8 @@
 
 static const struct nla_policy nft_xfrm_policy[NFTA_XFRM_MAX + 1] = {
 	[NFTA_XFRM_KEY]		= NLA_POLICY_MAX(NLA_BE32, 255),
-	[NFTA_XFRM_DIR]		= { .type = NLA_U8 },
-	[NFTA_XFRM_SPNUM]	= NLA_POLICY_MAX(NLA_BE32, 255),
+	[NFTA_XFRM_DIR]		= NLA_POLICY_MAX(NLA_U8, XFRM_POLICY_OUT),
+	[NFTA_XFRM_SPNUM]	= NLA_POLICY_MAX(NLA_BE32, XFRM_MAX_DEPTH - 1),
 	[NFTA_XFRM_DREG]	= { .type = NLA_U32 },
 };
 
-- 
2.52.0

