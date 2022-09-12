Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17AEEECAAD5
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Sep 2022 10:53:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbiILKxr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 12 Sep 2022 06:53:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiILKxp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Sep 2022 06:53:45 -0400
Received: from mx0.riseup.net (mx0.riseup.net [198.252.153.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D3531365
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2022 03:53:40 -0700 (PDT)
Received: from fews2.riseup.net (fews2-pn.riseup.net [10.0.1.84])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256
         client-signature RSA-PSS (2048 bits) client-digest SHA256)
        (Client CN "mail.riseup.net", Issuer "R3" (not verified))
        by mx0.riseup.net (Postfix) with ESMTPS id 4MR3P01lvbz9s3P
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2022 10:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1662980020; bh=aWVgPe374NPlssnqURb4cnHgUpQdXbh/9gIb+JkUFbw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kOdK4KBdnJo/r3Vxf5Zwx713rCRs7hObyz0zi+Lrlc5A7YUoTcUFjC21bU2AN8A9O
         667hyf61wcbpB8p4HzWR6hMsIpF7D249dqdMNRseZWzeoowW20bKyt/Kxh3FBnxhsP
         KJUFPcEWrT+Z7VW42MPjn0bMdD7k6Z+BK7zEc2/E=
X-Riseup-User-ID: 40C9F28CCDFED6E0C6D07C88A4EB8F91A2A3E21A5D2E887BE78EFD24A24CA4E8
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by fews2.riseup.net (Postfix) with ESMTPSA id 4MR3Nz2lYDz1xx3;
        Mon, 12 Sep 2022 10:53:39 +0000 (UTC)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH 2/3 nft] py: support variables management and fix formatting
Date:   Mon, 12 Sep 2022 12:52:24 +0200
Message-Id: <20220912105225.79025-2-ffmancera@riseup.net>
In-Reply-To: <20220912105225.79025-1-ffmancera@riseup.net>
References: <20220912105225.79025-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add nft_ctx_add_var() and nft_ctx_clear_vars() support through add_var() and
clear_vars(). Also, fix some functions documentation and drop unnecesary
comments.

In addition, modify get_dry_run() to return the previous value set. This is
needed to be consistent with the rest of the python API.

Link: https://bugzilla.netfilter.org/show_bug.cgi?id=1591
Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
 py/nftables.py | 43 ++++++++++++++++++++++++++++++-------------
 1 file changed, 30 insertions(+), 13 deletions(-)

diff --git a/py/nftables.py b/py/nftables.py
index 99ba082f..6daeafc2 100644
--- a/py/nftables.py
+++ b/py/nftables.py
@@ -134,6 +134,13 @@ class Nftables:
         self.nft_ctx_set_dry_run = lib.nft_ctx_set_dry_run
         self.nft_ctx_set_dry_run.argtypes = [c_void_p, c_bool]
 
+        self.nft_ctx_add_var = lib.nft_ctx_add_var
+        self.nft_ctx_add_var.restype = c_int
+        self.nft_ctx_add_var.argtypes = [c_void_p, c_char_p]
+
+        self.nft_ctx_clear_vars = lib.nft_ctx_clear_vars
+        self.nft_ctx_clear_vars.argtypes = [c_void_p]
+
         self.nft_ctx_free = lib.nft_ctx_free
         lib.nft_ctx_free.argtypes = [c_void_p]
 
@@ -471,15 +478,13 @@ class Nftables:
         filename can be a str or a Path
 
         Returns a tuple (rc, output, error):
-        rc     -- return code as returned by nft_run_cmd_from_buffer() function
+        rc     -- return code as returned by nft_run_cmd_from_filename() function
         output -- a string containing output written to stdout
         error  -- a string containing output written to stderr
         """
-
         filename_is_unicode = False
         if not isinstance(filename, bytes):
             filename_is_unicode = True
-            # allow filename to be a Path
             filename = str(filename)
             filename= filename.encode("utf-8")
         rc = self.nft_run_cmd_from_filename(self.__ctx, filename)
@@ -492,14 +497,11 @@ class Nftables:
 
     def add_include_path(self, filename):
         """Add a path to the include file list
-        The default list includes /etc
+        The default list includes the built-in default one
 
-        Returns True on success
-        False if memory allocation fails
+        Returns True on success, False if memory allocation fails
         """
-
         if not isinstance(filename, bytes):
-            # allow filename to be a Path
             filename = str(filename)
             filename= filename.encode("utf-8")
         rc = self.nft_ctx_add_include_path(self.__ctx, filename)
@@ -508,9 +510,8 @@ class Nftables:
     def clear_include_paths(self):
         """Clear include path list
 
-        Will also remove /etc
+        Will also remove the built-in default one
         """
-
         self.nft_ctx_clear_include_paths(self.__ctx)
 
     def get_dry_run(self):
@@ -518,13 +519,29 @@ class Nftables:
 
         Returns True if set, False otherwise
         """
-
         return self.nft_ctx_get_dry_run(self.__ctx)
 
     def set_dry_run(self, onoff):
         """ Set dry run state
 
-        Called with True/False
+        Returns the previous dry run state
         """
-
+        old = self.get_dry_run()
         self.nft_ctx_set_dry_run(self.__ctx, onoff)
+
+        return old
+
+    def add_var(self, var):
+        """Add a variable to the variable list
+
+        Returns True if added, False otherwise
+        """
+        if not isinstance(var, bytes):
+            var = var.encode("utf-8")
+        rc = self.nft_ctx_add_var(self.__ctx, var)
+        return rc == 0
+
+    def clear_vars(self):
+        """Clear variable list
+        """
+        self.nft_ctx_clear_vars(self.__ctx)
-- 
2.30.2

