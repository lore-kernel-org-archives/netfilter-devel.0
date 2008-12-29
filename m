From: Eric Leblond <eric@inl.fr>
Subject: [libnetfilter_log 1/3] Suppress reference to libnetfilter_queue which is the model of libnetfilter_log.
Date: Mon, 29 Dec 2008 22:33:22 +0100
Message-ID: <1230586404-24639-2-git-send-email-eric@inl.fr>
References: <1230586404-24639-1-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:43347 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752944AbYL2Vdc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Dec 2008 16:33:32 -0500
In-Reply-To: <1230586404-24639-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fixes the description of the file was the one of libnetfilter_queue.c
and it suppresses indication through out the file that it is a copy of the queue
module.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 src/libnetfilter_log.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/src/libnetfilter_log.c b/src/libnetfilter_log.c
index 216cdb8..ed92561 100644
--- a/src/libnetfilter_log.c
+++ b/src/libnetfilter_log.c
@@ -1,4 +1,4 @@
-/* libnfqnetlink.c: generic library for access to nf_queue
+/* libnetfilter_log.c: generic library for access to NFLOG
  *
  * (C) 2005 by Harald Welte <laforge@gnumonks.org>
  *
@@ -104,7 +104,7 @@ static int __nflog_rcv_cmd(struct nlmsghdr *nlh, struct nfattr *nfa[],
 /* build a NFULNL_MSG_CONFIG message */
 static int
 __build_send_cfg_msg(struct nflog_handle *h, u_int8_t command,
-		     u_int16_t queuenum, u_int8_t pf)
+		     u_int16_t groupnum, u_int8_t pf)
 {
 	union {
 		char buf[NFNL_HEADER_LEN
@@ -113,7 +113,7 @@ __build_send_cfg_msg(struct nflog_handle *h, u_int8_t command,
 	} u;
 	struct nfulnl_msg_config_cmd cmd;
 
-	nfnl_fill_hdr(h->nfnlssh, &u.nmh, 0, pf, queuenum,
+	nfnl_fill_hdr(h->nfnlssh, &u.nmh, 0, pf, groupnum,
 		      NFULNL_MSG_CONFIG, NLM_F_REQUEST|NLM_F_ACK);
 
 	cmd.command = command;
@@ -242,19 +242,19 @@ int nflog_close(struct nflog_handle *h)
 	return ret;
 }
 
-/* bind nf_queue from a specific protocol family */
+/* bind nf_log from a specific protocol family */
 int nflog_bind_pf(struct nflog_handle *h, u_int16_t pf)
 {
 	return __build_send_cfg_msg(h, NFULNL_CFG_CMD_PF_BIND, 0, pf);
 }
 
-/* unbind nf_queue from a specific protocol family */
+/* unbind nf_log from a specific protocol family */
 int nflog_unbind_pf(struct nflog_handle *h, u_int16_t pf)
 {
 	return __build_send_cfg_msg(h, NFULNL_CFG_CMD_PF_UNBIND, 0, pf);
 }
 
-/* bind this socket to a specific queue number */
+/* bind this socket to a specific group number */
 struct nflog_g_handle *
 nflog_bind_group(struct nflog_handle *h, u_int16_t num)
 {
@@ -280,7 +280,7 @@ nflog_bind_group(struct nflog_handle *h, u_int16_t num)
 	return gh;
 }
 
-/* unbind this socket from a specific queue number */
+/* unbind this socket from a specific group number */
 int nflog_unbind_group(struct nflog_g_handle *gh)
 {
 	int ret = __build_send_cfg_msg(gh->h, NFULNL_CFG_CMD_UNBIND, gh->id, 0);
-- 
1.5.6.3

