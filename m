From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: [PATCH] TCPOPTSTRIP 20071006 (iptables)
Date: Sat, 6 Oct 2007 17:37:59 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710061724370.8864@bizon.gios.gov.pl>
References: <873awz2s7u.fsf@begreifnix.intranet.astaro.de>
 <Pine.LNX.4.64.0709281607250.25099@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0709281643520.25099@fbirervta.pbzchgretzou.qr>
 <46FD1798.2020302@trash.net> <87tzpd266j.fsf@begreifnix.intranet.astaro.de>
 <87hcl91ubt.fsf@begreifnix.intranet.astaro.de> <87abr11tth.fsf@begreifnix.intranet.astaro.de>
 <Pine.LNX.4.64.0710021656510.7130@fbirervta.pbzchgretzou.qr>
 <874ph4bafm.fsf@apollo.sven.bitebene.org> <Pine.LNX.4.64.0710061630310.5969@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0710061700360.5969@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-1080656772-1191685079=:8864"
Cc: Sven Schnelle <svens@bitebene.org>,
	Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:48297 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759415AbXJFPiT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 6 Oct 2007 11:38:19 -0400
In-Reply-To: <Pine.LNX.4.64.0710061700360.5969@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-1080656772-1191685079=:8864
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Sat, 6 Oct 2007, Jan Engelhardt wrote:

> +struct tcp_optionmap_struct {
> +=09const char *name;
> +=09const int option;
+=09const char *desc;
> +};

> +static const struct tcp_optionmap_struct tcp_optionmap[] =3D {
> +=09{"wscale",         TCPOPT_WINDOW},
> +=09{"mss",            TCPOPT_MAXSEG},
> +=09{"sack-permitted", TCPOPT_SACK_PERMITTED},
> +=09{"sack",           TCPOPT_SACK},
> +=09{"timestamp",      TCPOPT_TIMESTAMP},
> +=09{"md5",            TCPOPT_MD5SIG},
> +=09{NULL},
> +};

We could convert spaces into tabs here, plus:

> +=09{"mss",=09=09=09TCPOPT_MAXSEG,=09=09"Maximum Segment Size"},
> +=09{"wscale",=09=09TCPOPT_WINDOW,=09=09"Window Scale"},
> +=09{"sack-permitted",=09TCPOPT_SACK_PERMITTED,=09"SACK Permitted"},
> +=09{"sack",=09=09TCPOPT_SACK,=09=09"SACK"},
> +=09{"timestamp",=09=09TCPOPT_TIMESTAMP,=09"Time Stamp"},
> +=09{"md5",=09=09=09TCPOPT_MD5SIG,=09=09"MD5 Signature"},
> +=09{NULL},

=2E..

> +static void tcpoptstrip_help(void)
> +{
+=09int i;
> +=09printf(
> +"TCPOPTSTRIP target options:\n"
> +"  --strip-options value     strip specified TCP options denoted by valu=
e\n"
> +"                            (separated by comma) from TCP header\n"
> +"  Instead of the numeric value, you can also use the following names:\n=
"
> +=09);

+ =09for (i =3D 0; tcp_optionmap[i].name !=3D NULL; ++i) {
+=09=09printf("\t%s\t%s\n", tcp_optionmap[i].name, tcp_optionmap[i].desc);
+=09};

And remove this:
> +"    mss               strip MSS option\n"
> +"    wscale            strip window scaling option\n"
> +"    sack-permitted    strip \"SACK permitted\" option\n"
> +"    sack              strip SACK option\n"
> +"    timestamp         strip timestamp option\n"
> +"    md5               strip MD5 signature option (RFC2385)\n"
> +=09);

Best regsrds,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1080656772-1191685079=:8864--
