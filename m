Return-Path: <SRS0=wLp+=YK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46ADBFA372A
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Oct 2019 11:07:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20C25214E0
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Oct 2019 11:07:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394168AbfJQLH5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Oct 2019 07:07:57 -0400
Received: from correo.us.es ([193.147.175.20]:46398 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393652AbfJQLH5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Oct 2019 07:07:57 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0946711EB21
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Oct 2019 13:07:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EBBD4DA4CA
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Oct 2019 13:07:52 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E07F0DA801; Thu, 17 Oct 2019 13:07:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E02B2B7FF6;
        Thu, 17 Oct 2019 13:07:50 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 17 Oct 2019 13:07:50 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id BD89D42EE38F;
        Thu, 17 Oct 2019 13:07:50 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     ejallot@gmail.com
Subject: [PATCH nft 2/2,v2] flowtable: fix memleak in exit path
Date:   Thu, 17 Oct 2019 13:07:47 +0200
Message-Id: <20191017110747.25985-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191017110747.25985-1-pablo@netfilter.org>
References: <20191017110747.25985-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Eric Jallot <ejallot@gmail.com>

Add missing loop in table_free().
Free all objects in flowtable_free() and add conditions in case of error recovery
in the parser (See commit 4be0a3f922a29).

Also, fix memleak in the parser.

This fixes the following memleak:

 # valgrind --leak-check=full nft add flowtable inet raw f '{ hook ingress priority filter; devices = { eth0 }; }'
 ==15414== Memcheck, a memory error detector
 ==15414== Copyright (C) 2002-2017, and GNU GPL'd, by Julian Seward et al.
 ==15414== Using Valgrind-3.14.0 and LibVEX; rerun with -h for copyright info
 ==15414== Command: nft add flowtable inet raw f {\ hook\ ingress\ priority\ filter;\ devices\ =\ {\ eth0\ };\ }
 ==15414==
 ==15414==
 ==15414== HEAP SUMMARY:
 ==15414==     in use at exit: 266 bytes in 4 blocks
 ==15414==   total heap usage: 55 allocs, 51 frees, 208,105 bytes allocated
 ==15414==
 ==15414== 5 bytes in 1 blocks are definitely lost in loss record 2 of 4
 ==15414==    at 0x4C29EA3: malloc (vg_replace_malloc.c:309)
 ==15414==    by 0x5C64AA9: strdup (strdup.c:42)
 ==15414==    by 0x4E705ED: xstrdup (utils.c:75)
 ==15414==    by 0x4E93F01: nft_lex (scanner.l:648)
 ==15414==    by 0x4E85C1C: nft_parse (parser_bison.c:5577)
 ==15414==    by 0x4E75A07: nft_parse_bison_buffer (libnftables.c:375)
 ==15414==    by 0x4E75A07: nft_run_cmd_from_buffer (libnftables.c:443)
 ==15414==    by 0x40170F: main (main.c:326)
 ==15414==
 ==15414== 261 (128 direct, 133 indirect) bytes in 1 blocks are definitely lost in loss record 4 of 4
 ==15414==    at 0x4C29EA3: malloc (vg_replace_malloc.c:309)
 ==15414==    by 0x4E705AD: xmalloc (utils.c:36)
 ==15414==    by 0x4E705AD: xzalloc (utils.c:65)
 ==15414==    by 0x4E560B6: expr_alloc (expression.c:45)
 ==15414==    by 0x4E56288: symbol_expr_alloc (expression.c:286)
 ==15414==    by 0x4E8A601: nft_parse (parser_bison.y:1842)
 ==15414==    by 0x4E75A07: nft_parse_bison_buffer (libnftables.c:375)
 ==15414==    by 0x4E75A07: nft_run_cmd_from_buffer (libnftables.c:443)
 ==15414==    by 0x40170F: main (main.c:326)

Fixes: 92911b362e906 ("src: add support to add flowtables")
Signed-off-by: Eric Jallot <ejallot@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: simplify original patch a bit.

 src/parser_bison.y |  1 +
 src/rule.c         | 12 ++++++++++++
 2 files changed, 13 insertions(+)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 8ad581f69271..11f0dc8b2153 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1842,6 +1842,7 @@ flowtable_expr_member	:	STRING
 				$$ = symbol_expr_alloc(&@$, SYMBOL_VALUE,
 						       current_scope(state),
 						       $1);
+				xfree($1);
 			}
 			;
 
diff --git a/src/rule.c b/src/rule.c
index 2d35bae44c9e..d4d4add1afab 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1180,6 +1180,7 @@ struct table *table_alloc(void)
 void table_free(struct table *table)
 {
 	struct chain *chain, *next;
+	struct flowtable *ft, *nft;
 	struct set *set, *nset;
 	struct obj *obj, *nobj;
 
@@ -1189,6 +1190,8 @@ void table_free(struct table *table)
 		chain_free(chain);
 	list_for_each_entry_safe(set, nset, &table->sets, list)
 		set_free(set);
+	list_for_each_entry_safe(ft, nft, &table->flowtables, list)
+		flowtable_free(ft);
 	list_for_each_entry_safe(obj, nobj, &table->objs, list)
 		obj_free(obj);
 	handle_free(&table->handle);
@@ -2104,10 +2107,19 @@ struct flowtable *flowtable_get(struct flowtable *flowtable)
 
 void flowtable_free(struct flowtable *flowtable)
 {
+	int i;
+
 	if (--flowtable->refcnt > 0)
 		return;
 	handle_free(&flowtable->handle);
 	expr_free(flowtable->priority.expr);
+	expr_free(flowtable->dev_expr);
+
+	if (flowtable->dev_array != NULL) {
+		for (i = 0; i < flowtable->dev_array_len; i++)
+			xfree(flowtable->dev_array[i]);
+		xfree(flowtable->dev_array);
+	}
 	xfree(flowtable);
 }
 
-- 
2.11.0

