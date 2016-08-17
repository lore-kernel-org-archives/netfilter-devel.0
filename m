From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 04/10] parser_bison: missing token string in QUOTED_ASTERISK and ASTERISK_STRING
Date: Wed, 17 Aug 2016 15:29:55 +0200
Message-ID: <1471440601-5327-5-git-send-email-pablo@netfilter.org>
References: <1471440601-5327-1-git-send-email-pablo@netfilter.org>
Cc: fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44020 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009AbcHQNaN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Aug 2016 09:30:13 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 2AE6CE977B
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 15:30:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 14F5DFF134
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 15:30:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id F14A4DA800
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 15:30:08 +0200 (CEST)
In-Reply-To: <1471440601-5327-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

<cmdline>:1:24-24: Error: syntax error, unexpected newline, expecting string or QUOTED_STRING or ASTERISK_STRING
add rule x y log prefix
                       ^

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index ba2dba4..f4ce11d 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -221,8 +221,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 
 %token <val> NUM		"number"
 %token <string> STRING		"string"
-%token <string> QUOTED_STRING
-%token <string> ASTERISK_STRING
+%token <string> QUOTED_STRING	"quoted string"
+%token <string> ASTERISK_STRING	"string with a trailing asterisk"
 %destructor { xfree($$); }	STRING QUOTED_STRING ASTERISK_STRING
 
 %token LL_HDR			"ll"
-- 
2.1.4

