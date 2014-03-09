From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [libnftnl PATCH 1/2] src/rule: Removed mandatory attribute printing
 in rules
Date: Sun, 09 Mar 2014 13:59:59 +0100
Message-ID: <20140309125959.23270.43422.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bk0-f41.google.com ([209.85.214.41]:53968 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbaCINAO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Mar 2014 09:00:14 -0400
Received: by mail-bk0-f41.google.com with SMTP id d7so1110935bkh.0
        for <netfilter-devel@vger.kernel.org>; Sun, 09 Mar 2014 06:00:12 -0700 (PDT)
Received: from [127.0.1.1] ([2001:bf0:c001:30:10b9:5ac6:6d77:434d])
        by mx.google.com with ESMTPSA id mc2sm8455390bkb.12.2014.03.09.06.00.11
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 09 Mar 2014 06:00:11 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

Before this patch, the program tried to print some attribute
that maybe the user hasn't defined for printing. We can't
assume that the user want to print some attribute that we have put
mandatory in the rules. Example:

Before this patch, it's mandatory have a rule with family
and this is the output:

{"rule":{"family":"ip","handle":4...
<rule><family>ip</family><handle>4</handle>...

Now, we can print rule without some attribute:

{"rule":{"handle":4...
<rule><handle>4</handle>...

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 src/rule.c |   92 ++++++++++++++++++++++++++++++++++++++++++++++++++++=
--------
 1 file changed, 79 insertions(+), 13 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index 162a0a1..f0cafd3 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -775,12 +775,32 @@ static int nft_rule_snprintf_json(char *buf, size=
_t size, struct nft_rule *r,
 	int ret, len =3D size, offset =3D 0;
 	struct nft_rule_expr *expr;
=20
-	ret =3D snprintf(buf, len, "{\"rule\":{\"family\":\"%s\",\"table\":\"=
%s\","
-				 "\"chain\":\"%s\",\"handle\":%llu,",
-		       nft_family2str(r->family), r->table, r->chain,
-		       (unsigned long long)r->handle);
+	ret =3D snprintf(buf, len, "{\"rule\":{");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
+	if (r->flags & (1 << NFT_RULE_ATTR_FAMILY)) {
+		ret =3D snprintf(buf+offset, len, "\"family\":\"%s\",",
+			       nft_family2str(r->family));
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	if (r->flags & (1 << NFT_RULE_ATTR_TABLE)) {
+		ret =3D snprintf(buf+offset, len, "\"table\":\"%s\",",
+			       r->table);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	if (r->flags & (1 << NFT_RULE_ATTR_CHAIN)) {
+		ret =3D snprintf(buf+offset, len, "\"chain\":\"%s\",",
+			       r->chain);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	if (r->flags & (1 << NFT_RULE_ATTR_HANDLE)) {
+		ret =3D snprintf(buf+offset, len, "\"handle\":%llu,",
+			       (unsigned long long)r->handle);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
 	if (r->flags & (1 << NFT_RULE_ATTR_COMPAT_PROTO) ||
 	    r->flags & (1 << NFT_RULE_ATTR_COMPAT_FLAGS)) {
 		ret =3D snprintf(buf+offset, len, "\"compat_flags\":%u,"
@@ -824,13 +844,32 @@ static int nft_rule_snprintf_xml(char *buf, size_=
t size, struct nft_rule *r,
 	int ret, len =3D size, offset =3D 0;
 	struct nft_rule_expr *expr;
=20
-	ret =3D snprintf(buf, len, "<rule><family>%s</family>"
-		       "<table>%s</table><chain>%s</chain>"
-		       "<handle>%llu</handle>",
-		       nft_family2str(r->family), r->table, r->chain,
-		       (unsigned long long)r->handle);
+	ret =3D snprintf(buf, len, "<rule>");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
+	if (r->flags & (1 << NFT_RULE_ATTR_FAMILY)) {
+		ret =3D snprintf(buf+offset, len, "<family>%s</family>",
+			       nft_family2str(r->family));
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	if (r->flags & (1 << NFT_RULE_ATTR_TABLE)) {
+		ret =3D snprintf(buf+offset, len, "<table>%s</table>",
+			       r->table);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	if (r->flags & (1 << NFT_RULE_ATTR_CHAIN)) {
+		ret =3D snprintf(buf+offset, len, "<chain>%s</chain>",
+			       r->chain);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	if (r->flags & (1 << NFT_RULE_ATTR_HANDLE)) {
+		ret =3D snprintf(buf+offset, len, "<handle>%llu</handle>",
+			       (unsigned long long)r->handle);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
 	if (r->compat.flags !=3D 0 || r->compat.proto !=3D 0) {
 		ret =3D snprintf(buf+offset, len,
 			       "<compat_flags>%u</compat_flags>"
@@ -865,15 +904,42 @@ static int nft_rule_snprintf_xml(char *buf, size_=
t size, struct nft_rule *r,
 	return offset;
 }
=20
-static int nft_rule_snprintf_default(char *buf, size_t size, struct nf=
t_rule *r,=20
+static int nft_rule_snprintf_default(char *buf, size_t size, struct nf=
t_rule *r,
 				     uint32_t type, uint32_t flags)
 {
 	struct nft_rule_expr *expr;
 	int ret, len =3D size, offset =3D 0, i;
=20
-	ret =3D snprintf(buf, len, "%s %s %s %"PRIu64" %"PRIu64"\n",
-			nft_family2str(r->family), r->table, r->chain,
-			r->handle, r->position);
+	if (r->flags & (1 << NFT_RULE_ATTR_FAMILY)) {
+		ret =3D snprintf(buf+offset, len, "%s ",
+			       nft_family2str(r->family));
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	if (r->flags & (1 << NFT_RULE_ATTR_TABLE)) {
+		ret =3D snprintf(buf+offset, len, "%s ",
+			       r->table);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	if (r->flags & (1 << NFT_RULE_ATTR_CHAIN)) {
+		ret =3D snprintf(buf+offset, len, "%s ",
+			       r->chain);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	if (r->flags & (1 << NFT_RULE_ATTR_TABLE)) {
+		ret =3D snprintf(buf+offset, len, "%llu ",
+			       (unsigned long long)r->handle);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	if (r->flags & (1 << NFT_RULE_ATTR_POSITION)) {
+		ret =3D snprintf(buf+offset, len, "%llu ",
+			       (unsigned long long)r->position);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	ret =3D snprintf(buf+offset, len, "\n");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 	list_for_each_entry(expr, &r->expr_list, head) {

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
