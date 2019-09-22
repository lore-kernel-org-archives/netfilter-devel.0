Return-Path: <SRS0=d85k=XR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 148EBC3A5A6
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Sep 2019 07:17:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA44620830
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Sep 2019 07:17:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727635AbfIVHRV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 22 Sep 2019 03:17:21 -0400
Received: from correo.us.es ([193.147.175.20]:37534 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727598AbfIVHRV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 22 Sep 2019 03:17:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 77F28E1222
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Sep 2019 09:17:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6A102CE17F
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Sep 2019 09:17:17 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5FB18DA72F; Sun, 22 Sep 2019 09:17:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3E228D1DBB
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Sep 2019 09:17:15 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 22 Sep 2019 09:17:15 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [193.47.165.251])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id E63DA4265A5A
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Sep 2019 09:17:14 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2] mnl: do not cache sender buffer size
Date:   Sun, 22 Sep 2019 09:17:11 +0200
Message-Id: <20190922071711.4083-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

SO_SNDBUF never fails, this socket option just provides a hint to the
kernel.  SO_SNDBUFFORCE sets the buffer size to zero if the value goes
over INT_MAX. Userspace is caching the buffer hint that sends to the
kernel, so it might leave userspace out of sync if the kernel ignores
the hint. Do not make assumptions, fetch the sender buffer size from the
kernel via getsockopt().

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: Missing len variable initialization - Florian Westphal.

 src/mnl.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/src/mnl.c b/src/mnl.c
index 57ff89f50e23..14fa4a7186fd 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -218,24 +218,24 @@ void mnl_err_list_free(struct mnl_err *err)
 	xfree(err);
 }
 
-static int nlbuffsiz;
-
 static void mnl_set_sndbuffer(const struct mnl_socket *nl,
 			      struct nftnl_batch *batch)
 {
+	socklen_t len = sizeof(int);
+	int sndnlbuffsiz = 0;
 	int newbuffsiz;
 
-	if (nftnl_batch_iovec_len(batch) * BATCH_PAGE_SIZE <= nlbuffsiz)
-		return;
+	getsockopt(mnl_socket_get_fd(nl), SOL_SOCKET, SO_SNDBUF,
+		   &sndnlbuffsiz, &len);
 
 	newbuffsiz = nftnl_batch_iovec_len(batch) * BATCH_PAGE_SIZE;
+	if (newbuffsiz <= sndnlbuffsiz)
+		return;
 
 	/* Rise sender buffer length to avoid hitting -EMSGSIZE */
 	if (setsockopt(mnl_socket_get_fd(nl), SOL_SOCKET, SO_SNDBUFFORCE,
 		       &newbuffsiz, sizeof(socklen_t)) < 0)
 		return;
-
-	nlbuffsiz = newbuffsiz;
 }
 
 static unsigned int nlsndbufsiz;
-- 
2.11.0

