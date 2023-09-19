Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66F97CD342F
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Sep 2023 01:05:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbjISBF4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Sep 2023 21:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjISBFz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Sep 2023 21:05:55 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF7B2107
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Sep 2023 18:05:47 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1c3d6d88231so41092625ad.0
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Sep 2023 18:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695085547; x=1695690347; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=tqvkkXaF3ppWbe8bIE+HzvYTOuQd6cfrfiVjZRNH9vc=;
        b=Zy7+QzVtQv19iXUIULlo0x5G4L9gELsjteIFS4umyqCiM3Ss6tlNiuLK5urFRJ+ABk
         XwZ1nFIAqJGl4qEAPUh5CS4pFRJc92rKFhq3UHyL+PkgXm1r75LUHPbUGRCjlLM+HYlh
         4NyZFglpxqfdiqKvPOT4idiNmgcTLLk94CREh7LSotk8mDxck1uuKj7tAVYJuwmL6Gn8
         olZ8u6aTON/VWlvL1B0E6ZNNAz7GzbvI4TBhRZVBWfDS4UjSE1XtaPF26+ZpZoKa0Otr
         B5hpCzazfXaGlLhUPZJneA7g4LXN1DY+ZwCV6pNOPfqYFNGqce8XmodFMyT3gu47Zsv1
         +gIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695085547; x=1695690347;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tqvkkXaF3ppWbe8bIE+HzvYTOuQd6cfrfiVjZRNH9vc=;
        b=h3e9K0vtnbMQAT6eZltF3JYLwhF5aMOifRmPc9f7Ab+1rW4zfuLhL7o5OjhFy0E5R+
         q5IkOYjUCqnRl88Sl6EMARas3T0WMLpV0VzXBXlz7NPVblBq/5zYXVOz0ZHbTss/Vaxv
         u/vQCPXCX4nIJd+EaPFdeJh6/7U777H7f8ep7ZYg6VeqGeU5hKoxOsZhhgjgF++YgbMf
         /0StzwGr/+uUbfFY1KkTMrKXjInP4EeJYic/fpDt/a5HtKLkn7ZB7OJels7b2XqMGWL9
         1wCkdkQlYuoA6xoepzAMQ6HfL0Nr6rbEFV2VWr69JowvCptnvAe70uaCSExXZkwocGwP
         PMKw==
X-Gm-Message-State: AOJu0YwrP1kv3THkTSfiJA2gGBCYgXoXK3TzhQ91EgwH2xzAHFeakePg
        +sXum4VI6JD1KkASDvKrigNJKXurlEw=
X-Google-Smtp-Source: AGHT+IG3IoojMu7MCTL918SUvKPgWITG+OycYq8fDD3pEVCMCuXHw7VBolN8i1VOPi4kAU7pbcBmDw==
X-Received: by 2002:a17:903:182:b0:1bc:6861:d746 with SMTP id z2-20020a170903018200b001bc6861d746mr10814744plg.58.1695085547315;
        Mon, 18 Sep 2023 18:05:47 -0700 (PDT)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id z12-20020a170903018c00b001beef2c9bffsm8862253plg.85.2023.09.18.18.05.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 18:05:46 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue] doc: generate libnetfilter_queue.7 man page from HTML mainpage
Date:   Tue, 19 Sep 2023 11:05:42 +1000
Message-Id: <20230919010542.16431-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Method: make a temporary .c file with a \defgroup instad of \mainpage and run
doxygen on that, with a specially cut-down doxygen config.

Most of the change is to doxygen/build_man.sh. build_man.sh remains generic,
so should be able to make man7 pages for other projects e.g. libnetfilter_log.

build_man.sh must be invoked with arguments to activate man7 generation, so will
continue to work in other projects as before.

The HTML display stays as it was: \section is not available inside a
\defgroup and so is changed to <h1> ... </h1>. This looks the same as \defgroup
but doesn't come with an implicit \anchor as \defgroup does: we can always add
an anchor if we need one.

The man3 pages reference libnetfilter_queue.7.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 doxygen/Makefile.am      |   6 +--
 doxygen/build_man.sh     | 101 +++++++++++++++++++++++++++++++++++++--
 doxygen/man7.extra.txt   |   1 +
 doxygen/old_doxy_fix.txt |   5 ++
 src/libnetfilter_queue.c |  14 +++---
 5 files changed, 113 insertions(+), 14 deletions(-)
 create mode 100644 doxygen/man7.extra.txt
 create mode 100644 doxygen/old_doxy_fix.txt

diff --git a/doxygen/Makefile.am b/doxygen/Makefile.am
index c6eeed7..e98368b 100644
--- a/doxygen/Makefile.am
+++ b/doxygen/Makefile.am
@@ -10,12 +10,12 @@ doc_srcs = $(top_srcdir)/src/libnetfilter_queue.c\
            $(top_srcdir)/src/extra/udp.c\
            $(top_srcdir)/src/extra/icmp.c
 
-doxyfile.stamp: $(doc_srcs) Makefile
+doxyfile.stamp: $(doc_srcs) Makefile build_man.sh man7.extra.txt old_doxy_fix.txt
 	rm -rf html man
 	doxygen doxygen.cfg >/dev/null
 
 if BUILD_MAN
-	$(abs_top_srcdir)/doxygen/build_man.sh
+	$(abs_top_srcdir)/doxygen/build_man.sh libnetfilter_queue libnetfilter_queue.c
 endif
 
 	touch doxyfile.stamp
@@ -42,4 +42,4 @@ uninstall-local:
 	rm -rf $(DESTDIR)$(mandir) man html doxyfile.stamp $(DESTDIR)$(htmldir)
 endif
 
-EXTRA_DIST = build_man.sh
+EXTRA_DIST = build_man.sh man7.extra.txt old_doxy_fix.txt
diff --git a/doxygen/build_man.sh b/doxygen/build_man.sh
index 0d3be4c..38a6b3f 100755
--- a/doxygen/build_man.sh
+++ b/doxygen/build_man.sh
@@ -1,19 +1,20 @@
 #!/bin/sh
-[ -n "$BASH" ] || exec bash -p $0
+[ -n "$BASH" ] || exec bash -p $0 $@
 
 # Script to process man pages output by doxygen.
 # We need to use bash for its associative array facility.
 # (`bash -p` prevents import of functions from the environment).
+# Args: none or 2 being man7 page name & relative path of source with \mainpage
 
 declare -A renamed_page
 
 main(){
   set -e
-  cd man/man3; rm -f _*
+  pushd man/man3 >/dev/null; rm -f _*
   count_real_pages
   rename_real_pages
   make_symlinks
-  post_process
+  post_process $@
 }
 
 count_real_pages(){
@@ -76,9 +77,101 @@ post_process(){
 
   done
 
+  [ $# -ne 2 ] || make_man7 $@
+
   remove_temp_files
 }
 
+make_man7(){
+  popd >/dev/null
+  target=$(grep -Ew INPUT doxygen.cfg | rev | cut -f1 -d' ' | rev)/$2
+  mypath=$(dirname $0)
+
+  # Build up temporary source in temp.c
+  # (doxygen only makes man pages from .c files).
+  mygrep \\\\mainpage $target
+  tail -n+$((linnum-1)) $target | head -n1 >temp.c
+  echo " * \\defgroup $1 $1 overview" >>temp.c
+  tail -n+$((linnum+1)) $target >$fileA
+  linnum=$(grep -En '\*/' $fileA | head -n1 | cut -d: -f1)
+  head -n$((linnum - 1)) $fileA >> temp.c
+
+  # Add any lines specific to this project
+  # (E.g. to satisfy an off-page link)
+  [ ! -r $mypath/man7.extra.txt ] || cat $mypath/man7.extra.txt >> temp.c
+
+  echo ' */' >> temp.c
+  cat >> temp.c <<////
+
+ /**
+  * @{
+  *
+  * $1 - DELETE_ME
+  */
+int $1(void)
+{
+	return 0;
+}
+/**
+ * @}
+ */
+////
+
+  # Create temporary doxygen config in fileC
+  cat /dev/null >$fileC
+  for i in \
+  PROJECT_NAME \
+  PROJECT_NUMBER \
+  ABBREVIATE_BRIEF \
+  FULL_PATH_NAMES \
+  TAB_SIZE \
+  OPTIMIZE_OUTPUT_FOR_C \
+  EXAMPLE_PATTERNS \
+  ALPHABETICAL_INDEX \
+  SEARCHENGINE \
+  GENERATE_LATEX \
+  ; do grep -Ew $i doxygen.cfg >>$fileC; done
+  cat >>$fileC <<////
+INPUT = temp.c
+GENERATE_HTML = NO
+GENERATE_MAN = YES
+MAN_EXTENSION = .7
+////
+
+  doxygen $fileC >/dev/null
+
+  # Remove SYNOPSIS line if there is one
+  target=man/man7/$1.7
+  mygrep "SH SYNOPSIS" $target
+  [ $linnum -eq 0 ] || delete_lines $linnum $((linnum+1))
+
+  # doxygen 1.8.9.1 and possibly newer run the first para into NAME
+  # (i.e. in this unusual group). There won't be a SYNOPSIS when this happens
+  if grep -Eq "overview$1" $target; then
+    head -n2 temp.c >$fileA
+    cat $mypath/old_doxy_fix.txt >>$fileA
+    tail -n+3 temp.c >>$fileA
+    cat $fileA >temp.c
+    doxygen $fileC >/dev/null
+  fi
+
+  # Insert top-level "See also" of man7 page in all real man3 pages
+  for target in $(find man/man3 -type f)
+  do mygrep "Detailed Description" $target
+    [ $linnum -ne 0 ] || mygrep "Function Documentation" $target
+    [ $linnum -ne 0 ] || { echo "NO HEADER IN $target" >&2; continue; }
+    head -n$((linnum-1)) $target >$fileA
+    cat >>$fileA <<////
+.SH "See also"
+\\fB${1}\\fP(7)
+////
+    tail -n+$linnum $target >>$fileA
+    cp $fileA $target
+  done
+
+  rm temp.c
+}
+
 fix_double_blanks(){
   linnum=1
   #
@@ -225,4 +318,4 @@ remove_temp_files(){
   done
 }
 
-main
+main $@
diff --git a/doxygen/man7.extra.txt b/doxygen/man7.extra.txt
new file mode 100644
index 0000000..62c8698
--- /dev/null
+++ b/doxygen/man7.extra.txt
@@ -0,0 +1 @@
+ * \anchor LibrarySetup
diff --git a/doxygen/old_doxy_fix.txt b/doxygen/old_doxy_fix.txt
new file mode 100644
index 0000000..46eeff8
--- /dev/null
+++ b/doxygen/old_doxy_fix.txt
@@ -0,0 +1,5 @@
+ * \manonly
+.PP
+.SH "Detailed Description"
+.PP
+\endmanonly
diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index a170143..1269181 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -45,11 +45,11 @@
  * libnetfilter_queue homepage is:
  * 	https://netfilter.org/projects/libnetfilter_queue/
  *
- * \section deps Dependencies
+ <h1>Dependencies</h1>
  * libnetfilter_queue requires libmnl, libnfnetlink and a kernel that includes
  * the Netfilter NFQUEUE over NFNETLINK interface (i.e. 2.6.14 or later).
  *
- * \section features Main Features
+ * <h1>Main Features</h1>
  *  - receiving queued packets from the kernel nfnetlink_queue subsystem
  *  - issuing verdicts and possibly reinjecting altered packets to the kernel
  *  nfnetlink_queue subsystem
@@ -71,15 +71,15 @@
  * When a queue is full, packets that should have been enqueued are dropped by
  * kernel instead of being enqueued.
  *
- * \section git Git Tree
+ * <h1>Git Tree</h1>
  * The current development version of libnetfilter_queue can be accessed at
  * https://git.netfilter.org/libnetfilter_queue.
  *
- * \section privs Privileges
+ * <h1>Privileges</h1>
  * You need the CAP_NET_ADMIN capability in order to allow your application
  * to receive from and to send packets to kernel-space.
  *
- * \section using Using libnetfilter_queue
+ * <h1>Using libnetfilter_queue</h1>
  *
  * To write your own program using libnetfilter_queue, you should start by
  * reading (or, if feasible, compiling and stepping through with *gdb*)
@@ -97,7 +97,7 @@ gcc -g3 -ggdb -Wall -lmnl -lnetfilter_queue -o nf-queue nf-queue.c
  * article:
  *  https://home.regit.org/netfilter-en/using-nfqueue-and-libnetfilter_queue/
  *
- * \section errors ENOBUFS errors in recv()
+ * <h1>ENOBUFS errors in recv()</h1>
  *
  * recv() may return -1 and errno is set to ENOBUFS in case that your
  * application is not fast enough to retrieve the packets from the kernel.
@@ -106,7 +106,7 @@ gcc -g3 -ggdb -Wall -lmnl -lnetfilter_queue -o nf-queue nf-queue.c
  * you may hit it again sooner or later. The next section provides some hints
  * on how to obtain the best performance for your application.
  *
- * \section perf Performance
+ * <h1>Performance</h1>
  * To improve your libnetfilter_queue application in terms of performance,
  * you may consider the following tweaks:
  *
-- 
2.35.8

