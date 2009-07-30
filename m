From: Eric Leblond <eric@inl.fr>
Subject: Re: Modifying packets in userspace using libnetfilter_queue
Date: Thu, 30 Jul 2009 17:16:00 +0200
Message-ID: <1248966960.11586.30.camel@khasse.inl.fr>
References: <5BB67BF4A0D4544A918C2FD76487A1E13D8944D6@USNAVSXCHMBSB2.ndc.alcatel-lucent.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-7EqsurHEkzOT9q5fzi7M"
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: "Srinivasan, Suman (Suman)** CTR **"
	<suman.srinivasan@alcatel-lucent.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:54714 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952AbZG3PQJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Jul 2009 11:16:09 -0400
In-Reply-To: <5BB67BF4A0D4544A918C2FD76487A1E13D8944D6@USNAVSXCHMBSB2.ndc.alcatel-lucent.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-7EqsurHEkzOT9q5fzi7M
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

Le jeudi 30 juillet 2009 =C3=A0 09:18 -0500, Srinivasan, Suman (Suman)** CT=
R
** a =C3=A9crit :
> Hi all,
>=20
> Sorry for this elementary question, but I am new to the world of packet m=
odification. I browsed the recent netfilter-devel archives and couldn't fin=
d much on this topic.
>=20
> I am trying to modify TCP packets in userspace. I know it is inefficient =
to do it in userspace, but I just need a prototype to test for now.

For testing, the easiest way is : http://software.inl.fr/trac/wiki/nfqueue-=
bindings

You can do Proof of Concept in Python, perl ... for an example of packet
modification:
http://git.inl.fr/cgi-bin/gitweb.cgi?p=3Dnfqueue-bindings.git;a=3Dblob;f=3D=
examples/rewrite.py;h=3D4086734e4483edd009f8333a1cc4d023a365a797;hb=3DHEAD


> I couldn't find much documentation on doing this, except for the document=
ation on the following URL, the nfqnl_test.c file and some modifications on=
 some mailing lists:
> http://www.nufw.org/doc/libnetfilter_queue/
>=20
> I have gotten this far:
> 1. Have set up iptables rules to send the TCP packets I want to intercept=
 down a NFQUEUE queue.=20
> 2. Am able to use nfqnl_test.c to receive and print out packet info.=20
> 3. Used netinet/tcp.h and sample code to check TCP headers=20
> 4. Able to print out TCP payload using TCP and IP header information=20
> 5. Able to modify the TCP payload (or at least the copy)=20
> =20
> However, the modified packets are not really being transmitted! I assume =
this is because I am getting a copy of the packets or the packet data. Othe=
r than getting/setting the TCP and payload data, the rest of the code to in=
tercept the packet is still the basic nfqnl_test.c code.
>=20
> How do I actually modify the packet in userspace so that it is sent out o=
ver the network?
>=20
> Also, if I modify the TCP packets and add more data to the payload, what =
would I change? I assume that I would only have to change the following:
>=20
> - TCP payload length
> - Checksum
> - IP length (?, would I have to touch this field)
>=20
> Is there anything else that I am not thinking of?

Yes you need to recompute manually all checksum and length and send
decision with nfq_set_verdict providing pointer to modified data and
data length to the function.

>=20
> By the way, the documentation available out there is a little hard for a =
newcomer to the world of iptables/netfilter. I'm getting a little lost with=
 all the talk about libipq, libiptc, etc. Is there any documentation on the=
 history of iptables/netfilter and which libraries have been retired or are=
 still active?
>=20

To do short: ip_queue is deprecated and replaced by libnetfilter_queue.


BR,
--=20
=C3=89ric Leblond <eric@inl.fr>
EdenWall, http://www.edenwall.com/
NuFW, http://www.nufw.org

--=-7EqsurHEkzOT9q5fzi7M
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpxuS0ACgkQnxA7CdMWjzKWogCdHTsYsAhd52IiEkvyjIxpYwHj
IB4AnjnstjNcCrEqLlfmimnvMmlFeOd6
=6wOA
-----END PGP SIGNATURE-----

--=-7EqsurHEkzOT9q5fzi7M--

