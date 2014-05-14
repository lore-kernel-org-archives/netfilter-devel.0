From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH] parser: fix inconsistency in monitor options
Date: Wed, 14 May 2014 17:24:29 +0200
Message-ID: <20140514152429.24350.45632.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:54864 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751875AbaENPYn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 May 2014 11:24:43 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 4E7F751EE76
	for <netfilter-devel@vger.kernel.org>; Wed, 14 May 2014 15:24:41 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id i1ltwjtNJpEV for <netfilter-devel@vger.kernel.org>;
	Wed, 14 May 2014 17:24:31 +0200 (CEST)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id 6B9E351ED51
	for <netfilter-devel@vger.kernel.org>; Wed, 14 May 2014 17:24:31 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The keyword for monitoring chains events is 'chains'. For rules, 'rules'.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/parser.y |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/parser.y b/src/parser.y
index 9c20737..b9916db 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -810,7 +810,7 @@ monitor_flags		:	/* empty */
 			}
 			|	NEW 	TABLES 	{	$$ |= (1 << NFT_MSG_NEWTABLE); }
 			|	DESTROY	TABLES	{	$$ |= (1 << NFT_MSG_DELTABLE); }
-			|	CHAIN
+			|	CHAINS
 			{
 				$$ |= (1 << NFT_MSG_NEWCHAIN);	$$ |= (1 << NFT_MSG_DELCHAIN);
 			}
@@ -822,7 +822,7 @@ monitor_flags		:	/* empty */
 			}
 			|	NEW	SETS 	{ 	$$ |= (1 << NFT_MSG_NEWSET); }
 			|	DESTROY SETS	{	$$ |= (1 << NFT_MSG_DELSET); }
-			|	RULE
+			|	RULES
 			{
 				$$ |= (1 << NFT_MSG_NEWRULE);	$$ |= (1 << NFT_MSG_DELRULE);
 			}

