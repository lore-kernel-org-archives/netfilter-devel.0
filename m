Return-Path: <SRS0=E6gp=UJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0569DC282DD
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Jun 2019 11:14:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4FBD206C3
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Jun 2019 11:14:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388703AbfFJLOy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Jun 2019 07:14:54 -0400
Received: from mail.us.es ([193.147.175.20]:44220 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388504AbfFJLOy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Jun 2019 07:14:54 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 79258F27A9
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Jun 2019 13:14:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 064EADA70A
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Jun 2019 13:14:52 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id EFF13DA712; Mon, 10 Jun 2019 13:14:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B7E76DA703;
        Mon, 10 Jun 2019 13:14:49 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 10 Jun 2019 13:14:49 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 97484406B681;
        Mon, 10 Jun 2019 13:14:49 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     ffmancera@riseup.net
Subject: [PATCH nft] src: invalid read when importing chain name
Date:   Mon, 10 Jun 2019 13:14:46 +0200
Message-Id: <20190610111446.3166-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use strlen(), otherwise mpz_import_data() reads too much beyond the real
chain string.

==2759== Invalid read of size 1
==2759==    at 0x67D68D6: __gmpz_import (in /usr/lib/x86_64-linux-gnu/libgmp.so.10.3.2)
==2759==    by 0x4E79467: mpz_import_data (gmputil.c:133)
==2759==    by 0x4E60A12: constant_expr_alloc (expression.c:375)
==2759==    by 0x4E8ED65: nft_parse (parser_bison.y:3825)
==2759==    by 0x4E7E850: nft_parse_bison_buffer (libnftables.c:357)
==2759==    by 0x4E7E850: nft_run_cmd_from_buffer (libnftables.c:424)
==2759==    by 0x1095D4: main (in /home/pablo/asuntos/netfilter/nftables-bugs/nft7/a.out)
==2759==  Address 0x6ee1b4a is 0 bytes after a block of size 10 alloc'd
==2759==    at 0x4C2BBAF: malloc (vg_replace_malloc.c:299)
==2759==    by 0x59FD3B9: strdup (strdup.c:42)
==2759==    by 0x4E7963D: xstrdup (utils.c:75)
==2759==    by 0x4E9C233: nft_lex (scanner.l:626)
==2759==    by 0x4E8E382: nft_parse (parser_bison.c:5297)
==2759==    by 0x4E7E850: nft_parse_bison_buffer (libnftables.c:357)
==2759==    by 0x4E7E850: nft_run_cmd_from_buffer (libnftables.c:424)

Fixes: f1e8a129ee42 ("src: Introduce chain_expr in jump and goto statements")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink.c      | 4 ++--
 src/parser_bison.y | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index ef12cb016b1d..e9779684ac09 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -265,8 +265,8 @@ static struct expr *netlink_alloc_verdict(const struct location *loc,
 	case NFT_GOTO:
 		chain = constant_expr_alloc(loc, &string_type,
 					    BYTEORDER_HOST_ENDIAN,
-					    NFT_CHAIN_MAXNAMELEN *
-					    BITS_PER_BYTE, nld->chain);
+					    strlen(nld->chain) * BITS_PER_BYTE,
+					    nld->chain);
 		break;
 	default:
 		chain = NULL;
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 8026708ed859..5ffb5cc22145 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -3824,8 +3824,8 @@ chain_expr		:	variable_expr
 			{
 				$$ = constant_expr_alloc(&@$, &string_type,
 							 BYTEORDER_HOST_ENDIAN,
-							 NFT_CHAIN_MAXNAMELEN *
-							 BITS_PER_BYTE, $1);
+							 strlen($1) * BITS_PER_BYTE,
+							 $1);
 			}
 			;
 
-- 
2.11.0

