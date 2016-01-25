From: =?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.dk>
Subject: [PATCH conntrack 3/5] conntrack: cleanup: use switch statements for family checks
Date: Mon, 25 Jan 2016 11:15:46 +0000
Message-ID: <1453720548-14413-3-git-send-email-ast@fiberby.dk>
References: <1453720548-14413-1-git-send-email-ast@fiberby.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org,
	=?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.dk>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.asbjorn.biz ([185.38.24.25]:45601 "EHLO mail.asbjorn.biz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756547AbcAYLQH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Jan 2016 06:16:07 -0500
In-Reply-To: <1453720548-14413-1-git-send-email-ast@fiberby.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Asbj=C3=B8rn Sloth T=C3=B8nnesen <ast@fiberby.dk>
---
 src/conntrack.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index cb9545b..3fc9c24 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -1017,10 +1017,16 @@ parse_addr(const char *cp, union ct_address *ad=
dress)
 	struct addr_parse parse;
 	int ret;
=20
-	if ((ret =3D parse_inetaddr(cp, &parse)) =3D=3D AF_INET)
+	ret =3D parse_inetaddr(cp, &parse);
+
+	switch(ret) {
+	case AF_INET:
 		address->v4 =3D parse.addr.s_addr;
-	else if (ret =3D=3D AF_INET6)
+		break;
+	case AF_INET6:
 		memcpy(address->v6, &parse.addr6, sizeof(parse.addr6));
+		break;
+	}
=20
 	return ret;
 }
@@ -1966,14 +1972,17 @@ nfct_set_addr_from_opt(int opt, struct nf_connt=
rack *ct, union ct_address *ad,
 			   "Invalid IP address `%s'", optarg);
 	}
 	set_family(family, l3protonum);
-	if (l3protonum =3D=3D AF_INET) {
+	switch(l3protonum) {
+	case AF_INET:
 		nfct_set_attr_u32(ct,
-				  opt2family_attr[opt][0],
-				  ad->v4);
-	} else if (l3protonum =3D=3D AF_INET6) {
+		                  opt2family_attr[opt][0],
+		                  ad->v4);
+		break;
+	case AF_INET6:
 		nfct_set_attr(ct,
-			      opt2family_attr[opt][1],
-			      &ad->v6);
+		              opt2family_attr[opt][1],
+		              &ad->v6);
+		break;
 	}
 	nfct_set_attr_u8(ct, opt2attr[opt], l3protonum);
 }
--=20
2.6.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
