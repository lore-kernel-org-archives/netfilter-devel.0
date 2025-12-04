Received: from libra.cs.put.poznan.pl (libra.cs.put.poznan.pl [150.254.30.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D899425742F
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Dec 2025 21:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.254.30.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764885298; cv=none; b=I4q2JqwZYyqQWHXhRGRxjqq9EJoLZs7+ubyeBapCqAxv6CrlJ1Ww1wUfPWgDko3m3qyJcigm0xpKhUTOZCDU6L50A9DF7ckcUt81a+GbNgC3FCuDYc4uzdt3I9V1acZkjtNxMINjOJSGoYBKuePm1OszWQ7zDFOVrL5mcn/XaEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764885298; c=relaxed/simple;
	bh=UIacNHNrD3t8TnAloz7KsRFKkZLitrPsi4oAY8zvu4E=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=f7FngBTm++tise7N2r5hHXQKqXS6G2DoKQbkGv2Rlq60ZeF6dljsfXK+/Yuj03kGABfgC7Uh67Yo1afcb57d6JYYoEoQxEGJT6zFFr5QXcQlPcvOSUPt3HNcnkjXYfe32oOIhTRC3Xu5NdNB0a9H3iI5ixk7yWMZuKF4X4o3618=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cs.put.poznan.pl; spf=pass smtp.mailfrom=cs.put.poznan.pl; dkim=pass (2048-bit key) header.d=cs.put.poznan.pl header.i=@cs.put.poznan.pl header.b=JB18tjLE; arc=none smtp.client-ip=150.254.30.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cs.put.poznan.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cs.put.poznan.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cs.put.poznan.pl header.i=@cs.put.poznan.pl header.b="JB18tjLE"
X-Virus-Scanned: Debian amavis at cs.put.poznan.pl
Received: from libra.cs.put.poznan.pl ([150.254.30.30])
 by localhost (meduza.cs.put.poznan.pl [150.254.30.40]) (amavis, port 10024)
 with ESMTP id JQTOzPlK1Lsh for <netfilter-devel@vger.kernel.org>;
 Thu,  4 Dec 2025 21:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=cs.put.poznan.pl;
	s=7168384; t=1764884029;
	bh=UIacNHNrD3t8TnAloz7KsRFKkZLitrPsi4oAY8zvu4E=;
	h=From:To:Subject:Date:From;
	b=JB18tjLE1V8Wa57RXucOWlKpF5NncefJ8pNvnv25rg4e4I/wSYLDTHhRHuuyQ3T1A
	 szcKi/AxxiOZEBXGcU4S2jqsZeRwm5e8C++hUDVYm5DzRaT9NeVv8QfWwZ+YfMrXDq
	 cnSLq1SazRci+rAvUfmnyASleHQbtXQqoaPeZBwR8GIAF+Kfyu4aHdv8xwlKW+f9SM
	 VLEPL+7WpQgvCh4r6vEV+nW8eajitT4EncFw+yV32A65xWI0LkpQ92ZVCvK9k8rx6Q
	 EIVy7EiDYIwU0PERaKXwjxvdJVMY9b3EAhgWzqBIsqdv+5IEwZdQBftOhN8F+u0s11
	 f2X4MDlGDyZVQ==
Received: from imladris.localnet (83.8.111.28.ipv4.supernova.orange.pl [83.8.111.28])
	(Authenticated sender: jkonczak@libra.cs.put.poznan.pl)
	by libra.cs.put.poznan.pl (Postfix on VMS) with ESMTPSA id D391D62DF0
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Dec 2025 22:54:51 +0100 (CET)
From: Jan =?UTF-8?B?S2/FhGN6YWs=?= <jan.konczak@cs.put.poznan.pl>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] parser_bison: on syntax errors, output expected tokens
Date: Thu, 04 Dec 2025 22:54:48 +0100
Message-ID: <1950751.CQOukoFCf9@imladris>
Organization: Institute of Computing Science,
 =?UTF-8?B?UG96bmHFhA==?= University of Technology
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

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
=46or instance, lexer/parser recognizes 'l4proto' in this command:
   nft add rule ip F I meta l4proto tcp
as a generic '%token <string> STRING', while 'iifname' in=20
   nft add rule ip F I meta iifname eth0
is recognized as a '%token IIFNAME'
In such case the parser is only able to say that right after 'meta'
it expects 'iifname' or 'string', rather than 'iifname' and 'l4proto'.

(Notice that the help which is already present in nft is also off,
e.g., 'nft add rule ip F I meta bogus bogus' constructs in meta.c
a list of all possible keywords that does not list all possible
keywords, for 'ibriport' gets recognized, but is not listed there.)


Signed-off-by: Jan Ko=C5=84czak <jan.konczak@cs.put.poznan.pl>
=2D--
 src/parser_bison.y | 68 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 67 insertions(+), 1 deletion(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 3ceef794..55e95028 100644
=2D-- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -221,7 +221,8 @@ int nft_lex(void *, void *, void *);
 %parse-param		{ void *scanner }
 %parse-param		{ struct parser_state *state }
 %lex-param		{ scanner }
=2D%define parse.error verbose
+%define parse.error custom
+%define parse.lac full
 %locations
=20
 %initial-action {
@@ -6603,3 +6604,68 @@ exthdr_key		:	HBH	close_scope_hbh	{ $$ =3D IPPROTO_H=
OPOPTS; }
 			;
=20
 %%
+
+static int
+yyreport_syntax_error(const yypcontext_t *yyctx, struct nft_ctx *nft,
+                      void *scanner, struct parser_state *state)
+{
+	struct location *loc =3D yypcontext_location(yyctx);
+	const char *badTok =3D yysymbol_name(yypcontext_token(yyctx));
+
+	char * msg;
+	int len =3D 1024;
+	int pos;
+	const char * const sep =3D ", ";
+
+	// get expected tokens
+	int expTokCnt =3D yypcontext_expected_tokens(yyctx, NULL, 0);
+	yysymbol_kind_t *expTokArr =3D malloc(sizeof(yysymbol_kind_t) * expTokCnt=
);
+	if (!expTokArr) return YYENOMEM;
+	yypcontext_expected_tokens(yyctx, expTokArr, expTokCnt);
+
+	// reserve space for the error message
+	msg =3D malloc(len);
+	if (!msg) { free(expTokArr); return YYENOMEM; }
+
+	// start building up the error message
+	pos =3D snprintf(msg, len, "syntax error, unexpected %s\n"
+	                         "expected any of: ", badTok);
+
+	// append expected tokens to the error message
+	for (int i =3D 0; i < expTokCnt; ++i) {
+		yysymbol_kind_t expTokKind =3D expTokArr[i];
+		const char * expTokName =3D yysymbol_name(expTokKind);
+
+		// tokens that name generic things shall be printed as <foo>; detect them
+		int isNotAKeyword =3D 0;
+		switch( expTokKind ){
+			case YYSYMBOL_NUM:      case YYSYMBOL_QUOTED_STRING:
+			case YYSYMBOL_STRING:   case YYSYMBOL_ASTERISK_STRING:
+				isNotAKeyword =3D 1;
+			default:
+		}
+
+		if ((size_t)len-pos-1 < strlen(expTokName)+strlen(sep)+isNotAKeyword*2) {
+			// need more space for the error message to fit all expected tokens
+			char * newMsg;
+			len +=3D 1024;
+			newMsg =3D realloc(msg, len);
+			if (!newMsg) { free(msg); free(expTokArr); return YYENOMEM; }
+			msg =3D newMsg;
+		}
+
+		pos +=3D snprintf(msg+pos, len-pos, "%s%s%s%s",
+		                                  (i ? sep : ""),
+		                                  (isNotAKeyword ? "<" : ""),
+		                                  expTokName,
+		                                  (isNotAKeyword ? ">" : ""));
+	}
+	free(expTokArr);
+	// notice no newline on the end of the error message; this is intended
+
+	// call the standard error function
+	yyerror(loc, nft, scanner, state, msg);
+
+	free(msg);
+	return 0;
+}
=2D-


