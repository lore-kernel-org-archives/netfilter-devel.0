Return-Path: <SRS0=EuAs=XL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F089C4CECD
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Sep 2019 16:51:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19A39206C2
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Sep 2019 16:51:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732018AbfIPQvZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Sep 2019 12:51:25 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:51232 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729084AbfIPQvZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Sep 2019 12:51:25 -0400
Received: from localhost ([::1]:36090 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1i9uDk-0003rm-7B; Mon, 16 Sep 2019 18:51:24 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 07/14] nft Increase mnl_talk() receive buffer size
Date:   Mon, 16 Sep 2019 18:49:53 +0200
Message-Id: <20190916165000.18217-8-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190916165000.18217-1-phil@nwl.cc>
References: <20190916165000.18217-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This improves cache population quite a bit and therefore helps when
dealing with large rulesets. A simple hard to improve use-case is
listing the last rule in a large chain. These are the average program
run times depending on number of rules:

rule count	| legacy	| nft old	| nft new
---------------------------------------------------------
 50,000		| .052s		| .611s		| .406s
100,000		| .115s		| 2.12s		| 1.24s
150,000		| .265s		| 7.63s		| 4.14s
200,000		| .411s		| 21.0s		| 10.6s

So while legacy iptables is still magnitudes faster, this simple change
doubles iptables-nft performance in ideal cases.

Note that increasing the buffer even further didn't improve performance
anymore, so 32KB seems to be an upper limit in kernel space.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 6248b9eb10a85..7f0f9e1234ae4 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -101,7 +101,7 @@ int mnl_talk(struct nft_handle *h, struct nlmsghdr *nlh,
 	     void *data)
 {
 	int ret;
-	char buf[16536];
+	char buf[32768];
 
 	if (mnl_socket_sendto(h->nl, nlh, nlh->nlmsg_len) < 0)
 		return -1;
-- 
2.23.0

