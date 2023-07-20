Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8D09EB64DD
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Jul 2023 14:32:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbjGTOcw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Jul 2023 10:32:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231293AbjGTOcw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Jul 2023 10:32:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D96F26AD
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Jul 2023 07:32:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689863523;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/FFg+Shveq1rwruBhJh8Oh1SOYL5hrtL0zSKAqH0R1k=;
        b=Yp/JQ0oArbhC2EVBw4IZK76d2GyRAKVEHvRvK/nrbcgAyQ1/6HhdumHEBN/d5/m+q7eJDQ
        9ChM28n6iZM06lzrpvmhc4lfxg0bGDMCB5DgRK2o0E92Zt6JoxJqQb1QLhP3Ig4t7jlZWi
        LzAYa0t3rLLJZ0kjvdlG67riFSxYYGw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-145-SFG_Kp9bNXSsC_MGVU_oXg-1; Thu, 20 Jul 2023 10:32:00 -0400
X-MC-Unique: SFG_Kp9bNXSsC_MGVU_oXg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 091651044590;
        Thu, 20 Jul 2023 14:32:00 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.210])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 45B6C40C206F;
        Thu, 20 Jul 2023 14:31:59 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
        Thomas Haller <thaller@redhat.com>
Subject: [nft v3 PATCH 4/4] py: add Nftables.input_{set,get}_flags() API
Date:   Thu, 20 Jul 2023 16:27:03 +0200
Message-ID: <20230720143147.669250-5-thaller@redhat.com>
In-Reply-To: <20230720143147.669250-1-thaller@redhat.com>
References: <20230720143147.669250-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add new API to expose the input flags in the Python API.

Note that the chosen approach differs from the existing
nft_ctx_output_get_flags() and nft_ctx_output_get_debug()
API, which themselves are inconsistent approaches.

The new API directly exposes the underlying C API, that is, the numeric
flags.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 py/nftables.py | 54 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/py/nftables.py b/py/nftables.py
index 68fcd7dd103c..e2417b7598c0 100644
--- a/py/nftables.py
+++ b/py/nftables.py
@@ -21,6 +21,29 @@ import os
 
 NFTABLES_VERSION = "0.1"
 
+"""Prevent blocking DNS lookups for IP addresses.
+
+By default, nftables will try to resolve IP addresses with blocking getaddrinfo() API.
+By setting this flag, only literal IP addresses are supported in input.
+
+This numeric flag can be passed to Nftables.input_get_flags() and is returned
+by Nftables.input_set_flags().
+"""
+NFT_CTX_INPUT_NO_DNS = 1
+
+"""Attempt to parse input in JSON format.
+
+By default, input will be parsed using the nftables format. By setting
+this flag, the parsing will first attempt to read the input in the
+JSON format as documented in libnftables-json manual. This flag is
+implied by NFT_CTX_OUTPUT_JSON flag (Nftables.set_json_output()).
+
+This numeric flag can be passed to Nftables.input_get_flags() and is returned
+by Nftables.input_set_flags().
+"""
+NFT_CTX_INPUT_JSON = 2
+
+
 class SchemaValidator:
     """Libnftables JSON validator using jsonschema"""
 
@@ -82,6 +105,13 @@ class Nftables:
         self.nft_ctx_new.restype = c_void_p
         self.nft_ctx_new.argtypes = [c_int]
 
+        self.nft_ctx_input_get_flags = lib.nft_ctx_input_get_flags
+        self.nft_ctx_input_get_flags.restype = c_uint
+        self.nft_ctx_input_get_flags.argtypes = [c_void_p]
+
+        self.nft_ctx_input_set_flags = lib.nft_ctx_input_set_flags
+        self.nft_ctx_input_set_flags.argtypes = [c_void_p, c_uint]
+
         self.nft_ctx_output_get_flags = lib.nft_ctx_output_get_flags
         self.nft_ctx_output_get_flags.restype = c_uint
         self.nft_ctx_output_get_flags.argtypes = [c_void_p]
@@ -152,6 +182,30 @@ class Nftables:
     def __del__(self):
         self.nft_ctx_free(self.__ctx)
 
+    def input_get_flags(self):
+        """Query input flags for the nft context.
+
+        See input_get_flags() for supported flags.
+
+        Returns the currently set input flags as number.
+        """
+        return self.nft_ctx_input_get_flags(self.__ctx)
+
+    def input_set_flags(self, flags):
+        """Set input flags for the nft context as number.
+
+        By default, a new context objects has flags set to zero.
+
+        The following flags are currently supported.
+        NFT_CTX_INPUT_NO_DNS (0x1) disables blocking address lookup.
+        NFT_CTX_INPUT_JSON (0x2) enables JSON mode for input.
+
+        Unknown flags are silently accepted.
+
+        Returns nothing.
+        """
+        self.nft_ctx_input_set_flags(self.__ctx, flags)
+
     def __get_output_flag(self, name):
         flag = self.output_flags[name]
         return (self.nft_ctx_output_get_flags(self.__ctx) & flag) != 0
-- 
2.41.0

