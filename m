From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH 2/4] doc: update return code for NFT_EXIT_NONL
Date: Wed, 14 May 2014 17:36:17 +0200
Message-ID: <20140514153617.25186.27876.stgit@nfdev.cica.es>
References: <20140514153146.25186.58208.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:48866 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752479AbaENPga (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 May 2014 11:36:30 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id F21F251EE9B
	for <netfilter-devel@vger.kernel.org>; Wed, 14 May 2014 15:36:28 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vCbnXhobTVYv for <netfilter-devel@vger.kernel.org>;
	Wed, 14 May 2014 17:36:19 +0200 (CEST)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id 2370151EDBB
	for <netfilter-devel@vger.kernel.org>; Wed, 14 May 2014 17:36:19 +0200 (CEST)
In-Reply-To: <20140514153146.25186.58208.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If we exit with NFT_EXIT_NONL, we return 3.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 doc/nft.xml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index 958abbc..1de4b3f 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -2124,7 +2124,7 @@ filter output oif wlan0
 		<para>
 			On success, nft exits with a status of 0. Unspecified
 			errors cause it to exit with a status of 1, memory allocation
-			errors with a status of 2.
+			errors with a status of 2, unable to open Netlink socket with 3.
 		</para>
 	</refsect1>
 

