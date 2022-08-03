Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D3E2C19F2B
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Aug 2022 20:13:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236087AbiHCUNq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Aug 2022 16:13:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236153AbiHCUNo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Aug 2022 16:13:44 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E94D13AB32
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Aug 2022 13:13:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=einHuz0BP9d6TAxMxn7a5YDebBBS8bB6i8o15dndFu8=; b=i2sDYpy25SG8Z2VmHDQtyTflSu
        eVaZ9MnebaONn6rkIG4LVtV6nmVUY1qt3PIT7OSfTVnWUyKb2B8xo66iVmisozE5ToyIdAk4xKyWD
        IU4k7w5KIoHGiCvez9I6H7pHJcJr8JrrJYHbMfnfh0TDIzexkzJKvT3spSvGemKR17ZKmq5IjU4ta
        cHuPQ1WmLJPSA3xLQNvDmlc3TshQIOW5UsCV7kVrY9SsBa94uYR2+Wa58LsxA8jjPHHXYBCAP65Dz
        w2Z/tiaOI18z8SZWCsH9Ibm3w1XygpZol4tD6Ij3I+QA10u5Lj103XplloNv1fCQpTheOkkYs2hwB
        HKras0NA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1oJKkK-001Fnp-7h; Wed, 03 Aug 2022 21:13:36 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Mark Mentovai <mark@mentovai.com>,
        Duncan Roe <duncan_roe@optusnet.com.au>
Subject: [PATCH libmnl 5/6] doc: move man-page sym-link shell-script into a separate file
Date:   Wed,  3 Aug 2022 21:12:46 +0100
Message-Id: <20220803201247.3057365-6-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220803201247.3057365-1-jeremy@azazel.net>
References: <20220803201247.3057365-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

We use `$(SHELL)` to run the script and exec bash if `$(SHELL)` is something
else.  We don't hard-code the path to bash.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 doxygen/Makefile.am          | 36 +++-----------------------------
 doxygen/finalize_manpages.sh | 40 ++++++++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+), 33 deletions(-)
 create mode 100644 doxygen/finalize_manpages.sh

diff --git a/doxygen/Makefile.am b/doxygen/Makefile.am
index 3f0b1e9a8ab4..4770fc788068 100644
--- a/doxygen/Makefile.am
+++ b/doxygen/Makefile.am
@@ -1,42 +1,10 @@
 if HAVE_DOXYGEN
-
 doc_srcs = $(shell find $(top_srcdir)/src -name '*.c')
 
 doxyfile.stamp: $(doc_srcs) Makefile.am
 	rm -rf html man
 	doxygen doxygen.cfg >/dev/null
-# We need to use bash for its associative array facility
-# (`bash -p` prevents import of functions from the environment).
-# The command has to be a single line so the functions work
-# and so `make` gives all lines to `bash -c`
-# (hence ";\" at the end of every line but the last).
-	/bin/bash -p -c 'declare -A renamed_page;\
-main(){ set -e; cd man/man3; rm -f _*;\
-  count_real_pages;\
-  rename_real_pages;\
-  make_symlinks;\
-};\
-count_real_pages(){ page_count=0;\
-  for i in $$(ls -S);\
-  do head -n1 $$i | grep -E -q '^\.so' && break;\
-    page_count=$$(($$page_count + 1));\
-  done;\
-  first_link=$$(($$page_count + 1));\
-};\
-rename_real_pages(){ for i in $$(ls -S | head -n$$page_count);\
-  do for j in $$(ls -S | tail -n+$$first_link);\
-    do grep -E -q $$i$$ $$j && break;\
-    done;\
-    mv -f $$i $$j;\
-    renamed_page[$$i]=$$j;\
-  done;\
-};\
-make_symlinks(){ for j in $$(ls -S | tail -n+$$first_link);\
-  do ln -sf $${renamed_page[$$(cat $$j | cut -f2 -d/)]} $$j;\
-  done;\
-};\
-main'
-
+	$(SHELL) $(top_srcdir)/doxygen/finalize_manpages.sh
 	touch doxyfile.stamp
 
 CLEANFILES = doxyfile.stamp
@@ -53,3 +21,5 @@ install-data-local:
 uninstall-local:
 	rm -r $(DESTDIR)$(mandir) man html doxyfile.stamp
 endif
+
+EXTRA_DIST = finalize_manpages.sh
diff --git a/doxygen/finalize_manpages.sh b/doxygen/finalize_manpages.sh
new file mode 100644
index 000000000000..6f230b12cbc0
--- /dev/null
+++ b/doxygen/finalize_manpages.sh
@@ -0,0 +1,40 @@
+#
+# We need to use bash for its associative array facility
+#
+[ "$BASH" ] || exec bash $0
+#
+# (`bash -p` prevents import of functions from the environment).
+#
+set -p
+
+declare -A renamed_page
+
+main(){ set -e; cd man/man3; rm -f _*
+  count_real_pages
+  rename_real_pages
+  make_symlinks
+}
+
+count_real_pages(){ page_count=0
+  for i in $(ls -S)
+  do head -n1 $i | grep -E -q '^\.so' && break
+    page_count=$(($page_count + 1))
+  done
+  first_link=$(($page_count + 1))
+}
+
+rename_real_pages(){ for i in $(ls -S | head -n$page_count)
+  do for j in $(ls -S | tail -n+$first_link)
+    do grep -E -q $i$ $j && break
+    done
+    mv -f $i $j
+    renamed_page[$i]=$j
+  done
+}
+
+make_symlinks(){ for j in $(ls -S | tail -n+$first_link)
+  do ln -sf ${renamed_page[$(cat $j | cut -f2 -d/)]} $j
+  done
+}
+
+main
-- 
2.35.1

