Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C6CBC4332F
	for <netfilter-devel@archiver.kernel.org>; Fri, 16 Dec 2022 20:27:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbiLPU1b (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 16 Dec 2022 15:27:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231940AbiLPU1Z (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Dec 2022 15:27:25 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A6573947E
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Dec 2022 12:27:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=0QjsAFQjd1M6ZoicXVJBzodLGmHnb/hECrO52ccNl3A=; b=RHY7DSsnV1uY/yzlXlbzq/F676
        tTAmQ4wLt4mBMMilYy92aBtCXU55ubBDyV7dTKpTJsULPW1pRthWxTvYx1IoL0cdnN7/NabRY/NBP
        jf6FsSw273WUlk0zoyjcGCRTB68IdfSs5WA0IVXLdv6Wlh0+V9iAI7W2m/wYGeMV1EJ+lrUCqTbPD
        FHqMT2+OBO0C4g/a0brD03a2QJfB/egZhWn8rX4ugeoGvDioqTqCYCR+AYxMIdPdK9Xsp2ZYEWg8o
        o4lM5b/pBAW9taSmeW+r/vD+ZHSu+lBVPKrtvDBaNayVf5aCEAHvwv1aZo5QNiN/tyAKAgIrWtXD6
        zu1GT5gg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1p6HId-00EYeA-TL
        for netfilter-devel@vger.kernel.org; Fri, 16 Dec 2022 20:27:20 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft] scanner: treat invalid octal strings as strings
Date:   Fri, 16 Dec 2022 20:27:14 +0000
Message-Id: <20221216202714.1413699-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The action associated with the `{numberstring}` pattern, passes `yytext`
to `strtoull` with base 0:

	errno = 0;
	yylval->val = strtoull(yytext, NULL, 0);
	if (errno != 0) {
		yylval->string = xstrdup(yytext);
		return STRING;
	}
	return NUM;

If `yytext` begins with '0', it will be parsed as octal.  However, this
has unexpected consequences if the token contains non-octal characters.
`09` will be parsed as 0; `0308` will be parsed as 24, because
`strtoull` and its siblings stop parsing as soon as they reach a
character in the input which is not valid for the base.

Replace the `{numberstring}` match with separate `{hexstring}` and
`{decstring}` matches.  For `{decstring}` set the base to 8 if the
leading character is '0', and handle an incompletely parsed token in
the same way as one that causes `strtoull` to set `errno`.

Thus, instead of:

  $ sudo nft -f - <<<'
    table x {
      chain y {
        ip saddr 0308 continue comment "parsed as 0.0.0.24/32"
      }
    }
  '
  $ sudo nft list chain x y
  table ip x {
    chain y {
      ip saddr 0.0.0.24 continue comment "parsed as 0.0.0.24/32"
    }
  }

We get:

  $ sudo ./src/nft -f - <<<'
  > table x {
  >   chain y {
  >     ip saddr 0308 continue comment "error"
  >   }
  > }
  > '
  /dev/stdin:4:14-17: Error: Could not resolve hostname: Name or service not known
      ip saddr 0308 continue comment "error"
               ^^^^

Add a test-case.

Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=932880
Link: https://bugzilla.netfilter.org/show_bug.cgi?id=1363
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/scanner.l                       | 18 +++++++++++++++---
 tests/shell/testcases/parsing/octal | 13 +++++++++++++
 2 files changed, 28 insertions(+), 3 deletions(-)
 create mode 100755 tests/shell/testcases/parsing/octal

diff --git a/src/scanner.l b/src/scanner.l
index 1371cd044b65..1540df508f78 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -118,7 +118,6 @@ digit		[0-9]
 hexdigit	[0-9a-fA-F]
 decstring	{digit}+
 hexstring	0[xX]{hexdigit}+
-numberstring	({decstring}|{hexstring})
 letter		[a-zA-Z]
 string		({letter}|[_.])({letter}|{digit}|[/\-_\.])*
 quotedstring	\"[^"]*\"
@@ -815,9 +814,9 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 				return STRING;
 			}
 
-{numberstring}		{
+{hexstring}		{
 				errno = 0;
-				yylval->val = strtoull(yytext, NULL, 0);
+				yylval->val = strtoull(yytext, NULL, 16);
 				if (errno != 0) {
 					yylval->string = xstrdup(yytext);
 					return STRING;
@@ -825,6 +824,19 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 				return NUM;
 			}
 
+{decstring}		{
+				int base = yytext[0] == '0' ? 8 : 10;
+				char *end;
+
+				errno = 0;
+				yylval->val = strtoull(yytext, &end, base);
+				if (errno != 0 || *end) {
+					yylval->string = xstrdup(yytext);
+					return STRING;
+				}
+				return NUM;
+			}
+
 {classid}/[ \t\n:\-},]	{
 				yylval->string = xstrdup(yytext);
 				return STRING;
diff --git a/tests/shell/testcases/parsing/octal b/tests/shell/testcases/parsing/octal
new file mode 100755
index 000000000000..09ac26e76144
--- /dev/null
+++ b/tests/shell/testcases/parsing/octal
@@ -0,0 +1,13 @@
+#!/bin/bash
+
+$NFT add table t || exit 1
+$NFT add chain t c || exit 1
+$NFT add rule t c 'ip saddr 01 continue comment "0.0.0.1"' || exit 1
+$NFT add rule t c 'ip saddr 08 continue comment "error"' && {
+  echo "'"ip saddr 08"'" not rejected 1>&2
+  exit 1
+}
+$NFT delete table t || exit 1
+
+exit 0
+
-- 
2.35.1

