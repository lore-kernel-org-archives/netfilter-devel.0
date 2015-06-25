From: pfeiffer.szilard@balabit.hu
Subject: [PATCH 1/2] conntrack: refactor handling of address options
Date: Thu, 25 Jun 2015 12:22:10 +0200
Message-ID: <1435227731-15872-2-git-send-email-pfeiffer.szilard@balabit.hu>
References: <1435227731-15872-1-git-send-email-pfeiffer.szilard@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pfeiffer.szilard@balabit.hu
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from hq.balabit.com ([195.56.155.161]:38980 "EHLO mail.balabit.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932422AbbFYKWP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Jun 2015 06:22:15 -0400
In-Reply-To: <1435227731-15872-1-git-send-email-pfeiffer.szilard@balabit.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Szil=C3=A1rd Pfeiffer <pfeiffer.szilard@balabit.hu>

Signed-off-by: Szil=C3=A1rd Pfeiffer <pfeiffer.szilard@balabit.hu>
---
 src/conntrack.c | 69 ++++++++++++++++++++++++++-----------------------=
--------
 1 file changed, 32 insertions(+), 37 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index b1a2589..4b22e75 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -437,6 +437,10 @@ static const int opt2attr[] =3D {
 	['d']	=3D ATTR_ORIG_L3PROTO,
 	['r']	=3D ATTR_REPL_L3PROTO,
 	['q']	=3D ATTR_REPL_L3PROTO,
+	['{']	=3D ATTR_ORIG_L3PROTO,
+	['}']	=3D ATTR_ORIG_L3PROTO,
+	['[']	=3D ATTR_ORIG_L3PROTO,
+	[']']	=3D ATTR_ORIG_L3PROTO,
 	['m']	=3D ATTR_MARK,
 	['c']	=3D ATTR_SECMARK,
 	['i']	=3D ATTR_ID,
@@ -1952,6 +1956,31 @@ static void merge_bitmasks(struct nfct_bitmask *=
*current,
 	nfct_bitmask_destroy(src);
 }
=20
+static void=20
+nfct_set_addr_from_opt(int opt, struct nf_conntrack *ct, union ct_addr=
ess *ad,
+		       int *family)
+{
+	int l3protonum;
+
+	options |=3D opt2type[opt];
+	l3protonum =3D parse_addr(optarg, ad);
+	if (l3protonum =3D=3D AF_UNSPEC) {
+		exit_error(PARAMETER_PROBLEM,
+			   "Invalid IP address `%s'", optarg);
+	}
+	set_family(family, l3protonum);
+	if (l3protonum =3D=3D AF_INET) {
+		nfct_set_attr_u32(ct,
+				  opt2family_attr[opt][0],
+				  ad->v4);
+	} else if (l3protonum =3D=3D AF_INET6) {
+		nfct_set_attr(ct,
+			      opt2family_attr[opt][1],
+			      &ad->v6);
+	}
+	nfct_set_attr_u8(ct, opt2attr[opt], l3protonum);
+}
+
 int main(int argc, char *argv[])
 {
 	int c, cmd;
@@ -1959,7 +1988,7 @@ int main(int argc, char *argv[])
 	int res =3D 0, partial;
 	size_t socketbuffersize =3D 0;
 	int family =3D AF_UNSPEC;
-	int l3protonum, protonum =3D 0;
+	int protonum =3D 0;
 	union ct_address ad;
 	unsigned int command =3D 0;
=20
@@ -2030,47 +2059,13 @@ int main(int argc, char *argv[])
 		case 'd':
 		case 'r':
 		case 'q':
-			options |=3D opt2type[c];
-
-			l3protonum =3D parse_addr(optarg, &ad);
-			if (l3protonum =3D=3D AF_UNSPEC) {
-				exit_error(PARAMETER_PROBLEM,
-					   "Invalid IP address `%s'", optarg);
-			}
-			set_family(&family, l3protonum);
-			if (l3protonum =3D=3D AF_INET) {
-				nfct_set_attr_u32(tmpl.ct,
-						  opt2family_attr[c][0],
-						  ad.v4);
-			} else if (l3protonum =3D=3D AF_INET6) {
-				nfct_set_attr(tmpl.ct,
-					      opt2family_attr[c][1],
-					      &ad.v6);
-			}
-			nfct_set_attr_u8(tmpl.ct, opt2attr[c], l3protonum);
+			nfct_set_addr_from_opt(c, tmpl.ct, &ad, &family);
 			break;
 		case '{':
 		case '}':
 		case '[':
 		case ']':
-			options |=3D opt2type[c];
-			l3protonum =3D parse_addr(optarg, &ad);
-			if (l3protonum =3D=3D AF_UNSPEC) {
-				exit_error(PARAMETER_PROBLEM,
-					   "Invalid IP address `%s'", optarg);
-			}
-			set_family(&family, l3protonum);
-			if (l3protonum =3D=3D AF_INET) {
-				nfct_set_attr_u32(tmpl.mask,=20
-						  opt2family_attr[c][0],
-						  ad.v4);
-			} else if (l3protonum =3D=3D AF_INET6) {
-				nfct_set_attr(tmpl.mask,
-					      opt2family_attr[c][1],
-					      &ad.v6);
-			}
-			nfct_set_attr_u8(tmpl.mask,
-					 ATTR_ORIG_L3PROTO, l3protonum);
+			nfct_set_addr_from_opt(c, tmpl.mask, &ad, &family);
 			break;
 		case 'p':
 			options |=3D CT_OPT_PROTO;
--=20
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
