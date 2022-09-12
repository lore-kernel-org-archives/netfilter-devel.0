Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 095DBECAAA1
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Sep 2022 10:53:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbiILKxj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 12 Sep 2022 06:53:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiILKxi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Sep 2022 06:53:38 -0400
Received: from mx1.riseup.net (mx1.riseup.net [198.252.153.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F8CC30F58
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2022 03:53:37 -0700 (PDT)
Received: from fews2.riseup.net (fews2-pn.riseup.net [10.0.1.84])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256
         client-signature RSA-PSS (2048 bits) client-digest SHA256)
        (Client CN "mail.riseup.net", Issuer "R3" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 4MR3Nw5ZJ0zDqMh;
        Mon, 12 Sep 2022 10:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1662980016; bh=uqLcDzPv4+ovo1UL5TD55OSsVjsn3oOlu8jVBdPP+L0=;
        h=From:To:Cc:Subject:Date:From;
        b=kfiqrpuCXGN/+KuhLz8gdy7t3A/LC6DXAPck3fC7gN73qInCeLGO/tXMCNshYJ2Yv
         Qw2VFSvqhSBUZq/gtSqGAGaLFsMEV8Mv9Nalo6od0mHjjp4MG748v7FFeK9uXrunaG
         irUK/DAE88Ci/0FheHeqfxkE3ibaeb+9wR3b9qLk=
X-Riseup-User-ID: 4D35C410FEEAB2AAFCDF2CD60D7A3F8469589AA6ACC02EAF08A6A96FEECA7352
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by fews2.riseup.net (Postfix) with ESMTPSA id 4MR3Nv59Mvz1xwy;
        Mon, 12 Sep 2022 10:53:35 +0000 (UTC)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Peter Collinson <pc@hillside.co.uk>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH 1/3 nft] py: extend python API to support libnftables API
Date:   Mon, 12 Sep 2022 12:52:23 +0200
Message-Id: <20220912105225.79025-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Peter Collinson <pc@hillside.co.uk>

Allows py/nftables.py to support full mapping to the libnftables API. The
changes allow python code to talk in text to the kernel rather than just
using json. The Python API can now also use dry run to test changes.

Link: https://bugzilla.netfilter.org/show_bug.cgi?id=1591
Signed-off-by: Peter Collinson <pc@hillside.co.uk>
Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
 py/nftables.py | 82 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 82 insertions(+)

diff --git a/py/nftables.py b/py/nftables.py
index 2a0a1e89..99ba082f 100644
--- a/py/nftables.py
+++ b/py/nftables.py
@@ -116,6 +116,24 @@ class Nftables:
         self.nft_run_cmd_from_buffer.restype = c_int
         self.nft_run_cmd_from_buffer.argtypes = [c_void_p, c_char_p]
 
+        self.nft_run_cmd_from_filename = lib.nft_run_cmd_from_filename
+        self.nft_run_cmd_from_filename.restype = c_int
+        self.nft_run_cmd_from_filename.argtypes = [c_void_p, c_char_p]
+
+        self.nft_ctx_add_include_path = lib.nft_ctx_add_include_path
+        self.nft_ctx_add_include_path.restype = c_int
+        self.nft_ctx_add_include_path.argtypes = [c_void_p, c_char_p]
+
+        self.nft_ctx_clear_include_paths = lib.nft_ctx_clear_include_paths
+        self.nft_ctx_clear_include_paths.argtypes = [c_void_p]
+
+        self.nft_ctx_get_dry_run = lib.nft_ctx_get_dry_run
+        self.nft_ctx_get_dry_run.restype = c_bool
+        self.nft_ctx_get_dry_run.argtypes = [c_void_p]
+
+        self.nft_ctx_set_dry_run = lib.nft_ctx_set_dry_run
+        self.nft_ctx_set_dry_run.argtypes = [c_void_p, c_bool]
+
         self.nft_ctx_free = lib.nft_ctx_free
         lib.nft_ctx_free.argtypes = [c_void_p]
 
@@ -446,3 +464,67 @@ class Nftables:
 
         self.validator.validate(json_root)
         return True
+
+    def cmd_from_file(self, filename):
+        """Run a nftables command set from a file
+
+        filename can be a str or a Path
+
+        Returns a tuple (rc, output, error):
+        rc     -- return code as returned by nft_run_cmd_from_buffer() function
+        output -- a string containing output written to stdout
+        error  -- a string containing output written to stderr
+        """
+
+        filename_is_unicode = False
+        if not isinstance(filename, bytes):
+            filename_is_unicode = True
+            # allow filename to be a Path
+            filename = str(filename)
+            filename= filename.encode("utf-8")
+        rc = self.nft_run_cmd_from_filename(self.__ctx, filename)
+        output = self.nft_ctx_get_output_buffer(self.__ctx)
+        error = self.nft_ctx_get_error_buffer(self.__ctx)
+        if filename_is_unicode:
+            output = output.decode("utf-8")
+            error = error.decode("utf-8")
+        return (rc, output, error)
+
+    def add_include_path(self, filename):
+        """Add a path to the include file list
+        The default list includes /etc
+
+        Returns True on success
+        False if memory allocation fails
+        """
+
+        if not isinstance(filename, bytes):
+            # allow filename to be a Path
+            filename = str(filename)
+            filename= filename.encode("utf-8")
+        rc = self.nft_ctx_add_include_path(self.__ctx, filename)
+        return rc == 0
+
+    def clear_include_paths(self):
+        """Clear include path list
+
+        Will also remove /etc
+        """
+
+        self.nft_ctx_clear_include_paths(self.__ctx)
+
+    def get_dry_run(self):
+        """Get dry run state
+
+        Returns True if set, False otherwise
+        """
+
+        return self.nft_ctx_get_dry_run(self.__ctx)
+
+    def set_dry_run(self, onoff):
+        """ Set dry run state
+
+        Called with True/False
+        """
+
+        self.nft_ctx_set_dry_run(self.__ctx, onoff)
-- 
2.30.2

