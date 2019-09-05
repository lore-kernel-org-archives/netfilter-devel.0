Return-Path: <SRS0=iWGL=XA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDAA3C43331
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Sep 2019 17:09:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96F5D206DE
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Sep 2019 17:09:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389559AbfIERJq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Sep 2019 13:09:46 -0400
Received: from correo.us.es ([193.147.175.20]:46818 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731215AbfIERJq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Sep 2019 13:09:46 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A7867191902
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Sep 2019 19:09:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9A30FB7FF2
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Sep 2019 19:09:42 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8FE1A21FE4; Thu,  5 Sep 2019 19:09:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6301BDA4D0;
        Thu,  5 Sep 2019 19:09:40 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 05 Sep 2019 19:09:40 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 3984D4265A5A;
        Thu,  5 Sep 2019 19:09:40 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     eric@garver.life
Subject: [PATCH nft] cache: fix --echo with index/position
Date:   Thu,  5 Sep 2019 19:09:39 +0200
Message-Id: <20190905170939.4132-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Check for the index/position in case the echo flag is set on. Set the
NFT_CACHE_UPDATE flag in this case to enable incremental cache updates.

Reported-by: Eric Garver <eric@garver.life>
Fixes: 01e5c6f0ed03 ("src: add cache level flags")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/cache.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/cache.c b/src/cache.c
index cffcbb623ced..71d16a0fbeed 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -106,6 +106,9 @@ unsigned int cache_evaluate(struct nft_ctx *nft, struct list_head *cmds)
 		case CMD_CREATE:
 			if (nft_output_echo(&nft->output)) {
 				flags = NFT_CACHE_FULL;
+				if (cmd->handle.index.id ||
+				    cmd->handle.position.id)
+					flags |= NFT_CACHE_UPDATE;
 				break;
 			}
 			flags = evaluate_cache_add(cmd, flags);
-- 
2.11.0

