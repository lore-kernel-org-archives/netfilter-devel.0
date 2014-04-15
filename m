From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH] lookup: Fix an invalid read
Date: Tue, 15 Apr 2014 12:13:46 +0200
Message-ID: <952227cde493df2637db10cbe8cf2f9b964d885c.1397556664.git.anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:35458 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaDOKOB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Apr 2014 06:14:01 -0400
Received: by mail-wi0-f172.google.com with SMTP id hi2so5387908wib.17
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Apr 2014 03:14:00 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Valgrind reports the following invalid read:

$ sudo valgrind ./nft-parsing-test -f ../jsonfiles/30-rule-lookup.json
==26664== Memcheck, a memory error detector
==26664== Copyright (C) 2002-2013, and GNU GPL'd, by Julian Seward et al.
==26664== Using Valgrind-3.9.0 and LibVEX; rerun with -h for copyright info
==26664== Command: ./nft-parsing-test -f ../jsonfiles/30-rule-lookup.json
==26664==
==26664== Invalid read of size 8
==26664==    at 0x4E45490: nft_rule_expr_lookup_set (lookup.c:50)
==26664==    by 0x4E40B04: nft_rule_expr_set (expr.c:73)
==26664==    by 0x4E44FFF: nft_rule_expr_lookup_json_parse (lookup.c:157)
==26664==    by 0x4E408CD: nft_jansson_expr_parse (jansson.c:206)
==26664==    by 0x4E3B719: nft_jansson_parse_rule (rule.c:606)
==26664==    by 0x4E3F005: nft_ruleset_do_parse (ruleset.c:312)
==26664==    by 0x401479: test_json (nft-parsing-test.c:129)
==26664==    by 0x4017C2: execute_test_file (nft-parsing-test.c:270)
==26664==    by 0x400EBB: main (nft-parsing-test.c:332)
==26664==  Address 0x5c34d40 is 0 bytes inside a block of size 5 alloc'd
==26664==    at 0x4C274A0: malloc (vg_replace_malloc.c:291)
==26664==    by 0x56834FF: ??? (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26664==    by 0x5685825: json_string_nocheck (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26664==    by 0x5682A3F: ??? (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26664==    by 0x5682ADE: ??? (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26664==    by 0x5682C5D: ??? (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26664==    by 0x5682ADE: ??? (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26664==    by 0x5682ADE: ??? (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26664==    by 0x5682C5D: ??? (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26664==    by 0x5682ADE: ??? (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26664==    by 0x5682EDD: ??? (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26664==    by 0x5683295: json_loadf (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26664==
==26664== Invalid read of size 8
==26664==    at 0x4E45497: nft_rule_expr_lookup_set (lookup.c:50)
==26664==    by 0x4E40B04: nft_rule_expr_set (expr.c:73)
==26664==    by 0x4E44FFF: nft_rule_expr_lookup_json_parse (lookup.c:157)
==26664==    by 0x4E408CD: nft_jansson_expr_parse (jansson.c:206)
==26664==    by 0x4E3B719: nft_jansson_parse_rule (rule.c:606)
==26664==    by 0x4E3F005: nft_ruleset_do_parse (ruleset.c:312)
==26664==    by 0x401479: test_json (nft-parsing-test.c:129)
==26664==    by 0x4017C2: execute_test_file (nft-parsing-test.c:270)
==26664==    by 0x400EBB: main (nft-parsing-test.c:332)
==26664==  Address 0x5c34d48 is 3 bytes after a block of size 5 alloc'd
==26664==    at 0x4C274A0: malloc (vg_replace_malloc.c:291)
==26664==    by 0x56834FF: ??? (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26664==    by 0x5685825: json_string_nocheck (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26664==    by 0x5682A3F: ??? (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26664==    by 0x5682ADE: ??? (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26664==    by 0x5682C5D: ??? (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26664==    by 0x5682ADE: ??? (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26664==    by 0x5682ADE: ??? (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26664==    by 0x5682C5D: ??? (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26664==    by 0x5682ADE: ??? (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26664==    by 0x5682EDD: ??? (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)
==26664==    by 0x5683295: json_loadf (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.6.0)

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/lookup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/expr/lookup.c b/src/expr/lookup.c
index 5e0bf75..50282a8 100644
--- a/src/expr/lookup.c
+++ b/src/expr/lookup.c
@@ -47,8 +47,8 @@ nft_rule_expr_lookup_set(struct nft_rule_expr *e, uint16_t type,
 		lookup->dreg = *((uint32_t *)data);
 		break;
 	case NFT_EXPR_LOOKUP_SET:
-		memcpy(lookup->set_name, data, IFNAMSIZ);
-		lookup->set_name[IFNAMSIZ-1] = '\0';
+		snprintf(lookup->set_name, sizeof(lookup->set_name), "%s",
+			 (const char *)data);
 		break;
 	default:
 		return -1;
-- 
1.9.0

