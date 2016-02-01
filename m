From: =?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.dk>
Subject: [PATCH conntrack 1/4] conntrack: split up nfct_set_addr_from_opt()
Date: Mon,  1 Feb 2016 13:30:04 +0000
Message-ID: <1454333407-6335-1-git-send-email-ast@fiberby.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org,
	=?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.dk>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.asbjorn.biz ([185.38.24.25]:55842 "EHLO mail.asbjorn.biz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932225AbcBANin (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Feb 2016 08:38:43 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Prepare for CIDR support, by splitting nfct_set_addr_from_opt()
into nfct_parse_addr_from_opt() for parsing
and nfct_set_addr_opt() for storing.

Signed-off-by: Asbj=C3=B8rn Sloth T=C3=B8nnesen <ast@fiberby.dk>
---
 src/conntrack.c | 33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 34785f3..a656b84 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -2083,18 +2083,10 @@ static void merge_bitmasks(struct nfct_bitmask =
**current,
 }
=20
 static void
-nfct_set_addr_from_opt(int opt, struct nf_conntrack *ct, union ct_addr=
ess *ad,
-		       int *family)
+nfct_set_addr_opt(int opt, struct nf_conntrack *ct, union ct_address *=
ad,
+                  int l3protonum)
 {
-	int l3protonum;
-
 	options |=3D opt2type[opt];
-	l3protonum =3D parse_addr(optarg, ad);
-	if (l3protonum =3D=3D AF_UNSPEC) {
-		exit_error(PARAMETER_PROBLEM,
-			   "Invalid IP address `%s'", optarg);
-	}
-	set_family(family, l3protonum);
 	switch(l3protonum) {
 	case AF_INET:
 		nfct_set_attr_u32(ct,
@@ -2110,6 +2102,21 @@ nfct_set_addr_from_opt(int opt, struct nf_conntr=
ack *ct, union ct_address *ad,
 	nfct_set_attr_u8(ct, opt2attr[opt], l3protonum);
 }
=20
+static void
+nfct_parse_addr_from_opt(int opt, struct nf_conntrack *ct,
+                         union ct_address *ad, int *family)
+{
+	int l3protonum;
+
+	l3protonum =3D parse_addr(optarg, ad);
+	if (l3protonum =3D=3D AF_UNSPEC) {
+		exit_error(PARAMETER_PROBLEM,
+			   "Invalid IP address `%s'", optarg);
+	}
+	set_family(family, l3protonum);
+	nfct_set_addr_opt(opt, ct, ad, l3protonum);
+}
+
 int main(int argc, char *argv[])
 {
 	int c, cmd;
@@ -2188,15 +2195,15 @@ int main(int argc, char *argv[])
 		case 'd':
 		case 'r':
 		case 'q':
-			nfct_set_addr_from_opt(c, tmpl.ct, &ad, &family);
+			nfct_parse_addr_from_opt(c, tmpl.ct, &ad, &family);
 			break;
 		case '[':
 		case ']':
-			nfct_set_addr_from_opt(c, tmpl.exptuple, &ad, &family);
+			nfct_parse_addr_from_opt(c, tmpl.exptuple, &ad, &family);
 			break;
 		case '{':
 		case '}':
-			nfct_set_addr_from_opt(c, tmpl.mask, &ad, &family);
+			nfct_parse_addr_from_opt(c, tmpl.mask, &ad, &family);
 			break;
 		case 'p':
 			options |=3D CT_OPT_PROTO;
--=20
2.6.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
