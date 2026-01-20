Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01B642849C
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Jan 2026 12:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768912225; cv=none; b=RdZENvJHv8Yp71pzqIFmxvvdC+A51klHm2koKysXuvMlfFqdRj9fteB6I0FORuxnI/0YDGVzQxYpBq6tJaHIA/64bTQBPOtekF9t0n+sWXbFgsT3xVtU0vGtN608fQBTeGOalh6hxCNIS+N1qu0AvpA8X+XCdQNYsZGpLkQ6+Kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768912225; c=relaxed/simple;
	bh=biAP0tSHcFNu/OFm4pIwX84DdSnbnWqiSgcj0loQSMY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=darkORnerTzdyIan68l6USkamgzPUEG4eOzPdPuUNitO86XuEHYMZa1RsgtGzTdofSzjbhSzie9qCIZLgEnzBC7pP+P6K9yUBWZaB/wdg7CRVxVh5QC9nbnTnuXTp599S88waJ75tELwKZAJvALEFftVKud8zeR8qf9q05AxPeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 53D5C60516; Tue, 20 Jan 2026 13:30:14 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: =?UTF-8?q?Jan=20Ko=C5=84czak?= <jan.konczak@cs.put.poznan.pl>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nft v2] parser_bison: on syntax errors, output expected tokens
Date: Tue, 20 Jan 2026 13:29:51 +0100
Message-ID: <20260120122954.18909-1-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jan Kończak <jan.konczak@cs.put.poznan.pl>

Now, on syntax erros, e.g., 'nft create fable filter', the user sees:
   Error: syntax error, unexpected string
   create fable filter
          ^^^^^
The patch builds an error message that lists what the parser expects
to see, in that case it would print:
   Error: syntax error, unexpected string
   expected any of: synproxy, table, chain, set, element, map,
   flowtable, ct, counter, limit, quota, secmark
   create fable filter
          ^^^^^
The obvious purpose of this is to help people who learn nft syntax.
The messages are still not as explanatory as one wishes, for it may
list parser token names such as 'string', but it's still better
than no hints at all.

Heed that the list of possible items on the parser's side is not
always consistent with expectations.
For instance, lexer/parser recognizes 'l4proto' in this command:
   nft add rule ip F I meta l4proto tcp
as a generic '%token <string> STRING', while 'iifname' in
   nft add rule ip F I meta iifname eth0
is recognized as a '%token IIFNAME'
In such case the parser is only able to say that right after 'meta'
it expects 'iifname' or 'string', rather than 'iifname' and 'l4proto'.

(Notice that the help which is already present in nft is also off,
e.g., 'nft add rule ip F I meta bogus bogus' constructs in meta.c
a list of all possible keywords that does not list all possible
keywords, for 'ibriport' gets recognized, but is not listed there.)

Signed-off-by: Jan Kończak <jan.konczak@cs.put.poznan.pl>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v2: prefer stdio (fprintf+memopen) vs. manual realloc of a cstring
 buffer, align more with nftables coding style.

 I'll apply this unless there are any objections.

 src/parser_bison.y | 59 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 58 insertions(+), 1 deletion(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 3ceef79469d7..05f64e6c6cbb 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -221,7 +221,8 @@ int nft_lex(void *, void *, void *);
 %parse-param		{ void *scanner }
 %parse-param		{ struct parser_state *state }
 %lex-param		{ scanner }
-%define parse.error verbose
+%define parse.error custom
+%define parse.lac full
 %locations
 
 %initial-action {
@@ -6603,3 +6604,59 @@ exthdr_key		:	HBH	close_scope_hbh	{ $$ = IPPROTO_HOPOPTS; }
 			;
 
 %%
+
+static int
+yyreport_syntax_error(const yypcontext_t *yyctx, struct nft_ctx *nft,
+                      void *scanner, struct parser_state *state)
+{
+	const char *bad_token = yysymbol_name(yypcontext_token(yyctx));
+	struct location *loc = yypcontext_location(yyctx);
+	yysymbol_kind_t *exp_tokens;
+	int exp_tokens_cnt;
+	size_t errbufsz;
+	FILE *errfp;
+	char *msg;
+
+	errfp = open_memstream(&msg, &errbufsz);
+	if (!errfp)
+		memory_allocation_error();
+
+	exp_tokens_cnt = yypcontext_expected_tokens(yyctx, NULL, 0);
+	exp_tokens = xmalloc_array(exp_tokens_cnt, sizeof(yysymbol_kind_t));
+	yypcontext_expected_tokens(yyctx, exp_tokens, exp_tokens_cnt);
+
+	fprintf(errfp, "syntax error, unexpected %s\nexpected any of: ", bad_token);
+
+	for (int i = 0; i < exp_tokens_cnt; i++) {
+		const char *token_name = yysymbol_name(exp_tokens[i]);
+		bool is_keyword = true;
+
+		/* tokens that name generic things shall be printed as <foo>; detect them */
+		switch (exp_tokens[i]) {
+		case YYSYMBOL_NUM:
+		case YYSYMBOL_STRING:
+		case YYSYMBOL_QUOTED_STRING:
+		case YYSYMBOL_ASTERISK_STRING:
+			is_keyword = false;
+			break;
+		default:
+			break;
+		}
+
+		if (i > 0)
+			fputs(", ", errfp);
+		if (!is_keyword)
+			fputc('<', errfp);
+		fputs(token_name, errfp);
+		if (!is_keyword)
+			fputc('>', errfp);
+	}
+
+	free(exp_tokens);
+	fclose(errfp);
+	/* no newline on the end of the error message; this is intended */
+	yyerror(loc, nft, scanner, state, msg);
+
+	free(msg);
+	return 0;
+}
-- 
2.52.0

