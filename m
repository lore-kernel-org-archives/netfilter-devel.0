From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl] src: restore static array with expression operations
Date: Mon, 23 Mar 2015 12:44:12 +0100
Message-ID: <1427111052-5510-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, ska-devel@skarnet.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35568 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137AbbCWLk1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Mar 2015 07:40:27 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We cannot use __attribute__((constructor)) to register the supported
expressions in runtime when the library is statically linked. This lead
us to some explicit libnftnl_init() function that needs to be called
from the main() function of the client program.

This patch reverts 4dd0772 ("expr: use __attribute__((constructor)) to
register expression").

Reported-by: Laurent Bercot <ska-devel@skarnet.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/expr_ops.h   |    3 ---
 include/utils.h      |    1 -
 src/expr/bitwise.c   |    5 -----
 src/expr/byteorder.c |    5 -----
 src/expr/cmp.c       |    4 ----
 src/expr/counter.c   |    5 -----
 src/expr/ct.c        |    5 -----
 src/expr/exthdr.c    |    5 -----
 src/expr/immediate.c |    5 -----
 src/expr/limit.c     |    5 -----
 src/expr/log.c       |    5 -----
 src/expr/lookup.c    |    5 -----
 src/expr/masq.c      |    5 -----
 src/expr/match.c     |    5 -----
 src/expr/meta.c      |    5 -----
 src/expr/nat.c       |    5 -----
 src/expr/payload.c   |    5 -----
 src/expr/queue.c     |    5 -----
 src/expr/redir.c     |    5 -----
 src/expr/reject.c    |    5 -----
 src/expr/target.c    |    5 -----
 src/expr_ops.c       |   58 +++++++++++++++++++++++++++++++++++++++++---------
 22 files changed, 48 insertions(+), 108 deletions(-)

diff --git a/include/expr_ops.h b/include/expr_ops.h
index ea5defd..08cf57f 100644
--- a/include/expr_ops.h
+++ b/include/expr_ops.h
@@ -9,8 +9,6 @@ struct nlmsghdr;
 struct nft_rule_expr;
 
 struct expr_ops {
-	struct list_head head;
-
 	const char *name;
 	uint32_t alloc_len;
 	int	max_attr;
@@ -26,7 +24,6 @@ struct expr_ops {
 			      struct nft_parse_err *err);
 };
 
-void nft_expr_ops_register(struct expr_ops *ops);
 struct expr_ops *nft_expr_ops_lookup(const char *name);
 
 #define nft_expr_data(ops) (void *)ops->data
diff --git a/include/utils.h b/include/utils.h
index 1801108..380b020 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -15,7 +15,6 @@
 #	define EXPORT_SYMBOL
 #endif
 
-#define __init		__attribute__((constructor))
 #define __noreturn	__attribute__((__noreturn__))
 
 #define xfree(ptr)	free((void *)ptr);
diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index 3c4a2e4..f0851b0 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -322,8 +322,3 @@ struct expr_ops expr_ops_bitwise = {
 	.xml_parse	= nft_rule_expr_bitwise_xml_parse,
 	.json_parse	= nft_rule_expr_bitwise_json_parse,
 };
-
-static void __init expr_bitwise(void)
-{
-	nft_expr_ops_register(&expr_ops_bitwise);
-}
diff --git a/src/expr/byteorder.c b/src/expr/byteorder.c
index a16b145..81e5278 100644
--- a/src/expr/byteorder.c
+++ b/src/expr/byteorder.c
@@ -338,8 +338,3 @@ struct expr_ops expr_ops_byteorder = {
 	.xml_parse	= nft_rule_expr_byteorder_xml_parse,
 	.json_parse	= nft_rule_expr_byteorder_json_parse,
 };
-
-static void __init expr_byteorder_init(void)
-{
-	nft_expr_ops_register(&expr_ops_byteorder);
-}
diff --git a/src/expr/cmp.c b/src/expr/cmp.c
index ea51b83..3536332 100644
--- a/src/expr/cmp.c
+++ b/src/expr/cmp.c
@@ -305,7 +305,3 @@ struct expr_ops expr_ops_cmp = {
 	.xml_parse	= nft_rule_expr_cmp_xml_parse,
 	.json_parse	= nft_rule_expr_cmp_json_parse,
 };
-static void __init expr_cmp_init(void)
-{
-	nft_expr_ops_register(&expr_ops_cmp);
-}
diff --git a/src/expr/counter.c b/src/expr/counter.c
index a190863..55fe526 100644
--- a/src/expr/counter.c
+++ b/src/expr/counter.c
@@ -210,8 +210,3 @@ struct expr_ops expr_ops_counter = {
 	.xml_parse	= nft_rule_expr_counter_xml_parse,
 	.json_parse	= nft_rule_expr_counter_json_parse,
 };
-
-static void __init expr_counter_init(void)
-{
-	nft_expr_ops_register(&expr_ops_counter);
-}
diff --git a/src/expr/ct.c b/src/expr/ct.c
index c15bf42..b808e03 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -381,8 +381,3 @@ struct expr_ops expr_ops_ct = {
 	.xml_parse	= nft_rule_expr_ct_xml_parse,
 	.json_parse	= nft_rule_expr_ct_json_parse,
 };
-
-static void __init expr_ct_init(void)
-{
-	nft_expr_ops_register(&expr_ops_ct);
-}
diff --git a/src/expr/exthdr.c b/src/expr/exthdr.c
index 615fec6..a2541b4 100644
--- a/src/expr/exthdr.c
+++ b/src/expr/exthdr.c
@@ -316,8 +316,3 @@ struct expr_ops expr_ops_exthdr = {
 	.xml_parse	= nft_rule_expr_exthdr_xml_parse,
 	.json_parse	= nft_rule_expr_exthdr_json_parse,
 };
-
-static void __init expr_exthdr_init(void)
-{
-	nft_expr_ops_register(&expr_ops_exthdr);
-}
diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index b6cde0a..692d9e9 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -321,8 +321,3 @@ struct expr_ops expr_ops_immediate = {
 	.xml_parse	= nft_rule_expr_immediate_xml_parse,
 	.json_parse	= nft_rule_expr_immediate_json_parse,
 };
-
-static void __init expr_immediate_init(void)
-{
-	nft_expr_ops_register(&expr_ops_immediate);
-}
diff --git a/src/expr/limit.c b/src/expr/limit.c
index f9331b3..3ad246e 100644
--- a/src/expr/limit.c
+++ b/src/expr/limit.c
@@ -220,8 +220,3 @@ struct expr_ops expr_ops_limit = {
 	.xml_parse	= nft_rule_expr_limit_xml_parse,
 	.json_parse	= nft_rule_expr_limit_json_parse,
 };
-
-static void __init expr_limit_init(void)
-{
-	nft_expr_ops_register(&expr_ops_limit);
-}
diff --git a/src/expr/log.c b/src/expr/log.c
index 776c7fc..19bef56 100644
--- a/src/expr/log.c
+++ b/src/expr/log.c
@@ -345,8 +345,3 @@ struct expr_ops expr_ops_log = {
 	.xml_parse	= nft_rule_expr_log_xml_parse,
 	.json_parse	= nft_rule_expr_log_json_parse,
 };
-
-static void __init expr_log_init(void)
-{
-	nft_expr_ops_register(&expr_ops_log);
-}
diff --git a/src/expr/lookup.c b/src/expr/lookup.c
index 57eba1b..b2f0aa4 100644
--- a/src/expr/lookup.c
+++ b/src/expr/lookup.c
@@ -270,8 +270,3 @@ struct expr_ops expr_ops_lookup = {
 	.xml_parse	= nft_rule_expr_lookup_xml_parse,
 	.json_parse	= nft_rule_expr_lookup_json_parse,
 };
-
-static void __init expr_lookup_init(void)
-{
-	nft_expr_ops_register(&expr_ops_lookup);
-}
diff --git a/src/expr/masq.c b/src/expr/masq.c
index 79f5185..e25587f 100644
--- a/src/expr/masq.c
+++ b/src/expr/masq.c
@@ -184,8 +184,3 @@ struct expr_ops expr_ops_masq = {
 	.xml_parse	= nft_rule_expr_masq_xml_parse,
 	.json_parse	= nft_rule_expr_masq_json_parse,
 };
-
-static void __init expr_masq_init(void)
-{
-	nft_expr_ops_register(&expr_ops_masq);
-}
diff --git a/src/expr/match.c b/src/expr/match.c
index 45e7caf..e101c1f 100644
--- a/src/expr/match.c
+++ b/src/expr/match.c
@@ -253,8 +253,3 @@ struct expr_ops expr_ops_match = {
 	.xml_parse 	= nft_rule_expr_match_xml_parse,
 	.json_parse 	= nft_rule_expr_match_json_parse,
 };
-
-static void __init expr_match_init(void)
-{
-	nft_expr_ops_register(&expr_ops_match);
-}
diff --git a/src/expr/meta.c b/src/expr/meta.c
index 2f5cddc..cee09dd 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -307,8 +307,3 @@ struct expr_ops expr_ops_meta = {
 	.xml_parse 	= nft_rule_expr_meta_xml_parse,
 	.json_parse 	= nft_rule_expr_meta_json_parse,
 };
-
-static void __init expr_meta_init(void)
-{
-	nft_expr_ops_register(&expr_ops_meta);
-}
diff --git a/src/expr/nat.c b/src/expr/nat.c
index e36d023..f888dfa 100644
--- a/src/expr/nat.c
+++ b/src/expr/nat.c
@@ -416,8 +416,3 @@ struct expr_ops expr_ops_nat = {
 	.xml_parse	= nft_rule_expr_nat_xml_parse,
 	.json_parse	= nft_rule_expr_nat_json_parse,
 };
-
-static void __init expr_nat_init(void)
-{
-	nft_expr_ops_register(&expr_ops_nat);
-}
diff --git a/src/expr/payload.c b/src/expr/payload.c
index 61e88a9..52bea19 100644
--- a/src/expr/payload.c
+++ b/src/expr/payload.c
@@ -297,8 +297,3 @@ struct expr_ops expr_ops_payload = {
 	.xml_parse	= nft_rule_expr_payload_xml_parse,
 	.json_parse	= nft_rule_expr_payload_json_parse,
 };
-
-static void __init expr_payload_init(void)
-{
-	nft_expr_ops_register(&expr_ops_payload);
-}
diff --git a/src/expr/queue.c b/src/expr/queue.c
index dbae701..5e2a49e 100644
--- a/src/expr/queue.c
+++ b/src/expr/queue.c
@@ -255,8 +255,3 @@ struct expr_ops expr_ops_queue = {
 	.xml_parse	= nft_rule_expr_queue_xml_parse,
 	.json_parse	= nft_rule_expr_queue_json_parse,
 };
-
-static void __init expr_queue_init(void)
-{
-	nft_expr_ops_register(&expr_ops_queue);
-}
diff --git a/src/expr/redir.c b/src/expr/redir.c
index a1be181..b6adf88 100644
--- a/src/expr/redir.c
+++ b/src/expr/redir.c
@@ -254,8 +254,3 @@ struct expr_ops expr_ops_redir = {
 	.xml_parse	= nft_rule_expr_redir_xml_parse,
 	.json_parse	= nft_rule_expr_redir_json_parse,
 };
-
-static void __init expr_redir_init(void)
-{
-	nft_expr_ops_register(&expr_ops_redir);
-}
diff --git a/src/expr/reject.c b/src/expr/reject.c
index cd62cbe..a9c13d5 100644
--- a/src/expr/reject.c
+++ b/src/expr/reject.c
@@ -211,8 +211,3 @@ struct expr_ops expr_ops_reject = {
 	.xml_parse	= nft_rule_expr_reject_xml_parse,
 	.json_parse	= nft_rule_expr_reject_json_parse,
 };
-
-static void __init expr_reject_init(void)
-{
-	nft_expr_ops_register(&expr_ops_reject);
-}
diff --git a/src/expr/target.c b/src/expr/target.c
index 16e9e83..65c1ce0 100644
--- a/src/expr/target.c
+++ b/src/expr/target.c
@@ -254,8 +254,3 @@ struct expr_ops expr_ops_target = {
 	.xml_parse	= nft_rule_expr_target_xml_parse,
 	.json_parse	= nft_rule_expr_target_json_parse,
 };
-
-static void __init expr_target_init(void)
-{
-	nft_expr_ops_register(&expr_ops_target);
-}
diff --git a/src/expr_ops.c b/src/expr_ops.c
index d0315a3..9d8f3c9 100644
--- a/src/expr_ops.c
+++ b/src/expr_ops.c
@@ -3,21 +3,59 @@
 
 #include "expr_ops.h"
 
-static LIST_HEAD(expr_ops_list);
+/* Unfortunately, __attribute__((constructor)) breaks library static link */
+extern struct expr_ops expr_ops_bitwise;
+extern struct expr_ops expr_ops_byteorder;
+extern struct expr_ops expr_ops_cmp;
+extern struct expr_ops expr_ops_counter;
+extern struct expr_ops expr_ops_ct;
+extern struct expr_ops expr_ops_exthdr;
+extern struct expr_ops expr_ops_immediate;
+extern struct expr_ops expr_ops_limit;
+extern struct expr_ops expr_ops_log;
+extern struct expr_ops expr_ops_lookup;
+extern struct expr_ops expr_ops_masq;
+extern struct expr_ops expr_ops_match;
+extern struct expr_ops expr_ops_meta;
+extern struct expr_ops expr_ops_nat;
+extern struct expr_ops expr_ops_payload;
+extern struct expr_ops expr_ops_redir;
+extern struct expr_ops expr_ops_reject;
+extern struct expr_ops expr_ops_queue;
+extern struct expr_ops expr_ops_target;
 
-void nft_expr_ops_register(struct expr_ops *ops)
-{
-	list_add_tail(&ops->head, &expr_ops_list);
-}
+static struct expr_ops *expr_ops[] = {
+	&expr_ops_bitwise,
+	&expr_ops_byteorder,
+	&expr_ops_cmp,
+	&expr_ops_counter,
+	&expr_ops_ct,
+	&expr_ops_exthdr,
+	&expr_ops_immediate,
+	&expr_ops_limit,
+	&expr_ops_log,
+	&expr_ops_lookup,
+	&expr_ops_masq,
+	&expr_ops_match,
+	&expr_ops_meta,
+	&expr_ops_nat,
+	&expr_ops_payload,
+	&expr_ops_redir,
+	&expr_ops_reject,
+	&expr_ops_queue,
+	&expr_ops_target,
+	NULL,
+};
 
 struct expr_ops *nft_expr_ops_lookup(const char *name)
 {
-	struct expr_ops *ops;
+	int i = 0;
 
-	list_for_each_entry(ops, &expr_ops_list, head) {
-		if (strcmp(ops->name, name) == 0)
-			return ops;
-	}
+	while (expr_ops[i] != NULL) {
+		if (strcmp(expr_ops[i]->name, name) == 0)
+			return expr_ops[i];
 
+		i++;
+	}
 	return NULL;
 }
-- 
1.7.10.4

