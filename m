From: Felix Janda <felix.janda@posteo.de>
Subject: [libnetfilter_queue PATCH 3/4] Use stdint types everywhere
Date: Sat, 16 May 2015 14:45:23 +0200
Message-ID: <20150516123431.GV14201@euler>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:58473 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753241AbbEPMpm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 May 2015 08:45:42 -0400
Received: from dovecot04.posteo.de (unknown [185.67.36.27])
	by mx02.posteo.de (Postfix) with ESMTPS id D369A25A3DEA
	for <netfilter-devel@vger.kernel.org>; Sat, 16 May 2015 14:45:40 +0200 (CEST)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot04.posteo.de (Postfix) with ESMTPSA id 3lpmYJ3f4czFpW8
	for <netfilter-devel@vger.kernel.org>; Sat, 16 May 2015 14:45:40 +0200 (CEST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 include/libnetfilter_queue/libnetfilter_queue.h |  56 ++++++-------
 src/libnetfilter_queue.c                        | 102 ++++++++++++------------
 utils/nfqnl_test.c                              |   6 +-
 3 files changed, 82 insertions(+), 82 deletions(-)

diff --git a/include/libnetfilter_queue/libnetfilter_queue.h b/include/libnetfilter_queue/libnetfilter_queue.h
index 122cd10..8194a4f 100644
--- a/include/libnetfilter_queue/libnetfilter_queue.h
+++ b/include/libnetfilter_queue/libnetfilter_queue.h
@@ -39,11 +39,11 @@ extern struct nfq_handle *nfq_open(void);
 extern struct nfq_handle *nfq_open_nfnl(struct nfnl_handle *nfnlh);
 extern int nfq_close(struct nfq_handle *h);
 
-extern int nfq_bind_pf(struct nfq_handle *h, u_int16_t pf);
-extern int nfq_unbind_pf(struct nfq_handle *h, u_int16_t pf);
+extern int nfq_bind_pf(struct nfq_handle *h, uint16_t pf);
+extern int nfq_unbind_pf(struct nfq_handle *h, uint16_t pf);
 
 extern struct nfq_q_handle *nfq_create_queue(struct nfq_handle *h,
-			      			 u_int16_t num,
+						 uint16_t num,
 						 nfq_callback *cb,
 						 void *data);
 extern int nfq_destroy_queue(struct nfq_q_handle *qh);
@@ -51,42 +51,42 @@ extern int nfq_destroy_queue(struct nfq_q_handle *qh);
 extern int nfq_handle_packet(struct nfq_handle *h, char *buf, int len);
 
 extern int nfq_set_mode(struct nfq_q_handle *qh,
-			  u_int8_t mode, unsigned int len);
+			  uint8_t mode, unsigned int len);
 
 int nfq_set_queue_maxlen(struct nfq_q_handle *qh,
-			u_int32_t queuelen);
+			uint32_t queuelen);
 
 extern int nfq_set_queue_flags(struct nfq_q_handle *qh,
 			       uint32_t mask, uint32_t flags);
 
 extern int nfq_set_verdict(struct nfq_q_handle *qh,
-			     u_int32_t id,
-			     u_int32_t verdict,
-			     u_int32_t data_len,
+			     uint32_t id,
+			     uint32_t verdict,
+			     uint32_t data_len,
 			     const unsigned char *buf);
 
 extern int nfq_set_verdict2(struct nfq_q_handle *qh,
-			    u_int32_t id,
-			    u_int32_t verdict, 
-			    u_int32_t mark,
-			    u_int32_t datalen,
+			    uint32_t id,
+			    uint32_t verdict,
+			    uint32_t mark,
+			    uint32_t datalen,
 			    const unsigned char *buf);
 
 extern int nfq_set_verdict_batch(struct nfq_q_handle *qh,
-			    u_int32_t id,
-			    u_int32_t verdict);
+			    uint32_t id,
+			    uint32_t verdict);
 
 extern int nfq_set_verdict_batch2(struct nfq_q_handle *qh,
-			    u_int32_t id,
-			    u_int32_t verdict,
-			    u_int32_t mark);
+			    uint32_t id,
+			    uint32_t verdict,
+			    uint32_t mark);
 
 extern __attribute__((deprecated))
 int nfq_set_verdict_mark(struct nfq_q_handle *qh, 
-			 u_int32_t id,
-			 u_int32_t verdict, 
-			 u_int32_t mark,
-			 u_int32_t datalen,
+			 uint32_t id,
+			 uint32_t verdict,
+			 uint32_t mark,
+			 uint32_t datalen,
 			 const unsigned char *buf);
 
 /* message parsing function */
@@ -94,17 +94,17 @@ int nfq_set_verdict_mark(struct nfq_q_handle *qh,
 extern struct nfqnl_msg_packet_hdr *
 				nfq_get_msg_packet_hdr(struct nfq_data *nfad);
 
-extern u_int32_t nfq_get_nfmark(struct nfq_data *nfad);
+extern uint32_t nfq_get_nfmark(struct nfq_data *nfad);
 
 extern int nfq_get_timestamp(struct nfq_data *nfad, struct timeval *tv);
 
 /* return 0 if not set */
-extern u_int32_t nfq_get_indev(struct nfq_data *nfad);
-extern u_int32_t nfq_get_physindev(struct nfq_data *nfad);
-extern u_int32_t nfq_get_outdev(struct nfq_data *nfad);
-extern u_int32_t nfq_get_physoutdev(struct nfq_data *nfad);
-extern int nfq_get_uid(struct nfq_data *nfad, u_int32_t *uid);
-extern int nfq_get_gid(struct nfq_data *nfad, u_int32_t *gid);
+extern uint32_t nfq_get_indev(struct nfq_data *nfad);
+extern uint32_t nfq_get_physindev(struct nfq_data *nfad);
+extern uint32_t nfq_get_outdev(struct nfq_data *nfad);
+extern uint32_t nfq_get_physoutdev(struct nfq_data *nfad);
+extern int nfq_get_uid(struct nfq_data *nfad, uint32_t *uid);
+extern int nfq_get_gid(struct nfq_data *nfad, uint32_t *gid);
 
 extern int nfq_get_indev_name(struct nlif_handle *nlif_handle,
 			      struct nfq_data *nfad, char *name);
diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index 740b340..76cc58e 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -123,7 +123,7 @@ struct nfq_q_handle
 {
 	struct nfq_q_handle *next;
 	struct nfq_handle *h;
-	u_int16_t id;
+	uint16_t id;
 
 	nfq_callback *cb;
 	void *data;
@@ -162,7 +162,7 @@ static void add_qh(struct nfq_q_handle *qh)
 	qh->h->qh_list = qh;
 }
 
-static struct nfq_q_handle *find_qh(struct nfq_handle *h, u_int16_t id)
+static struct nfq_q_handle *find_qh(struct nfq_handle *h, uint16_t id)
 {
 	struct nfq_q_handle *qh;
 
@@ -175,8 +175,8 @@ static struct nfq_q_handle *find_qh(struct nfq_handle *h, u_int16_t id)
 
 /* build a NFQNL_MSG_CONFIG message */
 	static int
-__build_send_cfg_msg(struct nfq_handle *h, u_int8_t command,
-		u_int16_t queuenum, u_int16_t pf)
+__build_send_cfg_msg(struct nfq_handle *h, uint8_t command,
+		uint16_t queuenum, uint16_t pf)
 {
 	union {
 		char buf[NFNL_HEADER_LEN
@@ -201,7 +201,7 @@ static int __nfq_rcv_pkt(struct nlmsghdr *nlh, struct nfattr *nfa[],
 {
 	struct nfgenmsg *nfmsg = NLMSG_DATA(nlh);
 	struct nfq_handle *h = data;
-	u_int16_t queue_num = ntohs(nfmsg->res_id);
+	uint16_t queue_num = ntohs(nfmsg->res_id);
 	struct nfq_q_handle *qh = find_qh(h, queue_num);
 	struct nfq_data nfqa;
 
@@ -461,7 +461,7 @@ EXPORT_SYMBOL(nfq_close);
  *
  * \return integer inferior to 0 in case of failure
  */
-int nfq_bind_pf(struct nfq_handle *h, u_int16_t pf)
+int nfq_bind_pf(struct nfq_handle *h, uint16_t pf)
 {
 	return __build_send_cfg_msg(h, NFQNL_CFG_CMD_PF_BIND, 0, pf);
 }
@@ -477,7 +477,7 @@ EXPORT_SYMBOL(nfq_bind_pf);
  *
  * This call is obsolete, Linux kernels from 3.8 onwards ignore it.
  */
-int nfq_unbind_pf(struct nfq_handle *h, u_int16_t pf)
+int nfq_unbind_pf(struct nfq_handle *h, uint16_t pf)
 {
 	return __build_send_cfg_msg(h, NFQNL_CFG_CMD_PF_UNBIND, 0, pf);
 }
@@ -526,7 +526,7 @@ typedef int nfq_callback(struct nfq_q_handle *qh,
  */
 
 struct nfq_q_handle *nfq_create_queue(struct nfq_handle *h, 
-		u_int16_t num,
+		uint16_t num,
 		nfq_callback *cb,
 		void *data)
 {
@@ -618,7 +618,7 @@ EXPORT_SYMBOL(nfq_handle_packet);
  * \return -1 on error; >=0 otherwise.
  */
 int nfq_set_mode(struct nfq_q_handle *qh,
-		u_int8_t mode, u_int32_t range)
+		uint8_t mode, uint32_t range)
 {
 	union {
 		char buf[NFNL_HEADER_LEN
@@ -724,14 +724,14 @@ EXPORT_SYMBOL(nfq_set_queue_flags);
  * \return -1 on error; >=0 otherwise.
  */
 int nfq_set_queue_maxlen(struct nfq_q_handle *qh,
-				u_int32_t queuelen)
+				uint32_t queuelen)
 {
 	union {
 		char buf[NFNL_HEADER_LEN
 			+NFA_LENGTH(sizeof(struct nfqnl_msg_config_params))];
 		struct nlmsghdr nmh;
 	} u;
-	u_int32_t queue_maxlen = htonl(queuelen);
+	uint32_t queue_maxlen = htonl(queuelen);
 
 	nfnl_fill_hdr(qh->h->nfnlssh, &u.nmh, 0, AF_UNSPEC, qh->id,
 			NFQNL_MSG_CONFIG, NLM_F_REQUEST|NLM_F_ACK);
@@ -747,9 +747,9 @@ EXPORT_SYMBOL(nfq_set_queue_maxlen);
  * @}
  */
 
-static int __set_verdict(struct nfq_q_handle *qh, u_int32_t id,
-		u_int32_t verdict, u_int32_t mark, int set_mark,
-		u_int32_t data_len, const unsigned char *data,
+static int __set_verdict(struct nfq_q_handle *qh, uint32_t id,
+		uint32_t verdict, uint32_t mark, int set_mark,
+		uint32_t data_len, const unsigned char *data,
 		enum nfqnl_msg_types type)
 {
 	struct nfqnl_msg_verdict_hdr vh;
@@ -828,8 +828,8 @@ static int __set_verdict(struct nfq_q_handle *qh, u_int32_t id,
  *
  * \return -1 on error; >= 0 otherwise.
  */
-int nfq_set_verdict(struct nfq_q_handle *qh, u_int32_t id,
-		u_int32_t verdict, u_int32_t data_len, 
+int nfq_set_verdict(struct nfq_q_handle *qh, uint32_t id,
+		uint32_t verdict, uint32_t data_len,
 		const unsigned char *buf)
 {
 	return __set_verdict(qh, id, verdict, 0, 0, data_len, buf,
@@ -846,9 +846,9 @@ EXPORT_SYMBOL(nfq_set_verdict);
  * \param data_len number of bytes of data pointed to by #buf
  * \param buf the buffer that contains the packet data
  */
-int nfq_set_verdict2(struct nfq_q_handle *qh, u_int32_t id,
-		     u_int32_t verdict, u_int32_t mark,
-		     u_int32_t data_len, const unsigned char *buf)
+int nfq_set_verdict2(struct nfq_q_handle *qh, uint32_t id,
+		     uint32_t verdict, uint32_t mark,
+		     uint32_t data_len, const unsigned char *buf)
 {
 	return __set_verdict(qh, id, verdict, htonl(mark), 1, data_len,
 						buf, NFQNL_MSG_VERDICT);
@@ -867,8 +867,8 @@ EXPORT_SYMBOL(nfq_set_verdict2);
  * batch support was added in Linux 3.1.
  * These functions will fail silently on older kernels.
  */
-int nfq_set_verdict_batch(struct nfq_q_handle *qh, u_int32_t id,
-					  u_int32_t verdict)
+int nfq_set_verdict_batch(struct nfq_q_handle *qh, uint32_t id,
+					  uint32_t verdict)
 {
 	return __set_verdict(qh, id, verdict, 0, 0, 0, NULL,
 					NFQNL_MSG_VERDICT_BATCH);
@@ -882,8 +882,8 @@ EXPORT_SYMBOL(nfq_set_verdict_batch);
  * \param verdict verdict to return to netfilter (NF_ACCEPT, NF_DROP)
  * \param mark mark to put on packet
  */
-int nfq_set_verdict_batch2(struct nfq_q_handle *qh, u_int32_t id,
-		     u_int32_t verdict, u_int32_t mark)
+int nfq_set_verdict_batch2(struct nfq_q_handle *qh, uint32_t id,
+		     uint32_t verdict, uint32_t mark)
 {
 	return __set_verdict(qh, id, verdict, htonl(mark), 1, 0,
 				NULL, NFQNL_MSG_VERDICT_BATCH);
@@ -904,9 +904,9 @@ EXPORT_SYMBOL(nfq_set_verdict_batch2);
  * This function is deprecated since it is broken, its use is highly
  * discouraged. Please, use nfq_set_verdict2 instead.
  */
-int nfq_set_verdict_mark(struct nfq_q_handle *qh, u_int32_t id,
-		u_int32_t verdict, u_int32_t mark,
-		u_int32_t data_len, const unsigned char *buf)
+int nfq_set_verdict_mark(struct nfq_q_handle *qh, uint32_t id,
+		uint32_t verdict, uint32_t mark,
+		uint32_t data_len, const unsigned char *buf)
 {
 	return __set_verdict(qh, id, verdict, mark, 1, data_len, buf,
 						NFQNL_MSG_VERDICT);
@@ -940,9 +940,9 @@ EXPORT_SYMBOL(nfq_set_verdict_mark);
  *
  * \verbatim
 	struct nfqnl_msg_packet_hdr {
-		u_int32_t	packet_id;	// unique ID of packet in queue
-		u_int16_t	hw_protocol;	// hw protocol (network order)
-		u_int8_t	hook;		// netfilter hook
+		uint32_t	packet_id;	// unique ID of packet in queue
+		uint16_t	hw_protocol;	// hw protocol (network order)
+		uint8_t	hook;		// netfilter hook
 	} __attribute__ ((packed));
 \endverbatim
  */
@@ -961,7 +961,7 @@ EXPORT_SYMBOL(nfq_get_msg_packet_hdr);
  */
 uint32_t nfq_get_nfmark(struct nfq_data *nfad)
 {
-	return ntohl(nfnl_get_data(nfad->data, NFQA_MARK, u_int32_t));
+	return ntohl(nfnl_get_data(nfad->data, NFQA_MARK, uint32_t));
 }
 EXPORT_SYMBOL(nfq_get_nfmark);
 
@@ -1000,9 +1000,9 @@ EXPORT_SYMBOL(nfq_get_timestamp);
  * \warning all nfq_get_dev() functions return 0 if not set, since linux
  * only allows ifindex >= 1, see net/core/dev.c:2600  (in 2.6.13.1)
  */
-u_int32_t nfq_get_indev(struct nfq_data *nfad)
+uint32_t nfq_get_indev(struct nfq_data *nfad)
 {
-	return ntohl(nfnl_get_data(nfad->data, NFQA_IFINDEX_INDEV, u_int32_t));
+	return ntohl(nfnl_get_data(nfad->data, NFQA_IFINDEX_INDEV, uint32_t));
 }
 EXPORT_SYMBOL(nfq_get_indev);
 
@@ -1014,9 +1014,9 @@ EXPORT_SYMBOL(nfq_get_indev);
  * If the returned index is 0, the packet was locally generated or the
  * physical input interface is no longer known (ie. POSTROUTING?).
  */
-u_int32_t nfq_get_physindev(struct nfq_data *nfad)
+uint32_t nfq_get_physindev(struct nfq_data *nfad)
 {
-	return ntohl(nfnl_get_data(nfad->data, NFQA_IFINDEX_PHYSINDEV, u_int32_t));
+	return ntohl(nfnl_get_data(nfad->data, NFQA_IFINDEX_PHYSINDEV, uint32_t));
 }
 EXPORT_SYMBOL(nfq_get_physindev);
 
@@ -1028,9 +1028,9 @@ EXPORT_SYMBOL(nfq_get_physindev);
  * returned index is 0, the packet is destined for localhost or the output
  * interface is not yet known (ie. PREROUTING?).
  */
-u_int32_t nfq_get_outdev(struct nfq_data *nfad)
+uint32_t nfq_get_outdev(struct nfq_data *nfad)
 {
-	return ntohl(nfnl_get_data(nfad->data, NFQA_IFINDEX_OUTDEV, u_int32_t));
+	return ntohl(nfnl_get_data(nfad->data, NFQA_IFINDEX_OUTDEV, uint32_t));
 }
 EXPORT_SYMBOL(nfq_get_outdev);
 
@@ -1044,9 +1044,9 @@ EXPORT_SYMBOL(nfq_get_outdev);
  * 
  * \return The index of physical interface that the packet output will be routed out.
  */
-u_int32_t nfq_get_physoutdev(struct nfq_data *nfad)
+uint32_t nfq_get_physoutdev(struct nfq_data *nfad)
 {
-	return ntohl(nfnl_get_data(nfad->data, NFQA_IFINDEX_PHYSOUTDEV, u_int32_t));
+	return ntohl(nfnl_get_data(nfad->data, NFQA_IFINDEX_PHYSOUTDEV, uint32_t));
 }
 EXPORT_SYMBOL(nfq_get_physoutdev);
 
@@ -1091,7 +1091,7 @@ EXPORT_SYMBOL(nfq_get_physoutdev);
 int nfq_get_indev_name(struct nlif_handle *nlif_handle,
 			struct nfq_data *nfad, char *name)
 {
-	u_int32_t ifindex = nfq_get_indev(nfad);
+	uint32_t ifindex = nfq_get_indev(nfad);
 	return nlif_index2name(nlif_handle, ifindex, name);
 }
 EXPORT_SYMBOL(nfq_get_indev_name);
@@ -1111,7 +1111,7 @@ EXPORT_SYMBOL(nfq_get_indev_name);
 int nfq_get_physindev_name(struct nlif_handle *nlif_handle,
 			   struct nfq_data *nfad, char *name)
 {
-	u_int32_t ifindex = nfq_get_physindev(nfad);
+	uint32_t ifindex = nfq_get_physindev(nfad);
 	return nlif_index2name(nlif_handle, ifindex, name);
 }
 EXPORT_SYMBOL(nfq_get_physindev_name);
@@ -1131,7 +1131,7 @@ EXPORT_SYMBOL(nfq_get_physindev_name);
 int nfq_get_outdev_name(struct nlif_handle *nlif_handle,
 			struct nfq_data *nfad, char *name)
 {
-	u_int32_t ifindex = nfq_get_outdev(nfad);
+	uint32_t ifindex = nfq_get_outdev(nfad);
 	return nlif_index2name(nlif_handle, ifindex, name);
 }
 EXPORT_SYMBOL(nfq_get_outdev_name);
@@ -1152,7 +1152,7 @@ EXPORT_SYMBOL(nfq_get_outdev_name);
 int nfq_get_physoutdev_name(struct nlif_handle *nlif_handle,
 			    struct nfq_data *nfad, char *name)
 {
-	u_int32_t ifindex = nfq_get_physoutdev(nfad);
+	uint32_t ifindex = nfq_get_physoutdev(nfad);
 	return nlif_index2name(nlif_handle, ifindex, name);
 }
 EXPORT_SYMBOL(nfq_get_physoutdev_name);
@@ -1173,9 +1173,9 @@ EXPORT_SYMBOL(nfq_get_physoutdev_name);
  * The nfqnl_msg_packet_hw structure is defined in libnetfilter_queue.h as:
  * \verbatim
 	struct nfqnl_msg_packet_hw {
-		u_int16_t	hw_addrlen;
-		u_int16_t	_pad;
-		u_int8_t	hw_addr[8];
+		uint16_t	hw_addrlen;
+		uint16_t	_pad;
+		uint8_t	hw_addr[8];
 	} __attribute__ ((packed));
 \endverbatim
  */
@@ -1192,12 +1192,12 @@ EXPORT_SYMBOL(nfq_get_packet_hw);
  *
  * \return 1 if there is a UID available, 0 otherwise.
  */
-int nfq_get_uid(struct nfq_data *nfad, u_int32_t *uid)
+int nfq_get_uid(struct nfq_data *nfad, uint32_t *uid)
 {
 	if (!nfnl_attr_present(nfad->data, NFQA_UID))
 		return 0;
 
-	*uid = ntohl(nfnl_get_data(nfad->data, NFQA_UID, u_int32_t));
+	*uid = ntohl(nfnl_get_data(nfad->data, NFQA_UID, uint32_t));
 	return 1;
 }
 EXPORT_SYMBOL(nfq_get_uid);
@@ -1208,12 +1208,12 @@ EXPORT_SYMBOL(nfq_get_uid);
  *
  * \return 1 if there is a GID available, 0 otherwise.
  */
-int nfq_get_gid(struct nfq_data *nfad, u_int32_t *gid)
+int nfq_get_gid(struct nfq_data *nfad, uint32_t *gid)
 {
 	if (!nfnl_attr_present(nfad->data, NFQA_GID))
 		return 0;
 
-	*gid = ntohl(nfnl_get_data(nfad->data, NFQA_GID, u_int32_t));
+	*gid = ntohl(nfnl_get_data(nfad->data, NFQA_GID, uint32_t));
 	return 1;
 }
 EXPORT_SYMBOL(nfq_get_gid);
@@ -1287,8 +1287,8 @@ int nfq_snprintf_xml(char *buf, size_t rem, struct nfq_data *tb, int flags)
 {
 	struct nfqnl_msg_packet_hdr *ph;
 	struct nfqnl_msg_packet_hw *hwph;
-	u_int32_t mark, ifi;
-	u_int32_t uid, gid;
+	uint32_t mark, ifi;
+	uint32_t uid, gid;
 	int size, offset = 0, len = 0, ret;
 	unsigned char *data;
 
diff --git a/utils/nfqnl_test.c b/utils/nfqnl_test.c
index 2176a61..b760cf0 100644
--- a/utils/nfqnl_test.c
+++ b/utils/nfqnl_test.c
@@ -10,12 +10,12 @@
 #include <libnetfilter_queue/libnetfilter_queue.h>
 
 /* returns packet id */
-static u_int32_t print_pkt (struct nfq_data *tb)
+static uint32_t print_pkt (struct nfq_data *tb)
 {
 	int id = 0;
 	struct nfqnl_msg_packet_hdr *ph;
 	struct nfqnl_msg_packet_hw *hwph;
-	u_int32_t mark, ifi, uid, gid;
+	uint32_t mark, ifi, uid, gid;
 	int ret;
 	unsigned char *data;
 
@@ -74,7 +74,7 @@ static u_int32_t print_pkt (struct nfq_data *tb)
 static int cb(struct nfq_q_handle *qh, struct nfgenmsg *nfmsg,
 	      struct nfq_data *nfa, void *data)
 {
-	u_int32_t id = print_pkt(nfa);
+	uint32_t id = print_pkt(nfa);
 	printf("entering callback\n");
 	return nfq_set_verdict(qh, id, NF_ACCEPT, 0, NULL);
 }
-- 
2.3.6
