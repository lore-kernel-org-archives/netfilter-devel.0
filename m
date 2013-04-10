From: Arturo Borrero <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 1/5] src: rule: small fix XML output
Date: Wed, 10 Apr 2013 18:39:57 +0200
Message-ID: <20130410163957.6303.44318.stgit@nfdev.cica.es>
References: <20130410163912.6303.8705.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:36331 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S937118Ab3DJQkA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Apr 2013 12:40:00 -0400
In-Reply-To: <20130410163912.6303.8705.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch aplies two fixes:
	* snprintf XML output offset for rule.
	* add XML <flags> node, missing in previous patches.

The <flags> node will be used for parsing a rule in XML.

Signed-off-by: Arturo Borrero Gonz=C3=A1lez <arturo.borrero.glez@gmail.=
com>
---
 src/rule.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index e419b0a..c463c69 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -451,9 +451,10 @@ static int nft_rule_snprintf_xml(char *buf, size_t=
 size, struct nft_rule *r,
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 	ret =3D snprintf(buf+offset, len, "<rule_flags>%u</rule_flags>"
+					"<flags>%u</flags>"
 					"<compat_flags>%u</compat_flags>"
 					"<compat_proto>%u</compat_proto>",
-					r->rule_flags,
+					r->rule_flags, r->flags,
 					r->compat.flags, r->compat.proto);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
@@ -469,7 +470,7 @@ static int nft_rule_snprintf_xml(char *buf, size_t =
size, struct nft_rule *r,
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 	}
-	ret =3D snprintf(buf+offset-1, len, "\n</rule>\n ");
+	ret =3D snprintf(buf+offset, len, "\n</rule>\n ");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 	return ret;

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
