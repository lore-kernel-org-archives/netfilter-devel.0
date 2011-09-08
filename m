From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH RFC] iptables-restore: new option to change the commit
 timing
Date: Thu, 08 Sep 2011 17:06:58 +0200
Message-ID: <1315494418.2456.23.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <4E68C314.3070709@dump-Storage.net>
	 <alpine.LNX.2.01.1109081652310.13219@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Hiroshi KIHIRA <hiro@dump-Storage.net>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53442 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534Ab1IHPGy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Sep 2011 11:06:54 -0400
Received: by wyh22 with SMTP id 22so724222wyh.19
        for <netfilter-devel@vger.kernel.org>; Thu, 08 Sep 2011 08:06:53 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1109081652310.13219@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le jeudi 08 septembre 2011 =C3=A0 17:00 +0200, Jan Engelhardt a =C3=A9c=
rit :
> On Thursday 2011-09-08 15:28, Hiroshi KIHIRA wrote:
> >
> >I propose to add a new command line option to iptables-restore.
>=20
> I propose on top that it should be made the default, since half
> tables are not really useful to anybody. (This has gone as far as to
> people writing that iptables-apply script, and I'd love to see it
> being replaced by something included in the C code instead.)
>=20
> >In the situation that some tables are restored, each of tables are
> >applied into the kernel space when the COMMIT statement was read fro=
m
> >the input. If there was a syntax error in rules, iptables-restore
> >will end without doing any modification to the table. However the
> >table that was already committed into kernel space does not reverted=
=2E
> >[...]
>=20
> I am in favor of that. Though, I have to add, it actually misses the
> inconsistency case {syntax is accepted, but the options are rejected
> by the kernel}.
>=20
> What would probably be most desirable is that iptables-restore keeps
> copies in memory of each table it attempted to touch,
> for the eventual case of a rollback.

Unfortunately, keeping a copy into userland memory is not enough to
guarantee a rollback is possible in kernel land.

You might be in an OOM situation preveting new (large) memory
allocations.


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
