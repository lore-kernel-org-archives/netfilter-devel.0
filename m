From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH 04/13] src: fix display of compat_flag and
 compat_proto
Date: Fri, 09 Aug 2013 13:12:32 +0200
Message-ID: <20130809111232.29819.34259.stgit@Ph0enix>
References: <20130809111148.29819.95689.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:43540 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967573Ab3HILMl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Aug 2013 07:12:41 -0400
Received: by mail-wg0-f41.google.com with SMTP id l18so1398507wgh.2
        for <netfilter-devel@vger.kernel.org>; Fri, 09 Aug 2013 04:12:40 -0700 (PDT)
In-Reply-To: <20130809111148.29819.95689.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

=46ixed display compat_proto value and compat_flag if available

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 src/rule.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index 9d6a996..41534bd 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -633,9 +633,10 @@ static int nft_rule_snprintf_json(char *buf, size_=
t size, struct nft_rule *r,
 					r->rule_flags);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
-	if(NFT_RULE_ATTR_COMPAT_PROTO !=3D 0 || NFT_RULE_ATTR_COMPAT_FLAGS !=3D=
 0){
+	if (r->flags & (1 << NFT_RULE_ATTR_COMPAT_PROTO) ||
+	    r->flags & (1 << NFT_RULE_ATTR_COMPAT_FLAGS)) {
 		ret =3D snprintf(buf+offset,len,"\"compat_flags\" : %u, "
-									  "\"compat_proto\" : %u, ",
+					      "\"compat_proto\" : %u, ",
 					r->compat.flags, r->compat.proto);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
