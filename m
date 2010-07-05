From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: xt2 table core
Date: Mon, 05 Jul 2010 11:36:52 +0200
Message-ID: <1278322612.2877.21.camel@edumazet-laptop>
References: <1277801017-30600-1-git-send-email-jengelh@medozas.de>
	 <201007020532.12596.simonl@parknet.dk>
	 <alpine.LSU.2.01.1007041440130.12356@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Simon Lodal <simonl@parknet.dk>, netfilter-devel@vger.kernel.org,
	kaber@trash.net
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34568 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914Ab0GEJg4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Jul 2010 05:36:56 -0400
Received: by fxm14 with SMTP id 14so3475099fxm.19
        for <netfilter-devel@vger.kernel.org>; Mon, 05 Jul 2010 02:36:55 -0700 (PDT)
In-Reply-To: <alpine.LSU.2.01.1007041440130.12356@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le dimanche 04 juillet 2010 =C3=A0 15:56 +0200, Jan Engelhardt a =C3=A9=
crit :
> On Friday 2010-07-02 05:32, Simon Lodal wrote:
> >>=20
> >> This patchset adds the xtables2 main proper, and incrementally
> >> changes ip6_tables to use it. There are more patches for iptables
> >> and arptables and, but to not make it larger than needed, just thi=
s
> >> much for now.
> >>=20
> >> Previously featured on http://lwn.net/Articles/345176/ .
> >
> >Nice to see some new development! Guess we all have a long wishlist =
that is=20
> >hard to implement in the current design, and this may make it easier=
=2E
> >
> >But what about performance? I think all these lists must cause a hug=
e amount=20
> >of jumps in hot path (eg. filtering packets). The packed blob format=
 is hard to=20
> >work with, but once created it is efficient. Do you have any expecta=
tions or=20
> >even numbers on the performance?
>=20
> Your suspicion was right, linked lists seem to have their impact.
>=20
> The command I used was
>=20
> 	ping6 localhost -fc 500 -i .001
>=20
> this sends 500 packets in near-flood fashion (-i0 would lead to
> packet drops).
>=20
> Xtables1 blob-style 2.6.31-rc4:
> 500 packets transmitted, 500 received, 0% packet loss, time 3532ms
> 500 packets transmitted, 500 received, 0% packet loss, time 3428ms
> 500 packets transmitted, 500 received, 0% packet loss, time 3388ms
> 500 packets transmitted, 500 received, 0% packet loss, time 3339ms
> 500 packets transmitted, 500 received, 0% packet loss, time 3219ms
>=20
> Xtables1 blob-style 2.6.34:
> 500 packets transmitted, 500 received, 0% packet loss, time 3405ms
> 500 packets transmitted, 500 received, 0% packet loss, time 3525ms
> 500 packets transmitted, 500 received, 0% packet loss, time 3426ms
> 500 packets transmitted, 500 received, 0% packet loss, time 3388ms
> 500 packets transmitted, 500 received, 0% packet loss, time 3328ms
>=20
> Xtables2 (linked lists) 2.6.35-rc1:
> 500 packets transmitted, 500 received, 0% packet loss, time 14775ms
> 500 packets transmitted, 500 received, 0% packet loss, time 14383ms
> 500 packets transmitted, 500 received, 0% packet loss, time 14381ms
> 500 packets transmitted, 500 received, 0% packet loss, time 15432ms
> 500 packets transmitted, 500 received, 0% packet loss, time 14498ms
>=20
> nftables (uses linked lists) 2.6.31-rc4:
> 500 packets transmitted, 500 received, 0% packet loss, time 16198ms
> 500 packets transmitted, 500 received, 0% packet loss, time 16128ms
> 500 packets transmitted, 500 received, 0% packet loss, time 16492ms
> 500 packets transmitted, 500 received, 0% packet loss, time 16451ms
> 500 packets transmitted, 500 received, 0% packet loss, time 16475ms
>=20
> Well I guess Xt2 isn't the total backlight :-)
>=20
> Do you have any suggestions for improvement though?
>=20

I dont understand how it is possible to spend so much time per packet,
just adding few pointers :)

Are you sure you dont hit another problem ?

Could you give us the rules you use ?


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
