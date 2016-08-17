From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 06/10] scanner: remove range expression
Date: Wed, 17 Aug 2016 15:29:57 +0200
Message-ID: <1471440601-5327-7-git-send-email-pablo@netfilter.org>
References: <1471440601-5327-1-git-send-email-pablo@netfilter.org>
Cc: fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44028 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539AbcHQNaO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Aug 2016 09:30:14 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id B1355E9762
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 15:30:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9D5E6DA7FE
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 15:30:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8A785FC61C
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 15:30:10 +0200 (CEST)
In-Reply-To: <1471440601-5327-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This expression is not used anywhere in this scanner code.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/scanner.l | 1 -
 1 file changed, 1 deletion(-)

diff --git a/src/scanner.l b/src/scanner.l
index 6f497e8..b1420f3 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -110,7 +110,6 @@ digit		[0-9]
 hexdigit	[0-9a-fA-F]
 decstring	{digit}+
 hexstring	0[xX]{hexdigit}+
-range		({decstring}?:{decstring}?)
 letter		[a-zA-Z]
 string		({letter}|[_.])({letter}|{digit}|[/\-_\.])*
 quotedstring	\"[^"]*\"
-- 
2.1.4

