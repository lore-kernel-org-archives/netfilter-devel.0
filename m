From: Krishna Kumar <krkumar2@in.ibm.com>
Subject: [PATCH] libnetfilter_queue: Implement API to set per-queue flags
Date: Wed, 06 Jun 2012 16:29:00 +0530
Message-ID: <20120606105900.32466.56533.sendpatchset@localhost.localdomain>
Cc: vivk@us.ibm.com, svajipay@in.ibm.com,
	netfilter-devel@vger.kernel.org,
	Krishna Kumar <krkumar2@in.ibm.com>, sri@us.ibm.com
To: fw@strlen.de, kaber@trash.net, pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:46493 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945Ab2FFLtg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Jun 2012 07:49:36 -0400
Received: from /spool/local
	by e23smtp07.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <netfilter-devel@vger.kernel.org> from <krkumar2@in.ibm.com>;
	Wed, 6 Jun 2012 10:51:39 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q56Ax5LZ1638810
	for <netfilter-devel@vger.kernel.org>; Wed, 6 Jun 2012 20:59:06 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q56Ax42H017029
	for <netfilter-devel@vger.kernel.org>; Wed, 6 Jun 2012 20:59:05 +1000
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Implement API to set per-queue flags. This is initially used
to implement fail-open support in NFQUEUE.

Signed-off-by: Krishna Kumar <krkumar2@in.ibm.com>
---
 include/libnetfilter_queue/libnetfilter_queue.h    |    3 
 include/libnetfilter_queue/linux_nfnetlink_queue.h |    5 +
 src/libnetfilter_queue.c                           |   42 +++++++++++
 3 files changed, 50 insertions(+)

diff -ruNp org/include/libnetfilter_queue/libnetfilter_queue.h new/include/libnetfilter_queue/libnetfilter_queue.h
--- org/include/libnetfilter_queue/libnetfilter_queue.h	2012-06-06 10:07:21.863540677 +0530
+++ new/include/libnetfilter_queue/libnetfilter_queue.h	2012-06-06 10:08:17.629962800 +0530
@@ -56,6 +56,9 @@ extern int nfq_set_mode(struct nfq_q_han
 int nfq_set_queue_maxlen(struct nfq_q_handle *qh,
 			u_int32_t queuelen);
 
+extern int nfq_set_queue_flags(struct nfq_q_handle *qh,
+			       uint32_t mask, uint32_t flags);
+
 extern int nfq_set_verdict(struct nfq_q_handle *qh,
 			     u_int32_t id,
 			     u_int32_t verdict,
diff -ruNp org/include/libnetfilter_queue/linux_nfnetlink_queue.h new/include/libnetfilter_queue/linux_nfnetlink_queue.h
--- org/include/libnetfilter_queue/linux_nfnetlink_queue.h	2012-06-06 10:07:21.874538295 +0530
+++ new/include/libnetfilter_queue/linux_nfnetlink_queue.h	2012-06-06 15:41:51.912636134 +0530
@@ -87,8 +87,13 @@ enum nfqnl_attr_config {
 	NFQA_CFG_CMD,			/* nfqnl_msg_config_cmd */
 	NFQA_CFG_PARAMS,		/* nfqnl_msg_config_params */
 	NFQA_CFG_QUEUE_MAXLEN,		/* u_int32_t */
+	NFQA_CFG_MASK,			/* identify which flags to change */
+	NFQA_CFG_FLAGS,			/* value of these flags (__u32) */
 	__NFQA_CFG_MAX
 };
 #define NFQA_CFG_MAX (__NFQA_CFG_MAX-1)
 
+/* Flags/options for NFQA_CFG_FLAGS */
+#define NFQA_CFG_F_FAIL_OPEN		(1 << 0)
+
 #endif /* _NFNETLINK_QUEUE_H */
diff -ruNp org/src/libnetfilter_queue.c new/src/libnetfilter_queue.c
--- org/src/libnetfilter_queue.c	2012-06-06 10:07:21.844663683 +0530
+++ new/src/libnetfilter_queue.c	2012-06-06 15:51:58.823725859 +0530
@@ -602,6 +602,48 @@ int nfq_set_mode(struct nfq_q_handle *qh
 }
 
 /**
+ * nfq_set_queue_flags - set flags (options) for the kernel queue
+ * \param qh Netfilter queue handle obtained by call to nfq_create_queue().
+ * \param mask specifies which flag bits to modify
+ * \param flag bitmask of flags
+ *
+ * Here's a little code snippet to show how to use this API:
+ * \verbatim
+	uint32_t flags = NFQA_CFG_F_FAIL_OPEN;
+	uint32_t mask = NFQA_CFG_F_FAIL_OPEN;
+
+	printf("Enabling fail-open on this q\n");
+	err = nfq_set_queue_flags(qh, mask, flags);
+
+	printf("Disabling fail-open on this q\n");
+	flags &= ~NFQA_CFG_F_FAIL_OPEN;
+	err = nfq_set_queue_flags(qh, mask, flags);
+\endverbatim
+ * \return -1 on error with errno set appropriately; =0 otherwise.
+ */
+int nfq_set_queue_flags(struct nfq_q_handle *qh,
+			uint32_t mask, uint32_t flags)
+{
+	union {
+		char buf[NFNL_HEADER_LEN
+			+NFA_LENGTH(sizeof(mask)
+			+NFA_LENGTH(sizeof(flags)))];
+		struct nlmsghdr nmh;
+	} u;
+
+	mask = htonl(mask);
+	flags = htonl(flags);
+
+	nfnl_fill_hdr(qh->h->nfnlssh, &u.nmh, 0, AF_UNSPEC, qh->id,
+		      NFQNL_MSG_CONFIG, NLM_F_REQUEST|NLM_F_ACK);
+
+	nfnl_addattr32(&u.nmh, sizeof(u), NFQA_CFG_FLAGS, flags);
+	nfnl_addattr32(&u.nmh, sizeof(u), NFQA_CFG_MASK, mask);
+
+	return nfnl_query(qh->h->nfnlh, &u.nmh);
+}
+
+/**
  * nfq_set_queue_maxlen - Set kernel queue maximum length parameter
  * \param qh Netfilter queue handle obtained by call to nfq_create_queue().
  * \param queuelen the length of the queue

