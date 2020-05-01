Return-Path: <SRS0=Z556=6P=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BA20C47258
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 May 2020 15:57:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16C8124956
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 May 2020 15:57:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729915AbgEAP5X (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 May 2020 11:57:23 -0400
Received: from smail.fem.tu-ilmenau.de ([141.24.220.41]:40302 "EHLO
        smail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728495AbgEAP5W (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 May 2020 11:57:22 -0400
X-Greylist: delayed 529 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 May 2020 11:57:21 EDT
Received: from mail.fem.tu-ilmenau.de (mail-zuse.net.fem.tu-ilmenau.de [172.21.220.54])
        (using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by smail.fem.tu-ilmenau.de (Postfix) with ESMTPS id 7945E201B9;
        Fri,  1 May 2020 17:48:28 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by mail.fem.tu-ilmenau.de (Postfix) with ESMTP id 4489E61DE;
        Fri,  1 May 2020 17:48:28 +0200 (CEST)
X-Virus-Scanned: amavisd-new at fem.tu-ilmenau.de
Received: from mail.fem.tu-ilmenau.de ([127.0.0.1])
        by localhost (mail.fem.tu-ilmenau.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Agp53F2ETuRt; Fri,  1 May 2020 17:48:26 +0200 (CEST)
Received: from a234.fem.tu-ilmenau.de (ray-controller.net.fem.tu-ilmenau.de [10.42.51.234])
        by mail.fem.tu-ilmenau.de (Postfix) with ESMTP;
        Fri,  1 May 2020 17:48:26 +0200 (CEST)
Received: by a234.fem.tu-ilmenau.de (Postfix, from userid 1000)
        id EE56B306A950; Fri,  1 May 2020 17:48:24 +0200 (CEST)
From:   Michael Braun <michael-dev@fami-braun.de>
To:     netfilter-devel@vger.kernel.org
Cc:     Michael Braun <michael-dev@fami-braun.de>
Subject: [PATCH 1/3] main: fix ASAN -fsanizize=address error
Date:   Fri,  1 May 2020 17:48:16 +0200
Message-Id: <20200501154819.2984-1-michael-dev@fami-braun.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-of-by: Michael Braun <michael-dev@fami-braun.de>

nft list table bridge t
=================================================================
==28552==ERROR: AddressSanitizer: global-buffer-overflow on address 0x5579c662e816 at pc 0x7fc2803246aa bp 0x7fff495c86f0 sp 0x7fff495c7ea0
WRITE of size 2 at 0x5579c662e816 thread T0
    #0 0x7fc2803246a9 in vsprintf (/usr/lib/x86_64-linux-gnu/libasan.so.5+0x546a9)
    #1 0x7fc2803249f6 in __interceptor_sprintf (/usr/lib/x86_64-linux-gnu/libasan.so.5+0x549f6)
    #2 0x5579c661e7d2 in get_optstring nftables/src/main.c:128
    #3 0x5579c66202af in main nftables/src/main.c:315
    #4 0x7fc27ea7b09a in __libc_start_main ../csu/libc-start.c:308
    #5 0x5579c661e439 in _start (nftables/src/.libs/nft+0x9439)

0x5579c662e816 is located 0 bytes to the right of global variable 'optstring' defined in 'main.c:121:14' (0x5579c662e800) of size 22
0x5579c662e816 is located 42 bytes to the left of global variable 'options' defined in 'main.c:137:23' (0x5579c662e840) of size 672
SUMMARY: AddressSanitizer: global-buffer-overflow (/usr/lib/x86_64-linux-gnu/libasan.so.5+0x546a9) in vsprintf
Shadow bytes around the buggy address:
  0x0aafb8cbdcb0: f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9
  0x0aafb8cbdcc0: f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9
  0x0aafb8cbdcd0: f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9
  0x0aafb8cbdce0: f9 f9 f9 f9 00 00 00 00 00 00 00 00 00 00 00 00
  0x0aafb8cbdcf0: 00 00 00 00 00 00 00 00 00 f9 f9 f9 f9 f9 f9 f9
=>0x0aafb8cbdd00: 00 00[06]f9 f9 f9 f9 f9 00 00 00 00 00 00 00 00
  0x0aafb8cbdd10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x0aafb8cbdd20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x0aafb8cbdd30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x0aafb8cbdd40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x0aafb8cbdd50: 00 00 00 00 00 00 00 00 00 00 00 00 f9 f9 f9 f9
Shadow byte legend (one shadow byte represents 8 application bytes):
  Addressable:           00
  Partially addressable: 01 02 03 04 05 06 07
  Heap left redzone:       fa
  Freed heap region:       fd
  Stack left redzone:      f1
  Stack mid redzone:       f2
  Stack right redzone:     f3
  Stack after return:      f5
  Stack use after scope:   f8
  Global redzone:          f9
  Global init order:       f6
  Poisoned by user:        f7
  Container overflow:      fc
  Array cookie:            ac
  Intra object redzone:    bb
  ASan internal:           fe
  Left alloca redzone:     ca
  Right alloca redzone:    cb
==28552==ABORTING
---
 src/main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/src/main.c b/src/main.c
index 3dc6b62c..d213c601 100644
--- a/src/main.c
+++ b/src/main.c
@@ -124,10 +124,10 @@ static const char *get_optstring(void)
 		size_t i, j;
 
 		optstring[0] = '+';
-		for (i = 0, j = 1; i < NR_NFT_OPTIONS; i++)
-			j += sprintf(optstring + j, "%c%s",
-				     nft_options[i].val,
-				     nft_options[i].arg ? ":" : "");
+		for (i = 0, j = 1; i < NR_NFT_OPTIONS && j < sizeof(optstring); i++)
+			j += snprintf(optstring + j, sizeof(optstring) - j, "%c%s",
+				      nft_options[i].val,
+				      nft_options[i].arg ? ":" : "");
 	}
 	return optstring;
 }
-- 
2.20.1

