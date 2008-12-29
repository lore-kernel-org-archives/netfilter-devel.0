From: Eric Leblond <eric@inl.fr>
Subject: [libnetfilter_log 3/3] Suppress NFULNL_MSG_CONFIG callback registration.
Date: Mon, 29 Dec 2008 22:33:24 +0100
Message-ID: <1230586404-24639-4-git-send-email-eric@inl.fr>
References: <1230586404-24639-1-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:43345 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752883AbYL2Vdc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Dec 2008 16:33:32 -0500
In-Reply-To: <1230586404-24639-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It seems there is no NFULNL_MSG_CONFIG message send from kernel space to
userspace. Thus the registration of an nfnetlink callback for this type
of messages is not necessary.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 src/libnetfilter_log.c |   20 --------------------
 1 files changed, 0 insertions(+), 20 deletions(-)

diff --git a/src/libnetfilter_log.c b/src/libnetfilter_log.c
index 9343f90..2bbc875 100644
--- a/src/libnetfilter_log.c
+++ b/src/libnetfilter_log.c
@@ -92,15 +92,6 @@ static struct nflog_g_handle *find_gh(struct nflog_handle *h, u_int16_t group)
 	return NULL;
 }
 
-static int __nflog_rcv_cmd(struct nlmsghdr *nlh, struct nfattr *nfa[],
-			    void *data)
-{
-	/* struct nflog_handle *h = data; */
-
-	/* FIXME: implement this */
-	return 0;
-}
-
 /* build a NFULNL_MSG_CONFIG message */
 static int
 __build_send_cfg_msg(struct nflog_handle *h, u_int8_t command,
@@ -141,11 +132,6 @@ static int __nflog_rcv_pkt(struct nlmsghdr *nlh, struct nfattr *nfa[],
 	return gh->cb(gh, nfmsg, &nfldata, gh->data);
 }
 
-static struct nfnl_callback cmd_cb = {
-	.call 		= &__nflog_rcv_cmd,
-	.attr_count 	= NFULA_CFG_MAX,
-};
-
 static struct nfnl_callback pkt_cb = {
 	.call 		= &__nflog_rcv_pkt,
 	.attr_count 	= NFULA_MAX,
@@ -182,12 +168,6 @@ struct nflog_handle *nflog_open_nfnl(struct nfnl_handle *nfnlh)
 		goto out_free;
 	}
 
-	cmd_cb.data = h;
-	err = nfnl_callback_register(h->nfnlssh, NFULNL_MSG_CONFIG, &cmd_cb);
-	if (err < 0) {
-		nflog_errno = err;
-		goto out_close;
-	}
 	pkt_cb.data = h;
 	err = nfnl_callback_register(h->nfnlssh, NFULNL_MSG_PACKET, &pkt_cb);
 	if (err < 0) {
-- 
1.5.6.3

