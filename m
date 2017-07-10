From: Eric Leblond <eric@regit.org>
Subject: [nft PATCH 2/7] parser: fix memory leak in set creation
Date: Tue, 11 Jul 2017 00:32:50 +0200
Message-ID: <20170710223255.29885-3-eric@regit.org>
References: <20170710223255.29885-1-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:41132 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754695AbdGJWdP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Jul 2017 18:33:15 -0400
In-Reply-To: <20170710223255.29885-1-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

sudo  ASAN_SYMBOLIZER_PATH=/usr/lib/llvm-3.9/bin/llvm-symbolizer  nft add set inet filter blacklisddddddddddddddddddddt {type inet_service \;}

=================================================================
==25152==ERROR: LeakSanitizer: detected memory leaks

Direct leak of 13 byte(s) in 1 object(s) allocated from:
    #0 0x45cca0 in __interceptor_strdup (/usr/local/sbin/nft+0x45cca0)
    #1 0x593cb1 in xstrdup /home/eric/git/netfilter/nftables/src/utils.c:75:8
    #2 0x5bccb2 in nft_lex /home/eric/git/netfilter/nftables/src/scanner.l:566:22
    #3 0x5cb363 in nft_parse /home/eric/git/netfilter/nftables/src/parser_bison.c:4366:16
    #4 0x505a37 in nft_run /home/eric/git/netfilter/nftables/src/main.c:246:8
    #5 0x50771f in main /home/eric/git/netfilter/nftables/src/main.c:392:6
    #6 0x7ff7befdb2b0 in __libc_start_main (/lib/x86_64-linux-gnu/libc.so.6+0x202b0)

SUMMARY: AddressSanitizer: 13 byte(s) leaked in 1 allocation(s).
Signed-off-by: Eric Leblond <eric@regit.org>
---
 src/parser_bison.y | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index a8448e1..c505a04 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1452,8 +1452,10 @@ type_identifier_list	:	type_identifier
 				if (dtype == NULL) {
 					erec_queue(error(&@1, "unknown datatype %s", $1),
 						   state->msgs);
+					xfree($1);
 					YYERROR;
 				}
+				xfree($1);
 				$$ = dtype->type;
 			}
 			|	type_identifier_list	DOT	type_identifier
-- 
2.13.2

