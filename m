From: Arturo Borrero <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH] change XML output format to element better than
	attributes
Date: Wed, 13 Feb 2013 23:15:13 +0100
Message-ID: <20130213221513.11611.54603.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pneira@us.es
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:47769 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750967Ab3BMWP0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Feb 2013 17:15:26 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Some of the problems with attributes are:

* attributes cannot contain multiple values (child elements can)
* attributes are not easily expandable (for future changes)
* attributes cannot describe structures (child elements can)
* attributes are more difficult to manipulate by program code
* attribute values are not easy to test against a DTD

Examples of this question at: http://www.w3schools.com/dtd/dtd_el_vs_attr.asp
---
 src/chain.c |   16 ++++++++--------
 src/table.c |    5 +++--
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/src/chain.c b/src/chain.c
index 3c83e6d..1b1c3fe 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -443,14 +443,14 @@ static int nft_chain_snprintf_xml(char *buf, size_t size, struct nft_chain *c)
 		"<chain name=\"%s\" handle=\"%lu\""
 			" bytes=\"%lu\" packets=\"%lu\" >\n"
 			"\t<properties>\n"
-				"\t\t<flags value=\"%d\" />\n"
-				"\t\t<type value=\"%s\" />\n"
-				"\t\t<table value=\"%s\" />\n"
-				"\t\t<prio value=\"%d\" />\n"
-				"\t\t<use value=\"%d\" />\n"
-				"\t\t<hooknum value=\"%d\" />\n"
-				"\t\t<policy value=\"%d\" />\n"
-				"\t\t<family value=\"%d\" />\n"
+				"\t\t<flags>%d</flags>\n"
+				"\t\t<type>%s</type>\n"
+				"\t\t<table>%s</table>\n"
+				"\t\t<prio>%d</prio>\n"
+				"\t\t<use>%d</use>\n"
+				"\t\t<hooknum>%d</hooknum>\n"
+				"\t\t<policy>%d</policy>\n"
+				"\t\t<family>%d</family>\n"
 			"\t</properties>\n"
 		"</chain>\n",
 			c->name, c->handle, c->bytes, c->packets,
diff --git a/src/table.c b/src/table.c
index eb485b2..d2e07db 100644
--- a/src/table.c
+++ b/src/table.c
@@ -179,8 +179,9 @@ static int nft_table_snprintf_xml(char *buf, size_t size, struct nft_table *t)
 	return snprintf(buf, size,
 			"<table name=\"%s\" >\n"
 				"\t<properties>\n"
-					"\t\t<family value=\"%u\" />\n"
-					"\t\t<flags value=\"%d\" table_flags=\"%d\" />\n"
+					"\t\t<family>%u</family>\n"
+					"\t\t<flags>%d</flags>\n"
+					"\t\t<table_flags>%d</table_flags>\n"
 				"\t</properties>\n"
 			"</table>\n" ,
 			t->name, t->family, t->flags, t->table_flags);

