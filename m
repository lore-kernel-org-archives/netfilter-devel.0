Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36F14C001DF
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Aug 2023 19:42:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbjHCTm3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Aug 2023 15:42:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbjHCTm2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Aug 2023 15:42:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA4674200
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Aug 2023 12:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691091698;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E2/qtBS6h3UMIZhrk2tWrjiQm3MsKQfIjMS4MpLgFuM=;
        b=UZSQB70fd7dBxdZ2cyipYaCyCQBIZ2MyfNj7J2KSBDcUpGE++xPiWLJFhXOxBA+oZYlfSv
        NAQ3s+4MiopeXuhyV88KCY9jFxAkBhVSJbkmTSVODr9bdgIU1IplRvEiy4O+7fgSAj1opp
        Daxpf6XzVun4Q9/BEb7ZepM8dGA8gRA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-547-3J2GJVFJPciR5sj1f5aCXA-1; Thu, 03 Aug 2023 15:41:36 -0400
X-MC-Unique: 3J2GJVFJPciR5sj1f5aCXA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D1525800159;
        Thu,  3 Aug 2023 19:41:35 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.194.144])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 18C4F40C6CCC;
        Thu,  3 Aug 2023 19:41:34 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Phil Sutter <phil@nwl.cc>, Thomas Haller <thaller@redhat.com>
Subject: [nft PATCH v4 4/6] py: fix exception during cleanup of half-initialized Nftables
Date:   Thu,  3 Aug 2023 21:35:20 +0200
Message-ID: <20230803193940.1105287-9-thaller@redhat.com>
In-Reply-To: <20230803193940.1105287-1-thaller@redhat.com>
References: <20230803193940.1105287-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When we create a Nftables instance against an older library version,
we might not find a symbol and fail with an exception when initializing
the context object.

Then, __del__() is still called, but resulting in a second exception
because self.__ctx is not set. Avoid that second exception.

    $ python -c 'import nftables; nftables.Nftables()'
    Traceback (most recent call last):
      File "<string>", line 1, in <module>
      File "/data/src/nftables/py/nftables.py", line 90, in __init__
        self.nft_ctx_input_get_flags = lib.nft_ctx_input_get_flags
                                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^
      File "/usr/lib64/python3.11/ctypes/__init__.py", line 389, in __getattr__
        func = self.__getitem__(name)
               ^^^^^^^^^^^^^^^^^^^^^^
      File "/usr/lib64/python3.11/ctypes/__init__.py", line 394, in __getitem__
        func = self._FuncPtr((name_or_ordinal, self))
               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    AttributeError: /lib64/libnftables.so.1: undefined symbol: nft_ctx_input_get_flags
    Exception ignored in: <function Nftables.__del__ at 0x7f6315a2c540>
    Traceback (most recent call last):
      File "/data/src/nftables/py/nftables.py", line 166, in __del__
        self.nft_ctx_free(self.__ctx)
        ^^^^^^^^^^^^^^^^^
    AttributeError: 'Nftables' object has no attribute 'nft_ctx_free'

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 py/src/nftables.py | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/py/src/nftables.py b/py/src/nftables.py
index 68fcd7dd103c..b1186781ab5c 100644
--- a/py/src/nftables.py
+++ b/py/src/nftables.py
@@ -74,6 +74,8 @@ class Nftables:
         is requested from the library and buffering of output and error streams
         is turned on.
         """
+        self.__ctx = None
+
         lib = cdll.LoadLibrary(sofile)
 
         ### API function definitions
@@ -150,7 +152,9 @@ class Nftables:
         self.nft_ctx_buffer_error(self.__ctx)
 
     def __del__(self):
-        self.nft_ctx_free(self.__ctx)
+        if self.__ctx is not None:
+            self.nft_ctx_free(self.__ctx)
+            self.__ctx = None
 
     def __get_output_flag(self, name):
         flag = self.output_flags[name]
-- 
2.41.0

