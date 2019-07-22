Return-Path: <SRS0=3WFO=VT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 702D1C76194
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jul 2019 11:55:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4BBC620449
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jul 2019 11:55:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730076AbfGVLze (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Jul 2019 07:55:34 -0400
Received: from mail.us.es ([193.147.175.20]:48892 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730062AbfGVLze (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Jul 2019 07:55:34 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A6013F2806
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Jul 2019 13:55:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9921E1150CB
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Jul 2019 13:55:31 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8E822A6D8; Mon, 22 Jul 2019 13:55:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 80A52FF6CC;
        Mon, 22 Jul 2019 13:55:29 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 22 Jul 2019 13:55:28 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.214.120])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 8E3C040705C6;
        Mon, 22 Jul 2019 13:55:28 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
Subject: [PATCH nft] evaluate: missing location for chain nested in table definition
Date:   Mon, 22 Jul 2019 13:55:22 +0200
Message-Id: <20190722115522.31726-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

error reporting may crash because location is unset.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
This supersedes your patch 2/3. Regarding 1/3, I think it should be good
to assume location must be always set, so BUG() is probably a good idea
from erec_print() if unset.

 src/evaluate.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index 69b853f58722..c6cc6ccad75d 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3516,6 +3516,7 @@ static int table_evaluate(struct eval_ctx *ctx, struct table *table)
 	}
 	list_for_each_entry(chain, &table->chains, list) {
 		handle_merge(&chain->handle, &table->handle);
+		ctx->cmd->handle.chain.location = chain->location;
 		if (chain_evaluate(ctx, chain) < 0)
 			return -1;
 	}
-- 
2.11.0


