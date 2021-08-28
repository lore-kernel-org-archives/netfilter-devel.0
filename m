Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E86CDC432BE
	for <netfilter-devel@archiver.kernel.org>; Sat, 28 Aug 2021 03:35:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC03B60F25
	for <netfilter-devel@archiver.kernel.org>; Sat, 28 Aug 2021 03:35:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233117AbhH1DgF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 27 Aug 2021 23:36:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233101AbhH1DgE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 27 Aug 2021 23:36:04 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34EE0C0613D9
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Aug 2021 20:35:15 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id s29so2525354pfw.5
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Aug 2021 20:35:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5VZBCyaq5mR8XSRgUCQBNhuB2c4wh1NWsb0wCIFvIuk=;
        b=MF/YnlW8s8na5/I52KD60+pJMKM28DhpHCkwP6iUAsbkTMrNNLuG29/MNzLujgV7St
         xrEsx+EsQV1AfQ4g5GS9kUXIb7i8RGrMNy2r46bIc9TXq6bQEm1yecqkvyU2kR4lKRdA
         EgmCpneTvuRskNsexdn3FymvETF9xMnMtCCuZ1sknYjJvQh2t7QuaQtRdSgeAbzs9WnU
         gLUvxSnjxf2bv42fLLVLLRYbF+Cd6/7j7gIjHDgOL/wzGIbDdQnTZ9w3I6ndzAoaty3Q
         llNu0gfAZ3NGOpDltYxA0N84hDA6c5Fpq7PB+xsPseANbWve4fPCcgbLVZT9kSM5O2LW
         oClA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=5VZBCyaq5mR8XSRgUCQBNhuB2c4wh1NWsb0wCIFvIuk=;
        b=BMhx/DDIC6KqlyIfsJUgX1zpEaktC4Ws3fPfGqZJZ0YrroZn/xoqsJgpFfe1vURTbH
         knwo6D6q9q24am81oUi3WKvnuftegHuMEjatoA4gdmXvjLhVBrkIe1XYTKvvtn8UrBI0
         BzyrwpWSC5TBxo6mLx9Tt0rOUw6MA39G5v26TKaNIg4eda1nJ7KYGE/KOWInaq/H0uvq
         HreKGoegW99sgj7pB3EJY061+eeCHCei8Qut2R1SHIkzQehxS1T7xWfQnL2cSJVfTjwO
         H1AXUBbXMQU5oJxnC7Gctqy9mPTcIBINMB/qM3uWLv81nLa56+0P5w4zAmGf2GoOP+r8
         cV5g==
X-Gm-Message-State: AOAM532OotvM9Ma7Ksv3mha4U/ncqIYwHIiF9r+Bn2d3Wc6A4Cu67R2h
        0RVLgD+zpMnhU5t0mMvjXvK2L47EkRk=
X-Google-Smtp-Source: ABdhPJxb48+ikjJsq2W3JvqGQHpG98ksNn6xVEacMyy+yzsAI/9QZhXI3N/vqo49kjRfVBmPE3Nw0g==
X-Received: by 2002:aa7:9096:0:b0:3e1:72fd:a614 with SMTP id i22-20020aa79096000000b003e172fda614mr11981026pfa.56.1630121714543;
        Fri, 27 Aug 2021 20:35:14 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id q21sm8513021pgk.71.2021.08.27.20.35.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Aug 2021 20:35:14 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v3 1/6] build: doc: Fix man pages
Date:   Sat, 28 Aug 2021 13:35:03 +1000
Message-Id: <20210828033508.15618-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Split off shell script from within doxygen/Makefile.am into
doxygen/build_man.sh.

This patch by itself doesn't fix anything.
The patch is only for traceability, because diff patch format is not very good
at catching code updates and moving code together.
Therefore the script is exactly as it was; it still looks a bit different
because of having to un-double doubled-up $ signs, remove trailing ";/" and so
on.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 doxygen/Makefile.am  | 34 +++-------------------------------
 doxygen/build_man.sh | 29 +++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+), 31 deletions(-)
 create mode 100755 doxygen/build_man.sh

diff --git a/doxygen/Makefile.am b/doxygen/Makefile.am
index 29078de..5068544 100644
--- a/doxygen/Makefile.am
+++ b/doxygen/Makefile.am
@@ -16,37 +16,7 @@ doxyfile.stamp: $(doc_srcs) Makefile.am
 	[ ! -d ../src.distcheck ] || \
 { set -x; cd ..; rm src; mv src.distcheck src; }
 
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
+	$(abs_top_srcdir)/doxygen/build_man.sh
 
 	touch doxyfile.stamp
 
@@ -64,3 +34,5 @@ install-data-local:
 uninstall-local:
 	rm -r $(DESTDIR)$(mandir) man html doxyfile.stamp
 endif
+
+EXTRA_DIST = build_man.sh
diff --git a/doxygen/build_man.sh b/doxygen/build_man.sh
new file mode 100755
index 0000000..304a305
--- /dev/null
+++ b/doxygen/build_man.sh
@@ -0,0 +1,29 @@
+#!/bin/bash -p
+# We need to use bash for its associative array facility
+# (`bash -p` prevents import of functions from the environment).
+declare -A renamed_page
+main(){ set -e; cd man/man3; rm -f _*
+  count_real_pages
+  rename_real_pages
+  make_symlinks
+}
+count_real_pages(){ page_count=0
+  for i in $(ls -S)
+  do head -n1 $i | grep -E -q '^\.so' && break
+    page_count=$(($page_count + 1))
+  done
+  first_link=$(($page_count + 1))
+}
+rename_real_pages(){ for i in $(ls -S | head -n$page_count)
+  do for j in $(ls -S | tail -n+$first_link)
+    do grep -E -q $i$ $j && break
+    done
+    mv -f $i $j
+    renamed_page[$i]=$j
+  done
+}
+make_symlinks(){ for j in $(ls -S | tail -n+$first_link)
+  do ln -sf ${renamed_page[$(cat $j | cut -f2 -d/)]} $j
+  done
+}
+main
-- 
2.17.5

