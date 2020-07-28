Return-Path: <SRS0=tHxH=BH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAB67C433E5
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Jul 2020 18:15:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAA6B2070B
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Jul 2020 18:15:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732260AbgG1SPx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Jul 2020 14:15:53 -0400
Received: from correo.us.es ([193.147.175.20]:41192 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728050AbgG1SPx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Jul 2020 14:15:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DF62215AEAB
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Jul 2020 20:15:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D143FDA72F
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Jul 2020 20:15:51 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D0C11DA722; Tue, 28 Jul 2020 20:15:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B6C33DA72F
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Jul 2020 20:15:49 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 28 Jul 2020 20:15:49 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 9983C4265A2F
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Jul 2020 20:15:49 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/3] parser_bison: memleak symbol redefinition
Date:   Tue, 28 Jul 2020 20:15:44 +0200
Message-Id: <20200728181546.12663-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Missing expr_free() from the error path.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index f0cca64136ee..167c315810ed 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -862,6 +862,7 @@ common_block		:	INCLUDE		QUOTED_STRING	stmt_separator
 				if (symbol_lookup(scope, $2) != NULL) {
 					erec_queue(error(&@2, "redefinition of symbol '%s'", $2),
 						   state->msgs);
+					expr_free($4);
 					xfree($2);
 					YYERROR;
 				}
-- 
2.20.1

