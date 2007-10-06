From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 1/1] TCPOPTSTRIP 20071006 descriptions (iptables)
Date: Sat, 6 Oct 2007 17:52:35 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710061740180.5969@fbirervta.pbzchgretzou.qr>
References: <873awz2s7u.fsf@begreifnix.intranet.astaro.de>
 <Pine.LNX.4.64.0709281607250.25099@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0709281643520.25099@fbirervta.pbzchgretzou.qr>
 <46FD1798.2020302@trash.net> <87tzpd266j.fsf@begreifnix.intranet.astaro.de>
 <87hcl91ubt.fsf@begreifnix.intranet.astaro.de> <87abr11tth.fsf@begreifnix.intranet.astaro.de>
 <Pine.LNX.4.64.0710021656510.7130@fbirervta.pbzchgretzou.qr>
 <874ph4bafm.fsf@apollo.sven.bitebene.org> <Pine.LNX.4.64.0710061630310.5969@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0710061700360.5969@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0710061724370.8864@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Sven Schnelle <svens@bitebene.org>,
	Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:44988 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759446AbXJFPwi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 6 Oct 2007 11:52:38 -0400
In-Reply-To: <Pine.LNX.4.64.0710061724370.8864@bizon.gios.gov.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Oct 6 2007 17:37, Krzysztof Oledzki wrote:
>
>> +struct tcp_optionmap_struct {
>> +	const char *name;
>> +	const int option;
> +	const char *desc;
>> +};
>
>> +static const struct tcp_optionmap_struct tcp_optionmap[] =3D {
>> +	{"wscale",         TCPOPT_WINDOW},
>> +	{"mss",            TCPOPT_MAXSEG},
>> +	{"sack-permitted", TCPOPT_SACK_PERMITTED},
>> +	{"sack",           TCPOPT_SACK},
>> +	{"timestamp",      TCPOPT_TIMESTAMP},
>> +	{"md5",            TCPOPT_MD5SIG},
>> +	{NULL},
>> +};
>
> We could convert spaces into tabs here, plus:

We should not, because that would break alignment.
When adhering to the indent-is-not-alignment distinction (see the one o=
r
other CodingStyle debate on lkml), people can set their tab width to
their preferred value, while code does not look bad with other tab widt=
hs.
Only remaining requirement then is that it fits into 80 when \t width i=
s 8,
which is easy; so the overall situation is a plus.

>> +	{"mss",			TCPOPT_MAXSEG,		"Maximum Segment
>> Size"},
>> +	{"wscale",		TCPOPT_WINDOW,		"Window Scale"},
>> +	{"sack-permitted",	TCPOPT_SACK_PERMITTED,	"SACK Permitted"},
>> +	{"sack",		TCPOPT_SACK,		"SACK"},
>> +	{"timestamp",		TCPOPT_TIMESTAMP,	"Time Stamp"},
>> +	{"md5",			TCPOPT_MD5SIG,		"MD5 Signature"},
>> +	{NULL},

=3D=3D

The following patch implements option descriptions after a
suggestion by Krzysztof Ol=C4=99dzki. It goes _on top_ of the
afore-posted libxt_TCPOPTSTRIP patch.

=3D=3D patch begins here =3D=3D

Replace the manually typed help by option description fields.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 extensions/libxt_TCPOPTSTRIP.c |   29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

Index: iptables/extensions/libxt_TCPOPTSTRIP.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- iptables.orig/extensions/libxt_TCPOPTSTRIP.c
+++ iptables/extensions/libxt_TCPOPTSTRIP.c
@@ -19,8 +19,8 @@ enum {
 	F_STRIP =3D 1 << 0,
 };
=20
-struct tcp_optionmap_struct {
-	const char *name;
+struct tcp_optionmap {
+	const char *name, *desc;
 	const int option;
 };
=20
@@ -29,30 +29,29 @@ static const struct option tcpoptstrip_o
 	{NULL},
 };
=20
-static const struct tcp_optionmap_struct tcp_optionmap[] =3D {
-	{"wscale",         TCPOPT_WINDOW},
-	{"mss",            TCPOPT_MAXSEG},
-	{"sack-permitted", TCPOPT_SACK_PERMITTED},
-	{"sack",           TCPOPT_SACK},
-	{"timestamp",      TCPOPT_TIMESTAMP},
-	{"md5",            TCPOPT_MD5SIG},
+static const struct tcp_optionmap tcp_optionmap[] =3D {
+	{"wscale",         "Window scale",         TCPOPT_WINDOW},
+	{"mss",            "Maximum Segment Size", TCPOPT_MAXSEG},
+	{"sack-permitted", "SACK permitted",       TCPOPT_SACK_PERMITTED},
+	{"sack",           "Selective ACK",        TCPOPT_SACK},
+	{"timestamp",      "Timestamp",            TCPOPT_TIMESTAMP},
+	{"md5",            "MD5 signature",        TCPOPT_MD5SIG},
 	{NULL},
 };
=20
 static void tcpoptstrip_help(void)
 {
+	const struct tcp_optionmap *w;
+
 	printf(
 "TCPOPTSTRIP target options:\n"
 "  --strip-options value     strip specified TCP options denoted by va=
lue\n"
 "                            (separated by comma) from TCP header\n"
 "  Instead of the numeric value, you can also use the following names:=
\n"
-"    mss               strip MSS option\n"
-"    wscale            strip window scaling option\n"
-"    sack-permitted    strip \"SACK permitted\" option\n"
-"    sack              strip SACK option\n"
-"    timestamp         strip timestamp option\n"
-"    md5               strip MD5 signature option (RFC2385)\n"
 	);
+
+	for (w =3D tcp_optionmap; w->name !=3D NULL; ++w)
+		printf("    %-14s    strip \"%s\" option\n", w->name, w->desc);
 }
=20
 static void tcpoptstrip_init(struct xt_entry_target *t)
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
