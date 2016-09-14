From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH libnftnl V2] expr: queue: add NFTA_QUEUE_SREG_QNUM attr support
Date: Wed, 14 Sep 2016 23:45:44 +0800
Message-ID: <1473867944-52307-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-17.163.com ([220.181.12.17]:48290 "EHLO m12-17.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1764344AbcINPqZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Sep 2016 11:46:25 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

After adding _SREG_QNUM attr, queuenum is not must option anymore,
so we must test NFTNL_EXPR_QUEUE_NUM first before dumpping queue num
in snprintf_default. Also add a tailing space in snprintf_default,
this is consistent with other expressions.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 V2: adjust two sreg to one sreg, keep consistent with the kernel

 include/buffer.h                    |  1 +
 include/libnftnl/expr.h             |  1 +
 include/linux/netfilter/nf_tables.h |  2 ++
 src/expr/queue.c                    | 57 ++++++++++++++++++++++++++++++++-----
 4 files changed, 54 insertions(+), 7 deletions(-)

diff --git a/include/buffer.h b/include/buffer.h
index a753c78..ab1d468 100644
--- a/include/buffer.h
+++ b/include/buffer.h
@@ -77,6 +77,7 @@ int nftnl_buf_reg(struct nftnl_buf *b, int type, union nftnl_data_reg *reg,
 #define SREG_PROTO_MIN		"sreg_proto_min"
 #define SREG_KEY		"sreg_key"
 #define SREG_DATA		"sreg_data"
+#define SREG_QNUM		"sreg_qnum"
 #define SREG			"sreg"
 #define TABLE			"table"
 #define TOTAL			"total"
diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index 8b35203..476f82d 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -176,6 +176,7 @@ enum {
 	NFTNL_EXPR_QUEUE_NUM	= NFTNL_EXPR_BASE,
 	NFTNL_EXPR_QUEUE_TOTAL,
 	NFTNL_EXPR_QUEUE_FLAGS,
+	NFTNL_EXPR_QUEUE_SREG_QNUM,
 };
 
 enum {
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index e608054..b4366f3 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -888,12 +888,14 @@ enum nft_log_attributes {
  * @NFTA_QUEUE_NUM: netlink queue to send messages to (NLA_U16)
  * @NFTA_QUEUE_TOTAL: number of queues to load balance packets on (NLA_U16)
  * @NFTA_QUEUE_FLAGS: various flags (NLA_U16)
+ * @NFTA_QUEUE_SREG_QNUM: source register of queue number (NLA_U32: nft_registers)
  */
 enum nft_queue_attributes {
 	NFTA_QUEUE_UNSPEC,
 	NFTA_QUEUE_NUM,
 	NFTA_QUEUE_TOTAL,
 	NFTA_QUEUE_FLAGS,
+	NFTA_QUEUE_SREG_QNUM,
 	__NFTA_QUEUE_MAX
 };
 #define NFTA_QUEUE_MAX		(__NFTA_QUEUE_MAX - 1)
diff --git a/src/expr/queue.c b/src/expr/queue.c
index 033c542..316a9ed 100644
--- a/src/expr/queue.c
+++ b/src/expr/queue.c
@@ -21,6 +21,7 @@
 #include <libnftnl/rule.h>
 
 struct nftnl_expr_queue {
+	enum nft_registers	sreg_qnum;
 	uint16_t		queuenum;
 	uint16_t		queues_total;
 	uint16_t		flags;
@@ -41,6 +42,9 @@ static int nftnl_expr_queue_set(struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_QUEUE_FLAGS:
 		queue->flags = *((uint16_t *)data);
 		break;
+	case NFTNL_EXPR_QUEUE_SREG_QNUM:
+		queue->sreg_qnum = *((uint32_t *)data);
+		break;
 	default:
 		return -1;
 	}
@@ -63,6 +67,9 @@ nftnl_expr_queue_get(const struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_QUEUE_FLAGS:
 		*data_len = sizeof(queue->flags);
 		return &queue->flags;
+	case NFTNL_EXPR_QUEUE_SREG_QNUM:
+		*data_len = sizeof(queue->sreg_qnum);
+		return &queue->sreg_qnum;
 	}
 	return NULL;
 }
@@ -82,6 +89,10 @@ static int nftnl_expr_queue_cb(const struct nlattr *attr, void *data)
 		if (mnl_attr_validate(attr, MNL_TYPE_U16) < 0)
 			abi_breakage();
 		break;
+	case NFTA_QUEUE_SREG_QNUM:
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+			abi_breakage();
+		break;
 	}
 
 	tb[type] = attr;
@@ -99,6 +110,8 @@ nftnl_expr_queue_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
 		mnl_attr_put_u16(nlh, NFTA_QUEUE_TOTAL, htons(queue->queues_total));
 	if (e->flags & (1 << NFTNL_EXPR_QUEUE_FLAGS))
 		mnl_attr_put_u16(nlh, NFTA_QUEUE_FLAGS, htons(queue->flags));
+	if (e->flags & (1 << NFTNL_EXPR_QUEUE_SREG_QNUM))
+		mnl_attr_put_u32(nlh, NFTA_QUEUE_SREG_QNUM, htonl(queue->sreg_qnum));
 }
 
 static int
@@ -122,6 +135,10 @@ nftnl_expr_queue_parse(struct nftnl_expr *e, struct nlattr *attr)
 		queue->flags = ntohs(mnl_attr_get_u16(tb[NFTA_QUEUE_FLAGS]));
 		e->flags |= (1 << NFTNL_EXPR_QUEUE_FLAGS);
 	}
+	if (tb[NFTA_QUEUE_SREG_QNUM]) {
+		queue->sreg_qnum = ntohl(mnl_attr_get_u32(tb[NFTA_QUEUE_SREG_QNUM]));
+		e->flags |= (1 << NFTNL_EXPR_QUEUE_SREG_QNUM);
+	}
 
 	return 0;
 }
@@ -131,6 +148,7 @@ nftnl_expr_queue_json_parse(struct nftnl_expr *e, json_t *root,
 			       struct nftnl_parse_err *err)
 {
 #ifdef JSON_PARSING
+	uint32_t sreg_qnum;
 	uint16_t type;
 	uint16_t code;
 
@@ -143,6 +161,10 @@ nftnl_expr_queue_json_parse(struct nftnl_expr *e, json_t *root,
 	if (nftnl_jansson_parse_val(root, "flags", NFTNL_TYPE_U16, &code, err) == 0)
 		nftnl_expr_set_u16(e, NFTNL_EXPR_QUEUE_FLAGS, code);
 
+	if (nftnl_jansson_parse_val(root, "sreg_qnum", NFTNL_TYPE_U32, &sreg_qnum,
+				    err) == 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_QUEUE_SREG_QNUM, sreg_qnum);
+
 	return 0;
 #else
 	errno = EOPNOTSUPP;
@@ -156,6 +178,7 @@ nftnl_expr_queue_xml_parse(struct nftnl_expr *e, mxml_node_t *tree,
 {
 #ifdef XML_PARSING
 	uint16_t queue_num, queue_total, flags;
+	uint32_t sreg_qnum;
 
 	if (nftnl_mxml_num_parse(tree, "num", MXML_DESCEND_FIRST, BASE_DEC,
 			       &queue_num, NFTNL_TYPE_U16, NFTNL_XML_MAND,
@@ -172,6 +195,11 @@ nftnl_expr_queue_xml_parse(struct nftnl_expr *e, mxml_node_t *tree,
 			       NFTNL_XML_MAND, err) == 0)
 		nftnl_expr_set_u16(e, NFTNL_EXPR_QUEUE_FLAGS, flags);
 
+	if (nftnl_mxml_num_parse(tree, "sreg_qnum", MXML_DESCEND_FIRST, BASE_DEC,
+			       &sreg_qnum, NFTNL_TYPE_U32,
+			       NFTNL_XML_MAND, err) == 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_QUEUE_SREG_QNUM, sreg_qnum);
+
 	return 0;
 #else
 	errno = EOPNOTSUPP;
@@ -186,23 +214,34 @@ static int nftnl_expr_queue_snprintf_default(char *buf, size_t len,
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
+	if (e->flags & (1 << NFTNL_EXPR_QUEUE_SREG_QNUM)) {
+		ret = snprintf(buf + offset, len, "sreg_qnum %u ",
+			       queue->sreg_qnum);
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
@@ -221,6 +260,8 @@ static int nftnl_expr_queue_export(char *buf, size_t size,
 		nftnl_buf_u32(&b, type, queue->queues_total, TOTAL);
 	if (e->flags & (1 << NFTNL_EXPR_QUEUE_FLAGS))
 		nftnl_buf_u32(&b, type, queue->flags, FLAGS);
+	if (e->flags & (1 << NFTNL_EXPR_QUEUE_SREG_QNUM))
+		nftnl_buf_u32(&b, type, queue->sreg_qnum, SREG_QNUM);
 
 	return nftnl_buf_done(&b);
 }
@@ -255,6 +296,8 @@ static bool nftnl_expr_queue_cmp(const struct nftnl_expr *e1,
 		eq &= (q1->queues_total == q2->queues_total);
 	if (e1->flags & (1 << NFTNL_EXPR_QUEUE_FLAGS))
 		eq &= (q1->flags == q2->flags);
+	if (e1->flags & (1 << NFTNL_EXPR_QUEUE_SREG_QNUM))
+		eq &= (q1->sreg_qnum == q2->sreg_qnum);
 
 	return eq;
 }
-- 
2.5.5


