From: =?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.dk>
Subject: [PATCH conntrack 3/4 v2] conntrack: add support for CIDR notation
Date: Mon,  1 Feb 2016 13:30:06 +0000
Message-ID: <1454333407-6335-3-git-send-email-ast@fiberby.dk>
References: <1454333407-6335-1-git-send-email-ast@fiberby.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org,
	=?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.dk>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.asbjorn.biz ([185.38.24.25]:58549 "EHLO mail.asbjorn.biz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932183AbcBANio (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Feb 2016 08:38:44 -0500
In-Reply-To: <1454333407-6335-1-git-send-email-ast@fiberby.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add support for using CIDR notation in --{orig,tuple}-{src,dst} argumen=
ts,
instead of free-form formatting netmask in --mask-{src,dst}.

Example:
  conntrack -L -s 2001:db8::/56

Instead of:
  conntrack -L -s 2001:db8:: --mask-src ffff:ffff:ffff:ff00::

Signed-off-by: Asbj=C3=B8rn Sloth T=C3=B8nnesen <ast@fiberby.dk>
---
 conntrack.8     |  4 +++
 src/conntrack.c | 86 +++++++++++++++++++++++++++++++++++++++++++++++++=
++++----
 2 files changed, 85 insertions(+), 5 deletions(-)

diff --git a/conntrack.8 b/conntrack.8
index 5bba1b1..f2c1ca5 100644
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
@@ -186,9 +188,11 @@ See iptables CT target for more information.
 .TP
 .BI "--tuple-src " IP_ADDRESS
 Specify the tuple source address of an expectation.
+Implies "--mask-src" when CIDR notation is used.
 .TP
 .BI "--tuple-dst " IP_ADDRESS
 Specify the tuple destination address of an expectation.
+Implies "--mask-dst" when CIDR notation is used.
 .TP
 .BI "--mask-src " IP_ADDRESS
 Specify the source address mask.
diff --git a/src/conntrack.c b/src/conntrack.c
index dfc2de8..d8b60a4 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -434,6 +434,17 @@ static const int opt2type[] =3D {
 	[')']	=3D CT_OPT_REPL_ZONE,
 };
=20
+static const int opt2maskopt[] =3D {
+	['s']	=3D '{',
+	['d']	=3D '}',
+	['r']	=3D 0, /* no netmask */
+	['q']	=3D 0, /* support yet */
+	['{']	=3D 0,
+	['}']	=3D 0,
+	['[']	=3D '{',
+	[']']	=3D '}',
+};
+
 static const int opt2family_attr[][2] =3D {
 	['s']	=3D { ATTR_ORIG_IPV4_SRC,	ATTR_ORIG_IPV6_SRC },
 	['d']	=3D { ATTR_ORIG_IPV4_DST,	ATTR_ORIG_IPV6_DST },
@@ -684,6 +695,21 @@ static int bit2cmd(int command)
 	return i;
 }
=20
+static const char *
+get_long_opt(int opt)
+{
+	struct option o;
+	int i;
+
+	for (i =3D 0 ; ; i++) {
+		o =3D opts[i];
+		if (o.name =3D=3D NULL) break;
+		if (o.val =3D=3D opt)
+			return o.name;
+	}
+	return "unknown";
+}
+
 int generic_opt_check(int local_options, int num_opts,
 		      char *optset, const char *optflg[],
 		      unsigned int *coupled_flags, int coupled_flags_size,
@@ -2104,6 +2130,24 @@ static void merge_bitmasks(struct nfct_bitmask *=
*current,
 }
=20
 static void
+nfct_build_netmask(uint32_t *dst, int b, int n)
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
+static void
 nfct_set_addr_opt(int opt, struct nf_conntrack *ct, union ct_address *=
ad,
                   int l3protonum)
 {
@@ -2125,17 +2169,47 @@ nfct_set_addr_opt(int opt, struct nf_conntrack =
*ct, union ct_address *ad,
=20
 static void
 nfct_parse_addr_from_opt(int opt, struct nf_conntrack *ct,
+                         struct nf_conntrack *ctmask,
                          union ct_address *ad, int *family)
 {
-	int l3protonum;
+	int l3protonum, mask, maskopt;
=20
-	l3protonum =3D parse_addr(optarg, ad, NULL);
+	l3protonum =3D parse_addr(optarg, ad, &mask);
 	if (l3protonum =3D=3D AF_UNSPEC) {
 		exit_error(PARAMETER_PROBLEM,
 			   "Invalid IP address `%s'", optarg);
 	}
 	set_family(family, l3protonum);
+	maskopt =3D opt2maskopt[opt];
+	if (!maskopt && mask !=3D -1) {
+		exit_error(PARAMETER_PROBLEM,
+		           "CIDR notation unavailable"
+		           " for `--%s'", get_long_opt(opt));
+	} else if (mask =3D=3D -2) {
+		exit_error(PARAMETER_PROBLEM,
+		           "Invalid netmask");
+	}
+
 	nfct_set_addr_opt(opt, ct, ad, l3protonum);
+
+	/* bail if we don't have a netmask to set*/
+	if (!maskopt || mask =3D=3D -1 || ctmask =3D=3D NULL)
+		return;
+
+	switch(l3protonum) {
+	case AF_INET:
+		if (mask =3D=3D 32)
+			return;
+		nfct_build_netmask(&ad->v4, mask, 1);
+		break;
+	case AF_INET6:
+		if (mask =3D=3D 128)
+			return;
+		nfct_build_netmask((uint32_t *) &ad->v6, mask, 4);
+		break;
+	}
+
+	nfct_set_addr_opt(maskopt, ctmask, ad, l3protonum);
 }
=20
 int main(int argc, char *argv[])
@@ -2216,15 +2290,17 @@ int main(int argc, char *argv[])
 		case 'd':
 		case 'r':
 		case 'q':
-			nfct_parse_addr_from_opt(c, tmpl.ct, &ad, &family);
+			nfct_parse_addr_from_opt(c, tmpl.ct, tmpl.mask,
+			                         &ad, &family);
 			break;
 		case '[':
 		case ']':
-			nfct_parse_addr_from_opt(c, tmpl.exptuple, &ad, &family);
+			nfct_parse_addr_from_opt(c, tmpl.exptuple, tmpl.mask,
+			                         &ad, &family);
 			break;
 		case '{':
 		case '}':
-			nfct_parse_addr_from_opt(c, tmpl.mask, &ad, &family);
+			nfct_parse_addr_from_opt(c, tmpl.mask, NULL, &ad, &family);
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
