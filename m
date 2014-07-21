From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl] src: stricter netlink attribute length validation
Date: Mon, 21 Jul 2014 14:31:16 +0200
Message-ID: <1405945876-8807-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57387 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754579AbaGUMbP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jul 2014 08:31:15 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If the kernel sends us different data length for a given attribute,
stop further processing and indicate that an ABI breakage has ocurred.
This is an example of the (hypothetical) message that is shown in that
case:

 nf_tables kernel ABI is broken, contact your vendor.
 table.c:214 reason: Numerical result out of range

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/chain.c          |   36 ++++++++++++------------------------
 src/expr/bitwise.c   |   12 ++++--------
 src/expr/byteorder.c |    6 ++----
 src/expr/cmp.c       |   12 ++++--------
 src/expr/counter.c   |    6 ++----
 src/expr/ct.c        |   12 ++++--------
 src/expr/data_reg.c  |   24 ++++++++----------------
 src/expr/exthdr.c    |   12 ++++--------
 src/expr/immediate.c |   12 ++++--------
 src/expr/limit.c     |    6 ++----
 src/expr/log.c       |   18 ++++++------------
 src/expr/lookup.c    |   12 ++++--------
 src/expr/match.c     |   18 ++++++------------
 src/expr/meta.c      |    6 ++----
 src/expr/nat.c       |    6 ++----
 src/expr/payload.c   |    6 ++----
 src/expr/queue.c     |    6 ++----
 src/expr/reject.c    |   12 ++++--------
 src/expr/target.c    |   18 ++++++------------
 src/internal.h       |    9 +++++++++
 src/rule.c           |   48 ++++++++++++++++--------------------------------
 src/set.c            |   12 ++++--------
 src/set_elem.c       |   24 ++++++++----------------
 src/table.c          |   17 ++++-------------
 src/utils.c          |    7 +++++++
 25 files changed, 128 insertions(+), 229 deletions(-)
 create mode 100644 src/attr.c

diff --git a/src/attr.c b/src/attr.c
new file mode 100644
index 0000000..e69de29
diff --git a/src/chain.c b/src/chain.c
index ad9da51..a056bab 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -385,30 +385,22 @@ static int nft_chain_parse_attr_cb(const struct nlattr *attr, void *data)
 	case NFTA_CHAIN_NAME:
 	case NFTA_CHAIN_TABLE:
 	case NFTA_CHAIN_TYPE:
-		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0) {
-			perror("mnl_attr_validate");
-			return MNL_CB_ERROR;
-		}
+		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
+			abi_breakage();
 		break;
 	case NFTA_CHAIN_HOOK:
 	case NFTA_CHAIN_COUNTERS:
-		if (mnl_attr_validate(attr, MNL_TYPE_NESTED) < 0) {
-			perror("mnl_attr_validate");
-			return MNL_CB_ERROR;
-		}
+		if (mnl_attr_validate(attr, MNL_TYPE_NESTED) < 0)
+			abi_breakage();
 		break;
 	case NFTA_CHAIN_POLICY:
 	case NFTA_CHAIN_USE:
-		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0) {
-			perror("mnl_attr_validate");
-			return MNL_CB_ERROR;
-		}
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+			abi_breakage();
 		break;
 	case NFTA_CHAIN_HANDLE:
-		if (mnl_attr_validate(attr, MNL_TYPE_U64) < 0) {
-			perror("mnl_attr_validate");
-			return MNL_CB_ERROR;
-		}
+		if (mnl_attr_validate(attr, MNL_TYPE_U64) < 0)
+			abi_breakage();
 		break;
 	}
 
@@ -427,10 +419,8 @@ static int nft_chain_parse_counters_cb(const struct nlattr *attr, void *data)
 	switch(type) {
 	case NFTA_COUNTER_BYTES:
 	case NFTA_COUNTER_PACKETS:
-		if (mnl_attr_validate(attr, MNL_TYPE_U64) < 0) {
-			perror("mnl_attr_validate");
-			return MNL_CB_ERROR;
-		}
+		if (mnl_attr_validate(attr, MNL_TYPE_U64) < 0)
+			abi_breakage();
 		break;
 	}
 
@@ -467,10 +457,8 @@ static int nft_chain_parse_hook_cb(const struct nlattr *attr, void *data)
 	switch(type) {
 	case NFTA_HOOK_HOOKNUM:
 	case NFTA_HOOK_PRIORITY:
-		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0) {
-			perror("mnl_attr_validate");
-			return MNL_CB_ERROR;
-		}
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+			abi_breakage();
 		break;
 	}
 
diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index 7872a7f..b575c7a 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -99,17 +99,13 @@ static int nft_rule_expr_bitwise_cb(const struct nlattr *attr, void *data)
 	case NFTA_BITWISE_SREG:
 	case NFTA_BITWISE_DREG:
 	case NFTA_BITWISE_LEN:
-		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0) {
-			perror("mnl_attr_validate");
-			return MNL_CB_ERROR;
-		}
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+			abi_breakage();
 		break;
 	case NFTA_BITWISE_MASK:
 	case NFTA_BITWISE_XOR:
-		if (mnl_attr_validate(attr, MNL_TYPE_BINARY) < 0) {
-			perror("mnl_attr_validate");
-			return MNL_CB_ERROR;
-		}
+		if (mnl_attr_validate(attr, MNL_TYPE_BINARY) < 0)
+			abi_breakage();
 		break;
 	}
 
diff --git a/src/expr/byteorder.c b/src/expr/byteorder.c
index 3659918..ad28bc4 100644
--- a/src/expr/byteorder.c
+++ b/src/expr/byteorder.c
@@ -99,10 +99,8 @@ static int nft_rule_expr_byteorder_cb(const struct nlattr *attr, void *data)
 	case NFTA_BYTEORDER_OP:
 	case NFTA_BYTEORDER_LEN:
 	case NFTA_BYTEORDER_SIZE:
-		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0) {
-			perror("mnl_attr_validate");
-			return MNL_CB_ERROR;
-		}
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+			abi_breakage();
 		break;
 	}
 
diff --git a/src/expr/cmp.c b/src/expr/cmp.c
index 8b0e54d..6ecab7d 100644
--- a/src/expr/cmp.c
+++ b/src/expr/cmp.c
@@ -84,16 +84,12 @@ static int nft_rule_expr_cmp_cb(const struct nlattr *attr, void *data)
 	switch(type) {
 	case NFTA_CMP_SREG:
 	case NFTA_CMP_OP:
-		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0) {
-			perror("mnl_attr_validate");
-			return MNL_CB_ERROR;
-		}
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+			abi_breakage();
 		break;
 	case NFTA_CMP_DATA:
-		if (mnl_attr_validate(attr, MNL_TYPE_BINARY) < 0) {
-			perror("mnl_attr_validate");
-			return MNL_CB_ERROR;
-		}
+		if (mnl_attr_validate(attr, MNL_TYPE_BINARY) < 0)
+			abi_breakage();
 		break;
 	}
 
diff --git a/src/expr/counter.c b/src/expr/counter.c
index 5ab9a5a..82d1939 100644
--- a/src/expr/counter.c
+++ b/src/expr/counter.c
@@ -75,10 +75,8 @@ static int nft_rule_expr_counter_cb(const struct nlattr *attr, void *data)
 	switch(type) {
 	case NFTA_COUNTER_BYTES:
 	case NFTA_COUNTER_PACKETS:
-		if (mnl_attr_validate(attr, MNL_TYPE_U64) < 0) {
-			perror("mnl_attr_validate");
-			return MNL_CB_ERROR;
-		}
+		if (mnl_attr_validate(attr, MNL_TYPE_U64) < 0)
+			abi_breakage();
 		break;
 	}
 
diff --git a/src/expr/ct.c b/src/expr/ct.c
index d9d36a6..d443c1e 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -96,16 +96,12 @@ static int nft_rule_expr_ct_cb(const struct nlattr *attr, void *data)
 	case NFTA_CT_KEY:
 	case NFTA_CT_DREG:
 	case NFTA_CT_SREG:
-		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0) {
-			perror("mnl_attr_validate");
-			return MNL_CB_ERROR;
-		}
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+			abi_breakage();
 		break;
 	case NFTA_CT_DIRECTION:
-		if (mnl_attr_validate(attr, MNL_TYPE_U8) < 0) {
-			perror("mnl_attr_validate");
-			return MNL_CB_ERROR;
-		}
+		if (mnl_attr_validate(attr, MNL_TYPE_U8) < 0)
+			abi_breakage();
 		break;
 	}
 
diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index 44281f7..28ad164 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -405,16 +405,12 @@ static int nft_data_parse_cb(const struct nlattr *attr, void *data)
 
 	switch(type) {
 	case NFTA_DATA_VALUE:
-		if (mnl_attr_validate(attr, MNL_TYPE_BINARY) < 0) {
-			perror("mnl_attr_validate");
-			return MNL_CB_ERROR;
-		}
+		if (mnl_attr_validate(attr, MNL_TYPE_BINARY) < 0)
+			abi_breakage();
 		break;
 	case NFTA_DATA_VERDICT:
-		if (mnl_attr_validate(attr, MNL_TYPE_NESTED) < 0) {
-			perror("mnl_attr_validate");
-			return MNL_CB_ERROR;
-		}
+		if (mnl_attr_validate(attr, MNL_TYPE_NESTED) < 0)
+			abi_breakage();
 		break;
 	}
 	tb[type] = attr;
@@ -431,16 +427,12 @@ static int nft_verdict_parse_cb(const struct nlattr *attr, void *data)
 
 	switch(type) {
 	case NFTA_VERDICT_CODE:
-		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0) {
-			perror("mnl_attr_validate");
-			return MNL_CB_ERROR;
-		}
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+			abi_breakage();
 		break;
 	case NFTA_VERDICT_CHAIN:
-		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0) {
-			perror("mnl_attr_validate");
-			return MNL_CB_ERROR;
-		}
+		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
+			abi_breakage();
 		break;
 	}
 	tb[type] = attr;
diff --git a/src/expr/exthdr.c b/src/expr/exthdr.c
index e237c73..369727c 100644
--- a/src/expr/exthdr.c
+++ b/src/expr/exthdr.c
@@ -95,18 +95,14 @@ static int nft_rule_expr_exthdr_cb(const struct nlattr *attr, void *data)
 
 	switch(type) {
 	case NFTA_EXTHDR_TYPE:
-		if (mnl_attr_validate(attr, MNL_TYPE_U8) < 0) {
-			perror("mnl_attr_validate");
-			return MNL_CB_ERROR;
-		}
+		if (mnl_attr_validate(attr, MNL_TYPE_U8) < 0)
+			abi_breakage();
 		break;
 	case NFTA_EXTHDR_DREG:
 	case NFTA_EXTHDR_OFFSET:
 	case NFTA_EXTHDR_LEN:
-		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0) {
-			perror("mnl_attr_validate");
-			return MNL_CB_ERROR;
-		}
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+			abi_breakage();
 		break;
 	}
 
diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index 385ee61..5f54129 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -89,16 +89,12 @@ static int nft_rule_expr_immediate_cb(const struct nlattr *attr, void *data)
 
 	switch(type) {
 	case NFTA_IMMEDIATE_DREG:
-		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0) {
-			perror("mnl_attr_validate");
-			return MNL_CB_ERROR;
-		}
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+			abi_breakage();
 		break;
 	case NFTA_IMMEDIATE_DATA:
-		if (mnl_attr_validate(attr, MNL_TYPE_BINARY) < 0) {
-			perror("mnl_attr_validate");
-			return MNL_CB_ERROR;
-		}
+		if (mnl_attr_validate(attr, MNL_TYPE_BINARY) < 0)
+			abi_breakage();
 		break;
 	}
 
diff --git a/src/expr/limit.c b/src/expr/limit.c
index c706a72..68cfa37 100644
--- a/src/expr/limit.c
+++ b/src/expr/limit.c
@@ -75,10 +75,8 @@ static int nft_rule_expr_limit_cb(const struct nlattr *attr, void *data)
 	switch(type) {
 	case NFTA_LIMIT_RATE:
 	case NFTA_LIMIT_UNIT:
-		if (mnl_attr_validate(attr, MNL_TYPE_U64) < 0) {
-			perror("mnl_attr_validate");
-			return MNL_CB_ERROR;
-		}
+		if (mnl_attr_validate(attr, MNL_TYPE_U64) < 0)
+			abi_breakage();
 		break;
 	}
 
diff --git a/src/expr/log.c b/src/expr/log.c
index bc70eca..98481c9 100644
--- a/src/expr/log.c
+++ b/src/expr/log.c
@@ -103,25 +103,19 @@ static int nft_rule_expr_log_cb(const struct nlattr *attr, void *data)
 
 	switch(type) {
 	case NFTA_LOG_PREFIX:
-		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0) {
-			perror("mnl_attr_validate");
-			return MNL_CB_ERROR;
-		}
+		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
+			abi_breakage();
 		break;
 	case NFTA_LOG_GROUP:
 	case NFTA_LOG_QTHRESHOLD:
-		if (mnl_attr_validate(attr, MNL_TYPE_U16) < 0) {
-			perror("mnl_attr_validate");
-			return MNL_CB_ERROR;
-		}
+		if (mnl_attr_validate(attr, MNL_TYPE_U16) < 0)
+			abi_breakage();
 		break;
 	case NFTA_LOG_SNAPLEN:
 	case NFTA_LOG_LEVEL:
 	case NFTA_LOG_FLAGS:
-		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0) {
-			perror("mnl_attr_validate");
-			return MNL_CB_ERROR;
-		}
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+			abi_breakage();
 		break;
 	}
 
diff --git a/src/expr/lookup.c b/src/expr/lookup.c
index 3f77228..625bc58 100644
--- a/src/expr/lookup.c
+++ b/src/expr/lookup.c
@@ -93,16 +93,12 @@ static int nft_rule_expr_lookup_cb(const struct nlattr *attr, void *data)
 	case NFTA_LOOKUP_SREG:
 	case NFTA_LOOKUP_DREG:
 	case NFTA_LOOKUP_SET_ID:
-		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0) {
-			perror("mnl_attr_validate");
-			return MNL_CB_ERROR;
-		}
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+			abi_breakage();
 		break;
 	case NFTA_LOOKUP_SET:
-		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0) {
-			perror("mnl_attr_validate");
-			return MNL_CB_ERROR;
-		}
+		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
+			abi_breakage();
 		break;
 	}
 
diff --git a/src/expr/match.c b/src/expr/match.c
index 2c4b3dc..378d5dd 100644
--- a/src/expr/match.c
+++ b/src/expr/match.c
@@ -91,22 +91,16 @@ static int nft_rule_expr_match_cb(const struct nlattr *attr, void *data)
 
 	switch(type) {
 	case NFTA_MATCH_NAME:
-		if (mnl_attr_validate(attr, MNL_TYPE_NUL_STRING) < 0) {
-			perror("mnl_attr_validate");
-			return MNL_CB_ERROR;
-		}
+		if (mnl_attr_validate(attr, MNL_TYPE_NUL_STRING) < 0)
+			abi_breakage();
 		break;
 	case NFTA_MATCH_REV:
-		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0) {
-			perror("mnl_attr_validate");
-			return MNL_CB_ERROR;
-		}
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+			abi_breakage();
 		break;
 	case NFTA_MATCH_INFO:
-		if (mnl_attr_validate(attr, MNL_TYPE_BINARY) < 0) {
-			perror("mnl_attr_validate");
-			return MNL_CB_ERROR;
-		}
+		if (mnl_attr_validate(attr, MNL_TYPE_BINARY) < 0)
+			abi_breakage();
 		break;
 	}
 
diff --git a/src/expr/meta.c b/src/expr/meta.c
index f19b55a..85097b5 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -86,10 +86,8 @@ static int nft_rule_expr_meta_cb(const struct nlattr *attr, void *data)
 	case NFTA_META_KEY:
 	case NFTA_META_DREG:
 	case NFTA_META_SREG:
-		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0) {
-			perror("mnl_attr_validate");
-			return MNL_CB_ERROR;
-		}
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+			abi_breakage();
 		break;
 	}
 
diff --git a/src/expr/nat.c b/src/expr/nat.c
index c719b6c..a7b9023 100644
--- a/src/expr/nat.c
+++ b/src/expr/nat.c
@@ -109,10 +109,8 @@ static int nft_rule_expr_nat_cb(const struct nlattr *attr, void *data)
 	case NFTA_NAT_REG_ADDR_MAX:
 	case NFTA_NAT_REG_PROTO_MIN:
 	case NFTA_NAT_REG_PROTO_MAX:
-		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0) {
-			perror("mnl_attr_validate");
-			return MNL_CB_ERROR;
-		}
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+			abi_breakage();
 		break;
 	}
 
diff --git a/src/expr/payload.c b/src/expr/payload.c
index 95c9d9c..717cdac 100644
--- a/src/expr/payload.c
+++ b/src/expr/payload.c
@@ -94,10 +94,8 @@ static int nft_rule_expr_payload_cb(const struct nlattr *attr, void *data)
 	case NFTA_PAYLOAD_BASE:
 	case NFTA_PAYLOAD_OFFSET:
 	case NFTA_PAYLOAD_LEN:
-		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0) {
-			perror("mnl_attr_validate");
-			return MNL_CB_ERROR;
-		}
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+			abi_breakage();
 		break;
 	}
 
diff --git a/src/expr/queue.c b/src/expr/queue.c
index f366ad1..64eb3cb 100644
--- a/src/expr/queue.c
+++ b/src/expr/queue.c
@@ -80,10 +80,8 @@ static int nft_rule_expr_queue_cb(const struct nlattr *attr, void *data)
 	case NFTA_QUEUE_NUM:
 	case NFTA_QUEUE_TOTAL:
 	case NFTA_QUEUE_FLAGS:
-		if (mnl_attr_validate(attr, MNL_TYPE_U16) < 0) {
-			perror("mnl_attr_validate");
-			return MNL_CB_ERROR;
-		}
+		if (mnl_attr_validate(attr, MNL_TYPE_U16) < 0)
+			abi_breakage();
 		break;
 	}
 
diff --git a/src/expr/reject.c b/src/expr/reject.c
index 2a1285b..fb88cf5 100644
--- a/src/expr/reject.c
+++ b/src/expr/reject.c
@@ -72,16 +72,12 @@ static int nft_rule_expr_reject_cb(const struct nlattr *attr, void *data)
 
 	switch(type) {
 	case NFTA_REJECT_TYPE:
-		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0) {
-			perror("mnl_attr_validate");
-			return MNL_CB_ERROR;
-		}
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+			abi_breakage();
 		break;
 	case NFTA_REJECT_ICMP_CODE:
-		if (mnl_attr_validate(attr, MNL_TYPE_U8) < 0) {
-			perror("mnl_attr_validate");
-			return MNL_CB_ERROR;
-		}
+		if (mnl_attr_validate(attr, MNL_TYPE_U8) < 0)
+			abi_breakage();
 		break;
 	}
 
diff --git a/src/expr/target.c b/src/expr/target.c
index 7ebeda6..b3966a6 100644
--- a/src/expr/target.c
+++ b/src/expr/target.c
@@ -91,22 +91,16 @@ static int nft_rule_expr_target_cb(const struct nlattr *attr, void *data)
 
 	switch(type) {
 	case NFTA_TARGET_NAME:
-		if (mnl_attr_validate(attr, MNL_TYPE_NUL_STRING) < 0) {
-			perror("mnl_attr_validate");
-			return MNL_CB_ERROR;
-		}
+		if (mnl_attr_validate(attr, MNL_TYPE_NUL_STRING) < 0)
+			abi_breakage();
 		break;
 	case NFTA_TARGET_REV:
-		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0) {
-			perror("mnl_attr_validate");
-			return MNL_CB_ERROR;
-		}
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+			abi_breakage();
 		break;
 	case NFTA_TARGET_INFO:
-		if (mnl_attr_validate(attr, MNL_TYPE_BINARY) < 0) {
-			perror("mnl_attr_validate");
-			return MNL_CB_ERROR;
-		}
+		if (mnl_attr_validate(attr, MNL_TYPE_BINARY) < 0)
+			abi_breakage();
 		break;
 	}
 
diff --git a/src/internal.h b/src/internal.h
index b8ed616..7b848db 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -211,4 +211,13 @@ void __nft_assert_fail(uint16_t attr, const char *filename, int line);
 		nft_assert(data, attr, _validate_array[_attr] == _data_len);	\
 })
 
+#define __noreturn	__attribute__((__noreturn__))
+
+void __noreturn __abi_breakage(const char *file, int line, const char *reason);
+
+#include <string.h>
+
+#define abi_breakage()	\
+	__abi_breakage(__FILE__, __LINE__, strerror(errno));
+
 #endif
diff --git a/src/rule.c b/src/rule.c
index 88e9f71..ec5f9a8 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -332,34 +332,24 @@ static int nft_rule_parse_attr_cb(const struct nlattr *attr, void *data)
 	switch(type) {
 	case NFTA_RULE_TABLE:
 	case NFTA_RULE_CHAIN:
-		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0) {
-			perror("mnl_attr_validate");
-			return MNL_CB_ERROR;
-		}
+		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
+			abi_breakage();
 		break;
 	case NFTA_RULE_HANDLE:
-		if (mnl_attr_validate(attr, MNL_TYPE_U64) < 0) {
-			perror("mnl_attr_validate");
-			return MNL_CB_ERROR;
-		}
+		if (mnl_attr_validate(attr, MNL_TYPE_U64) < 0)
+			abi_breakage();
 		break;
 	case NFTA_RULE_COMPAT:
-		if (mnl_attr_validate(attr, MNL_TYPE_NESTED) < 0) {
-			perror("mnl_attr_validate");
-			return MNL_CB_ERROR;
-		}
+		if (mnl_attr_validate(attr, MNL_TYPE_NESTED) < 0)
+			abi_breakage();
 		break;
 	case NFTA_RULE_POSITION:
-		if (mnl_attr_validate(attr, MNL_TYPE_U64) < 0) {
-			perror("mnl_attr_validate");
-			return MNL_CB_ERROR;
-		}
+		if (mnl_attr_validate(attr, MNL_TYPE_U64) < 0)
+			abi_breakage();
 		break;
 	case NFTA_RULE_USERDATA:
-		if (mnl_attr_validate(attr, MNL_TYPE_BINARY) < 0) {
-			perror("mnl_attr_validate");
-			return MNL_CB_ERROR;
-		}
+		if (mnl_attr_validate(attr, MNL_TYPE_BINARY) < 0)
+			abi_breakage();
 		break;
 	}
 
@@ -377,16 +367,12 @@ static int nft_rule_parse_expr_cb(const struct nlattr *attr, void *data)
 
 	switch(type) {
 	case NFTA_EXPR_NAME:
-		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0) {
-			perror("mnl_attr_validate");
-			return MNL_CB_ERROR;
-		}
+		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
+			abi_breakage();
 		break;
 	case NFTA_EXPR_DATA:
-		if (mnl_attr_validate(attr, MNL_TYPE_NESTED) < 0) {
-			perror("mnl_attr_validate");
-			return MNL_CB_ERROR;
-		}
+		if (mnl_attr_validate(attr, MNL_TYPE_NESTED) < 0)
+			abi_breakage();
 		break;
 	}
 
@@ -441,10 +427,8 @@ static int nft_rule_parse_compat_cb(const struct nlattr *attr, void *data)
 	switch(type) {
 	case NFTA_RULE_COMPAT_PROTO:
 	case NFTA_RULE_COMPAT_FLAGS:
-		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0) {
-			perror("mnl_attr_validate");
-			return MNL_CB_ERROR;
-		}
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+			abi_breakage();
 		break;
 	}
 
diff --git a/src/set.c b/src/set.c
index a1e195b..ee7f983 100644
--- a/src/set.c
+++ b/src/set.c
@@ -265,10 +265,8 @@ static int nft_set_parse_attr_cb(const struct nlattr *attr, void *data)
 	switch(type) {
 	case NFTA_SET_TABLE:
 	case NFTA_SET_NAME:
-		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0) {
-			perror("mnl_attr_validate");
-			return MNL_CB_ERROR;
-		}
+		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
+			abi_breakage();
 		break;
 	case NFTA_SET_FLAGS:
 	case NFTA_SET_KEY_TYPE:
@@ -276,10 +274,8 @@ static int nft_set_parse_attr_cb(const struct nlattr *attr, void *data)
 	case NFTA_SET_DATA_TYPE:
 	case NFTA_SET_DATA_LEN:
 	case NFTA_SET_ID:
-		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0) {
-			perror("mnl_attr_validate");
-			return MNL_CB_ERROR;
-		}
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+			abi_breakage();
 		break;
 	}
 
diff --git a/src/set_elem.c b/src/set_elem.c
index 3b27317..197da73 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -232,17 +232,13 @@ static int nft_set_elem_parse_attr_cb(const struct nlattr *attr, void *data)
 
 	switch(type) {
 	case NFTA_SET_ELEM_FLAGS:
-		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0) {
-			perror("mnl_attr_validate");
-			return MNL_CB_ERROR;
-		}
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+			abi_breakage();
 		break;
 	case NFTA_SET_ELEM_KEY:
 	case NFTA_SET_ELEM_DATA:
-		if (mnl_attr_validate(attr, MNL_TYPE_NESTED) < 0) {
-			perror("mnl_attr_validate");
-			return MNL_CB_ERROR;
-		}
+		if (mnl_attr_validate(attr, MNL_TYPE_NESTED) < 0)
+			abi_breakage();
 		break;
 	}
 
@@ -312,16 +308,12 @@ nft_set_elem_list_parse_attr_cb(const struct nlattr *attr, void *data)
 	switch(type) {
 	case NFTA_SET_ELEM_LIST_TABLE:
 	case NFTA_SET_ELEM_LIST_SET:
-		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0) {
-			perror("mnl_attr_validate");
-			return MNL_CB_ERROR;
-		}
+		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
+			abi_breakage();
 		break;
 	case NFTA_SET_ELEM_LIST_ELEMENTS:
-		if (mnl_attr_validate(attr, MNL_TYPE_NESTED) < 0) {
-			perror("mnl_attr_validate");
-			return MNL_CB_ERROR;
-		}
+		if (mnl_attr_validate(attr, MNL_TYPE_NESTED) < 0)
+			abi_breakage();
 		break;
 	}
 
diff --git a/src/table.c b/src/table.c
index abbaa52..53f6a4d 100644
--- a/src/table.c
+++ b/src/table.c
@@ -205,22 +205,13 @@ static int nft_table_parse_attr_cb(const struct nlattr *attr, void *data)
 
 	switch(type) {
 	case NFTA_TABLE_NAME:
-		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0) {
-			perror("mnl_attr_validate");
-			return MNL_CB_ERROR;
-		}
+		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
+			abi_breakage();
 		break;
 	case NFTA_TABLE_FLAGS:
-		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0) {
-			perror("mnl_attr_validate");
-			return MNL_CB_ERROR;
-		}
-		break;
 	case NFTA_TABLE_USE:
-		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0) {
-			perror("mnl_attr_validate");
-			return MNL_CB_ERROR;
-		}
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+			abi_breakage();
 		break;
 	}
 
diff --git a/src/utils.c b/src/utils.c
index 20a2fa3..1878390 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -225,3 +225,10 @@ void __nft_assert_fail(uint16_t attr, const char *filename, int line)
 		attr, filename, line);
 	exit(EXIT_FAILURE);
 }
+
+void __noreturn __abi_breakage(const char *file, int line, const char *reason)
+{
+       fprintf(stderr, "nf_tables kernel ABI is broken, contact your vendor.\n"
+		       "%s:%d reason: %s\n", file, line, reason);
+       exit(EXIT_FAILURE);
+}
-- 
1.7.10.4

