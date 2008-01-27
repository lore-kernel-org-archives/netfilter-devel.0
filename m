From: "Silvester Erdeg" <slipszi@gmail.com>
Subject: [PATCH] libnetfilter_queue: align the buffer passed to nfnl_fill_hdr
Date: Sun, 27 Jan 2008 22:37:18 +0100
Message-ID: <ac67d9130801271337s562eebabt7b7332a5f14b9a82@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.189]:40862 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754929AbYA0VhV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Jan 2008 16:37:21 -0500
Received: by rv-out-0910.google.com with SMTP id k20so1477418rvb.1
        for <netfilter-devel@vger.kernel.org>; Sun, 27 Jan 2008 13:37:18 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The buffer passed to nfnl_fill_hdr needs to aligned because some
architectures (e.g. ARM) cannot do proper 32-bit read/writes on
unaligned addresses. This patch solves this for libnetfilter_queue.

Signed-off-by: Szilveszter Ordog <slipszi@gmail.com>

diff -uNpr libnetfilter_queue-0.0.15-orig/src/libnetfilter_queue.c
libnetfilter_queue-0.0.15/src/libnetfilter_queue.c
--- libnetfilter_queue-0.0.15-orig/src/libnetfilter_queue.c	2007-03-22
00:49:46.000000000 +0100
+++ libnetfilter_queue-0.0.15/src/libnetfilter_queue.c	2008-01-08
14:50:53.000000000 +0100
@@ -98,7 +98,7 @@ __build_send_cfg_msg(struct nfq_handle *
 		u_int16_t queuenum, u_int16_t pf)
 {
 	char buf[NFNL_HEADER_LEN
-		+NFA_LENGTH(sizeof(struct nfqnl_msg_config_cmd))];
+		+NFA_LENGTH(sizeof(struct nfqnl_msg_config_cmd))] __attribute__((aligned));
 	struct nfqnl_msg_config_cmd cmd;
 	struct nlmsghdr *nmh = (struct nlmsghdr *) buf;

@@ -273,7 +273,7 @@ int nfq_set_mode(struct nfq_q_handle *qh
 		u_int8_t mode, u_int32_t range)
 {
 	char buf[NFNL_HEADER_LEN
-		+NFA_LENGTH(sizeof(struct nfqnl_msg_config_params))];
+		+NFA_LENGTH(sizeof(struct nfqnl_msg_config_params))]
__attribute__((aligned));
 	struct nfqnl_msg_config_params params;
 	struct nlmsghdr *nmh = (struct nlmsghdr *) buf;

@@ -292,7 +292,7 @@ int nfq_set_queue_maxlen(struct nfq_q_ha
 				u_int32_t queuelen)
 {
 	char buf[NFNL_HEADER_LEN
-		+NFA_LENGTH(sizeof(struct nfqnl_msg_config_params))];
+		+NFA_LENGTH(sizeof(struct nfqnl_msg_config_params))]
__attribute__((aligned));
 	u_int32_t queue_maxlen = htonl(queuelen);
 	struct nlmsghdr *nmh = (struct nlmsghdr *) buf;

@@ -312,7 +312,7 @@ static int __set_verdict(struct nfq_q_ha
 	struct nfqnl_msg_verdict_hdr vh;
 	char buf[NFNL_HEADER_LEN
 		+NFA_LENGTH(sizeof(mark))
-		+NFA_LENGTH(sizeof(vh))];
+		+NFA_LENGTH(sizeof(vh))] __attribute__((aligned));
 	struct nlmsghdr *nmh = (struct nlmsghdr *) buf;

 	struct iovec iov[3];
