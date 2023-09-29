Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5191E743EA
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Sep 2023 04:59:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231429AbjI2E72 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 Sep 2023 00:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbjI2E71 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Sep 2023 00:59:27 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71DB2195
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Sep 2023 21:59:24 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-692eed30152so7325910b3a.1
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Sep 2023 21:59:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695963564; x=1696568364; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=QssbfKlim5iNJSWOCYcB4edTg/+cX9K1g6nvP2Fzauo=;
        b=Oa9B7jdLr1VYCr58/Ty2EJuxNWKJrn5mDjenqWDgP/WtmdMEbxBPOLJrBcd5UPKUzW
         4Mies3kbRxC+QaAJe4mim+yH7qHA5Fpx2s2r6cE6M/gW3wpXp0vUYxOC/tCjqx9shbDS
         qWQzIWXna5b9knC+r+nDAvg+FDbmSRo7s4HDXNti72v9misQvzUFFcNaVwhMKYvpJ7G7
         HSHZD2UERAIuSUg2vdwQKuNtrLCTJ+IBMJ2hxuXNoZp9tjwlMJ9dbN3sElc9z5KQ2pfz
         xKEOQvx6+hVr7ZUUjYMHoysZdb1NquOr9UKznnjeUEpM87Nq6YQ7O8lugtSDbSM3KKqv
         LDXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695963564; x=1696568364;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QssbfKlim5iNJSWOCYcB4edTg/+cX9K1g6nvP2Fzauo=;
        b=ojFcpxegf4BVcktJ5wgYSkmLqDEjYFjqCu2A/pdeLPG0w9veMgKErTrbpECMpY/YMZ
         eWo4u0l97R/9QicyR8oTzdwuaae706ZLXi72uqgge707oAQHT8OT1UL3xpW7aheNN7Fn
         lAQtpH7qxJBmGleIay/MlGeeNxYgh4AehAvqVhUfr6dwhj3qKSAIkNyLCnjwi2XXGs1e
         XQceP05WMHdsMuzBzy7sc+oc/Sujuf+oBcL7X9GANtZoczzhIKpKU2fdkaPU6WEvUfdd
         sl7axMRWVXuWjQBBr4kSMJBXNKgRRpieri48OcW1crJFVA4o0JXzhn1BIPiXP0nD5/lv
         rh0Q==
X-Gm-Message-State: AOJu0YzvGKg6d3otzb7nFDcLq44yR3fIrbhabSJwCTh+jo6mL4+N/Ax6
        GWwe2EkqHyBtYKb8h4rcfzYzdlQ+TN0=
X-Google-Smtp-Source: AGHT+IHPZv6N/1AvLFRGhSjZ+2gwGQXhmrHdBQb8R86bdsCAgms8Iaez80+5x19wGK5MauRL9znk4g==
X-Received: by 2002:a05:6a00:189b:b0:690:422f:4f17 with SMTP id x27-20020a056a00189b00b00690422f4f17mr3328895pfh.4.1695963563766;
        Thu, 28 Sep 2023 21:59:23 -0700 (PDT)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id m26-20020aa78a1a000000b0068fd026b496sm14105108pfa.46.2023.09.28.21.59.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Sep 2023 21:59:23 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v3] make the HTML main page available as `man 7 libnetfilter_queue`
Date:   Fri, 29 Sep 2023 14:59:18 +1000
Message-Id: <20230929045918.26887-1-duncan_roe@optusnet.com.au>
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

v3: Confine man page generation to build_man.sh per Pablo request;
    Add build_man.sh to doxyfile.stamp dependencies (should have always been)

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 doxygen/Makefile.am      |   4 +-
 doxygen/build_man.sh     | 103 +++++++++++++++++++++++++++++++++++++--
 src/libnetfilter_queue.c |  23 ++++++---
 3 files changed, 116 insertions(+), 14 deletions(-)

diff --git a/doxygen/Makefile.am b/doxygen/Makefile.am
index c6eeed7..68be963 100644
--- a/doxygen/Makefile.am
+++ b/doxygen/Makefile.am
@@ -10,12 +10,12 @@ doc_srcs = $(top_srcdir)/src/libnetfilter_queue.c\
            $(top_srcdir)/src/extra/udp.c\
            $(top_srcdir)/src/extra/icmp.c
 
-doxyfile.stamp: $(doc_srcs) Makefile
+doxyfile.stamp: $(doc_srcs) Makefile build_man.sh
 	rm -rf html man
 	doxygen doxygen.cfg >/dev/null
 
 if BUILD_MAN
-	$(abs_top_srcdir)/doxygen/build_man.sh
+	$(abs_top_srcdir)/doxygen/build_man.sh libnetfilter_queue libnetfilter_queue.c
 endif
 
 	touch doxyfile.stamp
diff --git a/doxygen/build_man.sh b/doxygen/build_man.sh
index 0d3be4c..7eab8fa 100755
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
@@ -76,9 +77,103 @@ post_process(){
 
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
+    cat >>$fileA <<////
+ * \\manonly
+.PP
+.SH "Detailed Description"
+.PP
+\\endmanonly
+////
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
@@ -225,4 +320,4 @@ remove_temp_files(){
   done
 }
 
-main
+main $@
diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index a170143..86d74c2 100644
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
@@ -88,7 +88,14 @@
  * \verbatim
 gcc -g3 -ggdb -Wall -lmnl -lnetfilter_queue -o nf-queue nf-queue.c
 \endverbatim
- * The doxygen documentation \link LibrarySetup \endlink is Deprecated and
+ *The doxygen documentation
+ * \htmlonly
+<a class="el" href="group__LibrarySetup.html">LibrarySetup </a>
+\endhtmlonly
+ * \manonly
+\fBLibrarySetup\fP\
+\endmanonly
+ * is Deprecated and
  * incompatible with non-deprecated functions. It is hoped to produce a
  * corresponding non-deprecated (*Current*) topic soon.
  *
@@ -97,7 +104,7 @@ gcc -g3 -ggdb -Wall -lmnl -lnetfilter_queue -o nf-queue nf-queue.c
  * article:
  *  https://home.regit.org/netfilter-en/using-nfqueue-and-libnetfilter_queue/
  *
- * \section errors ENOBUFS errors in recv()
+ * <h1>ENOBUFS errors in recv()</h1>
  *
  * recv() may return -1 and errno is set to ENOBUFS in case that your
  * application is not fast enough to retrieve the packets from the kernel.
@@ -106,7 +113,7 @@ gcc -g3 -ggdb -Wall -lmnl -lnetfilter_queue -o nf-queue nf-queue.c
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

