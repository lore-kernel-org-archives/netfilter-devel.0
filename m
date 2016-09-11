From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH libnftnl 3/3] expr: queue: add sreg_from and sreg_to support
Date: Sun, 11 Sep 2016 22:11:24 +0800
Message-ID: <1473603084-33964-4-git-send-email-zlpnobody@163.com>
References: <1473603084-33964-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-12.163.com ([220.181.12.12]:50880 "EHLO m12-12.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755728AbcIKOMb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 11 Sep 2016 10:12:31 -0400
In-Reply-To: <1473603084-33964-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

Add NFTA_QUEUE_SREG_FROM and NFTA_QUEUE_SREG_TO attributes support.

After adding _SREG_FROM attr, queuenum is not must option anymore,
so we must test NFTNL_EXPR_QUEUE_NUM first before dumpping queue num
in snprintf_default.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 include/buffer.h                    |  2 +
 include/libnftnl/expr.h             |  2 +
 include/linux/netfilter/nf_tables.h |  4 ++
 src/expr/queue.c                    | 84 +++++++++++++++++++++++++++++++++----
 tests/nft-expr_queue-test.c         |  8 ++++
 5 files changed, 93 insertions(+), 7 deletions(-)

diff --git a/include/buffer.h b/include/buffer.h
index a753c78..f8884cd 100644
--- a/include/buffer.h
+++ b/include/buffer.h
@@ -77,6 +77,8 @@ int nftnl_buf_reg(struct nftnl_buf *b, int type, union nftnl_data_reg *reg,
 #define SREG_PROTO_MIN		"sreg_proto_min"
 #define SREG_KEY		"sreg_key"
 #define SREG_DATA		"sreg_data"
+#define SREG_FROM		"sreg_from"
+#define SREG_TO			"sreg_to"
 #define SREG			"sreg"
 #define TABLE			"table"
 #define TOTAL			"total"
diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index 94ce529..8075d9c 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -176,6 +176,8 @@ enum {
 	NFTNL_EXPR_QUEUE_NUM	= NFTNL_EXPR_BASE,
 	NFTNL_EXPR_QUEUE_TOTAL,
 	NFTNL_EXPR_QUEUE_FLAGS,
+	NFTNL_EXPR_QUEUE_SREG_FROM,
+	NFTNL_EXPR_QUEUE_SREG_TO,
 };
 
 enum {
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index dd8b746..8ebd767 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -886,12 +886,16 @@ enum nft_log_attributes {
  * @NFTA_QUEUE_NUM: netlink queue to send messages to (NLA_U16)
  * @NFTA_QUEUE_TOTAL: number of queues to load balance packets on (NLA_U16)
  * @NFTA_QUEUE_FLAGS: various flags (NLA_U16)
+ * @NFTA_QUEUE_SREG_FROM: source register of queue number start (NLA_U32: nft_registers)
+ * @NFTA_QUEUE_SREG_TO: source register of queue number end (NLA_U32: nft_registers)
  */
 enum nft_queue_attributes {
 	NFTA_QUEUE_UNSPEC,
 	NFTA_QUEUE_NUM,
 	NFTA_QUEUE_TOTAL,
 	NFTA_QUEUE_FLAGS,
+	NFTA_QUEUE_SREG_FROM,
+	NFTA_QUEUE_SREG_TO,
 	__NFTA_QUEUE_MAX
 };
 #define NFTA_QUEUE_MAX		(__NFTA_QUEUE_MAX - 1)
diff --git a/src/expr/queue.c b/src/expr/queue.c
index 033c542..01380a6 100644
--- a/src/expr/queue.c
+++ b/src/expr/queue.c
@@ -21,6 +21,8 @@
 #include <libnftnl/rule.h>
 
 struct nftnl_expr_queue {
+	enum nft_registers	sreg_from;
+	enum nft_registers	sreg_to;
 	uint16_t		queuenum;
 	uint16_t		queues_total;
 	uint16_t		flags;
@@ -41,6 +43,12 @@ static int nftnl_expr_queue_set(struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_QUEUE_FLAGS:
 		queue->flags = *((uint16_t *)data);
 		break;
+	case NFTNL_EXPR_QUEUE_SREG_FROM:
+		queue->sreg_from = *((uint32_t *)data);
+		break;
+	case NFTNL_EXPR_QUEUE_SREG_TO:
+		queue->sreg_to = *((uint32_t *)data);
+		break;
 	default:
 		return -1;
 	}
@@ -63,6 +71,12 @@ nftnl_expr_queue_get(const struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_QUEUE_FLAGS:
 		*data_len = sizeof(queue->flags);
 		return &queue->flags;
+	case NFTNL_EXPR_QUEUE_SREG_FROM:
+		*data_len = sizeof(queue->sreg_from);
+		return &queue->sreg_from;
+	case NFTNL_EXPR_QUEUE_SREG_TO:
+		*data_len = sizeof(queue->sreg_to);
+		return &queue->sreg_to;
 	}
 	return NULL;
 }
@@ -82,6 +96,11 @@ static int nftnl_expr_queue_cb(const struct nlattr *attr, void *data)
 		if (mnl_attr_validate(attr, MNL_TYPE_U16) < 0)
 			abi_breakage();
 		break;
+	case NFTA_QUEUE_SREG_FROM:
+	case NFTA_QUEUE_SREG_TO:
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+			abi_breakage();
+		break;
 	}
 
 	tb[type] = attr;
@@ -99,6 +118,10 @@ nftnl_expr_queue_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
 		mnl_attr_put_u16(nlh, NFTA_QUEUE_TOTAL, htons(queue->queues_total));
 	if (e->flags & (1 << NFTNL_EXPR_QUEUE_FLAGS))
 		mnl_attr_put_u16(nlh, NFTA_QUEUE_FLAGS, htons(queue->flags));
+	if (e->flags & (1 << NFTNL_EXPR_QUEUE_SREG_FROM))
+		mnl_attr_put_u32(nlh, NFTA_QUEUE_SREG_FROM, htonl(queue->sreg_from));
+	if (e->flags & (1 << NFTNL_EXPR_QUEUE_SREG_TO))
+		mnl_attr_put_u32(nlh, NFTA_QUEUE_SREG_TO, htonl(queue->sreg_to));
 }
 
 static int
@@ -122,6 +145,14 @@ nftnl_expr_queue_parse(struct nftnl_expr *e, struct nlattr *attr)
 		queue->flags = ntohs(mnl_attr_get_u16(tb[NFTA_QUEUE_FLAGS]));
 		e->flags |= (1 << NFTNL_EXPR_QUEUE_FLAGS);
 	}
+	if (tb[NFTA_QUEUE_SREG_FROM]) {
+		queue->sreg_from = ntohl(mnl_attr_get_u32(tb[NFTA_QUEUE_SREG_FROM]));
+		e->flags |= (1 << NFTNL_EXPR_QUEUE_SREG_FROM);
+	}
+	if (tb[NFTA_QUEUE_SREG_TO]) {
+		queue->sreg_to = ntohl(mnl_attr_get_u32(tb[NFTA_QUEUE_SREG_TO]));
+		e->flags |= (1 << NFTNL_EXPR_QUEUE_SREG_TO);
+	}
 
 	return 0;
 }
@@ -131,6 +162,7 @@ nftnl_expr_queue_json_parse(struct nftnl_expr *e, json_t *root,
 			       struct nftnl_parse_err *err)
 {
 #ifdef JSON_PARSING
+	uint32_t sreg_from, sreg_to;
 	uint16_t type;
 	uint16_t code;
 
@@ -143,6 +175,14 @@ nftnl_expr_queue_json_parse(struct nftnl_expr *e, json_t *root,
 	if (nftnl_jansson_parse_val(root, "flags", NFTNL_TYPE_U16, &code, err) == 0)
 		nftnl_expr_set_u16(e, NFTNL_EXPR_QUEUE_FLAGS, code);
 
+	if (nftnl_jansson_parse_val(root, "sreg_from", NFTNL_TYPE_U32, &sreg_from,
+				    err) == 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_QUEUE_SREG_FROM, sreg_from);
+
+	if (nftnl_jansson_parse_val(root, "sreg_to", NFTNL_TYPE_U32, &sreg_to,
+				    err) == 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_QUEUE_SREG_TO, sreg_to);
+
 	return 0;
 #else
 	errno = EOPNOTSUPP;
@@ -156,6 +196,7 @@ nftnl_expr_queue_xml_parse(struct nftnl_expr *e, mxml_node_t *tree,
 {
 #ifdef XML_PARSING
 	uint16_t queue_num, queue_total, flags;
+	uint32_t sreg_from, sreg_to;
 
 	if (nftnl_mxml_num_parse(tree, "num", MXML_DESCEND_FIRST, BASE_DEC,
 			       &queue_num, NFTNL_TYPE_U16, NFTNL_XML_MAND,
@@ -172,6 +213,16 @@ nftnl_expr_queue_xml_parse(struct nftnl_expr *e, mxml_node_t *tree,
 			       NFTNL_XML_MAND, err) == 0)
 		nftnl_expr_set_u16(e, NFTNL_EXPR_QUEUE_FLAGS, flags);
 
+	if (nftnl_mxml_num_parse(tree, "sreg_from", MXML_DESCEND_FIRST, BASE_DEC,
+			       &sreg_from, NFTNL_TYPE_U32,
+			       NFTNL_XML_MAND, err) == 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_QUEUE_SREG_FROM, sreg_from);
+
+	if (nftnl_mxml_num_parse(tree, "sreg_to", MXML_DESCEND_FIRST, BASE_DEC,
+			       &sreg_to, NFTNL_TYPE_U32,
+			       NFTNL_XML_MAND, err) == 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_QUEUE_SREG_TO, sreg_to);
+
 	return 0;
 #else
 	errno = EOPNOTSUPP;
@@ -186,23 +237,34 @@ static int nftnl_expr_queue_snprintf_default(char *buf, size_t len,
 	int ret, size = len, offset = 0;
 	uint16_t total_queues;
 
-	total_queues = queue->queuenum + queue->queues_total -1;
+	if (e->flags & (1 << NFTNL_EXPR_QUEUE_NUM)) {
+		total_queues = queue->queuenum + queue->queues_total - 1;
 
-	ret = snprintf(buf + offset, len, "num %u", queue->queuenum);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		ret = snprintf(buf + offset, len, "num %u", queue->queuenum);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+		if (queue->queues_total && total_queues != queue->queuenum) {
+			ret = snprintf(buf + offset, len, "-%u", total_queues);
+			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		}
+
+		ret = snprintf(buf + offset, len, " ");
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
 
-	if (queue->queues_total && total_queues != queue->queuenum) {
-		ret = snprintf(buf + offset, len, "-%u", total_queues);
+	if (e->flags & (1 << NFTNL_EXPR_QUEUE_SREG_FROM)) {
+		ret = snprintf(buf + offset, len, "reg_from %u reg_to %u ",
+			       queue->sreg_from, queue->sreg_to);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
 	if (e->flags & (1 << NFTNL_EXPR_QUEUE_FLAGS)) {
 		if (queue->flags & (NFT_QUEUE_FLAG_BYPASS)) {
-			ret = snprintf(buf + offset, len, " bypass");
+			ret = snprintf(buf + offset, len, "bypass ");
 			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 		}
 		if (queue->flags & (NFT_QUEUE_FLAG_CPU_FANOUT)) {
-			ret = snprintf(buf + offset, len, " fanout");
+			ret = snprintf(buf + offset, len, "fanout ");
 			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 		}
 	}
@@ -221,6 +283,10 @@ static int nftnl_expr_queue_export(char *buf, size_t size,
 		nftnl_buf_u32(&b, type, queue->queues_total, TOTAL);
 	if (e->flags & (1 << NFTNL_EXPR_QUEUE_FLAGS))
 		nftnl_buf_u32(&b, type, queue->flags, FLAGS);
+	if (e->flags & (1 << NFTNL_EXPR_QUEUE_SREG_FROM))
+		nftnl_buf_u32(&b, type, queue->sreg_from, SREG_FROM);
+	if (e->flags & (1 << NFTNL_EXPR_QUEUE_SREG_TO))
+		nftnl_buf_u32(&b, type, queue->sreg_to, SREG_TO);
 
 	return nftnl_buf_done(&b);
 }
@@ -255,6 +321,10 @@ static bool nftnl_expr_queue_cmp(const struct nftnl_expr *e1,
 		eq &= (q1->queues_total == q2->queues_total);
 	if (e1->flags & (1 << NFTNL_EXPR_QUEUE_FLAGS))
 		eq &= (q1->flags == q2->flags);
+	if (e1->flags & (1 << NFTNL_EXPR_QUEUE_SREG_FROM))
+		eq &= (q1->sreg_from == q2->sreg_from);
+	if (e1->flags & (1 << NFTNL_EXPR_QUEUE_SREG_TO))
+		eq &= (q1->sreg_to == q2->sreg_to);
 
 	return eq;
 }
diff --git a/tests/nft-expr_queue-test.c b/tests/nft-expr_queue-test.c
index 81d7dd2..e038ce4 100644
--- a/tests/nft-expr_queue-test.c
+++ b/tests/nft-expr_queue-test.c
@@ -42,6 +42,12 @@ static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
 	if (nftnl_expr_get_u16(rule_a, NFTNL_EXPR_QUEUE_FLAGS) !=
 	    nftnl_expr_get_u16(rule_b, NFTNL_EXPR_QUEUE_FLAGS))
 		print_err("Expr NFTNL_EXPR_QUEUE_FLAGS mismatches");
+	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_QUEUE_SREG_FROM) !=
+	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_QUEUE_SREG_FROM))
+		print_err("Expr NFTNL_EXPR_QUEUE_SREG_FROM mismatches");
+	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_QUEUE_SREG_TO) !=
+	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_QUEUE_SREG_TO))
+		print_err("Expr NFTNL_EXPR_QUEUE_SREG_TO mismatches");
 }
 
 int main(int argc, char *argv[])
@@ -64,6 +70,8 @@ int main(int argc, char *argv[])
 	nftnl_expr_set_u16(ex, NFTNL_EXPR_QUEUE_NUM, 0x01010);
 	nftnl_expr_set_u16(ex, NFTNL_EXPR_QUEUE_TOTAL, 0x1234);
 	nftnl_expr_set_u16(ex, NFTNL_EXPR_QUEUE_FLAGS, 0x4321);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_QUEUE_SREG_FROM, 0x1452638);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_QUEUE_SREG_TO, 0x5134682);
 
 	nftnl_rule_add_expr(a, ex);
 
-- 
2.5.5


