From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: [RFC] TCPOPTSTRIP target
Date: Sat, 29 Sep 2007 19:23:59 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0709291841530.29204@bizon.gios.gov.pl>
References: <873awz2s7u.fsf@begreifnix.intranet.astaro.de>
 <Pine.LNX.4.64.0709281607250.25099@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0709281643520.25099@fbirervta.pbzchgretzou.qr>
 <46FD1798.2020302@trash.net> <87tzpd266j.fsf@begreifnix.intranet.astaro.de>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-1542021634-1191086639=:29204"
Cc: Patrick McHardy <kaber@trash.net>,
	Jan Engelhardt <jengelh@computergmbh.de>,
	netfilter-devel@vger.kernel.org
To: Sven Schnelle <svens@bitebene.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:52130 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbXI2RYN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 29 Sep 2007 13:24:13 -0400
In-Reply-To: <87tzpd266j.fsf@begreifnix.intranet.astaro.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-1542021634-1191086639=:29204
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Sat, 29 Sep 2007, Sven Schnelle wrote:

> Patrick McHardy <kaber@trash.net> writes:
>
>> Jan Engelhardt wrote:
>>> Since I had nothing better to do, I did a cleanup :)
>>
>> Great :) My main question is what the use case of this is.
>
> Main intention for writing this module was to strip of TCP Options from
> the SYN packets sent by some Hosts - for example Hosts that are
> announcing that they can do window scaling, but in fact some broken
> implementation/routers inbetween are preventing this. Simply stripping
> of these Option allows communicating with such device, without the need
> to disable window scaling kernel-wide.

Another example may be sack & broken fw/nats. BTW: it is possible to=20
disable window scaling by simply adding a route with a window attribute.
This unfortunately works only on a host that initiates a connection,
so this is not an option when you have some Windows workstations behind a=
=20
firewall.

> The first version was only stripping the Windows scaling option, but it
> may be useful for other cases - so i decided to make the stripped option
> configurable.

It is quite funny as I have also started working on similar target,=20
mainly to solve this sack problem.

>> Seems to be copied from TCPMSS - but I don't see why you shouldn't allow
>> stripping options from packets with data.
>
> Indeed, i've used xt_TCPMSS.c as some kind of template. Could be removed
> of course.

But the documentation should mention that it is often better to strip
for example sackok from a syn packet than sack from a packet with data.

>> For TCPOPTSTRIP I would expect either real stripping or replacement
>> by TCPOPT_NOP. In which cases does replacement by something else
>> make sense?
>
> It does replacement by TCPOPT_NOP - the newopt is a const
> TCPOPT_NOP. But i've changed this with the checksum code above.
> Of course we can choose another name which describes the task of this
> target better - didn't care much about it the name in the first case.
>
> I think replacing the TCP Option by nop is cheaper than moving all
> remaining options.

Indeed, especially that with moving, it would be nice to keep
alignments.

BTW: it is quite easy to pass more than one tcp option - all you need is=20
AFAIR something like "u8 options[32]" array accessed like:

to set:
options[optnr >> 3] |=3D (1<<(optnr&7))

to check:

if (options[optnr >> 3] & (1<<(optnr&7)) {
   mask_it;
}

This may allow to specify a list of options to strip/mask:
--strip-tcp-options 3,4

I also suggest adding friendly names for tcp options. If you wish I have a=
=20
working code for that so I can post a incremental patch.

Best regards,


 =09=09=09=09=09Krzysztof Ol=EAdzki

---187430788-1542021634-1191086639=:29204--
