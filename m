From: =?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.dk>
Subject: [PATCH conntrack 2/4 v2] conntrack: extend parse_addr() with CIDR support
Date: Mon,  1 Feb 2016 13:30:05 +0000
Message-ID: <1454333407-6335-2-git-send-email-ast@fiberby.dk>
References: <1454333407-6335-1-git-send-email-ast@fiberby.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org,
	=?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.dk>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.asbjorn.biz ([185.38.24.25]:37325 "EHLO mail.asbjorn.biz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932227AbcBANio (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Feb 2016 08:38:44 -0500
In-Reply-To: <1454333407-6335-1-git-send-email-ast@fiberby.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Asbj=C3=B8rn Sloth T=C3=B8nnesen <ast@fiberby.dk>
---
Previously posted as part of "conntrack: add support for CIDR notation"=
=2E

 src/conntrack.c | 35 ++++++++++++++++++++++++++++-------
 1 file changed, 28 insertions(+), 7 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index a656b84..dfc2de8 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -1029,23 +1029,44 @@ parse_inetaddr(const char *cp, struct addr_pars=
e *parse)
 }
=20
 static int
-parse_addr(const char *cp, union ct_address *address)
+parse_addr(const char *cp, union ct_address *address, int *mask)
 {
 	struct addr_parse parse;
-	int ret;
+	int family;
+	char buf[INET6_ADDRSTRLEN];
+	char *slash, *end;
+
+	strncpy((char *) &buf, cp, INET6_ADDRSTRLEN);
+	buf[INET6_ADDRSTRLEN-1] =3D '\0';
+
+	if (mask !=3D NULL) {
+		slash =3D strchr(buf, '/');
+		if (slash !=3D NULL) {
+			*mask =3D strtol(slash+1, &end, 10);
+			if (*mask < 0 || end !=3D slash+strlen(slash))
+				*mask =3D -2; /* invalid netmask */
+			slash[0] =3D '\0';
+		} else {
+			*mask =3D -1; /* no netmask */
+		}
+	}
=20
-	ret =3D parse_inetaddr(cp, &parse);
+	family =3D parse_inetaddr(buf, &parse);
=20
-	switch(ret) {
+	switch(family) {
 	case AF_INET:
 		address->v4 =3D parse.addr.s_addr;
+		if (mask !=3D NULL && *mask > 32)
+			*mask =3D -2; /* invalid netmask */
 		break;
 	case AF_INET6:
 		memcpy(address->v6, &parse.addr6, sizeof(parse.addr6));
+		if (mask !=3D NULL && *mask > 128)
+			*mask =3D -2; /* invalid netmask */
 		break;
 	}
=20
-	return ret;
+	return family;
 }
=20
 static void
@@ -1087,7 +1108,7 @@ nat_parse(char *arg, struct nf_conntrack *obj, in=
t type)
 		}
 	}
=20
-	if (parse_addr(arg, &parse) =3D=3D AF_UNSPEC) {
+	if (parse_addr(arg, &parse, NULL) =3D=3D AF_UNSPEC) {
 		if (strlen(arg) =3D=3D 0) {
 			exit_error(PARAMETER_PROBLEM, "No IP specified");
 		} else {
@@ -2108,7 +2129,7 @@ nfct_parse_addr_from_opt(int opt, struct nf_connt=
rack *ct,
 {
 	int l3protonum;
=20
-	l3protonum =3D parse_addr(optarg, ad);
+	l3protonum =3D parse_addr(optarg, ad, NULL);
 	if (l3protonum =3D=3D AF_UNSPEC) {
 		exit_error(PARAMETER_PROBLEM,
 			   "Invalid IP address `%s'", optarg);
--=20
2.6.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
