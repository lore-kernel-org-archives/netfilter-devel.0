From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH] set-elem: fix a memory leak
Date: Tue, 15 Apr 2014 12:13:47 +0200
Message-ID: <8df9d8df7c8a2c0fa13763fcae5e57f04a4d0362.1397556694.git.anarey@gmail.com>
References: <952227cde493df2637db10cbe8cf2f9b964d885c.1397556664.git.anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:42083 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbaDOKOF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Apr 2014 06:14:05 -0400
Received: by mail-wg0-f46.google.com with SMTP id b13so9180487wgh.17
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Apr 2014 03:14:04 -0700 (PDT)
In-Reply-To: <952227cde493df2637db10cbe8cf2f9b964d885c.1397556664.git.anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Valgrind reports the following memory leak:

valgrind  --leak-check=full ./nft-parsing-test -f jsonfiles/63-set.json
==7131== HEAP SUMMARY:
==7131==     in use at exit: 2 bytes in 1 blocks
==7131==   total heap usage: 155 allocs, 154 frees, 6,497 bytes allocated
==7131==
==7131== 2 bytes in 1 blocks are definitely lost in loss record 1 of 1
==7131==    at 0x4C274A0: malloc (vg_replace_malloc.c:291)
==7131==    by 0x590B829: strdup (strdup.c:42)
==7131==    by 0x4E4341A: nft_data_reg_json_parse (data_reg.c:55)
==7131==    by 0x4E4093A: nft_jansson_data_reg_parse (jansson.c:231)
==7131==    by 0x4E40A1B: nft_jansson_et_elem_parse (jansson.c:257)
==7131==    by 0x4E3CECA: nft_jansson_parse_set (set.c:398)
==7131==    by 0x4E3EC65: nft_ruleset_do_parse (ruleset.c:263)
==7131==    by 0x401479: test_json (nft-parsing-test.c:129)
==7131==    by 0x4017C2: execute_test_file (nft-parsing-test.c:270)
==7131==    by 0x400EBB: main (nft-parsing-test.c:332)

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/set_elem.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/src/set_elem.c b/src/set_elem.c
index a747ba6..05fd08b 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -42,6 +42,12 @@ EXPORT_SYMBOL(nft_set_elem_alloc);
 
 void nft_set_elem_free(struct nft_set_elem *s)
 {
+	if (s->flags & (1 << NFT_SET_ELEM_ATTR_CHAIN)) {
+		if (s->data.chain) {
+			xfree(s->data.chain);
+			s->data.chain = NULL;
+		}
+	}
 	xfree(s);
 }
 EXPORT_SYMBOL(nft_set_elem_free);
-- 
1.9.0

