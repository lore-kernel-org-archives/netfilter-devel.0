From: Eric Leblond <eric@inl.fr>
Subject: Re: libnetfilter_queue - remove packet from kernel buffer, and
 reinject   later
Date: Tue, 19 Jan 2010 23:54:57 +0100
Message-ID: <1263941697.4571.46.camel@ice-age>
References: <6c279bde1001191125u28fa13a4i4fd7973cf950cccc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-5dxCDQ8qA4EA/zyBX8tC"
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Mistick Levi <gmistick@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:42720 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752297Ab0ASWzH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Jan 2010 17:55:07 -0500
In-Reply-To: <6c279bde1001191125u28fa13a4i4fd7973cf950cccc@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-5dxCDQ8qA4EA/zyBX8tC
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

Hello,

Le mardi 19 janvier 2010 =E0 21:25 +0200, Mistick Levi a =E9crit :
> Hi,
> I've worked with libipq, and libnetfilter_queue, and i got to a place
> where my userspace code can't get anymore packets( with the message:
> netlink message: no buffer space available ) .
>=20
> Now what i want to do is this:
> Read a packet from the queue, copy it to my own queue/location in my
> program, and re injecting the packet later on with my verdict, after i
> finished.

This is how it works ;)

In fact, the 'no buffer space available' message is due to your program
not getting packets as fast as needed: The kernel is sending packet to a
netlink socket and the internal buffer of the socket gets filled with
the packets waiting to be read.

What you need to do is:
      * read packet as fast as you can (your callback function has to be
        fast)
      * do the intensive or delay needing work outside of the callback
        (via a thread or something)

It last option is not possible, you can increase the netlink buffer size
via the nfnl_rcvbufsiz function. "Standard" syntax is the following:
	nfnl_rcvbufsiz(nfq_nfnlh(my_nfq_handle), NFQ_NF_BUFSIZE);

BR,

>=20
> but to my best of my understanding, until i send a verdict the packet
> still takes place in the queue.
> and i've read something about using NF_STOLEN and then reinject, but i
> dont think that NF_STOLEN is a valid verdict.
>=20
> Any ideas on how i can do what it is i wish to do? ( Clear the kernel
> queue by transferring the packets to my queue ).
>=20
> Kind regards
> Levi Yechiel
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=20
Eric Leblond <eric@inl.fr>
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--=-5dxCDQ8qA4EA/zyBX8tC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Ceci est une partie de message
 =?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBLVjg8nxA7CdMWjzIRAlqQAJ98gmAhKw3kGP38im4CnuMCS6GGrgCfVicL
RDw2BkbtBTezonVBMgaxWao=
=7fbg
-----END PGP SIGNATURE-----

--=-5dxCDQ8qA4EA/zyBX8tC--

