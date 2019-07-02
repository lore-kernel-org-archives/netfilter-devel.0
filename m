Return-Path: <SRS0=Rfup=U7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1EC4C06510
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Jul 2019 18:30:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 999C72184B
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Jul 2019 18:30:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbfGBSay (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 Jul 2019 14:30:54 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:44070 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725851AbfGBSay (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 Jul 2019 14:30:54 -0400
Received: from localhost ([::1]:57160 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hiNYK-0004XP-TK; Tue, 02 Jul 2019 20:30:52 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2] nft: Set socket receive buffer
Date:   Tue,  2 Jul 2019 20:30:49 +0200
Message-Id: <20190702183049.21460-1-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When trying to delete user-defined chains in a large ruleset,
iptables-nft aborts with "No buffer space available". This can be
reproduced using the following script:

| #! /bin/bash
| iptables-nft-restore <(
|
| echo "*filter"
| for i in $(seq 0 200000);do
|         printf ":chain_%06x - [0:0]\n" $i
| done
| for i in $(seq 0 200000);do
|         printf -- "-A INPUT -j chain_%06x\n" $i
|         printf -- "-A INPUT -j chain_%06x\n" $i
| done
| echo COMMIT
|
| )
| iptables-nft -X

The problem seems to be the sheer amount of netlink error messages sent
back to user space (one EBUSY for each chain). To solve this, set
receive buffer size depending on number of commands sent to kernel.

Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Reset stored receive buffer size to zero in nft_restart().
---
 iptables/nft.c | 27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 2c61521455de8..3aa2c6c6b9166 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -206,8 +206,24 @@ static void mnl_set_sndbuffer(const struct mnl_socket *nl,
 	nlbuffsiz = newbuffsiz;
 }
 
+static int nlrcvbuffsiz;
+
+static void mnl_set_rcvbuffer(const struct mnl_socket *nl, int numcmds)
+{
+	int newbuffsiz = getpagesize() * numcmds;
+
+	if (newbuffsiz <= nlrcvbuffsiz)
+		return;
+
+	if (setsockopt(mnl_socket_get_fd(nl), SOL_SOCKET, SO_RCVBUFFORCE,
+		       &newbuffsiz, sizeof(socklen_t)) < 0)
+		return;
+
+	nlrcvbuffsiz = newbuffsiz;
+}
+
 static ssize_t mnl_nft_socket_sendmsg(const struct mnl_socket *nf_sock,
-				      struct nftnl_batch *batch)
+				      struct nftnl_batch *batch, int numcmds)
 {
 	static const struct sockaddr_nl snl = {
 		.nl_family = AF_NETLINK
@@ -222,13 +238,15 @@ static ssize_t mnl_nft_socket_sendmsg(const struct mnl_socket *nf_sock,
 	};
 
 	mnl_set_sndbuffer(nf_sock, batch);
+	mnl_set_rcvbuffer(nf_sock, numcmds);
 	nftnl_batch_iovec(batch, iov, iov_len);
 
 	return sendmsg(mnl_socket_get_fd(nf_sock), &msg, 0);
 }
 
 static int mnl_batch_talk(const struct mnl_socket *nf_sock,
-			  struct nftnl_batch *batch, struct list_head *err_list)
+			  struct nftnl_batch *batch, int numcmds,
+			  struct list_head *err_list)
 {
 	const struct mnl_socket *nl = nf_sock;
 	int ret, fd = mnl_socket_get_fd(nl), portid = mnl_socket_get_portid(nl);
@@ -240,7 +258,7 @@ static int mnl_batch_talk(const struct mnl_socket *nf_sock,
 	};
 	int err = 0;
 
-	ret = mnl_nft_socket_sendmsg(nf_sock, batch);
+	ret = mnl_nft_socket_sendmsg(nf_sock, batch, numcmds);
 	if (ret == -1)
 		return -1;
 
@@ -795,6 +813,7 @@ static int nft_restart(struct nft_handle *h)
 
 	h->portid = mnl_socket_get_portid(h->nl);
 	nlbuffsiz = 0;
+	nlrcvbuffsiz = 0;
 
 	return 0;
 }
@@ -2917,7 +2936,7 @@ retry:
 	}
 
 	errno = 0;
-	ret = mnl_batch_talk(h->nl, h->batch, &h->err_list);
+	ret = mnl_batch_talk(h->nl, h->batch, seq, &h->err_list);
 	if (ret && errno == ERESTART) {
 		nft_rebuild_cache(h);
 
-- 
2.21.0

