Return-Path: <SRS0=QQeY=TB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDE10C43219
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 May 2019 16:35:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADF3920835
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 May 2019 16:35:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbfEAQfD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 May 2019 12:35:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53958 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726224AbfEAQfD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 May 2019 12:35:03 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 400BE3082E57;
        Wed,  1 May 2019 16:35:03 +0000 (UTC)
Received: from egarver.remote.csb (ovpn-122-125.rdu2.redhat.com [10.10.122.125])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8EA1070C48;
        Wed,  1 May 2019 16:35:02 +0000 (UTC)
From:   Eric Garver <eric@garver.life>
To:     netfilter-devel@vger.kernel.org
Cc:     Phil Sutter <phil@nwl.cc>
Subject: [PATCH nft] py: fix missing decode/encode of strings
Date:   Wed,  1 May 2019 12:35:00 -0400
Message-Id: <20190501163500.29662-1-eric@garver.life>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Wed, 01 May 2019 16:35:03 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When calling ffi functions we need to convert from python strings to
utf-8. Then convert back for any output we receive.

Fixes: 586ad210368b7 ("libnftables: Implement JSON parser")
Signed-off-by: Eric Garver <eric@garver.life>
---
 py/nftables.py | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/py/nftables.py b/py/nftables.py
index f07163573f9a..dea417e587d6 100644
--- a/py/nftables.py
+++ b/py/nftables.py
@@ -352,9 +352,9 @@ class Nftables:
         output -- a string containing output written to stdout
         error  -- a string containing output written to stderr
         """
-        rc = self.nft_run_cmd_from_buffer(self.__ctx, cmdline)
-        output = self.nft_ctx_get_output_buffer(self.__ctx)
-        error = self.nft_ctx_get_error_buffer(self.__ctx)
+        rc = self.nft_run_cmd_from_buffer(self.__ctx, cmdline.encode("utf-8"))
+        output = self.nft_ctx_get_output_buffer(self.__ctx).decode("utf-8")
+        error = self.nft_ctx_get_error_buffer(self.__ctx).decode("utf-8")
 
         return (rc, output, error)
 
-- 
2.20.1

