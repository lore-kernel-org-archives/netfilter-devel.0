Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D2CFC4361B
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Dec 2020 11:44:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECE3E23741
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Dec 2020 11:44:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727388AbgLQLoW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Dec 2020 06:44:22 -0500
Received: from correo.us.es ([193.147.175.20]:34938 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726012AbgLQLoV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Dec 2020 06:44:21 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 23C7D1F0CF0
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Dec 2020 12:43:21 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 149E0DA78A
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Dec 2020 12:43:21 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 139C4DA704; Thu, 17 Dec 2020 12:43:21 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A6291DA78A
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Dec 2020 12:43:18 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 17 Dec 2020 12:43:18 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 93743426CC84
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Dec 2020 12:43:18 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf] parser_bison: disallow burst 0 in ratelimits
Date:   Thu, 17 Dec 2020 12:43:30 +0100
Message-Id: <20201217114330.25719-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The ratelimiter in nftables is similar to the one in iptables, and
iptables disallows a zero burst.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 doc/statements.txt |  3 ++-
 src/parser_bison.y | 23 ++++++++++++++++++++++-
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/doc/statements.txt b/doc/statements.txt
index beebba1611a8..aac7c7d6b009 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -324,7 +324,8 @@ ____
 A limit statement matches at a limited rate using a token bucket filter. A rule
 using this statement will match until this limit is reached. It can be used in
 combination with the log statement to give limited logging. The optional
-*over* keyword makes it match over the specified rate.
+*over* keyword makes it match over the specified rate. Default *burst* is 5.
+if you specify *burst*, it must be non-zero value.
 
 .limit statement values
 [options="header"]
diff --git a/src/parser_bison.y b/src/parser_bison.y
index ba64dc00bee8..2667a5850c07 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -3037,6 +3037,11 @@ log_flag_tcp		:	SEQUENCE
 
 limit_stmt		:	LIMIT	RATE	limit_mode	NUM	SLASH	time_unit	limit_burst_pkts
 	    		{
+				if ($7 == 0) {
+					erec_queue(error(&@7, "limit burst must be > 0"),
+						   state->msgs);
+					YYERROR;
+				}
 				$$ = limit_stmt_alloc(&@$);
 				$$->limit.rate	= $4;
 				$$->limit.unit	= $6;
@@ -3049,6 +3054,12 @@ limit_stmt		:	LIMIT	RATE	limit_mode	NUM	SLASH	time_unit	limit_burst_pkts
 				struct error_record *erec;
 				uint64_t rate, unit;
 
+				if ($6 == 0) {
+					erec_queue(error(&@6, "limit burst must be > 0"),
+						   state->msgs);
+					YYERROR;
+				}
+
 				erec = rate_parse(&@$, $5, &rate, &unit);
 				xfree($5);
 				if (erec != NULL) {
@@ -3125,7 +3136,7 @@ limit_mode		:	OVER				{ $$ = NFT_LIMIT_F_INV; }
 			|	/* empty */			{ $$ = 0; }
 			;
 
-limit_burst_pkts	:	/* empty */			{ $$ = 0; }
+limit_burst_pkts	:	/* empty */			{ $$ = 5; }
 			|	BURST	NUM	PACKETS		{ $$ = $2; }
 			;
 
@@ -4118,6 +4129,11 @@ set_elem_stmt		:	COUNTER
 			}
 			|	LIMIT   RATE    limit_mode      NUM     SLASH   time_unit       limit_burst_pkts
 			{
+				if ($7 == 0) {
+					erec_queue(error(&@7, "limit burst must be > 0"),
+						   state->msgs);
+					YYERROR;
+				}
 				$$ = limit_stmt_alloc(&@$);
 				$$->limit.rate  = $4;
 				$$->limit.unit  = $6;
@@ -4130,6 +4146,11 @@ set_elem_stmt		:	COUNTER
 				struct error_record *erec;
 				uint64_t rate, unit;
 
+				if ($6 == 0) {
+					erec_queue(error(&@6, "limit burst must be > 0"),
+						   state->msgs);
+					YYERROR;
+				}
 				erec = rate_parse(&@$, $5, &rate, &unit);
 				xfree($5);
 				if (erec != NULL) {
-- 
2.20.1

