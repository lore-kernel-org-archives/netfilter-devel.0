From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl 8/9] tests: shuffle values that are injected
Date: Tue, 14 Jun 2016 15:18:44 +0200
Message-ID: <1465910325-13286-8-git-send-email-pablo@netfilter.org>
References: <1465910325-13286-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55952 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393AbcFNNTD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Jun 2016 09:19:03 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 34371E7DC0
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jun 2016 15:19:02 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 1BC2C9EBA3
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jun 2016 15:19:02 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 53D779EBA0
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jun 2016 15:18:56 +0200 (CEST)
In-Reply-To: <1465910325-13286-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Shuffle value that are used to set attributes, this variability should
help us catch more problems in the future.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/nft-chain-test.c          | 10 +++++-----
 tests/nft-expr_bitwise-test.c   |  4 ++--
 tests/nft-expr_cmp-test.c       |  2 +-
 tests/nft-expr_counter-test.c   |  2 +-
 tests/nft-expr_ct-test.c        |  2 +-
 tests/nft-expr_exthdr-test.c    |  4 ++--
 tests/nft-expr_immediate-test.c | 10 +++++-----
 tests/nft-expr_limit-test.c     |  4 ++--
 tests/nft-expr_log-test.c       |  2 +-
 tests/nft-expr_lookup-test.c    |  2 +-
 tests/nft-expr_meta-test.c      |  2 +-
 tests/nft-expr_payload-test.c   |  6 +++---
 tests/nft-expr_queue-test.c     |  6 +++---
 tests/nft-expr_redir-test.c     |  6 +++---
 tests/nft-expr_reject-test.c    |  4 ++--
 tests/nft-expr_target-test.c    |  2 +-
 16 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/tests/nft-chain-test.c b/tests/nft-chain-test.c
index 3f5c5a5..d678d46 100644
--- a/tests/nft-chain-test.c
+++ b/tests/nft-chain-test.c
@@ -79,12 +79,12 @@ int main(int argc, char *argv[])
 	nftnl_chain_set_u32(a, NFTNL_CHAIN_FAMILY, AF_INET);
 	nftnl_chain_set_str(a, NFTNL_CHAIN_TABLE, "Table");
 	nftnl_chain_set_u32(a, NFTNL_CHAIN_POLICY,0x12345678);
-	nftnl_chain_set_u32(a, NFTNL_CHAIN_HOOKNUM, 0x12345678);
-	nftnl_chain_set_s32(a, NFTNL_CHAIN_PRIO, 0x12345678);
-	nftnl_chain_set_u32(a, NFTNL_CHAIN_USE, 0x12345678 );
+	nftnl_chain_set_u32(a, NFTNL_CHAIN_HOOKNUM, 0x34567812);
+	nftnl_chain_set_s32(a, NFTNL_CHAIN_PRIO, 0x56781234);
+	nftnl_chain_set_u32(a, NFTNL_CHAIN_USE, 0x78123456);
 	nftnl_chain_set_u64(a, NFTNL_CHAIN_PACKETS, 0x1234567812345678);
-	nftnl_chain_set_u64(a, NFTNL_CHAIN_BYTES, 0x1234567812345678);
-	nftnl_chain_set_u64(a, NFTNL_CHAIN_HANDLE, 0x1234567812345678);
+	nftnl_chain_set_u64(a, NFTNL_CHAIN_BYTES, 0x7812345678123456);
+	nftnl_chain_set_u64(a, NFTNL_CHAIN_HANDLE, 0x5678123456781234);
 	nftnl_chain_set_str(a, NFTNL_CHAIN_TYPE, "Prueba");
 	nftnl_chain_set_str(a, NFTNL_CHAIN_DEV, "eth0");
 
diff --git a/tests/nft-expr_bitwise-test.c b/tests/nft-expr_bitwise-test.c
index 4b59751..64c1446 100644
--- a/tests/nft-expr_bitwise-test.c
+++ b/tests/nft-expr_bitwise-test.c
@@ -72,8 +72,8 @@ int main(int argc, char *argv[])
 		print_err("OOM");
 
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_SREG, 0x12345678);
-	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_DREG, 0x12345678);
-	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_LEN, 0x12345678);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_DREG, 0x78123456);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_LEN, 0x56781234);
 	nftnl_expr_set(ex, NFTNL_EXPR_BITWISE_MASK, &mask, sizeof(mask));
 	nftnl_expr_set(ex, NFTNL_EXPR_BITWISE_XOR, &xor, sizeof(xor));
 
diff --git a/tests/nft-expr_cmp-test.c b/tests/nft-expr_cmp-test.c
index 23292c9..ec00bb9 100644
--- a/tests/nft-expr_cmp-test.c
+++ b/tests/nft-expr_cmp-test.c
@@ -64,7 +64,7 @@ int main(int argc, char *argv[])
 
 	nftnl_expr_set(ex, NFTNL_EXPR_CMP_DATA, &data_len, sizeof(data_len));
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_CMP_SREG, 0x12345678);
-	nftnl_expr_set_u32(ex, NFTNL_EXPR_CMP_OP, 0x12345678);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_CMP_OP, 0x78123456);
 
 	nftnl_rule_add_expr(a, ex);
 
diff --git a/tests/nft-expr_counter-test.c b/tests/nft-expr_counter-test.c
index d515952..519bc1f 100644
--- a/tests/nft-expr_counter-test.c
+++ b/tests/nft-expr_counter-test.c
@@ -57,7 +57,7 @@ int main(int argc, char *argv[])
 		print_err("OOM");
 
 	nftnl_expr_set_u64(ex, NFTNL_EXPR_CTR_BYTES, 0x123456789abcdef0);
-	nftnl_expr_set_u64(ex, NFTNL_EXPR_CTR_PACKETS, 0x123456789abcdef0);
+	nftnl_expr_set_u64(ex, NFTNL_EXPR_CTR_PACKETS, 0xf0123456789abcde);
 	nftnl_rule_add_expr(a, ex);
 
 	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
diff --git a/tests/nft-expr_ct-test.c b/tests/nft-expr_ct-test.c
index af69587..e98fbab 100644
--- a/tests/nft-expr_ct-test.c
+++ b/tests/nft-expr_ct-test.c
@@ -58,7 +58,7 @@ int main(int argc, char *argv[])
 
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_CT_KEY, 0x1234568);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_CT_DIR, 0x12);
-	nftnl_expr_set_u32(ex, NFTNL_EXPR_CT_DREG, 0x12345678);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_CT_DREG, 0x78123456);
 
 	nftnl_rule_add_expr(a, ex);
 
diff --git a/tests/nft-expr_exthdr-test.c b/tests/nft-expr_exthdr-test.c
index 622015c..fef2dd0 100644
--- a/tests/nft-expr_exthdr-test.c
+++ b/tests/nft-expr_exthdr-test.c
@@ -63,8 +63,8 @@ int main(int argc, char *argv[])
 
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_EXTHDR_DREG, 0x12345678);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_EXTHDR_TYPE, 0x12);
-	nftnl_expr_set_u32(ex, NFTNL_EXPR_EXTHDR_OFFSET, 0x12345678);
-	nftnl_expr_set_u32(ex, NFTNL_EXPR_EXTHDR_LEN, 0x12345678);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_EXTHDR_OFFSET, 0x78123456);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_EXTHDR_LEN, 0x56781234);
 
 	nftnl_rule_add_expr(a, ex);
 
diff --git a/tests/nft-expr_immediate-test.c b/tests/nft-expr_immediate-test.c
index abde2e1..695e0b0 100644
--- a/tests/nft-expr_immediate-test.c
+++ b/tests/nft-expr_immediate-test.c
@@ -56,8 +56,8 @@ int main(int argc, char *argv[])
 	char buf[4096];
 	struct nftnl_expr_iter *iter_a, *iter_b;
 	struct nftnl_expr *rule_a, *rule_b;
-	uint32_t chain_t = 0x12345678;
-	uint32_t data_t = 0x12345678;
+	uint32_t chain = 0x12345678;
+	uint32_t data = 0x56781234;
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
@@ -68,9 +68,9 @@ int main(int argc, char *argv[])
 		print_err("OOM");
 
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_IMM_DREG, 0x1234568);
-	nftnl_expr_set(ex, NFTNL_EXPR_IMM_DATA, &chain_t, sizeof(chain_t));
-	nftnl_expr_set_u32(ex, NFTNL_EXPR_IMM_VERDICT, 0x12345678);
-	nftnl_expr_set(ex, NFTNL_EXPR_IMM_CHAIN, &data_t, sizeof(data_t));
+	nftnl_expr_set(ex, NFTNL_EXPR_IMM_DATA, &data, sizeof(data));
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_IMM_VERDICT, 0x78123456);
+	nftnl_expr_set(ex, NFTNL_EXPR_IMM_CHAIN, &chain, sizeof(chain));
 
 	nftnl_rule_add_expr(a, ex);
 
diff --git a/tests/nft-expr_limit-test.c b/tests/nft-expr_limit-test.c
index 29fb489..2838941 100644
--- a/tests/nft-expr_limit-test.c
+++ b/tests/nft-expr_limit-test.c
@@ -66,10 +66,10 @@ int main(int argc, char *argv[])
 		print_err("OOM");
 
 	nftnl_expr_set_u64(ex, NFTNL_EXPR_LIMIT_RATE, 0x123456789abcdef0);
-	nftnl_expr_set_u64(ex, NFTNL_EXPR_LIMIT_UNIT, 0x123456789abcdef0);
+	nftnl_expr_set_u64(ex, NFTNL_EXPR_LIMIT_UNIT, 0xf0123456789abcde);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_LIMIT_BURST, 0x89123456);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_LIMIT_TYPE, 0xdef01234);
-	nftnl_expr_set_u32(ex, NFTNL_EXPR_LIMIT_FLAGS, 0xdef01234);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_LIMIT_FLAGS, 0x34def012);
 
 	nftnl_rule_add_expr(a, ex);
 
diff --git a/tests/nft-expr_log-test.c b/tests/nft-expr_log-test.c
index 3815778..b7aa302 100644
--- a/tests/nft-expr_log-test.c
+++ b/tests/nft-expr_log-test.c
@@ -63,7 +63,7 @@ int main(int argc, char *argv[])
 
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_LOG_SNAPLEN, 0x12345678);
 	nftnl_expr_set_u16(ex, NFTNL_EXPR_LOG_GROUP, 0x1234);
-	nftnl_expr_set_u16(ex, NFTNL_EXPR_LOG_QTHRESHOLD, 0x1234);
+	nftnl_expr_set_u16(ex, NFTNL_EXPR_LOG_QTHRESHOLD, 0x3412);
 	nftnl_expr_set_str(ex, NFTNL_EXPR_LOG_PREFIX, "test");
 
 	nftnl_rule_add_expr(a, ex);
diff --git a/tests/nft-expr_lookup-test.c b/tests/nft-expr_lookup-test.c
index ad028e9..83fa829 100644
--- a/tests/nft-expr_lookup-test.c
+++ b/tests/nft-expr_lookup-test.c
@@ -63,7 +63,7 @@ int main(int argc, char *argv[])
 		print_err("OOM");
 
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_LOOKUP_SREG, 0x12345678);
-	nftnl_expr_set_u32(ex, NFTNL_EXPR_LOOKUP_DREG, 0x12345678);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_LOOKUP_DREG, 0x78123456);
 	nftnl_expr_set(ex, NFTNL_EXPR_LOOKUP_SET, &lookup_set,
 			  sizeof(lookup_set));
 
diff --git a/tests/nft-expr_meta-test.c b/tests/nft-expr_meta-test.c
index 82f8fcf..8fb7873 100644
--- a/tests/nft-expr_meta-test.c
+++ b/tests/nft-expr_meta-test.c
@@ -56,7 +56,7 @@ int main(int argc, char *argv[])
 		print_err("OOM");
 
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_META_KEY, 0x1234568);
-	nftnl_expr_set_u32(ex, NFTNL_EXPR_META_DREG, 0x12345678);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_META_DREG, 0x78123456);
 
 	nftnl_rule_add_expr(a, ex);
 
diff --git a/tests/nft-expr_payload-test.c b/tests/nft-expr_payload-test.c
index c652195..371372c 100644
--- a/tests/nft-expr_payload-test.c
+++ b/tests/nft-expr_payload-test.c
@@ -63,9 +63,9 @@ int main(int argc, char *argv[])
 		print_err("OOM");
 
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_PAYLOAD_DREG, 0x1234568);
-	nftnl_expr_set_u32(ex, NFTNL_EXPR_PAYLOAD_BASE, 0x12345678);
-	nftnl_expr_set_u32(ex, NFTNL_EXPR_PAYLOAD_OFFSET, 0x12345678);
-	nftnl_expr_set_u32(ex, NFTNL_EXPR_PAYLOAD_LEN, 0x12345678);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_PAYLOAD_BASE, 0x78123456);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_PAYLOAD_OFFSET, 0x56781234);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_PAYLOAD_LEN, 0x78561234);
 
 	nftnl_rule_add_expr(a, ex);
 
diff --git a/tests/nft-expr_queue-test.c b/tests/nft-expr_queue-test.c
index 654e13c..1cc39aa 100644
--- a/tests/nft-expr_queue-test.c
+++ b/tests/nft-expr_queue-test.c
@@ -58,9 +58,9 @@ int main(int argc, char *argv[])
 	if (ex == NULL)
 		print_err("OOM");
 
-	nftnl_expr_set_u16(ex, NFTNL_EXPR_QUEUE_NUM, 0x123);
-	nftnl_expr_set_u16(ex, NFTNL_EXPR_QUEUE_TOTAL, 0x2);
-	nftnl_expr_set_u16(ex, NFTNL_EXPR_QUEUE_FLAGS, 0x2);
+	nftnl_expr_set_u16(ex, NFTNL_EXPR_QUEUE_NUM, 0x01010);
+	nftnl_expr_set_u16(ex, NFTNL_EXPR_QUEUE_TOTAL, 0x1234);
+	nftnl_expr_set_u16(ex, NFTNL_EXPR_QUEUE_FLAGS, 0x4321);
 
 	nftnl_rule_add_expr(a, ex);
 
diff --git a/tests/nft-expr_redir-test.c b/tests/nft-expr_redir-test.c
index 978cac6..6c8caec 100644
--- a/tests/nft-expr_redir-test.c
+++ b/tests/nft-expr_redir-test.c
@@ -56,9 +56,9 @@ int main(int argc, char *argv[])
 	if (ex == NULL)
 		print_err("OOM");
 
-	nftnl_expr_set_u32(ex, NFTNL_EXPR_REDIR_REG_PROTO_MIN, 0x1234568);
-	nftnl_expr_set_u32(ex, NFTNL_EXPR_REDIR_REG_PROTO_MAX, 0x23456);
-	nftnl_expr_set_u32(ex, NFTNL_EXPR_REDIR_FLAGS, 0x1234568);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_REDIR_REG_PROTO_MIN, 0x12345678);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_REDIR_REG_PROTO_MAX, 0x56781234);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_REDIR_FLAGS, 0x12003400);
 
 	nftnl_rule_add_expr(a, ex);
 
diff --git a/tests/nft-expr_reject-test.c b/tests/nft-expr_reject-test.c
index 5fa4cda..d8189ea 100644
--- a/tests/nft-expr_reject-test.c
+++ b/tests/nft-expr_reject-test.c
@@ -56,8 +56,8 @@ int main(int argc, char *argv[])
 	if (ex == NULL)
 		print_err("OOM");
 
-	nftnl_expr_set_u32(ex, NFTNL_EXPR_REJECT_TYPE, 0x1234568);
-	nftnl_expr_set_u32(ex, NFTNL_EXPR_REJECT_CODE, 0x1234568);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_REJECT_TYPE, 0x12345678);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_REJECT_CODE, 0x45681234);
 
 	nftnl_rule_add_expr(a, ex);
 
diff --git a/tests/nft-expr_target-test.c b/tests/nft-expr_target-test.c
index 634fc0a..ba56b27 100644
--- a/tests/nft-expr_target-test.c
+++ b/tests/nft-expr_target-test.c
@@ -70,7 +70,7 @@ int main(int argc, char *argv[])
 		print_err("OOM");
 
 	nftnl_expr_set(ex, NFTNL_EXPR_TG_NAME, "test", strlen("test"));
-	nftnl_expr_set_u32(ex, NFTNL_EXPR_TG_REV, 0x12345678);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_TG_REV, 0x56781234);
 	nftnl_expr_set(ex, NFTNL_EXPR_TG_INFO, strdup(data), sizeof(data));
 	nftnl_rule_add_expr(a, ex);
 
-- 
2.1.4

