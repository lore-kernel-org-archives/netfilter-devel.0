Return-Path: <SRS0=PuwI=UG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08EDBC2BCA1
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Jun 2019 11:43:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3E2B208E3
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Jun 2019 11:42:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728497AbfFGLm7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 7 Jun 2019 07:42:59 -0400
Received: from mail.us.es ([193.147.175.20]:53498 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727866AbfFGLm7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Jun 2019 07:42:59 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 710B7C1A03
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Jun 2019 13:42:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6403DDA701
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Jun 2019 13:42:57 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 59ACDDA70C; Fri,  7 Jun 2019 13:42:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4104FDA708;
        Fri,  7 Jun 2019 13:42:55 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 07 Jun 2019 13:42:55 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 110CC4265A2F;
        Fri,  7 Jun 2019 13:42:55 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, phil@nwl.cc
Subject: [PATCH nft] libnftables: keep evaluating until parser_max_errors
Date:   Fri,  7 Jun 2019 13:42:52 +0200
Message-Id: <20190607114252.10623-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Bail out after parser_max_errors has been reached, eg.

 # nft -f /tmp/errors.nft
 /tmp/errors.nft:1:23-23: Error: syntax error, unexpected newline
 filter input tcp dport
                      ^
 /tmp/errors.nft:2:24-26: Error: datatype mismatch, expected internet network service, expression has type Internet protocol
 filter input tcp dport tcp
             ~~~~~~~~~ ^^^
 root@salvia:/home/pablo# nft -f /tmp/errors.nft
 /tmp/errors.nft:1:23-23: Error: syntax error, unexpected newline
 filter input tcp dport
                      ^
 /tmp/errors.nft:2:24-26: Error: datatype mismatch, expected internet network service, expression has type Internet protocol
 filter input tcp dport tcp
             ~~~~~~~~~ ^^^
 /tmp/errors.nft:3:24-26: Error: datatype mismatch, expected internet network service, expression has type Internet protocol
 filter input tcp sport udp
             ~~~~~~~~~ ^^^

Fixes: f211921e25e6 ("src: perform evaluation after parsing")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/libnftables.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/libnftables.c b/src/libnftables.c
index eae78e8be9d7..e9dc03cf2909 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -393,7 +393,8 @@ static int nft_evaluate(struct nft_ctx *nft, struct list_head *msgs,
 			.nft	= nft,
 			.msgs	= msgs,
 		};
-		if (cmd_evaluate(&ectx, cmd) < 0)
+		if (cmd_evaluate(&ectx, cmd) < 0 &&
+		    ++nft->state->nerrs == nft->parser_max_errors)
 			return -1;
 	}
 
-- 
2.11.0

