From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH 2/2] chain: json: use string to identify policy
Date: Mon, 15 Jul 2013 21:31:00 +0200
Message-ID: <20130715193100.20241.23433.stgit@Ph0enix>
References: <20130715193052.20241.52862.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:63452 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716Ab3GOTbE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Jul 2013 15:31:04 -0400
Received: by mail-wi0-f172.google.com with SMTP id c10so3294101wiw.5
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Jul 2013 12:31:03 -0700 (PDT)
In-Reply-To: <20130715193052.20241.52862.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

* if we don't have hooknum we don't need to print the policy tag
* If we have hooknum, i have used the policy2str function for printing =
the policy with
"accept" string or "drop" string

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 src/chain.c |   66 ++++++++++++++++++++++++++++++++++++---------------=
--------
 1 file changed, 40 insertions(+), 26 deletions(-)

diff --git a/src/chain.c b/src/chain.c
index bdbaf60..e2738d5 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -717,9 +717,24 @@ int nft_chain_parse(struct nft_chain *c, enum nft_=
chain_parse_type type,
 }
 EXPORT_SYMBOL(nft_chain_parse);
=20
+static const char *policy2str(int policy)
+{
+	switch (policy) {
+	case NF_ACCEPT:
+		return "accept";
+	case NF_DROP:
+		return "drop";
+	default:
+		break;
+	}
+	return "unknown";
+}
+
 static int nft_chain_snprintf_json(char *buf, size_t size, struct nft_=
chain *c)
 {
-	return snprintf(buf, size,
+	int ret, len =3D size, offset =3D 0;
+
+	ret =3D snprintf(buf, size,
 		"{ \"chain\": {"
 			"\"name\": \"%s\","
 			"\"handle\": %"PRIu64","
@@ -727,20 +742,32 @@ static int nft_chain_snprintf_json(char *buf, siz=
e_t size, struct nft_chain *c)
 			"\"packets\": %"PRIu64","
 			"\"version\": %d,"
 			"\"properties\": {"
-				"\"type\" : \"%s\","
-				"\"table\" : \"%s\","
-				"\"prio\" : %d,"
-				"\"use\" : %d,"
-				"\"hooknum\" : \"%s\","
-				"\"policy\" : %d,"
-				"\"family\" : \"%s\""
+				"\"family\": \"%s\","
+				"\"table\": \"%s\","
+				"\"use\": %d",
+			c->name, c->handle, c->bytes, c->packets,
+			NFT_CHAIN_JSON_VERSION, c->table,
+			nft_family2str(c->family), c->use);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	if (c->flags & (1 << NFT_CHAIN_ATTR_HOOKNUM)) {
+		ret =3D  snprintf(buf+offset, size,
+				",\"type\": \"%s\","
+				"\"hooknum\": \"%s\","
+				"\"prio\": %d,"
+				"\"policy\": \"%s\"",
+			c->type, hooknum2str_array[c->hooknum], c->prio,
+			policy2str(c->policy));
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	ret =3D snprintf(buf+offset, size,
 			"}"
 		"}"
-		"}",
-			c->name, c->handle, c->bytes, c->packets,
-			NFT_CHAIN_JSON_VERSION, c->type, c->table,
-			c->prio, c->use, hooknum2str_array[c->hooknum],
-			c->policy, nft_family2str(c->family));
+		"}");
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	return offset;
 }
=20
 static int nft_chain_snprintf_xml(char *buf, size_t size, struct nft_c=
hain *c)
@@ -780,19 +807,6 @@ static int nft_chain_snprintf_xml(char *buf, size_=
t size, struct nft_chain *c)
 	return offset;
 }
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
 static int nft_chain_snprintf_default(char *buf, size_t size,
 				      struct nft_chain *c)
 {

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
