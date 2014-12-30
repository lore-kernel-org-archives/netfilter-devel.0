From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH] doc: add a reference to the wiki page in the man page
Date: Tue, 30 Dec 2014 16:11:13 +0100
Message-ID: <20141230151112.14860.37311.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org, jidanni@jidanni.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:41144 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751310AbaL3PLZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Dec 2014 10:11:25 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Let's add a pointer in the man page to the wiki page.

Requested-by: Dan Jacobson <jidanni@jidanni.org>
Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 doc/nft.xml |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/doc/nft.xml b/doc/nft.xml
index e45a593..7998008 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -2202,6 +2202,13 @@ filter output oif wlan0
 	</refsect1>
 
 	<refsect1>
+		<title>Further reading</title>
+		<para>
+			There is an official wiki at: http://wiki.nftables.org
+		</para>
+	</refsect1>
+
+	<refsect1>
 		<title>See Also</title>
 		<para>
 			<simplelist type="inline">

