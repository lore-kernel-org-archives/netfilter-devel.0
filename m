From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: socket match - add wildcard option [2/4]
Date: Sun, 25 Jul 2010 21:55:47 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1007252150110.8534@obet.zrqbmnf.qr>
References: <AANLkTi=4J96JVoM46wjtXwe1hW62injH+=9FEbexhh3K@mail.gmail.com> <alpine.LSU.2.01.1007251708460.3572@obet.zrqbmnf.qr> <AANLkTikOF2J9VR6ZwLdSxdeC7VhQZyRjbCa0V1Yqpyh6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Nepenthes Development Team <nepenthesdev@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:39371 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850Ab0GYTzt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 25 Jul 2010 15:55:49 -0400
In-Reply-To: <AANLkTikOF2J9VR6ZwLdSxdeC7VhQZyRjbCa0V1Yqpyh6@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2010-07-25 21:10, Nepenthes Development Team wrote:
>Hi,
>
>thanks for your reply.
>
>>>+static const struct option socket_opts_v1[] =3D {
>>>+ =C2=A0 =C2=A0 =C2=A0{ "transparent", 0, NULL, '1' },
>>>+ =C2=A0 =C2=A0 =C2=A0{ }
>>>+};
>>
>> Try to use the C99 version.
>
>Not sure what C99 shall mean in this context,
>> { .name =3D NULL }

{.name =3D "transparent", .has_arg =3D false, .val =3D '1'},
{NULL},

>> ' does not need to be escaped, to my knowledge.
>
>I adopted the syntax from the original manpage, which escapes ', shall
>I remove it altogether?

Yes, given no other manpage has it. (And I think ' does not need any
escaping, unlike -, but someone feel free to educate me otherwise.)

>>>+struct xt_socket_mtinfo1 {
>>>+ =C2=A0 =C2=A0 =C2=A0__u8 flags;
>>>+};
>>
>> I'm sure Eric Dumazet will remind us that u32 is a better idea.
>
>Adopted, as the kernel already uses __u8 for the socket match flags
>http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3D=
blob;f=3Dinclude/linux/netfilter/xt_socket.h;h=3D6f475b8ff34be81caa612b=
f1a947d3ad627290ab;hb=3D962400e8fd29981a7b166e463dd143b6ac6a3e76#l8
>shall I change it to u32?

Pending Eric's comment, I would suggest to include a bump to
revision 2 of the existing kernel parts for revision 1 -
since there is no libxt_socket.c code for revision 1.

>Attached is current version for iptables, I remembered being able to
>invert a match would be great, therefore I added the invertible
>implicit --exists option.

if (invert)
   info->invert |=3D foo;

or alternatively

xtables_param_act(...NO_INVERT...) /* check existing code */

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
