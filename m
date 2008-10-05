From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iptables not working with monolithic 2.6.26.5 kernel on ARM
Date: Sun, 5 Oct 2008 10:01:37 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810050955560.21891@fbirervta.pbzchgretzou.qr>
References: <18661.41641.113458.932029@martins.ozlabs.org> <48E6166F.40607@trash.net> <alpine.LNX.1.10.0810031006260.3893@fbirervta.pbzchgretzou.qr> <18662.61266.69230.675687@martins.ozlabs.org> <alpine.LNX.1.10.0810040724110.19954@fbirervta.pbzchgretzou.qr>
 <48E8C027.6040209@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Martin Schwenke <martin@meltin.net>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:33559 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691AbYJEOBj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Oct 2008 10:01:39 -0400
In-Reply-To: <48E8C027.6040209@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2008-10-05 09:24, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> You can change the XT_ALIGN macro in the
>> kernel/include/linux/netfilter/x_tables.h and
>> iptables/include/linux/netfilter/x_tables.h to read
>>=20
>>  #ifndef roundup
>>  #define roundup(x, y) ((((x) + ((y) - 1)) / (y)) * (y))
>>  #endif
>>  #define XT_ALIGN(s) roundup(s, sizeof(uint64_t))
>>=20
>> and try again. There might be more alignment issues hiding, so
>> don't expect it to fix it all in a magic whizz.
>
> An idea to avoid these problems in the future would be to change
> the kernel so it accepts stricter alignment than what we currently
> use and after a grace period (maybe 1-2 years) change XT_ALIGN in
> userspace so it starts using u64 or simply 8 byte alignment
> everywhere.

I'd rather be interested in what architectures actually have
alignof(uint64_t)=C2=A0=3D=3D=C2=A04, besides the native ARM gcc that's=
 used here.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
