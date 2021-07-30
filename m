Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 979E3C4338F
	for <netfilter-devel@archiver.kernel.org>; Fri, 30 Jul 2021 10:37:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7999760F6B
	for <netfilter-devel@archiver.kernel.org>; Fri, 30 Jul 2021 10:37:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238503AbhG3Khi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 30 Jul 2021 06:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238492AbhG3Khb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 30 Jul 2021 06:37:31 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 439E8C0613D3
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Jul 2021 03:37:27 -0700 (PDT)
Received: from localhost ([::1]:44778 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1m9PtL-0000bA-UI; Fri, 30 Jul 2021 12:37:23 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] ebtables: Dump atomic waste
Date:   Fri, 30 Jul 2021 12:37:15 +0200
Message-Id: <20210730103715.20501-1-phil@nwl.cc>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

With ebtables-nft.8 now educating people about the missing
functionality, get rid of atomic remains in source code. This eliminates
mostly comments except for --atomic-commit which was treated as alias of
--init-table. People not using the latter are probably trying to
atomic-commit from an atomic-file which in turn is not supported, so no
point keeping it.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables-eb.c | 53 -------------------------------------------
 1 file changed, 53 deletions(-)

diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index 6c58adaa66c1e..6e35f58ee685f 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -211,10 +211,6 @@ struct option ebt_original_options[] =
 	{ "new-chain"      , required_argument, 0, 'N' },
 	{ "rename-chain"   , required_argument, 0, 'E' },
 	{ "delete-chain"   , optional_argument, 0, 'X' },
-	{ "atomic-init"    , no_argument      , 0, 7   },
-	{ "atomic-commit"  , no_argument      , 0, 8   },
-	{ "atomic-file"    , required_argument, 0, 9   },
-	{ "atomic-save"    , no_argument      , 0, 10  },
 	{ "init-table"     , no_argument      , 0, 11  },
 	{ "concurrent"     , no_argument      , 0, 13  },
 	{ 0 }
@@ -320,10 +316,6 @@ static void print_help(const struct xtables_target *t,
 "--new-chain -N chain          : create a user defined chain\n"
 "--rename-chain -E old new     : rename a chain\n"
 "--delete-chain -X [chain]     : delete a user defined chain\n"
-"--atomic-commit               : update the kernel w/t table contained in <FILE>\n"
-"--atomic-init                 : put the initial kernel table into <FILE>\n"
-"--atomic-save                 : put the current kernel table into <FILE>\n"
-"--atomic-file file            : set <FILE> to file\n\n"
 "Options:\n"
 "--proto  -p [!] proto         : protocol hexadecimal, by name or LENGTH\n"
 "--src    -s [!] address[/mask]: source mac address\n"
@@ -1087,54 +1079,9 @@ print_zero:
 					       "Use --Lmac2 with -L");
 			flags |= LIST_MAC2;
 			break;
-		case 8 : /* atomic-commit */
-/*
-			replace->command = c;
-			if (OPT_COMMANDS)
-				ebt_print_error2("Multiple commands are not allowed");
-			replace->flags |= OPT_COMMAND;
-			if (!replace->filename)
-				ebt_print_error2("No atomic file specified");*/
-			/* Get the information from the file */
-			/*ebt_get_table(replace, 0);*/
-			/* We don't want the kernel giving us its counters,
-			 * they would overwrite the counters extracted from
-			 * the file */
-			/*replace->num_counters = 0;*/
-			/* Make sure the table will be written to the kernel */
-			/*free(replace->filename);
-			replace->filename = NULL;
-			break;*/
-		/*case 7 :*/ /* atomic-init */
-		/*case 10:*/ /* atomic-save */
 		case 11: /* init-table */
 			nft_cmd_table_flush(h, *table, false);
 			return 1;
-		/*
-			replace->command = c;
-			if (OPT_COMMANDS)
-				ebt_print_error2("Multiple commands are not allowed");
-			if (c != 11 && !replace->filename)
-				ebt_print_error2("No atomic file specified");
-			replace->flags |= OPT_COMMAND;
-			{
-				char *tmp = replace->filename;*/
-
-				/* Get the kernel table */
-				/*replace->filename = NULL;
-				ebt_get_kernel_table(replace, c == 10 ? 0 : 1);
-				replace->filename = tmp;
-			}
-			break;
-		case 9 :*/ /* atomic */
-			/*
-			if (OPT_COMMANDS)
-				ebt_print_error2("--atomic has to come before the command");*/
-			/* A possible memory leak here, but this is not
-			 * executed in daemon mode */
-			/*replace->filename = (char *)malloc(strlen(optarg) + 1);
-			strcpy(replace->filename, optarg);
-			break; */
 		case 13 :
 			break;
 		case 1 :
-- 
2.32.0

