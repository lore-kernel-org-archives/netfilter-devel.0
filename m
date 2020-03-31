Return-Path: <SRS0=TvDw=5Q=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C2DBC43331
	for <netfilter-devel@archiver.kernel.org>; Tue, 31 Mar 2020 18:29:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53C3020786
	for <netfilter-devel@archiver.kernel.org>; Tue, 31 Mar 2020 18:29:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727509AbgCaS3j (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 31 Mar 2020 14:29:39 -0400
Received: from correo.us.es ([193.147.175.20]:39024 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726268AbgCaS3j (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 31 Mar 2020 14:29:39 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4721A4FFE03
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Mar 2020 20:29:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2CB14165CB0
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Mar 2020 20:29:37 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1B753165CB2; Tue, 31 Mar 2020 20:29:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 28D03165CB0
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Mar 2020 20:29:35 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 31 Mar 2020 20:29:35 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 0A6DE4301DF5
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Mar 2020 20:29:35 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/2] evaluate: check for device in non-netdev chains
Date:   Tue, 31 Mar 2020 20:29:31 +0200
Message-Id: <20200331182932.34515-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

 # nft -f /tmp/x
 /tmp/x:3:26-36: Error: This chain type cannot be bound to device
                 type filter hook input device eth0 priority 0
                                        ^^^^^^^^^^^

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index 84fe89eed657..fcc79386b325 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3805,6 +3805,9 @@ static int chain_evaluate(struct eval_ctx *ctx, struct chain *chain)
 			if (!chain->dev_expr)
 				return __stmt_binary_error(ctx, &chain->loc, NULL,
 							   "Missing `device' in this chain definition");
+		} else if (chain->dev_expr) {
+			return __stmt_binary_error(ctx, &chain->dev_expr->location, NULL,
+						   "This chain type cannot be bound to device");
 		}
 	}
 
-- 
2.11.0

