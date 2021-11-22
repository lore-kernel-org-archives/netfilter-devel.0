Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C38FC433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Nov 2021 17:05:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237015AbhKVRIt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Nov 2021 12:08:49 -0500
Received: from mail.netfilter.org ([217.70.188.207]:33326 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231714AbhKVRIs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Nov 2021 12:08:48 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 94B4264A8F
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Nov 2021 18:03:31 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] mnl: different signedness compilation warning
Date:   Mon, 22 Nov 2021 18:05:37 +0100
Message-Id: <20211122170537.534136-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

mnl.c: In function ‘mnl_batch_talk’:
mnl.c:417:17: warning: comparison of integer expressions of different signedness: ‘unsigned in’ and ‘long int’ [-Wsign-compare]
   if (rcvbufsiz < NFT_MNL_ECHO_RCVBUFF_DEFAULT)
                 ^

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/mnl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/mnl.c b/src/mnl.c
index 4a10647f9f17..23348e1393bc 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -377,7 +377,7 @@ static int mnl_batch_extack_cb(const struct nlmsghdr *nlh, void *data)
 	return MNL_CB_ERROR;
 }
 
-#define NFT_MNL_ECHO_RCVBUFF_DEFAULT	(MNL_SOCKET_BUFFER_SIZE * 1024)
+#define NFT_MNL_ECHO_RCVBUFF_DEFAULT	(MNL_SOCKET_BUFFER_SIZE * 1024U)
 #define NFT_MNL_ACK_MAXSIZE		((sizeof(struct nlmsghdr) + \
 					  sizeof(struct nfgenmsg) + (1 << 16)) + \
 					  MNL_SOCKET_BUFFER_SIZE)
-- 
2.30.2

