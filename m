Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 127E9C00140
	for <netfilter-devel@archiver.kernel.org>; Wed, 10 Aug 2022 09:48:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbiHJJst (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 10 Aug 2022 05:48:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiHJJss (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 10 Aug 2022 05:48:48 -0400
X-Greylist: delayed 2613 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 10 Aug 2022 02:48:43 PDT
Received: from wood.hillside.co.uk (wood.hillside.co.uk [IPv6:2a00:1098:82:11::1:1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C83A061DA6
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2022 02:48:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=wood.hillside.co.uk; s=wood; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=4r6cmUhLl4TWphiJehmHHV4Lhz+05z/fkJpTz0EU3/I=; b=g0YUqsivxY+0CCwxKjOi4QUBJy
        qtATh65DZI9Wfj8mqVbvA5igqT8dTt69Er9wVa3ShljEFCfj4ww+B6yk5bLFtAdFT47pAdpD3VRQy
        wiFKluSLAuCg3LEdLthPQLKmdF7VZcJkDBIGMWKBek5f9EUh6fgPvfx+Qo6IcH1bt7+u7FnQyi5Cz
        3PNexkcWU1uo32wf7eNygOfhaRflSi4/QgoGdoQaIX+RX+mN2+toTEkm6to3votk9UXwW2Da+LVu1
        oEkzuUUbkgqGokgA5RfOLnsc9oZ5gSFtPqIadIWqthY3wloSo2QgiEMkz4stT479GCIJ6v2O2Xl26
        qFlpz8zA==;
Received: from craggy.hillside.co.uk ([81.138.86.234])
        by wood.hillside.co.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pc@wood.hillside.co.uk>)
        id 1oLheH-000Q2j-J7; Wed, 10 Aug 2022 10:05:08 +0100
Received: from pc by craggy.hillside.co.uk with local (Exim 4.94.2)
        (envelope-from <pc@hillside.co.uk>)
        id 1oLheF-0007aE-Ct; Wed, 10 Aug 2022 10:05:07 +0100
From:   Peter Collinson <11645080+pcollinson@users.noreply.github.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Peter Collinson <11645080+pcollinson@users.noreply.github.com>,
        Peter Collinson <pc@hillside.co.uk>
Subject: [PATCH] Extends py/nftables.py
Date:   Wed, 10 Aug 2022 10:04:50 +0100
Message-Id: <20220810090450.29054-1-11645080+pcollinson@users.noreply.github.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: pc@wood.hillside.co.uk
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Allows py/nftables.py to support full mapping to the libnftables API. The
changes allow python code to talk in text to the kernel rather than just
using json. The Python API can now also use dryruns to test changes.

Functions added are:

add_include_path(filename)
clear_include_paths()
cmd_from_file(filename)
get_dry_run()
set_dry_run(onoff)

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1591
Signed-off-by: Peter Collinson <pc@hillside.co.uk>
---
 py/nftables.py | 92 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 91 insertions(+), 1 deletion(-)

diff --git a/py/nftables.py b/py/nftables.py
index 2a0a1e89..bb9d49d4 100644
--- a/py/nftables.py
+++ b/py/nftables.py
@@ -13,13 +13,21 @@
 # You should have received a copy of the GNU General Public License
 # along with this program; if not, write to the Free Software
 # Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+#
+# Extended to add
+# add_include_path(self, filename)
+# clear_include_paths(self)
+# cmd_from_file(self, filename)
+# get_dry_run(self)
+# set_dry_run(self, onoff)
+# Peter Collinson March 2022

 import json
 from ctypes import *
 import sys
 import os

-NFTABLES_VERSION = "0.1"
+NFTABLES_VERSION = "0.2"

 class SchemaValidator:
     """Libnftables JSON validator using jsonschema"""
@@ -116,6 +124,24 @@ class Nftables:
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

@@ -446,3 +472,67 @@ class Nftables:

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
