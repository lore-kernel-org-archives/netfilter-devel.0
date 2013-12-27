From: Vytas Dauksa <vytas.dauksa@smoothwall.net>
Subject: Fwd: [PATCH] add hash:ip,mark data type to ipset
Date: Fri, 27 Dec 2013 15:20:58 +0000
Message-ID: <CACUMwTkwxuXn3g5jxy07m0-=hoQtKViTu6nyT7jtQe52DcDtJg@mail.gmail.com>
References: <1383146590-4626-1-git-send-email-vytas.dauksa@smoothwall.net>
	<alpine.DEB.2.10.1311112106200.8236@blackhole.kfki.hu>
	<CACUMwTmRbK=tMMNhGe3BmhS4Fm76njtDPE=ez8TvO0HHBJ-bww@mail.gmail.com>
	<alpine.DEB.2.10.1312032006500.32285@blackhole.kfki.hu>
	<CACUMwTm3ed8eJPszf_f0iTop+vYeyGVX7_RHFc6su6z3hf_+Cg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from exprod7og103.obsmtp.com ([64.18.2.159]:38527 "HELO
	exprod7og103.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753604Ab3L0PVA convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Dec 2013 10:21:00 -0500
Received: by mail-wg0-f42.google.com with SMTP id a1so12295745wgh.5
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Dec 2013 07:20:58 -0800 (PST)
In-Reply-To: <CACUMwTm3ed8eJPszf_f0iTop+vYeyGVX7_RHFc6su6z3hf_+Cg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

thank you once again for review, few comments bellow, patches can be fo=
und:

[PATCH 0/1] add hash:ip,mark data type to ipset -
http://marc.info/?l=3Dnetfilter-devel&m=3D138728893302103&w=3D2

[PATCH 1/1] add markmask for hash:ip,mark data type -
http://marc.info/?l=3Dnetfilter-devel&m=3D138728893302104&w=3D2

On 3 December 2013 19:15, Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> w=
rote:
>
> > The intended use is similar to the ip:port type, but for protocols =
which don't use
> > a predictable port number. Instead of port number it matches a fire=
wall mark
> > determined by a layer 7 filtering program like opendpi, which will =
be called
> > by an earlier iptables rule.
>
> OK, I see.
>
> > I wasn't sure if it's best to set mark on individual entry within a=
 set or for
> > whole set with or without mask.
> > What are your views on it? For now it's set on individual entries w=
ithout mask.
>
> I think mark value and mask pair per element would be more useful and
> flexible than a mark value alone. The "mark" match uses value[/mask],=
 so
> the same should be used here too.
>

mark[/mask] has limitation that packet marks don't have precedence
like ip netmask ( with most specific networks first ), so overlapping
marks can't exist in the same set. Constantly parsing them, might
introduce performance issues.
Therefore, I implemented mark mask per set ( the same way as netmask
is implemented in hash:ip ).

A simple use case:
user is interested in the first 11 bits of mark. User specifies
markmask when creating set:
ipset create mytest hash:ip,mark markmask 0xffe00000

Thereafter, each time an entry is added to the set, it will perform
bitwise AND using markmask value before mark is stored:
ipset add mytest 1.1.1.1,0xf0345678

which results to 1.1.1.1,0xf0200000 being stored.

However, if user is interested in all 32 bits, user should either
specify markmask as 0xffffffff or leave it blank, as markmask defaults
to 0xffffffff.

I believe this is more clear and useful than markmask per entry.

> There's one thing I spotted in your patch, in both *_uadt function:
>
> +       e.mark =3D htonl(nla_get_u32(tb[IPSET_ATTR_MARK]));
>
> The value is passed in network order back and forth, so it should be =
at
> both places:
>
> +       e.mark =3D ntohl(nla_get_u32(tb[IPSET_ATTR_MARK]));
>

=46ixed

--=20
Vytas Dauksa
Junior Developer
vytas.dauksa@smoothwall.net

Smoothwall Ltd
Phone: +44 (0=AD) 8701 999500
www.smoothwall.net
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
