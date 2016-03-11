From: Piyush Pangtey <gokuvsvegita@gmail.com>
Subject: [PATCH v4] extensions: libxt_multiport: Add translation to nft
Date: Fri, 11 Mar 2016 17:06:04 +0530
Message-ID: <20160311113604.GA4217@fate>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:34620 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbcCKLfu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Mar 2016 06:35:50 -0500
Received: by mail-pa0-f67.google.com with SMTP id hj7so8098294pac.1
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Mar 2016 03:35:49 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Added full translation for multiport

Examples :
$ iptables-translate -A input -p tcp -m multiport --ports ssh:http -j A=
CCEPT
nft add rule ip filter input ip protocol tcp tcp dport { ssh - http } t=
cp sport
{ ssh - http } counter accept

$ iptables-translate -A input -p sctp -m multiport --dports 11:18  -j A=
CCEPT
nft add rule ip filter input ip protocol sctp sctp dport { 11 - 18 } co=
unter
accept

$ iptables-translate -A input -p dccp -m multiport --sports 11:18 -j AC=
CEPT
nft add rule ip filter input ip protocol dccp dccp sport { 11 - 18 } co=
unter
accept

$ ip6tables-translate -A input -p udplite -m multiport --sports 11:18 -=
j ACCEPT
nft add rule ip6 filter input meta l4proto udplite udplite sport { 11 -=
 18 }
counter accept

Signed-off-by: Piyush Pangtey <gokuvsvegita@gmail.com>
---
v2:
	Corrected the translations , as suggested by Arturo Borrero Gonz=E1lez

v3:
	Removed static variable trick. Now utilizes ipt_ip and ip6t_ip
	which is now passed to xlate ,from the patch
	http://patchwork.ozlabs.org/patch/595128/

v4:
	Corrected code as per coding style.

Signed-off-by: Piyush Pangtey <gokuvsvegita@gmail.com>
---
 extensions/libxt_multiport.c | 199 +++++++++++++++++++++++++++++++++++=
++++++++
 1 file changed, 199 insertions(+)

diff --git a/extensions/libxt_multiport.c b/extensions/libxt_multiport.=
c
index 03af5a9..61b9917 100644
--- a/extensions/libxt_multiport.c
+++ b/extensions/libxt_multiport.c
@@ -278,6 +278,18 @@ print_port(uint16_t port, uint8_t protocol, int nu=
meric)
 }
=20
 static void
+print_port_xlate(struct xt_xlate *xl, uint16_t port, uint8_t protocol,
+		int numeric)
+{
+	const char *service;
+
+	if (numeric || (service =3D port_to_service(port, protocol)) =3D=3D N=
ULL)
+		xt_xlate_add(xl, "%u", port);
+	else
+		xt_xlate_add(xl, "%s", service);
+}
+
+static void
 __multiport_print(const struct xt_entry_match *match, int numeric,
                   uint16_t proto)
 {
@@ -318,6 +330,21 @@ static void multiport_print(const void *ip_void,
 	__multiport_print(match, numeric, ip->proto);
 }
=20
+static void multiport_print_xlate(const struct xt_entry_match *match,
+				  struct xt_xlate *xl, uint16_t proto,
+				  int numeric)
+{
+	const struct xt_multiport_v1 *multiinfo =3D
+		(const struct xt_multiport_v1 *)match->data;
+	unsigned int i;
+
+	for (i =3D 0; i < multiinfo->count; i++) {
+		xt_xlate_add(xl, "%s", i ? "," : "");
+		print_port_xlate(xl, multiinfo->ports[i],
+				 proto, numeric);
+	}
+}
+
 static void multiport_print6(const void *ip_void,
                              const struct xt_entry_match *match, int n=
umeric)
 {
@@ -372,6 +399,25 @@ static void multiport_print_v1(const void *ip_void=
,
 	__multiport_print_v1(match, numeric, ip->proto);
 }
=20
+static void multiport_print_v1_xlate(const struct xt_entry_match *matc=
h,
+				     struct xt_xlate *xl, uint16_t proto,
+				     int numeric)
+{
+	const struct xt_multiport_v1 *multiinfo =3D
+		(const struct xt_multiport_v1 *)match->data;
+	unsigned int i;
+
+	for (i =3D 0; i < multiinfo->count; i++) {
+		xt_xlate_add(xl, "%s", i ? "," : "");
+		print_port_xlate(xl, multiinfo->ports[i], proto, numeric);
+		if (multiinfo->pflags[i]) {
+			xt_xlate_add(xl, " - ");
+			print_port_xlate(xl, multiinfo->ports[++i],
+					 proto, numeric);
+		}
+	}
+}
+
 static void multiport_print6_v1(const void *ip_void,
                                 const struct xt_entry_match *match, in=
t numeric)
 {
@@ -468,6 +514,155 @@ static void multiport_save6_v1(const void *ip_voi=
d,
 	__multiport_save_v1(match, ip->proto);
 }
=20
+static int __multiport_xlate(const struct xt_entry_match *match,
+			    struct xt_xlate *xl, uint16_t protocol, int numeric)
+{
+	const struct xt_multiport_v1 *multiinfo =3D
+		(const struct xt_multiport_v1 *)match->data;
+	const char *proto_name;
+	bool have_multiple =3D false, have_invert =3D false;
+
+	if ((proto_name =3D proto_to_name(protocol)) !=3D NULL) {
+		if (multiinfo->count > 1) have_multiple =3D true;
+		if (multiinfo->invert) have_invert =3D true;
+		if (have_multiple && have_invert)
+			return 0;
+
+		switch (multiinfo->flags) {
+		case XT_MULTIPORT_SOURCE:
+			xt_xlate_add(xl, "%s sport %s%s", proto_name,
+				    (have_invert =3D=3D true) ? "!=3D " : "",
+				    (have_multiple =3D=3D true) ? "{ " : "");
+			multiport_print_xlate(match, xl, protocol,
+					      numeric);
+			break;
+		case XT_MULTIPORT_DESTINATION:
+			xt_xlate_add(xl, "%s dport %s%s", proto_name,
+				    (have_invert =3D=3D true) ? "!=3D " : "",
+				    (have_multiple =3D=3D true) ? "{ " : "");
+			multiport_print_xlate(match, xl, protocol,
+					      numeric);
+			break;
+		case XT_MULTIPORT_EITHER:
+			xt_xlate_add(xl, "%s dport %s%s", proto_name,
+				    (have_invert =3D=3D true) ? "!=3D " : "",
+				    (have_multiple =3D=3D true) ? "{ " : "");
+			multiport_print_xlate(match, xl, protocol,
+					      numeric);
+			if (have_multiple)
+				xt_xlate_add(xl, " } ");
+			else
+				xt_xlate_add(xl, " ");
+			xt_xlate_add(xl, "%s sport %s%s", proto_name,
+				    (have_invert =3D=3D true) ? "!=3D " : "",
+				    (have_multiple =3D=3D true) ? "{ " : "");
+			multiport_print_xlate(match, xl, protocol,
+					      numeric);
+			break;
+		default:
+			return 0;
+		}
+		if (have_multiple)
+			xt_xlate_add(xl, " } ");
+		else
+			xt_xlate_add(xl, " ");
+	}
+
+	return 1;
+}
+
+static int __multiport_xlate_v1(const struct xt_entry_match *match,
+			        struct xt_xlate *xl, uint16_t protocol,
+				int numeric)
+{
+	const struct xt_multiport_v1 *multiinfo =3D
+		(const struct xt_multiport_v1 *)match->data;
+	const char *proto_name;
+	bool have_multiple =3D false, have_invert =3D false;
+
+	if ((proto_name =3D proto_to_name(protocol)) !=3D NULL) {
+		if (multiinfo->count > 1)
+			have_multiple =3D true;
+		if (multiinfo->invert)
+			have_invert =3D true;
+		if (have_multiple && have_invert)
+			return 0;
+
+		switch (multiinfo->flags) {
+		case XT_MULTIPORT_SOURCE:
+			xt_xlate_add(xl, "%s sport %s%s", proto_name,
+				    (have_invert =3D=3D true) ? "!=3D " : "",
+				    (have_multiple =3D=3D true) ? "{ " : "");
+			multiport_print_v1_xlate(match, xl, protocol,
+						 numeric);
+			break;
+		case XT_MULTIPORT_DESTINATION:
+			xt_xlate_add(xl, "%s dport %s%s", proto_name,
+				    (have_invert =3D=3D true) ? "!=3D " : "",
+				    (have_multiple =3D=3D true) ? "{ " : "");
+			multiport_print_v1_xlate(match, xl, protocol,
+						 numeric);
+			break;
+		case XT_MULTIPORT_EITHER:
+			xt_xlate_add(xl, "%s dport %s%s", proto_name,
+				    (have_invert =3D=3D true) ? "!=3D " : "",
+				    (have_multiple =3D=3D true) ? "{ " : "");
+			multiport_print_v1_xlate(match, xl, protocol,
+						 numeric);
+			if (have_multiple)
+				xt_xlate_add(xl, " } ");
+			else
+				xt_xlate_add(xl, " ");
+			xt_xlate_add(xl, "%s sport %s%s", proto_name,
+				    (have_invert =3D=3D true) ? "!=3D " : "",
+				    (have_multiple =3D=3D true) ? "{ " : "");
+			multiport_print_v1_xlate(match, xl, protocol,
+						 numeric);
+			break;
+		default:
+			return 0;
+		}
+		if (have_multiple)
+			xt_xlate_add(xl, " } ");
+		else
+			xt_xlate_add(xl, " ");
+	}
+
+	return 1;
+}
+
+static int multiport_xlate(const void *ip_void,
+			   const struct xt_entry_match *match,
+			   struct xt_xlate *xl, int numeric)
+{
+	const struct ipt_ip *ip =3D ip_void;
+	return __multiport_xlate(match, xl, ip->proto, numeric);
+}
+
+static int multiport_xlate6(const void *ip_void,
+			    const struct xt_entry_match *match,
+			    struct xt_xlate *xl, int numeric)
+{
+	const struct ip6t_ip6 *ip =3D ip_void;
+	return __multiport_xlate(match, xl, ip->proto, numeric);
+}
+
+static int multiport_xlate_v1(const void *ip_void,
+			      const struct xt_entry_match *match,
+			      struct xt_xlate *xl, int numeric)
+{
+	const struct ipt_ip *ip =3D ip_void;
+	return __multiport_xlate_v1(match, xl, ip->proto, numeric);
+}
+
+static int multiport_xlate6_v1(const void *ip_void,
+			       const struct xt_entry_match *match,
+			       struct xt_xlate *xl, int numeric)
+{
+	const struct ip6t_ip6 *ip =3D ip_void;
+	return __multiport_xlate_v1(match, xl, ip->proto, numeric);
+}
+
 static struct xtables_match multiport_mt_reg[] =3D {
 	{
 		.family        =3D NFPROTO_IPV4,
@@ -482,6 +677,7 @@ static struct xtables_match multiport_mt_reg[] =3D =
{
 		.print         =3D multiport_print,
 		.save          =3D multiport_save,
 		.x6_options    =3D multiport_opts,
+		.xlate         =3D multiport_xlate,
 	},
 	{
 		.family        =3D NFPROTO_IPV6,
@@ -496,6 +692,7 @@ static struct xtables_match multiport_mt_reg[] =3D =
{
 		.print         =3D multiport_print6,
 		.save          =3D multiport_save6,
 		.x6_options    =3D multiport_opts,
+		.xlate         =3D multiport_xlate6,
 	},
 	{
 		.family        =3D NFPROTO_IPV4,
@@ -510,6 +707,7 @@ static struct xtables_match multiport_mt_reg[] =3D =
{
 		.print         =3D multiport_print_v1,
 		.save          =3D multiport_save_v1,
 		.x6_options    =3D multiport_opts,
+		.xlate         =3D multiport_xlate_v1,
 	},
 	{
 		.family        =3D NFPROTO_IPV6,
@@ -524,6 +722,7 @@ static struct xtables_match multiport_mt_reg[] =3D =
{
 		.print         =3D multiport_print6_v1,
 		.save          =3D multiport_save6_v1,
 		.x6_options    =3D multiport_opts,
+		.xlate         =3D multiport_xlate6_v1,
 	},
 };
=20
--=20
1.9.1


--=20

With regards,
Piyush Pangtey <gokuvsvegita@gmail.com>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
