Return-Path: <SRS0=hXfx=ZH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DCA3C43141
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Nov 2019 18:38:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13B412073C
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Nov 2019 18:38:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbfKOSiY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 15 Nov 2019 13:38:24 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:55622 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726075AbfKOSiX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 15 Nov 2019 13:38:23 -0500
Received: from localhost ([::1]:40480 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iVgU9-00069A-M5; Fri, 15 Nov 2019 19:38:21 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] scanner: Introduce numberstring
Date:   Fri, 15 Nov 2019 19:38:13 +0100
Message-Id: <20191115183813.25085-1-phil@nwl.cc>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This token combines decstring and hexstring. The latter two had
identical action blocks (which were not completely trivial), this allows
to merge them.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/scanner.l | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/src/scanner.l b/src/scanner.l
index 3de5a9e0426e6..80b5a5f0dafcf 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -116,6 +116,7 @@ digit		[0-9]
 hexdigit	[0-9a-fA-F]
 decstring	{digit}+
 hexstring	0[xX]{hexdigit}+
+numberstring	({decstring}|{hexstring})
 letter		[a-zA-Z]
 string		({letter}|[_.])({letter}|{digit}|[/\-_\.])*
 quotedstring	\"[^"]*\"
@@ -608,17 +609,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 				return STRING;
 			}
 
-{decstring}		{
-				errno = 0;
-				yylval->val = strtoull(yytext, NULL, 0);
-				if (errno != 0) {
-					yylval->string = xstrdup(yytext);
-					return STRING;
-				}
-				return NUM;
-			}
-
-{hexstring}		{
+{numberstring}		{
 				errno = 0;
 				yylval->val = strtoull(yytext, NULL, 0);
 				if (errno != 0) {
-- 
2.24.0

