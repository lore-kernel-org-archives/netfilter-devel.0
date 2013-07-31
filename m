From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH 1/7] chain: change policy2str function to
 nft_verdict2str function
Date: Wed, 31 Jul 2013 15:20:51 +0200
Message-ID: <20130731132051.29730.53717.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:65097 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab3GaNUz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:20:55 -0400
Received: by mail-wi0-f171.google.com with SMTP id hr7so3884738wib.4
        for <netfilter-devel@vger.kernel.org>; Wed, 31 Jul 2013 06:20:53 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 src/chain.c |   17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/src/chain.c b/src/chain.c
index 14db5f7..621794c 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -659,19 +659,6 @@ int nft_chain_parse(struct nft_chain *c, enum nft_=
chain_parse_type type,
 }
 EXPORT_SYMBOL(nft_chain_parse);
=20
-static const char *policy2str(int policy)
-{
-	switch (policy) {
-	case NF_ACCEPT:
-		return "accept";
-	case NF_DROP:
-		return "drop";
-	default:
-		break;
-	}
-	return "unknown";
-}
-
 static int nft_chain_snprintf_json(char *buf, size_t size, struct nft_=
chain *c)
 {
 	int ret, len =3D size, offset =3D 0;
@@ -698,7 +685,7 @@ static int nft_chain_snprintf_json(char *buf, size_=
t size, struct nft_chain *c)
 				"\"prio\": %d,"
 				"\"policy\": \"%s\"",
 			c->type, hooknum2str_array[c->hooknum], c->prio,
-			policy2str(c->policy));
+			nft_verdict2str(c->policy));
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
=20
@@ -762,7 +749,7 @@ static int nft_chain_snprintf_default(char *buf, si=
ze_t size,
 			       " type %s hook %s prio %d policy %s use %d "
 			       "packets %"PRIu64" bytes %"PRIu64"",
 			       c->type, hooknum2str_array[c->hooknum], c->prio,
-			       policy2str(c->policy), c->use,
+			       nft_verdict2str(c->policy), c->use,
 			       c->packets, c->bytes);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
