From: Patrick McHardy <kaber@trash.net>
Subject: Re: Avoiding multiple calls to xt_target.checkentry
Date: Thu, 05 Nov 2009 19:43:12 +0100
Message-ID: <4AF31CC0.3040405@trash.net>
References: <4A18A70F.50808@shikadi.net> <alpine.LSU.2.00.0905240933050.18758@fbirervta.pbzchgretzou.qr> <4A1DC798.1090604@shikadi.net> <4A26418C.5090707@trash.net> <4A265891.4050201@shikadi.net> <4AF2E8A5.7020409@trash.net> <alpine.LSU.2.00.0911051923510.25147@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Adam Nielsen <a.nielsen@shikadi.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42508 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758342AbZKESnI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Nov 2009 13:43:08 -0500
In-Reply-To: <alpine.LSU.2.00.0911051923510.25147@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Thursday 2009-11-05 16:00, Patrick McHardy wrote:
>> Adam Nielsen wrote in summer 2009:
>>>>> Thanks for the explanation!  So - to get it straight in my mind -=
 the
>>>>> checkentry function will be called multiple times while the trigg=
er
>>>>> exists,
>>>>> but is the destroy function also called multiple times?  Or is ch=
eckentry
>>>>> called whenever tables are created, but destroy only ever called =
once
>>>>> when the
>>>>> table is removed for the last time?
>>>> They will always be called an equal amount of times - each one
>>>> once per target instance.
>>> Great, thanks for the info (thanks Jan too!)  I'm working on a patc=
h so I'll
>>> post it when I think I've solved the issue correctly.
>> Just wondering whether there's still hope for this issue to get fixe=
d.
>>
>> I haven't added the LED extension to iptables yet, so if there's no
>> interest in fixing this, we can remove the LED target again.
>=20
> An increasing number of modules want to keep a global state.
> Currently, xt_recent and xt_RATEEST do that in the kernel; xt_quota3
> (Xt-a) also does its own management =E2=80=94 basically just a
> name=3D>personal_struct mapping =E2=80=94, and xt_LED would now need =
such state
> keeping too. It seems preferable to somehow join that together and
> funnel that into xtables.c. What do you think?
> Meanwhile, let me prep some commit.

If this can be done clean and simple, sure. I have my doubt though,
since it needs a mapping of the old rule to the new rule.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
