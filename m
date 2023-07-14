Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F932C001DE
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Jul 2023 08:50:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235439AbjGNIut (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 14 Jul 2023 04:50:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235517AbjGNIus (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 14 Jul 2023 04:50:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C24EA26B2
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Jul 2023 01:49:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689324599;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9TjVXwn7iD/vD0Qhmgtp+Jj1u5DqSWW5VUu9BhWccyw=;
        b=LM3qc9twZBFvAZpIW0a7X3iC14k7YXsHKjUu3Jyrz0mxtEsZPmWohbiKM/g/t4lWQCo6uE
        gk9f2YEaBVMoCjRfORmGOeRSbN0BIT/cn9sjBuBGE1w+M1rY1HczyCzc5sqjGCVtxCA1yb
        jg1y6JagHT8fjTMfimFx701xqmJj+/s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-111-RoLCYWabOPOpIilWu1aXNg-1; Fri, 14 Jul 2023 04:49:57 -0400
X-MC-Unique: RoLCYWabOPOpIilWu1aXNg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 54EDB1064B40;
        Fri, 14 Jul 2023 08:49:57 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.135])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AF444492B03;
        Fri, 14 Jul 2023 08:49:56 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Thomas Haller <thaller@redhat.com>
Subject: [nft v2 PATCH 3/3] py: add input_{set,get}_flags() API to helpers
Date:   Fri, 14 Jul 2023 10:48:53 +0200
Message-ID: <20230714084943.1080757-3-thaller@redhat.com>
In-Reply-To: <20230714084943.1080757-1-thaller@redhat.com>
References: <ZKxG23yJzlRRPpsO@calendula>
 <20230714084943.1080757-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Note that the corresponding API for output flags does not expose the
plain numeric flags. Instead, it exposes the underlying, flag-based C
API more directly.

Reasons:

- a flags property has the benefits that adding new flags is very light
  weight. Otherwise, every addition of a flag requires new API. That new
  API increases the documentation and what the user needs to understand.
  With a flag API, we just need new documentation what the new flag is.
  It's already clear how to use it.

- opinionated, also the usage of "many getter/setter API" is not have
  better usability. Its convenient when we can do similar things (setting
  a boolean flag) depending on an argument of a function, instead of
  having different functions.

  Compare

     ctx.set_reversedns_output(True)
     ctx.set_handle_output(True)

  with

     ctx.ouput_set_flags(NFT_CTX_OUTPUT_REVERSEDNS | NFT_CTX_OUTPUT_HANDLE)

  Note that the vast majority of users of this API will just create one
  nft_ctx instance and set the flags once. Each user application
  probably has only one place where they call the setter once. So
  while I think flags have better usability, it doesn't matter much
  either way.

- if individual properties are preferable over flags, then the C API
  should also do that. In other words, the Python API should be similar
  to the underlying C API.

- I don't understand how to do this best. Is Nftables.output_flags
  public API? It appears to be, as it has no underscore. Why does this
  additional mapping from function (get_reversedns_output()) to name
  ("reversedns") to number (1<<0) exist?

Downside is the inconsistency with the existing output flags API.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---

This is probably a controversial approach :)

 py/nftables.py | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/py/nftables.py b/py/nftables.py
index b9fa63bb8789..795700db45ef 100644
--- a/py/nftables.py
+++ b/py/nftables.py
@@ -21,6 +21,16 @@ import os
 
 NFTABLES_VERSION = "0.1"
 
+"""Prevent blocking DNS lookups for IP addresses.
+
+By default, nftables will try to resolve IP addresses with blocking getaddrinfo() API.
+By setting this flag, only literal IP adddresses are supported in input.
+
+This numeric flag can be passed to Nftables.input_get_flags() and Nftables.input_set_flags().
+"""
+NFT_CTX_INPUT_NO_DNS = 1
+
+
 class SchemaValidator:
     """Libnftables JSON validator using jsonschema"""
 
@@ -159,6 +169,27 @@ class Nftables:
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
+        By default, a new context objects has no flags set.
+
+        Supported flags are NFT_CTX_INPUT_NO_DNS (0x1) to disable blocking address
+        lookup via getaddrinfo.
+
+        Returns nothing.
+        """
+        self.nft_ctx_input_set_flags(self.__ctx, flags)
+
     def __get_output_flag(self, name):
         flag = self.output_flags[name]
         return self.nft_ctx_output_get_flags(self.__ctx) & flag
-- 
2.41.0

