Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D326310D
	for <netfilter-devel@vger.kernel.org>; Tue, 13 Feb 2024 21:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707858446; cv=none; b=WFb8CHsbUbhR5/oqYkCIGclJpp/GSvg4oEeZlQix7jhuBlZ7Gl/AXs9b+1XvApu3iawfWZksiBG145C37Prt3rmAsCyAtXpBUETWpgxsJ2wIOd8JqBQCiQn7rgvq6WtFeHVwMjyjACL/6GaXD8m5QrlAhFwNYfqMM1H+ooIy8/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707858446; c=relaxed/simple;
	bh=otDByMbbHAj5PI3B589r9ef2W6mQ6diLfBfVgy7YTkQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XrBp/TvfXq5hMgG9G/xrOuWOggWKTaBA77gi/BBgH6Do+TwMc7u0q3XLfjKw4rIFWbLyaQ5Q3R2sdSZU4hAPq9TeaNa4nv0FuulugXMmTOZ62hY7+HY1AS2UzhTfy2GjeYhKCO1FtdwDCCzwp1JYCsLxt+jPC4pgp/AAs6WTaLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aazePd5b; arc=none smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aazePd5b"
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-59502aa878aso2080777eaf.1
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Feb 2024 13:07:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707858441; x=1708463241; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dqbH9begB0Z4bWCKWIw5GYCt51mE3rGQdNo3K98pRtQ=;
        b=aazePd5bTD5AvIILCjF8SN1uHauQ2ulNq+u2dNBUWkySLcgpFtxTcYrvWC8R7WGq46
         hGSu4zXsovZmxb8L9v9+Yrg/5X2ro6qKe6AnF0pM+OBT4L4/U4HgjdaL9nXVYV1Kcce5
         xoowK2ZSL5UuuQvu2JhqUQWgEKxbiPEVOZBUA6RCvSwwx3UMssEm5pU/R2FtXd4KeYxu
         1NlZszpnFBNDrsOlyOLTQSmUeum1ICz2mJxshjKsv0IIgw9fyIjh1uzKgW+UnG8NTq5u
         rn50SjT9sj+03DWxQWNunyUPnq4SLnEAa0s2FFrPCFQNSFzuEXsZpmTx6xZWZ5w9pL5e
         eiQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707858441; x=1708463241;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dqbH9begB0Z4bWCKWIw5GYCt51mE3rGQdNo3K98pRtQ=;
        b=FstxTLugKWw7ec2Men4IhEfR2rmzsp8SkgiYsFyU5Dc4kwKzrgaRkjifQPqHzSo82v
         jhhsNKmFcIkiPaNVQqO+TYI6aKmqfHM9l418VCWvc1046n8BMiBM+vddReWheTrhqmmT
         7J0wayw8G8k7gPSZWhjmsCfAK6Y1c/fwNrUyO8TOY6DsaEY+BprcRPiSzm6cbi94NtlA
         7vZqCj23kHSEVzEduUaKV2yzZpsoioN9C/74zXDg2N6R97O+xYhYtzFIMzxwxBeABkVv
         TX1RtoJxUnewQAwralKWResANt0n8DEgZ5T9b7PRrHz4fPWOTtQwDfRrlO/uKLkUP9z+
         QF9g==
X-Gm-Message-State: AOJu0YyYtLtxgeJ7hoRdizeqS4cpC//OeZJT4aUhHbI6HQU4u5muv6c+
	0NM0lvgoTNafEZdVTFuukCEbIJKQjkZkvnkLolpCxEM08iQYoW8J1nCrofWJ
X-Google-Smtp-Source: AGHT+IHdRkdk1fd3cjLN/qrD1YoSkdvPtQOkcH5dalUCFkfufRKRf+0E2thiMs96Eh2sqrtmqN0JZg==
X-Received: by 2002:a05:6358:7e94:b0:178:7540:999 with SMTP id o20-20020a0563587e9400b0017875400999mr583331rwn.3.1707858439959;
        Tue, 13 Feb 2024 13:07:19 -0800 (PST)
Received: from slk15.local.net (pa49-184-82-110.pa.vic.optusnet.com.au. [49.184.82.110])
        by smtp.gmail.com with ESMTPSA id s26-20020a65691a000000b005dbe22202fbsm2497543pgq.42.2024.02.13.13.07.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Feb 2024 13:07:19 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 1/1] Convert libnetfilter_queue to use entirely libmnl functions
Date: Wed, 14 Feb 2024 08:07:06 +1100
Message-Id: <20240213210706.4867-2-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
In-Reply-To: <20240213210706.4867-1-duncan_roe@optusnet.com.au>
References: <20240213210706.4867-1-duncan_roe@optusnet.com.au>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

And no libnfnetlink headers either.
Submitted as a single patch because the first change essentially broke
it until the job was nearly finished.

Summary of changes (sort-of cleaned up git log):

doc: pre-submission updates
-Main page: re-work introductory para
 - mention fail-open earlier
 - Add manonly section "Accessing source online "
 - Add link to examples/nf-queue.c to actually see source code
 - Add link to nfq6.c to actually see source code
 - Elaborate on Eric Leblond's blog
- Queue handling, Library setup, Message parsing functions,
  Printing: Add [nfnl API]
- Verdict helpers, Config helpers,
  Netlink message helper functions: Add [mnl API]
- linux_list.h: Add "alternative approach"
- pktbuff.c:
  - pktb_alloc: mention pktb_setup_raw
  - pktb_setup_raw: re-work and expand
- iftable.c:
 - Point to nfq6.c example of using only libmnl calls instead.
 - Document what to do on interrupted dump.
- libnetfilter_queue.c:
  - Main page (as above)
  - Delete nfq_set_queue_maxlen reference
  - Update nftables command-line queue num verdict to nft QUEUE STATEMENT
  - replace nf-queue.c example with nfq6 (easier to find)
  - re-work nfq_nlmsg_verdict_put_pkt

Use a cast in place of convoluted construct
I.e. when calling list_del() and list_add().
We have a list of struct ifindex_node but the fns want struct list_head
which is at the head of struct ifindex_node.
Also audit counter loops to count downwards (c/w 0 is faster).

Add list_empty() to linux_list.h
And translate kerneldoc comments to doxygen.
Use \note instead of Note:
Add \return to list_empty docn

doc: Cater for doxygen variants w.r.t. #define stmts

doc: Resolve most issues with man page generated from linux_list.h
build_man.sh has extra logic to extract documented macros into the
"Name" line.
doxygen.cfg.in excludes the list_head structure.
doxygen 1.10.0 has a bug which appends ".PP" to macro "Value:" headings.
Fixed after I reported it.

build: Shave some time off build
Modify function mygrep in build_man.sh to use pipes rather than the
temporary files. Saves ~20% elapsed time in a make with no compiles on my
system.

SYNOPSIS of linux_list.h nominates libnetfilter_queue/linux_list.h

doc: Get doxygen to document useful static inline functions
include/libnetfilter_queue/linux_list.h contains static inline list_add and
list_del which mnl programs may wish to use. Make a temporary copy of
linux_list.h with 'static' removed and get doxygen to process that.

Move nlif_*() usage description from libnetfilter_queue.c to iftable.c
Also in iftable.c:
 - Expand usage description to cover nlif_catch.
 - Add SYNOPSIS.
 - Fix some doc typos.
Also in libnetfilter_queue.c:
 - Standardise similar-looking \return lines.
 - Use "an nlif" instead of "a nlif" since nlif pronounciation will always
   start "enn" ("enn liff" or "enn ell eye eff").

doc: Change libnfnetlink reference to libnetfilter_queue
While being about it, clarify surrounding documentation a bit.

include: linux_nfnetlink_queue.h no longer needs
libnfnetlink/linux_nfnetlink.h

Conversion to not use libnfnetlink is complete
No sources include libnfnetlink.h
libnetfilter_queue.so builds
programs in examples and utils do not show libnfnetlink in ldd

Add iftable.c to provide nlif_* functions
Fix all doxygen warnings. Introduce some new doxygen content.
Convert to use libmnl.

Eliminate doxygen warnings from linux_list.h
The warnings concerned prefetch(), LIST_POISON1 & LIST_POISON2.
Remove all 3 macros since they do nothing useful in userspace programs.
Also take a few doxygen comment improvements from 6.6 Linux source.

Add linux_list.h to the doxygen system
Produce web and man pages for list_for_each_entry() &c.

Create include/libnetfilter_queue/linux_list.h
include/libnetfilter_queue/libnetfilter_queue.h includes linux_list.h.
Needed to write replacemants for the nlif_* functions,
or for dierct use by mnl-api programs.

Convert remaining nfq_* functions to use libmnl
Converted: nfq_set_verdict2(), nfq_set_verdict_batch2(),
	   nfq_set_verdict_mark(), nfq_get_nfmark() [again] &
	   nfq_get_skbinfo().

Eliminate calls to nfnl_build_nfa_iovec() & nfnl_sendiov

Clarify where nfqnl_msg_packet_hdr structure is defined
I.e. not in libnetfilter_queue.h

Convert nfq_fd()
Also update build of utils/nfqnl_test to ignore unresolved symbols
and document nfq_nfnlh().

Rename element `id` of struct nfq_q_handle to `queue_num`
This leaves `id` as always referring to packet id.
`queue_num` is also used in other sources.

Remove libnfnetlink from the build
Programs using nfnl-api functions must build with -lnfnetlink.
Programs using mnl-api functions no longer show libnfnetlink in ldd.

Incorporate nfnl_rcvbufsiz()

Remove `struct nfnl_subsys_handle *nfnlssh` from `struct nfq_handle`

Convert nfq_close()

Convert non-data verdict functions
Updated:
 include/libnetfilter_queue/libnetfilter_queue.h:
 - Fix name in 1st line
 - Change name of guardian #define to the conventional one
 - Flag line to be removed (when we can)
 src/libnetfilter_queue.c:
 - include libmnl.h
 - Use real Linux headers
 - __set_verdict() uses mnl_socket_sendto() if no packed data

Convert more message parsing functioms
Functions now using libmnl exclusively: nfq_get_msg_packet_hdr(),
nfq_get_nfmark(), nfq_get_timestamp(), nfq_get_indev(),
nfq_get_physindev(), nfq_get_outdev(), nfq_get_physoutdev(),
nfqnl_msg_packet_hw(), nfq_get_uid() & nfq_get_gid().

About to convert / redo all nfq_get_ functions
Functions now using libmnl exclusively: nfq_handle_packet(),
nfq_get_secctx() & nfq_get_payload().
The opaque struct nfq_data is now an array of struct nlattr instead of
struct nfattr.
The difference is: nlattr starts at 0 while nfattr starts at 1.

Delete nfq_open_nfnl() and __nfq_rcv_pkt()
nfq_open_nfnl was the last user of static __nfq_rcv_pkt and was slated
for removal so delete both of them.

Convert nfq_set_queue_flags() & nfq_set_queue_maxlen() to use libmnl

Introduce a static function to check response from using NLM_F_ACK
Code uses nfq_query() where it previously used nfnl_query().
nfq_query() takes 2 extra args being a buffer / buffer size pair which
the caller can also use for sending.
(nfq_query() used to call nfnl_catch() which declared that buffer).
THIS FUNCTION WILL BE REPLACED by nfq_socket_sendto() if it ever makes
it out of patchwork.

Convert nfq_set_mode(), nfq_bind_pf() & nfq_unbind_pf() to use libmnl
Also remove nfq_errno (incomplete project, never documented).
Main change is to static function __build_send_cfg_msg().

Convert nfq_open() to use libmnl

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 Make_global.am                                |   2 +-
 configure.ac                                  |   1 -
 doxygen/Makefile.am                           |   5 +
 doxygen/build_man.sh                          |  44 +-
 doxygen/doxygen.cfg.in                        |   8 +-
 .../libnetfilter_queue/libnetfilter_queue.h   |  47 +-
 include/libnetfilter_queue/linux_list.h       | 185 +++++
 .../linux_nfnetlink_queue.h                   |   1 -
 libnetfilter_queue.pc.in                      |   1 -
 src/Makefile.am                               |   3 +-
 src/extra/pktbuff.c                           |  27 +-
 src/iftable.c                                 | 391 ++++++++++
 src/libnetfilter_queue.c                      | 696 ++++++++++--------
 src/nlmsg.c                                   |  46 +-
 14 files changed, 1102 insertions(+), 355 deletions(-)
 create mode 100644 include/libnetfilter_queue/linux_list.h
 create mode 100644 src/iftable.c

diff --git a/Make_global.am b/Make_global.am
index 91da5da..4d8a58e 100644
--- a/Make_global.am
+++ b/Make_global.am
@@ -1,2 +1,2 @@
-AM_CPPFLAGS = -I${top_srcdir}/include ${LIBNFNETLINK_CFLAGS} ${LIBMNL_CFLAGS}
+AM_CPPFLAGS = -I${top_srcdir}/include ${LIBMNL_CFLAGS}
 AM_CFLAGS = -Wall ${GCC_FVISIBILITY_HIDDEN}
diff --git a/configure.ac b/configure.ac
index 7359fba..ba7b15f 100644
--- a/configure.ac
+++ b/configure.ac
@@ -42,7 +42,6 @@ case "$host" in
 esac
 
 dnl Dependencies
-PKG_CHECK_MODULES([LIBNFNETLINK], [libnfnetlink >= 0.0.41])
 PKG_CHECK_MODULES([LIBMNL], [libmnl >= 1.0.3])
 
 AS_IF([test "$enable_man_pages" = no -a "$enable_html_doc" = no],
diff --git a/doxygen/Makefile.am b/doxygen/Makefile.am
index 68be963..4934e8e 100644
--- a/doxygen/Makefile.am
+++ b/doxygen/Makefile.am
@@ -2,17 +2,22 @@ if HAVE_DOXYGEN
 
 doc_srcs = $(top_srcdir)/src/libnetfilter_queue.c\
            $(top_srcdir)/src/nlmsg.c\
+           $(top_srcdir)/src/iftable.c\
            $(top_srcdir)/src/extra/checksum.c\
            $(top_srcdir)/src/extra/ipv4.c\
            $(top_srcdir)/src/extra/pktbuff.c\
            $(top_srcdir)/src/extra/ipv6.c\
            $(top_srcdir)/src/extra/tcp.c\
            $(top_srcdir)/src/extra/udp.c\
+           $(top_srcdir)/include/libnetfilter_queue/linux_list.h\
            $(top_srcdir)/src/extra/icmp.c
 
 doxyfile.stamp: $(doc_srcs) Makefile build_man.sh
 	rm -rf html man
+	sed '/^static inline [^ ]* [^_]/s/static //' \
+	  $(top_srcdir)/include/libnetfilter_queue/linux_list.h > linux_list.h
 	doxygen doxygen.cfg >/dev/null
+	rm linux_list.h
 
 if BUILD_MAN
 	$(abs_top_srcdir)/doxygen/build_man.sh libnetfilter_queue libnetfilter_queue.c
diff --git a/doxygen/build_man.sh b/doxygen/build_man.sh
index 7eab8fa..d3bd748 100755
--- a/doxygen/build_man.sh
+++ b/doxygen/build_man.sh
@@ -7,6 +7,7 @@
 # Args: none or 2 being man7 page name & relative path of source with \mainpage
 
 declare -A renamed_page
+no_macroRI=maybe
 
 main(){
   set -e
@@ -84,7 +85,12 @@ post_process(){
 
 make_man7(){
   popd >/dev/null
-  target=$(grep -Ew INPUT doxygen.cfg | rev | cut -f1 -d' ' | rev)/$2
+
+  # This grep command works for multiple directories on the INPUT line,
+  # as long as the directory containing the source with the main page
+  # comes first.
+  target=/$(grep -Ew INPUT doxygen.cfg | cut -f2- -d/ | cut -f1 -d' ')/$2
+
   mypath=$(dirname $0)
 
   # Build up temporary source in temp.c
@@ -245,10 +251,18 @@ fix_name_line(){
   mygrep "^\\.SH \"Function Documentation" $target
   head -n$linnum $target >$fileC
 
+  # Different versions of doxygen present macros and functions differently.
+  # Some versions have .RI lines for macros then functions.
+  # Some versions have .SS lines for macros instead of .RI.
+  # All versions (so far) have .SS lines for macros after all .RI lines.
+  # Look for #define in .RI lines and look for .SS lines if none found
+  # to cater for either scenario.
+
   while :
-  do mygrep ^\\.RI $fileC
+  do mygrep2 ^\\.RI $fileC
     [ $linnum -ne 0 ] || break
     # Discard this entry
+    ! grep -E -q '#define' $fileG || no_macroRI=
     tail -n+$(($linnum + 1)) $fileC >$fileB
     cp $fileB $fileC
 
@@ -256,6 +270,16 @@ fix_name_line(){
     [ -z "$all_funcs" ] && all_funcs=$func ||\
       all_funcs="$all_funcs, $func"
   done
+
+  [ -z "$no_macroRI" ] ||
+  while :
+  do mygrep2 '^\.SS "#define' $fileC
+    [ $linnum -ne 0 ] || break
+    tail -n+$(($linnum + 1)) $fileC >$fileB
+    cp $fileB $fileC
+    func=$(cat $fileG | cut -f3 -d' ' | cut -f1 -d\()
+    [ -z "$all_funcs" ] && all_funcs=$func || all_funcs="$all_funcs, $func"
+  done
   # For now, assume name is at line 5
   head -n4 $target >$fileA
   desc=$(head -n5 $target | tail -n1 | cut -f3- -d" ")
@@ -299,15 +323,19 @@ delete_lines(){
 }
 
 mygrep(){
-  set +e
-  grep -En "$1" $2 2>/dev/null >$fileH
-  [ $? -ne 0 ] && linnum=0 ||\
-    { head -n1 $fileH >$fileG; linnum=$(cat $fileG | cut -f1 -d:); }
-  set -e
+  linnum=$(grep -En "$1" $2 2>/dev/null | head -n1 | cut -f1 -d:)
+  [ $linnum ] || linnum=0
+}
+
+# mygrep2 copies found line to $fileG. Only fix_name_line() needs this.
+# Using mygrep everywhere else gives a measurable CPU saving.
+mygrep2(){
+  linnum=$(grep -En "$1" $2 2>/dev/null | head -n1 | tee $fileG | cut -f1 -d:)
+  [ $linnum ] || linnum=0
 }
 
 make_temp_files(){
-  temps="A B C G H"
+  temps="A B C G"
   for i in $temps
   do declare -g file$i=$(mktemp)
   done
diff --git a/doxygen/doxygen.cfg.in b/doxygen/doxygen.cfg.in
index 97174ff..d719105 100644
--- a/doxygen/doxygen.cfg.in
+++ b/doxygen/doxygen.cfg.in
@@ -5,14 +5,18 @@ ABBREVIATE_BRIEF       =
 FULL_PATH_NAMES        = NO
 TAB_SIZE               = 8
 OPTIMIZE_OUTPUT_FOR_C  = YES
-INPUT                  = @abs_top_srcdir@/src
-FILE_PATTERNS          = *.c
+INPUT                  = @abs_top_srcdir@/src .
+FILE_PATTERNS          = *.c linux_list.h
 RECURSIVE              = YES
 EXCLUDE_SYMBOLS        = EXPORT_SYMBOL \
                          tcp_word_hdr \
                          nfq_handle \
                          nfq_data \
                          nfq_q_handle \
+                         nfnl_handle \
+                         ifindex_node \
+                         list_head \
+                         nlif_handle \
                          tcp_flag_word
 EXAMPLE_PATTERNS       =
 INPUT_FILTER           = "sed 's/EXPORT_SYMBOL//g'"
diff --git a/include/libnetfilter_queue/libnetfilter_queue.h b/include/libnetfilter_queue/libnetfilter_queue.h
index f7e68d8..851f2ca 100644
--- a/include/libnetfilter_queue/libnetfilter_queue.h
+++ b/include/libnetfilter_queue/libnetfilter_queue.h
@@ -1,4 +1,4 @@
-/* libnfqnetlink.h: Header file for the Netfilter Queue library.
+/* libnetfilter_queue.h: Header file for the Netfilter Queue library.
  *
  * (C) 2005 by Harald Welte <laforge@gnumonks.org>
  *
@@ -10,12 +10,13 @@
  * of the GNU General Public License, incorporated herein by reference.
  */
 
-#ifndef __LIBCTNETLINK_H
-#define __LIBCTNETLINK_H
+#ifndef __LIBNETFILTER_QUEUE_H
+#define __LIBNETFILTER_QUEUE_H
 
 #include <sys/time.h>
-#include <libnfnetlink/libnfnetlink.h>
+#include <libmnl/libmnl.h>
 
+#include <libnetfilter_queue/linux_list.h>
 #include <libnetfilter_queue/linux_nfnetlink_queue.h>
 
 #ifdef __cplusplus
@@ -25,8 +26,7 @@ extern "C" {
 struct nfq_handle;
 struct nfq_q_handle;
 struct nfq_data;
-
-extern int nfq_errno;
+struct nlif_handle;
 
 extern struct nfnl_handle *nfq_nfnlh(struct nfq_handle *h);
 extern int nfq_fd(struct nfq_handle *h);
@@ -35,6 +35,8 @@ typedef int  nfq_callback(struct nfq_q_handle *gh, struct nfgenmsg *nfmsg,
 		       struct nfq_data *nfad, void *data);
 
 
+extern unsigned int nfnl_rcvbufsiz(const struct nfnl_handle *h,
+				   unsigned int size);
 extern struct nfq_handle *nfq_open(void);
 extern struct nfq_handle *nfq_open_nfnl(struct nfnl_handle *nfnlh);
 extern int nfq_close(struct nfq_handle *h);
@@ -153,8 +155,41 @@ int nfq_nlmsg_parse(const struct nlmsghdr *nlh, struct nlattr **attr);
 struct nlmsghdr *nfq_nlmsg_put(char *buf, int type, uint32_t queue_num);
 struct nlmsghdr *nfq_nlmsg_put2(char *buf, int type, uint32_t queue_num, uint16_t flags);
 
+/*
+ * Network Interface Table API
+ */
+
+#ifndef IFNAMSIZ
+#define IFNAMSIZ 16
+#endif
+
+struct nlif_handle *nlif_open(void);
+void nlif_close(struct nlif_handle *orig);
+int nlif_fd(struct nlif_handle *nlif_handle);
+int nlif_query(struct nlif_handle *nlif_handle);
+int nlif_catch(struct nlif_handle *nlif_handle);
+int nlif_index2name(struct nlif_handle *nlif_handle, unsigned int if_index, char *name);
+int nlif_get_ifflags(const struct nlif_handle *h, unsigned int index, unsigned int *flags);
+
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
 
+/*
+ * __be46 stuff - should be in libmnl.h maybe?
+ */
+
+#include <byteswap.h>
+#if __BYTE_ORDER == __BIG_ENDIAN
+#  ifndef __be64_to_cpu
+#  define __be64_to_cpu(x)	(x)
+#  endif
+# else
+# if __BYTE_ORDER == __LITTLE_ENDIAN
+#  ifndef __be64_to_cpu
+#  define __be64_to_cpu(x)	__bswap_64(x)
+#  endif
+# endif
+#endif
+
 #endif	/* __LIBNFQNETLINK_H */
diff --git a/include/libnetfilter_queue/linux_list.h b/include/libnetfilter_queue/linux_list.h
new file mode 100644
index 0000000..b955609
--- /dev/null
+++ b/include/libnetfilter_queue/linux_list.h
@@ -0,0 +1,185 @@
+#ifndef _LINUX_LIST_H
+#define _LINUX_LIST_H
+
+#include <stddef.h>
+
+#undef offsetof
+#define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
+
+/*
+ * This is a cut-down copy of libnfnetlink/include/linux_list.h which is itself
+ * an old snapshot of linux/include/linux/list.h.
+ * This file only contains what we use.
+ *
+ * 2024-01-27 12:45:41 +1100 duncan_roe@optusnet.com.au
+ * LIST_POISONx doesn't really work for user space - just use NULL
+ *
+ * 2024-01-27 18:16:51 +1100 duncan_roe@optusnet.com.au
+ * I can't see how the prefetch() calls do any good so remove them
+ * and #define of prefetch
+ *
+ * 2024-01-27 18:53:46 +1100 duncan_roe@optusnet.com.au
+ * Take a few doxygen comment improvements from 6.6 Linux source
+ */
+
+/**
+ * \defgroup List Circular doubly linked list implementation
+ *
+ * Unlike file units (which are re-used), network interface indicies
+ * increase monotonically as they are brought up and down.
+ *
+ * To keep memory usage predictable as indices increase,
+ * the nlif_* functions keep their data in a circular list
+ * (in fact a number of lists, to minimise search times).
+ * <br>An alternative approach, which is faster to look up, is to have an array
+ * of pointers indexed by network interface index. Each unused interface index
+ * wastes \b sizeof(void*) in this setup.
+ * \ref nfq6"nfq6.c" demonstrates both approaches:
+ * search the source for `tests[24]` (numerous occurrences).
+ *
+ * \manonly
+.SH SYNOPSIS
+.nf
+\fB
+#include <libnetfilter_queue/libnetfilter_queue.h>
+\endmanonly
+ * @{
+ */
+
+
+/**
+ * container_of - cast a member of a structure out to the containing structure
+ *
+ * \param ptr:	the pointer to the member.
+ * \param type:	the type of the container struct this is embedded in.
+ * \param member:	the name of the member within the struct.
+ *
+ */
+#define container_of(ptr, type, member) ({			\
+	typeof( ((type *)0)->member ) *__mptr = (ptr);	\
+	(type *)( (char *)__mptr - offsetof(type,member) );})
+
+/*
+ * Simple doubly linked list implementation.
+ *
+ * Some of the internal functions ("__xxx") are useful when
+ * manipulating whole lists rather than single entries, as
+ * sometimes we already know the next/prev entries and we can
+ * generate better code by using them directly rather than
+ * using the generic single-entry routines.
+ */
+
+/**
+ * \struct list_head
+ * Link to adjacent members of the circular list
+ * \note Each member of a list must start with this structure
+ * (containing structures OK)
+ * \var list_head::next
+ * pointer to the next list member
+ * \var list_head::prev
+ * pointer to the previous list member
+ */
+
+struct list_head {
+	struct list_head *next, *prev;
+};
+
+/**
+ * INIT_LIST_HEAD - Initialise first member of a new list
+ * \param ptr the &struct list_head pointer.
+ */
+#define INIT_LIST_HEAD(ptr) do { \
+	(ptr)->next = (ptr); (ptr)->prev = (ptr); \
+} while (0)
+
+/*
+ * Insert a new entry between two known consecutive entries.
+ *
+ * This is only for internal list manipulation where we know
+ * the prev/next entries already!
+ */
+static inline void __list_add(struct list_head *new,
+			      struct list_head *prev,
+			      struct list_head *next)
+{
+	next->prev = new;
+	new->next = next;
+	new->prev = prev;
+	prev->next = new;
+}
+
+/**
+ * list_add - add a new entry
+ * \param new: new entry to be added
+ * \param head: list head to add it after
+ *
+ * Insert a new entry after the specified head.
+ * This is good for implementing stacks.
+ */
+static inline void list_add(struct list_head *new, struct list_head *head)
+{
+	__list_add(new, head, head->next);
+}
+
+/**
+ * list_entry - get the struct for this entry
+ * \param ptr:	the &struct list_head pointer.
+ * \param type:	the type of the struct this is embedded in.
+ * \param member:	the name of the list_head within the struct.
+ */
+#define list_entry(ptr, type, member) \
+	container_of(ptr, type, member)
+
+/*
+ * Delete a list entry by making the prev/next entries
+ * point to each other.
+ *
+ * This is only for internal list manipulation where we know
+ * the prev/next entries already!
+ */
+static inline void __list_del(struct list_head * prev, struct list_head * next)
+{
+	next->prev = prev;
+	prev->next = next;
+}
+
+/**
+ * list_del - deletes entry from list.
+ * \param entry: the element to delete from the list.
+ * \note
+ * list_empty() on **entry** does not return true after this, **entry** is
+ * in an undefined state.
+ */
+static inline void list_del(struct list_head *entry)
+{
+	__list_del(entry->prev, entry->next);
+	entry->next = NULL;
+	entry->prev = NULL;
+}
+
+/**
+ * list_for_each_entry	-	iterate over list of given type
+ * \param pos:	the type * to use as a loop cursor.
+ * \param head:	the head for your list.
+ * \param member:	the name of the list_head within the struct.
+ */
+#define list_for_each_entry(pos, head, member)				\
+	for (pos = list_entry((head)->next, typeof(*pos), member);	\
+	     &pos->member != (head); 					\
+	     pos = list_entry(pos->member.next, typeof(*pos), member))	\
+
+/**
+ * list_empty - tests whether a list is empty
+ * \param head: the list to test.
+ * \return 1 if list is empty, 0 otherwise
+ */
+static inline int list_empty(const struct list_head *head)
+{
+	return head->next == head;
+}
+
+/**
+ * @}
+ */
+
+#endif
diff --git a/include/libnetfilter_queue/linux_nfnetlink_queue.h b/include/libnetfilter_queue/linux_nfnetlink_queue.h
index 6844270..f8c33cb 100644
--- a/include/libnetfilter_queue/linux_nfnetlink_queue.h
+++ b/include/libnetfilter_queue/linux_nfnetlink_queue.h
@@ -8,7 +8,6 @@
 #endif
 
 #include <linux/types.h>
-#include <libnfnetlink/linux_nfnetlink.h>
 
 enum nfqnl_msg_types {
 	NFQNL_MSG_PACKET,		/* packet from kernel to userspace */
diff --git a/libnetfilter_queue.pc.in b/libnetfilter_queue.pc.in
index 9c6c2c4..962c686 100644
--- a/libnetfilter_queue.pc.in
+++ b/libnetfilter_queue.pc.in
@@ -12,5 +12,4 @@ Version: @VERSION@
 Requires: libnfnetlink
 Conflicts:
 Libs: -L${libdir} -lnetfilter_queue
-Libs.private: @LIBNFNETLINK_LIBS@
 Cflags: -I${includedir}
diff --git a/src/Makefile.am b/src/Makefile.am
index 079853e..e5e1d66 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -30,6 +30,7 @@ libnetfilter_queue_la_LDFLAGS = -Wc,-nostartfiles \
 				-version-info $(LIBVERSION)
 libnetfilter_queue_la_SOURCES = libnetfilter_queue.c	\
 				nlmsg.c			\
+				iftable.c		\
 				extra/checksum.c	\
 				extra/icmp.c		\
 				extra/ipv6.c		\
@@ -38,4 +39,4 @@ libnetfilter_queue_la_SOURCES = libnetfilter_queue.c	\
 				extra/pktbuff.c		\
 				extra/udp.c
 
-libnetfilter_queue_la_LIBADD  = ${LIBNFNETLINK_LIBS} ${LIBMNL_LIBS}
+libnetfilter_queue_la_LIBADD  = ${LIBMNL_LIBS}
diff --git a/src/extra/pktbuff.c b/src/extra/pktbuff.c
index 40d2250..833456c 100644
--- a/src/extra/pktbuff.c
+++ b/src/extra/pktbuff.c
@@ -77,6 +77,13 @@ static void pktb_setup_metadata(struct pkt_buff *pktb, void *pkt_data,
 
 /**
  * pktb_alloc - allocate a new packet buffer
+ * \note
+ * pktb_alloc copies the IP datagram to the (<b>calloc</b>'d) packet buffer.
+ * This is essential if your application needs to hold on to multiple
+ * datagrams.
+ * <br>If your application processes each datagram as it arrives, you can avoid
+ * the datagram copy by calling pktb_setup_raw() instead.
+ *
  * \param family Indicate what family. Currently supported families are
  * AF_BRIDGE, AF_INET & AF_INET6.
  * \param data Pointer to packet data
@@ -131,11 +138,19 @@ struct pkt_buff *pktb_alloc(int family, void *data, size_t len, size_t extra)
  * \param len Packet data length
  * \param extra Extra memory available after packet data (for mangling).
  *
- * Use this function to set up a packet buffer from a memory area, minimum size
- * of such memory area must be pktb_head_size(). This function attaches the
- * packet data that is provided to the packet buffer (data is not copied). Use
- * this function as an alternative to the pktb_alloc() interface for more
- * control on memory management.
+ * Use this function to set up a packet buffer in a memory area of size
+ * pktb_head_size(). The created packet buffer addresses the packet data
+ * in the buffer filled by <b>mnl_socket_recvfrom</b>() in the mainline.
+ * This function avoids a packet copy and uses less memory than the alternative
+ * pktb_alloc() interface.
+ *
+ * \note
+ * The extra space available for mangling is the buffer size minus the number of
+ * bytes returned by <b>mnl_socket_recvfrom</b>().
+ * The mainline needs to pass this datum to the callback,
+ * since that is where pktb_setup_raw() is called.
+ * The \b data argument of <b>mnl_cb_run</b>() is available:
+ * see \ref nfq6"nfq6.c" (search for `tests[7]`).
  *
  * \return Pointer to a new userspace packet buffer or NULL on failure.
  * \par Errors
@@ -201,7 +216,7 @@ void pktb_free(struct pkt_buff *pktb)
  * 1. Functions to get values of members of opaque __struct pktbuff__, described
  * below
  *
- * 2. Internal functions, described in Module __Internal functions__
+ * 2. Internal functions, described in Topic __Internal functions__
  *
  * \manonly
 .SH SYNOPSIS
diff --git a/src/iftable.c b/src/iftable.c
new file mode 100644
index 0000000..d0ee7dd
--- /dev/null
+++ b/src/iftable.c
@@ -0,0 +1,391 @@
+/* iftable - table of network interfaces
+ *
+ * (C) 2004 by Astaro AG, written by Harald Welte <hwelte@astaro.com>
+ * (C) 2008 by Pablo Neira Ayuso <pablo@netfilter.org>
+ * (C) 2024 by Duncan Roe <duncan_roe@optusnet.com.au>
+ *
+ * This software is Free Software and licensed under GNU GPLv2+.
+ */
+
+/* IFINDEX handling */
+
+#include <time.h>
+#include <errno.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <arpa/inet.h>
+#include <sys/types.h>
+#include <netinet/in.h>
+#include <linux/netdevice.h>
+#include <linux/rtnetlink.h>
+#include <linux/netfilter/nfnetlink_queue.h>
+#include <libnetfilter_queue/libnetfilter_queue.h>
+
+#include "internal.h"
+
+#define NUM_NLIF_BITS 4
+#define NUM_NLIF_ENTRIES (1 << NUM_NLIF_BITS)
+#define NLIF_ENTRY_MASK (NUM_NLIF_ENTRIES -1)
+
+/**
+ * \defgroup iftable Functions to manage a table of network interfaces
+ * These functions maintain a database of the name and flags of each
+ * network interface.
+ *
+ * mnl API programs may instead use
+ * [libmnl](https://netfilter.org/projects/libmnl/doxygen/html/)
+ * calls directly to maintain an
+ * interface table with more (or less) data points, e.g. with MTU.
+ * <br>\ref nfq6"nfq6.c" has example code:
+ * search the source for `tests[24]` (numerous occurrences).
+ * The <b><tt>!tests[24]</tt></b> code uses circular
+ * lists like the functions described here.
+ *
+ * Programs access an nlif database through an opaque __struct nlif_handle__
+ * interface resolving handle. Call nlif_open() to get a handle:
+ * \verbatim
+	h = nlif_open();
+	if (h == NULL) {
+		perror("nlif_open");
+		exit(EXIT_FAILURE);
+	}
+\endverbatim
+ * Once the handler is open, you need to fetch the interface table at a
+ * whole via a call to nlif_query.
+ * \verbatim
+	nlif_query(h);
+\endverbatim
+ * libnetfilter_queue is able to update the interface mapping
+ * when a new interface appears.
+ * To do so, you need to call nlif_catch() on the handler after each
+ * interface related event. The simplest way to get and treat event is to run
+ * a **select()** or **poll()** against the nlif and netilter_queue
+ * file descriptors.
+ * E.g. use nlif_fd() to get the nlif file descriptor, then give this fd to
+ * **poll()** as in this code snippet (error-checking removed):
+ * \verbatim
+	if_fd = nlif_fd(h);
+	qfd = mnl_socket_get_fd(nl); // For mnl API or ...
+	qfd = nfq_fd(qh);            // For nfnl API
+	. . .
+	fds[0].fd = ifd;
+	fds[0].events = POLLIN;
+	fds[1].fd = qfd;
+	fds[1].events = POLLIN;
+	for(;;)
+	{
+		poll((struct pollfd *)&fds, 2, -1);
+		if (fds[0].revents & POLLIN)
+			nlif_catch(h);
+\endverbatim
+ * Don't forget to close the handler when you don't need the feature anymore:
+ * \verbatim
+	nlif_close(h);
+\endverbatim
+ *
+ * \manonly
+.SH SYNOPSIS
+.nf
+\fB
+#include <libnetfilter_queue/libnetfilter_queue.h>
+\endmanonly
+ * @{
+ */
+
+struct ifindex_node {
+	struct list_head head;
+
+	uint32_t index;
+	uint32_t type;
+	uint32_t flags;
+	char name[IFNAMSIZ];
+};
+
+struct nlif_handle {
+	struct list_head ifindex_hash[NUM_NLIF_ENTRIES];
+	struct mnl_socket *nl;
+	unsigned int portid;
+};
+
+/*
+ * find_ifindex_node - find node by index
+ */
+
+static struct ifindex_node *find_ifindex_node(uint32_t index,
+    struct nlif_handle *h)
+{
+	struct ifindex_node *result;
+	uint32_t hash;
+
+	if (!index)
+		goto err;
+
+	hash = index & NLIF_ENTRY_MASK;
+	list_for_each_entry(result, &h->ifindex_hash[hash], head) {
+		if (result->index == index)
+			return result;
+	}
+err:
+	errno = ENOENT;
+	return NULL;
+}
+
+/*
+ * data_cb - callback for rtnetlink messages
+ *           caller will put nlif_handle in data
+ */
+
+static int data_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct ifinfomsg *ifi_msg = mnl_nlmsg_get_payload(nlh);
+	struct nlif_handle *h = data;
+	struct nlattr *attr;
+	struct ifindex_node *this = find_ifindex_node(ifi_msg->ifi_index, h);
+
+	if (nlh->nlmsg_type != RTM_NEWLINK && nlh->nlmsg_type != RTM_DELLINK) {
+		errno = EPROTO;
+		return MNL_CB_ERROR;
+	}
+
+	/* RTM_DELLINK is simple, do it first for less indenting */
+	if (nlh->nlmsg_type == RTM_DELLINK) {
+		/*
+		 * rtnetlink.c used list_for_each_entry_safe()
+		 * and removed all entries with the wanted index number.
+		 * But we know there can be at max one entry,
+		 * so delete it if we have one.
+		 */
+		if (this) {
+			list_del((struct list_head *)this);
+			free(this);
+		}
+	return MNL_CB_OK;
+	}
+
+	if (!this) {
+		uint32_t hash = ifi_msg->ifi_index & NLIF_ENTRY_MASK;
+
+		this = calloc(1, sizeof(*this));
+		if (!this)
+			return MNL_CB_ERROR;
+		this->index = ifi_msg->ifi_index;
+		this->type = ifi_msg->ifi_type;
+		this->flags = ifi_msg->ifi_flags;
+		list_add((struct list_head *)this, &h->ifindex_hash[hash]);
+	}
+
+	mnl_attr_for_each(attr, nlh, sizeof(*ifi_msg)) {
+		/* All we want is the interface name */
+		if (mnl_attr_get_type(attr) == IFLA_IFNAME) {
+			if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0) {
+				perror("mnl_attr_validate");
+				return MNL_CB_ERROR;
+			}
+			strcpy(this->name, mnl_attr_get_str(attr));
+			break;
+		}
+	}
+	return MNL_CB_OK;
+}
+
+/**
+ * nlif_index2name - get the name for an ifindex
+ *
+ * \param h pointer to nlif_handle created by nlif_open()
+ * \param index ifindex to be resolved
+ * \param name interface name, pass a buffer of IFNAMSIZ size
+ * \return -1 on error, 1 on success
+ */
+EXPORT_SYMBOL
+int nlif_index2name(struct nlif_handle *h,
+		    unsigned int index,
+		    char *name)
+{
+	unsigned int hash;
+	struct ifindex_node *this;
+
+	if (index == 0) {
+		strcpy(name, "*");
+		return 1;
+	}
+
+	hash = index & 0xF;
+	list_for_each_entry(this, &h->ifindex_hash[hash], head) {
+		if (this->index == index) {
+			strcpy(name, this->name);
+			return 1;
+		}
+	}
+
+	errno = ENOENT;
+	return -1;
+}
+
+/**
+ * nlif_get_ifflags - get the flags for an ifindex
+ *
+ * \param h pointer to nlif_handle created by nlif_open()
+ * \param index ifindex to be resolved
+ * \param flags pointer to variable used to store the interface flags
+ * \return -1 on error, 1 on success
+ */
+EXPORT_SYMBOL
+int nlif_get_ifflags(const struct nlif_handle *h,
+		     unsigned int index,
+		     unsigned int *flags)
+{
+	unsigned int hash;
+	struct ifindex_node *this;
+
+	if (!index)
+		goto err;
+
+	hash = index & 0xF;
+	list_for_each_entry(this, &h->ifindex_hash[hash], head) {
+		if (this->index == index) {
+			*flags = this->flags;
+			return 1;
+		}
+	}
+err:
+	errno = ENOENT;
+	return -1;
+}
+
+/**
+ * nlif_open - initialize interface table
+ *
+ * Open a netlink socket and initialise interface table.
+ * Call this before any other nlif_* function
+ *
+ * \return NULL on error, else valid pointer to an nlif_handle structure
+ */
+EXPORT_SYMBOL
+struct nlif_handle *nlif_open(void)
+{
+	int i;
+	struct nlif_handle *h;
+
+	h = calloc(1,  sizeof(struct nlif_handle));
+	if (h == NULL)
+		goto err;
+
+	for (i = NUM_NLIF_ENTRIES - 1; i>= 0; i--)
+		INIT_LIST_HEAD(&h->ifindex_hash[i]);
+
+	h->nl = mnl_socket_open(NETLINK_ROUTE);
+	if (!h->nl)
+		goto err_free;
+
+	if (mnl_socket_bind(h->nl, RTMGRP_LINK, MNL_SOCKET_AUTOPID) < 0)
+		goto err_close;
+	h->portid = mnl_socket_get_portid(h->nl);
+
+	return h;
+
+err_close:
+	mnl_socket_close(h->nl);
+err_free:
+	free(h);
+err:
+	return NULL;
+}
+
+/**
+ * nlif_close - free all resources associated with the interface table
+ *
+ * \param h pointer to nlif_handle created by nlif_open()
+ */
+EXPORT_SYMBOL
+void nlif_close(struct nlif_handle *h)
+{
+	int i;
+	struct list_head *tmp;
+
+	mnl_socket_close(h->nl);
+
+	for (i = NUM_NLIF_ENTRIES - 1; i>= 0; i--) {
+		while (h->ifindex_hash[i].next != &h->ifindex_hash[i]) {
+			tmp = h->ifindex_hash[i].next;
+			list_del(tmp);
+			free(tmp);
+		}
+	}
+
+	free(h);
+}
+
+/**
+ * nlif_catch - receive message from netlink and update interface table
+ *
+ * \param h pointer to nlif_handle created by nlif_open()
+ * \return 0 if OK
+ */
+EXPORT_SYMBOL
+int nlif_catch(struct nlif_handle *h)
+{
+	char buf[MNL_SOCKET_DUMP_SIZE];
+	int ret;
+
+	if (!h->nl)                /* The old library had this test */
+		return -1;
+
+	ret = mnl_socket_recvfrom(h->nl, buf, sizeof buf);
+	if (ret == -1)
+		return ret;
+	return mnl_cb_run(buf, ret, 0, h->portid, data_cb, h) == -1 ? -1 : 0;
+}
+
+/**
+ * nlif_query - request a dump of interfaces available in the system
+ * \param h: pointer to a valid nlif_handler
+ * \return -1 on error with errno set, else >=0
+ * \par Errors
+ * __EINTR__ Dump was interrupted
+ * (by creation or deletion of a network interface).
+ * <br> Caller must call nlif_close() and nlif_open() before re-trying
+ */
+EXPORT_SYMBOL
+int nlif_query(struct nlif_handle *h)
+{
+	char buf[MNL_SOCKET_DUMP_SIZE];
+	struct nlmsghdr *nlh;
+	uint32_t seq;
+	int ret;
+	struct rtgenmsg *rt;
+
+	nlh = mnl_nlmsg_put_header(buf);
+	nlh->nlmsg_type = RTM_GETLINK;
+	nlh->nlmsg_flags = NLM_F_REQUEST | NLM_F_DUMP;
+	nlh->nlmsg_seq = seq = time(NULL);
+	rt = mnl_nlmsg_put_extra_header(nlh, sizeof(struct rtgenmsg));
+	rt->rtgen_family = AF_PACKET;
+	if (mnl_socket_sendto(h->nl, nlh, nlh->nlmsg_len) < 0)
+		return -1;
+	ret = mnl_socket_recvfrom(h->nl, buf, sizeof(buf));
+	while (ret > 0) {
+		ret = mnl_cb_run(buf, ret, seq, h->portid, data_cb, h);
+		if (ret <= MNL_CB_STOP)
+			break;
+		ret = mnl_socket_recvfrom(h->nl, buf, sizeof(buf));
+	}
+	return ret;
+}
+
+/**
+ * nlif_fd - get file descriptor for the netlink socket
+ *
+ * \param h pointer to nlif_handle created by nlif_open()
+ * \return socket fd or -1 on error
+ */
+EXPORT_SYMBOL
+int nlif_fd(struct nlif_handle *h)
+{
+	return h->nl? mnl_socket_get_fd(h->nl) : -1;
+}
+
+/**
+ * @}
+ */
diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index bf67a19..c9f8377 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -19,6 +19,7 @@
  *  2006-01-23 Andreas Florath <andreas@florath.net>
  *	Fix __set_verdict() that it can now handle payload.
  */
+//#define __LIBNFNETLINK_H
 
 #include <stdio.h>
 #include <stdlib.h>
@@ -31,7 +32,14 @@
 #include <sys/socket.h>
 #include <linux/netfilter/nfnetlink_queue.h>
 
-#include <libnfnetlink/libnfnetlink.h>
+/* Use real headers since libnfnetlink is going away. */
+/* nfq_pkt_parse_attr_cb only knows attribates up to NFQA_SECCTX */
+/* so won't try to validate them but will store them. */
+/* mnl API programs will then be able to access them. */
+#include <linux/netfilter/nfnetlink.h>
+#include <linux/netfilter/nfnetlink_compat.h>
+
+#include <libmnl/libmnl.h>
 #include <libnetfilter_queue/libnetfilter_queue.h>
 #include "internal.h"
 
@@ -41,12 +49,49 @@
  * libnetfilter_queue is a userspace library providing an API to packets that
  * have been queued by the kernel packet filter. It is is part of a system that
  * replaces the old ip_queue / libipq mechanism (withdrawn in kernel 3.5).
+ * \n
+ * libnetfilter_queue in fact offers 2 different APIs:
+ *   -# The modern API which provides helper functions for some
+ * libmnl functions. Users call other libmnl functions directly.
+ * The documentation calls this the **mnl** API.
+ *   -# An older API which provided wrappers for all relevant
+ * functions in the old libnfnetlink library.
+ * This API now also uses libmnl calls.
+ * The documentation calls this the **nfnl** API.
+ *
+ * When developing new software, you have to choose which of the mnl and nfnl
+ * APIs to use. Of the two, the nfnl API is higher level but restricts you to
+ * what the API provides: you can't, for instance, send a packet to another
+ * queue.
+ *
+ * With the mnl API, you have access to everything.
+ *
+ * Function groups specific to an API are indicated as such in
+ * the \e Topics (formerly <i>Modules</i>) tab in the HTML documentation;
+ * in man pages the indication (if any) is at the end of the \b NAME line.
+ *
+ * Whichever API you choose, the higher-level functions are available.
+ * These include everything to do with mangling
+ * (packet buffer and protocol helpers).
+ *
+ * libnfnetlink itself is deprecated and will eventually be removed.
  *
  * libnetfilter_queue homepage is:
  * 	https://netfilter.org/projects/libnetfilter_queue/
  *
- <h1>Dependencies</h1>
- * libnetfilter_queue requires libmnl, libnfnetlink and a kernel that includes
+ * \manonly
+.SS "Accessing source online "
+.PP
+The HTML documentation gives immediate access to the source code of each
+documented function\&. If you would like to use this but your Linux
+distribution does not include the HTML documentation, you can access it
+online by going to the homepage above then clicking the \fIdoxygen\fP link under
+the \fBDocumentation\fP heading\&.
+.PP
+\endmanonly
+ *
+ * <h1>Dependencies</h1>
+ * libnetfilter_queue requires libmnl and a kernel that includes
  * the Netfilter NFQUEUE over NFNETLINK interface (i.e. 2.6.14 or later).
  *
  * <h1>Main Features</h1>
@@ -69,7 +114,9 @@
  * needed information is the packet id.
  *
  * When a queue is full, packets that should have been enqueued are dropped by
- * kernel instead of being enqueued.
+ * the kernel instead of being enqueued. You can instead instruct the kernel to
+ * accept such packets by configuring the
+ * \ref failopen"fail-open" option.
  *
  * <h1>Git Tree</h1>
  * The current development version of libnetfilter_queue can be accessed at
@@ -83,33 +130,33 @@
  *
  * To write your own program using libnetfilter_queue, you should start by
  * reading (or, if feasible, compiling and stepping through with *gdb*)
- * nf-queue.c source file.
- * Simple compile line:
+ * \b examples/nf-queue.c
+ * https://git.netfilter.org/libnetfilter_queue/tree/examples/nf-queue.c
+ * <br>Simple compile line:
  * \verbatim
-gcc -g3 -ggdb -Wall -lmnl -lnetfilter_queue -o nf-queue nf-queue.c
+gcc -g3 -gdwarf-4 -Wall -lmnl -lnetfilter_queue -o nf-queue nf-queue.c
 \endverbatim
- *The doxygen documentation
- * \htmlonly
-<a class="el" href="group__LibrarySetup.html">LibrarySetup </a>
-\endhtmlonly
- * \manonly
-\fBLibrarySetup\fP\
-\endmanonly
- * is Deprecated and
- * incompatible with non-deprecated functions. It is hoped to produce a
- * corresponding non-deprecated (*Current*) topic soon.
  *
- * Somewhat outdated but possibly providing some insight into
+ * Somewhat outdated but still providing insight into
  * libnetfilter_queue usage is the following
  * article:
- *  https://home.regit.org/netfilter-en/using-nfqueue-and-libnetfilter_queue/
+ *  https://home.regit.org/netfilter-en/using-nfqueue-and-libnetfilter_queue/,
+ * which also documents the layout of
+ * <i>/proc/net/netfilter/nfnetlink_queue</i>.
+ *
+ * \anchor nfq6<b>nfq6.c</b>
+ * https://raw.githubusercontent.com/duncan-roe/nfq6/main/nfq6.c
+ * is an extension of nf-queue.c.
+ * The code has examples of packet mangling (any protocol)
+ * and other features mentioned elsewhere.
+ * Search for `Exit nfq6` to land in the middle of the usage summary.
  *
  * <h1>ENOBUFS errors in recv()</h1>
  *
  * recv() may return -1 and errno is set to ENOBUFS in case that your
  * application is not fast enough to retrieve the packets from the kernel.
  * In that case, you can increase the socket buffer size by means of
- * nfnl_rcvbufsiz(). Although this delays the appearance of ENOBUFS errors,
+ * setsocketopt(). Although this delays the appearance of ENOBUFS errors,
  * you may hit it again sooner or later. The next section provides some hints
  * on how to obtain the best performance for your application.
  *
@@ -117,7 +164,11 @@ gcc -g3 -ggdb -Wall -lmnl -lnetfilter_queue -o nf-queue nf-queue.c
  * To improve your libnetfilter_queue application in terms of performance,
  * you may consider the following tweaks:
  *
- * - increase the default socket buffer size by means of nfnl_rcvbufsiz().
+ * - increase the default socket buffer size.
+ * Use setsocketopt() with SOL_SOCKET and SO_RCVBUFFORCE on the netlink socket
+ * fd returned by mnl_socket_get_fd()
+ * (software using the old nfnl API calls nfq_fd()).
+ * Software calling nfnl_rcvbufsiz() will continue to be supported.
  * - set nice value of your process to -20 (maximum priority).
  * - set the CPU affinity of your process to a spare core that is not used
  * to handle NIC interruptions.
@@ -125,42 +176,65 @@ gcc -g3 -ggdb -Wall -lmnl -lnetfilter_queue -o nf-queue nf-queue.c
  * (requires Linux kernel >= 2.6.30).
  * - see --queue-balance option in NFQUEUE target for multi-threaded apps
  * (it requires Linux kernel >= 2.6.31).
- * - consider using fail-open option see nfq_set_queue_flags() (it requires
- *  Linux kernel >= 3.6)
+ * - consider using
+ * \anchor failopen \b fail-open option see nfq_set_queue_flags()
+ * (it requires  Linux kernel >= 3.6)
  * - make your application offload aware to avoid costly normalization on kernel
  * side.  See NFQA_CFG_F_GSO flag to nfq_set_queue_flags().
  *  Linux kernel >= 3.10.
- * - increase queue max length with nfq_set_queue_maxlen() to resist to packets
- * burst
  */
 
+/* We need a rump nfnl_handle to support nfnl_rcvbufsiz()
+ * which is documented in libnetfilter_queue(7) and on the HTML main page.
+ * Luckily fd is the 1st item and that's all we need
+ * Because we need to have an fd in struct nfnl_handle,
+ * we don't have one in struct nfq_handle (for e.g. nfq_fd()).
+ */
+
+struct nfnl_handle {
+	int			fd;
+};
+
 struct nfq_handle
 {
+	unsigned int portid;
 	struct nfnl_handle *nfnlh;
-	struct nfnl_subsys_handle *nfnlssh;
 	struct nfq_q_handle *qh_list;
+	struct mnl_socket *nl;
+	struct nfnl_handle rump_nfnl_handle;
 };
 
 struct nfq_q_handle
 {
 	struct nfq_q_handle *next;
 	struct nfq_handle *h;
-	uint16_t id;
+	uint16_t queue_num;
 
 	nfq_callback *cb;
 	void *data;
 };
 
 struct nfq_data {
-	struct nfattr **data;
+	struct nlattr **data;
 };
 
-EXPORT_SYMBOL int nfq_errno;
-
 /***********************************************************************
  * low level stuff
  ***********************************************************************/
 
+static int nfq_query(struct nfq_handle *h, struct nlmsghdr *nlh, char *buf,
+		      size_t bufsiz)
+{
+	int ret;
+
+	ret = mnl_socket_sendto(h->nl, nlh, nlh->nlmsg_len);
+	if (ret != -1)
+		ret = mnl_socket_recvfrom(h->nl, buf, bufsiz);
+	if (ret != -1)
+		ret = mnl_cb_run(buf, ret, 0, h->portid, NULL, NULL);
+	return ret;
+}
+
 static void del_qh(struct nfq_q_handle *qh)
 {
 	struct nfq_q_handle *cur_qh, *prev_qh = NULL;
@@ -183,12 +257,12 @@ static void add_qh(struct nfq_q_handle *qh)
 	qh->h->qh_list = qh;
 }
 
-static struct nfq_q_handle *find_qh(struct nfq_handle *h, uint16_t id)
+static struct nfq_q_handle *find_qh(struct nfq_handle *h, uint16_t queue_num)
 {
 	struct nfq_q_handle *qh;
 
 	for (qh = h->qh_list; qh; qh = qh->next) {
-		if (qh->id == id)
+		if (qh->queue_num == queue_num)
 			return qh;
 	}
 	return NULL;
@@ -199,46 +273,36 @@ static struct nfq_q_handle *find_qh(struct nfq_handle *h, uint16_t id)
 __build_send_cfg_msg(struct nfq_handle *h, uint8_t command,
 		uint16_t queuenum, uint16_t pf)
 {
-	union {
-		char buf[NFNL_HEADER_LEN
-			+NFA_LENGTH(sizeof(struct nfqnl_msg_config_cmd))];
-		struct nlmsghdr nmh;
-	} u;
-	struct nfqnl_msg_config_cmd cmd;
-
-	nfnl_fill_hdr(h->nfnlssh, &u.nmh, 0, AF_UNSPEC, queuenum,
-			NFQNL_MSG_CONFIG, NLM_F_REQUEST|NLM_F_ACK);
-
-	cmd._pad = 0;
-	cmd.command = command;
-	cmd.pf = htons(pf);
-	nfnl_addattr_l(&u.nmh, sizeof(u), NFQA_CFG_CMD, &cmd, sizeof(cmd));
-
-	return nfnl_query(h->nfnlh, &u.nmh);
-}
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
 
-static int __nfq_rcv_pkt(struct nlmsghdr *nlh, struct nfattr *nfa[],
-		void *data)
-{
-	struct nfgenmsg *nfmsg = NLMSG_DATA(nlh);
-	struct nfq_handle *h = data;
-	uint16_t queue_num = ntohs(nfmsg->res_id);
-	struct nfq_q_handle *qh = find_qh(h, queue_num);
-	struct nfq_data nfqa;
+	nlh = nfq_nlmsg_put2(buf, NFQNL_MSG_CONFIG, queuenum, NLM_F_ACK);
 
-	if (!qh)
-		return -ENODEV;
-
-	if (!qh->cb)
-		return -ENODEV;
-
-	nfqa.data = nfa;
+	nfq_nlmsg_cfg_put_cmd(nlh, AF_UNSPEC, command);
 
-	return qh->cb(qh, nfmsg, &nfqa, qh->data);
+	return nfq_query(h, nlh, buf, sizeof(buf));
 }
 
 /* public interface */
 
+/**
+ * \addtogroup LibrarySetup
+ * @{
+ */
+
+/**
+ *
+ * nfq_nfnlh - obtain a handle for nfnl_rcvbufsiz()
+ *
+ * \param h Netfilter queue connection handle obtained via call to nfq_open()
+ *
+ * \return pointer to struct nfnl_handle
+ *
+ * \warning
+ * The returned handle \b h is for nfnl_rcvbufsiz() only. It is not suitable
+ * for calling other functions in the deprecated \b libnfnetlink library.
+ */
+
 EXPORT_SYMBOL
 struct nfnl_handle *nfq_nfnlh(struct nfq_handle *h)
 {
@@ -246,14 +310,22 @@ struct nfnl_handle *nfq_nfnlh(struct nfq_handle *h)
 }
 
 /**
+ * @}
+ */
+
+/**
+ *
+ * \defgroup Queue Queue handling [nfnl API]
  *
- * \defgroup Queue Queue handling [DEPRECATED]
+ * \warning
+ * This page describes functions from the old nfnl API.
+ * Consider using the mnl API for new projects.
  *
  * Once libnetfilter_queue library has been initialised (See
  * \link LibrarySetup \endlink), it is possible to bind the program to a
  * specific queue. This can be done by using nfq_create_queue().
  *
- * The queue can then be tuned via nfq_set_mode() or nfq_set_queue_maxlen().
+ * The queue can then be tuned via nfq_set_mode()
  *
  * Here's a little code snippet that create queue numbered 0:
  * \verbatim
@@ -328,14 +400,18 @@ struct nfnl_handle *nfq_nfnlh(struct nfq_handle *h)
 EXPORT_SYMBOL
 int nfq_fd(struct nfq_handle *h)
 {
-	return nfnl_fd(nfq_nfnlh(h));
+	return h->nfnlh->fd;
 }
 /**
  * @}
  */
 
 /**
- * \defgroup LibrarySetup Library setup [DEPRECATED]
+ * \defgroup LibrarySetup Library setup [nfnl API]
+ *
+ * \warning
+ * This page describes functions from the old nfnl API.
+ * Consider using the mnl API for new projects.
  *
  * Library initialisation is made in two steps.
  *
@@ -383,75 +459,36 @@ int nfq_fd(struct nfq_handle *h)
 EXPORT_SYMBOL
 struct nfq_handle *nfq_open(void)
 {
-	struct nfnl_handle *nfnlh = nfnl_open();
-	struct nfq_handle *qh;
-
-	if (!nfnlh)
-		return NULL;
-
-	/* unset netlink sequence tracking by default */
-	nfnl_unset_sequence_tracking(nfnlh);
-
-	qh = nfq_open_nfnl(nfnlh);
-	if (!qh)
-		nfnl_close(nfnlh);
-
-	return qh;
-}
-
-/**
- * @}
- */
-
-/**
- * nfq_open_nfnl - open a nfqueue handler from a existing nfnetlink handler
- * \param nfnlh Netfilter netlink connection handle obtained by calling nfnl_open()
- *
- * This function obtains a netfilter queue connection handle using an existing
- * netlink connection. This function is used internally to implement
- * nfq_open(), and should typically not be called directly.
- *
- * \return a pointer to a new queue handle or NULL on failure.
- */
-EXPORT_SYMBOL
-struct nfq_handle *nfq_open_nfnl(struct nfnl_handle *nfnlh)
-{
-	struct nfnl_callback pkt_cb = {
-		.call		= __nfq_rcv_pkt,
-		.attr_count	= NFQA_MAX,
-	};
-	struct nfq_handle *h;
-	int err;
+	struct nfq_handle *h = malloc(sizeof(*h));
 
-	h = malloc(sizeof(*h));
 	if (!h)
 		return NULL;
-
 	memset(h, 0, sizeof(*h));
-	h->nfnlh = nfnlh;
 
-	h->nfnlssh = nfnl_subsys_open(h->nfnlh, NFNL_SUBSYS_QUEUE,
-				      NFQNL_MSG_MAX, 0);
-	if (!h->nfnlssh) {
-		/* FIXME: nfq_errno */
-		goto out_free;
+	h->nl = mnl_socket_open(NETLINK_NETFILTER);
+	if (!h->nl) {
+		free(h);
+		return NULL;
 	}
 
-	pkt_cb.data = h;
-	err = nfnl_callback_register(h->nfnlssh, NFQNL_MSG_PACKET, &pkt_cb);
-	if (err < 0) {
-		nfq_errno = err;
-		goto out_close;
+	if (mnl_socket_bind(h->nl, 0, MNL_SOCKET_AUTOPID) < 0) {
+		mnl_socket_close(h->nl);
+		free(h);
+		return NULL;
 	}
+	h->portid = mnl_socket_get_portid(h->nl);
+
+	/* fudges for nfnl_rcvbufsiz() */
+	h->nfnlh = &h->rump_nfnl_handle;
+	h->rump_nfnl_handle.fd = mnl_socket_get_fd(h->nl);
 
 	return h;
-out_close:
-	nfnl_subsys_close(h->nfnlssh);
-out_free:
-	free(h);
-	return NULL;
 }
 
+/**
+ * @}
+ */
+
 /**
  * \addtogroup LibrarySetup
  *
@@ -469,6 +506,55 @@ out_free:
  * @{
  */
 
+/**
+ * nfnl_rcvbufsiz - set the socket buffer size
+ * \param h nfnetlink connection handle obtained via call to nfq_nfnlh()
+ * \param size size of the buffer we want to set
+ *
+ * This nfnl-API function sets the new size of the socket buffer.
+ * Use this setting
+ * to increase the socket buffer size if your system is reporting ENOBUFS
+ * errors.
+ *
+ * This code snippet achieves the same result from the mnl API:
+ * \verbatim
+	socklen_t wanted_size;     // Set this to number of bytes you want
+	socklen_t read_size;       // Will be number of bytes you got
+	socklen_t socklen = sizeof wanted_size;
+	struct mnl_socket *nl;     // Returned by mnl_socket_open()
+
+	setsockopt(mnl_socket_get_fd(nl), SOL_SOCKET, SO_RCVBUFFORCE,
+	    &wanted_size, sizeof(socklen_t));
+	getsockopt(mnl_socket_get_fd(nl), SOL_SOCKET, SO_RCVBUF, &read_size,
+	    &socklen);
+\endverbatim
+ *
+ * \return new size of kernel socket buffer
+ */
+
+EXPORT_SYMBOL
+unsigned int nfnl_rcvbufsiz(const struct nfnl_handle *h, unsigned int size)
+{
+	int status;
+	socklen_t socklen = sizeof(size);
+	unsigned int read_size = 0;
+
+	/* first we try the FORCE option, which is introduced in kernel
+	 * 2.6.14 to give "root" the ability to override the system wide
+	 * maximum
+	 */
+	status = setsockopt(h->fd, SOL_SOCKET, SO_RCVBUFFORCE, &size, socklen);
+	if (status < 0) {
+		/* if this didn't work, we try at least to get the system
+		 * wide maximum (or whatever the user requested)
+		 */
+		setsockopt(h->fd, SOL_SOCKET, SO_RCVBUF, &size, socklen);
+	}
+	getsockopt(h->fd, SOL_SOCKET, SO_RCVBUF, &read_size, &socklen);
+
+	return read_size;
+}
+
 /**
  * nfq_close - close a nfqueue handler
  * \param h Netfilter queue connection handle obtained via call to nfq_open()
@@ -480,12 +566,18 @@ out_free:
 EXPORT_SYMBOL
 int nfq_close(struct nfq_handle *h)
 {
-	int ret;
+	struct nfq_q_handle *qh;
 
-	ret = nfnl_close(h->nfnlh);
-	if (ret == 0)
-		free(h);
-	return ret;
+	mnl_socket_close(h->nl);
+
+	while (h->qh_list) {
+		qh = h->qh_list;
+		h->qh_list = qh->next;
+		free(qh);
+	}
+	free(h);
+
+	return 0;
 }
 
 /**
@@ -497,7 +589,7 @@ int nfq_close(struct nfq_handle *h)
  * the given protocol family (ie. PF_INET, PF_INET6, etc).
  * This call is obsolete, Linux kernels from 3.8 onwards ignore it.
  *
- * \return integer inferior to 0 in case of failure
+ * \return -1 on error with errno set, else 0
  */
 EXPORT_SYMBOL
 int nfq_bind_pf(struct nfq_handle *h, uint16_t pf)
@@ -521,7 +613,6 @@ int nfq_unbind_pf(struct nfq_handle *h, uint16_t pf)
 	return __build_send_cfg_msg(h, NFQNL_CFG_CMD_PF_UNBIND, 0, pf);
 }
 
-
 /**
  * @}
  */
@@ -544,7 +635,7 @@ int nfq_unbind_pf(struct nfq_handle *h, uint16_t pf)
  * Creates a new queue handle, and returns it.  The new queue is identified by
  * \b num, and the callback specified by \b cb will be called for each enqueued
  * packet.  The \b data argument will be passed unchanged to the callback.  If
- * a queue entry with id \b num already exists,
+ * a queue entry with queue_num \b num already exists,
  * this function will return failure and the existing entry is unchanged.
  *
  * The nfq_callback type is defined in libnetfilter_queue.h as:
@@ -579,13 +670,12 @@ struct nfq_q_handle *nfq_create_queue(struct nfq_handle *h, uint16_t num,
 
 	memset(qh, 0, sizeof(*qh));
 	qh->h = h;
-	qh->id = num;
+	qh->queue_num = num;
 	qh->cb = cb;
 	qh->data = data;
 
 	ret = __build_send_cfg_msg(h, NFQNL_CFG_CMD_BIND, num, 0);
 	if (ret < 0) {
-		nfq_errno = ret;
 		free(qh);
 		return NULL;
 	}
@@ -598,6 +688,25 @@ struct nfq_q_handle *nfq_create_queue(struct nfq_handle *h, uint16_t num,
  * @}
  */
 
+static int __nfq_handle_msg(const struct nlmsghdr *nlh, void *data)
+{
+	struct nfq_handle *h = data;
+	struct nfq_q_handle *qh;
+	struct nlattr *nfa[NFQA_MAX + 1] = {};
+	struct nfq_data nfad = {nfa};
+	struct nfgenmsg *nfmsg = NLMSG_DATA(nlh);
+
+	if (nfq_nlmsg_parse(nlh, nfa) < 0)
+		return MNL_CB_ERROR;
+
+	/* Find our queue handler (to get CB fn) */
+	qh = find_qh(h, ntohs(nfmsg->res_id));
+	if (!qh)
+		return MNL_CB_ERROR;
+
+	return qh->cb(qh, nfmsg, &nfad, qh->data);
+}
+
 /**
  * \addtogroup Queue
  * @{
@@ -613,7 +722,8 @@ struct nfq_q_handle *nfq_create_queue(struct nfq_handle *h, uint16_t num,
 EXPORT_SYMBOL
 int nfq_destroy_queue(struct nfq_q_handle *qh)
 {
-	int ret = __build_send_cfg_msg(qh->h, NFQNL_CFG_CMD_UNBIND, qh->id, 0);
+	int ret = __build_send_cfg_msg(qh->h, NFQNL_CFG_CMD_UNBIND,
+				       qh->queue_num, 0);
 	if (ret == 0) {
 		del_qh(qh);
 		free(qh);
@@ -632,12 +742,12 @@ int nfq_destroy_queue(struct nfq_q_handle *qh)
  * queue. Packets can be read from the queue using nfq_fd() and recv(). See
  * example code for nfq_fd().
  *
- * \return 0 on success, non-zero on failure.
+ * \return value returned by callback function specified to nfq_create_queue()
  */
 EXPORT_SYMBOL
 int nfq_handle_packet(struct nfq_handle *h, char *buf, int len)
 {
-	return nfnl_handle_packet(h->nfnlh, buf, len);
+	return mnl_cb_run(buf, len, 0, h->portid, __nfq_handle_msg, h);
 }
 
 /**
@@ -658,22 +768,14 @@ int nfq_handle_packet(struct nfq_handle *h, char *buf, int len)
 EXPORT_SYMBOL
 int nfq_set_mode(struct nfq_q_handle *qh, uint8_t mode, uint32_t range)
 {
-	union {
-		char buf[NFNL_HEADER_LEN
-			+NFA_LENGTH(sizeof(struct nfqnl_msg_config_params))];
-		struct nlmsghdr nmh;
-	} u;
-	struct nfqnl_msg_config_params params;
-
-	nfnl_fill_hdr(qh->h->nfnlssh, &u.nmh, 0, AF_UNSPEC, qh->id,
-			NFQNL_MSG_CONFIG, NLM_F_REQUEST|NLM_F_ACK);
-
-	params.copy_range = htonl(range);
-	params.copy_mode = mode;
-	nfnl_addattr_l(&u.nmh, sizeof(u), NFQA_CFG_PARAMS, &params,
-			sizeof(params));
-
-	return nfnl_query(qh->h->nfnlh, &u.nmh);
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+
+	nlh = nfq_nlmsg_put2(buf, NFQNL_MSG_CONFIG, qh->queue_num, NLM_F_ACK);
+
+	nfq_nlmsg_cfg_put_params(nlh, mode, range);
+
+	return nfq_query(qh->h, nlh, buf, sizeof(buf));
 }
 
 /**
@@ -707,6 +809,9 @@ int nfq_set_mode(struct nfq_q_handle *qh, uint8_t mode, uint32_t range)
  *   If your application validates checksums (e.g., tcp checksum),
  *   then you must also check if the NFQA_SKB_INFO attribute is present.
  *   If it is, you need to test the NFQA_SKB_CSUMNOTREADY bit:
+ *
+ * FIXME the code below is for the mnl API
+ *       but nfq_set_queue_flags is part of the nfnl API
  * \verbatim
 	if (attr[NFQA_SKB_INFO]) {
 		uint32_t info = ntohl(mnl_attr_get_u32(attr[NFQA_SKB_INFO]));
@@ -742,28 +847,23 @@ int nfq_set_mode(struct nfq_q_handle *qh, uint8_t mode, uint32_t range)
  *  dumps UID/GID and security context fields only for one fragment. To deal
  *  with this limitation always set NFQA_CFG_F_GSO.
  *
- * \return -1 on error with errno set appropriately; =0 otherwise.
+ * \return -1 on error with errno set, else 0
  */
 EXPORT_SYMBOL
 int nfq_set_queue_flags(struct nfq_q_handle *qh, uint32_t mask, uint32_t flags)
 {
-	union {
-		char buf[NFNL_HEADER_LEN
-			+NFA_LENGTH(sizeof(mask)
-			+NFA_LENGTH(sizeof(flags)))];
-		struct nlmsghdr nmh;
-	} u;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
 
 	mask = htonl(mask);
 	flags = htonl(flags);
 
-	nfnl_fill_hdr(qh->h->nfnlssh, &u.nmh, 0, AF_UNSPEC, qh->id,
-		      NFQNL_MSG_CONFIG, NLM_F_REQUEST|NLM_F_ACK);
+	nlh = nfq_nlmsg_put2(buf, NFQNL_MSG_CONFIG, qh->queue_num, NLM_F_ACK);
 
-	nfnl_addattr32(&u.nmh, sizeof(u), NFQA_CFG_FLAGS, flags);
-	nfnl_addattr32(&u.nmh, sizeof(u), NFQA_CFG_MASK, mask);
+	mnl_attr_put_u32(nlh, NFQA_CFG_FLAGS, flags);
+	mnl_attr_put_u32(nlh, NFQA_CFG_MASK, mask);
 
-	return nfnl_query(qh->h->nfnlh, &u.nmh);
+	return nfq_query(qh->h, nlh, buf, sizeof(buf));
 }
 
 /**
@@ -775,25 +875,24 @@ int nfq_set_queue_flags(struct nfq_q_handle *qh, uint32_t mask, uint32_t flags)
  * of packets the kernel will store before internally before dropping
  * upcoming packets.
  *
+ * \note
+ * The kernel already sets this to several times the maximum that other parts
+ * of the system can implement.
+ * For experimenters, setting it to a low value does work.
+ *
  * \return -1 on error; >=0 otherwise.
  */
 EXPORT_SYMBOL
 int nfq_set_queue_maxlen(struct nfq_q_handle *qh, uint32_t queuelen)
 {
-	union {
-		char buf[NFNL_HEADER_LEN
-			+NFA_LENGTH(sizeof(struct nfqnl_msg_config_params))];
-		struct nlmsghdr nmh;
-	} u;
-	uint32_t queue_maxlen = htonl(queuelen);
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
 
-	nfnl_fill_hdr(qh->h->nfnlssh, &u.nmh, 0, AF_UNSPEC, qh->id,
-			NFQNL_MSG_CONFIG, NLM_F_REQUEST|NLM_F_ACK);
+	nlh = nfq_nlmsg_put2(buf, NFQNL_MSG_CONFIG, qh->queue_num, NLM_F_ACK);
 
-	nfnl_addattr_l(&u.nmh, sizeof(u), NFQA_CFG_QUEUE_MAXLEN, &queue_maxlen,
-			sizeof(queue_maxlen));
+	mnl_attr_put_u32(nlh, NFQA_CFG_QUEUE_MAXLEN, htonl(queuelen));
 
-	return nfnl_query(qh->h->nfnlh, &u.nmh);
+	return nfq_query(qh->h, nlh, buf, sizeof(buf));
 }
 
 /**
@@ -805,52 +904,55 @@ static int __set_verdict(struct nfq_q_handle *qh, uint32_t id,
 		uint32_t data_len, const unsigned char *data,
 		enum nfqnl_msg_types type)
 {
-	struct nfqnl_msg_verdict_hdr vh;
-	union {
-		char buf[NFNL_HEADER_LEN
-			+NFA_LENGTH(sizeof(mark))
-			+NFA_LENGTH(sizeof(vh))];
-		struct nlmsghdr nmh;
-	} u;
-
-	struct iovec iov[3];
-	int nvecs;
-
-	/* This must be declared here (and not inside the data
-	 * handling block) because the iovec points to this. */
-	struct nfattr data_attr;
-
-	memset(iov, 0, sizeof(iov));
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+	static struct sockaddr_nl snl = {.nl_family = AF_NETLINK };
 
-	vh.verdict = htonl(verdict);
-	vh.id = htonl(id);
-
-	nfnl_fill_hdr(qh->h->nfnlssh, &u.nmh, 0, AF_UNSPEC, qh->id,
-				type, NLM_F_REQUEST);
+	nlh = nfq_nlmsg_put(buf, type, qh->queue_num);
 
 	/* add verdict header */
-	nfnl_addattr_l(&u.nmh, sizeof(u), NFQA_VERDICT_HDR, &vh, sizeof(vh));
+	nfq_nlmsg_verdict_put(nlh, id, verdict);
 
 	if (set_mark)
-		nfnl_addattr32(&u.nmh, sizeof(u), NFQA_MARK, mark);
-
-	iov[0].iov_base = &u.nmh;
-	iov[0].iov_len = NLMSG_TAIL(&u.nmh) - (void *)&u.nmh;
-	nvecs = 1;
-
-	if (data_len) {
+		nfq_nlmsg_verdict_put_mark(nlh, mark);
+
+	/* Efficiency gain: when there is only 1 iov,
+	 * sendto() is faster than sendmsg() because the kernel only has
+	 * 1 userspace address to validate instead of 2.
+	 */
+	if (!data_len)
+		return mnl_socket_sendto(qh->h->nl, nlh, nlh->nlmsg_len);
+	else {
+		struct iovec iov[2];
+		struct nlattr *data_attr = mnl_nlmsg_get_payload_tail(nlh);
+		const struct msghdr msg = {
+			.msg_name = &snl,
+			.msg_namelen = sizeof snl,
+			.msg_iov = iov,
+			.msg_iovlen = 2,
+			.msg_control = NULL,
+			.msg_controllen = 0,
+			.msg_flags = 0,
+		};
+
+		mnl_attr_put(nlh, NFQA_PAYLOAD, 0, NULL);
+
+		iov[0].iov_base = nlh;
+		iov[0].iov_len = nlh->nlmsg_len;
 		/* The typecast here is to cast away data's const-ness: */
-		nfnl_build_nfa_iovec(&iov[1], &data_attr, NFQA_PAYLOAD,
-				data_len, (unsigned char *) data);
-		nvecs += 2;
+		iov[1].iov_base = (unsigned char *)data;
+		iov[1].iov_len = data_len;
+
 		/* Add the length of the appended data to the message
-		 * header.  The size of the attribute is given in the
-		 * nfa_len field and is set in the nfnl_build_nfa_iovec()
-		 * function. */
-		u.nmh.nlmsg_len += data_attr.nfa_len;
-	}
+		 * header and attribute length.
+		 * No padding is needed: this is the end of the message. */
+
+		nlh->nlmsg_len += data_len;
 
-	return nfnl_sendiov(qh->h->nfnlh, iov, nvecs, 0);
+		data_attr->nla_len += data_len;
+
+		return sendmsg(qh->h->nfnlh->fd, &msg, 0);
+	}
 }
 
 /**
@@ -904,7 +1006,7 @@ int nfq_set_verdict2(struct nfq_q_handle *qh, uint32_t id,
 		     uint32_t verdict, uint32_t mark,
 		     uint32_t data_len, const unsigned char *buf)
 {
-	return __set_verdict(qh, id, verdict, htonl(mark), 1, data_len,
+	return __set_verdict(qh, id, verdict, mark, 1, data_len,
 						buf, NFQNL_MSG_VERDICT);
 }
 
@@ -939,7 +1041,7 @@ EXPORT_SYMBOL
 int nfq_set_verdict_batch2(struct nfq_q_handle *qh, uint32_t id,
 			   uint32_t verdict, uint32_t mark)
 {
-	return __set_verdict(qh, id, verdict, htonl(mark), 1, 0,
+	return __set_verdict(qh, id, verdict, mark, 1, 0,
 				NULL, NFQNL_MSG_VERDICT_BATCH);
 }
 
@@ -962,7 +1064,7 @@ int nfq_set_verdict_mark(struct nfq_q_handle *qh, uint32_t id,
 			 uint32_t verdict, uint32_t mark,
 			 uint32_t data_len, const unsigned char *buf)
 {
-	return __set_verdict(qh, id, verdict, mark, 1, data_len, buf,
+	return __set_verdict(qh, id, verdict, ntohl(mark), 1, data_len, buf,
 						NFQNL_MSG_VERDICT);
 }
 
@@ -977,7 +1079,11 @@ int nfq_set_verdict_mark(struct nfq_q_handle *qh, uint32_t id,
  *************************************************************/
 
 /**
- * \defgroup Parsing Message parsing functions [DEPRECATED]
+ * \defgroup Parsing Message parsing functions [nfnl API]
+ *
+ * \warning
+ * This page describes functions from the old nfnl API.
+ * Consider using the mnl API for new projects.
  *
  * \manonly
 .SH SYNOPSIS
@@ -997,8 +1103,9 @@ int nfq_set_verdict_mark(struct nfq_q_handle *qh, uint32_t id,
  * \return the netfilter queue netlink packet header for the given
  * nfq_data argument.  Typically, the nfq_data value is passed as the 3rd
  * parameter to the callback function set by a call to nfq_create_queue().
-  *
- * The nfqnl_msg_packet_hdr structure is defined in libnetfilter_queue.h as:
+ *
+ * The nfqnl_msg_packet_hdr structure is defined in
+ * linux/netfilter/nfnetlink_queue.h as:
  *
  * \verbatim
 	struct nfqnl_msg_packet_hdr {
@@ -1011,8 +1118,10 @@ int nfq_set_verdict_mark(struct nfq_q_handle *qh, uint32_t id,
 EXPORT_SYMBOL
 struct nfqnl_msg_packet_hdr *nfq_get_msg_packet_hdr(struct nfq_data *nfad)
 {
-	return nfnl_get_pointer_to_data(nfad->data, NFQA_PACKET_HDR,
-					struct nfqnl_msg_packet_hdr);
+	if (!nfad->data[NFQA_PACKET_HDR])
+		return NULL;
+
+	return mnl_attr_get_payload(nfad->data[NFQA_PACKET_HDR]);
 }
 
 /**
@@ -1024,7 +1133,10 @@ struct nfqnl_msg_packet_hdr *nfq_get_msg_packet_hdr(struct nfq_data *nfad)
 EXPORT_SYMBOL
 uint32_t nfq_get_nfmark(struct nfq_data *nfad)
 {
-	return ntohl(nfnl_get_data(nfad->data, NFQA_MARK, uint32_t));
+	if (!nfad->data[NFQA_MARK])
+		return 0;
+
+	return ntohl(mnl_attr_get_u32(nfad->data[NFQA_MARK]));
 }
 
 /**
@@ -1040,11 +1152,12 @@ EXPORT_SYMBOL
 int nfq_get_timestamp(struct nfq_data *nfad, struct timeval *tv)
 {
 	struct nfqnl_msg_packet_timestamp *qpt;
-	qpt = nfnl_get_pointer_to_data(nfad->data, NFQA_TIMESTAMP,
-					struct nfqnl_msg_packet_timestamp);
-	if (!qpt)
+
+	if (!nfad->data[NFQA_TIMESTAMP])
 		return -1;
 
+	qpt = mnl_attr_get_payload(nfad->data[NFQA_TIMESTAMP]);
+
 	tv->tv_sec = __be64_to_cpu(qpt->sec);
 	tv->tv_usec = __be64_to_cpu(qpt->usec);
 
@@ -1065,7 +1178,10 @@ int nfq_get_timestamp(struct nfq_data *nfad, struct timeval *tv)
 EXPORT_SYMBOL
 uint32_t nfq_get_indev(struct nfq_data *nfad)
 {
-	return ntohl(nfnl_get_data(nfad->data, NFQA_IFINDEX_INDEV, uint32_t));
+	if (!nfad->data[NFQA_IFINDEX_INDEV])
+		return 0;
+
+	return ntohl(mnl_attr_get_u32(nfad->data[NFQA_IFINDEX_INDEV]));
 }
 
 /**
@@ -1079,7 +1195,10 @@ uint32_t nfq_get_indev(struct nfq_data *nfad)
 EXPORT_SYMBOL
 uint32_t nfq_get_physindev(struct nfq_data *nfad)
 {
-	return ntohl(nfnl_get_data(nfad->data, NFQA_IFINDEX_PHYSINDEV, uint32_t));
+	if (!nfad->data[NFQA_IFINDEX_PHYSINDEV])
+		return 0;
+
+	return ntohl(mnl_attr_get_u32(nfad->data[NFQA_IFINDEX_PHYSINDEV]));
 }
 
 /**
@@ -1093,7 +1212,10 @@ uint32_t nfq_get_physindev(struct nfq_data *nfad)
 EXPORT_SYMBOL
 uint32_t nfq_get_outdev(struct nfq_data *nfad)
 {
-	return ntohl(nfnl_get_data(nfad->data, NFQA_IFINDEX_OUTDEV, uint32_t));
+	if (!nfad->data[NFQA_IFINDEX_OUTDEV])
+		return 0;
+
+	return ntohl(mnl_attr_get_u32(nfad->data[NFQA_IFINDEX_OUTDEV]));
 }
 
 /**
@@ -1104,51 +1226,28 @@ uint32_t nfq_get_outdev(struct nfq_data *nfad)
  * If the returned index is 0, the packet is destined for localhost or the
  * physical output interface is not yet known (ie. PREROUTING?).
  *
- * \return The index of physical interface that the packet output will be routed out.
+ * \return The index of physical interface that the packet output will be
+ *         routed to.
  */
 EXPORT_SYMBOL
 uint32_t nfq_get_physoutdev(struct nfq_data *nfad)
 {
-	return ntohl(nfnl_get_data(nfad->data, NFQA_IFINDEX_PHYSOUTDEV, uint32_t));
+	if (!nfad->data[NFQA_IFINDEX_PHYSOUTDEV])
+		return 0;
+
+	return ntohl(mnl_attr_get_u32(nfad->data[NFQA_IFINDEX_PHYSOUTDEV]));
 }
 
 /**
  * nfq_get_indev_name - get the name of the interface the packet
  * was received through
- * \param nlif_handle pointer to a nlif interface resolving handle
+ * \param nlif_handle pointer to an nlif interface resolving handle
  * \param nfad Netlink packet data handle passed to callback function
  * \param name pointer to the buffer to receive the interface name;
  *  not more than \c IFNAMSIZ bytes will be copied to it.
- * \return -1 in case of error, >0 if it succeed.
- *
- * To use a nlif_handle, You need first to call nlif_open() and to open
- * an handler. Don't forget to store the result as it will be used
- * during all your program life:
- * \verbatim
-	h = nlif_open();
-	if (h == NULL) {
-		perror("nlif_open");
-		exit(EXIT_FAILURE);
-	}
-\endverbatim
- * Once the handler is open, you need to fetch the interface table at a
- * whole via a call to nlif_query.
- * \verbatim
-	nlif_query(h);
-\endverbatim
- * libnfnetlink is able to update the interface mapping when a new interface
- * appears. To do so, you need to call nlif_catch() on the handler after each
- * interface related event. The simplest way to get and treat event is to run
- * a select() or poll() against the nlif file descriptor. To get this file
- * descriptor, you need to use nlif_fd:
- * \verbatim
-	if_fd = nlif_fd(h);
-\endverbatim
- * Don't forget to close the handler when you don't need the feature anymore:
- * \verbatim
-	nlif_close(h);
-\endverbatim
  *
+ * \return -1 on error, > 0 otherwise.
+ * \sa __nlif_open__(3)
  */
 EXPORT_SYMBOL
 int nfq_get_indev_name(struct nlif_handle *nlif_handle,
@@ -1161,14 +1260,13 @@ int nfq_get_indev_name(struct nlif_handle *nlif_handle,
 /**
  * nfq_get_physindev_name - get the name of the physical interface the
  * packet was received through
- * \param nlif_handle pointer to a nlif interface resolving handle
+ * \param nlif_handle pointer to an nlif interface resolving handle
  * \param nfad Netlink packet data handle passed to callback function
  * \param name pointer to the buffer to receive the interface name;
  *  not more than \c IFNAMSIZ bytes will be copied to it.
  *
- * See nfq_get_indev_name() documentation for nlif_handle usage.
- *
- * \return  -1 in case of error, > 0 if it succeed.
+ * \return -1 on error, > 0 otherwise.
+ * \sa __nlif_open__(3)
  */
 EXPORT_SYMBOL
 int nfq_get_physindev_name(struct nlif_handle *nlif_handle,
@@ -1181,14 +1279,13 @@ int nfq_get_physindev_name(struct nlif_handle *nlif_handle,
 /**
  * nfq_get_outdev_name - get the name of the physical interface the
  * packet will be sent to
- * \param nlif_handle pointer to a nlif interface resolving handle
+ * \param nlif_handle pointer to an nlif interface resolving handle
  * \param nfad Netlink packet data handle passed to callback function
  * \param name pointer to the buffer to receive the interface name;
  *  not more than \c IFNAMSIZ bytes will be copied to it.
  *
- * See nfq_get_indev_name() documentation for nlif_handle usage.
- *
- * \return  -1 in case of error, > 0 if it succeed.
+ * \return -1 on error, > 0 otherwise.
+ * \sa __nlif_open__(3)
  */
 EXPORT_SYMBOL
 int nfq_get_outdev_name(struct nlif_handle *nlif_handle,
@@ -1201,14 +1298,13 @@ int nfq_get_outdev_name(struct nlif_handle *nlif_handle,
 /**
  * nfq_get_physoutdev_name - get the name of the interface the
  * packet will be sent to
- * \param nlif_handle pointer to a nlif interface resolving handle
+ * \param nlif_handle pointer to an nlif interface resolving handle
  * \param nfad Netlink packet data handle passed to callback function
  * \param name pointer to the buffer to receive the interface name;
  *  not more than \c IFNAMSIZ bytes will be copied to it.
  *
- * See nfq_get_indev_name() documentation for nlif_handle usage.
- *
- * \return  -1 in case of error, > 0 if it succeed.
+ * \return -1 on error, > 0 otherwise.
+ * \sa __nlif_open__(3)
  */
 
 EXPORT_SYMBOL
@@ -1244,8 +1340,10 @@ int nfq_get_physoutdev_name(struct nlif_handle *nlif_handle,
 EXPORT_SYMBOL
 struct nfqnl_msg_packet_hw *nfq_get_packet_hw(struct nfq_data *nfad)
 {
-	return nfnl_get_pointer_to_data(nfad->data, NFQA_HWADDR,
-					struct nfqnl_msg_packet_hw);
+	if (!nfad->data[NFQA_HWADDR])
+		return NULL;
+
+	return mnl_attr_get_payload(nfad->data[NFQA_HWADDR]);
 }
 
 /**
@@ -1273,10 +1371,10 @@ struct nfqnl_msg_packet_hw *nfq_get_packet_hw(struct nfq_data *nfad)
 EXPORT_SYMBOL
 uint32_t nfq_get_skbinfo(struct nfq_data *nfad)
 {
-	if (!nfnl_attr_present(nfad->data, NFQA_SKB_INFO))
+	if (!nfad->data[NFQA_SKB_INFO])
 		return 0;
 
-	return ntohl(nfnl_get_data(nfad->data, NFQA_SKB_INFO, uint32_t));
+	return ntohl(mnl_attr_get_u32(nfad->data[NFQA_SKB_INFO]));
 }
 
 /**
@@ -1293,10 +1391,10 @@ uint32_t nfq_get_skbinfo(struct nfq_data *nfad)
 EXPORT_SYMBOL
 int nfq_get_uid(struct nfq_data *nfad, uint32_t *uid)
 {
-	if (!nfnl_attr_present(nfad->data, NFQA_UID))
+	if (!nfad->data[NFQA_UID])
 		return 0;
 
-	*uid = ntohl(nfnl_get_data(nfad->data, NFQA_UID, uint32_t));
+	*uid = ntohl(mnl_attr_get_u32(nfad->data[NFQA_UID]));
 	return 1;
 }
 
@@ -1314,10 +1412,10 @@ int nfq_get_uid(struct nfq_data *nfad, uint32_t *uid)
 EXPORT_SYMBOL
 int nfq_get_gid(struct nfq_data *nfad, uint32_t *gid)
 {
-	if (!nfnl_attr_present(nfad->data, NFQA_GID))
+	if (!nfad->data[NFQA_GID])
 		return 0;
 
-	*gid = ntohl(nfnl_get_data(nfad->data, NFQA_GID, uint32_t));
+	*gid = ntohl(mnl_attr_get_u32(nfad->data[NFQA_GID]));
 	return 1;
 }
 
@@ -1330,19 +1428,18 @@ int nfq_get_gid(struct nfq_data *nfad, uint32_t *gid)
  * may be pushed into the queue. In this case, only one fragment will have the
  * SECCTX field set. To deal with this issue always set NFQA_CFG_F_GSO.
  *
- * \return -1 on error, otherwise > 0
+ * \return -1 on error, > 0 otherwise.
  */
 EXPORT_SYMBOL
 int nfq_get_secctx(struct nfq_data *nfad, unsigned char **secdata)
 {
-	if (!nfnl_attr_present(nfad->data, NFQA_SECCTX))
+	if (!nfad->data[NFQA_SECCTX])
 		return -1;
 
-	*secdata = (unsigned char *)nfnl_get_pointer_to_data(nfad->data,
-							NFQA_SECCTX, char);
+	*secdata = mnl_attr_get_payload(nfad->data[NFQA_SECCTX]);
 
 	if (*secdata)
-		return NFA_PAYLOAD(nfad->data[NFQA_SECCTX-1]);
+		return mnl_attr_get_payload_len(nfad->data[NFQA_SECCTX]);
 
 	return 0;
 }
@@ -1356,15 +1453,17 @@ int nfq_get_secctx(struct nfq_data *nfad, unsigned char **secdata)
  * data retrieved by this function will depend on the mode set with the
  * nfq_set_mode() function.
  *
- * \return -1 on error, otherwise > 0.
+ * \return -1 on error, > 0 otherwise.
  */
 EXPORT_SYMBOL
 int nfq_get_payload(struct nfq_data *nfad, unsigned char **data)
 {
-	*data = (unsigned char *)
-		nfnl_get_pointer_to_data(nfad->data, NFQA_PAYLOAD, char);
+	if (!nfad->data[NFQA_PAYLOAD])
+		return -1;
+
+	*data = mnl_attr_get_payload(nfad->data[NFQA_PAYLOAD]);
 	if (*data)
-		return NFA_PAYLOAD(nfad->data[NFQA_PAYLOAD-1]);
+		return mnl_attr_get_payload_len(nfad->data[NFQA_PAYLOAD]);
 
 	return -1;
 }
@@ -1385,7 +1484,11 @@ do {								\
 } while (0)
 
 /**
- * \defgroup Printing Printing [DEPRECATED]
+ * \defgroup Printing Printing [nfnl API]
+ *
+ * \warning
+ * This page describes functions from the old nfnl API.
+ * Consider using the mnl API for new projects.
  *
  * \manonly
 .SH SYNOPSIS
@@ -1415,11 +1518,12 @@ do {								\
  *	- NFQ_XML_TIME: include the timestamp
  *	- NFQ_XML_ALL: include all the logging information (all flags set)
  *
- * You can combine this flags with an binary OR.
+ * You can combine these flags with a bitwise OR.
  *
- * \return -1 in case of failure, otherwise the length of the string that
+ * \return -1 on error, otherwise the length of the string that
  * would have been printed into the buffer (in case that there is enough
- * room in it). See snprintf() return value for more information.
+ * room in it).
+ * \sa __snprintf__(3)
  */
 EXPORT_SYMBOL
 int nfq_snprintf_xml(char *buf, size_t rem, struct nfq_data *tb, int flags)
diff --git a/src/nlmsg.c b/src/nlmsg.c
index 39fd12d..4a482b3 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -26,7 +26,7 @@
 #include "internal.h"
 
 /**
- * \defgroup nfq_verd Verdict helpers
+ * \defgroup nfq_verdict Verdict helpers [mnl API]
  *
  * \manonly
 .SH SYNOPSIS
@@ -62,7 +62,7 @@
  * do this test.
  * \n
  * __NF_QUEUE_NR__(*new_queue*) Like __NF_ACCEPT__, but queue this packet to
- * queue number *new_queue*. As with the command-line \b queue \b num verdict,
+ * queue number *new_queue*. As with the command-line <b>QUEUE STATEMENT</b>
  * if no process is listening to that queue then the packet is discarded; but
  * again like with the command-line, one may OR in a flag to bypass *new_queue*
  *  if there is no listener, as in this snippet:
@@ -71,12 +71,10 @@
 	       NF_VERDICT_FLAG_QUEUE_BYPASS);
 \endverbatim
  *
- * See examples/nf-queue.c, line
- * <a class="el" href="nf-queue_8c_source.html#l00046">46</a>
- * for an example of how to use this function in context.
- * The calling sequence is \b main --> \b mnl_cb_run --> \b queue_cb -->
- * \b nfq_send_verdict --> \b nfq_nlmsg_verdict_put
- * (\b cb being short for \b callback).
+ * See
+ * \ref nfq6 "nfq6.c"
+ * for an example of how to use this function in context:
+ * search the code for `tests[5]` (2nd occurrence).
  */
 EXPORT_SYMBOL
 void nfq_nlmsg_verdict_put(struct nlmsghdr *nlh, int id, int verdict)
@@ -114,28 +112,12 @@ EXPORT_SYMBOL
  * There is only ever a need to return packet content if it has been modified.
  * Usually one of the nfq_*_mangle_* functions does the modifying.
  *
- * This code snippet uses nfq_udp_mangle_ipv4. See nf-queue.c for
- * context:
- * \verbatim
-// main calls queue_cb (line 64) to process an enqueued packet:
-	// Extra variables
-	uint8_t *payload, *rep_data;
-	unsigned int match_offset, match_len, rep_len;
-
-	// The next line was commented-out (with payload void*)
-	payload = mnl_attr_get_payload(attr[NFQA_PAYLOAD]);
-	// Copy data to a packet buffer (allow 255 bytes for mangling).
-	pktb = pktb_alloc(AF_INET, payload, plen, 255);
-	// (decide that this packet needs mangling)
-	nfq_udp_mangle_ipv4(pktb, match_offset, match_len, rep_data, rep_len);
-	// nfq_udp_mangle_ipv4 updates packet length, no need to track locally
-
-	// Eventually nfq_send_verdict (line 39) gets called
-	// The received packet may or may not have been modified.
-	// Add this code before nfq_nlmsg_verdict_put call:
-	if (pktb_mangled(pktb))
-		nfq_nlmsg_verdict_put_pkt(nlh, pktb_data(pktb), pktb_len(pktb));
-\endverbatim
+ * \note
+ * nfq_nlmsg_verdict_put_pkt copies the IP datagram to your output buffer.
+ * To avoid this packet copy, you may like to consider using **sendmsg**(2)
+ * much as nfq_set_verdict() does (scroll back to find <b>__set_verdict</b>()
+ * which does the work).
+ *
  */
 void nfq_nlmsg_verdict_put_pkt(struct nlmsghdr *nlh, const void *pkt,
 			       uint32_t plen)
@@ -148,7 +130,7 @@ void nfq_nlmsg_verdict_put_pkt(struct nlmsghdr *nlh, const void *pkt,
  */
 
 /**
- * \defgroup nfq_cfg Config helpers
+ * \defgroup nfq_cfg Config helpers [mnl API}
  *
  * \manonly
 .SH SYNOPSIS
@@ -223,7 +205,7 @@ void nfq_nlmsg_cfg_put_qmaxlen(struct nlmsghdr *nlh, uint32_t queue_maxlen)
  */
 
 /**
- * \defgroup nlmsg Netlink message helper functions
+ * \defgroup nlmsg Netlink message helper functions [mnl API]
  *
  * \manonly
 .SH SYNOPSIS
-- 
2.35.8

