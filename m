Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD6C3C00528
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Aug 2023 19:42:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbjHCTmv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Aug 2023 15:42:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbjHCTmu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Aug 2023 15:42:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 641634206
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Aug 2023 12:42:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691091723;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4Gsf5yipj0DGJeFqKQT/wu/y3zILsxWBQOWzZjXdGFo=;
        b=A3VcgQ+7GZR/RCvjypLiVEh/ty8EnY3lbBa5iaUoVceF9+hJNAnrKwAl0yCH+1lh0Y9tqJ
        mEqpfL6KMmZ7yxat5k+dEXxqqDB440D34duksXo+SpMZEQqipt8Lp4u9lfAjrBZCGOPJmx
        gs4t0pxA2sNqu1K0P+Gy+1rzLcQM36w=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-529-ZqCfDewHOkyxFZHfqRmdEA-1; Thu, 03 Aug 2023 15:42:02 -0400
X-MC-Unique: ZqCfDewHOkyxFZHfqRmdEA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C0EC38DC66C;
        Thu,  3 Aug 2023 19:42:01 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.194.144])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0842B4021520;
        Thu,  3 Aug 2023 19:42:00 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Phil Sutter <phil@nwl.cc>, Thomas Haller <thaller@redhat.com>
Subject: [nft PATCH v4 6/6] py: add Nftables.{get,set}_input() API
Date:   Thu,  3 Aug 2023 21:35:24 +0200
Message-ID: <20230803193940.1105287-13-thaller@redhat.com>
In-Reply-To: <20230803193940.1105287-1-thaller@redhat.com>
References: <20230803193940.1105287-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Similar to the existing Nftables.{get,set}_debug() API.

Only notable (internal) difference is that nft_ctx_input_set_flags()
returns the old value already, so we don't need to call
Nftables.get_input() first.

The benefit of this API, is that it follows the existing API for debug
flags. Also, when future flags are added it requires few changes to the
python code.

The disadvantage is that it looks different from the underlying C API,
which is confusing when reading the C API. Also, it's a bit cumbersome
to reset only one flag. For example:

     def _drop_flag_foo(flag):
        if isinstance(flag, int):
            return flag & ~FOO_NUM
        if flag == 'foo':
            return 0
        return flag

     ctx.set_input(_drop_flag_foo(v) for v in ctx.get_input())

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 py/src/nftables.py | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/py/src/nftables.py b/py/src/nftables.py
index 95c65cde69c4..2b68fe4184cb 100644
--- a/py/src/nftables.py
+++ b/py/src/nftables.py
@@ -37,6 +37,11 @@ class SchemaValidator:
 class Nftables:
     """A class representing libnftables interface"""
 
+    input_flags = {
+        "no-dns": 0x1,
+        "json": 0x2,
+    }
+
     debug_flags = {
         "scanner":   0x1,
         "parser":    0x2,
@@ -84,6 +89,14 @@ class Nftables:
         self.nft_ctx_new.restype = c_void_p
         self.nft_ctx_new.argtypes = [c_int]
 
+        self.nft_ctx_input_get_flags = lib.nft_ctx_input_get_flags
+        self.nft_ctx_input_get_flags.restype = c_uint
+        self.nft_ctx_input_get_flags.argtypes = [c_void_p]
+
+        self.nft_ctx_input_set_flags = lib.nft_ctx_input_set_flags
+        self.nft_ctx_input_set_flags.restype = c_uint
+        self.nft_ctx_input_set_flags.argtypes = [c_void_p, c_uint]
+
         self.nft_ctx_output_get_flags = lib.nft_ctx_output_get_flags
         self.nft_ctx_output_get_flags.restype = c_uint
         self.nft_ctx_output_get_flags.argtypes = [c_void_p]
@@ -185,6 +198,36 @@ class Nftables:
 
         return val
 
+    def get_input(self):
+        """Get currently active input flags.
+
+        Returns a set of flag names. See set_input() for details.
+        """
+        val = self.nft_ctx_input_get_flags(self.__ctx)
+        return self._flags_from_numeric(self.input_flags, val)
+
+    def set_input(self, values):
+        """Set input flags.
+
+        Resets all input flags to values. Accepts either a single flag or a list
+        of flags. Each flag might be given either as string or integer value as
+        shown in the following table:
+
+        Name      | Value (hex)
+        -----------------------
+        "no-dns"  | 0x1
+        "json"    | 0x2
+
+        "no-dns" disables blocking address lookup.
+        "json" enables JSON mode for input.
+
+        Returns a set of previously active input flags, as returned by
+        get_input() method.
+        """
+        val = self._flags_to_numeric(self.input_flags, values)
+        old = self.nft_ctx_input_set_flags(self.__ctx, val)
+        return self._flags_from_numeric(self.input_flags, old)
+
     def __get_output_flag(self, name):
         flag = self.output_flags[name]
         return (self.nft_ctx_output_get_flags(self.__ctx) & flag) != 0
-- 
2.41.0

