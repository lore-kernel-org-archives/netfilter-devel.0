From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH 1/4] doc: fix indendation of examples
Date: Wed, 14 May 2014 17:36:12 +0200
Message-ID: <20140514153612.25186.66035.stgit@nfdev.cica.es>
References: <20140514153146.25186.58208.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:48861 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755143AbaENPgU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 May 2014 11:36:20 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id E68E051ED91
	for <netfilter-devel@vger.kernel.org>; Wed, 14 May 2014 15:36:18 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5e1szoo2en6N for <netfilter-devel@vger.kernel.org>;
	Wed, 14 May 2014 17:36:13 +0200 (CEST)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id E9C3751EDBB
	for <netfilter-devel@vger.kernel.org>; Wed, 14 May 2014 17:36:13 +0200 (CEST)
In-Reply-To: <20140514153146.25186.58208.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Let's fix the indendation of examples.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 doc/nft.xml |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index 702891c..958abbc 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -2097,7 +2097,7 @@ filter input iif eth0 drop
 			<programlisting>
 &lt;cmdline&gt;:1:19-22: Error: Interface does not exist
 filter output oif eth0
-^^^
+                  ^^^^
 			</programlisting>
 		</example>
 		<example>
@@ -2105,7 +2105,7 @@ filter output oif eth0
 			<programlisting>
 &lt;cmdline&gt;:1:28-36: Error: Right hand side of relational expression (==) must be constant
 filter output tcp dport == tcp dport
-~~ ^^^^^^^^^
+                        ~~ ^^^^^^^^^
 			</programlisting>
 		</example>
 

