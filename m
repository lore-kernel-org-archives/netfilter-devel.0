Return-Path: <SRS0=Hnfl=SH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28B63C4360F
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Apr 2019 13:12:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02CBA21852
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Apr 2019 13:12:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729184AbfDENMf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 Apr 2019 09:12:35 -0400
Received: from mail.us.es ([193.147.175.20]:38122 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726027AbfDENMf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 Apr 2019 09:12:35 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B8EED4DE72B
        for <netfilter-devel@vger.kernel.org>; Fri,  5 Apr 2019 15:12:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9BD50DA702
        for <netfilter-devel@vger.kernel.org>; Fri,  5 Apr 2019 15:12:32 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 91B2EDA706; Fri,  5 Apr 2019 15:12:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 873E3DA702
        for <netfilter-devel@vger.kernel.org>; Fri,  5 Apr 2019 15:12:30 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 05 Apr 2019 15:12:30 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 66A044265A32
        for <netfilter-devel@vger.kernel.org>; Fri,  5 Apr 2019 15:12:30 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] parser_bison: type_identifier string memleak
Date:   Fri,  5 Apr 2019 15:12:27 +0200
Message-Id: <20190405131227.17209-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

==6297== 24 bytes in 3 blocks are definitely lost in loss record 2 of 13
==6297==    at 0x4C2BBAF: malloc (vg_replace_malloc.c:299)
==6297==    by 0x56193B9: strdup (strdup.c:42)
==6297==    by 0x4E758BD: xstrdup (utils.c:75)
==6297==    by 0x4E7F9D3: nft_parse (parser_bison.y:1895)
==6297==    by 0x4E7AAE1: nft_parse_bison_filename (libnftables.c:370)
==6297==    by 0x4E7AAE1: nft_run_cmd_from_filename (libnftables.c:438)
==6297==    by 0x109A33: main (main.c:310)

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 50642b4e02f4..343df12a3281 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1796,11 +1796,11 @@ data_type_atom_expr	:	type_identifier
 				if (dtype == NULL) {
 					erec_queue(error(&@1, "unknown datatype %s", $1),
 						   state->msgs);
-					xfree($1);
 					YYERROR;
 				}
 				$$ = constant_expr_alloc(&@1, dtype, dtype->byteorder,
 							 dtype->size, NULL);
+				xfree($1);
 			}
 			;
 
-- 
2.11.0

