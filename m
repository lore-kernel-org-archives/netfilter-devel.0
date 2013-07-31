From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH 4/7] chain: remove the properties node in Json
 output
Date: Wed, 31 Jul 2013 15:21:12 +0200
Message-ID: <20130731132112.29730.21871.stgit@Ph0enix>
References: <20130731132051.29730.53717.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:59605 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803Ab3GaNVQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:21:16 -0400
Received: by mail-wi0-f173.google.com with SMTP id en1so5500744wid.0
        for <netfilter-devel@vger.kernel.org>; Wed, 31 Jul 2013 06:21:15 -0700 (PDT)
In-Reply-To: <20130731132051.29730.53717.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

I have removed the properties node from chain because it's a node witho=
ut relevant information

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 src/chain.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/src/chain.c b/src/chain.c
index 621794c..7e2567b 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -669,10 +669,9 @@ static int nft_chain_snprintf_json(char *buf, size=
_t size, struct nft_chain *c)
 			"\"handle\": %"PRIu64","
 			"\"bytes\": %"PRIu64","
 			"\"packets\": %"PRIu64","
-			"\"properties\": {"
-				"\"family\": \"%s\","
-				"\"table\": \"%s\","
-				"\"use\": %d",
+			"\"family\": \"%s\","
+			"\"table\": \"%s\","
+			"\"use\": %d",
 			c->name, c->handle, c->bytes, c->packets,
 			nft_family2str(c->family),
 			c->table, c->use);
@@ -690,7 +689,6 @@ static int nft_chain_snprintf_json(char *buf, size_=
t size, struct nft_chain *c)
 	}
=20
 	ret =3D snprintf(buf+offset, size,
-			"}"
 		"}"
 		"}");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
