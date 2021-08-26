Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C332FC432BE
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Aug 2021 03:43:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EA17610CD
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Aug 2021 03:43:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236891AbhHZDok (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Aug 2021 23:44:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235803AbhHZDoj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Aug 2021 23:44:39 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22C7BC061757
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Aug 2021 20:43:53 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id ot2-20020a17090b3b4200b0019127f8ed87so5154096pjb.1
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Aug 2021 20:43:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5VZBCyaq5mR8XSRgUCQBNhuB2c4wh1NWsb0wCIFvIuk=;
        b=IJ3Cqx8egUcYAWl10oWzElVErRfs2vqN69rz7VnLNkeflCAZqt/g1YmkiY9hyBjl3Z
         aCbFYA1FlnqARHBZbzxWKluLJm4RT0s8vVYhfpQu/AaYM0ZKnlaji9vzBaTSIUPk4iKb
         7XEi1DjBI1Fix1qwmDU/cL79k+hun02SlmpbGMD0OwwnRlTWmUiAIE9VtqptFO0qCzHT
         qbdTXlzDSv8rxO4c2XG1P0ZaGX9uoIykFL50ClWMC5uxUBa+Tui85CU+x4KtKSOiotsK
         nsN7d9VYuHYKzloBNkRbRP/w5fnYAF1EN70Fg1h3CFHBcOXkn/Wq0SJWUxMxmhilMc54
         s1cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=5VZBCyaq5mR8XSRgUCQBNhuB2c4wh1NWsb0wCIFvIuk=;
        b=FHX+1zA4rUfY/KKfMKAOf8Osr1JifzMP5FaZZtWUAgVLWTA2VOwa6uBjDbh2s9FPmf
         nboZlamfXlkrarXAcptDnw/OzSoac5VvHhEAtGMBIXzVIhVsZ+/0+TWGfr7x1jx6GEUW
         LOnPYFdqcBI+clMKJWyg2viBswTQV35j8pEBF8rt2dInbPJDIkgV//XzfRZvoo2gqg2k
         NxLJAAbpcqKgvyaWmp1QflwYoBpKI2L0aDDJ/3rJxTIrvrWyidPLc/a9yxTSo0reroo7
         rqpY4c84e6yrNjNazwiO9ozR3piZePBBQypCqjxKDEKjHBIfMbpMaox981esNlfE6F+M
         gxtw==
X-Gm-Message-State: AOAM532UsKqjYLUpABrImX+Kq3PASFlQPSiE2o6nBlXieGfwHKUPp1cg
        E+e/4oqDcvlzNOzkth23UVHy4hY4DP5Xng==
X-Google-Smtp-Source: ABdhPJwypzAO7rAxsWGuP8BouzSPqWcICjLtFXZnfKrMRlhcYyD1py64RBi3hTka7oqmD8a06r3DIQ==
X-Received: by 2002:a17:90b:3144:: with SMTP id ip4mr14459224pjb.22.1629949432691;
        Wed, 25 Aug 2021 20:43:52 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id s11sm1109193pfh.18.2021.08.25.20.43.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 20:43:52 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v2 1/5] build: doc: Fix man pages
Date:   Thu, 26 Aug 2021 13:43:42 +1000
Message-Id: <20210826034346.13224-1-duncan_roe@optusnet.com.au>
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

