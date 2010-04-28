From: Eric Leblond <eric@inl.fr>
Subject: Re: nfnetlink_queue: which userspace library?
Date: Wed, 28 Apr 2010 09:59:43 +0200
Message-ID: <1272441583.29439.10.camel@khasse.inl.fr>
References: <4BD72377.8070400@meta-dynamic.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-TWgJz8IqMr/qgzYZ+aB6"
Cc: netfilter <netfilter-devel@vger.kernel.org>
To: David F <netfilter@meta-dynamic.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:51538 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864Ab0D1H46 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 Apr 2010 03:56:58 -0400
In-Reply-To: <4BD72377.8070400@meta-dynamic.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-TWgJz8IqMr/qgzYZ+aB6
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

Le mardi 27 avril 2010 =C3=A0 13:48 -0400, David F a =C3=A9crit :
> Hi,
>=20
> I want to do some packet manipulation that seems beyond the scope of=20
> what can be done directly by existing iptables modules (ipv4 options=20
> mangling), so I'd like to queue the packets in question for userspace,=20
> for easy experimentation and development.
>=20
> After a fair bit of googling, it seems to me that the most common and=20
> well-documented way to do this is via the QUEUE target and libipq.  But=20
> numerous references indicate that QUEUE and libipq are deprecated

Yes, they really are.

>  and=20
> NFQUEUE/nfnetlink_queue is the preferred method.  Setting up the=20
> iptables looks straightforward, but then how to receive/return them on=20
> the userspace side?  Aside from libipq, it seems that there are 3=20
> alternatives:
>=20
> * libnetfilter_queue http://www.netfilter.org/projects/libnetfilter_queue=
/
> * libnl and its "queue" group of functions=20
> http://www.infradead.org/~tgr/libnl/doc/group__queue.html=20
> <http://www.infradead.org/%7Etgr/libnl/doc/group__queue.html>
> * Code your own using netlink sockets directly, and=20
> <linux/netfilter/nfnetlink_queue.h>.


libnetfilter_queue is the official and most used library.=20

>=20
> None of these seem to have great documentation or example programs,=20

http://www.nufw.org/doc/libnetfilter_queue/ is the most accurate
libnetfilter_queue documentation.
An example program is available in the source :
http://git.netfilter.org/cgi-bin/gitweb.cgi?p=3Dlibnetfilter_queue.git;a=3D=
blob;f=3Dutils/nfqnl_test.c

Real life example can be found in :
      * suricata:
        http://www.openinfosecfoundation.org/index.php/download-suricata
      * NuFW:
        http://www.nufw.org/projects/nufw/repository/revisions/master/entry=
/src/nufw/packetsrv.c

You can even use libnetfilter_queue with high-level langage:
http://www.nufw.org/projects/nfqueue-bindings

> although I have found a few resources.  So I'm wondering if anyone can=20
> give me a little direction as to what are the differences, which would=20
> be the best option, and why there seems to be a duplication between=20
> libnl and libnetfilter.

There's a idea of merging libnetfilter_queue inside libnl but the move
was not really succesfull (when talking about adoption by oter project).

ipqueue is deprecated and sucks by most aspect (not portable, only one
queue for example)

> Is libipq truly deprecated?=20

Yes ! For some years !

BR,
--=20
=C3=89ric Leblond <eric@inl.fr>
EdenWall, http://www.edenwall.com/
NuFW, http://www.nufw.org

--=-TWgJz8IqMr/qgzYZ+aB6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkvX6uwACgkQnxA7CdMWjzJ3iACgiALjCDjZgYVhOB1F1tGvmrd2
/LEAnRvITQVNrpkUG+f4aVpAcXbW0ASY
=f4Qx
-----END PGP SIGNATURE-----

--=-TWgJz8IqMr/qgzYZ+aB6--

