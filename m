Return-Path: <SRS0=kxmZ=T6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D6BEC28CC3
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 May 2019 10:55:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E59BC257A0
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 May 2019 10:55:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbfE3Kzk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 May 2019 06:55:40 -0400
Received: from mail.us.es ([193.147.175.20]:35316 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726198AbfE3Kzk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 May 2019 06:55:40 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 29FFEC1DE4
        for <netfilter-devel@vger.kernel.org>; Thu, 30 May 2019 12:55:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1C269DA713
        for <netfilter-devel@vger.kernel.org>; Thu, 30 May 2019 12:55:36 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 11C47DA702; Thu, 30 May 2019 12:55:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E5D22DA702;
        Thu, 30 May 2019 12:55:33 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 30 May 2019 12:55:33 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id C36F74265A5B;
        Thu, 30 May 2019 12:55:33 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH nft,v2 1/7] mnl: add mnl_set_rcvbuffer() and use it
Date:   Thu, 30 May 2019 12:55:23 +0200
Message-Id: <20190530105529.12657-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This new function allows us to set the netlink receiver buffer.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/mnl.c | 37 +++++++++++++++++++++++--------------
 1 file changed, 23 insertions(+), 14 deletions(-)

diff --git a/src/mnl.c b/src/mnl.c
index f6363560721c..288a887df097 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -233,6 +233,23 @@ static void mnl_set_sndbuffer(const struct mnl_socket *nl,
 	nlbuffsiz = newbuffsiz;
 }
 
+static int mnl_set_rcvbuffer(const struct mnl_socket *nl, size_t bufsiz)
+{
+	int ret;
+
+	ret = setsockopt(mnl_socket_get_fd(nl), SOL_SOCKET, SO_RCVBUFFORCE,
+			 &bufsiz, sizeof(socklen_t));
+	if (ret < 0) {
+		/* If this doesn't work, try to reach the system wide maximum
+		 * (or whatever the user requested).
+		 */
+		ret = setsockopt(mnl_socket_get_fd(nl), SOL_SOCKET, SO_RCVBUF,
+				 &bufsiz, sizeof(socklen_t));
+	}
+
+	return ret;
+}
+
 static ssize_t mnl_nft_socket_sendmsg(const struct netlink_ctx *ctx)
 {
 	static const struct sockaddr_nl snl = {
@@ -1391,20 +1408,12 @@ int mnl_nft_event_listener(struct mnl_socket *nf_sock, unsigned int debug_mask,
 	fd_set readfds;
 	int ret;
 
-	ret = setsockopt(fd, SOL_SOCKET, SO_RCVBUFFORCE, &bufsiz,
-			 sizeof(socklen_t));
-	if (ret < 0) {
-		/* If this doesn't work, try to reach the system wide maximum
-		 * (or whatever the user requested).
-		 */
-		ret = setsockopt(fd, SOL_SOCKET, SO_RCVBUF, &bufsiz,
-				 sizeof(socklen_t));
-		if (ret < 0)
-			nft_print(octx, "# Cannot increase netlink socket buffer size, expect message loss\n");
-		else
-			nft_print(octx, "# Cannot set up netlink socket buffer size to %u bytes, falling back to %u bytes\n",
-				  NFTABLES_NLEVENT_BUFSIZ, bufsiz);
-	}
+	ret = mnl_set_rcvbuffer(nf_sock, bufsiz);
+	if (ret < 0)
+		nft_print(octx, "# Cannot increase netlink socket buffer size, expect message loss\n");
+	else
+		nft_print(octx, "# Cannot set up netlink socket buffer size to %u bytes, falling back to %u bytes\n",
+			  NFTABLES_NLEVENT_BUFSIZ, bufsiz);
 
 	while (1) {
 		FD_ZERO(&readfds);
-- 
2.11.0

