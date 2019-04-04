Return-Path: <SRS0=UjrQ=SG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47D0FC4360F
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Apr 2019 11:39:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23138206C0
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Apr 2019 11:39:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728724AbfDDLjz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 4 Apr 2019 07:39:55 -0400
Received: from mail.us.es ([193.147.175.20]:58360 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726269AbfDDLjz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 Apr 2019 07:39:55 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9679812BFF6
        for <netfilter-devel@vger.kernel.org>; Thu,  4 Apr 2019 13:39:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 86D3FDA708
        for <netfilter-devel@vger.kernel.org>; Thu,  4 Apr 2019 13:39:53 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7C6BCDA713; Thu,  4 Apr 2019 13:39:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0D6D5DA70B;
        Thu,  4 Apr 2019 13:39:51 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 04 Apr 2019 13:39:51 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id CA11340705C0;
        Thu,  4 Apr 2019 13:39:50 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     mirq-boogs@rere.qmqm.pl, ffmancera@riseup.net, arturo@debian.org
Subject: [PATCH nft 2/2] evaluate: improve error reporting in tproxy with inet family
Date:   Thu,  4 Apr 2019 13:39:42 +0200
Message-Id: <20190404113942.26263-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190404113942.26263-1-pablo@netfilter.org>
References: <20190404113942.26263-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

 # nft add rule inet filter divert ip daddr 0.0.0.0/0 meta l4proto tcp tproxy to :2000
 Error: conflicting protocols specified: ip vs. unknown. You must specify ip or ip6 family in tproxy statement
 add rule inet filter divert ip daddr 0.0.0.0/0 meta l4proto tcp tproxy to :2000
                             ~~~~~~~~                            ^^^^^^^^^^^^^^^

instead of:

 # nft add rule inet filter divert ip daddr 0.0.0.0/0 meta l4proto tcp tproxy to :2000
 Error: Conflicting network layer protocols.
 add rule inet filter divert ip daddr 0.0.0.0/0 meta l4proto tcp tproxy to :2000
                                                                 ^^^^^^^^^^^^^^^

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1310
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 94377da99335..3a3f2468c826 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2606,8 +2606,11 @@ static int stmt_evaluate_tproxy(struct eval_ctx *ctx, struct stmt *stmt)
 		/* this prevents us from rules like
 		 * ip protocol tcp tproxy ip6 to [dead::beef]
 		 */
-		return stmt_error(ctx, stmt,
-				  "Conflicting network layer protocols.");
+		return stmt_binary_error(ctx, stmt,
+					 &ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR],
+					 "conflicting protocols specified: %s vs. %s. You must specify ip or ip6 family in tproxy statement",
+					 ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc->name,
+					 family2str(stmt->tproxy.family));
 
 	if (stmt->tproxy.addr != NULL) {
 		if (stmt->tproxy.addr->etype == EXPR_RANGE)
-- 
2.11.0

