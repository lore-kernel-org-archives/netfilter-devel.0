Return-Path: <SRS0=Rfup=U7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EE36C06510
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Jul 2019 15:12:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6BE692146F
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Jul 2019 15:12:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725972AbfGBPMG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 Jul 2019 11:12:06 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:43700 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725851AbfGBPMG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 Jul 2019 11:12:06 -0400
Received: from localhost ([::1]:56790 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hiKRx-0001Us-CK; Tue, 02 Jul 2019 17:12:05 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH RFC] nft: Set socket receive buffer
Date:   Tue,  2 Jul 2019 17:12:01 +0200
Message-Id: <20190702151201.592-1-phil@nwl.cc>
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

Note that calling 'iptables-nft -F' before the last call avoids the
issue. Also, correct behaviour is indicated by a different error
message, namely:

| iptables v1.8.3 (nf_tables):  CHAIN_USER_DEL failed (Device or resource busy): chain chain_000000

The used multiplier value is a result of trial-and-error, it is the
first one which eliminated the ENOBUFS condition.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/iptables/nft.c b/iptables/nft.c
index 2c61521455de8..529d5fb1bfac8 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -192,6 +192,7 @@ static void mnl_set_sndbuffer(const struct mnl_socket *nl,
 			      struct nftnl_batch *batch)
 {
 	int newbuffsiz;
+	int mult = 7;
 
 	if (nftnl_batch_iovec_len(batch) * BATCH_PAGE_SIZE <= nlbuffsiz)
 		return;
@@ -203,6 +204,12 @@ static void mnl_set_sndbuffer(const struct mnl_socket *nl,
 		       &newbuffsiz, sizeof(socklen_t)) < 0)
 		return;
 
+	newbuffsiz *= mult;
+	if (setsockopt(mnl_socket_get_fd(nl), SOL_SOCKET, SO_RCVBUFFORCE,
+		       &newbuffsiz, sizeof(socklen_t)) < 0)
+		return;
+	newbuffsiz /= mult;
+
 	nlbuffsiz = newbuffsiz;
 }
 
-- 
2.21.0

