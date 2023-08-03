Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D0D7C001DF
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Aug 2023 19:42:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231187AbjHCTmi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Aug 2023 15:42:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbjHCTmh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Aug 2023 15:42:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C3C83C3E
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Aug 2023 12:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691091712;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Jahh2dz9WnGpt4/VMzj1QgQFCsny/D1VbciFs6sPL3w=;
        b=G7OIHOoz5N30kehmMslbbfIZxP+2/OTa44OnibFM2/Ebh+vJvyASon9yKxaVDvZaVFDk0d
        lQUyQdVanVKLM7UsLAICg4dD59HHobFvSOFhQF6/0JcyK2nQ8aRP0lt+Pb82xslQGJxXBU
        w0Pb7whO+Uw7UVvY1Hd7Ry8JkBw3EPA=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-7-cYKRJtEtMtGH5PNdyo-gfQ-1; Thu, 03 Aug 2023 15:41:47 -0400
X-MC-Unique: cYKRJtEtMtGH5PNdyo-gfQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CE1883C13937;
        Thu,  3 Aug 2023 19:41:46 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.194.144])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D67DC4021520;
        Thu,  3 Aug 2023 19:41:45 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Phil Sutter <phil@nwl.cc>, Thomas Haller <thaller@redhat.com>
Subject: [nft PATCH v4 5/6] py: extract flags helper functions for set_debug()/get_debug()
Date:   Thu,  3 Aug 2023 21:35:22 +0200
Message-ID: <20230803193940.1105287-11-thaller@redhat.com>
In-Reply-To: <20230803193940.1105287-1-thaller@redhat.com>
References: <20230803193940.1105287-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Will be re-used for nft_ctx_input_set_flags() and
nft_ctx_input_get_flags().

There are changes in behavior here.

- when passing an unrecognized string (e.g. `ctx.set_debug('foo')` or
  `ctx.set_debug(['foo'])`), a ValueError is now raised instead of a
  KeyError.

- when passing an out-of-range integer, now a ValueError is no raised.
  Previously the integer was truncated to 32bit.

Changing the exception is an API change, but most likely nobody will
care or try to catch a KeyError to find out whether a flag is supported.
Especially, since such a check would be better performed via `'foo' in
ctx.debug_flags`.

In other cases, a TypeError is raised as before.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 py/src/nftables.py | 52 +++++++++++++++++++++++++++-------------------
 1 file changed, 31 insertions(+), 21 deletions(-)

diff --git a/py/src/nftables.py b/py/src/nftables.py
index b1186781ab5c..95c65cde69c4 100644
--- a/py/src/nftables.py
+++ b/py/src/nftables.py
@@ -156,6 +156,35 @@ class Nftables:
             self.nft_ctx_free(self.__ctx)
             self.__ctx = None
 
+    def _flags_from_numeric(self, flags_dict, val):
+        names = []
+        for n, v in flags_dict.items():
+            if val & v:
+                names.append(n)
+                val &= ~v
+        if val:
+            names.append(val)
+        return names
+
+    def _flags_to_numeric(self, flags_dict, values):
+        if isinstance(values, (str, int)):
+            values = (values,)
+
+        val = 0
+        for v in values:
+            if isinstance(v, str):
+                v = flags_dict.get(v)
+                if v is None:
+                    raise ValueError("Invalid argument")
+            elif isinstance(v, int):
+                if v < 0 or v > 0xFFFFFFFF:
+                    raise ValueError("Invalid argument")
+            else:
+                raise TypeError("Not a valid flag")
+            val |= v
+
+        return val
+
     def __get_output_flag(self, name):
         flag = self.output_flags[name]
         return (self.nft_ctx_output_get_flags(self.__ctx) & flag) != 0
@@ -375,16 +404,7 @@ class Nftables:
         Returns a set of flag names. See set_debug() for details.
         """
         val = self.nft_ctx_output_get_debug(self.__ctx)
-
-        names = []
-        for n,v in self.debug_flags.items():
-            if val & v:
-                names.append(n)
-                val &= ~v
-        if val:
-            names.append(val)
-
-        return names
+        return self._flags_from_numeric(self.debug_flags, val)
 
     def set_debug(self, values):
         """Set debug output flags.
@@ -406,19 +426,9 @@ class Nftables:
         Returns a set of previously active debug flags, as returned by
         get_debug() method.
         """
+        val = self._flags_to_numeric(self.debug_flags, values)
         old = self.get_debug()
-
-        if type(values) in [str, int]:
-            values = [values]
-
-        val = 0
-        for v in values:
-            if type(v) is str:
-                v = self.debug_flags[v]
-            val |= v
-
         self.nft_ctx_output_set_debug(self.__ctx, val)
-
         return old
 
     def cmd(self, cmdline):
-- 
2.41.0

