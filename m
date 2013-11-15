From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/2 nft] parser: fix warning on deprecated directive in bison
Date: Fri, 15 Nov 2013 10:06:04 +0100
Message-ID: <1384506365-4342-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49639 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753514Ab3KOJGN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Nov 2013 04:06:13 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

src/parser.y:93.1-13: warning: deprecated directive, use =E2=80=98%name=
-prefix=E2=80=99 [-Wdeprecated]
 %name-prefix=3D"nft_"
 ^^^^^^^^^^^^^
Reported-by: Anatol Pomozov <anatol.pomozov@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser.y |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/parser.y b/src/parser.y
index cfe1e86..a49e5c2 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -90,7 +90,7 @@ static void location_update(struct location *loc, str=
uct location *rhs, int n)
=20
 /* Declaration section */
=20
-%name-prefix=3D"nft_"
+%name-prefix "nft_"
 %debug
 %pure-parser
 %parse-param		{ void *scanner }
--=20
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
