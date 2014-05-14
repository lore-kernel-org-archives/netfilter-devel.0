From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH 3/4] doc: document export op
Date: Wed, 14 May 2014 17:36:22 +0200
Message-ID: <20140514153622.25186.9873.stgit@nfdev.cica.es>
References: <20140514153146.25186.58208.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:48868 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755772AbaENPga (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 May 2014 11:36:30 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 4FA7E51EDBB
	for <netfilter-devel@vger.kernel.org>; Wed, 14 May 2014 15:36:29 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hWLoTdFqHkZl for <netfilter-devel@vger.kernel.org>;
	Wed, 14 May 2014 17:36:24 +0200 (CEST)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id 528D751ED91
	for <netfilter-devel@vger.kernel.org>; Wed, 14 May 2014 17:36:24 +0200 (CEST)
In-Reply-To: <20140514153146.25186.58208.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Let's document the `nft export [xml|json]' command.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 doc/nft.xml |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/doc/nft.xml b/doc/nft.xml
index 1de4b3f..61ca03a 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -2080,6 +2080,28 @@ filter input iif eth0 drop
 	</refsect1>
 
 	<refsect1>
+		<title>Additional commands</title>
+		<para>
+			These are some additional commands included in nft.
+		</para>
+		<refsect2>
+			<title>export</title>
+			<para>
+				Export your current ruleset in XML or JSON format to stdout.
+			</para>
+			<para>
+				Examples:
+				<programlisting>
+% nft export xml
+[...]
+% nft export json
+[...]
+				</programlisting>
+			</para>
+		</refsect2>
+	</refsect1>
+
+	<refsect1>
 		<title>Error reporting</title>
 		<para>
 			When an error is detected, nft shows the line(s) containing the error, the position

