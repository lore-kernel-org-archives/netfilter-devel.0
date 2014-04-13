From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH] target: Fix an invalid read.
Date: Sun, 13 Apr 2014 20:08:33 +0200
Message-ID: <3a6157fa2be7124bafa2b681acb65eea9be432d2.1397411873.git.anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:40807 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754785AbaDMSIu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 13 Apr 2014 14:08:50 -0400
Received: by mail-wi0-f171.google.com with SMTP id q5so3091555wiv.4
        for <netfilter-devel@vger.kernel.org>; Sun, 13 Apr 2014 11:08:49 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Valgrind reports the following invalid read:

$ sudo valgrind --leak-check=full ./nft-parsing-test -f ../jsonfiles/35-rule-target.json

==26018== Invalid read of size 8
==26018==    at 0x4E484E3: nft_rule_expr_target_set (target.c:46)
==26018==    by 0x4E40B54: nft_rule_expr_set (expr.c:73)
==26018==    by 0x4E48167: nft_rule_expr_target_json_parse (target.c:185)
==26018==    by 0x4E4091D: nft_jansson_expr_parse (jansson.c:206)
==26018==    by 0x4E3B769: nft_jansson_parse_rule (rule.c:606)
==26018==    by 0x4E3F055: nft_ruleset_do_parse (ruleset.c:312)
==26018==    by 0x401479: test_json (nft-parsing-test.c:129)
==26018==    by 0x4017C2: execute_test_file (nft-parsing-test.c:270)
==26018==    by 0x400EBB: main (nft-parsing-test.c:332)
==26018==  Address 0x5c34a60 is 0 bytes inside a block of size 4 alloc'd
==26018==    at 0x4C274A0: malloc (vg_replace_malloc.c:291)
==26018==    by 0x56834FF: ??? (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26018==    by 0x5685825: json_string_nocheck (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26018==    by 0x5682A3F: ??? (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26018==    by 0x5682ADE: ??? (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26018==    by 0x5682C5D: ??? (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26018==    by 0x5682ADE: ??? (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26018==    by 0x5682ADE: ??? (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26018==    by 0x5682C5D: ??? (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26018==    by 0x5682ADE: ??? (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26018==    by 0x5682EDD: ??? (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26018==    by 0x5683295: json_loadf (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26018==
==26018== Invalid read of size 8
==26018==    at 0x4E484ED: nft_rule_expr_target_set (target.c:46)
==26018==    by 0x4E40B54: nft_rule_expr_set (expr.c:73)
==26018==    by 0x4E48167: nft_rule_expr_target_json_parse (target.c:185)
==26018==    by 0x4E4091D: nft_jansson_expr_parse (jansson.c:206)
==26018==    by 0x4E3B769: nft_jansson_parse_rule (rule.c:606)
==26018==    by 0x4E3F055: nft_ruleset_do_parse (ruleset.c:312)
==26018==    by 0x401479: test_json (nft-parsing-test.c:129)
==26018==    by 0x4017C2: execute_test_file (nft-parsing-test.c:270)
==26018==    by 0x400EBB: main (nft-parsing-test.c:332)
==26018==  Address 0x5c34a68 is 4 bytes after a block of size 4 alloc'd
==26018==    at 0x4C274A0: malloc (vg_replace_malloc.c:291)
==26018==    by 0x56834FF: ??? (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26018==    by 0x5685825: json_string_nocheck (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26018==    by 0x5682A3F: ??? (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26018==    by 0x5682ADE: ??? (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26018==    by 0x5682C5D: ??? (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26018==    by 0x5682ADE: ??? (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26018==    by 0x5682ADE: ??? (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26018==    by 0x5682C5D: ??? (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26018==    by 0x5682ADE: ??? (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26018==    by 0x5682EDD: ??? (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26018==    by 0x5683295: json_loadf (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26018==
==26018== Invalid read of size 8
==26018==    at 0x4E484F5: nft_rule_expr_target_set (target.c:46)
==26018==    by 0x4E40B54: nft_rule_expr_set (expr.c:73)
==26018==    by 0x4E48167: nft_rule_expr_target_json_parse (target.c:185)
==26018==    by 0x4E4091D: nft_jansson_expr_parse (jansson.c:206)
==26018==    by 0x4E3B769: nft_jansson_parse_rule (rule.c:606)
==26018==    by 0x4E3F055: nft_ruleset_do_parse (ruleset.c:312)
==26018==    by 0x401479: test_json (nft-parsing-test.c:129)
==26018==    by 0x4017C2: execute_test_file (nft-parsing-test.c:270)
==26018==    by 0x400EBB: main (nft-parsing-test.c:332)
==26018==  Address 0x5c34a70 is 12 bytes after a block of size 4 alloc'd
==26018==    at 0x4C274A0: malloc (vg_replace_malloc.c:291)
==26018==    by 0x56834FF: ??? (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26018==    by 0x5685825: json_string_nocheck (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26018==    by 0x5682A3F: ??? (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26018==    by 0x5682ADE: ??? (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26018==    by 0x5682C5D: ??? (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26018==    by 0x5682ADE: ??? (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26018==    by 0x5682ADE: ??? (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26018==    by 0x5682C5D: ??? (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26018==    by 0x5682ADE: ??? (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26018==    by 0x5682EDD: ??? (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26018==    by 0x5683295: json_loadf (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26018==
==26018== Invalid read of size 4
==26018==    at 0x4E484FD: nft_rule_expr_target_set (target.c:46)
==26018==    by 0x4E40B54: nft_rule_expr_set (expr.c:73)
==26018==    by 0x4E48167: nft_rule_expr_target_json_parse (target.c:185)
==26018==    by 0x4E4091D: nft_jansson_expr_parse (jansson.c:206)
==26018==    by 0x4E3B769: nft_jansson_parse_rule (rule.c:606)
==26018==    by 0x4E3F055: nft_ruleset_do_parse (ruleset.c:312)
==26018==    by 0x401479: test_json (nft-parsing-test.c:129)
==26018==    by 0x4017C2: execute_test_file (nft-parsing-test.c:270)
==26018==    by 0x400EBB: main (nft-parsing-test.c:332)
==26018==  Address 0x5c34a78 is 20 bytes after a block of size 4 alloc'd
==26018==    at 0x4C274A0: malloc (vg_replace_malloc.c:291)
==26018==    by 0x56834FF: ??? (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26018==    by 0x5685825: json_string_nocheck (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26018==    by 0x5682A3F: ??? (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26018==    by 0x5682ADE: ??? (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26018==    by 0x5682C5D: ??? (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26018==    by 0x5682ADE: ??? (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26018==    by 0x5682ADE: ??? (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26018==    by 0x5682C5D: ??? (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26018==    by 0x5682ADE: ??? (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26018==    by 0x5682EDD: ??? (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26018==    by 0x5683295: json_loadf (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/target.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/expr/target.c b/src/expr/target.c
index 36e37de..072f25f 100644
--- a/src/expr/target.c
+++ b/src/expr/target.c
@@ -42,8 +42,8 @@ nft_rule_expr_target_set(struct nft_rule_expr *e, uint16_t type,
 
 	switch(type) {
 	case NFT_EXPR_TG_NAME:
-		memcpy(tg->name, data, XT_EXTENSION_MAXNAMELEN);
-		tg->name[XT_EXTENSION_MAXNAMELEN-1] = '\0';
+		memcpy(tg->name, data, strlen(data));
+		tg->name[strlen(data)+1] = '\0';
 		break;
 	case NFT_EXPR_TG_REV:
 		tg->rev = *((uint32_t *)data);
-- 
1.9.0

