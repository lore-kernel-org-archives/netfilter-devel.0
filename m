From: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Subject: Re: [PATCH 2/3] libnetlink-log byte alignment
Date: Mon, 16 Jun 2008 21:32:35 +0100
Message-ID: <1213648356.29727.12.camel@pumper.lan.luxnet.ch>
References: <1212488472.29489.41.camel@pumper.lan.luxnet.ch>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:33874 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751556AbYFPUcr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Jun 2008 16:32:47 -0400
In-Reply-To: <1212488472.29489.41.camel@pumper.lan.luxnet.ch>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use union of char buffer and message header to ensure proper byte
alignment.

This patch increases portability, but alignment is still not respected
in nflog_get_*() which still leaves libnetfilter_log unusable on
particular platforms.

Signed-off-by: Fabian Hugelshofer <hugelshofer2006@gmx.ch>

diff --git a/src/libnetfilter_log.c b/src/libnetfilter_log.c
index a3bd435..2019b0c 100644
--- a/src/libnetfilter_log.c
+++ b/src/libnetfilter_log.c
@@ -106,18 +106,20 @@ static int
 __build_send_cfg_msg(struct nflog_handle *h, u_int8_t command,
 		     u_int16_t queuenum, u_int8_t pf)
 {
-	char buf[NFNL_HEADER_LEN
-		+NFA_LENGTH(sizeof(struct nfulnl_msg_config_cmd))];
+	union {
+		char buf[NFNL_HEADER_LEN
+			+NFA_LENGTH(sizeof(struct nfulnl_msg_config_cmd))];
+		struct nlmsghdr nmh;
+	} u;
 	struct nfulnl_msg_config_cmd cmd;
-	struct nlmsghdr *nmh = (struct nlmsghdr *) buf;
 
-	nfnl_fill_hdr(h->nfnlssh, nmh, 0, pf, queuenum,
+	nfnl_fill_hdr(h->nfnlssh, &u.nmh, 0, pf, queuenum,
 		      NFULNL_MSG_CONFIG, NLM_F_REQUEST|NLM_F_ACK);
 
 	cmd.command = command;
-	nfnl_addattr_l(nmh, sizeof(buf), NFULA_CFG_CMD, &cmd, sizeof(cmd));
+	nfnl_addattr_l(&u.nmh, sizeof(u), NFULA_CFG_CMD, &cmd, sizeof(cmd));
 
-	return nfnl_talk(h->nfnlh, nmh, 0, 0, NULL, NULL, NULL);
+	return nfnl_talk(h->nfnlh, &u.nmh, 0, 0, NULL, NULL, NULL);
 }
 
 static int __nflog_rcv_pkt(struct nlmsghdr *nlh, struct nfattr *nfa[],
@@ -291,60 +293,68 @@ int nflog_unbind_group(struct nflog_g_handle *gh)
 int nflog_set_mode(struct nflog_g_handle *gh,
 		   u_int8_t mode, u_int32_t range)
 {
-	char buf[NFNL_HEADER_LEN
-		+NFA_LENGTH(sizeof(struct nfulnl_msg_config_mode))];
+	union {
+		char buf[NFNL_HEADER_LEN
+			+NFA_LENGTH(sizeof(struct nfulnl_msg_config_mode))];
+		struct nlmsghdr nmh;
+	} u;
 	struct nfulnl_msg_config_mode params;
-	struct nlmsghdr *nmh = (struct nlmsghdr *) buf;
 
-	nfnl_fill_hdr(gh->h->nfnlssh, nmh, 0, AF_UNSPEC, gh->id,
+	nfnl_fill_hdr(gh->h->nfnlssh, &u.nmh, 0, AF_UNSPEC, gh->id,
 		      NFULNL_MSG_CONFIG, NLM_F_REQUEST|NLM_F_ACK);
 
 	params.copy_range = htonl(range);	/* copy_range is short */
 	params.copy_mode = mode;
-	nfnl_addattr_l(nmh, sizeof(buf), NFULA_CFG_MODE, &params,
+	nfnl_addattr_l(&u.nmh, sizeof(u), NFULA_CFG_MODE, &params,
 		       sizeof(params));
 
-	return nfnl_talk(gh->h->nfnlh, nmh, 0, 0, NULL, NULL, NULL);
+	return nfnl_talk(gh->h->nfnlh, &u.nmh, 0, 0, NULL, NULL, NULL);
 }
 
 int nflog_set_timeout(struct nflog_g_handle *gh, u_int32_t timeout)
 {
-	char buf[NFNL_HEADER_LEN+NFA_LENGTH(sizeof(u_int32_t))];
-	struct nlmsghdr *nmh = (struct nlmsghdr *) buf;
+	union {
+		char buf[NFNL_HEADER_LEN+NFA_LENGTH(sizeof(u_int32_t))];
+		struct nlmsghdr nmh;
+	} u;
 
-	nfnl_fill_hdr(gh->h->nfnlssh, nmh, 0, AF_UNSPEC, gh->id,
+	nfnl_fill_hdr(gh->h->nfnlssh, &u.nmh, 0, AF_UNSPEC, gh->id,
 		      NFULNL_MSG_CONFIG, NLM_F_REQUEST|NLM_F_ACK);
 
-	nfnl_addattr32(nmh, sizeof(buf), NFULA_CFG_TIMEOUT, htonl(timeout));
+	nfnl_addattr32(&u.nmh, sizeof(u), NFULA_CFG_TIMEOUT, htonl(timeout));
 
-	return nfnl_talk(gh->h->nfnlh, nmh, 0, 0, NULL, NULL, NULL);
+	return nfnl_talk(gh->h->nfnlh, &u.nmh, 0, 0, NULL, NULL, NULL);
 }
 
 int nflog_set_qthresh(struct nflog_g_handle *gh, u_int32_t qthresh)
 {
-	char buf[NFNL_HEADER_LEN+NFA_LENGTH(sizeof(u_int32_t))];
-	struct nlmsghdr *nmh = (struct nlmsghdr *) buf;
+	union {
+		char buf[NFNL_HEADER_LEN+NFA_LENGTH(sizeof(u_int32_t))];
+		struct nlmsghdr nmh;
+	} u;
 
-	nfnl_fill_hdr(gh->h->nfnlssh, nmh, 0, AF_UNSPEC, gh->id,
+	nfnl_fill_hdr(gh->h->nfnlssh, &u.nmh, 0, AF_UNSPEC, gh->id,
 		      NFULNL_MSG_CONFIG, NLM_F_REQUEST|NLM_F_ACK);
 
-	nfnl_addattr32(nmh, sizeof(buf), NFULA_CFG_QTHRESH, htonl(qthresh));
+	nfnl_addattr32(&u.nmh, sizeof(u), NFULA_CFG_QTHRESH, htonl(qthresh));
 
-	return nfnl_talk(gh->h->nfnlh, nmh, 0, 0, NULL, NULL, NULL);
+	return nfnl_talk(gh->h->nfnlh, &u.nmh, 0, 0, NULL, NULL, NULL);
 }
 
 int nflog_set_nlbufsiz(struct nflog_g_handle *gh, u_int32_t nlbufsiz)
 {
-	char buf[NFNL_HEADER_LEN+NFA_LENGTH(sizeof(u_int32_t))];
-	struct nlmsghdr *nmh = (struct nlmsghdr *) buf;
+	union {
+		char buf[NFNL_HEADER_LEN+NFA_LENGTH(sizeof(u_int32_t))];
+		struct nlmsghdr nmh;
+	} u;
 	int status;
 
-	nfnl_fill_hdr(gh->h->nfnlssh, nmh, 0, AF_UNSPEC, gh->id,
+	nfnl_fill_hdr(gh->h->nfnlssh, &u.nmh, 0, AF_UNSPEC, gh->id,
 		      NFULNL_MSG_CONFIG, NLM_F_REQUEST|NLM_F_ACK);
 
-	nfnl_addattr32(nmh, sizeof(buf), NFULA_CFG_NLBUFSIZ, htonl(nlbufsiz));
+	nfnl_addattr32(&u.nmh, sizeof(u), NFULA_CFG_NLBUFSIZ, htonl(nlbufsiz));
 
-	status = nfnl_talk(gh->h->nfnlh, nmh, 0, 0, NULL, NULL, NULL);
+	status = nfnl_talk(gh->h->nfnlh, &u.nmh, 0, 0, NULL, NULL, NULL);
 
 	/* we try to have space for at least 10 messages in the socket buffer */
 	if (status >= 0)
@@ -355,15 +365,17 @@ int nflog_set_nlbufsiz(struct nflog_g_handle *gh, u_int32_t nlbufsiz)
 
 int nflog_set_flags(struct nflog_g_handle *gh, u_int16_t flags)
 {
-	char buf[NFNL_HEADER_LEN+NFA_LENGTH(sizeof(u_int16_t))];
-	struct nlmsghdr *nmh = (struct nlmsghdr *) buf;
+	union {
+		char buf[NFNL_HEADER_LEN+NFA_LENGTH(sizeof(u_int16_t))];
+		struct nlmsghdr nmh;
+	} u;
 
-	nfnl_fill_hdr(gh->h->nfnlssh, nmh, 0, AF_UNSPEC, gh->id,
+	nfnl_fill_hdr(gh->h->nfnlssh, &u.nmh, 0, AF_UNSPEC, gh->id,
 		      NFULNL_MSG_CONFIG, NLM_F_REQUEST|NLM_F_ACK);
 
-	nfnl_addattr16(nmh, sizeof(buf), NFULA_CFG_FLAGS, htons(flags));
+	nfnl_addattr16(&u.nmh, sizeof(u), NFULA_CFG_FLAGS, htons(flags));
 
-	return nfnl_talk(gh->h->nfnlh, nmh, 0, 0, NULL, NULL, NULL);
+	return nfnl_talk(gh->h->nfnlh, &u.nmh, 0, 0, NULL, NULL, NULL);
 }
 
 


