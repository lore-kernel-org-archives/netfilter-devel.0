From: Florian Westphal <fw@strlen.de>
Subject: [PATCH] nfq: NFQNL_MSG_VERDICT_BATCH support
Date: Mon,  5 Sep 2011 21:11:37 +0200
Message-ID: <1315249897-5477-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:57589 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751424Ab1IETN2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Sep 2011 15:13:28 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

add nfq_set_verdict_batch() and nfq_set_verdict_batch2 (to also
set the nfmark of all packets).

verdicts sent by the _batch variant will affect all queued skbs
whose id is smaller or equal to the given id.

This facility is available from Linux 3.1 onwards.

While at it, add notes on use of NF_STOLEN and NF_REPEAT verdicts.
---
 include/libnetfilter_queue/libnetfilter_queue.h    |    9 +++
 include/libnetfilter_queue/linux_nfnetlink_queue.h |    1 +
 src/libnetfilter_queue.c                           |   57 +++++++++++++++++---
 3 files changed, 60 insertions(+), 7 deletions(-)

diff --git a/include/libnetfilter_queue/libnetfilter_queue.h b/include/libnetfilter_queue/libnetfilter_queue.h
index 295de66..28bf2b1 100644
--- a/include/libnetfilter_queue/libnetfilter_queue.h
+++ b/include/libnetfilter_queue/libnetfilter_queue.h
@@ -69,6 +69,15 @@ extern int nfq_set_verdict2(struct nfq_q_handle *qh,
 			    u_int32_t datalen,
 			    const unsigned char *buf);
 
+extern int nfq_set_verdict_batch(struct nfq_q_handle *qh,
+			    u_int32_t id,
+			    u_int32_t verdict);
+
+extern int nfq_set_verdict_batch2(struct nfq_q_handle *qh,
+			    u_int32_t id,
+			    u_int32_t verdict,
+			    u_int32_t mark);
+
 extern __attribute__((deprecated))
 int nfq_set_verdict_mark(struct nfq_q_handle *qh, 
 			 u_int32_t id,
diff --git a/include/libnetfilter_queue/linux_nfnetlink_queue.h b/include/libnetfilter_queue/linux_nfnetlink_queue.h
index 191b094..6b4f86d 100644
--- a/include/libnetfilter_queue/linux_nfnetlink_queue.h
+++ b/include/libnetfilter_queue/linux_nfnetlink_queue.h
@@ -11,6 +11,7 @@ enum nfqnl_msg_types {
 	NFQNL_MSG_PACKET,		/* packet from kernel to userspace */
 	NFQNL_MSG_VERDICT,		/* verdict from userspace to kernel */
 	NFQNL_MSG_CONFIG,		/* connect to a particular queue */
+	NFQNL_MSG_VERDICT_BATCH,	/* batch verdict from userspace to kernel */
 
 	NFQNL_MSG_MAX
 };
diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index 08c4039..d57a523 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -244,12 +244,17 @@ struct nfnl_handle *nfq_nfnlh(struct nfq_handle *h)
  *
  *   - NF_DROP discarded the packet
  *   - NF_ACCEPT the packet passes, continue iterations
- *   - NF_STOLEN gone away
  *   - NF_QUEUE inject the packet into a different queue
  *     (the target queue number is in the high 16 bits of the verdict)
  *   - NF_REPEAT iterate the same cycle once more
  *   - NF_STOP accept, but don't continue iterations
  *
+ * The verdict NF_STOLEN must not be used, as it has special meaning in the
+ * kernel.
+ * When using NF_REPEAT, one way to prevent re-queueing of the same packet
+ * is to also set an nfmark using nfq_set_verdict2, and set up the nefilter
+ * rules to only queue a packet when the mark is not (yet) set.
+ *
  * Data and information about the packet can be fetch by using message parsing
  * functions (See \link Parsing \endlink).
  * @{
@@ -632,7 +637,8 @@ int nfq_set_queue_maxlen(struct nfq_q_handle *qh,
 
 static int __set_verdict(struct nfq_q_handle *qh, u_int32_t id,
 		u_int32_t verdict, u_int32_t mark, int set_mark,
-		u_int32_t data_len, const unsigned char *data)
+		u_int32_t data_len, const unsigned char *data,
+		enum nfqnl_msg_types type)
 {
 	struct nfqnl_msg_verdict_hdr vh;
 	union {
@@ -655,7 +661,7 @@ static int __set_verdict(struct nfq_q_handle *qh, u_int32_t id,
 	vh.id = htonl(id);
 
 	nfnl_fill_hdr(qh->h->nfnlssh, &u.nmh, 0, AF_UNSPEC, qh->id,
-			NFQNL_MSG_VERDICT, NLM_F_REQUEST);
+				type, NLM_F_REQUEST);
 
 	/* add verdict header */
 	nfnl_addattr_l(&u.nmh, sizeof(u), NFQA_VERDICT_HDR, &vh, sizeof(vh));
@@ -705,7 +711,8 @@ static int __set_verdict(struct nfq_q_handle *qh, u_int32_t id,
  *
  * Notifies netfilter of the userspace verdict for the given packet.  Every
  * queued packet _must_ have a verdict specified by userspace, either by
- * calling this function, or by calling the nfq_set_verdict2() function.
+ * calling this function, the nfq_set_verdict2() function, or the _batch
+ * versions of these functions.
  *
  * \return -1 on error; >= 0 otherwise.
  */
@@ -713,7 +720,8 @@ int nfq_set_verdict(struct nfq_q_handle *qh, u_int32_t id,
 		u_int32_t verdict, u_int32_t data_len, 
 		const unsigned char *buf)
 {
-	return __set_verdict(qh, id, verdict, 0, 0, data_len, buf);
+	return __set_verdict(qh, id, verdict, 0, 0, data_len, buf,
+						NFQNL_MSG_VERDICT);
 }	
 
 /**
@@ -729,7 +737,41 @@ int nfq_set_verdict2(struct nfq_q_handle *qh, u_int32_t id,
 		     u_int32_t verdict, u_int32_t mark,
 		     u_int32_t data_len, const unsigned char *buf)
 {
-	return __set_verdict(qh, id, verdict, htonl(mark), 1, data_len, buf);
+	return __set_verdict(qh, id, verdict, htonl(mark), 1, data_len,
+						buf, NFQNL_MSG_VERDICT);
+}
+
+/**
+ * nfq_set_verdict_batch - issue verdicts on several packets at once
+ * \param qh Netfilter queue handle obtained by call to nfq_create_queue().
+ * \param id maximum ID of the packets that the verdict should be applied to.
+ * \param verdict verdict to return to netfilter (NF_ACCEPT, NF_DROP)
+ *
+ * Unlike nfq_set_verdict, the verdict is applied to all queued packets
+ * whose packet id is smaller or equal to #id.
+ *
+ * batch support was added in Linux 3.1.
+ * These functions will fail silently on older kernels.
+ */
+int nfq_set_verdict_batch(struct nfq_q_handle *qh, u_int32_t id,
+					  u_int32_t verdict)
+{
+	return __set_verdict(qh, id, verdict, 0, 0, 0, NULL,
+					NFQNL_MSG_VERDICT_BATCH);
+}
+
+/**
+ * nfq_set_verdict_batch2 - like nfq_set_verdict_batch, but you can set a mark.
+ * \param qh Netfilter queue handle obtained by call to nfq_create_queue().
+ * \param id maximum ID of the packets that the verdict should be applied to.
+ * \param verdict verdict to return to netfilter (NF_ACCEPT, NF_DROP)
+ * \param mark mark to put on packet
+ */
+int nfq_set_verdict_batch2(struct nfq_q_handle *qh, u_int32_t id,
+		     u_int32_t verdict, u_int32_t mark)
+{
+	return __set_verdict(qh, id, verdict, htonl(mark), 1, 0,
+				NULL, NFQNL_MSG_VERDICT_BATCH);
 }
 
 /**
@@ -750,7 +792,8 @@ int nfq_set_verdict_mark(struct nfq_q_handle *qh, u_int32_t id,
 		u_int32_t verdict, u_int32_t mark,
 		u_int32_t data_len, const unsigned char *buf)
 {
-	return __set_verdict(qh, id, verdict, mark, 1, data_len, buf);
+	return __set_verdict(qh, id, verdict, mark, 1, data_len, buf,
+						NFQNL_MSG_VERDICT);
 }
 
 /**
-- 
1.7.3.4

