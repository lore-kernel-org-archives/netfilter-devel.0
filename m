From: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Subject: [PATCH] libnetfilter-queue byte alignment
Date: Mon, 23 Jun 2008 13:43:47 +0100
Message-ID: <1214225027.12564.4.camel@pumper.lan.luxnet.ch>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:38583 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752683AbYFWMnw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Jun 2008 08:43:52 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The same byte alignment issues as they have been fixed in
libnetfilter-conntrack and libnetfilter-log exist also in
libnetfilter-queue.

This patch uses a union of the char buffer and message header to ensure
proper byte alignment and make it more portable.

Signed-off-by: Fabian Hugelshofer <hugelshofer2006@gmx.ch>

diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index ef638d6..d319b7b 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -97,19 +97,21 @@ static struct nfq_q_handle *find_qh(struct nfq_handle *h, u_int16_t id)
 __build_send_cfg_msg(struct nfq_handle *h, u_int8_t command,
 		u_int16_t queuenum, u_int16_t pf)
 {
-	char buf[NFNL_HEADER_LEN
-		+NFA_LENGTH(sizeof(struct nfqnl_msg_config_cmd))];
+	union {
+		char buf[NFNL_HEADER_LEN
+			+NFA_LENGTH(sizeof(struct nfqnl_msg_config_cmd))];
+		struct nlmsghdr nmh;
+	} u;
 	struct nfqnl_msg_config_cmd cmd;
-	struct nlmsghdr *nmh = (struct nlmsghdr *) buf;
 
-	nfnl_fill_hdr(h->nfnlssh, nmh, 0, AF_UNSPEC, queuenum,
+	nfnl_fill_hdr(h->nfnlssh, &u.nmh, 0, AF_UNSPEC, queuenum,
 			NFQNL_MSG_CONFIG, NLM_F_REQUEST|NLM_F_ACK);
 
 	cmd.command = command;
 	cmd.pf = htons(pf);
-	nfnl_addattr_l(nmh, sizeof(buf), NFQA_CFG_CMD, &cmd, sizeof(cmd));
+	nfnl_addattr_l(&u.nmh, sizeof(u), NFQA_CFG_CMD, &cmd, sizeof(cmd));
 
-	return nfnl_talk(h->nfnlh, nmh, 0, 0, NULL, NULL, NULL);
+	return nfnl_talk(h->nfnlh, &u.nmh, 0, 0, NULL, NULL, NULL);
 }
 
 static int __nfq_rcv_pkt(struct nlmsghdr *nlh, struct nfattr *nfa[],
@@ -272,37 +274,41 @@ int nfq_handle_packet(struct nfq_handle *h, char *buf, int len)
 int nfq_set_mode(struct nfq_q_handle *qh,
 		u_int8_t mode, u_int32_t range)
 {
-	char buf[NFNL_HEADER_LEN
-		+NFA_LENGTH(sizeof(struct nfqnl_msg_config_params))];
+	union {
+		char buf[NFNL_HEADER_LEN
+			+NFA_LENGTH(sizeof(struct nfqnl_msg_config_params))];
+		struct nlmsghdr nmh;
+	} u;
 	struct nfqnl_msg_config_params params;
-	struct nlmsghdr *nmh = (struct nlmsghdr *) buf;
 
-	nfnl_fill_hdr(qh->h->nfnlssh, nmh, 0, AF_UNSPEC, qh->id,
+	nfnl_fill_hdr(qh->h->nfnlssh, &u.nmh, 0, AF_UNSPEC, qh->id,
 			NFQNL_MSG_CONFIG, NLM_F_REQUEST|NLM_F_ACK);
 
 	params.copy_range = htonl(range);
 	params.copy_mode = mode;
-	nfnl_addattr_l(nmh, sizeof(buf), NFQA_CFG_PARAMS, &params,
+	nfnl_addattr_l(&u.nmh, sizeof(u), NFQA_CFG_PARAMS, &params,
 			sizeof(params));
 
-	return nfnl_talk(qh->h->nfnlh, nmh, 0, 0, NULL, NULL, NULL);
+	return nfnl_talk(qh->h->nfnlh, &u.nmh, 0, 0, NULL, NULL, NULL);
 }
 
 int nfq_set_queue_maxlen(struct nfq_q_handle *qh,
 				u_int32_t queuelen)
 {
-	char buf[NFNL_HEADER_LEN
-		+NFA_LENGTH(sizeof(struct nfqnl_msg_config_params))];
+	union {
+		char buf[NFNL_HEADER_LEN
+			+NFA_LENGTH(sizeof(struct nfqnl_msg_config_params))];
+		struct nlmsghdr nmh;
+	} u;
 	u_int32_t queue_maxlen = htonl(queuelen);
-	struct nlmsghdr *nmh = (struct nlmsghdr *) buf;
 
-	nfnl_fill_hdr(qh->h->nfnlssh, nmh, 0, AF_UNSPEC, qh->id,
+	nfnl_fill_hdr(qh->h->nfnlssh, &u.nmh, 0, AF_UNSPEC, qh->id,
 			NFQNL_MSG_CONFIG, NLM_F_REQUEST|NLM_F_ACK);
 
-	nfnl_addattr_l(nmh, sizeof(buf), NFQA_CFG_QUEUE_MAXLEN, &queue_maxlen,
+	nfnl_addattr_l(&u.nmh, sizeof(u), NFQA_CFG_QUEUE_MAXLEN, &queue_maxlen,
 			sizeof(queue_maxlen));
 
-	return nfnl_talk(qh->h->nfnlh, nmh, 0, 0, NULL, NULL, NULL);
+	return nfnl_talk(qh->h->nfnlh, &u.nmh, 0, 0, NULL, NULL, NULL);
 }
 
 static int __set_verdict(struct nfq_q_handle *qh, u_int32_t id,
@@ -310,10 +316,12 @@ static int __set_verdict(struct nfq_q_handle *qh, u_int32_t id,
 		u_int32_t data_len, unsigned char *data)
 {
 	struct nfqnl_msg_verdict_hdr vh;
-	char buf[NFNL_HEADER_LEN
-		+NFA_LENGTH(sizeof(mark))
-		+NFA_LENGTH(sizeof(vh))];
-	struct nlmsghdr *nmh = (struct nlmsghdr *) buf;
+	union {
+		char buf[NFNL_HEADER_LEN
+			+NFA_LENGTH(sizeof(mark))
+			+NFA_LENGTH(sizeof(vh))];
+		struct nlmsghdr nmh;
+	} u;
 
 	struct iovec iov[3];
 	int nvecs;
@@ -327,17 +335,17 @@ static int __set_verdict(struct nfq_q_handle *qh, u_int32_t id,
 	vh.verdict = htonl(verdict);
 	vh.id = htonl(id);
 
-	nfnl_fill_hdr(qh->h->nfnlssh, nmh, 0, AF_UNSPEC, qh->id,
+	nfnl_fill_hdr(qh->h->nfnlssh, &u.nmh, 0, AF_UNSPEC, qh->id,
 			NFQNL_MSG_VERDICT, NLM_F_REQUEST);
 
 	/* add verdict header */
-	nfnl_addattr_l(nmh, sizeof(buf), NFQA_VERDICT_HDR, &vh, sizeof(vh));
+	nfnl_addattr_l(&u.nmh, sizeof(u), NFQA_VERDICT_HDR, &vh, sizeof(vh));
 
 	if (set_mark)
-		nfnl_addattr32(nmh, sizeof(buf), NFQA_MARK, mark);
+		nfnl_addattr32(&u.nmh, sizeof(u), NFQA_MARK, mark);
 
-	iov[0].iov_base = nmh;
-	iov[0].iov_len = NLMSG_TAIL(nmh) - (void *)nmh;
+	iov[0].iov_base = &u.nmh;
+	iov[0].iov_len = NLMSG_TAIL(&u.nmh) - (void *)&u.nmh;
 	nvecs = 1;
 
 	if (data_len) {
@@ -348,7 +356,7 @@ static int __set_verdict(struct nfq_q_handle *qh, u_int32_t id,
 		 * header.  The size of the attribute is given in the
 		 * nfa_len field and is set in the nfnl_build_nfa_iovec()
 		 * function. */
-		nmh->nlmsg_len += data_attr.nfa_len;
+		u.nmh.nlmsg_len += data_attr.nfa_len;
 	}
 
 	return nfnl_sendiov(qh->h->nfnlh, iov, nvecs, 0);
diff --git a/utils/nfqnl_test.c b/utils/nfqnl_test.c
index be72974..7e4edab 100644
--- a/utils/nfqnl_test.c
+++ b/utils/nfqnl_test.c
@@ -61,7 +61,7 @@ int main(int argc, char **argv)
 	struct nfnl_handle *nh;
 	int fd;
 	int rv;
-	char buf[4096];
+	char buf[4096] __attribute__ ((aligned));
 
 	printf("opening library handle\n");
 	h = nfq_open();


