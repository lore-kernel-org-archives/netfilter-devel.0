Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E01D37F331
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Sep 2026 09:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788256149; cv=none; b=fhw9ql6Tkdm+JTkbAJb2z4cPgykasiewc5xaaKdMfn/UB1IK8nAISJ8LGBnNAADm1tX2+U9929d6kbSz/L/6GTw0qQCtTH+AfroEjIbG2Y9jyxOQ3RvvuBUHUePaWR8EQH+dAJbyfqAThNuSURPSMkAQtJO4aFTdO5Ktfeh48JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788256149; c=relaxed/simple;
	bh=CdoFNkgMlU/fWWH2F9BXV8oL7aGnVPDBwTFpbPocy/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Nexarvmp4jzgfXryzc25ENWscE1MPaJW+qH+j/LwWUnNspp77nAXQmwYP+0XfbaPJEbFOlzUVN4Nj8G01MyXlqtN99gJQt2krt8FZjlbrrDPSLHyMiQZLddzVTI6ecdOg5Pbf3PUhGwF7yaGYk5I1siDqt/qdt+0TLoH6/+UZb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=F7bpqJEl; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="F7bpqJEl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=xQIxfrhxGx2lGkxh8U7/H6j+eBBx79DvT4Ny+CNEDCE=; b=F7bpqJElrZCvgLqDSF4H+JChGr
	91X6cgpFtGGJwiLKvfEmESpatrNqgeNSPvWL0g7M1R6EOvHUjDJcNRJjWUeZ66aETDtJIYabsnSdG
	xJNkXmnUZgORcKtiZpUw/59mQDRkA5raq0kJmiohKos++JUUsTGQLWFVfcnIIZ9cArqKJFJX1r+vF
	q0+r/JGOzv4mOA+wNw3PitdrCRGtgOod6OjQRNTYNjhanL2BvpFhbOPFjJt+FR6QVA+rbcZe/VwVM
	xHjNnqCwzoccTO3E/Gnd1OusLqdGnlt1oFz7LYdTd/3kaCX5uAEa7oAL8abPCx/Nx4P5XyR/fa6/2
	EtHNnBrQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1x1L6v-000000008Uz-40PS;
	Tue, 01 Sep 2026 11:48:58 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH] libnftables: Drop symbol nft_bison_have_extended_errors
Date: Tue,  1 Sep 2026 11:48:52 +0200
Message-ID: <20260901094852.104268-1-phil@nwl.cc>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It was merely used to indicate extended parser error support in 'nft
--version' output. Not worth bumping library version just for that, so
drop it again.

Fixes: b315dd551dd96 ("parser_bison: Fix for bison < 3.6")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/nftables/libnftables.h |  2 --
 src/libnftables.map            |  4 ----
 src/main.c                     | 15 ++++++---------
 src/parser_bison.y             |  4 ----
 4 files changed, 6 insertions(+), 19 deletions(-)

diff --git a/include/nftables/libnftables.h b/include/nftables/libnftables.h
index 90b3f1b84a66f..c1d48d765a423 100644
--- a/include/nftables/libnftables.h
+++ b/include/nftables/libnftables.h
@@ -99,8 +99,6 @@ void nft_ctx_clear_vars(struct nft_ctx *ctx);
 int nft_run_cmd_from_buffer(struct nft_ctx *nft, const char *buf);
 int nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename);
 
-extern bool nft_bison_have_extended_errors;
-
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
diff --git a/src/libnftables.map b/src/libnftables.map
index 55c64f40e6a28..9369f44f35367 100644
--- a/src/libnftables.map
+++ b/src/libnftables.map
@@ -38,7 +38,3 @@ LIBNFTABLES_4 {
   nft_ctx_input_get_flags;
   nft_ctx_input_set_flags;
 } LIBNFTABLES_3;
-
-LIBNFTABLES_5 {
-  nft_bison_have_extended_errors;
-} LIBNFTABLES_4;
diff --git a/src/main.c b/src/main.c
index 976410b05fba8..c8430174f5450 100644
--- a/src/main.c
+++ b/src/main.c
@@ -237,7 +237,7 @@ static void show_help(const char *name)
 
 static void show_version(void)
 {
-	const char *cli, *minigmp, *json, *xt, *ext_bsn_err;
+	const char *cli, *minigmp, *json, *xt;
 
 #if defined(HAVE_LIBREADLINE)
 	cli = "readline";
@@ -266,16 +266,13 @@ static void show_version(void)
 #else
 	xt = "no";
 #endif
-	ext_bsn_err = nft_bison_have_extended_errors ? "yes" : "no";
-
 	printf("%s v%s (%s)\n"
-	       "  cli:				%s\n"
-	       "  json:				%s\n"
-	       "  minigmp:			%s\n"
-	       "  libxtables:			%s\n"
-	       "  extended parser errors:	%s\n",
+	       "  cli:		%s\n"
+	       "  json:		%s\n"
+	       "  minigmp:	%s\n"
+	       "  libxtables:	%s\n",
 	       PACKAGE_NAME, PACKAGE_VERSION, RELEASE_NAME,
-	       cli, json, minigmp, xt, ext_bsn_err);
+	       cli, json, minigmp, xt);
 
 }
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 3967993472960..c63007321e339 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -6677,8 +6677,4 @@ yyreport_syntax_error(const yypcontext_t *yyctx, struct nft_ctx *nft,
 	return 0;
 }
 
-bool nft_bison_have_extended_errors = true;
-#else /* ! YY_LAC_ESTABLISH */
-bool nft_bison_have_extended_errors = false;
 #endif /* YY_LAC_ESTABLISH */
-EXPORT_SYMBOL(nft_bison_have_extended_errors);
-- 
2.54.0

