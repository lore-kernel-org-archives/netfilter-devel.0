From: "Salatiel Filho" <salatiel.filho@gmail.com>
Subject: Re: iptables -> can't initialize iptables table `filter': Bad file descriptor
Date: Sun, 9 Dec 2007 11:11:32 -0300
Message-ID: <beb91d720712090611va682efcn80db6efb1efbaf0e@mail.gmail.com>
References: <beb91d720712021122w93088ccjf4544c591df3c4b5@mail.gmail.com>
	 <475578F1.8060600@trash.net>
	 <beb91d720712040805u7dd0241by2349e9b34c361a87@mail.gmail.com>
	 <47557D04.1040101@trash.net>
	 <beb91d720712040832p71981f85yd097f86614e680af@mail.gmail.com>
	 <47565BB3.9030500@trash.net>
	 <beb91d720712050339w7daeb392me3e3e3cc44bad0d@mail.gmail.com>
	 <4757C632.60503@trash.net>
	 <beb91d720712060325l22f4b609kdc481a64d36768e9@mail.gmail.com>
	 <beb91d720712090534i4df4513bk22b840d75e2ff543@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Netfilter Development Mailinglist" <netfilter-devel@vger.kernel.org>
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:8517 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbXLIOLg convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Dec 2007 09:11:36 -0500
Received: by wa-out-1112.google.com with SMTP id v27so2726142wah
        for <netfilter-devel@vger.kernel.org>; Sun, 09 Dec 2007 06:11:32 -0800 (PST)
In-Reply-To: <beb91d720712090534i4df4513bk22b840d75e2ff543@mail.gmail.com>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 12/9/07, Salatiel Filho <salatiel.filho@gmail.com> wrote:
> On 12/6/07, Salatiel Filho <salatiel.filho@gmail.com> wrote:
> > On Dec 6, 2007 6:51 AM, Patrick McHardy <kaber@trash.net> wrote:
> > > Salatiel Filho wrote:
> > > > On Dec 5, 2007 5:05 AM, Patrick McHardy <kaber@trash.net> wrote=
:
> > > >> Salatiel Filho wrote:
> > > >>
> > > >>> iptables v1.3.8: can't initialize iptables table `filter': In=
valid argument
> > > >>> Perhaps iptables or your kernel needs to be upgraded.
> > > >> Perhaps the 32/64 bit hacks that are still included in 1.3.8
> > > >> are falsely enabled. Please post a few lines from the iptables
> > > >> compilation output.
> > > >>
> > > >
> > > > Should i try 1.40 ?
> > >
> > > I don't expect it will help, but would still be worth a try.
> > >
> > Still it doesn`t work :/
> >
> > > > # make
> > > > Extensions found: IPv4:CLUSTERIP IPv4:recent IPv6:ah IPv6:esp
> > > > IPv6:frag IPv6:ipv6header IPv6:hbh IPv6:dst IPv6:rt
> > > > cc -O2 -Wall -Wunused -I"/lib/modules/2.6.12.6-arm2/build"/incl=
ude
> > > > -Iinclude/ -DIPTABLES_VERSION=3D\"1.3.8\"  -fPIC -o
> > > > extensions/libipt_ah_sh.o -c extensions/libipt_ah.c
> > >
> > > This looks OK, the 32/64 bit hacks are not enabled.
> > >
> >
> > :(
> >
> > --
> > []'s
> > Salatiel
> >
> > "O maior prazer do inteligente =E9 bancar o  idiota
> >    diante de um  idiota que banca o inteligente".
> >
>
> anything else?
>
>
>
> --
> []'s
> Salatiel
>
> "O maior prazer do inteligente =E9 bancar o  idiota
>    diante de um  idiota que banca o inteligente".
>

I forgot to mention that the kernel is crosscompiled , but iptables is
natively compiled. Can this generate this problem ?

--=20
[]'s
Salatiel

"O maior prazer do inteligente =E9 bancar o  idiota
   diante de um  idiota que banca o inteligente".
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
