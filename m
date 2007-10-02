From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: [RFC] TCPOPTSTRIP target
Date: Tue, 2 Oct 2007 19:49:06 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710021947170.18802@bizon.gios.gov.pl>
References: <873awz2s7u.fsf@begreifnix.intranet.astaro.de>
 <Pine.LNX.4.64.0709281607250.25099@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0709281643520.25099@fbirervta.pbzchgretzou.qr>
 <46FD1798.2020302@trash.net> <87tzpd266j.fsf@begreifnix.intranet.astaro.de>
 <87hcl91ubt.fsf@begreifnix.intranet.astaro.de> <87abr11tth.fsf@begreifnix.intranet.astaro.de>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-1761716910-1191347346=:18802"
Cc: Patrick McHardy <kaber@trash.net>,
	Jan Engelhardt <jengelh@computergmbh.de>,
	netfilter-devel@vger.kernel.org
To: Sven Schnelle <sschnelle@astaro.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:41963 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966AbXJBRtb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Oct 2007 13:49:31 -0400
In-Reply-To: <87abr11tth.fsf@begreifnix.intranet.astaro.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-1761716910-1191347346=:18802
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Tue, 2 Oct 2007, Sven Schnelle wrote:
> +static const struct option tcpoptstrip_opts[] =3D {
> +=09{ "strip-tcp-options", 1, NULL, OPT_STRIP_OPTIONS },
> +=09{ "strip-wscale", 0, NULL, OPT_STRIP_WSCALE },
> +=09{ "strip-timestamp", 0, NULL, OPT_STRIP_TIMESTAMP },
> +=09{ "strip-mss", 0, NULL, OPT_STRIP_MSS },
> +=09{ "strip-sack", 0, NULL, OPT_STRIP_SACK },
> +=09{ "strip-sack-permitted", 0, NULL, OPT_STRIP_SACK_PERMITTED },
> +=09{ }
> +};
> +
> +/* Function which prints out usage message. */
> +static void tcpoptstrip_help(void)
> +{
> +    printf("TCPOPTSTRIP target options:\n"
> +=09   "  --strip-tcp-options option(s)  strip specified tcp options from=
 TCP Header\n"
> +=09   "  --strip-wscale                 strip windows scaling option\n"
> +=09   "  --strip-timestamp              strip timestamp option\n"
> +=09   "  --strip-mss                    strip mss option\n"
> +=09   "  --strip-sack                   strip sack option\n"
> +=09   "  --strip-sack-permitted         strip sack permitted option\n");
> +

How about something similar to:
  --strip-tcp-options wscale,timestamp,mss
? :)

Like in --dport for example:
  --dport ftp,ssh,telnet,http

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1761716910-1191347346=:18802--
