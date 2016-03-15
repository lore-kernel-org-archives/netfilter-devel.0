From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [nft 3/3] parser_bison: release parsed type and hook name strings
Date: Tue, 15 Mar 2016 17:33:18 +0100
Message-ID: <1458059598-7470-3-git-send-email-pablo@netfilter.org>
References: <1458059598-7470-1-git-send-email-pablo@netfilter.org>
Cc: fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33690 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934250AbcCOQdk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Mar 2016 12:33:40 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 0806B114F50
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 17:33:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E70F0DA392
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 17:33:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E96C5DA392
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 17:33:27 +0100 (CET)
In-Reply-To: <1458059598-7470-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The scanner allocates memory for this, so release them given that we
don't attach them to any object.

==6277== 42 bytes in 6 blocks are definitely lost in loss record 2 of 4
==6277==    at 0x4C28C20: malloc (vg_replace_malloc.c:296)
==6277==    by 0x57AC9D9: strdup (strdup.c:42)
==6277==    by 0x41B82D: xstrdup (utils.c:64)
==6277==    by 0x41F510: nft_lex (scanner.l:511)
==6277==    by 0x427FD1: nft_parse (parser_bison.c:3690)
==6277==    by 0x4063AC: nft_run (main.c:231)
==6277==    by 0x40600C: main (main.c:361)

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 0592b68..9e86f26 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1107,12 +1107,16 @@ hook_spec		:	TYPE		STRING		HOOK		STRING		dev_spec	PRIORITY	prio_spec
 						   state->msgs);
 					YYERROR;
 				}
+				xfree($2);
+
 				$<chain>0->hookstr	= chain_hookname_lookup($4);
 				if ($<chain>0->hookstr == NULL) {
 					erec_queue(error(&@4, "unknown chain hook %s", $4),
 						   state->msgs);
 					YYERROR;
 				}
+				xfree($4);
+
 				$<chain>0->dev		= $5;
 				$<chain>0->priority	= $7;
 				$<chain>0->flags	|= CHAIN_F_BASECHAIN;
-- 
2.1.4

