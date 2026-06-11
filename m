Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11C33FADE8
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Jun 2026 12:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781182368; cv=none; b=Gb1NRVmWlO3A6RXf5VacymRhqJPwUKDXi3mKTvF8iXFfEMrpUP5uoaYyMAHdsOr4Xe5cnSCWwLfhRBmsddZoM6Qg70DyfhGS0yU/amvafY4N3bXLxtEMHl+b0Yzm8mOtMM631FAMGiIWzpfnfzJgOsbUrM+uHhVTI/2KBOC0i7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781182368; c=relaxed/simple;
	bh=Z37qsdv2WyQH6GcN8O/Fa02ehOoHe4R5BobAUariaO8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=oh2BFvM9UdKyGIEVFCVpOrsqErSE4tsMkfcPjewGxFR5KAj+QRBG++2vrVMZiZLYuzEmGN2rl2l9OvVCzHcouK3hwXTeCvRVu56c5fZkPcigbGIl4WS9v4wtaEiwrGOcMnMVl/EWPAX+A9EzXGPWzhPIRkMBsHIPMU9hGE1tFxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Y8m25QsI; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Y8m25QsI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=w+Y8I4x4fqYccUG8d2yCrs2xKhtDx6YwnbSx544IBCw=; b=Y8m25QsIeyJHBUKOb4Uzrw1Td3
	JVgO/vl/aO1nW8GT3bUmRD5nxbBTOqBRLLTBVM25K6LfgXAfW0GYBYr/q8SmXPGkLLmjqrSD9rwA2
	1JBPd/pPqmXpNdJT/n58ArKVSjHgNefSBzNs95wiG/SzMYqBHqN/e/jG7H3ZODVwqCLXCrliCiI+Y
	t8mUaSpZ39+Ff08gM9bOXKjDG18dtREM97UOxCdQA1oeBNqsMtXG8uISoZWiUREm0cINkGk/dPEPe
	2YPlhBbTQlBSgr8Ctjc99qI+aZgRDUsqyv70s8VBU+t/OPreEf4E6ATBxew7++C95J5XznsKpV1dZ
	uBtxBgdQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wXeth-000000002qL-04cH;
	Thu, 11 Jun 2026 14:52:37 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	=?UTF-8?q?Jan=20Ko=C5=84czak?= <jan.konczak@cs.put.poznan.pl>
Subject: [nft PATCH v2] parser_bison: Fix for bison < 3.6
Date: Thu, 11 Jun 2026 14:52:25 +0200
Message-ID: <20260611125231.652353-1-phil@nwl.cc>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Support for 'custom' parse.error value was added in bison-3.6. Fall back
to previous value for earlier versions.

This is harder to get right than it seems: On one hand, preprocessor
macros can't be used in parser_bison.y's declaration section and
automake forbids conditional changes to AM_YFLAGS on the other.

Another aspect complicating things is compiling with (an up to date)
parser_bison.c in place vs. without: Dist tarballs generally have it in
place, relieving users from having to provide a YACC when compiling. The
existing parser_bison.c either uses parse.error=custom or not which does
not (should not) change when compiling. Hiding yyreport_syntax_error()
behind a CPPFLAG which may be set or not depending on bison presence and
version then causes trouble if it doesn't match how parser_bison.c was
created.

Avoid these pitfalls by:
- Not relying upon a preprocessor define to control parser_bison.c
  compilation, instead check existence of the bison-internal
  YY_LAC_ESTABLISH macro
- Exporting the above macro existence check in a variable for use by
  main.c (thereby crossing the libnftables library boundary)

Also:
- Introduce have_prebuilt_bison variable in configure.ac, unifying the
  parser_bison.c existence check and solidify the latter by also
  comparing its timestamp
- Report extended parser errors enableval in configure only if
  parser_bison.c will be recreated, otherwise we can't quite tell if it
  will turn out to be enabled or not

Suggested-by: Jan Kończak <jan.konczak@cs.put.poznan.pl>
Fixes: 67b822f2b2624 ("parser_bison: on syntax errors, output expected tokens")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Report extended parser error support in 'nft -V' and configure output
- Fix for recompiling with changed extended-parser-errors configure
  option
- Fix for tarball compiling without bison presence
- Document the antics in the commit message
---
 Makefile.am                    |  5 +++++
 configure.ac                   | 22 +++++++++++++++++++++-
 include/nftables/libnftables.h |  2 ++
 src/libnftables.map            |  4 ++++
 src/main.c                     | 14 ++++++++------
 src/parser_bison.y             |  9 +++++++--
 6 files changed, 47 insertions(+), 9 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index fa71e06eefee5..5778dd29828e1 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -164,6 +164,11 @@ AM_CFLAGS = \
 	$(NULL)
 
 AM_YFLAGS = -d -Wno-yacc
+if BISON_CUSTOM_ERROR
+YACC += -D parse.error=custom -D parse.lac=full
+else
+YACC += -D parse.error=verbose
+endif
 
 if BUILD_PROFILING
 AM_CFLAGS += --coverage
diff --git a/configure.ac b/configure.ac
index 0d3ee2ac89f69..d0eb7829bf604 100644
--- a/configure.ac
+++ b/configure.ac
@@ -32,7 +32,11 @@ AC_PROG_SED
 AC_PROG_LEX([noyywrap])
 AC_PROG_YACC
 
-if test -z "$ac_cv_prog_YACC" -a ! -f "${srcdir}/src/parser_bison.c"
+p_bison_pfx="${srcdir}/src/parser_bison"
+if test -f "${p_bison_pfx}.c" -a "${p_bison_pfx}.c" -nt "${p_bison_pfx}.y"
+then
+	have_prebuilt_bison="yes"
+elif test -z "$ac_cv_prog_YACC"
 then
         echo "*** Error: No suitable bison/yacc found. ***"
         echo "    Please install the 'bison' package."
@@ -45,6 +49,18 @@ then
         exit 1
 fi
 
+AC_ARG_ENABLE([extended_parser_errors],
+	      AS_HELP_STRING([--disable-extended-parser-errors],
+			     [Disable use of parse.error=custom and LAC in Bison]),
+	      [], [
+			enable_extended_parser_errors=no
+			AC_SUBST([BISON], [$ac_cv_prog_YACC])
+			AX_PROG_BISON_VERSION([3.6],
+					      [enable_extended_parser_errors=yes])
+	      ])
+AM_CONDITIONAL([BISON_CUSTOM_ERROR],
+	       [test "x$enable_extended_parser_errors" != xno])
+
 AM_PROG_AR
 LT_INIT([disable-static])
 AC_EXEEXT
@@ -180,6 +196,10 @@ echo "
   json output support:          ${with_json}
   collect profiling data:       ${enable_profiling}"
 
+if test "x$have_prebuilt_bison" != "xyes"; then
+echo "  extended parser errors:       ${enable_extended_parser_errors}"
+fi
+
 if test "x$unitdir" != "x"; then
 AC_SUBST([unitdir])
 echo "  systemd unit:                 ${unitdir}"
diff --git a/include/nftables/libnftables.h b/include/nftables/libnftables.h
index c1d48d765a423..90b3f1b84a66f 100644
--- a/include/nftables/libnftables.h
+++ b/include/nftables/libnftables.h
@@ -99,6 +99,8 @@ void nft_ctx_clear_vars(struct nft_ctx *ctx);
 int nft_run_cmd_from_buffer(struct nft_ctx *nft, const char *buf);
 int nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename);
 
+extern bool nft_bison_have_extended_errors;
+
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
diff --git a/src/libnftables.map b/src/libnftables.map
index 9369f44f35367..55c64f40e6a28 100644
--- a/src/libnftables.map
+++ b/src/libnftables.map
@@ -38,3 +38,7 @@ LIBNFTABLES_4 {
   nft_ctx_input_get_flags;
   nft_ctx_input_set_flags;
 } LIBNFTABLES_3;
+
+LIBNFTABLES_5 {
+  nft_bison_have_extended_errors;
+} LIBNFTABLES_4;
diff --git a/src/main.c b/src/main.c
index 4cb51ff7f5fef..976410b05fba8 100644
--- a/src/main.c
+++ b/src/main.c
@@ -237,7 +237,7 @@ static void show_help(const char *name)
 
 static void show_version(void)
 {
-	const char *cli, *minigmp, *json, *xt;
+	const char *cli, *minigmp, *json, *xt, *ext_bsn_err;
 
 #if defined(HAVE_LIBREADLINE)
 	cli = "readline";
@@ -266,14 +266,16 @@ static void show_version(void)
 #else
 	xt = "no";
 #endif
+	ext_bsn_err = nft_bison_have_extended_errors ? "yes" : "no";
 
 	printf("%s v%s (%s)\n"
-	       "  cli:		%s\n"
-	       "  json:		%s\n"
-	       "  minigmp:	%s\n"
-	       "  libxtables:	%s\n",
+	       "  cli:				%s\n"
+	       "  json:				%s\n"
+	       "  minigmp:			%s\n"
+	       "  libxtables:			%s\n"
+	       "  extended parser errors:	%s\n",
 	       PACKAGE_NAME, PACKAGE_VERSION, RELEASE_NAME,
-	       cli, json, minigmp, xt);
+	       cli, json, minigmp, xt, ext_bsn_err);
 
 }
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 5a334bf0c4997..800a4bda3760f 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -221,8 +221,6 @@ int nft_lex(void *, void *, void *);
 %parse-param		{ void *scanner }
 %parse-param		{ struct parser_state *state }
 %lex-param		{ scanner }
-%define parse.error custom
-%define parse.lac full
 %locations
 
 %initial-action {
@@ -6537,6 +6535,7 @@ exthdr_key		:	HBH	close_scope_hbh	{ $$ = IPPROTO_HOPOPTS; }
 
 %%
 
+#ifdef YY_LAC_ESTABLISH
 static int
 yyreport_syntax_error(const yypcontext_t *yyctx, struct nft_ctx *nft,
                       void *scanner, struct parser_state *state)
@@ -6592,3 +6591,9 @@ yyreport_syntax_error(const yypcontext_t *yyctx, struct nft_ctx *nft,
 	free(msg);
 	return 0;
 }
+
+bool nft_bison_have_extended_errors = true;
+#else /* ! YY_LAC_ESTABLISH */
+bool nft_bison_have_extended_errors = false;
+#endif /* YY_LAC_ESTABLISH */
+EXPORT_SYMBOL(nft_bison_have_extended_errors);
-- 
2.54.0

