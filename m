From: =?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.dk>
Subject: [PATCH 2/3] conntrack: add support for CIDR notation
Date: Tue, 13 Jan 2015 11:55:11 +0000
Message-ID: <1421150112-3836-3-git-send-email-ast@fiberby.dk>
References: <1421150112-3836-1-git-send-email-ast@fiberby.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.asbjorn.biz ([81.7.185.110]:46375 "EHLO mail.asbjorn.biz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751653AbbAML5L (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Jan 2015 06:57:11 -0500
In-Reply-To: <1421150112-3836-1-git-send-email-ast@fiberby.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add support for using CIDR notation in -s and -d arguments,
instead of free-form formatting IPv6 netmask in --mask-src
and --mask-dst.

Example:
  conntrack -L -s 2001:db8::/56

Instead of:
  conntrack -L -s 2001:db8:: --mask-src ffff:ffff:ffff:ff00::

Signed-off-by: Asbj=C3=B8rn Sloth T=C3=B8nnesen <ast@fiberby.dk>
---
 conntrack.8     |  2 ++
 src/conntrack.c | 86 +++++++++++++++++++++++++++++++++++++++++++++++++=
++++----
 2 files changed, 82 insertions(+), 6 deletions(-)

diff --git a/conntrack.8 b/conntrack.8
index 4bb8bfe..5072839 100644
--- a/conntrack.8
+++ b/conntrack.8
@@ -117,9 +117,11 @@ This option can only be used in conjunction with "=
\-E, \-\-event".
 .TP
 .BI "-s, --orig-src " IP_ADDRESS
 Match only entries whose source address in the original direction equa=
ls the one specified as argument.
+Implies "--mask-src" when CIDR notation is used.
 .TP
 .BI "-d, --orig-dst " IP_ADDRESS
 Match only entries whose destination address in the original direction=
 equals the one specified as argument.
+Implies "--mask-dst" when CIDR notation is used.
 .TP
 .BI "-r, --reply-src " IP_ADDRESS
 Match only entries whose source address in the reply direction equals =
the one specified as argument.
diff --git a/src/conntrack.c b/src/conntrack.c
index ceafb0c..87903b9 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -421,6 +421,13 @@ static const int opt2type[] =3D {
 	['>']	=3D CT_OPT_DEL_LABEL,
 };
=20
+static const char opt2mask[] =3D {
+	['s']	=3D '{',
+	['d']	=3D '}',
+	['r']	=3D 0, /* no netmask */
+	['q']	=3D 0, /* support yet */
+};
+
 static const int opt2family_attr[][2] =3D {
 	['s']	=3D { ATTR_ORIG_IPV4_SRC,	ATTR_ORIG_IPV6_SRC },
 	['d']	=3D { ATTR_ORIG_IPV4_DST,	ATTR_ORIG_IPV6_DST },
@@ -1008,15 +1015,37 @@ parse_inetaddr(const char *cp, struct addr_pars=
e *parse)
 }
=20
 static int
-parse_addr(const char *cp, union ct_address *address)
+parse_addr(const char *cp, union ct_address *address, int *mask)
 {
 	struct addr_parse parse;
 	int ret;
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
+				*mask =3D -2;
+			slash[0] =3D '\0';
+		} else {
+			*mask =3D -1;
+		}
+	}
=20
-	if ((ret =3D parse_inetaddr(cp, &parse)) =3D=3D AF_INET)
+	if ((ret =3D parse_inetaddr(buf, &parse)) =3D=3D AF_INET) {
 		address->v4 =3D parse.addr.s_addr;
-	else if (ret =3D=3D AF_INET6)
+		if (mask !=3D NULL && *mask > 32)
+			*mask =3D -2;
+	} else if (ret =3D=3D AF_INET6) {
 		memcpy(address->v6, &parse.addr6, sizeof(parse.addr6));
+		if (mask !=3D NULL && *mask > 128)
+			*mask =3D -2;
+	}
=20
 	return ret;
 }
@@ -1060,7 +1089,7 @@ nat_parse(char *arg, struct nf_conntrack *obj, in=
t type)
 		}
 	}
=20
-	if (parse_addr(arg, &parse) =3D=3D AF_UNSPEC) {
+	if (parse_addr(arg, &parse, NULL) =3D=3D AF_UNSPEC) {
 		if (strlen(arg) =3D=3D 0) {
 			exit_error(PARAMETER_PROBLEM, "No IP specified");
 		} else {
@@ -2048,6 +2077,24 @@ static void merge_bitmasks(struct nfct_bitmask *=
*current,
 	nfct_bitmask_destroy(src);
 }
=20
+static void
+buildnetmask(uint32_t *dst, int b, int n)
+{
+	int i;
+
+	for (i=3D0;i<n;i++) {
+		if (b >=3D 32) {
+			dst[i] =3D 0xffffffff;
+			b -=3D 32;
+		} else if (b > 0) {
+			dst[i] =3D (1<<b)-1;
+			b =3D 0;
+		} else {
+			dst[i] =3D 0;
+		}
+	}
+}
+
 int main(int argc, char *argv[])
 {
 	int c, cmd;
@@ -2058,6 +2105,7 @@ int main(int argc, char *argv[])
 	int l3protonum, protonum =3D 0;
 	union ct_address ad;
 	unsigned int command =3D 0;
+	int mask, mc;
=20
 	/* we release these objects in the exit_error() path. */
 	if (!alloc_tmpl_objects())
@@ -2128,29 +2176,55 @@ int main(int argc, char *argv[])
 		case 'q':
 			options |=3D opt2type[c];
=20
-			l3protonum =3D parse_addr(optarg, &ad);
+			l3protonum =3D parse_addr(optarg, &ad, &mask);
 			if (l3protonum =3D=3D AF_UNSPEC) {
 				exit_error(PARAMETER_PROBLEM,
 					   "Invalid IP address `%s'", optarg);
 			}
 			set_family(&family, l3protonum);
+			mc =3D opt2mask[c];
+			if (mask !=3D -1 && !mc) {
+				exit_error(PARAMETER_PROBLEM,
+					   "CIDR notation unavailable"
+					   " for `%c'", c);
+			} else if (mask =3D=3D -2) {
+				exit_error(PARAMETER_PROBLEM,
+					   "Invalid netmask");
+			}
 			if (l3protonum =3D=3D AF_INET) {
 				nfct_set_attr_u32(tmpl.ct,
 						  opt2family_attr[c][0],
 						  ad.v4);
+				if (mc) {
+					if (mask >=3D 0 && mask < 32)
+						buildnetmask(&ad.v4, mask, 1);
+					else
+						mc =3D 0;
+				}
 			} else if (l3protonum =3D=3D AF_INET6) {
 				nfct_set_attr(tmpl.ct,
 					      opt2family_attr[c][1],
 					      &ad.v6);
+				if (mc) {
+					if (mask >=3D 0 && mask < 128)
+						buildnetmask((uint32_t *) &ad.v6, mask, 4);
+					else
+						mc =3D 0;
+				}
 			}
 			nfct_set_attr_u8(tmpl.ct, opt2attr[c], l3protonum);
+			if (mc) {
+				c =3D mc;
+				goto set_netmask;
+			}
 			break;
 		case '{':
 		case '}':
 		case '[':
 		case ']':
+			l3protonum =3D parse_addr(optarg, &ad, NULL);
+set_netmask:
 			options |=3D opt2type[c];
-			l3protonum =3D parse_addr(optarg, &ad);
 			if (l3protonum =3D=3D AF_UNSPEC) {
 				exit_error(PARAMETER_PROBLEM,
 					   "Invalid IP address `%s'", optarg);
--=20
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
