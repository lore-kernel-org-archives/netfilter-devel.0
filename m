From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH v2 1/2] rule: json: Fixed wrong offset return
Date: Tue, 24 Sep 2013 14:54:10 +0200
Message-ID: <20130924125410.18650.33470.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:34862 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab3IXMyS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Sep 2013 08:54:18 -0400
Received: by mail-wi0-f172.google.com with SMTP id hn9so3735001wib.17
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Sep 2013 05:54:17 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

I have fixed the offset because when i try to print more of one rule,
the json output support only print one rule because this function retur=
n
a wrong offset value

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 src/rule.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/rule.c b/src/rule.c
index e744cf8..e593109 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -748,7 +748,7 @@ static int nft_rule_snprintf_json(char *buf, size_t=
 size, struct nft_rule *r,
 	ret =3D snprintf(buf+offset-1, len, "]}}");
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
-	return offset;
+	return offset-1;
 }
=20
 static int nft_rule_snprintf_xml(char *buf, size_t size, struct nft_ru=
le *r,

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
