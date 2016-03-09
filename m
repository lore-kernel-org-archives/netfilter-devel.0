From: Piyush Pangtey <gokuvsvegita@gmail.com>
Subject: [PATCH v2] libxt_multiport: Add translation to nft
Date: Wed, 9 Mar 2016 20:09:27 +0530
Message-ID: <56E0359F.7060308@gmail.com>
References: <20160307212141.GA10594@sonyv> <20160308105346.GB4008@salvia>
 <56DFC995.7090009@gmail.com> <20160309123238.GA30363@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:32941 "EHLO
	mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932767AbcCIOjL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Mar 2016 09:39:11 -0500
Received: by mail-pf0-f196.google.com with SMTP id 129so1022937pfw.0
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Mar 2016 06:39:11 -0800 (PST)
In-Reply-To: <20160309123238.GA30363@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Added full translation for multiport.

Examples :
$ iptables-translate -A INPUT -p tcp -m multiport --ports 3:4  -j ACCEP=
T
nft add rule ip filter INPUT ip protocol tcp tcp dport { 3-4 } tcp spor=
t { 3-4 }
counter accept

$ iptables-translate -A input -p sctp -m multiport --dports 11:18  -j A=
CCEPT
nft add rule ip filter input ip protocol sctp sctp dport { 11-18 } coun=
ter
accept

$ iptables-translate -A input -p dccp -m multiport --ports 11:18  -j AC=
CEPT
nft add rule ip filter input ip protocol dccp dccp dport { 11-18 } dccp=
 sport {
11-18 } counter accept

$ ip6tables-translate -A input -p dccp -m multiport --ports 11:18  -j A=
CCEPT
nft add rule ip6 filter input meta l4proto dccp dccp dport { 11-18 } dc=
cp sport
{ 11-18 } counter accept

Signed-off-by: Piyush Pangtey <gokuvsvegita@gmail.com>
---
v2:
	Corrected the translations , as suggested by Arturo Borrero Gonz=E1lez

 extensions/libxt_multiport.c | 171 +++++++++++++++++++++++++++++++++++=
+++++++-
 1 file changed, 170 insertions(+), 1 deletion(-)

diff --git a/extensions/libxt_multiport.c b/extensions/libxt_multiport.=
c
index 03af5a9..6358ffd 100644
--- a/extensions/libxt_multiport.c
+++ b/extensions/libxt_multiport.c
@@ -18,6 +18,8 @@ enum {
 	F_ANY          =3D F_SOURCE_PORTS | F_DEST_PORTS | F_SD_PORTS,
 };
=20
+static const char *xlate_proto;
+
 /* Function which prints out usage message. */
 static void multiport_help(void)
 {
@@ -150,8 +152,10 @@ check_proto(uint16_t pnum, uint8_t invflags)
 		xtables_error(PARAMETER_PROBLEM,
 			   "multiport only works with TCP, UDP, UDPLITE, SCTP and DCCP");
=20
-	if ((proto =3D proto_to_name(pnum)) !=3D NULL)
+	if ((proto =3D proto_to_name(pnum)) !=3D NULL){
+		xlate_proto =3D proto;
 		return proto;
+	}
 	else if (!pnum)
 		xtables_error(PARAMETER_PROBLEM,
 			   "multiport needs `-p tcp', `-p udp', `-p udplite', "
@@ -468,6 +472,167 @@ static void multiport_save6_v1(const void *ip_voi=
d,
 	__multiport_save_v1(match, ip->proto);
 }
=20
+static int multiport_xlate(const struct xt_entry_match *match, struct =
xt_xlate *xl,
+		       int numeric)
+{
+	const struct xt_multiport_v1 *multiinfo =3D
+		(const struct xt_multiport_v1 *)match->data;
+	unsigned int i;
+	bool have_multiple =3D false, have_invert =3D false;
+
+	if(xlate_proto !=3D NULL){
+		if (multiinfo->count > 1)
+			have_multiple =3D true;
+		if (multiinfo->invert)
+			have_invert =3D true;
+		if (xlate_proto =3D=3D NULL || (have_multiple && have_invert))
+			return 0;
+
+		switch (multiinfo->flags) {
+		case XT_MULTIPORT_SOURCE:
+			xt_xlate_add(xl,"sport %s%s",
+				    (have_invert =3D=3D true) ? "!=3D " : "",
+				    (have_multiple =3D=3D true) ? "{ " : "");
+			for (i =3D 0; i < multiinfo->count; i++) {
+				xt_xlate_add(xl, "%s", i ? "," : "");
+				xt_xlate_add(xl, "%u", multiinfo->ports[i]);
+			}
+			break;
+
+		case XT_MULTIPORT_DESTINATION:
+			xt_xlate_add(xl,"dport %s%s",
+				    (have_invert =3D=3D true) ? "!=3D " : "",
+				    (have_multiple =3D=3D true) ? "{ " : "");
+			for (i =3D 0; i < multiinfo->count; i++) {
+				xt_xlate_add(xl, "%s", i ? "," : "");
+				xt_xlate_add(xl, "%u", multiinfo->ports[i]);
+			}
+			break;
+
+		case XT_MULTIPORT_EITHER:
+			xt_xlate_add(xl,"dport %s%s",
+				    (have_invert =3D=3D true) ? "!=3D " : "",
+				    (have_multiple =3D=3D true) ? "{ " : "");
+			for (i =3D 0; i < multiinfo->count; i++) {
+				xt_xlate_add(xl, "%s", i ? "," : "");
+				xt_xlate_add(xl, "%u", multiinfo->ports[i]);
+			}
+			if (have_multiple)
+				xt_xlate_add(xl, " } ");
+			else
+				xt_xlate_add(xl, " ");
+
+			xt_xlate_add(xl,"%s sport %s%s", xlate_proto,
+				    (have_invert =3D=3D true) ? "!=3D " : "",
+				    (have_multiple =3D=3D true) ? "{ " : "");
+			for (i =3D 0; i < multiinfo->count; i++) {
+				xt_xlate_add(xl, "%s", i ? "," : "");
+				xt_xlate_add(xl, "%u", multiinfo->ports[i]);
+			}
+			break;
+
+
+		default:
+			return 0;
+		}
+		if (have_multiple)
+			xt_xlate_add(xl, " } ");
+		else
+			xt_xlate_add(xl, " ");
+	}
+
+
+	return 1;
+}
+
+static int multiport_xlate_v1(const struct xt_entry_match *match, stru=
ct xt_xlate *xl,
+		       int numeric)
+{
+	const struct xt_multiport_v1 *multiinfo =3D
+		(const struct xt_multiport_v1 *)match->data;
+	unsigned int i;
+	bool have_multiple =3D false, have_invert =3D false ;
+
+	if(xlate_proto !=3D NULL){
+		if (multiinfo->count > 1)
+			have_multiple =3D true;
+		if (multiinfo->invert)
+			have_invert =3D true;
+		if (xlate_proto =3D=3D NULL || (have_multiple && have_invert))
+			return 0;
+
+		switch (multiinfo->flags) {
+		case XT_MULTIPORT_SOURCE:
+			xt_xlate_add(xl,"%s sport %s%s", xlate_proto,
+				    (have_invert =3D=3D true) ? "!=3D " : "",
+				    (have_multiple =3D=3D true) ? "{ " : "");
+			for (i =3D 0; i < multiinfo->count; i++) {
+				xt_xlate_add(xl, "%s", i ? "," : "");
+				xt_xlate_add(xl, "%u", multiinfo->ports[i]);
+		 	        if (multiinfo->pflags[i]) {
+				            xt_xlate_add(xl,"-%u",
+				            		multiinfo->ports[++i]);
+				}
+			}
+			break;
+
+		case XT_MULTIPORT_DESTINATION:
+			xt_xlate_add(xl,"%s dport %s%s", xlate_proto,
+				    (have_invert =3D=3D true) ? "!=3D " : "",
+				    (have_multiple =3D=3D true) ? "{ " : "");
+			for (i =3D 0; i < multiinfo->count; i++) {
+				xt_xlate_add(xl, "%s", i ? "," : "");
+				xt_xlate_add(xl, "%u", multiinfo->ports[i]);
+		 	        if (multiinfo->pflags[i]) {
+				            xt_xlate_add(xl,"-%u",
+				            		multiinfo->ports[++i]);
+				}
+			}
+			break;
+
+		case XT_MULTIPORT_EITHER:
+			xt_xlate_add(xl,"%s dport %s%s", xlate_proto,
+				    (have_invert =3D=3D true) ? "!=3D " : "",
+				    (have_multiple =3D=3D true) ? "{ " : "");
+			for (i =3D 0; i < multiinfo->count; i++) {
+				xt_xlate_add(xl, "%s", i ? "," : "");
+				xt_xlate_add(xl, "%u", multiinfo->ports[i]);
+		 	        if (multiinfo->pflags[i]) {
+				            xt_xlate_add(xl,"-%u",
+				            		multiinfo->ports[++i]);
+				}
+			}
+			if (have_multiple)
+				xt_xlate_add(xl, " } ");
+			else
+				xt_xlate_add(xl, " ");
+
+			xt_xlate_add(xl,"%s sport %s%s", xlate_proto,
+				    (have_invert =3D=3D true) ? "!=3D " : "",
+				    (have_multiple =3D=3D true) ? "{ " : "");
+			for (i =3D 0; i < multiinfo->count; i++) {
+				xt_xlate_add(xl, "%s", i ? "," : "");
+				xt_xlate_add(xl, "%u", multiinfo->ports[i]);
+		 	        if (multiinfo->pflags[i]) {
+				            xt_xlate_add(xl,"-%u",
+				            		multiinfo->ports[++i]);
+				}
+			}
+			break;
+
+		default:
+			return 0;
+		}
+		if (have_multiple)
+			xt_xlate_add(xl, " } ");
+		else
+			xt_xlate_add(xl, " ");
+	}
+
+
+	return 1;
+}
+
 static struct xtables_match multiport_mt_reg[] =3D {
 	{
 		.family        =3D NFPROTO_IPV4,
@@ -482,6 +647,7 @@ static struct xtables_match multiport_mt_reg[] =3D =
{
 		.print         =3D multiport_print,
 		.save          =3D multiport_save,
 		.x6_options    =3D multiport_opts,
+		.xlate	       =3D multiport_xlate,
 	},
 	{
 		.family        =3D NFPROTO_IPV6,
@@ -496,6 +662,7 @@ static struct xtables_match multiport_mt_reg[] =3D =
{
 		.print         =3D multiport_print6,
 		.save          =3D multiport_save6,
 		.x6_options    =3D multiport_opts,
+		.xlate         =3D multiport_xlate,
 	},
 	{
 		.family        =3D NFPROTO_IPV4,
@@ -510,6 +677,7 @@ static struct xtables_match multiport_mt_reg[] =3D =
{
 		.print         =3D multiport_print_v1,
 		.save          =3D multiport_save_v1,
 		.x6_options    =3D multiport_opts,
+		.xlate 	       =3D multiport_xlate_v1,
 	},
 	{
 		.family        =3D NFPROTO_IPV6,
@@ -524,6 +692,7 @@ static struct xtables_match multiport_mt_reg[] =3D =
{
 		.print         =3D multiport_print6_v1,
 		.save          =3D multiport_save6_v1,
 		.x6_options    =3D multiport_opts,
+		.xlate         =3D multiport_xlate_v1,
 	},
 };
=20
--=20
1.9.1
On Wednesday 09 March 2016 06:02 PM, Pablo Neira Ayuso wrote:
> On Wed, Mar 09, 2016 at 12:28:29PM +0530, FaTe wrote:
>> Added translation for the match multiport.
>>
>> Example :
>> $ iptables-translate -A INPUT -p tcp -m multiport --ports 3:4  -j AC=
CEPT
>> nft add rule ip filter INPUT ip protocol tcp dport { 3-4 } tcp sport=
 { 3-4 }
>> counter accept
>>
>> $ iptables-translate -A INPUT -p tcp -m multiport --sports http,ssh,=
ftp  -j
>> ACCEPT
>> nft add rule ip filter INPUT ip protocol tcp sport { 80,22,21 } coun=
ter accept
>>
>> $ iptables-translate -A INPUT -p tcp -m multiport --dports 1024:2048=
  -j ACCEPT
>> nft add rule ip filter INPUT ip protocol tcp dport { 1024-2048 } cou=
nter accept
>>
>> $  iptables-translate -A input -p tcp -m multiport --dports 1024:204=
8,2049:3333
>> -j ACCEPT
>> nft add rule ip filter input ip protocol tcp dport { 1024-2048,2049-=
3333 }
>> counter accept
>=20
> This translation is not correct as it's been discussed in a different
> thread.
>=20
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
