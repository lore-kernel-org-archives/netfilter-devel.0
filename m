From: Eric Leblond <eleblond@inl.fr>
Subject: Re: libnfnetlink list of interfaces
Date: Mon, 05 Oct 2009 10:59:50 +0200
Message-ID: <1254733190.5052.62.camel@ice-age>
References: <17010436980.20091003100800@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Kuzin Andrey <kuzinandrey@yandex.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:45023 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941AbZJEJAg convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Oct 2009 05:00:36 -0400
In-Reply-To: <17010436980.20091003100800@yandex.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Le samedi 03 octobre 2009 =E0 10:08 +0400, Kuzin Andrey a =E9crit :
> I use nlif_index2name() to get interfaces list in my programm.
> After uptime 44 days and many reconnections by vtund i can't
> get tun/tap interfaces numbers.
>=20
> For example output of iftest (example in nfnetlink library):

As mentionned in its name, iftest is for testing. It is not supposed to
do the complete job.

>=20
> root@banana:/tmp/tgz/libnfnetlink-1.0.0/utils# ./iftest
> index (1) is lo (RUNNING)
> index (2) is eth0 (RUNNING)
> index (3) is eth1 (RUNNING)
=2E...
> In iftest.c we have:
>       for (i=3D0; i<64; i++) {
>             char name[IFNAMSIZ];
>             unsigned int flags;
>=20
>             if (nlif_index2name(h, i, name) =3D=3D -1)
>                   continue;
>             if (nlif_get_ifflags(h, i, &flags) =3D=3D -1)
>                   continue;
>             printf("index (%d) is %s (%s)\n", i, name,
>                   flags & IFF_RUNNING ? "RUNNING" : "NOT RUNNING");
>       }
>=20
> Only 64 interfaces numbers checked. It mean that tun ifaces have
> number greater than 64.

Yes, see previous remark.

>=20
> I think libnfnetlink need better way to get list of interfaces,
> better than stupid checking random number by nlif_index2name.

What do you mean here ?

BR,
--=20
Eric Leblond <eleblond@inl.fr>
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/
EdenWall: http://www.edenwall.com/

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
