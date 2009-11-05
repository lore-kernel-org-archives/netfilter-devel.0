From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Avoiding multiple calls to xt_target.checkentry
Date: Thu, 5 Nov 2009 19:40:46 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0911051923510.25147@obet.zrqbmnf.qr>
References: <4A18A70F.50808@shikadi.net> <alpine.LSU.2.00.0905240933050.18758@fbirervta.pbzchgretzou.qr> <4A1DC798.1090604@shikadi.net> <4A26418C.5090707@trash.net> <4A265891.4050201@shikadi.net> <4AF2E8A5.7020409@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Adam Nielsen <a.nielsen@shikadi.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:57317 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758288AbZKESkl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Nov 2009 13:40:41 -0500
In-Reply-To: <4AF2E8A5.7020409@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2009-11-05 16:00, Patrick McHardy wrote:
>Adam Nielsen wrote in summer 2009:
>>>> Thanks for the explanation!  So - to get it straight in my mind - =
the
>>>> checkentry function will be called multiple times while the trigge=
r
>>>> exists,
>>>> but is the destroy function also called multiple times?  Or is che=
ckentry
>>>> called whenever tables are created, but destroy only ever called o=
nce
>>>> when the
>>>> table is removed for the last time?
>>> They will always be called an equal amount of times - each one
>>> once per target instance.
>>=20
>> Great, thanks for the info (thanks Jan too!)  I'm working on a patch=
 so I'll
>> post it when I think I've solved the issue correctly.
>
>Just wondering whether there's still hope for this issue to get fixed.
>
>I haven't added the LED extension to iptables yet, so if there's no
>interest in fixing this, we can remove the LED target again.

An increasing number of modules want to keep a global state.
Currently, xt_recent and xt_RATEEST do that in the kernel; xt_quota3
(Xt-a) also does its own management=C2=A0=E2=80=94 basically just a
name=3D>personal_struct mapping=C2=A0=E2=80=94, and xt_LED would now ne=
ed such state
keeping too. It seems preferable to somehow join that together and
funnel that into xtables.c. What do you think?
Meanwhile, let me prep some commit.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
