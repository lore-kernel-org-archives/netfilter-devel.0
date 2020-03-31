Return-Path: <SRS0=TvDw=5Q=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B065C2D0EE
	for <netfilter-devel@archiver.kernel.org>; Tue, 31 Mar 2020 18:29:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72F1520786
	for <netfilter-devel@archiver.kernel.org>; Tue, 31 Mar 2020 18:29:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727749AbgCaS3k (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 31 Mar 2020 14:29:40 -0400
Received: from correo.us.es ([193.147.175.20]:39076 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726268AbgCaS3k (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 31 Mar 2020 14:29:40 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EAAC1505542
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Mar 2020 20:29:38 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DA67EDA736
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Mar 2020 20:29:38 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D94A1165CC3; Tue, 31 Mar 2020 20:29:38 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6D700DA736
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Mar 2020 20:29:36 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 31 Mar 2020 20:29:36 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 4A4DA4301DE2
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Mar 2020 20:29:36 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/2] parser_bison: simplify error in chain type and hook
Date:   Tue, 31 Mar 2020 20:29:32 +0200
Message-Id: <20200331182932.34515-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200331182932.34515-1-pablo@netfilter.org>
References: <20200331182932.34515-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Remove extra string after error, location is sufficient.

 # nft -f x
 /tmp/x:3:8-11: Error: unknown chain type
                type nput hook input device eth0 priority 0
                     ^^^^

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 735f2dffc6e6..3e8d6bd6d8ca 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1880,7 +1880,7 @@ flowtable_block		:	/* empty */	{ $$ = $<flowtable>-1; }
 				$$->hook.loc = @3;
 				$$->hook.name = chain_hookname_lookup($3);
 				if ($$->hook.name == NULL) {
-					erec_queue(error(&@3, "unknown chain hook %s", $3),
+					erec_queue(error(&@3, "unknown chain hook"),
 						   state->msgs);
 					xfree($3);
 					YYERROR;
@@ -2049,7 +2049,7 @@ hook_spec		:	TYPE		STRING		HOOK		STRING		dev_spec	prio_spec
 				const char *chain_type = chain_type_name_lookup($2);
 
 				if (chain_type == NULL) {
-					erec_queue(error(&@2, "unknown chain type %s", $2),
+					erec_queue(error(&@2, "unknown chain type"),
 						   state->msgs);
 					xfree($2);
 					YYERROR;
@@ -2061,7 +2061,7 @@ hook_spec		:	TYPE		STRING		HOOK		STRING		dev_spec	prio_spec
 				$<chain>0->hook.loc = @4;
 				$<chain>0->hook.name = chain_hookname_lookup($4);
 				if ($<chain>0->hook.name == NULL) {
-					erec_queue(error(&@4, "unknown chain hook %s", $4),
+					erec_queue(error(&@4, "unknown chain hook"),
 						   state->msgs);
 					xfree($4);
 					YYERROR;
-- 
2.11.0

