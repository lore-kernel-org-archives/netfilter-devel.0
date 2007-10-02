From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: [RFC] TCPOPTSTRIP target (netfilter)
Date: Tue, 2 Oct 2007 19:56:26 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710021950060.18802@bizon.gios.gov.pl>
References: <873awz2s7u.fsf@begreifnix.intranet.astaro.de>
 <Pine.LNX.4.64.0709281607250.25099@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0709281643520.25099@fbirervta.pbzchgretzou.qr>
 <46FD1798.2020302@trash.net> <87tzpd266j.fsf@begreifnix.intranet.astaro.de>
 <87lkal1ucz.fsf@begreifnix.intranet.astaro.de>
 <Pine.LNX.4.64.0710021612590.7130@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-1871202731-1191347786=:18802"
Cc: Sven Schnelle <sschnelle@astaro.com>,
	Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:58553 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567AbXJBR4s (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Oct 2007 13:56:48 -0400
In-Reply-To: <Pine.LNX.4.64.0710021612590.7130@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-1871202731-1191347786=:18802
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Tue, 2 Oct 2007, Jan Engelhardt wrote:

>> +#ifndef _XT_TCPOPTSTRIP_H
>> +#define _XT_TCPOPTSTRIP_H
>> +
>> +#define OPTION_IS_SET(p, bit) (p)[(bit) >> 3] & 1 << ((bit) & 0x07)
>> +#define SET_OPTION(p, bit) (p)[(bit) >> 3] |=3D 1 << ((bit) & 0x07)
>
> You should probably use <linux/bitmap.h>.
>
>> +struct xt_tcpoptstrip_info {
>> +=09unsigned char tcpoptions[32];
>> +};
>
> And u_int8_t. Better is uint32_t[8], because that is what the linux
> bitops work with. (And, unfortunately, it's buggy so we end up
> continuing to use own macros.)

But with uint32_t you have to remember about big/low-endianism &=20
network/host byte order conversion and stuff. Not sure if that's really=20
better.

Best regards,


 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1871202731-1191347786=:18802--
