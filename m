Return-Path: <SRS0=jxct=TK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90734C04A6B
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 May 2019 12:29:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D7BD2173B
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 May 2019 12:29:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727383AbfEJM3y (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 10 May 2019 08:29:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45122 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727071AbfEJM3y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 May 2019 08:29:54 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3D113308402A;
        Fri, 10 May 2019 12:29:53 +0000 (UTC)
Received: from egarver.remote.csb (ovpn-120-252.rdu2.redhat.com [10.10.120.252])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 753DD1001E6E;
        Fri, 10 May 2019 12:29:50 +0000 (UTC)
From:   Eric Garver <eric@garver.life>
To:     netfilter-devel@vger.kernel.org
Cc:     Phil Sutter <phil@nwl.cc>
Subject: [PATCH nft v2] py: fix missing decode/encode of strings
Date:   Fri, 10 May 2019 08:29:47 -0400
Message-Id: <20190510122947.29854-1-eric@garver.life>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Fri, 10 May 2019 12:29:53 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When calling ffi functions, if the string is unicode we need to convert
to utf-8. Then convert back for any output we receive.

Fixes: 586ad210368b7 ("libnftables: Implement JSON parser")
Signed-off-by: Eric Garver <eric@garver.life>
---
v2: allow python2 support by checking if the string is already "bytes".
python2 str uses bytes, python3 str uses unicode.
---
 py/nftables.py | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/py/nftables.py b/py/nftables.py
index f07163573f9a..33cd2dfd736d 100644
--- a/py/nftables.py
+++ b/py/nftables.py
@@ -352,9 +352,16 @@ class Nftables:
         output -- a string containing output written to stdout
         error  -- a string containing output written to stderr
         """
+        cmdline_is_unicode = False
+        if not isinstance(cmdline, bytes):
+            cmdline_is_unicode = True
+            cmdline = cmdline.encode("utf-8")
         rc = self.nft_run_cmd_from_buffer(self.__ctx, cmdline)
         output = self.nft_ctx_get_output_buffer(self.__ctx)
         error = self.nft_ctx_get_error_buffer(self.__ctx)
+        if cmdline_is_unicode:
+            output = output.decode("utf-8")
+            error = error.decode("utf-8")
 
         return (rc, output, error)
 
-- 
2.20.1

