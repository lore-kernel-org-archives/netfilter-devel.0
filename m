Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BF62C433B4
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Apr 2021 08:51:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3736161241
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Apr 2021 08:51:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240554AbhDFIvk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Apr 2021 04:51:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232593AbhDFIvi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Apr 2021 04:51:38 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F558C06174A
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Apr 2021 01:51:31 -0700 (PDT)
Received: from localhost ([::1]:54242 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1lThQn-0003ro-5b; Tue, 06 Apr 2021 10:51:29 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: [iptables PATCH v2] nft: Increase BATCH_PAGE_SIZE to support huge rulesets
Date:   Tue,  6 Apr 2021 10:51:20 +0200
Message-Id: <20210406085120.10310-1-phil@nwl.cc>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In order to support the same ruleset sizes as legacy iptables, the
kernel's limit of 1024 iovecs has to be overcome. Therefore increase
each iovec's size from 128KB to 2MB.

While being at it, add a log message for failing sendmsg() call. This is
not supposed to happen, even if the transaction fails. Yet if it does,
users are left with only a "line XXX failed" message (with line number
being the COMMIT line).

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Drop getpagesize() call, no real use for that.
- Adjust comment and description to account for the actual page size.
---
 iptables/nft.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index bd840e75f83f4..4e80e5b7e7972 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -88,11 +88,11 @@ int mnl_talk(struct nft_handle *h, struct nlmsghdr *nlh,
 
 #define NFT_NLMSG_MAXSIZE (UINT16_MAX + getpagesize())
 
-/* selected batch page is 256 Kbytes long to load ruleset of
- * half a million rules without hitting -EMSGSIZE due to large
- * iovec.
+/* Selected batch page is 2 Mbytes long to support loading a ruleset of 3.5M
+ * rules matching on source and destination address as well as input and output
+ * interfaces. This is what legacy iptables supports.
  */
-#define BATCH_PAGE_SIZE getpagesize() * 32
+#define BATCH_PAGE_SIZE 2 * 1024 * 1024
 
 static struct nftnl_batch *mnl_batch_init(void)
 {
@@ -220,8 +220,10 @@ static int mnl_batch_talk(struct nft_handle *h, int numcmds)
 	int err = 0;
 
 	ret = mnl_nft_socket_sendmsg(h, numcmds);
-	if (ret == -1)
+	if (ret == -1) {
+		fprintf(stderr, "sendmsg() failed: %s\n", strerror(errno));
 		return -1;
+	}
 
 	FD_ZERO(&readfds);
 	FD_SET(fd, &readfds);
-- 
2.31.0

