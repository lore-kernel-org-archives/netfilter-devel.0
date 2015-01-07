From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH v2] doc: add a reference to the wiki page in the man page
Date: Wed, 07 Jan 2015 17:03:09 +0100
Message-ID: <20150107160244.24333.83734.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp4.cica.es ([150.214.5.182]:39434 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752525AbbAGQDW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Jan 2015 11:03:22 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Let's add a pointer in the man page to the wiki page.

Requested-by: Dan Jacobson <jidanni@jidanni.org>
Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
v2: include the reference in the "see also" section as suggested by Pablo.

 doc/nft.xml |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/doc/nft.xml b/doc/nft.xml
index e45a593..696a4c3 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -2213,6 +2213,9 @@ filter output oif wlan0
 				<member>tc(8)</member>
 			</simplelist>
 		</para>
+		<para>
+			There is an official wiki at: http://wiki.nftables.org
+		</para>
 	</refsect1>
 
 	<refsect1>

