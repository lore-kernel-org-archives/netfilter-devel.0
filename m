Return-Path: <SRS0=0f1v=RX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 055D9C43381
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Mar 2019 10:35:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3E642186A
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Mar 2019 10:35:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727741AbfCTKfj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Mar 2019 06:35:39 -0400
Received: from mail.us.es ([193.147.175.20]:36112 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727708AbfCTKfj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Mar 2019 06:35:39 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DF43F67B88
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Mar 2019 11:35:36 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C229F17B3AE
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Mar 2019 11:35:36 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B593A17B3AC; Wed, 20 Mar 2019 11:35:36 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6C15E17B3AC
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Mar 2019 11:35:35 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 20 Mar 2019 11:35:35 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.hhotels.local (148.160.broadband14.iol.cz [90.181.160.148])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 2D7AE4265A2F
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Mar 2019 11:35:35 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/2] src: use 'flow add' syntax
Date:   Wed, 20 Mar 2019 11:35:29 +0100
Message-Id: <20190320103530.23974-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

As discussed during NFWS 2018. Old syntax is stilled allowed.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/ct.c           | 2 +-
 src/parser_bison.y | 4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/src/ct.c b/src/ct.c
index e77c3201eb5d..ca31f49850d4 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -481,7 +481,7 @@ struct stmt *notrack_stmt_alloc(const struct location *loc)
 static void flow_offload_stmt_print(const struct stmt *stmt,
 				    struct output_ctx *octx)
 {
-	printf("flow offload @%s", stmt->flow.table_name);
+	printf("flow add @%s", stmt->flow.table_name);
 }
 
 static const struct stmt_ops flow_offload_stmt_ops = {
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 48e44e5adc40..65b3fb3ebac2 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -3915,6 +3915,10 @@ meta_stmt		:	META	meta_key	SET	stmt_expr
 			{
 				$$ = flow_offload_stmt_alloc(&@$, $4);
 			}
+			|	FLOW	ADD	AT string
+			{
+				$$ = flow_offload_stmt_alloc(&@$, $4);
+			}
 			;
 
 socket_expr		:	SOCKET	socket_key
-- 
2.11.0

