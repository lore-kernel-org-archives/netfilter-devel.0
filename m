From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: libxt_TCPOPTSTRIP(iptables) 20071014
Date: Sun, 14 Oct 2007 17:19:46 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710141714420.6777@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0710141622170.22801@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-1410893230-1192375186=:6777"
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, kaber@trash.net
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:42639 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755955AbXJNPTz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 14 Oct 2007 11:19:55 -0400
In-Reply-To: <Pine.LNX.4.64.0710141622170.22801@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-1410893230-1192375186=:6777
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Sun, 14 Oct 2007, Jan Engelhardt wrote:

>
> This version folds in tcp option descriptions.
>
> =3D=3D=3D Patch begins here =3D=3D=3D
>
> Add libxt_TCPOPTSTRIP.
>
> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
<CUT>
> +struct tcp_optionmap {
> +=09const char *name, *desc;
> +=09const int option;
> +};
> +
> +static const struct option tcpoptstrip_opts[] =3D {
> +=09{"strip-options", true, NULL, '0'},
> +=09{NULL},
> +};
> +
> +static const struct tcp_optionmap tcp_optionmap[] =3D {
> +=09{"wscale",         "Window scale",         TCPOPT_WINDOW},
> +=09{"mss",            "Maximum Segment Size", TCPOPT_MAXSEG},
> +=09{"sack-permitted", "SACK permitted",       TCPOPT_SACK_PERMITTED},
> +=09{"sack",           "Selective ACK",        TCPOPT_SACK},
> +=09{"timestamp",      "Timestamp",            TCPOPT_TIMESTAMP},
> +=09{"md5",            "MD5 signature",        TCPOPT_MD5SIG},
> +=09{NULL},
> +};

Ahh, good. Thank you for considering my suggestions.

Just cosmetic: what about making it up to=20
http://www.iana.org/assignments/tcp-parameters:

s/Window scale/Window Scale/
s/SACK permitted/SACK Permitted/
s/MD5 signature/MD5 Signature/

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1410893230-1192375186=:6777--
