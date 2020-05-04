Return-Path: <SRS0=zdgi=6S=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3EE6C3A5A9
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 May 2020 20:49:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 846E72063A
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 May 2020 20:49:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbgEDUtI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 May 2020 16:49:08 -0400
Received: from smail.fem.tu-ilmenau.de ([141.24.220.41]:57430 "EHLO
        smail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbgEDUtH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 May 2020 16:49:07 -0400
Received: from mail.fem.tu-ilmenau.de (mail-zuse.net.fem.tu-ilmenau.de [172.21.220.54])
        (using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by smail.fem.tu-ilmenau.de (Postfix) with ESMTPS id 0138B200AE;
        Mon,  4 May 2020 22:49:02 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by mail.fem.tu-ilmenau.de (Postfix) with ESMTP id B378C61D8;
        Mon,  4 May 2020 22:49:02 +0200 (CEST)
X-Virus-Scanned: amavisd-new at fem.tu-ilmenau.de
Received: from mail.fem.tu-ilmenau.de ([127.0.0.1])
        by localhost (mail.fem.tu-ilmenau.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id nNAi2Emqi-pW; Mon,  4 May 2020 22:49:01 +0200 (CEST)
Received: from a234.fem.tu-ilmenau.de (ray-controller.net.fem.tu-ilmenau.de [10.42.51.234])
        by mail.fem.tu-ilmenau.de (Postfix) with ESMTP;
        Mon,  4 May 2020 22:49:01 +0200 (CEST)
Received: by a234.fem.tu-ilmenau.de (Postfix, from userid 1000)
        id 051B3306A950; Mon,  4 May 2020 22:49:00 +0200 (CEST)
From:   Michael Braun <michael-dev@fami-braun.de>
To:     netfilter-devel@vger.kernel.org
Cc:     Michael Braun <michael-dev@fami-braun.de>
Subject: [PATCH] rule: fix out of memory write if num_stmts is too low
Date:   Mon,  4 May 2020 22:48:58 +0200
Message-Id: <20200504204858.15009-1-michael-dev@fami-braun.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Running bridge/vlan.t with ASAN, results in the following error.
This patch fixes this

flush table bridge test-bridge
add rule bridge test-bridge input vlan id 1 ip saddr 10.0.0.1
rule.c:2870:5: runtime error: index 2 out of bounds for type 'stmt *[*]'
=================================================================
==1043==ERROR: AddressSanitizer: dynamic-stack-buffer-overflow on address 0x7ffdd69c1350 at pc 0x7f1036f53330 bp 0x7ffdd69c1300 sp 0x7ffdd69c12f8
WRITE of size 8 at 0x7ffdd69c1350 thread T0
    #0 0x7f1036f5332f in payload_try_merge /home/mbr/nftables/src/rule.c:2870
    #1 0x7f1036f534b7 in rule_postprocess /home/mbr/nftables/src/rule.c:2885
    #2 0x7f1036fb2785 in rule_evaluate /home/mbr/nftables/src/evaluate.c:3744
    #3 0x7f1036fb627b in cmd_evaluate_add /home/mbr/nftables/src/evaluate.c:3982
    #4 0x7f1036fbb9e9 in cmd_evaluate /home/mbr/nftables/src/evaluate.c:4462
    #5 0x7f10370652d2 in nft_evaluate /home/mbr/nftables/src/libnftables.c:414
    #6 0x7f1037065ba1 in nft_run_cmd_from_buffer /home/mbr/nftables/src/libnftables.c:447
    #7 0x7f10380098ed in ffi_call_unix64 (/usr/lib/x86_64-linux-gnu/libffi.so.6+0x68ed)
    #8 0x7f10380092be in ffi_call (/usr/lib/x86_64-linux-gnu/libffi.so.6+0x62be)
    #9 0x7f10375214a6 in _ctypes_callproc (/usr/lib/python2.7/lib-dynload/_ctypes.x86_64-linux-gnu.so+0x114a6)
    #10 0x7f1037520e8e  (/usr/lib/python2.7/lib-dynload/_ctypes.x86_64-linux-gnu.so+0x10e8e)
    #11 0x562dca596882 in PyObject_Call (/usr/bin/python2.7+0xd2882)
    #12 0x562dca5ba501 in PyEval_EvalFrameEx (/usr/bin/python2.7+0xf6501)
    #13 0x562dca5ba3b9 in PyEval_EvalFrameEx (/usr/bin/python2.7+0xf63b9)
    #14 0x562dca5b2865 in PyEval_EvalCodeEx (/usr/bin/python2.7+0xee865)
    #15 0x562dca5ba64d in PyEval_EvalFrameEx (/usr/bin/python2.7+0xf664d)
    #16 0x562dca5b2865 in PyEval_EvalCodeEx (/usr/bin/python2.7+0xee865)
    #17 0x562dca5babd7 in PyEval_EvalFrameEx (/usr/bin/python2.7+0xf6bd7)
    #18 0x562dca5b2865 in PyEval_EvalCodeEx (/usr/bin/python2.7+0xee865)
    #19 0x562dca5babd7 in PyEval_EvalFrameEx (/usr/bin/python2.7+0xf6bd7)
    #20 0x562dca5b2865 in PyEval_EvalCodeEx (/usr/bin/python2.7+0xee865)
    #21 0x562dca5babd7 in PyEval_EvalFrameEx (/usr/bin/python2.7+0xf6bd7)
    #22 0x562dca5b2865 in PyEval_EvalCodeEx (/usr/bin/python2.7+0xee865)
    #23 0x562dca5b21f8 in PyEval_EvalCode (/usr/bin/python2.7+0xee1f8)
    #24 0x562dca5e4e2e  (/usr/bin/python2.7+0x120e2e)
    #25 0x562dca5dfd1f in PyRun_FileExFlags (/usr/bin/python2.7+0x11bd1f)
    #26 0x562dca5df6c9 in PyRun_SimpleFileExFlags (/usr/bin/python2.7+0x11b6c9)
    #27 0x562dca580187 in Py_Main (/usr/bin/python2.7+0xbc187)
    #28 0x7f103ab0109a in __libc_start_main ../csu/libc-start.c:308
    #29 0x562dca57fae9 in _start (/usr/bin/python2.7+0xbbae9)

Address 0x7ffdd69c1350 is located in stack of thread T0
SUMMARY: AddressSanitizer: dynamic-stack-buffer-overflow /home/mbr/nftables/src/rule.c:2870 in payload_try_merge
Shadow bytes around the buggy address:
  0x10003ad30210: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x10003ad30220: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x10003ad30230: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x10003ad30240: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x10003ad30250: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
=>0x10003ad30260: 00 00 00 00 ca ca ca ca 00 00[cb]cb cb cb cb cb
  0x10003ad30270: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x10003ad30280: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x10003ad30290: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x10003ad302a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x10003ad302b0: 00 00 00 00 f1 f1 f1 f1 00 00 00 00 00 00 00 00
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
==1043==ABORTING

Signed-off-by: Michael Braun <michael-dev@fami-braun.de>
---
 src/rule.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/src/rule.c b/src/rule.c
index 23b1cbfc..8b17ada0 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -2830,6 +2830,18 @@ static void payload_do_merge(struct stmt *sa[], unsigned int n)
 	}
 }
 
+static unsigned int payload_count_stmts(const struct rule *rule)
+{
+	struct stmt *stmt, *next;
+	unsigned int count = 0;
+
+	list_for_each_entry_safe(stmt, next, &rule->stmts, list) {
+		count++;
+	}
+
+	return count;
+}
+
 /**
  * payload_try_merge - try to merge consecutive payload match statements
  *
@@ -2843,7 +2855,7 @@ static void payload_do_merge(struct stmt *sa[], unsigned int n)
  */
 static void payload_try_merge(const struct rule *rule)
 {
-	struct stmt *sa[rule->num_stmts];
+	struct stmt *sa[payload_count_stmts(rule)];
 	struct stmt *stmt, *next;
 	unsigned int idx = 0;
 
-- 
2.20.1

