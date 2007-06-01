From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: Re: How to pass arguments to a kernel module
Date: Fri, 01 Jun 2007 04:36:16 +0200
Message-ID: <1180665376.21871.10.camel@henriknordstrom.net>
References: <70309fc20705302111w41c08d91u6c62185d204d41ba@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-015s0sA6YQfgJS7J76+i"
Cc: netfilter-devel@lists.netfilter.org
To: Tharanga Abeyseela <tharanga.abeyseela@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <70309fc20705302111w41c08d91u6c62185d204d41ba@mail.gmail.com>
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


--=-015s0sA6YQfgJS7J76+i
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

ons 2007-05-30 klockan 21:11 -0700 skrev Tharanga Abeyseela:
> Dear all,
>=20
> I have implemented  a small firewall on linux as a kernel module (.ko)
> (using victor castros tutorial on netfilter programming) . and now i
> need to pass arguments such as source ip, dst ip, port..etc..from  a
> remote machine to my firewall module. basically .ko module should
> accept that parameters and block the specific traffic. without
> unloading the kernel module how should i insert my firewall  rules to
> kernel module.
> can someone give me a sample code for that.

You would preferably use a netlink socket

Used quite a lot by the netfilter modules, and there is a whole
framework in netfilter for netlink, nfnetlink. Might be of use for you.

http://www.netfilter.org/projects/libnfnetlink/index.html

not sure if there is any documentation on how to add new nfnetlink
subsystems other than the code.

For general information about Netlink see

http://linux-net.osdl.org/index.php/Generic_Netlink_HOWTO
http://www.linuxjournal.com/article/7356


Regards
Henrik

--=-015s0sA6YQfgJS7J76+i
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Detta =?ISO-8859-1?Q?=E4r?= en digitalt signerad
	meddelandedel

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iQCVAwUARl+GG0NPQ5Kbx8daAQJU2gP/XB3jRGMxMl/3K7kNfxROmsEgW2va0j9u
tDMfXqWvOjGTv7BlNH29pOOqAVaDSLcYxj8Kck3BvskfMxOoljjKLpY0pEPDM5mY
IvIyJuVfTNLjCtqzqXi1P3p5siy9wp4kN5rzXN6HBokiAdm74F5irBuOPzE25XZx
zw36AJOB0vQ=
=vCVQ
-----END PGP SIGNATURE-----

--=-015s0sA6YQfgJS7J76+i--
