Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CA34CD4938
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Sep 2023 00:43:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbjIUAn0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Sep 2023 20:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbjIUAnZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2023 20:43:25 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A032C6
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 17:43:17 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-690d9cda925so331667b3a.3
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 17:43:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695256997; x=1695861797; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=hZM8B8tjZ63FN9RKeE0ZPVY/CYgKDz6xJqXOQMtQBSA=;
        b=nb2oeV9ggg9HPDGrO6yK+mREGklb0fqaeClebvf+nz1W2XGZb95PdV477w7k6i3g1m
         vhnzk6Nd55a/Aml3sHdCHT4Y8LSegIdclbqYBfRn4kYo0jJ2p6IoZdcR1+hrjsN/IEYK
         zUYrQNk1czkFvPTjfmzOSCKjkIJ+aORhbwNdUhtd3wBSQkNf0dVBa4sYWdnEiSNAnj2K
         UMrkFfcOvDzjdPqMMEkCnrXzfQPLoVqgraGoYRhrXhjppV9Yv0htGHC/0IiarQejv8Kt
         5TUudQjb3ZhFqr8BPS/BbisqSEJGcHWJgExboDUzS27BVq9T2Z45iXHFOnhZEL0kOIXq
         W0+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695256997; x=1695861797;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hZM8B8tjZ63FN9RKeE0ZPVY/CYgKDz6xJqXOQMtQBSA=;
        b=bBRMBtEhXY/KIBX+Skwit7tZrVv+tuJyyOYeFCepaidco3M7oxStauO+YdZuWW38nW
         O+ziVdRwC37+aKlUOo6S10sUWklb2qxh9wprIVgKCbqNZzZVOlZ+mC8bAN+t3ExEONCx
         OB7G2+ou3oQOMIhjxLNGHHUZ0vguFD0sObIyztalKKDcmwWYzYkCLoZcBREew5AhIYuD
         t4obw9a6PPkKfvhW4A6iOauAktXcgWZN1lq3dKuoz0wbH3zoqHjSqUG3P/s2QmHSMdPn
         KTffPSkLPimur6a/MVOf3FOIT3L9r6KL/3pvj9E4acYGtCBm5GZ5hQw9MB0IKCPkfzoW
         r2tw==
X-Gm-Message-State: AOJu0Yzo7Oxuyjl00R0/zPXX0CIKuR+zvo2sDCxTtYS9R/6dbZvY4vn/
        U8HyW0bROaq7hrTQRvzns99hSJBAcPQ=
X-Google-Smtp-Source: AGHT+IFUkL/5xPL+p3ClusSlD/vpPsiFTkhFlzHx3V1X1y/zIFs0yVHAj3fmRCwcjMG/g1kjkf1j3g==
X-Received: by 2002:a05:6a00:22cc:b0:68f:c6f8:13f4 with SMTP id f12-20020a056a0022cc00b0068fc6f813f4mr5176702pfj.3.1695256996583;
        Wed, 20 Sep 2023 17:43:16 -0700 (PDT)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id h1-20020a62b401000000b0068fde95aa93sm115652pfn.135.2023.09.20.17.43.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Sep 2023 17:43:16 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v2] doc: make the HTML main page available as `man 7 libnetfilter_queue`
Date:   Thu, 21 Sep 2023 10:43:11 +1000
Message-Id: <20230921004311.18412-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Without this patch, man page users can miss important general information.

The HTML display stays as it was.
The man3 pages are updated to reference libnetfilter_queue.7.
build_man.sh must be invoked with arguments to activate man7 generation,
so will continue to work in other projects as before.
build_man.sh remains generic,
so should be able to make man7 pages for other netfilter projects.

v2: Change commit message from "how" to "why"

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

