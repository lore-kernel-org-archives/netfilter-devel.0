Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA0EB3E3147
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Jun 2026 11:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781092645; cv=none; b=eK43lbn9s6W/jX3jJMaq6HGq8YVr6bvXPIa4JAvYlQ7oYrSdCzwUONo3slIUiRSZmT+hw98+zkl9tY7AN5iB7QnYI6POpDTRpSD2j2+09yT46nt+fK4CH0Sbc8XyKs+vTwAauh3VatzXk4D+QVbcaMbJKctiWsejkdmjErGS8uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781092645; c=relaxed/simple;
	bh=wxzhIaaVQtfH0n6Pl0PisZqNBQVy1PmdqWXfZLnDyGA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=iYdgUfHfVtbcLTGeHPDNb+p0uaIJ68d3m3U6PODnS2spPAQxPT71kAtrs9szfUyFBmI37mFWECN9QJTXJ8v3FltDrnEZixDfDPyeRbdL+tIqVJdh/d+ZKWqPcMJPZWk9L7jsAZZsvBgGCiZypYyQNut7q6YnQDemkahEpIg2pgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=CZoaqqKv; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="CZoaqqKv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=yWpnQK6URl2Uom2kLHM0GXX86/pSmneNNVNLdmZN3hE=; b=CZoaqqKvi45+yppsWWFA/bFFsJ
	GbHQRZ2wqmw0Oj6BzQaH4ie5PicWdC2W6BR9vT8M1OqQW5GK8OgVyigdSCSuWGXYC6zGh8os0D2KZ
	vBSHFEEYR2Ly6iZ0AHrhYtVQruZrfq/xJbBEqq6iFGwfO8FTARBLQf7cw6q0BAZctmSdWk2eIKkMj
	bN/vzJJOu/KE52kOPE01Wf8eRRhpg8QPWOfP8mr1VcHOZkqrFdMsq4mJQaoAkSmGZoAG+tGwmGCTz
	t2OkQ+Azr1xErgQqaRid/5xwcnceW824+rnQIc4FAWbiphHPnytXks1fnSG/j9lkyQ89JRmUD6HjV
	bDhlC8LQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wXHYY-000000005sQ-1R5a;
	Wed, 10 Jun 2026 13:57:14 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	=?UTF-8?q?Jan=20Ko=C5=84czak?= <jan.konczak@cs.put.poznan.pl>
Subject: [nft PATCH] parser_bison: Fix for bison < 3.6
Date: Wed, 10 Jun 2026 13:57:09 +0200
Message-ID: <20260610115709.3982133-1-phil@nwl.cc>
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

Suggested-by: Jan Kończak <jan.konczak@cs.put.poznan.pl>
Fixes: 67b822f2b2624 ("parser_bison: on syntax errors, output expected tokens")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 Makefile.am        |  6 ++++++
 configure.ac       | 12 ++++++++++++
 src/parser_bison.y |  4 ++--
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index fa71e06eefee5..ddf145a87c810 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -164,6 +164,12 @@ AM_CFLAGS = \
 	$(NULL)
 
 AM_YFLAGS = -d -Wno-yacc
+if BISON_CUSTOM_ERROR
+YACC += -D parse.error=custom -D parse.lac=full
+AM_CFLAGS += -DBISON_CUSTOM_ERROR
+else
+YACC += -D parse.error=verbose
+endif
 
 if BUILD_PROFILING
 AM_CFLAGS += --coverage
diff --git a/configure.ac b/configure.ac
index 0d3ee2ac89f69..b6cad3117a51b 100644
--- a/configure.ac
+++ b/configure.ac
@@ -45,6 +45,18 @@ then
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
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 5a334bf0c4997..fc95597d898c0 100644
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
 
+#ifdef BISON_CUSTOM_ERROR
 static int
 yyreport_syntax_error(const yypcontext_t *yyctx, struct nft_ctx *nft,
                       void *scanner, struct parser_state *state)
@@ -6592,3 +6591,4 @@ yyreport_syntax_error(const yypcontext_t *yyctx, struct nft_ctx *nft,
 	free(msg);
 	return 0;
 }
+#endif /* BISON_CUSTOM_ERROR */
-- 
2.54.0

