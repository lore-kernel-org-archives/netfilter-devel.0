Return-Path: <SRS0=danl=U6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D34CCC0650E
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Jul 2019 10:53:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97FD0205F4
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Jul 2019 10:53:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727925AbfGAKxd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 1 Jul 2019 06:53:33 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44330 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727748AbfGAKxd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 Jul 2019 06:53:33 -0400
Received: by mail-wr1-f65.google.com with SMTP id e3so3752224wrs.11
        for <netfilter-devel@vger.kernel.org>; Mon, 01 Jul 2019 03:53:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=giPXmPw9UvxPk+g2z3ltuuQp6l3XDWoc8BxT/JXopuU=;
        b=FILfzzEiuXwwiP7eGH4Kzi31uNjlXqyYzyx9mBhlZrqyXUujgR+dG6NuRsYlKA1KN5
         V00VSdfQocJLawXgKz4HZ4XA8NcqgqCh4myPYN8wrFNfYrVss0qw3mfZag5kbsiYhkP6
         gXCkiibVAc7dNLBn4f/PEoKPZprWNLsfRbbiDcNK88b9hECAyd5pcJ+mbbY02MnkX6Jh
         gckOU7LW+AaFuCGzIdyXu+4DOAdII6N4xzkXc8clrg8yC49dPEQi00cYS4togf/4FFAE
         iWPdTt16FJl91gnpzAwmXdmhSqqM8W4mNMDuhM4BfZxf+Ag2GKZSTVNtvI41gmOjGU7G
         9+mw==
X-Gm-Message-State: APjAAAXcrBM5GSnyiWQuj+KGOMyLFc49dD1V0fOEQuVBibYhzUIUmFq+
        7171ftKJqDt9JA4fAJUh/4vq86bq/Uw=
X-Google-Smtp-Source: APXvYqzDJdCtzukHJqFOAaXJQzRFSWZtHHHlrNMBbtpUaOLUSt8ha03BUzlLZvIBQWgP7G1XXz0EPA==
X-Received: by 2002:adf:82a8:: with SMTP id 37mr8417526wrc.332.1561978409659;
        Mon, 01 Jul 2019 03:53:29 -0700 (PDT)
Received: from localhost (static.137.137.194.213.ibercom.com. [213.194.137.137])
        by smtp.gmail.com with ESMTPSA id a81sm9739221wmh.3.2019.07.01.03.53.28
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 01 Jul 2019 03:53:29 -0700 (PDT)
Subject: [nft PATCH v2 3/3] libnftables: export public symbols only
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Date:   Mon, 01 Jul 2019 12:53:28 +0200
Message-ID: <156197840229.14440.6449813194254743291.stgit@endurance>
In-Reply-To: <156197834773.14440.15033673835278456059.stgit@endurance>
References: <156197834773.14440.15033673835278456059.stgit@endurance>
User-Agent: StGit/0.18
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Export public symbols (the library API functions) instead of all symbols in
the library.

This patch introduces the required macros to manage the visibility attributes
(mostly copied from libnftnl.git) and also marks each symbol as exported when
they need to be public. Also, introduce a .map file for proper symbol
versioning.

Previous to this patch, libnftables public symbols were:

% dpkg-gensymbols -q -plibnftables -v0.9.1 -O -esrc/.libs/libnftables.so.1 | wc -l
527

With this patch, libnftables symbols are:

% dpkg-gensymbols -q -plibnftables -v0.9.1 -O -esrc/.libs/libnftables.so.1
libnftables.so.1 libnftables #MINVER#
 nft_ctx_add_include_path@Base 0.9.1
 nft_ctx_buffer_error@Base 0.9.1
 nft_ctx_buffer_output@Base 0.9.1
 nft_ctx_clear_include_paths@Base 0.9.1
 nft_ctx_free@Base 0.9.1
 nft_ctx_get_dry_run@Base 0.9.1
 nft_ctx_get_error_buffer@Base 0.9.1
 nft_ctx_get_output_buffer@Base 0.9.1
 nft_ctx_new@Base 0.9.1
 nft_ctx_output_get_debug@Base 0.9.1
 nft_ctx_output_get_flags@Base 0.9.1
 nft_ctx_output_set_debug@Base 0.9.1
 nft_ctx_output_set_flags@Base 0.9.1
 nft_ctx_set_dry_run@Base 0.9.1
 nft_ctx_set_error@Base 0.9.1
 nft_ctx_set_output@Base 0.9.1
 nft_ctx_unbuffer_error@Base 0.9.1
 nft_ctx_unbuffer_output@Base 0.9.1
 nft_run_cmd_from_buffer@Base 0.9.1
 nft_run_cmd_from_filename@Base 0.9.1

Signed-off-by: Arturo Borrero Gonzalez <arturo@netfilter.org>
---
v2: rebased

 configure.ac          |    5 +++++
 include/utils.h       |    8 ++++++++
 m4/gcc4_visibility.m4 |   21 +++++++++++++++++++++
 src/Makefile.am       |    8 +++++---
 src/libnftables.c     |   20 ++++++++++++++++++++
 src/libnftables.map   |   25 +++++++++++++++++++++++++
 6 files changed, 84 insertions(+), 3 deletions(-)
 create mode 100644 m4/gcc4_visibility.m4
 create mode 100644 src/libnftables.map

diff --git a/configure.ac b/configure.ac
index b71268e..26a9cb7 100644
--- a/configure.ac
+++ b/configure.ac
@@ -44,6 +44,11 @@ fi
 
 AM_PROG_AR
 AM_PROG_LIBTOOL
+LT_INIT
+AM_PROG_CC_C_O
+AC_EXEEXT
+AC_DISABLE_STATIC
+CHECK_GCC_FVISIBILITY
 
 AS_IF([test "x$enable_man_doc" = "xyes"], [
        AC_CHECK_PROG(A2X, [a2x], [a2x], [no])
diff --git a/include/utils.h b/include/utils.h
index e791523..647e8bb 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -11,6 +11,14 @@
 #include <list.h>
 #include <gmputil.h>
 
+#include "config.h"
+#ifdef HAVE_VISIBILITY_HIDDEN
+#       define __visible        __attribute__((visibility("default")))
+#       define EXPORT_SYMBOL(x) typeof(x) (x) __visible;
+#else
+#       define EXPORT_SYMBOL
+#endif
+
 #define BITS_PER_BYTE	8
 
 #define pr_debug(fmt, arg...) printf(fmt, ##arg)
diff --git a/m4/gcc4_visibility.m4 b/m4/gcc4_visibility.m4
new file mode 100644
index 0000000..214d3f3
--- /dev/null
+++ b/m4/gcc4_visibility.m4
@@ -0,0 +1,21 @@
+
+# GCC 4.x -fvisibility=hidden
+
+AC_DEFUN([CHECK_GCC_FVISIBILITY], [
+	AC_LANG_PUSH([C])
+	saved_CFLAGS="$CFLAGS"
+	CFLAGS="$saved_CFLAGS -fvisibility=hidden"
+	AC_CACHE_CHECK([whether compiler accepts -fvisibility=hidden],
+	  [ac_cv_fvisibility_hidden], AC_COMPILE_IFELSE(
+		[AC_LANG_SOURCE()],
+		[ac_cv_fvisibility_hidden=yes],
+		[ac_cv_fvisibility_hidden=no]
+	))
+	if test "$ac_cv_fvisibility_hidden" = "yes"; then
+		AC_DEFINE([HAVE_VISIBILITY_HIDDEN], [1],
+			[True if compiler supports -fvisibility=hidden])
+		AC_SUBST([GCC_FVISIBILITY_HIDDEN], [-fvisibility=hidden])
+	fi
+	CFLAGS="$saved_CFLAGS"
+	AC_LANG_POP([C])
+])
diff --git a/src/Makefile.am b/src/Makefile.am
index a1c18fe..9ad7e1f 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -19,7 +19,7 @@ AM_CFLAGS = -Wall								\
 	    -Wdeclaration-after-statement -Wsign-compare -Winit-self		\
 	    -Wformat-nonliteral -Wformat-security -Wmissing-format-attribute	\
 	    -Wcast-align -Wundef -Wbad-function-cast				\
-	    -Waggregate-return -Wunused -Wwrite-strings
+	    -Waggregate-return -Wunused -Wwrite-strings ${GCC_FVISIBILITY_HIDDEN}
 
 
 AM_YFLAGS = -d
@@ -63,7 +63,8 @@ libnftables_la_SOURCES =			\
 		tcpopt.c			\
 		socket.c			\
 		print.c				\
-		libnftables.c
+		libnftables.c			\
+		libnftables.map
 
 # yacc and lex generate dirty code
 noinst_LTLIBRARIES = libparser.la
@@ -77,7 +78,8 @@ libparser_la_CFLAGS = ${AM_CFLAGS} \
 		      -Wno-redundant-decls
 
 libnftables_la_LIBADD = ${LIBMNL_LIBS} ${LIBNFTNL_LIBS} libparser.la
-libnftables_la_LDFLAGS = -version-info ${libnftables_LIBVERSION}
+libnftables_la_LDFLAGS = -version-info ${libnftables_LIBVERSION} \
+			 --version-script=$(srcdir)/libnftables.map
 
 if BUILD_MINIGMP
 noinst_LTLIBRARIES += libminigmp.la
diff --git a/src/libnftables.c b/src/libnftables.c
index f2cd267..2f77a77 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -109,6 +109,7 @@ static void nft_exit(void)
 	mark_table_exit();
 }
 
+EXPORT_SYMBOL(nft_ctx_add_include_path);
 int nft_ctx_add_include_path(struct nft_ctx *ctx, const char *path)
 {
 	char **tmp;
@@ -127,6 +128,7 @@ int nft_ctx_add_include_path(struct nft_ctx *ctx, const char *path)
 	return 0;
 }
 
+EXPORT_SYMBOL(nft_ctx_clear_include_paths);
 void nft_ctx_clear_include_paths(struct nft_ctx *ctx)
 {
 	while (ctx->num_include_paths)
@@ -141,6 +143,7 @@ static void nft_ctx_netlink_init(struct nft_ctx *ctx)
 	ctx->nf_sock = nft_mnl_socket_open();
 }
 
+EXPORT_SYMBOL(nft_ctx_new);
 struct nft_ctx *nft_ctx_new(uint32_t flags)
 {
 	struct nft_ctx *ctx;
@@ -226,21 +229,25 @@ static int exit_cookie(struct cookie *cookie)
 	return 0;
 }
 
+EXPORT_SYMBOL(nft_ctx_buffer_output);
 int nft_ctx_buffer_output(struct nft_ctx *ctx)
 {
 	return init_cookie(&ctx->output.output_cookie);
 }
 
+EXPORT_SYMBOL(nft_ctx_unbuffer_output);
 int nft_ctx_unbuffer_output(struct nft_ctx *ctx)
 {
 	return exit_cookie(&ctx->output.output_cookie);
 }
 
+EXPORT_SYMBOL(nft_ctx_buffer_error);
 int nft_ctx_buffer_error(struct nft_ctx *ctx)
 {
 	return init_cookie(&ctx->output.error_cookie);
 }
 
+EXPORT_SYMBOL(nft_ctx_unbuffer_error);
 int nft_ctx_unbuffer_error(struct nft_ctx *ctx)
 {
 	return exit_cookie(&ctx->output.error_cookie);
@@ -262,16 +269,19 @@ static const char *get_cookie_buffer(struct cookie *cookie)
 	return cookie->buf;
 }
 
+EXPORT_SYMBOL(nft_ctx_get_output_buffer);
 const char *nft_ctx_get_output_buffer(struct nft_ctx *ctx)
 {
 	return get_cookie_buffer(&ctx->output.output_cookie);
 }
 
+EXPORT_SYMBOL(nft_ctx_get_error_buffer);
 const char *nft_ctx_get_error_buffer(struct nft_ctx *ctx)
 {
 	return get_cookie_buffer(&ctx->output.error_cookie);
 }
 
+EXPORT_SYMBOL(nft_ctx_free);
 void nft_ctx_free(struct nft_ctx *ctx)
 {
 	if (ctx->nf_sock)
@@ -287,6 +297,7 @@ void nft_ctx_free(struct nft_ctx *ctx)
 	nft_exit();
 }
 
+EXPORT_SYMBOL(nft_ctx_set_output);
 FILE *nft_ctx_set_output(struct nft_ctx *ctx, FILE *fp)
 {
 	FILE *old = ctx->output.output_fp;
@@ -299,6 +310,7 @@ FILE *nft_ctx_set_output(struct nft_ctx *ctx, FILE *fp)
 	return old;
 }
 
+EXPORT_SYMBOL(nft_ctx_set_error);
 FILE *nft_ctx_set_error(struct nft_ctx *ctx, FILE *fp)
 {
 	FILE *old = ctx->output.error_fp;
@@ -311,30 +323,36 @@ FILE *nft_ctx_set_error(struct nft_ctx *ctx, FILE *fp)
 	return old;
 }
 
+EXPORT_SYMBOL(nft_ctx_get_dry_run);
 bool nft_ctx_get_dry_run(struct nft_ctx *ctx)
 {
 	return ctx->check;
 }
 
+EXPORT_SYMBOL(nft_ctx_set_dry_run);
 void nft_ctx_set_dry_run(struct nft_ctx *ctx, bool dry)
 {
 	ctx->check = dry;
 }
 
+EXPORT_SYMBOL(nft_ctx_output_get_flags);
 unsigned int nft_ctx_output_get_flags(struct nft_ctx *ctx)
 {
 	return ctx->output.flags;
 }
 
+EXPORT_SYMBOL(nft_ctx_output_set_flags);
 void nft_ctx_output_set_flags(struct nft_ctx *ctx, unsigned int flags)
 {
 	ctx->output.flags = flags;
 }
 
+EXPORT_SYMBOL(nft_ctx_output_get_debug);
 unsigned int nft_ctx_output_get_debug(struct nft_ctx *ctx)
 {
 	return ctx->debug_mask;
 }
+EXPORT_SYMBOL(nft_ctx_output_set_debug);
 void nft_ctx_output_set_debug(struct nft_ctx *ctx, unsigned int mask)
 {
 	ctx->debug_mask = mask;
@@ -407,6 +425,7 @@ static int nft_evaluate(struct nft_ctx *nft, struct list_head *msgs,
 	return 0;
 }
 
+EXPORT_SYMBOL(nft_run_cmd_from_buffer);
 int nft_run_cmd_from_buffer(struct nft_ctx *nft, const char *buf)
 {
 	int rc = -EINVAL, parser_rc;
@@ -458,6 +477,7 @@ err:
 	return rc;
 }
 
+EXPORT_SYMBOL(nft_run_cmd_from_filename);
 int nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename)
 {
 	struct cmd *cmd, *next;
diff --git a/src/libnftables.map b/src/libnftables.map
new file mode 100644
index 0000000..955af38
--- /dev/null
+++ b/src/libnftables.map
@@ -0,0 +1,25 @@
+LIBNFTABLES_1 {
+global:
+  nft_ctx_add_include_path;
+  nft_ctx_clear_include_pat;
+  nft_ctx_new;
+  nft_ctx_buffer_output;
+  nft_ctx_unbuffer_output;
+  nft_ctx_buffer_error;
+  nft_ctx_unbuffer_error;
+  nft_ctx_get_output_buffer;
+  nft_ctx_get_error_buffer;
+  nft_ctx_free;
+  nft_ctx_set_output;
+  nft_ctx_set_error;
+  nft_ctx_get_dry_run;
+  nft_ctx_set_dry_run;
+  nft_ctx_output_get_flags;
+  nft_ctx_output_set_flags;
+  nft_ctx_output_get_debug;
+  nft_ctx_output_set_debug;
+  nft_run_cmd_from_buffer;
+  nft_run_cmd_from_filename;
+
+local: *;
+};

