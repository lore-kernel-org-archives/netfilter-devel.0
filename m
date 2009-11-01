From: Pierre Chifflier <pchifflier@edenwall.com>
Subject: Re: [PATCH 1/2] Add new input plugin UNIXSOCK
Date: Sun, 1 Nov 2009 18:01:11 +0100
Message-ID: <20091101170111.GA16662@piche.inl.fr>
References: <1257072828-11028-1-git-send-email-chifflier@inl.fr>
 <1257072828-11028-2-git-send-email-chifflier@inl.fr>
 <alpine.LSU.2.00.0911011336330.22807@obet.zrqbmnf.qr>
 <20091101130739.GC11601@piche.inl.fr>
 <alpine.LSU.2.00.0911011432160.26262@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, eleblond@inl.fr
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:46234 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752978AbZKARBP convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Nov 2009 12:01:15 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.0911011432160.26262@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Nov 01, 2009 at 02:41:21PM +0100, Jan Engelhardt wrote:
>=20
> On Sunday 2009-11-01 14:07, Pierre Chifflier wrote:
>=20
> >> >+	ip =3D (struct iphdr *) data;
> >>=20
> >> If data is not aligned, later dereferencing can fail :(
> >
> >I remember some arches (sparc, arm ?) will send a signal (SIGBUS I
> >think) in this case.
> >How can I prevent data from being unaligned ?
> >Adding some __attribute__((aligned(4)) will be enough ?
>=20
> __attribute__(aligned) only specifies the minimum requirement.
>=20
> What one would need is __attribute__((packed)), and it needs
> to be on struct iphdr - in /usr/include/... - and that is the
> problem because you cannot change it.
> And gcc does not allow saying (ignored the attribute)
>=20
>   struct iphdr __attribute__((packed)) *iph =3D data;
>=20
> So.. tough luck.

It seems gcc does not appreciate:
ulogd_inppkt_UNIXSOCK.c:352: warning: =E2=80=98packed=E2=80=99 attribut=
e ignored

I can see the problem, but I can't see any solution without memcpy'ing
the data several times :(
Generally speaking, what is the best way to deal with these kind of
Key-Kength-Value protocols and alignment ?
Since I do not not the size of the elements and that most of them are
strings, it's very unlikely the result is going to be aligned. Should I
memcpy each element before using it ? Or does a better (in terms of
performance) solution ?

Thanks,
Pierre

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
