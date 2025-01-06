Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A25F1E0DC0
	for <netfilter-devel@vger.kernel.org>; Mon,  6 Jan 2025 23:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736205018; cv=none; b=SYF8jMbMrF63hsPvnzOjGuaphdt6oTSuO6lDt8hcfxUl2J7olpaprrqx7ghjST1CyvKERzELJvUudXTXZ457l8oswegL86rvTBU0hVFkBM0vVDO62//7Sryzrf7yygJpDfyIntCVW8E+7hl/LqVPQUIqkI2AP5wTlwl/c/qS7q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736205018; c=relaxed/simple;
	bh=hEME1TOnBtm39THN3xcFcctpODT5MgBxw9uxS/jWuk4=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=cHVDSBKl1vTrHh7yf0CUngDrqkkIdAvmQFC2dnHHV2huxRzXfvlEkFoNx7WoSATjE5UIIOQFBEoZs+JfV8HkXSUGfsBjpBJFSzEzWw8gTM+GNdar9JcUtLX1xlNm5fla9iRQgOHE4ZN3AVtYeKooaG0L0yw3w+Tuozey5YPXTH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
X-Spam-Level: 
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] scanner: better error reporting for CRLF line terminators
Date: Tue,  7 Jan 2025 00:10:11 +0100
Message-Id: <20250106231011.204094-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Provide a hint to users that file are coming with CRLF line terminators
maybe from non-Linux OS.

Extend scanner.l to provide hint on CRLF in files:

 # file test.nft
 test.nft: ASCII text, with CRLF, LF line terminators
 # nft -f test.nft
 test.nft:1:13-14: Error: syntax error, unexpected CRLF line terminators
 table ip x {
             ^^

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y | 1 +
 src/scanner.l      | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index e107ddfd3e4e..addeb03ac21c 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -251,6 +251,7 @@ int nft_lex(void *, void *, void *);
 
 %token TOKEN_EOF 0		"end of file"
 %token JUNK			"junk"
+%token CRLF			"CRLF line terminators"
 
 %token NEWLINE			"newline"
 %token COLON			"colon"
diff --git a/src/scanner.l b/src/scanner.l
index 9ccbc22d2120..4787cc12f993 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -121,6 +121,7 @@ extern void	yyset_column(int, yyscan_t);
 
 space		[ ]
 tab		\t
+newline_crlf	\r\n
 newline		\n
 digit		[0-9]
 hexdigit	[0-9a-fA-F]
@@ -894,6 +895,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 				return STRING;
 			}
 
+{newline_crlf}		{	return CRLF; }
+
 \\{newline}		{
 				reset_pos(yyget_extra(yyscanner), yylloc);
 			}
-- 
2.30.2

