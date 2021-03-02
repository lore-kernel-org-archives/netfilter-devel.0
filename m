Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22AF5C4332D
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Mar 2021 23:38:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC94F64F43
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Mar 2021 23:38:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbhCBXfq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 Mar 2021 18:35:46 -0500
Received: from correo.us.es ([193.147.175.20]:40234 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350054AbhCBLuG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 Mar 2021 06:50:06 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CE0D68140E
        for <netfilter-devel@vger.kernel.org>; Tue,  2 Mar 2021 12:48:53 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BA311DA789
        for <netfilter-devel@vger.kernel.org>; Tue,  2 Mar 2021 12:48:53 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B8FAEDA722; Tue,  2 Mar 2021 12:48:53 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5D30FDA722
        for <netfilter-devel@vger.kernel.org>; Tue,  2 Mar 2021 12:48:51 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 02 Mar 2021 12:48:51 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 4A02142DF560
        for <netfilter-devel@vger.kernel.org>; Tue,  2 Mar 2021 12:48:51 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] mnl: remove nft_mnl_socket_reopen()
Date:   Tue,  2 Mar 2021 12:48:46 +0100
Message-Id: <20210302114847.3865-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nft_mnl_socket_reopen() was introduced to deal with the EINTR case.
By reopening the netlink socket, pending netlink messages that are part
part of a stale netlink dump are implicitly drop. This patch replaces
the nft_mnl_socket_reopen() strategy by pulling out all of the remaining
netlink message to restart in a clean state.

This is implicitly fixing up a bug in the table ownership support, which
assumes that the netlink socket remains open until nft_ctx_free() is
invoked.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/mnl.h |  1 -
 src/mnl.c     | 20 +++++++++++---------
 src/rule.c    |  5 ++---
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/include/mnl.h b/include/mnl.h
index 74b1b56fd686..979929c31c17 100644
--- a/include/mnl.h
+++ b/include/mnl.h
@@ -7,7 +7,6 @@
 #include <libmnl/libmnl.h>
 
 struct mnl_socket *nft_mnl_socket_open(void);
-struct mnl_socket *nft_mnl_socket_reopen(struct mnl_socket *nf_sock);
 
 uint32_t mnl_seqnum_alloc(uint32_t *seqnum);
 uint32_t mnl_genid_get(struct netlink_ctx *ctx);
diff --git a/src/mnl.c b/src/mnl.c
index 84cfb2380f55..2ae69c6f185e 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -52,13 +52,6 @@ struct mnl_socket *nft_mnl_socket_open(void)
 	return nf_sock;
 }
 
-struct mnl_socket *nft_mnl_socket_reopen(struct mnl_socket *nf_sock)
-{
-	mnl_socket_close(nf_sock);
-
-	return nft_mnl_socket_open();
-}
-
 uint32_t mnl_seqnum_alloc(unsigned int *seqnum)
 {
 	return (*seqnum)++;
@@ -77,17 +70,26 @@ nft_mnl_recv(struct netlink_ctx *ctx, uint32_t portid,
 	     int (*cb)(const struct nlmsghdr *nlh, void *data), void *cb_data)
 {
 	char buf[NFT_NLMSG_MAXSIZE];
+	bool eintr = false;
 	int ret;
 
 	ret = mnl_socket_recvfrom(ctx->nft->nf_sock, buf, sizeof(buf));
 	while (ret > 0) {
 		ret = mnl_cb_run(buf, ret, ctx->seqnum, portid, cb, cb_data);
-		if (ret <= 0)
-			goto out;
+		if (ret <= 0) {
+			if (errno != EINTR)
+				goto out;
+
+			eintr = true;
+		}
 
 		ret = mnl_socket_recvfrom(ctx->nft->nf_sock, buf, sizeof(buf));
 	}
 out:
+	if (eintr) {
+		ret = -1;
+		errno = EINTR;
+	}
 	if (ret < 0 && errno == EAGAIN)
 		return 0;
 
diff --git a/src/rule.c b/src/rule.c
index acb10f65a517..367c5c8be952 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -292,10 +292,9 @@ replay:
 	ret = cache_init(&ctx, flags);
 	if (ret < 0) {
 		cache_release(cache);
-		if (errno == EINTR) {
-			nft->nf_sock = nft_mnl_socket_reopen(nft->nf_sock);
+		if (errno == EINTR)
 			goto replay;
-		}
+
 		return -1;
 	}
 
-- 
2.20.1

