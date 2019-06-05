Return-Path: <SRS0=tNyb=UE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3024CC46460
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Jun 2019 17:35:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D86D020872
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Jun 2019 17:34:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfFERe7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Jun 2019 13:34:59 -0400
Received: from mail.us.es ([193.147.175.20]:49678 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726608AbfFERe6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Jun 2019 13:34:58 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1F7B41022A1
        for <netfilter-devel@vger.kernel.org>; Wed,  5 Jun 2019 19:34:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 11BADDA704
        for <netfilter-devel@vger.kernel.org>; Wed,  5 Jun 2019 19:34:57 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 07678DA703; Wed,  5 Jun 2019 19:34:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EF453DA704
        for <netfilter-devel@vger.kernel.org>; Wed,  5 Jun 2019 19:34:54 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 05 Jun 2019 19:34:54 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id CCEB44265A2F
        for <netfilter-devel@vger.kernel.org>; Wed,  5 Jun 2019 19:34:54 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] mnl: bogus error when running monitor mode
Date:   Wed,  5 Jun 2019 19:34:51 +0200
Message-Id: <20190605173451.19031-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fix bogus error message:

 # nft monitor
 Cannot set up netlink socket buffer size to 16777216 bytes, falling back to 16777216 bytes

Fixes: bcf60fb819bf ("mnl: add mnl_set_rcvbuffer() and use it")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/mnl.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/src/mnl.c b/src/mnl.c
index c0df2c941d88..a7693ef1de30 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -1433,8 +1433,6 @@ int mnl_nft_event_listener(struct mnl_socket *nf_sock, unsigned int debug_mask,
 
 	ret = mnl_set_rcvbuffer(nf_sock, bufsiz);
 	if (ret < 0)
-		nft_print(octx, "# Cannot increase netlink socket buffer size, expect message loss\n");
-	else
 		nft_print(octx, "# Cannot set up netlink socket buffer size to %u bytes, falling back to %u bytes\n",
 			  NFTABLES_NLEVENT_BUFSIZ, bufsiz);
 
-- 
2.11.0

