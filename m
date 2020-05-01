Return-Path: <SRS0=Z556=6P=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01BB5C4724C
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 May 2020 15:57:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF00424956
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 May 2020 15:57:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729914AbgEAP5W (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 May 2020 11:57:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729860AbgEAP5V (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 May 2020 11:57:21 -0400
Received: from smail.fem.tu-ilmenau.de (smail.fem.tu-ilmenau.de [IPv6:2001:638:904:ffbf::41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1071C061A0E
        for <netfilter-devel@vger.kernel.org>; Fri,  1 May 2020 08:57:21 -0700 (PDT)
Received: from mail.fem.tu-ilmenau.de (mail-zuse.net.fem.tu-ilmenau.de [172.21.220.54])
        (using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by smail.fem.tu-ilmenau.de (Postfix) with ESMTPS id EB52E203F8;
        Fri,  1 May 2020 17:48:28 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by mail.fem.tu-ilmenau.de (Postfix) with ESMTP id B51FD6207;
        Fri,  1 May 2020 17:48:28 +0200 (CEST)
X-Virus-Scanned: amavisd-new at fem.tu-ilmenau.de
Received: from mail.fem.tu-ilmenau.de ([127.0.0.1])
        by localhost (mail.fem.tu-ilmenau.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id F5wK7f9jpT6P; Fri,  1 May 2020 17:48:26 +0200 (CEST)
Received: from a234.fem.tu-ilmenau.de (ray-controller.net.fem.tu-ilmenau.de [10.42.51.234])
        by mail.fem.tu-ilmenau.de (Postfix) with ESMTP;
        Fri,  1 May 2020 17:48:26 +0200 (CEST)
Received: by a234.fem.tu-ilmenau.de (Postfix, from userid 1000)
        id 95B2C306A96B; Fri,  1 May 2020 17:48:26 +0200 (CEST)
From:   Michael Braun <michael-dev@fami-braun.de>
To:     netfilter-devel@vger.kernel.org
Cc:     Michael Braun <michael-dev@fami-braun.de>
Subject: [PATCH 3/3] datatype: fix double-free resulting in use-after-free in datatype_free
Date:   Fri,  1 May 2020 17:48:18 +0200
Message-Id: <20200501154819.2984-3-michael-dev@fami-braun.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200501154819.2984-1-michael-dev@fami-braun.de>
References: <20200501154819.2984-1-michael-dev@fami-braun.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nft list table bridge t
table bridge t {
        set s4 {
                typeof ip saddr . ip daddr
                elements = { 1.0.0.1 . 2.0.0.2 }
        }
}
=================================================================
==24334==ERROR: AddressSanitizer: heap-use-after-free on address 0x6080000000a8 at pc 0x7fe0e67df0ad bp 0x7ffff83e88c0 sp 0x7ffff83e88b8
READ of size 4 at 0x6080000000a8 thread T0
    #0 0x7fe0e67df0ac in datatype_free nftables/src/datatype.c:1110
    #1 0x7fe0e67e2092 in expr_free nftables/src/expression.c:89
    #2 0x7fe0e67a855e in set_free nftables/src/rule.c:359
    #3 0x7fe0e67b2f3e in table_free nftables/src/rule.c:1263
    #4 0x7fe0e67a70ce in __cache_flush nftables/src/rule.c:299
    #5 0x7fe0e67a71c7 in cache_release nftables/src/rule.c:305
    #6 0x7fe0e68dbfa9 in nft_ctx_free nftables/src/libnftables.c:292
    #7 0x55f00fbe0051 in main nftables/src/main.c:469
    #8 0x7fe0e553309a in __libc_start_main ../csu/libc-start.c:308
    #9 0x55f00fbdd429 in _start (nftables/src/.libs/nft+0x9429)

0x6080000000a8 is located 8 bytes inside of 96-byte region [0x6080000000a0,0x608000000100)
freed by thread T0 here:
    #0 0x7fe0e6e70fb0 in __interceptor_free (/usr/lib/x86_64-linux-gnu/libasan.so.5+0xe8fb0)
    #1 0x7fe0e68b8122 in xfree nftables/src/utils.c:29
    #2 0x7fe0e67df2e5 in datatype_free nftables/src/datatype.c:1117
    #3 0x7fe0e67e2092 in expr_free nftables/src/expression.c:89
    #4 0x7fe0e67a83fe in set_free nftables/src/rule.c:356
    #5 0x7fe0e67b2f3e in table_free nftables/src/rule.c:1263
    #6 0x7fe0e67a70ce in __cache_flush nftables/src/rule.c:299
    #7 0x7fe0e67a71c7 in cache_release nftables/src/rule.c:305
    #8 0x7fe0e68dbfa9 in nft_ctx_free nftables/src/libnftables.c:292
    #9 0x55f00fbe0051 in main nftables/src/main.c:469
    #10 0x7fe0e553309a in __libc_start_main ../csu/libc-start.c:308

previously allocated by thread T0 here:
    #0 0x7fe0e6e71330 in __interceptor_malloc (/usr/lib/x86_64-linux-gnu/libasan.so.5+0xe9330)
    #1 0x7fe0e68b813d in xmalloc nftables/src/utils.c:36
    #2 0x7fe0e68b8296 in xzalloc nftables/src/utils.c:65
    #3 0x7fe0e67de7d5 in dtype_alloc nftables/src/datatype.c:1065
    #4 0x7fe0e67df862 in concat_type_alloc nftables/src/datatype.c:1146
    #5 0x7fe0e67ea852 in concat_expr_parse_udata nftables/src/expression.c:954
    #6 0x7fe0e685dc94 in set_make_key nftables/src/netlink.c:718
    #7 0x7fe0e685e177 in netlink_delinearize_set nftables/src/netlink.c:770
    #8 0x7fe0e685f667 in list_set_cb nftables/src/netlink.c:895
    #9 0x7fe0e4f95a03 in nftnl_set_list_foreach src/set.c:904

SUMMARY: AddressSanitizer: heap-use-after-free nftables/src/datatype.c:1110 in datatype_free
Shadow bytes around the buggy address:
  0x0c107fff7fc0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x0c107fff7fd0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x0c107fff7fe0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x0c107fff7ff0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x0c107fff8000: fa fa fa fa fd fd fd fd fd fd fd fd fd fd fd fd
=>0x0c107fff8010: fa fa fa fa fd[fd]fd fd fd fd fd fd fd fd fd fd
  0x0c107fff8020: fa fa fa fa fd fd fd fd fd fd fd fd fd fd fd fd
  0x0c107fff8030: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
  0x0c107fff8040: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
  0x0c107fff8050: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
  0x0c107fff8060: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
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
==24334==ABORTING
---
 src/datatype.c   | 2 ++
 src/expression.c | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/src/datatype.c b/src/datatype.c
index 095598d9..0110846f 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -1083,6 +1083,8 @@ struct datatype *datatype_get(const struct datatype *ptr)
 
 void datatype_set(struct expr *expr, const struct datatype *dtype)
 {
+	if (dtype == expr->dtype)
+		return; // do not free dtype before incrementing refcnt again
 	datatype_free(expr->dtype);
 	expr->dtype = datatype_get(dtype);
 }
diff --git a/src/expression.c b/src/expression.c
index 6605beb3..a6bde70f 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -955,7 +955,7 @@ static struct expr *concat_expr_parse_udata(const struct nftnl_udata *attr)
 	if (!dtype)
 		goto err_free;
 
-	concat_expr->dtype = dtype;
+	concat_expr->dtype = datatype_get(dtype);
 	concat_expr->len = dtype->size;
 
 	return concat_expr;
-- 
2.20.1

