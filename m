From: Arturo Borrero <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 1/2] src: delete exporting internal flags in XML
Date: Mon, 29 Apr 2013 14:36:07 +0200
Message-ID: <20130429123607.26114.18073.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:60451 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752044Ab3D2MgM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Apr 2013 08:36:12 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The uint32_t flags attribute is internal, so no need to export/import i=
n XML.

Signed-off-by: Arturo Borrero Gonz=C3=A1lez <arturo.borrero.glez@gmail.=
com>
---
 src/chain.c |    5 ++---
 src/table.c |    3 +--
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/src/chain.c b/src/chain.c
index fb5d218..44a0e66 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -452,7 +452,6 @@ static int nft_chain_snprintf_xml(char *buf, size_t=
 size, struct nft_chain *c)
 		"<chain name=3D\"%s\" handle=3D\"%lu\""
 			" bytes=3D\"%lu\" packets=3D\"%lu\">"
 			"<properties>"
-				"<flags>%d</flags>"
 				"<type>%s</type>"
 				"<table>%s</table>"
 				"<prio>%d</prio>"
@@ -463,8 +462,8 @@ static int nft_chain_snprintf_xml(char *buf, size_t=
 size, struct nft_chain *c)
 			"</properties>"
 		"</chain>",
 			c->name, c->handle, c->bytes, c->packets,
-			c->flags, c->type, c->table, c->prio,
-			c->use, c->hooknum, c->policy, c->family);
+			c->type, c->table, c->prio, c->use, c->hooknum,
+			c->policy, c->family);
 }
=20
 static int nft_chain_snprintf_default(char *buf, size_t size, struct n=
ft_chain *c)
diff --git a/src/table.c b/src/table.c
index 2d72136..8adaba8 100644
--- a/src/table.c
+++ b/src/table.c
@@ -188,11 +188,10 @@ static int nft_table_snprintf_xml(char *buf, size=
_t size, struct nft_table *t)
 			"<table name=3D\"%s\">"
 				"<properties>"
 					"<family>%u</family>"
-					"<flags>%d</flags>"
 					"<table_flags>%d</table_flags>"
 				"</properties>"
 			"</table>" ,
-			t->name, t->family, t->flags, t->table_flags);
+			t->name, t->family, t->table_flags);
 }
=20
 static int nft_table_snprintf_default(char *buf, size_t size, struct n=
ft_table *t)

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
