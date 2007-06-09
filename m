From: Eric Leblond <eric@inl.fr>
Subject: Re: libipq
Date: Sat, 09 Jun 2007 20:15:13 +0200
Message-ID: <1181412913.24499.3.camel@localhost>
References: <f7de5e030706091046m2a6bbfb7m8ced3774e06b924a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-7Ez3gdCC3+vrdaKQbnuI"
Cc: netfilter-devel@lists.netfilter.org
To: Simon <simon.xhz@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <f7de5e030706091046m2a6bbfb7m8ced3774e06b924a@mail.gmail.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--=-7Ez3gdCC3+vrdaKQbnuI
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi,

Le samedi 09 juin 2007 =E0 12:46 -0500, Simon a =E9crit :
> Hi there,
>   I've been working with iptables a long time but only as a newbie.
> Now I moved up the ladder to the rank of amateur and I made myself a
> companion program to iptables that helps manage it.
>   One more thing i whish to do is to examine packets one after the
> other (only certain types of packet, not all traffic) and I understand
> I should QUEUE packets and use libipq to read those packets.

You should not use the deprecated and almost dead ipq. Use
libnetfilter_queue.

>=20
>   Now my question: is this a good place for any questions regarding
> libipq ?

Yes

>   And if it is, can you guys tell me in advance where I can
> find a more in-depth documentation that the simple man-page i could
> only find?

libnetfilter_queue or ip_queue lack documentation but you can look at
some code sample like the one I wrote for NuFW :
http://software.inl.fr/trac/trac.cgi/browser/mirror/edenwall/nufw/trunk/nuf=
w/src/nufw/packetsrv.c

BR,
--=20
Eric Leblond <eric@inl.fr>
INL

--=-7Ez3gdCC3+vrdaKQbnuI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGau4xnxA7CdMWjzIRAtieAJ0ezo1ulw6vohEox8Oc8r40D3ZaXwCfYUXI
Lm/hEVZxr2l0dv6cvWCR678=
=5Ez5
-----END PGP SIGNATURE-----

--=-7Ez3gdCC3+vrdaKQbnuI--
