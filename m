Return-Path: <SRS0=aW9c=VA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01546C5B578
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jul 2019 07:36:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C82D521881
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jul 2019 07:36:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbfGCHgc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Jul 2019 03:36:32 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:45452 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726327AbfGCHgc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Jul 2019 03:36:32 -0400
Received: from localhost ([::1]:58542 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hiZob-0003Os-Nr; Wed, 03 Jul 2019 09:36:29 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/2] nft: Move send/receive buffer sizes into nft_handle
Date:   Wed,  3 Jul 2019 09:36:26 +0200
Message-Id: <20190703073626.18915-2-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190703073626.18915-1-phil@nwl.cc>
References: <20190703073626.18915-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Store them next to the mnl_socket pointer. While being at it, add a
comment to mnl_set_rcvbuffer() explaining why the buffer size is
changed.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c | 17 +++++++----------
 iptables/nft.h |  2 ++
 2 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 4a5280916e3b1..e927d1db2b426 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -186,13 +186,11 @@ static void mnl_err_list_free(struct mnl_err *err)
 	free(err);
 }
 
-static int nlbuffsiz;
-
 static void mnl_set_sndbuffer(struct nft_handle *h)
 {
 	int newbuffsiz = nftnl_batch_iovec_len(h->batch) * BATCH_PAGE_SIZE;
 
-	if (newbuffsiz <= nlbuffsiz)
+	if (newbuffsiz <= h->nlsndbuffsiz)
 		return;
 
 	/* Rise sender buffer length to avoid hitting -EMSGSIZE */
@@ -200,23 +198,22 @@ static void mnl_set_sndbuffer(struct nft_handle *h)
 		       &newbuffsiz, sizeof(socklen_t)) < 0)
 		return;
 
-	nlbuffsiz = newbuffsiz;
+	h->nlsndbuffsiz = newbuffsiz;
 }
 
-static int nlrcvbuffsiz;
-
 static void mnl_set_rcvbuffer(struct nft_handle *h, int numcmds)
 {
 	int newbuffsiz = getpagesize() * numcmds;
 
-	if (newbuffsiz <= nlrcvbuffsiz)
+	if (newbuffsiz <= h->nlrcvbuffsiz)
 		return;
 
+	/* Rise receiver buffer length to avoid hitting -ENOBUFS */
 	if (setsockopt(mnl_socket_get_fd(h->nl), SOL_SOCKET, SO_RCVBUFFORCE,
 		       &newbuffsiz, sizeof(socklen_t)) < 0)
 		return;
 
-	nlrcvbuffsiz = newbuffsiz;
+	h->nlrcvbuffsiz = newbuffsiz;
 }
 
 static ssize_t mnl_nft_socket_sendmsg(struct nft_handle *h, int numcmds)
@@ -807,8 +804,8 @@ static int nft_restart(struct nft_handle *h)
 		return -1;
 
 	h->portid = mnl_socket_get_portid(h->nl);
-	nlbuffsiz = 0;
-	nlrcvbuffsiz = 0;
+	h->nlsndbuffsiz = 0;
+	h->nlrcvbuffsiz = 0;
 
 	return 0;
 }
diff --git a/iptables/nft.h b/iptables/nft.h
index 43eb8a39dd9c1..dc1161840a38c 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -38,6 +38,8 @@ struct nft_cache {
 struct nft_handle {
 	int			family;
 	struct mnl_socket	*nl;
+	int			nlsndbuffsiz;
+	int			nlrcvbuffsiz;
 	uint32_t		portid;
 	uint32_t		seq;
 	uint32_t		nft_genid;
-- 
2.21.0

