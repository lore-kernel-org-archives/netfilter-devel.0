From: Arturo Borrero <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 2/5] src: expr: XML printing for binary data in
	targer and match
Date: Wed, 10 Apr 2013 18:40:02 +0200
Message-ID: <20130410164002.6303.24175.stgit@nfdev.cica.es>
References: <20130410163912.6303.8705.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:36341 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965071Ab3DJQkF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Apr 2013 12:40:05 -0400
In-Reply-To: <20130410163912.6303.8705.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a try for expr/match and expr/target to be more XML friendly.

Signed-off-by: Arturo Borrero Gonz=C3=A1lez <arturo.borrero.glez@gmail.=
com>
---
 src/expr/match.c  |    6 +++---
 src/expr/target.c |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/src/expr/match.c b/src/expr/match.c
index f83a8ea..d1f5963 100644
--- a/src/expr/match.c
+++ b/src/expr/match.c
@@ -193,12 +193,12 @@ int nft_rule_expr_match_snprintf_xml(char *buf, s=
ize_t len,
 	int offset =3D 0;
 	uint8_t *data =3D (uint8_t *)mt->data;
=20
-	ret =3D snprintf(buf, len, "\t\t<name>%s</name> <rev>%u</rev> <info>0=
x",
-				mt->name, mt->rev);
+	ret =3D snprintf(buf, len, "\t\t<name>%s</name> <rev>%u</rev> <info><=
len>%u</len>",
+				mt->name, mt->rev, mt->data_len);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 	for (i=3D0; i < mt->data_len; i++) {
-	        ret =3D snprintf(buf+offset, len, "%x", data[i] & 0xff);
+	        ret =3D snprintf(buf+offset, len, "<data%d>0x%.2x</data%d>",i=
, data[i] & 0xff, i);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
=20
diff --git a/src/expr/target.c b/src/expr/target.c
index 86c9bc8..aae58ce 100644
--- a/src/expr/target.c
+++ b/src/expr/target.c
@@ -193,12 +193,12 @@ int nft_rule_exp_target_snprintf_xml(char *buf, s=
ize_t len,
 	int offset =3D 0;
 	uint8_t *data =3D (uint8_t *)tg->data;
=20
-	ret =3D snprintf(buf, len, "\t\t<name>%s</name> <rev>%u</rev> <info>0=
x",
-			tg->name, tg->rev);
+	ret =3D snprintf(buf, len, "\t\t<name>%s</name> <rev>%u</rev> <info><=
len>%u</len>",
+			tg->name, tg->rev, tg->data_len);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 	for (i=3D0; i < tg->data_len; i++) {
-		ret =3D snprintf(buf+offset, len, "%x", data[i] & 0xff);
+		ret =3D snprintf(buf+offset, len, "<data%d>0x%.2x</data%d>",i, data[=
i] & 0xff, i);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
=20

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
