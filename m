From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 05/10] scanner: allow strings starting by underscores and dots
Date: Wed, 17 Aug 2016 15:29:56 +0200
Message-ID: <1471440601-5327-6-git-send-email-pablo@netfilter.org>
References: <1471440601-5327-1-git-send-email-pablo@netfilter.org>
Cc: fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44036 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751591AbcHQNaO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Aug 2016 09:30:14 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 60B77E9774
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 15:30:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 4AEEFFF2C7
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 15:30:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8B15AFC61A
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 15:30:09 +0200 (CEST)
In-Reply-To: <1471440601-5327-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

POSIX.1-2008 (which is simultaneously IEEE Std 1003.1-2008) says:

"The set of characters from which portable filenames are constructed.

A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
a b c d e f g h i j k l m n o p q r s t u v w x y z
0 1 2 3 4 5 6 7 8 9 . _ -"

On top of that it says:

"The <hyphen> character should not be used as the first character of a
portable user name."

This allows a bit more things that NAME_REGEX though, but this still
looks fine to me.

For more info, see:
http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap03.html#tag_03_431
http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap03.html#tag_03_278

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/scanner.l | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/scanner.l b/src/scanner.l
index 3ad4dd9..6f497e8 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -112,7 +112,7 @@ decstring	{digit}+
 hexstring	0[xX]{hexdigit}+
 range		({decstring}?:{decstring}?)
 letter		[a-zA-Z]
-string		({letter})({letter}|{digit}|[/\-_\.])*
+string		({letter}|[_.])({letter}|{digit}|[/\-_\.])*
 quotedstring	\"[^"]*\"
 asteriskstring	({string}\*|{string}\\\*)
 comment		#.*$
-- 
2.1.4

